-module(parse_account).

-export([decode_account/1]).

-record(
    bank_transaction,
	{
	  primary_num,
	  process_code,
	  amount,
	  date_time,
	  trace_num,
	  trans_time,
	  trans_date,
	  capt_date,
	  insti_id,
	  ref_no
	}
).

decode_account(Account) ->
    Binary_account = list_to_binary(Account),
    do_decode_account(Binary_account).
	
	
do_decode_account(<<Pri_num:16/binary,Pro_code:6/binary,Amount:12/binary,Date_time:10/binary,
    Trace_num:6/binary,Time:6/binary,Trans_date:4/binary,Capt_date:4/binary,Insti_id:6/binary,Insti_id:6/binary,Ref_no:12/binary>>) ->
	%%note: It's better to add some feild checks (when ... -> )in the input of account details, eg: to check whether the date/time is a valid format.
    #bank_transaction{primary_num = binary_to_list(Pri_num), 
	                  process_code = binary_to_list(Pro_code), 
					  amount = binary_to_list(Amount), 
					  date_time = binary_to_list(Date_time), 
					  trace_num = binary_to_list(Trace_num),
					  trans_time = binary_to_list(Time), 
					  trans_date = binary_to_list(Trans_date), 
					  capt_date = binary_to_list(Capt_date), 
					  insti_id = binary_to_list(Insti_id), 
					  ref_no = binary_to_list(Ref_no)};
do_decode_account(<<Pri_num:16/binary,Pro_code:6/binary,Amount:12/binary,Date_time:10/binary,
    Trace_num:6/binary,Time:6/binary,Trans_date:4/binary, Insti_id:6/binary,Insti_id:6/binary,Ref_no:12/binary>>) ->
    #bank_transaction{primary_num = binary_to_list(Pri_num), 
	                  process_code = binary_to_list(Pro_code), 
					  amount = binary_to_list(Amount), 
					  date_time = binary_to_list(Date_time), 
					  trace_num = binary_to_list(Trace_num),
					  trans_time = binary_to_list(Time), 
					  trans_date = binary_to_list(Trans_date),
					  insti_id = binary_to_list(Insti_id), 
					  ref_no = binary_to_list(Ref_no)};
do_decode_account(_Others) ->
    {error, "input format error!"}.
					  
					  
