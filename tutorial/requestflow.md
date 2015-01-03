---
title: The Request Flow
layout: tutorial
---

In the [previous page](createapp.html) we created a new Revel application
called **myapp**. In this article we look at how Revel handles the HTTP request
to `http://localhost:9000/`, resulting in the welcome message.

## Routes

The first thing that Revel does is check the `conf/routes` file (see [routing](../manual/routing)):

	GET     /     App.Index

This tells Revel to invoke the **Index** method of the **App**
[controller](../controllers.html) when it receives a **GET** request to **/**.

## Actions

Let's follow this call to the code, in **app/controllers/app.go**:
{% highlight go %}
package controllers

import "github.com/revel/revel"

type App struct {
    *revel.Controller
}

func (c App) Index() revel.Result {
    return c.Render()
}
{% endhighlight %}

All controllers must be structs that embed `*revel.Controller`
in the first slot (directly or indirectly). Any method on a controller that is
exported and returns a [`revel.Result`](../manual/results.html) may be treated as an Action.

The Revel controller provides many useful methods for generating Results. In
this example, it calls [`Render()`](../docs/godoc/controller.html#Controller.Render),
which tells Revel to find and render a [template](../manual/templates.html) as the response with `200 OK`.

## Templates

All [templates](../manual/templates.html) are kept in the **app/views** directory. When an explicit
template name is not specified, Revel looks for a template matching the action.
In this case, Revel finds the **app/views/App/Index.html** file, and
renders it as a [Go template](http://www.golang.org/pkg/html/template).

{% raw %}

	{{set . "title" "Home"}}
	{{template "header.html" .}}

	<header class="hero-unit" style="background-color:#A9F16C">
	  <div class="container">
	    <div class="row">
	      <div class="hero-text">
	        <h1>It works!</h1>
	        <p></p>
	      </div>
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

{% endraw %}

Beyond the functions provided by the Go templates, Revel adds
[a few helpful ones](../manual/templates.html#functions) of its own.

This template is very simple.  It:

1. Adds a new **title** variable to the render context with [set](../manual/templates.html#set).
2. Includes the **header.html** template ,which uses the **title**.
3. Displays a welcome message.
4. Includes the **flash.html** template, which shows any [flashed](sessionflash.html#Flash) messages.
5. Includes the **footer.html**.

If you look at **header.html**, you can see some more template tags in action:

{% raw %}

	<!DOCTYPE html>

	<html>
	  <head>
	    <title>{{.title}}</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" type="text/css" href="/public/css/bootstrap.css">
	    <link rel="shortcut icon" type="image/png" href="/public/img/favicon.png">
	    <script src="/public/js/jquery-1.9.1.min.js" type="text/javascript" charset="utf-8"></script>
	    {{range .moreStyles}}
	      <link rel="stylesheet" type="text/css" href="/public/{{.}}">
	    {{end}}
	    {{range .moreScripts}}
	      <script src="/public/{{.}}" type="text/javascript" charset="utf-8"></script>
	    {{end}}
	  </head>
	  <body>

{% endraw %}

You can see the [set](../manual/templates.html#set) `.title` being used, and also see that it accepts JS and CSS
files included from calling templates in the **moreStyles** and **moreScripts**
variables.

## Hot-reload

Let's change the welcome message.  In **Index.html**, change

{% highlight html %}
<h1>It works!</h1>
{% endhighlight %}
to
{% highlight html %}
<h1>Hello Revel</h1>
{% endhighlight %}

Refresh your browser, and you should see the change immediately!  Revel noticed
that your template changed and reloaded it.

Revel watches (see [watchers config](../manual/appconf.html#Watchers)):

* All go code under **app/**
* All templates under **app/views/**
* Your routes file: **conf/routes**

Changes to any of those will cause Revel to update and compile the running app with the
newest code.  Try it right now: open **app/controllers/app.go** and introduce an error.

Change
{% highlight go %}
return c.Render()
{% endhighlight %}
to
{% highlight go %}
return c.Renderx()
{% endhighlight %}
Refresh the page and Revel will display a helpful error message:

![A helpful error message](../img/helpfulerror.png)

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

{% raw %}

	<h1>Hello Revel</h1>

{% endraw %}

to:

{% raw %}

	<h1>{{.greeting}}</h1>

{% endraw %}

Refresh the page and you will see a Hawaiian greeting.

![A Hawaiian greeting](../img/AlohaWorld.png)

**Next: [Make a simple Hello World application](firstapp.html).**
