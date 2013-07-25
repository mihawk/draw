%%%-------------------------------------------------------------------
%%% @author My Name <my_address@someplace.com>
%%% @copyright (C) 2013, My Company
%%% @doc
%%%
%%% {@module} implements the websocket service for realtime update
%%% with the ChicagoBoss MVC Web Framwork.
%%%
%%% This is a template for the ChicagoBoss Websocket support.  You
%%% can copy, rename, and modify this template in order to implement
%%% your Websocket service.
%%%         
%%% Powered by ChicagoBoss  [http://www.chicagoboss.org].
%%%
%%% You can use the following to generate docs from this module:
%%% ```
%%%     edoc:files(["mymodule.erl"], [{pretty_printer, erl_pp}])
%%% '''
%%%
%%% Here is a sample of JavaScript/jQuery code that you might use
%%% for the client: ```
%%%
%%%
%%% ----------------------- JavaScript -------------------------------
%%% <script src="/static/welcome/jquery.js" type="text/javascript"></script>
%%% 
%%% <script type="text/javascript">
%%% 
%%% $(document).ready(function() {
%%% 
%%%     // Create a WebSocket object.
%%%     wsc = new WebSocket(
%%%         "ws://localhost:8081/websocket/myapp_protocol",
%%%         "myapp_protocol");
%%% 
%%%     // Send message to server.
%%%     $("#websocket1").click(function(event) {
%%%         var value = $("#search2").val();
%%%         if (value == "") {
%%%             alert("Must enter tag search string.");
%%%             return false;
%%%         }
%%%         obj1 = [value, value];
%%%         alert('sending - obj1: ' + obj1);
%%%         wsc.send(JSON.stringify(obj1));
%%%     })
%%% 
%%%     // Receive message from server.
%%%     wsc.onmessage = function(event) {
%%%         var data = event.data;
%%%         alert("(onmessage) 1. event: " + event + "  data: " + event.data);
%%%         var content = JSON.parse(data);
%%%         alert('(onmessage) 2. content: ' + content);
%%%     }
%%% 
%%% });
%%%
%%% </script>
%%% ------------------- End JavaScript -------------------------------
%%% '''
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(draw_test_websocket).
-behaviour(boss_service_handler).

-record(state,{property1, property2}).

%% API
-export([
    init/0, 
	handle_incoming/5, 
	handle_join/4, 
	handle_close/4, 
	handle_info/2,
	terminate/2
    ]).

%%--------------------------------------------------------------------
-spec init() -> {ok, NewState::#state{}}.
%% @doc
%% Initiatialize the server.
%% Usually, this means creating and returning the record "state".
%% @end
%%--------------------------------------------------------------------
init() ->
    NewState = #state{},
    error_logger:info_msg("(init) ~p~n", [NewState]),
    {ok, NewState}.

%%--------------------------------------------------------------------
-spec handle_join(
        ServiceURL::string(),
        WebSocket::pid(),
        SessionId::string(),
        State::#state{}) -> 
    {reply, Reply, NewState::#state{}} |
    {reply, Reply, NewState::#state{}, Timeout} |
    {noreply, NewState::#state{}} |
    {noreply, NewState::#state{}, Timeout} |
    {stop, Reason, Reply, NewState::#state{}} |
    {stop, Reason, NewState::#state{}}.
%% @doc
%% Handle a client joining this service.
%% @end
%%--------------------------------------------------------------------
handle_join(ServiceName, WebSocketId, SessionId, State) ->
    error_logger:info_msg("(handle_join) ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, State]),
    {reply, ok, State}.

%%--------------------------------------------------------------------
-spec handle_close(
        ServiceURL::string(),
        WebSocket::pid(),
        SessionId::string(),
        State::#state{}) -> 
    {reply, Reply, NewState::#state{}} |
    {reply, Reply, NewState::#state{}, Timeout} |
    {noreply, NewState::#state{}} |
    {noreply, NewState::#state{}, Timeout} |
    {stop, Reason, Reply, NewState::#state{}} |
    {stop, Reason, NewState::#state{}}.
%% @doc
%% Handle a client leaving this service.
%% @end
%%--------------------------------------------------------------------
handle_close(ServiceName, WebSocketId, SessionId, State) ->
    error_logger:info_msg("(handle_close) ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, State]),
    {reply, ok, State}.

%%--------------------------------------------------------------------
-spec handle_incoming(
        ServiceURL::string(),
        WebSocket::pid(),
        SessionId::string(),
        Message::string(),
        State::#state{}) ->
    {noreply, NewState::#state{}} |
    {noreply, NewState::#state{}, Timeout::integer()} |
    {stop, Reason::string(), NewState::#state{}}.
%% @doc
%% Handle an incoming message to this service.
%% Often, but not always, this means sending a response back to
%% the client with something like this:
%% ```
%%     WebSocketId ! MyContent
%% '''
%% Consider using `mochijson:encode/1' (which is built in to ChicagoBoss)
%% to format complex data message content.
%% @end
%%--------------------------------------------------------------------
handle_incoming(ServiceName, WebSocketId, SessionId, Message, State) ->
    error_logger:info_msg("(handle_incoming) ~p / ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, Message, State]),
    {noreply, State}.

%%--------------------------------------------------------------------
-spec handle_info(
        Info::string(),
        State::#state{}) ->
    {noreply, NewState::#state{}} |
    {noreply, NewState::#state{}, Timeout::integer()} |
    {stop, Reason::string(), NewState::#state{}}.
%% @doc
%% Handle an informational message sent to the underlying gen_server process.
%% @end
%%--------------------------------------------------------------------
handle_info(ping, State) ->
    error_logger:info_msg("(handle_info,ping) State: ~p~n", [State]),
    {noreply, State};
handle_info(state, State) ->
    error_logger:info_msg("(handle_info,state) State:~p~n", [State]),
    {noreply, State};
handle_info(Info, State) ->
    error_logger:info_msg("(handle_info,Info) State:~p / ~p~n", [Info, State]),
    {noreply, State}.

%%--------------------------------------------------------------------
-spec terminate(Reason::string(), State::#state{}) -> ok.
%% @doc
%% Perform any cleanup before shutting down the service.
%% @end
%%--------------------------------------------------------------------
terminate(Reason, State) ->
    error_logger:info_msg("(terminate) ~p / ~p~n", [Reason, State]),
    %call boss_service:unregister(?SERVER),
    ok.

%%--------------------------------------------------------------------
%% Internal functions
%%--------------------------------------------------------------------
