{application, rpc_application,
[{description, "RPC server for accounts operations"},
{vsn, "0.1.0"},
{modules, [tr_app,
tr_sup,
tr_server]},
{registered, [tr_sup]},
{applications, [kernel, stdlib]},
{mod, {tr_app, []}}
]}.