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
-behaviour(gen_server).

-define(SERVER, ?MODULE).

-record(state,{users}).

%% API
-export([start_link/0, incoming/4, join/3, close/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% Client API
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
incoming(ServiceName, WebSocketId, SessionId, Msg) ->
  gen_server:cast(?SERVER, {incoming_msg, ServiceName, WebSocketId, SessionId, Msg}).
join(ServiceName, WebSocketId, SessionId) ->
  gen_server:call(?SERVER, {join_service, ServiceName, WebSocketId, SessionId }).
close(WebSocketId,SessionId) ->
  gen_server:call(?SERVER, {terminate_service, WebSocketId, SessionId}).

%% gen_server callbacks
%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting...~n", [?MODULE, self()]),
  {ok, #state{users=dict:new()}}.
  %% {ok, #class{prof=undefined, students=dict:new()}}.

%%--------------------------------------------------------------------
%% to handle a connection to your service
%%--------------------------------------------------------------------
handle_call({join_service, _ServiceName,WebSocketId, SessionId}, _From, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:store(WebSocketId,SessionId,Users)}};
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle a close connection to you service
%%--------------------------------------------------------------------
handle_call({terminate_service, WebSocketId, _SessionId}, _From, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:erase(WebSocketId,Users)}};

%%--------------------------------------------------------------------

handle_call(_Request, _From, State) ->
    {reply, ignored_message, State}.

%%--------------------------------------------------------------------
%% to handle incoming message to your service
%% here is simple copy to all
%%--------------------------------------------------------------------
handle_cast({incoming_msg, _ServiceName, WebSocketId,_SessionId, Msg}, State) ->
    #state{users=Users} = State,
	    Fun = fun(X) when is_pid(X)-> X ! {text, Msg} end,
	    All = dict:fetch_keys(Users),
	    [Fun(E) || E <- All, E /= WebSocketId],
    %% end,
    {noreply, State};
%%--------------------------------------------------------------------

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
   %call boss_service:unregister(?SERVER),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% Internal functions
