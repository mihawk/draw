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
-module(draw_draw_protocol_websocket, [Req, SessionId]).
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
handle_join(_ServiceName, WebSocketPid, State) ->
    #state{users=Users} = State,
    {noreply, #state{users=dict:store(WebSocketPid, SessionId ,Users)}}.
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle a close connection to you service
%%--------------------------------------------------------------------
handle_close(Reason, ServiceName, WebSocketId, State) ->
    #state{users=Users} = State,
    io:format("Service ~p, WsPid ~p close for Reason ~p~n",
              [ServiceName, WebSocketId, Reason]),
    {noreply, #state{users=dict:erase(WebSocketId,Users)}}.
%%--------------------------------------------------------------------

handle_broadcast(Message, State) ->
  io:format("Broadcast Message ~p~n",[Message]),
  {noreply, State}.

%%--------------------------------------------------------------------
%% to handle incoming message to your service
%% here is simple copy to all
%%--------------------------------------------------------------------
handle_incoming(_ServiceName, WebSocketId, Message, State) ->
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

handle_info(state, State) ->
    #state{users=Users} = State,
	All = dict:fetch_keys(Users),
	error_logger:info_msg("state:~p~n", [All]),
  {noreply, State};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
   %call boss_service:unregister(?SERVER),
  ok.

%% Internal functions
