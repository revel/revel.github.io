---
title: Results & Responses
layout: manual
github:
  labels:
    - topic-controller
    - topic-static
godoc:
    - Controller.Render
    - Controller.RenderTemplate
    - Controller.RenderJSON
    - Controller.RenderXML
    - Controller.RenderFile
    - Controller.RenderFileName
    - Controller.Redirect
---

Actions must return a [revel.Result](https://godoc.org/github.com/revel/revel#Result), which
handles the HTTP response generation and adheres to the simple interface:

{% highlight go %}
type Result interface {
	Apply(req *Request, resp *Response)
}
{% endhighlight %}

[revel.Controller](https://godoc.org/github.com/revel/revel#Controller) provides a few
methods to produce different results:


<div class="alert alert-success">
<b>NOTE: From v0.14, the following changes:</b>
<ul>
<li>`RenderJson` is now `RenderJSON`</li>
<li>`RenderJsonP` is now `RenderJSONP`</li>
<li>`RenderXml` is now `RenderXML`</li>
</ul>
</div>

* **[Render()](#Render)**, **[RenderTemplate()](#RenderTemplate)** 
    - render a template, passing arguments.
* **[RenderJSON()](#RenderJSON)**, **[RenderXML()](#RenderXML)** 
    - serialize a structure to json or xml.
* **`RenderText()`** 
    - return a plaintext response.
* **[Redirect()](#Redirect)** 
    - redirect to another action or URL
* **[RenderFile()](#RenderFile)**, **[RenderFileName()](#RenderFileName)**
    - return a file inline or to be downloaded as an attachment.
* **`RenderError()`** 
    - return a 500 response that renders the errors/500.html template.
* **`NotFound()`** 
    - return a 404 response that renders the errors/404.html template.
* **`Todo()`** 
    - return a stub response (500)

Additionally, the developer may define a result with [CustomResult](#CustomResult) and return that.

### Setting the Status Code / Content Type

Each built-in Result has a default `HTTP Status Code` and `Content Type`.  To override
those defaults, simply set those properties on the response:

```go
func (c App) Index() revel.Result {
	c.Response.Status = http.StatusTeapot
	c.Response.ContentType = "application/dishware"
	return c.Render()
}
```


You can override the default status code by setting one yourself:

```go
func (c *App) CreateEntity() revel.Result {
    c.Response.Status = 201
    return c.Render()
}
```

<a name="Render" /><a name="RenderTemplate" />

## Controller.Render()

Called within an action (e.g. "Controller.Action"),
[Controller.Render()](https://godoc.org/github.com/revel/revel#Controller.Render) does two things:

 1. Adds all arguments to the controller's `ViewArgs`, using their local identifier as the key.
 2. Executes the template "views/Controller/Action.html", passing in the controller's `ViewArgs` as the data map.

If unsuccessful (e.g. it could not find the template), an [ErrorResult](https://godoc.org/github.com/revel/revel#ErrorResult) is returned instead.

This allows the developer to write:

```go
func (c MyApp) Action() revel.Result {
	myValue := calculateValue()
	return c.Render(myValue)
}
```

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
    c.ViewArgs["foo"] = "bar"
    c.ViewArgs["bar"] = 1
    abc := "abc"
    xyz := "xyz"
    return c.Render(xyz, abc)
}

// Example renders the `views/Foo/boo.xhtml` tempate
func (c MyController) XTemp() revel.Result {
    c.ViewArgs["foo"] = "bar"
    c.ViewArgs["bar"] = 1
    return c.RenderTemplate("Foo/boo.xhtml")
}
{% endraw %}{% endcapture %}

{% highlight go %}{{ex_render}}{% endhighlight %}

<a name="RenderFile" /><a name="RenderFileName" />

## Controller.RenderFile() / Controller.RenderFileName()

Within an action it is sometimes necessary to serve a file (e.g. an attachment).
For this case the functions [Controller.RenderFile()](https://godoc.org/github.com/revel/revel#Controller.RenderFile) and For this case the functions [Controller.RenderFileName()](https://godoc.org/github.com/revel/revel#Controller.RenderFileName) are there.

The main difference is that `Controller.RenderFile()` needs an `*os.File` and `Controller.RenderFileName()` takes a file path as a string. Both require a Content-Disposition option which can be `revel.Attachment` or `revel.Inline`.

* `revel.Attachment` forces the browser to download the file. The filename and size are derived from the passed `*os.File` or file path.
* `revel.Inline` indicates the browser that it may render the file inline. Note that when browsers can't display the file a download is still performed.
* `revel.NoDisposition` omits the content disposition header and let the browser figure out what to do, also omits the file name from the header.

`Controller.RenderFileName()` can also return an error in case the file is not found. See [Controller.RenderError()](https://godoc.org/github.com/revel/revel#Controller.RenderError)

```go
func (c App) File() revel.Result {
	f, _ := os.Open("/path/to/attachment.pdf")
	return c.RenderFile(f, revel.Inline)
}

func (c App) Filename() revel.Result {
	return c.RenderFileName("/path/to/attachment.docx", revel.Attachment)
}
```

<a name="RenderJSON"></a><a name="RenderXML"></a>

## Controller.RenderJSON() / Controller.RenderXML()

The application may call
[RenderJSON](https://godoc.org/github.com/revel/revel#Controller.RenderJSON), 
[RenderJSONP](https://godoc.org/github.com/revel/revel#Controller.RenderJSONP) or
[RenderXML](https://godoc.org/github.com/revel/revel#Controller.RenderXML) and pass in any Go
type, usually a struct.  Revel will serialize it using
[json.Marshal](http://www.golang.org/pkg/encoding/json/#Marshal) or
[xml.Marshal](http://www.golang.org/pkg/encoding/xml/#Marshal).

If [`results.pretty=true`](appconf.html#results.pretty) in [`conf/app.conf`](appconf.html)  then serialization will be done using
`MarshalIndent` instead, to produce nicely indented output for human consumption.

```go
// Simple example

type Stuff struct {
    Foo string ` json:"foo" xml:"foo" `
    Bar int ` json:"bar" xml:"bar" `
}

func (c MyController) MyWork() revel.Result {
    data := make(map[string]interface{})
    data["error"] = nil
    stuff := Stuff{Foo: "xyz", Bar: 999}
    data["stuff"] = stuff
    return c.RenderJSON(data)
    // or alternately 
    // return c.RenderXML(data)
}
```

<a name="Redirect"></a>

## Redirect()

- A helper function for generating [HTTP redirects](http://en.wikipedia.org/wiki/URL_redirection#HTTP_status_codes_3xx).  
- It may be used in two ways and both return a `302 Temporary Redirect` HTTP status code.

#### Redirect to an action with no arguments:

```go
    return c.Redirect(Hotels.Settings)
```

- This form is useful as it provides a degree of type safety and independence from the 
routing and generates the URL automatically.

#### Redirect to a formatted string:

`return c.Redirect("/hotels/%d/settings", hotelId)`

- This form is necessary to pass arguments.
- It returns a `302 Temporary Redirect` status code.

<a name="CustomResult"></a>

## Custom Result

Below is a simple example of creating a custom [revel.Result](https://godoc.org/github.com/revel/revel#Result).

Create this type:

```go
import ("net/http")

type MyHtml string

func (r MyHtml) Apply(req *revel.Request, resp *revel.Response) {
	resp.WriteHeader(http.StatusOK, "text/html")
	resp.Out.Write([]byte(r))
}
```

Then use it in the action `MyApp.Hello`:

```go
func (c *MyApp) Hello() revel.Result {
	return MyHtml("<html><body>Hello Result</body></html>")
}
```


