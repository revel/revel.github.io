---
title: revel cmd
layout: manual
---

## Install

To install, run the command below

{% highlight sh %}
	$ go get -u github.com/revel/cmd/revel
{% endhighlight  %}

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> Gotcha. The command is in the subdirectory '/revel' ie <code>revel/cmd/revel</code> and not <code>revel/cmd</code></div>

- The `revel` command line tool is required to use the Revel framework
- It is NOT included with the main framework and is in a  [seperate repos](https://github.com/revel/cmd)

<a class="btn btn-success btn-sm" href="https://github.com/revel/cmd/tree/master/revel" role="button"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Browse Source</a>





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
		version     displays the Revel Framework and Go version

	Use "revel help [command]" for more information.



## Quick Ref


 - Please refer to the tool's built-in help (`revel -h`) for the latest information on the individual commands.

<div class="alert alert-success"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> If not specified, the <a href="appconf.html#runmodes"><code>run_mode</code></a> on all commands defaults to <b>dev</b></div>


<a name="new"></a>

#### `revel new [import_path] [skeleton]`

Creates a few files to get a new Revel application running quickly.

- Copies files from the [`revel/skeleton`](https://github.com/revel/revel/tree/master/skeleton) directory
- Under multi `GOPATH` scenario, Revel detects the current working directory with `GOPATH` and generates the project
- Skeleton is an optional argument, provided as an alternate skeleton path
{% highlight sh %}
revel new bitbucket.org/myorg/my-app
{% endhighlight %}
<a name="run"></a>

#### `revel run [import_path] [run_mode] [port]`
{% highlight sh %}
// run in dev mode
revel run github.com/mycorp/mega-app

// run in prod mode on port 9999
revel run github.com/mycorp/mega-app prod 9999
{% endhighlight %}   
<a name="build"></a>

#### `revel build [import_path] [target_path] [run_mode]`

- Build the Revel web application named by the given import path.
- This allows it to be deployed and run on a machine that lacks a Go installation.

{% highlight sh %}
    revel build github.org/mememe/mega-app /path/to/deploy/mega-app prod
{% endhighlight %}   

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="package"></a>

#### `revel package [import_path] [run_mode]`

- Build the Revel web application named by the given import path.
- This allows it to be deployed and run on a machine that lacks a Go installation.

{% highlight sh %}
    revel package github.com/revel/revel/samples/chat prod
    > Your archive is ready: chat.tar.gz
{% endhighlight %}

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="clean"></a>

#### `revel clean [import_path]`

- Clean the Revel web application named by the given import path
- Deletes the `app/tmp` directory.
- Deletes the `app/routes` directory.
{% highlight sh %}
    revel clean github.com/revel/samples/booking
{% endhighlight %}

<a name="test"></a>

#### `revel test [import_path] [run_mode] [suite.method]`

- Run all tests for the Revel app named by the given import path.
{% highlight sh %}
    revel test github.com/revel/samples/booking dev
{% endhighlight %}

#### `revel version`

- Displays the Revel Framework and Go version.
{% highlight sh %}
    revel version
{% endhighlight %}

