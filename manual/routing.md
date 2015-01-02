---
title: URL Routing
layout: manual
---

URL's and Routes are defined in the `conf/routes` file, and the basic syntax is three columns as example below:
{% highlight ini %}
[METHOD] [URL Pattern] [Controller.Action]
GET      /             MySite.Welcome
{% endhighlight %}



~~~
# conf/routes
# This file defines all application routes 
# Higher priority routes first

module:jobs  # Import all routes from the jobs module

GET    /login                 App.Login              # A simple path
GET    /hotels/               Hotels.Index           # Match /hotels and /hotels/ (optional trailing slash)
GET    /hotels/:id            Hotels.Show            # Extract a URI argument
WS     /hotels/:id/feed       Hotels.Feed            # WebSockets.
POST   /hotels/:id/:action    Hotels.:action         # Automatically route some actions.
GET    /public/*filepath      Static.Serve("public") # Map /app/public resources under /public/...
*      /debug/                module:testrunner      # Prefix all routes in the testrunner module with /debug/
*      /:controller/:action   :controller.:action    # Catch all; Automatic URL generation
~~~

Let's go through the lines one at a time.  At the end, we'll see how to
accomplish [reverse routing](#ReverseRouting) i.e generating the URL to invoke a particular action.

## A Fixed Path

	GET    /login                 App.Login
	GET    /about                 App.About

The routes above use an 'exact match' of HTTP method and path and invoke the Login and About
*action* on the *App* controller.

## Trailing slashes/

	GET    /hotels/               Hotels.Index

- This route invokes `Hotels.Index` for both `/hotels` and `/hotels/`
- The [reverse route](#ReverseRouting) to `Hotels.Index` will include the trailing slash/

Trailing slashes should not be used to differentiate between actions. The
simple path `/login` **will** be matched by a request to `/login/`.

## URL :parameters

	GET    /hotels/:id            Hotels.Show

- Segments of the path may be matched and extracted with a `:` prefix.  
- The `:id` variable above will match anything except a slash. For example, `/hotels/123` and
`/hotels/abc` would both be matched by the route above.
- Extracted parameters are available in both the
  - [`Controller`](../docs/godoc/controller.html#Controller).[`Params`](../docs/godoc/params.html#Params) map
  - and via Action method [parameters](parameters.html).  
  
For example:
{% highlight go %}
func (c Hotels) Show(id int) revel.Result {
    ...
}
{% endhighlight %}
or
{% highlight go %}
func (c Hotels) Show() revel.Result {
    var id string = c.Params.Get("id")
    ...
}
{% endhighlight %}
or
{% highlight go %}
func (c Hotels) Show() revel.Result {
    var id int
    c.Params.Bind(&id, "id")
    ...
}
{% endhighlight %}

## Star *parameters

	GET    /public/*filepath            Static.Serve("public")

The router recognizes a second kind of wildcard. The starred parameter must be
the first element in the path, and match all remaining path elements.

For example, in the case above it will match any path beginning with `/public/`, and
its value will be the path substring that follows the `*` prefix.

## Fixed Parameters

As demonstrated in the [Static Serving](#StaticFiles) section, routes may specify one or more
parameters to the action.  For example:

    GET    /products/:id     ShowList("PRODUCT")
    GET    /menus/:id        ShowList("MENU")

The provided argument(s) are bound to a parameter name using their position. In
this case, the list type string would be bound to the name of the first action
parameter.

This could be helpful in situations where:

* you have a couple similar actions
* you have actions that do the same thing, but operate in different modes
* you have actions that do the same thing, but operate on different data types

## Auto Routing

~~~
POST   /hotels/:id/:action    Hotels.:action
*      /:controller/:action   :controller.:action
~~~

URL argument extraction can also be used to determine the invoked action.
Matching to controllers and actions is **case insensitive**.

The first example route line would effect the following routes:

    /hotels/1/show    => Hotels.Show
    /hotels/2/details => Hotels.Details

Similarly, the second example may be used to access any action in the
application:

    /app/login         => App.Login
    /users/list        => Users.List

Since matching to controllers and actions is case insensitive, the following
routes would also work:

    /APP/LOGIN         => App.Login
    /Users/List        => Users.List

Using auto-routing as a catch-all (e.g. last route in the file) is useful for
quickly hooking up actions to non-vanity URLs, especially in conjunction with
the [reverse router](#ReverseRouting).

<a name="StaticFiles"></a>

## Static Serving

	GET    /public/*filepath            Static.Serve("public")
	GET    /favicon.ico                 Static.Serve("public","img/favicon.png")
	
For the two parameters version of Static.Serve, blank spaces are not allowed between
**"** and **,** due to how encoding/csv works.

For serving directories of static assets, Revel provides the **static** module,
which contains a single
[Static](http://godoc.org/github.com/revel/modules/static/app/controllers)
controller.  Its Serve action takes two parameters:

* prefix (string) - A (relative or absolute) path to the asset root.
* filepath (string) - A relative path that specifies the requested file.

(Refer to [organization](organization.html) for the directory layout)





## Modules

[Modules](modules.html) which contain routes can be imported into your application in two ways:

First method: Importing routes as-is using the following in the `conf/routes` file:

    # mymodule routes 
	module:mymodule

	# Other routes
	GET     /        Application.Index
	GET     /bar     Application.Bar

Second method: Importing the routes under a prefixed path:

~~~
# mymodule routes with prefix - Must be defined with asterisk `*` for the method
*       /foo     module:mymodule 
	
# Other routes
GET     /        Application.MyAction
GET     /foo     Application.FooAction
~~~

Assuming `mymodule` has a `routes` file containing:

	GET      /gopher        MyModule.FetchGopher
	POST     /gopher/add    MyModule.AddGopher

Then in the first example, the routes would be imported into your application with the URL patterns `/gopher` and `/gopher/add`. In the second example, the routes would be imported with the URL patterns `/foo/gopher` and `/foo/gopher/add`.


## Websockets

    WS     /hotels/:id/feed       Hotels.Feed

[Websockets](websockets.html) are routed the same way as other requests with the 'method'
identifier of `WS`.



<a name="ReverseRouting"></a>

## Reverse Routing

It is good practice to use a reverse router to generate URL's instead of hardcoding for a few reasons including:

* Avoids misspellings
* The compiler ensures that reverse routes have the right number and type of parameters.
* Localizes URL changes to one place in the 'conf/routes' file.

Upon building your application, Revel generates an `app/routes` package.  Use it
with a statement of the form:

<pre class="prettyprint lang-go">
routes.Controller.Action(param1, param2)
</pre>


The above statement returns an URL string to `Controller.Action` with the
given parameters.  

<div class="alert alert-info"><strong>Limitation:</strong> Only primitive
parameters to a route are typed due to the possibility of circular imports.
Non-primitive parameters are typed as interface{}.
</div>

Below is a more complete example:

{% highlight go %}
import (
	"github.com/revel/revel"
	"project/app/routes"
)

type App struct { *revel.Controller }

// Show a form
func (c App) ViewForm(username string) revel.Result {
	return c.Render(username)
}

// Process the submitted form.
func (c App) ProcessForm(username, input string) revel.Result {
	...
	if c.Validation.HasErrors() {
		c.Validation.Keep()
		c.Flash.Error("Form invalid. Try again.")
		return c.Redirect(routes.App.ViewForm(username))  // <--- REVERSE ROUTE
	}
	c.Flash.Success("Form processed!")
	return c.Redirect(routes.App.ViewConfirmation(username, input))  // <--- REVERSE ROUTE
}
{% endhighlight %}



