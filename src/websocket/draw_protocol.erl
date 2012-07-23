%%%-------------------------------------------------------------------
%%% @author chan sisowath <mihawk@github>
%%% @copyright (C) 2012, mihawk
%%% @doc
%%%
%%%        draw_protocol is a demo to show how to
%%%        implement websocket service for realtime update
%%%        with the ChicagoBoss MVC Web Framwork,
%%%        draw_protocol is the backend server for
%%%        open whiteboard application:
%%%         
%%%             https://developer.mozilla.org/fr/demosdetail/open-whiteboard
%%%
%%%        powered by ChicagoBoss  http://www.chicagoboss.org
%%% @end
%%% Created : 18 Jul 2012 by mihawk <chan.sisowath@mgmail.com>
%%%-------------------------------------------------------------------
-module(draw_protocol).
-behaviour(boss_service_handler).

-record(state,{users}).

%% API
-export([init/0, 
	handle_incoming/5, 
	handle_join/4, 
	handle_close/4, 
	handle_info/2,
	terminate/2]).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init() ->
  io:format("~p (~p) starting...~n", [?MODULE, self()]),
  %timer:send_interval(1000, ping),
  {ok, #state{users=dict:new()}}.

%%--------------------------------------------------------------------
%% to handle a connection to your service
%%--------------------------------------------------------------------
handle_join(_ServiceName, WebSocketId, SessionId, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:store(WebSocketId,SessionId,Users)}}.
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle a close connection to you service
%%--------------------------------------------------------------------
handle_close(ServiceName, WebSocketId, _SessionId, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:erase(WebSocketId,Users)}}.
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle incoming message to your service
%% here is simple copy to all
%%--------------------------------------------------------------------
handle_incoming(_ServiceName, WebSocketId,_SessionId, Message, State) ->
    #state{users=Users} = State,
	    Fun = fun(X) when is_pid(X)-> X ! {text, Message} end,
	    All = dict:fetch_keys(Users),
	    [Fun(E) || E <- All, E /= WebSocketId],
    %% end,
    {noreply, State}.
%%--------------------------------------------------------------------


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
   %call boss_service:unregister(?SERVER),
  ok.

%% Internal functions
