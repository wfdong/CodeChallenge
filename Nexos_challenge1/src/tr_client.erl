-module(tr_client).
-include("include/myRecords.hrl").
-export([query_all/0,query_single/1,query_multiple/1,add_account/4,delete_account/2]).


query_all() ->
    tr_server:query_all().
query_single(DocID) ->
    tr_server:query_accounts([DocID]).
query_multiple(DocIDs) ->
    tr_server:query_accounts(DocIDs).
add_account(Fname1, Lname1, Account1_balance, Account1_id) ->
    Account = #account_records{fname1=Fname1,lname1=Lname1,account1_balance=Account1_balance,account1_id=Account1_id},
    tr_server:add_account(Account).
delete_account(DocID, Rev_Id) ->
    tr_server:delete_account(DocID, Rev_Id).
	
	
