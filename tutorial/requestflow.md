---
title: The Request Flow
layout: tutorial
---

In the [previous page](createapp.html) we created a new Revel application
called **myapp**. On this page we look at how Revel handles the HTTP request
to `http://localhost:9000/` resulting in the welcome message.

## Routes

The first thing that Revel does is check the `conf/routes` file (see [routing](/manual/routing.html)):

	GET     /     App.Index

This tells Revel to invoke the **`Index`** method of the **`App`**
[controller](/manual/controllers.html) when it receives a http **`GET`** request to **`/`**.

## Controller Methods 

Let's follow this call to the code, in **app/controllers/app.go**:
```go
package controllers

import "github.com/revel/revel"

type App struct {
    *revel.Controller
}

func (c App) Index() revel.Result {
    return c.Render()
}
```

All [controllers](/manual/controllers.html) must be a `struct` that embeds a [`*revel.Controller`](https://godoc.org/github.com/revel/revel#Controller)
in the first slot. Any method on a controller that is
exported and returns a [`revel.Result`](/manual/results.html) may be used as 
part of an **Action**, in the above example **App.Index** is the **Action**.

The Revel controller provides many useful methods for generating [Results](/manual/results.html). In
this example, it calls [`Render()`](https://godoc.org/github.com/revel/revel#Controller.Render),
which tells Revel to find and render a [template](/manual/templates.html) as the response with http `200 OK`.

## Templates

[Templates](/manual/templates.html) are  in the **app/views** directory. When an explicit
template name is not specified, Revel looks for a template matching the controller/method.
In this case, Revel finds the **app/views/App/Index.html** file, and
renders it using the [Template engine](/manual/template-engine).

{% capture ex %}{% raw %}
{{set . "title" "Home"}}
{{template "header.html" .}}

<header class="jumbotron" style="background-color:#A9F16C">
  <div class="container">
    <div class="row">
      <h1>It works!</h1>
      <p></p>
    </div>
  </div>
</header>

<div class="container">
    <div class="row">
    <div class="span6">
        {{template "flash.html" .}}
    </div>
    </div>
</div>

{{template "footer.html" .}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

Beyond the functions provided by the Go templates package, Revel adds
[a few helpful ones](/manual/templates.html#functions) also.

The template above : -

1. Adds a new **title** variable to the render context with [set](/manual/templates.html#set).
2. Includes the **header.html** template, which uses the **title** variable.
3. Displays a welcome message.
4. Includes the **flash.html** template, which shows any [flashed](/manual/sessionflash.html#flash) messages.
5. Includes the **footer.html**.

If you look at **header.html**, you can see some more template tags in action:

{% capture ex %}{% raw %}
<!DOCTYPE html>

<html>
  <head>
    <title>{{.title}}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="/public/css/bootstrap-3.3.6.min.css">
    <link rel="shortcut icon" type="image/png" href="/public/img/favicon.png">
    <script src="/public/js/jquery-2.2.4.min.js"></script>
    <script src="/public/js/bootstrap-3.3.6.min.js"></script>
    {{range .moreStyles}}
      <link rel="stylesheet" type="text/css" href="/public/{{.}}">
    {{end}}
    {{range .moreScripts}}
      <script src="/public/{{.}}" type="text/javascript" charset="utf-8"></script>
    {{end}}
  </head>
  <body>

{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

You can see the [set](/manual/templates.html#set) `.title` being used, and also see that it accepts JS and CSS
files included from calling templates in the **moreStyles** and **moreScripts**
variables.

## Hot-reload

Revel has [`watchers`](/manual/appconf.html#watchers) that check for changes to files and recompiles as part of the development cycle.

To demonstrate this, change the welcome message.  In **Index.html**, change

{% highlight html %}
<h1>It works!</h1>
{% endhighlight %}
to
{% highlight html %}
<h1>Hello Revel</h1>
{% endhighlight %}

Refresh the browser, and you should see the change immediately!  Revel noticed
that your template changed and reloaded it.

Revel watches  - see [config](/manual/appconf.html#watchers)):

* All go code under **app/**
* All templates under **app/views/**
* The routes file: **conf/routes**

Changes to any of those will cause Revel to update and compile the running app with the
latest change in code.  Try it right now: open **app/controllers/app.go** and introduce an error.

Change
{% highlight go %}
return c.Render()
{% endhighlight %}
to
{% highlight go %}
return c.Renderx()
{% endhighlight %}
Refresh the page and Revel will display a helpful error message:

![A helpful error message](/img/helpfulerror.png)

Lastly, let's pass some data into the template.

In **app/controllers/app.go**, change:
{% highlight go %}
return c.Renderx()
{% endhighlight %}
to:
{% highlight go %}
greeting := "Aloha World"
return c.Render(greeting)
{% endhighlight %}
And in the **app/views/App/Index.html** template, change:

{% capture ex %}{% raw %}
<h1>Hello Revel</h1>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

to:

{% capture ex %}{% raw %}
<h1>{{.greeting}}</h1>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

Refresh the browser and to see a Hawaiian greeting.

![A Hawaiian greeting](/img/AlohaWorld.png)

<a href="firstapp.html" class="btn btn-sm btn-success" role="button">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a> [Create the 'Hello World' application](firstapp.html)
