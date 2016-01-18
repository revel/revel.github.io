---
title: Controllers Overview
layout: manual
---

A **Controller** is any type that embeds a [`*revel.Controller`](https://godoc.org/github.com/revel/revel#Controller).

{% highlight go %}
type MyAppController struct {
    *revel.Controller
}
type MyOtherController struct {
    *revel.Controller
    OtherStuff string
    MyNo int64
}
{% endhighlight %}

<div class="alert alert-danger">Note: <code>*revel.Controller</code> must be 'embedded' as the first type in 
the struct <a href="https://talks.golang.org/2012/10things.slide#2">anonymously</a>, the Go way for 'inheritance'</div>

The `revel.Controller` is the context for a request and  contains the 
[`Request`](https://godoc.org/github.com/revel/revel#Request) and [`Response`](https://godoc.org/github.com/revel/revel#Response) data.

Below are the most used Controller, Request, Params and Response structs and their definitions.

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
    RenderArgs map[string]interface{} // Args passed to the template.
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

- As part of handling a HTTP request, Revel instantiates an instance of a `Controller`.
- It then sets all of the properties on the embedded `revel.Controller`.  
- Revel does not share a `Controller` instance between requests.

<hr>
- See the godocs for [`Controller`](https://godoc.org/github.com/revel/revel#Controller)
- Issues tagged with [controller](https://github.com/revel/revel/labels/%23controller)
