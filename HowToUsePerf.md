Everything as release, except +`-g3` and -`-s`.

```sh
perf record --call-graph dwarf -F 99 -b ./${program} [${args}...] >/dev/null
#                        ^^^^^    ^^ ^^                           ^^^^^^^^^^^
#                        |        |  |                            |= This is optional, but useful
#                        |        |  |= Enable taken branch stack sampling, may require
#                        |        |  |=     changing `/proc/sys/kernel/perf_event_paranoid`
#                        |        |= Could be higher, but don't be multiples of 100
#                        |= `dwarf` produces most detail, and may cause `perf.data` to "explode"
```

Show report:
```sh
perf report [--no-children] [-G]
#            ^^^^^^^^^^^^^   ^^
#            |               |= Show caller-based call graph (instead of callee-based)
#            |= Add this flag to remove call chain (display self-time instead of accumulate-time)
```

Annotate source code (try annotate source code via `perf report` instead!):
```sh
perf annotate --tui -s ${symbol-name}
#             ^^^^^
#             |= Recommended if you have a tty; otherwise, try `--gtk` if you have GTK,
#                                                           or the plain old `--stdio`/`--stdio2`
```