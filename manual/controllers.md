---
title: Controllers Overview
layout: manual
github:
  labels:
    - topic-controller
godoc: 
    - Controller
    - Request
    - Response
---

The [revel.Controller](https://godoc.org/github.com/revel/revel#Controller) is the context for 
a single request and controls
- the incoming [Request](https://godoc.org/github.com/revel/revel#Request) stuff
- and the [Response](https://godoc.org/github.com/revel/revel#Response) back, in Hmtl, Json, Xml, File or your own custom.

A **Controller** is any type that embeds a [*revel.Controller](https://godoc.org/github.com/revel/revel#Controller) as the **first field/type**.

{% highlight go %}
type MyAppController struct {
    *revel.Controller
}
type MyOtherController struct {
    *revel.Controller
    OtherStuff string
    MyNo int64
}
type FailController struct {
    XStuff string
    *revel.Controller // Fail as it should be first    
}
{% endhighlight %}

<div class="alert alert-danger">NOTE: <code>*revel.Controller</code> must be 'embedded' as the first type in 
a controller struct <a href="https://talks.golang.org/2012/10things.slide#2">anonymously</a>.</div>

The [revel.Controller](https://godoc.org/github.com/revel/revel#Controller) is the context for a request and  contains the 
[Request](https://godoc.org/github.com/revel/revel#Request) and [Response](https://godoc.org/github.com/revel/revel#Response) data.

Below are the most used components and type/struct definitions to give a taste of 
[Controller](https://godoc.org/github.com/revel/revel#Controller), 
[Request](https://godoc.org/github.com/revel/revel#Request), 
[Params](https://godoc.org/github.com/revel/revel#Params) 
and [Response](https://godoc.org/github.com/revel/revel#Response).

{% highlight go %}
type Controller struct {
    Name          string          // The controller name, e.g. "Application"
    Type          *ControllerType // A description of the controller type.
    MethodType    *MethodType     // A description of the invoked action type.
    AppController interface{}     // The controller that was instantiated.

    Request  *Request
    Response *Response
    Result   Result

    Flash      Flash                  // User cookie, cleared after 1 request.
    Session    Session                // Session, stored in cookie, signed.
    Params     *Params                // Parameters from URL and form (including multipart).
    Args       map[string]interface{} // Per-request scratch space.
    ViewArgs map[string]interface{} // Args passed to the template.
    Validation *Validation            // Data validation helpers
}
{% endhighlight %}

{% highlight go %}
type Request struct {
    *http.Request
    ContentType string
    Format          string // "html", "xml", "json", or "txt"
    AcceptLanguages AcceptLanguages
    Locale          string
    Websocket       *websocket.Conn
}
{% endhighlight %}

{% highlight go %}
// These provide a unified view of the request params.
// Includes:
// - URL query string
// - Form values
// - File uploads
type Params struct {
    url.Values
    Files map[string][]*multipart.FileHeader
}
{% endhighlight %}

{% highlight go %}
type Response struct {
    Status      int
    ContentType string
    Headers     http.Header
    Cookies     []*http.Cookie
    Out http.ResponseWriter
}
{% endhighlight %}

- As part of handling a HTTP request, Revel instantiates an instance of a [revel.Controller](https://godoc.org/github.com/revel/revel#Controller).
- It then sets all of the properties on the embedded `revel.Controller`.
- Revel does not share a `Controller` instance between requests.

### Extending the Controller

A **Controller** is any type that embeds [revel.Controller](https://godoc.org/github.com/revel/revel#Controller) either directly or indirectly.
This means controllers may extend other classes, here is an example on how to do that. 
- Note in the `MyController` the `BaseController` reference is NOT a pointer

{% highlight go %}
type (
	BaseController struct {
		*revel.Controller
	}
)
type (
	MyController struct {
		BaseController
	}
)
{% endhighlight %}
