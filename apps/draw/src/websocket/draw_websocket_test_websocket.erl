%%%-------------------------------------------------------------------
%%% @author chan sisowath <mihawk@github>
%%% @copyright (C) 2012, mihawk
%%% @doc
%%%
%%%
%%%        powered by ChicagoBoss  http://www.chicagoboss.org
%%% @end
%%% Created : 18 Jul 2012 by mihawk <chan.sisowath@mgmail.com>
%%%-------------------------------------------------------------------
-module(draw_websocket_test_websocket, [Req, SessionId]).
-behaviour(boss_service_handler).

-record(state,{users}).

%% API
-export([init/0, 
	handle_incoming/4, 
	handle_join/3,
        handle_broadcast/2,
	handle_close/4, 
	handle_info/2,
	terminate/2]).

init() ->
  io:format("~p (~p) starting...~n", [?MODULE, self()]),
  %timer:send_interval(1000, ping),
  {ok, #state{users=dict:new()}}.

handle_join(ServiceName, WebSocketId, State) ->
    error_logger:info_msg("~p ~p ~p", [ServiceName, WebSocketId, SessionId]),
    #state{users=Users} = State,
    {noreply, #state{users=dict:store(WebSocketId,SessionId,Users)}}.


handle_close(Reason, ServiceName, WebSocketId, State) ->
    #state{users=Users} = State,
    io:format("ServiceName ~p, WebSocketId ~p, SessiondId ~p, close for Reason ~p~n",
              [ServiceName, WebSocketId, SessionId, Reason]),
    {noreply, #state{users=dict:erase(WebSocketId, Users)}}.

handle_broadcast(Message, State) ->
  io:format("Broadcast Message ~p~n",[Message]),
  {noreply, State}.

handle_incoming(_ServiceName, WebSocketId, Message, State) ->
     WebSocketId ! {text, << "That's what she said! ", Message/binary >>},
    {noreply, State}.

handle_info(state, State) ->
    #state{users=Users} = State,
	error_logger:info_msg("state:~p~n", [Users]),
	{noreply, State};

handle_info(ping, State) ->
	error_logger:info_msg("pong:~p~n", [now()]),
	{noreply, State};

handle_info(tic_tac, State) ->
    #state{users=Users} = State,
	    Fun = fun(X) when is_pid(X)-> X ! {text, "tic tac"} end,
	    All = dict:fetch_keys(Users),
	    [Fun(E) || E <- All],
  {noreply, State};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

