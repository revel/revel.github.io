---
title: Debugging
layout: manual
---

By default, the [`revel run`](tool.html) command without a 
[`run_mode`](appconf.html#runmodes) defaults to **dev**.

## Hot Reload

As part of the development cycle, Revel can be configured to 'watch' for 
local file changes, and recompile as necessary.

- See the [`watchers`](appconf.html#watchers) in [`conf/appconf`](appconf.html)

## Testing Module

Revel comes with a test suite, see the [Testing Module](/modules/testing.html)


## Debug using gdb

Go applications can be debugged using the [GNU Debugger (GDB)](http://www.gnu.org/software/gdb/).

- [Debugging with GDB](http://sourceware.org/gdb/current/onlinedocs/gdb/)
- See Go's [official GDB guide](http://golang.org/doc/gdb)
- This excellent go example at [lincon loop blog post](https://lincolnloop.com/blog/introduction-go-debugging-gdb/)
- A [StackOverflow - Revel debugging HOWTO](http://stackoverflow.com/questions/23952886/revel-debugging-how-to) question 

### Intellij debugging (goland)
1. Create your project, for this example i will be using canonical "revel new github.com/myaccount/my-app"
2. "revel run github.com/myaccount/my-app" to generate tmp/main.go - this file is needed by intellij
3. Shutdown the running server
4. Create project in intellij from existing sources
5. Create run configuration and in "Program arguments" add "-importPath github.com\myaccount\my-app -srcPath <your gopath>\src -runMode dev"
6. Point "File" to `<your gopath>\src\github.com\myaccount\my-app\app\tmp\main.go`
7. In "before launch" add "Run external tool". There:
   Program: `<your gopath>\bin\revel.exe`
   Paramerets: build github.com/myaccount/my-app


