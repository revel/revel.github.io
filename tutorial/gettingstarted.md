---
title: Getting Started
layout: tutorial
---


## Install Go

Before you can use Revel, first you need to [install Go](http://golang.org/doc/install).

- See the official [Go installation guide](https://golang.org/doc/install).
    - [Ubuntu](https://github.com/golang/go/wiki/Ubuntu)
    - [Windows](https://golang.org/doc/install#windows)
    
### Set up your GOPATH

If you have not created a GOPATH as part of the installation, do so now. The `GOPATH`
is a directory where all of your Go code will live. Here is one way of setting it up:

1. Make a directory: `mkdir ~/gocode`
2. Tell Go to use that as your GOPATH: `export GOPATH=~/gocode`
3. Save your GOPATH so that it will apply to all future shell sessions: `echo export GOPATH=$GOPATH >> ~/.bash_profile`

Note that depending on your shell, you may need to adjust (3) to write the export into a different configuration file (e.g. *~/.bashrc*, *~/.zshrc, etc.).

Now your Go installation is complete.

## Install git and hg

Git and Mercurial are required to allow `go get` to clone various dependencies.

* [Installing Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)
* [Installing Mercurial](https://www.mercurial-scm.org/downloads)

## Get the Revel framework

To get the Revel framework, run

	go get github.com/revel/revel

This command does a couple of things:

* Go uses git to clone the repository into `$GOPATH/src/github.com/revel/revel/`
* Go transitively finds all of the dependencies and runs `go get` on them as well.

### Get and Build the Revel command line tool

The [`revel`](tool.html) command line tool is used 
to [`build`](tool.html#build), [`run`](tool.html#run), and [`package`](tool.html#package) Revel applications.

Use `go get` to install:

	go get github.com/revel/cmd/revel

Ensure the `$GOPATH/bin` directory is in your PATH so that you can reference the command from anywhere.

	export PATH="$PATH:$GOPATH/bin"

Verify that it works:
	
```
$ revel
Usage:
  revel [OPTIONS] <command>

Application Options:
  -v, --debug                If set the logger is set to verbose
      --historic-run-mode    If set the runmode is passed a string not json
      --historic-build-mode  If set the code is scanned using the original parsers, not the go.1.11+
  -X, --build-flags=         These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands
      --gomod-flags=         These flags will execute go mod commands for each flag, this happens during the build process

Available commands:
  build
  clean
  new
  package
  run
  test
  version
```

<a href="createapp.html" class="btn btn-sm btn-success" role="button">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a> [Create a new Revel application.](createapp.html)
