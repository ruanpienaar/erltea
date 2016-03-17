-module(erltea).
-export([
    trace/0
    ,trace/1
    %,printer/1
]).

%% Why are you getting TEA when you asked for COFFEE ?
%% Stop pulling your hair out, use tracing :)

trace() ->
    usage().

%% here i expect people to pass in the redbug TRC spec.

trace(Args) when length(Args) > 1 ->
    [Node, Cookie|Trcs] = Args,
    erlang:set_cookie(list_to_atom(Node), list_to_atom(Cookie)),
    true = net_kernel:connect(list_to_atom(Node)),
    % File = trace_file(Node),
    % {ok, FPID} = file:open(File, [write, binary]),
    % true = erlang:register(
    %     erltea_tracer_printer,
    %     spawn(?MODULE, printer, [FPID])
    % ),
    _Pid = do_trace(Trcs, [], list_to_atom(Node));
trace(_Args) ->
    usage().

do_trace(Trc, Opts1, Node) ->
    File = trace_file(atom_to_list(Node)),
    io:format("File : ~p\n", [File]),
    Opts = [{target, Node},
            %% I had some crashes with print_file:
%             =ERROR REPORT==== 17-Mar-2016::11:55:20 ===
% Error in process <0.41.0> on node 'trace_node_test2@rpmbp' with exit value: {terminated,[{io,format,[<0.39.0>,"~s~n",["\n% 11:55:20 <5039.38.0>({erlang,apply,2})\n% ets:i()"]],[]},{redbug,'-mk_outer/1-fun-3-',6,[{file,"src/redbug.erl"},{line,397}]},{redbug,'-wrap_print_fun/1-fun-0-',3,[{file,"src/redbug.erl"},{line...
            % {print_file, File},
            {file, "traces/" ++ File},
            % {print_fun,
            %     fun(T) ->
            %         erltea_tracer_printer ! T
            %     end},
            {time, 50000},
            {msgs, 10000},
            {blocking, true}
          ] ++ Opts1,
    case redbug:start(Trc,Opts) of
        redbug_already_started ->
            redbug_already_started;
        {oops, {C, R}} ->
            {oops, {C, R}};
        {Procs, Funcs} ->
            {Procs, Funcs}
    end.

trace_file(Node) ->
    Node ++ "_traces".

% printer(FPID) ->
%     receive
%         Any ->
%             ok = file:write(FPID, list_to_binary(io_lib:format("~p\n",[Any]))),
%             printer(FPID)
%     end.

usage() ->
    io:format("\nuse Double Quotes.\n"),
    io:format("./erltea.sh \"application:which_applications\0\" \"ets:lookup\"").
