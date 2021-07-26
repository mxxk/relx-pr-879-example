-module(example_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    maybe_print_os_args(),
    io:format("init:get_arguments() -> ~p~n", [init:get_arguments()]),
    io:format("init:get_plain_arguments() -> ~p~n", [init:get_plain_arguments()]),
    example_sup:start_link().

stop(_State) ->
    ok.

maybe_print_os_args() ->
    case file:read_file(["/proc/", os:getpid(), "/cmdline"]) of
        {ok, Contents} ->
            Len = byte_size(Contents),
            <<NullSeparatedCmdLine:(Len - 1)/binary, 0>> = Contents,
            io:format("Process args:~n"),
            lists:foreach(
                fun(Arg) -> io:format("    ~p~n", [binary_to_list(Arg)]) end,
                string:split(NullSeparatedCmdLine, <<0>>, all)
            );
        _ ->
            % Not supported on this operating system..
            ok
    end.
