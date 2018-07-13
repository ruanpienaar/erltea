-module(erltea).
-export([
    trace/1
    ,do_trace/4
]).

trace([Node, Cookie, Time, MessageCount | Traces]) when length(Traces) >= 1 ->
    io:format("Traces ~p\n\n", [Traces]),
    NodeAtom = list_to_atom(Node),
    CookieAtom = list_to_atom(Cookie),
    true = erlang:set_cookie(NodeAtom, CookieAtom),
    case net_kernel:connect(NodeAtom) of
        true ->
            _Pid = proc_lib:spawn_link(
                ?MODULE,
                do_trace,
                [NodeAtom, list_to_integer(Time)*1000, list_to_integer(MessageCount), Traces]
            ),
            receive
                Any ->
                    io:format("Received:~p\n", [Any]),
                    io:format("stopping trace node ~p\n", [node()]),
                    erlang:halt()
            end;
        false ->
            io:format("[HALT] cannot connect to ~p\n", [NodeAtom])
    end;
trace(Args) ->
    io:format("Incorrect Args ~p\n\n", [Args]),
    % usage().
    ok.

do_trace(Node, Time, MessageCount, Traces) ->
    Opts = [{target, Node},
             %% I chose not to use {print_file, FN}, it had some problems,
             %% in the way i started this erltea node. i just use stdout,
             %% and the binary file
            % {file, trace_file(Node)}, TODO, add another shell script,
            % that creates binary files, and finish formatter function...
            {print_msec, true},
            {time, Time},
            {msgs, MessageCount}
          ],
    % leave these comments for later...
    % case redbug:start(Trc,Opts) of
    %     redbug_already_started ->
    %         redbug_already_started;
    %     {oops, {C, R}} ->
    %         {oops, {C, R}};
    %     {Procs, Funcs} ->
    %         {Procs, Funcs}
    % end,
    redbug:start(Traces, Opts),
    is_redbug_alive().

is_redbug_alive() ->
    case whereis(redbug) of
        undefined ->
            erlang:exit(self(), redbug_down);
        _ ->
            timer:sleep(50),
            is_redbug_alive()
    end.

% trace_file(Node) ->
%     atom_to_list(Node) ++ "_traces".

% usage() ->
%     io:format("\nerltea.sh TIME MSG_COUNT TRACES\n"),
%     io:format("./erltea.sh 60 1000 \"ets:lookup\""),
%     io:format("\nMultiple trace patterns allowed:\n"),
%     io:format("./erltea.sh 60 1000 \"application:which_applications\0\" \"ets:lookup\"").