usage:

1. install CouchDB and erlang OTP laocally;

2. in this src/ directory:
   compile:
   erlc -o ebin/ src/*.erl
   
3. cd into the ebin/
run :
(1) open a shell in ebin/, and use command "erl" to enter the erlang shell
(2) use command : tr_server:start(). to start the server;
(3) run specific cases:
all the commands below:
tr_client:query_all().
tr_client:query_single("5426aac6a3f48cadfdf383ac6900948a").
tr_client:query_multiple(["5426aac6a3f48cadfdf383ac6900948a","5426aac6a3f48cadfdf383ac6900a2da"]).
tr_client:add_account("Roger","Wn","234871","80000000000AD").
tr_client:delete_account("5426aac6a3f48cadfdf383ac6900a2da","1-9dd0f1bf2cf8319e02786ecb06a7cad1").


<1> add a account:
tr_client:add_account("Roger","Wn","234871","80000000000AD").

{ok,{{"HTTP/1.1",201,"Created"},
     [{"cache-control","must-revalidate"},
      {"date","Sun, 19 May 2019 10:18:47 GMT"},
      {"etag","\"1-0c4f068015e38d9b1a45dc4643d70f7b\""},
      {"location",
       "http://localhost:5986/accounts_db/5426aac6a3f48cadfdf383ac6900948a"},
      {"server","CouchDB/2.3.1 (Erlang OTP/19)"},
      {"content-length","95"},
      {"content-type","application/json"}],
     "{\"ok\":true,\"id\":\"5426aac6a3f48cadfdf383ac6900948a\",\"rev\":\"1-0c4f068015e38d9b1a45dc4643d70f7b\"}\n"}}
   
tr_client:add_account("Lily","Cha","934871","90000000000DE").

{ok,{{"HTTP/1.1",201,"Created"},
     [{"cache-control","must-revalidate"},
      {"date","Sun, 19 May 2019 10:19:45 GMT"},
      {"etag","\"1-9dd0f1bf2cf8319e02786ecb06a7cad1\""},
      {"location",
       "http://localhost:5986/accounts_db/5426aac6a3f48cadfdf383ac6900a2da"},
      {"server","CouchDB/2.3.1 (Erlang OTP/19)"},
      {"content-length","95"},
      {"content-type","application/json"}],
     "{\"ok\":true,\"id\":\"5426aac6a3f48cadfdf383ac6900a2da\",\"rev\":\"1-9dd0f1bf2cf8319e02786ecb06a7cad1\"}\n"}}  
	 
<2>  query all accounts
tr_client:query_all().

<3> query a single account:
tr_client:query_single("5426aac6a3f48cadfdf383ac6900948a").

[{ok,{{"HTTP/1.1",200,"OK"},
      [{"cache-control","must-revalidate"},
       {"date","Sun, 19 May 2019 10:23:46 GMT"},
       {"etag","\"1-0c4f068015e38d9b1a45dc4643d70f7b\""},
       {"server","CouchDB/2.3.1 (Erlang OTP/19)"},
       {"content-length","177"},
       {"content-type","application/json"}],
      "{\"_id\":\"5426aac6a3f48cadfdf383ac6900948a\",\"_rev\":\"1-0c4f068015e38d9b1a45dc4643d70f7b\",\"fname1\":\"Roger\",\"lname1\":\"Wn\",\"account1_balance\":\"234871\",\"account1_id.\":\"80000000000AD\"}\n"}}]
	  
<4> query multiple accounts:
tr_client:query_multiple(["5426aac6a3f48cadfdf383ac6900948a","5426aac6a3f48cadfdf383ac6900a2da"]).

[{ok,{{"HTTP/1.1",404,"Object Not Found"},
      [{"cache-control","must-revalidate"},
       {"date","Sun, 19 May 2019 10:24:13 GMT"},
       {"server","CouchDB/2.3.1 (Erlang OTP/19)"},
       {"content-length","41"},
       {"content-type","application/json"}],
      "{\"error\":\"not_found\",\"reason\":\"deleted\"}\n"}},
 {ok,{{"HTTP/1.1",200,"OK"},
      [{"cache-control","must-revalidate"},
       {"date","Sun, 19 May 2019 10:24:13 GMT"},
       {"etag","\"1-0c4f068015e38d9b1a45dc4643d70f7b\""},
       {"server","CouchDB/2.3.1 (Erlang OTP/19)"},
       {"content-length","177"},
       {"content-type","application/json"}],
      "{\"_id\":\"5426aac6a3f48cadfdf383ac6900948a\",\"_rev\":\"1-0c4f068015e38d9b1a45dc4643d70f7b\",\"fname1\":\"Roger\",\"lname1\":\"Wn\",\"account1_balance\":\"234871\",\"account1_id.\":\"80000000000AD\"}\n"}}]
	  
<5> to delete an account:
tr_client:delete_account("5426aac6a3f48cadfdf383ac6900a2da","1-9dd0f1bf2cf8319e02786ecb06a7cad1").

{ok,{{"HTTP/1.1",200,"OK"},
     [{"cache-control","must-revalidate"},
      {"date","Sun, 19 May 2019 10:22:58 GMT"},
      {"etag","\"2-2946161b4b98480e37260eb62569fe65\""},
      {"server","CouchDB/2.3.1 (Erlang OTP/19)"},
      {"content-length","95"},
      {"content-type","application/json"}],
     "{\"ok\":true,\"id\":\"5426aac6a3f48cadfdf383ac6900a2da\",\"rev\":\"2-2946161b4b98480e37260eb62569fe65\"}\n"}}