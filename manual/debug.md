---
title: Debugging
layout: manual
---

By default, the [`revel run`](tool.html) command without a [`run_mode`](appconf.html#runmodes) defaults to `dev`.

## Hot Reload

As part of the development cycle, Revel can be configured to 'watch' for local file changes, and recompile as necessary.

- See the [`watchers`](appconf.html#watchers) in [`conf/appconf`](appconf.html)

## Testing Module

Revel comes with a test suite, see the [Testing Module](testing.html)


## Debug using gdb

Go applications can be debugged using the [GNU Debugger (GDB)](http://www.gnu.org/software/gdb/).

- [Debugging with GDB](http://sourceware.org/gdb/current/onlinedocs/gdb/)
- See Go's [official GDB guide](http://golang.org/doc/gdb)
- This excellent go example at [lincon loop blog post](https://lincolnloop.com/blog/introduction-go-debugging-gdb/)
- A [StackOverflow - Revel debugging HOWTO](http://stackoverflow.com/questions/23952886/revel-debugging-how-to) question 

TODO - put example here



