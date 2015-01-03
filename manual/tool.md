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

## Examples

#### `revel new`

Create a new application

    revel new bitbucket.org/mycorp/my-app
    
#### `revel run`

