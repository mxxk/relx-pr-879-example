# Example app for [erlware/relx#879](https://github.com/erlware/relx/pull/879)

## Setup

1. Compile/bootstrap two separate builds of `rebar3`:
    - Baseline version, using `relx` from `master`,
    - Fixed version, using `relx` from the pull request branch.
2. Checkout this example project.

## Running the example

### Baseline version

Using the baseline version of `rebar3`, build a release for both profiles:

- `rebar3 release`
- `rebar3 as no_system_libs release`

The `no_system_libs` profile crashes immediately:

```
$ ./_build/no_system_libs/rel/example/bin/example -noshell -s init stop -- '1 2' 3
{"init terminating in do_boot",'cannot expand $SYSTEM_LIB_DIR in bootfile'}
init terminating in do_boot (cannot expand $SYSTEM_LIB_DIR in bootfile)

Crash dump is being written to: erl_crash.dump...done
```

The default profile runs, but incorrectly splits the first plain argument `'1 2'`:

```
$ ./_build/default/rel/example/bin/example -noshell -s init stop -- '1 2' 3
Process args:
    "./_build/default/rel/example/bin/example"
    "-K"
    "true"
    "-A30"
    "--"
    "-root"
    "/app/_build/default/rel/example"
    "-progname"
    "erl"
    "--"
    "-home"
    "/root"
    "--"
    "-config"
    "/app/_build/default/rel/example/releases/0.1.0/sys.config"
    "-sname"
    "example"
    "-setcookie"
    "example_cookie"
    "--"
    "-boot_var"
    "ERTS_LIB_DIR"
    "/usr/local/lib/erlang/erts-12.0.3/../lib"
    "-boot"
    "/app/_build/default/rel/example/releases/0.1.0/start"
    "-noshell"
    "-s"
    "init"
    "stop"
    "--"
    "1"
    "2"
    "3"
    "--"
init:get_arguments() -> [{root,["/app/_build/default/rel/example"]},
                         {progname,["erl"]},
                         {home,["/root"]},
                         {config,["/app/_build/default/rel/example/releases/0.1.0/sys.config"]},
                         {sname,["example"]},
                         {setcookie,["example_cookie"]},
                         {boot_var,["ERTS_LIB_DIR",
                                    "/usr/local/lib/erlang/erts-12.0.3/../lib"]},
                         {boot,["/app/_build/default/rel/example/releases/0.1.0/start"]},
                         {noshell,[]}]
init:get_plain_arguments() -> ["1","2","3"]
```

### Fixed version

Using the fixed version of `rebar3`, build a release for both profiles:

- `rebar3 release`
- `rebar3 as no_system_libs release`

Observe that both profiles run and properly handle their arguments:

```
$ ./_build/no_system_libs/rel/example/bin/example -noshell -s init stop -- '1 2' 3
Process args:
    "./_build/no_system_libs/rel/example/bin/example"
    "-K"
    "true"
    "-A30"
    "--"
    "-root"
    "/app/_build/no_system_libs/rel/example"
    "-progname"
    "erl"
    "--"
    "-home"
    "/root"
    "--"
    "-config"
    "/app/_build/no_system_libs/rel/example/releases/0.1.0/sys.config"
    "-sname"
    "example"
    "-setcookie"
    "example_cookie"
    "--"
    "-boot_var"
    "SYSTEM_LIB_DIR"
    "/usr/local/lib/erlang/lib"
    "-boot"
    "/app/_build/no_system_libs/rel/example/releases/0.1.0/start"
    "-noshell"
    "-s"
    "init"
    "stop"
    "--"
    "1 2"
    "3"
    "--"
init:get_arguments() -> [{root,["/app/_build/no_system_libs/rel/example"]},
                         {progname,["erl"]},
                         {home,["/root"]},
                         {config,["/app/_build/no_system_libs/rel/example/releases/0.1.0/sys.config"]},
                         {sname,["example"]},
                         {setcookie,["example_cookie"]},
                         {boot_var,["SYSTEM_LIB_DIR",
                                    "/usr/local/lib/erlang/lib"]},
                         {boot,["/app/_build/no_system_libs/rel/example/releases/0.1.0/start"]},
                         {noshell,[]}]
init:get_plain_arguments() -> ["1 2","3"]

$ ./_build/default/rel/example/bin/example -noshell -s init stop -- '1 2' 3
Process args:
    "./_build/default/rel/example/bin/example"
    "-K"
    "true"
    "-A30"
    "--"
    "-root"
    "/app/_build/default/rel/example"
    "-progname"
    "erl"
    "--"
    "-home"
    "/root"
    "--"
    "-config"
    "/app/_build/default/rel/example/releases/0.1.0/sys.config"
    "-sname"
    "example"
    "-setcookie"
    "example_cookie"
    "--"
    "-boot_var"
    "SYSTEM_LIB_DIR"
    "/usr/local/lib/erlang/lib"
    "-boot"
    "/app/_build/default/rel/example/releases/0.1.0/start"
    "-noshell"
    "-s"
    "init"
    "stop"
    "--"
    "1 2"
    "3"
    "--"
init:get_arguments() -> [{root,["/app/_build/default/rel/example"]},
                         {progname,["erl"]},
                         {home,["/root"]},
                         {config,["/app/_build/default/rel/example/releases/0.1.0/sys.config"]},
                         {sname,["example"]},
                         {setcookie,["example_cookie"]},
                         {boot_var,["SYSTEM_LIB_DIR",
                                    "/usr/local/lib/erlang/lib"]},
                         {boot,["/app/_build/default/rel/example/releases/0.1.0/start"]},
                         {noshell,[]}]
init:get_plain_arguments() -> ["1 2","3"]

```
