---
title: Install & Setup
layout: install
---



## prerequisite

It is outside the scope of this quide on the [Basic Setup](/install/setup.html), but required:

 - go install
 - git and hg install
 - GOPATH env set
 


## Install Revel Framework

To get the Revel framework and all its dependancies run the cmd below which:

* Go uses git to clone the repository into `$GOPATH/src/github.com/revel/cmd/revel/`
* Go transitively finds all of the dependencies and runs `go get` on them as well.
* The `-v` flag is option that shows all the dependancies being installed
* To update your existing installation of revel add a `-u` flag

```bash
# the -v shown whats being installed and can be ommitted
go get -v github.com/revel/cmd/revel
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


<a href="createapp.html" class="btn btn-sm btn-success" 
  role="button">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a> [Create a new Revel application.](/cmd/index.html)
