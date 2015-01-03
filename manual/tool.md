---
title: Command-line Tool
layout: manual
---

## Build and Run

- You must build the `revel` command line tool in order to use Revel:
- The code is in a seperate repository, and not included with the framework

	$ go get github.com/revel/cmd/revel

Now run it:

	$ bin/revel
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

Please refer to the tool's built-in help functionality for the latest information on the
individual commands.

<div class="alert alert-info">If not specified, <code>run_mode</code> defaults to <b>dev</b></div>

## Quick Ref



#### `revel new [import_path] [skeleton]`

Creates a few files to get a new Revel application running quickly. 
- Copies files from the [`revel/skeleton`](https://github.com/revel/revel/tree/master/skeleton) directory
- Skeleton is an optional argument, provided as an alternate skeleton path

    revel new bitbucket.org/mycorp/my-app
    
#### `revel run [import_path] [run_mode] [port]`

    // run in dev mode
    revel new bitbucket.org/mycorp/my-app
    
    // run in prod mode on port 9999
    revel new bitbucket.org/mycorp/my-app prod 9999
    
#### `revel build [import_path] [target_path]`

Build the Revel web application named by the given import path. This allows it to be deployed and run on a machine that lacks a Go installation.

    revel build github.org/mememe/mega-app /path/to/deploy/mega-app
    
<div class="alert alert-danger">WARNING: The target path will be completely deleted, if it already exists!</div>


    
#### `revel clean [import_path]`

Clean the Revel web application named by the given import path, removes the `app/tmp` directory.

    revel clean github.com/revel/samples/booking 

#### `revel test [import_path] [run_mode] [suite.method]`

Run all tests for the Revel app named by the given import path.

    revel test github.com/revel/samples/booking dev
    

    