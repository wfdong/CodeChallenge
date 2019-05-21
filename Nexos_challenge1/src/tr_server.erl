%%%-------------------------------------------------------------------
%%% @author  <Roger Wang>
%%% @copyright (C) 2019,
%%% @doc
%%%
%%% @end
%%% Created :  19 May 2019 by  <Roger Wang>
%%%-------------------------------------------------------------------
-module(tr_server).

-behaviour(gen_server).

%% API
-export([start/0, stop/0, 
         query_all/0, query_accounts/1,
         add_account/1, add_accounts/1,
         delete_account/2,delete_accounts/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, 
         handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

-include("include/myRecords.hrl").
%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start() -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop() -> 
    inets:stop(),
    gen_server:call(?MODULE, stop).
query_all() ->
    gen_server:call(?MODULE, {query_all, ?DB_Name}).
query_accounts(DocIDs) ->
    gen_server:call(?MODULE, {query_accounts, DocIDs}).

add_account(#account_records{} = Account) ->
    gen_server:call(?MODULE, {add_account, Account}).
add_accounts(Accounts) ->
    gen_server:call(?MODULE, {add_accounts, Accounts}).

delete_account(DocID, Rev_Id) ->
    gen_server:call(?MODULE, {delete_account, {DocID, Rev_Id}}).
delete_accounts(Accounts) ->
    gen_server:call(?MODULE, {delete_account, Accounts}).
%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) -> 
    inets:start(),
	httpc:set_options([{proxy, {{"www.myproxy.com", 8000},["localhost"]}}]),
	RequestUrl = ?CouchDB_Node ++ ?DB_Name,
	httpc:request(delete,{RequestUrl, []}, [], []),
	Result = httpc:request(get,{RequestUrl, []}, [], []),
	%io:format("~s",[Result]),
	{ok, init_couch_db(Result)}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} 
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({query_all, _DocID}, _From, State) ->
    RequestUrl = ?CouchDB_Node ++ ?DB_Name ++ "/_all_docs?include_docs=true",
	AccountResult = httpc:request(get, {RequestUrl, []}, [], []),
	{reply, AccountResult, State};
handle_call({query_accounts, [_H | _T] = DocIDs}, _From, State) ->
    AccountResult = do_query_accounts(DocIDs, []),
	{reply, AccountResult, State};
handle_call({add_account, Account}, _From, State) ->
    AccountResult = do_add_account(Account),
	{reply, AccountResult, State};
handle_call({add_accounts, [_H | _T] = Accounts}, _From, State)->
    AccountResult = do_add_accounts(Accounts, []),
    {reply, AccountResult, State};
handle_call({delete_account, {_DocID, _Rev_Id} = Account}, _From, State) ->
    AccountResult = do_delete_account(Account),
	{reply, AccountResult, State};
handle_call({delete_accounts, [_H | _T] = Accounts}, _From, State) ->
    AccountResult = do_delete_accounts(Accounts, []),
    {reply, AccountResult, State};
handle_call(_Others, _From, State) ->
    AccountResult = "no matched methods, input error!",
	{reply, AccountResult, State}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------	
handle_cast(_Msg, State) -> {noreply, State}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) -> {noreply, State}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) -> ok.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
init_couch_db({ok,{{"HTTP/1.1",404,"Object Not Found"},_Param1,_Param2}}) ->
    RequestUrl = ?CouchDB_Node ++ ?DB_Name,
    httpc:request(put,{RequestUrl, []}, [], []),
    {ok, #state{}};
init_couch_db(_Other) ->
    {ok, #state{}}.

do_query_accounts([], Acc) ->
    Acc;
do_query_accounts([DocID|T], Acc) when is_list(DocID)->
    RequestUrl = ?CouchDB_Node ++ ?DB_Name ++ "/" ++ DocID,
    AccountResult = httpc:request(get, {RequestUrl, []}, [], []),
    do_query_accounts(T,[AccountResult | Acc]);
%%Bad format, skip temporarily
do_query_accounts([_DocID|T], Acc) ->
    do_query_accounts(T, Acc);
%%Bad inputs, return empty list temporarily
do_query_accounts(_Other, _Acc) ->
    [].

do_add_accounts([], Acc) ->
    Acc;
do_add_accounts([H|T], Acc) when is_record(H, account_records)->
    AccountResult = do_add_account(H),
    do_add_accounts(T,[AccountResult | Acc]);
%%Bad format, skip temporarily
do_add_accounts([_Account_records|T], Acc) ->
    do_add_accounts(T, Acc);
%%Bad inputs, return empty list temporarily
do_add_accounts(_Other, _Acc) ->
    [].

do_add_account(#account_records{fname1 = Fname1, 
                                  lname1 = Lname1,
                                  account1_balance = Account1_balance,
                                  account1_id = Account1_id}) ->
    Body = "{\"fname1\":\"" ++ Fname1 ++ "\",\"lname1\":\"" ++ Lname1 ++ 
               "\",\"account1_balance\":\"" ++ Account1_balance ++ 
               "\",\"account1_id.\":\"" ++ Account1_id ++ "\"}",
    %io:format("~s",[Body]),
    RequestUrl = ?CouchDB_Node ++ ?DB_Name,
    httpc:request(post, {RequestUrl,[],"application/json",Body},[],[]).

do_delete_accounts([], Acc) ->
    Acc;
do_delete_accounts([{_DocID,_Rev_Id} = Account|T], Acc) ->
    AccountResult = do_delete_account(Account),
    do_delete_accounts(T,[AccountResult | Acc]);
%%Bad format, skip temporarily
do_delete_accounts([_DocID|T], Acc) ->
    do_delete_accounts(T, Acc);
%%Bad inputs, return empty list temporarily
do_delete_accounts(_Other, _Acc) ->
    [].

do_delete_account({DocID,Rev_Id}) ->
    RequestUrl = ?CouchDB_Node ++ ?DB_Name ++ "/" ++ DocID++"?rev="++Rev_Id,
    httpc:request(delete, {RequestUrl, []}, [], []).
