---
title: URL Routing
layout: manual
github:
  labels:
    - topic-routing
godoc: 
    - Router
    - Params
---

URL's and routes are defined in the `conf/routes` file and have three columns as example below:
	
```csv
[METHOD] [URL Pattern] [Controller.Method]
GET      /              MySite.Welcome
```

### conf example

```
# Higher priority routes first

module:jobs  # Importing jobs includes all the routes from the module

## main routes
GET             /                       App.Home # A simple path

GET             /contact                App.Contact  # contact page
#GET            /contact/               App.Contact  # unnecessary as (optional trailing slash is above)

GET             /login                  App.Login

GET             /hotels/                Hotels.Index            # Match /hotels and /hotels/ 
GET             /hotels/:id             Hotels.Show             # Extract a URI argument
WS              /hotels/:id/feed        Hotels.Feed             # WebSockets.
POST            /hotels/:id/:method     Hotels.:method          # Automatically route some methods.

PURGE           /purge/:key             Cache.Purge             # Cache

# WebDAV extends the set of standard HTTP verbs and headers allowed for request methods.
PROPFIND        /webdav/:key            WebDav.PropFind         # WebDav
PROPPATCH       /webdav/:key            WebDav.PropPatch        # WebDav
MKCOL           /webdav/:key            WebDav.MkCol            # WebDav
COPY            /webdav/:key            WebDav.Copy             # WebDav
MOVE            /webdav/:key            WebDav.Mode             # WebDav
LOCK            /webdav/:key            WebDav.Lock             # WebDav
UNLOCK          /webdav/:key            WebDav.UnLock           # WebDav

## Static files. Map /app/public resources under /public/...
GET    /public/*filepath      Static.Serve("public") 

## Developer Stuff
# Prefix all routes in the testrunner module with /debug/
*      /debug/                module:testrunner 

## Finally
# Catch all and Automatic URL generation
*      /:controller/:method   :controller.:method
```

