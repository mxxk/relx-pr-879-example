-module(example_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    io:format("init:get_arguments() -> ~p~n", [init:get_arguments()]),
    io:format("init:get_plain_arguments() -> ~p~n", [init:get_plain_arguments()]),
    example_sup:start_link().

stop(_State) ->
    ok.
