---
title: Concepts
layout: manual
---

**Revel** is almost a full stack web framework in the spirit of 
- [Rails](http://rubyonrails.org/) 
- [Play!](http://www.playframework.org)
- DJango 

- Many  *proven* ideas are incorporated into the framework, its design and interface. 
- Also using golang.. it's also hackable ;-)

Revel attempts to makes it easy to build web applications using the [Model-View-Controller
(MVC)](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
pattern by relying on conventions that require a certain structure in an
application.  In return, it is very light on [configuration](appconf.html) 
and enables an extremely fast development cycle.

## MVC

Here is a quick summary:

- **Models** are the essential data objects that describe your application domain.
   Models also contain domain-specific logic for querying and updating the data.
- **Views** describe how data is presented and manipulated. In our case, this is
   the [template](templates.html) that is used to [present data](results.html) and controls to the user.
- **Controllers** handle the request execution.  They perform the user's desired
   action, they decide which View to display, and they prepare and provide the
   necessary data to the View for rendering.

There are many excellent overviews of MVC structure online.  In particular, the
one provided by [Play! Framework](http://www.playframework.org) matches our model exactly.

## Life of a Request

Here is an overview of the request processing framework.

![Life of a Request](../img/RevelDesign.png)

Concept summary:

* Revel exposes a single http.Handler, responsible for instantiating a
  [`Controller`](controllers.html) (the context for the request) and passing the request along to the
  [Filter chain](filters.html).
* [Filters](filters.html) are links in a request processing chain. They may be composed to
  implement horizontal concerns like request logging, cookie policies,
  authorization, etc.  Most of Revel's built-in functionality are implemented as
  [Filters](filters.html).
* Actions are the application-specific functions that process the input and
  produce a [Result](results.html).

## HTTP Handler

Revel builds on top of the Go HTTP server, which creates a go-routine
(lightweight thread) to process each incoming request.  The implication is that
your code is free to block, but it must handle concurrent request processing.

The Revel handler does nothing except hand the request to the [Filter chain](filters.html) for
processing and, upon completion, apply the [result](results.html) to write the response.

By default, the Revel handler will be registered at the `"/"` url to receive all
incoming connections.  However, applications are free to override this behavior
-- for example, they may want to use existing http.Handlers rather than
re-implementing them within the Revel framework.  See the [FAQ](faq.html) for
more detail.

## Filters

[Filters](filters.html) implement most request processing functionality provided
by Revel. They have a simple interface that allows them to be nested.

The "Filter Chain" is an array of functions, each one invoking the next, until
the terminal filter stage invokes the action.  For example, one of the first
Filters in the chain is the `RouterFilter`, which decides which Action the
request is meant for and saves that to the Controller.

Overall, Filters and the Filter Chain are the equivalent of Rack.

## Controllers and Actions

Each HTTP request invokes an **action**, which handles the request and writes
the response. Related **actions** are grouped into [**controllers**](controllers.html).  The
[`Controller`](../docs/godoc/controller.html#Controller) type contains relevant
fields and methods and acts as the context for each request.

As part of handling a HTTP request, Revel instantiates an instance of a
Controller, and it sets all of these properties on the embedded
`revel.Controller`.  Revel does not share Controller instances between requests.

A **Controller** is any type that embeds `*revel.Controller` (directly or indirectly).
{% highlight go %}
type AppController struct {
  *revel.Controller
}
{% endhighlight %}

An **Action** is any method on a **Controller** that meets the following criteria:

* is exported
* returns a [`revel.Result`](results.html)

For example:
{% highlight go %}
func (c AppController) ShowLogin(username string) revel.Result {
	..
	return c.Render(username)
}
{% endhighlight %}

The example invokes `revel.Controller.Render` to execute a [template](templates.html), passing it the
username as a [parameter](parameters.html).  There are many methods on **revel.Controller** that
produce **revel.Result**, but applications are also [free to create their own](results.html#CustomResult).

## Results

A Result is anything conforming to the interface:
{% highlight go %}
type Result interface {
	Apply(req *Request, resp *Response)
}
{% endhighlight %}

Typically, nothing is written to the response until the **action** and all
[filters](filters.html) have returned.  At that point, Revel writes response headers and cookies
(e.g. setting the [session](sessionflash.html) cookie), and then invokes `Result.Apply` to write the
actual response content.
