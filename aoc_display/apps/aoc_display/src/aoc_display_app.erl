%%%-------------------------------------------------------------------
%% @doc aoc_display public API
%% @end
%%%-------------------------------------------------------------------

-module(aoc_display_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_',[
        {"/", cowboy_static, {priv_file, aoc_display, "index.html"}},
        {"/styles/[...]", cowboy_static, {priv_dir, aoc_display, "styles"}},
        {"/scripts/[...]", cowboy_static, {priv_dir, aoc_display, "scripts"}}
    ]}]),
    persistent_term:put(aoc_routes, Dispatch),
    cowboy:start_clear(aoc_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => {persistent_term, aoc_routes}}}
    ),
    aoc_display_sup:start_link().

stop(_State) ->
    ok = cowboy:stop_listener(aoc_http_listener).

%% internal functions
