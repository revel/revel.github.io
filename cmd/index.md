---
title: revel cmd
layout: cmd
---

## > revel 

```bash
revel
```

- If above in errors, then visit [Install](/install/index.html)



<a name="version"></a>

#### `revel version`

- Displays the Revel Framework and Go version.
{% highlight sh %}
    revel version
{% endhighlight %}


<a name="new"></a>

#### `revel new [import_path] [skeleton]`

Creates a few files to get a new Revel application running quickly.

- Copies files from the [`skeleton/`](https://github.com/revel/cmd/tree/develop/revel/skeleton) directory
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
    revel package github.com/revel/revel/examples/chat prod
    > Your archive is ready: chat.tar.gz
{% endhighlight %}

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="clean"></a>

#### `revel clean [import_path]`

- Clean the Revel web application named by the given import path
- Deletes the `app/tmp` directory.
- Deletes the `app/routes` directory.
{% highlight sh %}
    revel clean github.com/revel/examples/booking
{% endhighlight %}

<a name="test"></a>

#### `revel test [import_path] [run_mode] [suite.method]`

- Run all tests for the Revel app named by the given import path.
{% highlight sh %}
    revel test github.com/revel/examples/booking dev
{% endhighlight %}



