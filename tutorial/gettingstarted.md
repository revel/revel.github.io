---
title: Getting Started
layout: tutorial
---


## Install Go

Before you can use Revel, first need to [install Go](http://golang.org/doc/install).

- See official [Install Go](https://golang.org/doc/install) at [https://golang.org](https://golang.org)
    - [Ubuntu](https://github.com/golang/go/wiki/Ubuntu)
    - [Windows](https://golang.org/doc/install#windows)

### Set up your GOPATH

If you did not create a GOPATH as part of installation, do so now.  The `GOPATH`
is a directory tree where all of your Go code will live.  Here are the steps to do that:

1. Make a directory: `mkdir ~/gocode`
2. Tell Go to use that as your GOPATH: `export GOPATH=~/gocode`
3. Save your GOPATH so that it will apply to all future shell sessions: `echo export GOPATH=$GOPATH >> ~/.bash_profile`

Now your Go installation is complete.

## Install git and hg

Git and Mercurial are required to allow `go get` to clone various dependencies.

* [Installing Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)
* [Installing Mercurial](http://mercurial.selenic.com/wiki/Download)

## Get the Revel framework

To get the Revel framework, run

	go get github.com/revel/revel

This command does a couple things:

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

	$ revel help
	~
	~ revel! http://revel.github.io
	~
	usage: revel command [arguments]

	The commands are:

	    new         create a skeleton Revel application
	    run         run a Revel application
	    build       build a Revel application (e.g. for deployment)
	    package     package a Revel application (e.g. for deployment)
	    clean       clean a Revel application's temp files
	    test        run all tests from the command-line

	Use "revel help [command]" for more information.


<a href="createapp.html" class="btn btn-sm btn-success" role="button">Next &gt;&gt;</a> [Create a new Revel application.](createapp.html)
