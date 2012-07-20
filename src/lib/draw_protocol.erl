%%%-------------------------------------------------------------------
%%% @author chan sisowath <mihawk@github>
%%% @copyright (C) 2012, mihawk
%%% @doc
%%%
%%%        draw_protocol is an example to show how to
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

-record(class,{prof, students}).

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
  {ok, #class{prof=undefined, students=dict:new()}}.

%%--------------------------------------------------------------------
%% to handle a connection to your service
%%--------------------------------------------------------------------
handle_call({join_service, _A,B,C}, _From, State) ->
    #class{prof=V, students=S} = State,
    NewState=case V of 
		 undefined -> 
		     #class{prof=B, students=S};
		 _ ->
		     #class{prof=V, students=dict:store(B,C,S)}
	     end,
    {reply, ok, NewState};
%%--------------------------------------------------------------------


%%--------------------------------------------------------------------
%% to handle a close connection to you service
%%--------------------------------------------------------------------
handle_call({terminate_service, A, _B}, _From, State) ->
    #class{prof=V, students=S} = State,
    {reply, ok, #class{prof=V, students=dict:erase(A,S)}};
%%--------------------------------------------------------------------

handle_call(_Request, _From, State) ->
    {reply, ignored_message, State}.

%%--------------------------------------------------------------------
%% to handle incoming message to your service
%% here is simple copy to all
%%--------------------------------------------------------------------
handle_cast({incoming_msg, _ServiceName, WebSocketId,_SessionId, Msg}, State) ->
    #class{prof=Chef, students=Students} = State,
    case WebSocketId =:= Chef of
	false -> 
	    false;
	true ->
	    Fun = fun(X) when is_pid(X)-> X ! {text, Msg} end,
	    All = dict:fetch_keys(Students),
	    [Fun(E) || E <- All]
    end,
    {noreply, State};
%%--------------------------------------------------------------------

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% Internal functions