Let's go through the lines one at a time and by the end, we'll see how to
accomplish [reverse routing](#reverse-routing) i.e generating the URL to invoke a particular action.

## A Fixed Path

	GET    /login                 App.Login
	GET    /about                 App.About

The routes above use an 'exact match' of HTTP method and path and invoke the Login and About
*method* on the *App* controller.

## Trailing slashes/

	GET    /hotels/               Hotels.Index

- This route invokes `Hotels.Index` for both `/hotels` and `/hotels/`
- The [reverse route](#reverse-routing) to `Hotels.Index` will include the trailing slash/

Trailing slashes should not be used to differentiate between actions. The
simple path `/login` **will** be matched by a request to `/login/`.

## URL :parameters

	GET    /hotels/:id            Hotels.Show

- Segments of the path may be matched and extracted with a `:` prefix.  
- The `:id` variable above will match anything except a slash. For example, `/hotels/123` and
`/hotels/abc` would both be matched by the route above.
- Extracted parameters are available in both the
  - [Controller.Params](https://godoc.org/github.com/revel/revel#Params) map
  - and via Method [parameters](parameters.html).  
  
For example:
```go
func (c Hotels) Show(id int) revel.Result {
    ...
}
```
or
```go
func (c Hotels) Show() revel.Result {
    var id string = c.Params.Get("id")
    ...
}
```
or
```go
func (c Hotels) Show() revel.Result {
    var id int
    c.Params.Bind(&id, "id")
    ...
}
```

## Star *parameters

	GET    /public/*filepath            Static.Serve("public")

The starred parameter must be
the first element in the path, and match all remaining path elements.

For example, in the case above it will match any path beginning with `/public/`, and
its value will be the path substring that follows the `*` prefix.

## Fixed Parameters

As also demonstrated in [Static Serving](#StaticFiles) below, routes may specify one or more
parameters to the method.  For example:

    GET    /products/:id     ShowList("PRODUCT")
    GET    /menus/:id        ShowList("MENU")

The provided argument(s) are bound to a parameter name using their position. In
this case, the list type string would be bound to the name of the first method
parameter.

This is helpful in situations where:

* you have a couple similar methods
* you have methods that do the same thing, but operate in different modes
* you have methods that do the same thing, but operate on different data types

## Auto Routing

~~~
POST   /hotels/:id/:method    Hotels.:method
*      /:controller/:method   :controller.:method
~~~

URL argument extraction can also be used to determine the invoked method.
Matching to controllers and methods is **case insensitive**.

The first example route line would effect the following routes:

    /hotels/1/show    => Hotels.Show
    /hotels/2/details => Hotels.Details

Similarly, the second example may be used to access any action (Controller.Method) in the
application:

    /app/login         => App.Login
    /users/list        => Users.List

Since matching to controllers and methods are case insensitive, the following
routes would also work:

    /APP/LOGIN         => App.Login
    /Users/List        => Users.List

Using auto-routing as a catch-all (e.g. last route in the file) is useful for
quickly hooking up actions to non-vanity URLs, especially in conjunction with
the [reverse router](#reverse-routing).

**It is recommended that auto-routing be used for rapid development work, then 
routes should be fully qualified to avoid exposing a method in a controller**

<a name="StaticFiles"></a>

## Static Serving

	GET    /public/*filepath            Static.Serve("public")
	GET    /favicon.ico                 Static.Serve("public","img/favicon.png")
    GET    /img/icon.png                Static.Serve("public", "img/icon.png") << space causes error
    
For serving directories of static assets, Revel provides the **static** built in module,
which contains a single
[Static](https://godoc.org/github.com/revel/modules/static/app/controllers#Static)
controller.  [Static.Serve](https://godoc.org/github.com/revel/modules/static/app/controllers#Static.Serve) 
method takes two parameters:

* `prefix` (string) - A (relative or absolute) path to the asset root.
* `filepath` (string) - A relative path that specifies the requested file.

<div class="alert alert-warning">
Important:<br>For the two parameters version of <code>Static.Serve</code>, blank spaces are not allowed between
<code>"</code> and <code>,</code> due to how <a href="http://golang.org/pkg/encoding/csv/"><code>encoding/csv</code></a> works.
</div>
<div class="alert alert-danger">Static content can only be served from within the application root for security reasons. To include `external assets` consider symbolic links or a git submodule</div>


- Refer to [organization](organization.html) for the directory layout


<a name="modules"></a>

## Modules

[Modules](/modules/index.html) which contain routes can be imported into your application in two ways:

In the example below, it's assumed `mymodule` has a `routes` file containing:
    
    GET      /gopher        MyModule.FetchGopher
    POST     /gopher/add    MyModule.AddGopher
    
### 1) Importing routes as-is

    # mymodule routes 
	module:mymodule

	# Other routes
	GET     /        Application.Index
	GET     /bar     Application.Bar
	
- The routes would be 'imported' into your application with the URL's `/gopher` and `/gopher/add`

### 2) Importing the routes under a prefixed path

~~~
# mymodule routes with prefix - Must be defined with an asterisk * for the method
*       /myurl     module:mymodule 
	
# Other routes
GET     /        Application.MyMethod
GET     /foo     Application.FooMethod
~~~

- The routes would be imported with the URL's `/myurl/gopher` and `/myurl/gopher/add`.
- See also [Modules](/modules/index.hml) and  [Jobs](/modules/jobs.html)



## Websockets

    WS     /hotels/:id/feed       Hotels.Feed

[Websockets](websockets.html) are routed the same way as other requests with the 'method'
identifier of `WS`.

## Purge

	PURGE           /purge/:key             Cache.Purge             # Cache

- Purge method is routed the same way as other requests with the `method`
- An HTTP purge is similar to an HTTP GET request, except that the method is PURGE.
- Actually you can call the method whatever you'd like, but most people refer to this as purging. 

## WebDav

	PROPFIND        /webdav/:key            WebDav.PropFind         # WebDav
	PROPPATCH       /webdav/:key            WebDav.PropPatch        # WebDav
	MKCOL           /webdav/:key            WebDav.MkCol            # WebDav
	COPY            /webdav/:key            WebDav.Copy             # WebDav
	MOVE            /webdav/:key            WebDav.Mode             # WebDav
	LOCK            /webdav/:key            WebDav.Lock             # WebDav
	UNLOCK          /webdav/:key            WebDav.UnLock           # WebDav

- WebDav Methods are routed the same way as other requests with the `method`.
- See the [WebDav Documentation](https://en.wikipedia.org/wiki/WebDAV) for more details.


## Reverse Routing

It is good practice to use a reverse router to generate URL's instead of hardcoding for a few reasons including:

* Avoids misspellings
* The compiler ensures that reverse routes have the right number and type of parameters.
* Localizes URL changes to one place in the 'conf/routes' file.

Upon building your application, Revel generates an `app/routes` package.  Use it
with a statement of the form:

```go
routes.Controller.Method(param1, param2)
```


The above statement returns an URL string to `Controller.Method` with the
given parameters.  

<div class="alert alert-info"><strong>Limitation:</strong> Only primitive
parameters to a route are typed due to the possibility of circular imports.
Non-primitive parameters are typed as interface{}.
</div>

Below is a more complete example:

```go
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
```


