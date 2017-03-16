---
title: Install & Setup
layout: install
---



## prerequisite

- Its outside the scope of this quide on your `go` setup, required are a:
 - go install
 - git and hg install
 - GOPATH env set
 - Some tips on the [Basic Setup](/install/setup.html) page
 


## Install Revel Framework

To get the Revel framework and all its dependancies run cmd below which:

* Go uses git to clone the repository into `$GOPATH/src/github.com/revel/revel/`
* Go transitively finds all of the dependencies and runs `go get` on them as well.
* The `-v` flag is option that shows all the dependancies being installed

```bash
    # the -v shown whats being installed and can be ommitted
	go get -v github.com/revel/revel
```


### Install the revel cmd

The [`revel`](tool.html) command line tool is used 
to [`build`](tool.html#build), [`run`](tool.html#run), and [`package`](tool.html#package) Revel applications.

## go get 

```bash
go get github.com/revel/cmd/revel
```

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


<a href="createapp.html" class="btn btn-sm btn-success" role="button">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a> [Create a new Revel application.](createapp.html)
