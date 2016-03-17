-module(erltea).
-export([
    trace/0
    ,trace/1
    ,do_trace/3
]).

trace() ->
    usage().
trace(Args) when length(Args) > 1 ->
    % application:start(lager),
    [Node, Cookie|Trcs] = Args,
    NodeAtom=list_to_atom(Node),
    erlang:set_cookie(NodeAtom, list_to_atom(Cookie)),
    true = net_kernel:connect(NodeAtom),
    _Pid = proc_lib:spawn_link(
        ?MODULE,
        do_trace,
        [Trcs, [], NodeAtom]
    ),
    receive
        Any ->
            io:format("Received:~p\n", [Any]),
            io:format("stopping trace node ~p\n", [node()]),
            erlang:halt()
    end;
trace(_Args) ->
    usage().

do_trace(Trc, Opts1, Node) ->
    Opts = [{target, Node},
             %% I chose not to use {print_file, FN}, it had some problems,
             %% in the way i started this erltea node. i just use stdout,
             %% and the binary file
            % {file, trace_file(Node)}, TODO, add another shell script,
            % that creates binary files, and finish formatter function...
            {print_msec, true},
            {time, 10000},
            {msgs, 10000}
          ] ++ Opts1,
    case redbug:start(Trc,Opts) of
        redbug_already_started ->
            redbug_already_started;
        {oops, {C, R}} ->
            {oops, {C, R}};
        {Procs, Funcs} ->
            {Procs, Funcs}
    end,
    is_redbug_alive().

is_redbug_alive() ->
    case whereis(redbug) of
        undefined ->
            erlang:exit(self(), redbug_down);
        _ ->
            timer:sleep(100),
            is_redbug_alive()
    end.


% trace_file(Node) ->
%     atom_to_list(Node) ++ "_traces".

usage() ->
    io:format("\nuse Double Quotes.\n"),
    io:format("./erltea.sh \"application:which_applications\0\" \"ets:lookup\"").