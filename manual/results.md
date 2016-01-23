---
title: Results & Responses
layout: manual
---

Actions must return a [`revel.Result`](https://godoc.org/github.com/revel/revel#Result), which
handles the HTTP response generation.  It adheres to the simple interface:

{% highlight go %}
type Result interface {
	Apply(req *Request, resp *Response)
}
{% endhighlight %}

[`revel.Controller`](https://godoc.org/github.com/revel/revel#Controller) provides a few
methods to produce different results:

* **[`Render()`](#Render)**, **[`RenderTemplate()`](#RenderTemplate)** 
    - render a template, passing arguments.
* **[`RenderJson()`](#RenderJson)**, **[`RenderXml()`](#RenderXml)** 
    - serialize a structure to json or xml.
* **`RenderText()`** 
    - return a plaintext response.
* **[`Redirect()`](#Redirect)** 
    - redirect to another action or URL
* **`RenderFile()`** 
    - return a file, generally to be downloaded as an attachment.
* **`RenderError()`** 
    - return a 500 response that renders the errors/500.html template.
* **`NotFound()`** 
    - return a 404 response that renders the errors/404.html template.
* **`Todo()`** 
    - return a stub response (500)

Additionally, the developer may [define a custom `revel.Result`](#CustomResult) and return that.

### Setting the Status Code / Content Type

Each built-in Result has a default `HTTP Status Code` and `Content Type`.  To override
those defaults, simply set those properties on the response:

{% highlight go %}
func (c App) Action() revel.Result {
	c.Response.Status = http.StatusTeapot
	c.Response.ContentType = "application/dishware"
	return c.Render()
}
{% endhighlight %}


You can override the default status code by setting one yourself:

{% highlight go %}
func (c *App) CreateEntity() revel.Result {
    c.Response.Status = 201
    return c.Render()
}
{% endhighlight %}

<a name="Render"><a name="RenderTemplate">

## Render()

Called within an action (e.g. "Controller.Action"),
[`Controller.Render`](https://godoc.org/github.com/revel/revel#Controller.Render) does two things:

 1. Adds all arguments to the controller's `RenderArgs`, using their local identifier as the key.
 2. Executes the template "views/Controller/Action.html", passing in the controller's `RenderArgs` as the data map.

If unsuccessful (e.g. it could not find the template), an [`ErrorResult`](https://godoc.org/github.com/revel/revel#ErrorResult) is returned instead.

This allows the developer to write:

{% highlight go %}
func (c MyApp) Action() revel.Result {
	myValue := calculateValue()
	return c.Render(myValue)
}
{% endhighlight %}

and to use `myValue` in their template.  This is usually more convenient than
constructing an explicit map, since in many cases the data will need to be
handled as a local variable anyway.

<div class="alert alert-info">Note: Revel looks at the calling method name to determine the Template
path and to look up the argument names.  Therefore, `c.Render()` may only be  called from Actions.</div>

{% capture ex_render %}{% raw %}
// Example using mix of render args and variables
// This renders the `views/MyController/showSutuff.html` template as
// eg <pre>foo={{.foo}} bar={{.bar}} abc={{.abc}} xyz={{.xyz}}</pre>
func (c MyController) ShowStuff() revel.Result {
    c.RenderArgs["foo"] = "bar"
    c.RenderArgs["bar"] = 1
    abc := "abc"
    xyz := "xyz"
    return c.Render(xyz, abc)
}

// Example renders the `views/Foo/boo.xhtml` tempate
func (c MyController) XTemp() revel.Result {
    c.RenderArgs["foo"] = "bar"
    c.RenderArgs["bar"] = 1
    return c.RenderTemplate("Foo/boo.xhtml")
}
{% endraw %}{% endcapture %}

{% highlight go %}{{ex_render}}{% endhighlight %}

<a name="RenderJson"></a><a name="RenderXml"></a>

## RenderJson() / RenderXml()

The application may call
[`RenderJson`](https://godoc.org/github.com/revel/revel#Controller.RenderJson) or
[`RenderXml`](https://godoc.org/github.com/revel/revel#Controller.RenderXml) and pass in any Go
type (usually a struct).  Revel will serialize it using
[`json.Marshal`](http://www.golang.org/pkg/encoding/json/#Marshal) or
[`xml.Marshal`](http://www.golang.org/pkg/encoding/xml/#Marshal).

If [`results.pretty=true`](appconf.html#results.pretty) in [`conf/app.conf`](appconf.html)  then serialization will be done using
`MarshalIndent` instead, to produce nicely indented output for human consumption.

{% highlight go %}
// Simple example

type Stuff struct {
    Foo string ` json:"foo" xml:"foo" `
    Bar int ` json:"bar" xml:"bar" `
}

func (c MyController) MyAction() revel.Result {
    data := make(map[string]interface{})
    data["error"] = nil
    stuff := Stuff{Foo: "xyz", Bar: 999}
    data["stuff"] = stuff
    return c.RenderJson(data)
    //return c.RenderXml(data)
}
{% endhighlight %}

<a name="Redirect"></a>

## Redirect()

- A helper function is provided for generating [HTTP redirects](http://en.wikipedia.org/wiki/URL_redirection#HTTP_status_codes_3xx).  
- It may be used in two ways and both return a `302 Temporary Redirect` HTTP status code..

### Redirect to an action with no arguments:

{% highlight go %}
    return c.Redirect(Hotels.Settings)
{% endhighlight %}

- This form is useful as it provides a degree of type safety and independence from the routing and generates the URL automatically.

### Redirect to a formatted string:

{% highlight go %}return c.Redirect("/hotels/%d/settings", hotelId){% endhighlight %}

- This form is necessary to pass arguments.
- It returns a `302 Temporary Redirect` status code.

<a name="CustomResult"></a>

## Custom Result

Below is a simple example of creating a custom `Result`.

Create this type:

{% highlight go %}
import ("net/http")

type MyHtml string

func (r MyHtml) Apply(req *revel.Request, resp *revel.Response) {
	resp.WriteHeader(http.StatusOK, "text/html")
	resp.Out.Write([]byte(r))
}
{% endhighlight %}

Then use it in an action:

{% highlight go %}
func (c *MyApp) Action() revel.Result {
	return MyHtml("<html><body>Hello Result</body></html>")
}
{% endhighlight %}


<hr>
See the godocs for [results.go](../docs/godoc/results.html)
