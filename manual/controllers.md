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
- and the [Response](https://godoc.org/github.com/revel/revel#Response) back, in Html, Json, Xml, File or your own custom.
- `Controllers` are reused but not for the same Request <br />
- `Controllers.Destroy` function may be defined to *clean up* locally defined variables and are called
after the controller is used.
 
A `Controller` instance is not shared by two simultaneous requests, but a controller instance may be 
reused. So if you have instance variables that are set in your controller 
(like in a `Before` function), you should ensure that these variables are always initialized inside your 
`Before` function.  


For example say you have a Map defined in your controller, and the `Before` function looks at 
the `Controller.Params` object and see that the `name`  parameter exists, so it sets that value in the map.
then the controller finishes its execution.  

Now a new request comes in and the controller is reused, and the `Before` function looks at 
the `Controller.Params` object and does not see that the `name` parameter exists, so it does not change 
the "name" in the map, but as you see the map contains the value from the previous request. This type
of hidden bugs can be difficult to track down and it is the reason why it is recommended not to use
additional attributes in the controller 

There are a few ways to avoid this situation, 
1) Use the `Controller.Args` map to store your single use variables, this map is always initialized 
to an empty map so it makes a perfect spot to transfer objects within the controller call 
2) If you do use controller defined variables make sure you initialize them in your `Before` function. 
(see Before function below)
3) Define a `Destroy` function to "clean up" your locally defined stuff. Make sure the
first thing the Destroy calls is to the controller `Destroy` call

###### Example of a Controller with a `Destroy` function
```go
type MyAppController struct {
    *revel.Controller
    MyMappedData map[string]interface{}
}

// Assume that this is called for all the controller functions
func (c MyAppController) Before() {
  c.MyMappedData = map[string]interface{}{}
}

// This function will be called when the Controller is put back into the stack
func (c MyAppController) Destroy() {
	c.Controller.Destroy()
	// Clean up locally defined maps or items
	c.MyMappedData = nil
}
```



A **Controller** is any type that embeds a 
[*revel.Controller](https://godoc.org/github.com/revel/revel#Controller) as the **first field/type**
and is in a source path called controllers.

```go
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
```

<div class="alert alert-danger">NOTE: <code>*revel.Controller</code> must be 'embedded' as the first type in 
a controller struct <a href="https://talks.golang.org/2012/10things.slide#2">anonymously</a>.</div>

The [revel.Controller](https://godoc.org/github.com/revel/revel#Controller) is the context for a request and  contains the 
[Request](https://godoc.org/github.com/revel/revel#Request) and [Response](https://godoc.org/github.com/revel/revel#Response) data.

Below are the most used components and type/struct definitions to give a taste of 
[Controller](https://godoc.org/github.com/revel/revel#Controller), 
[Request](https://godoc.org/github.com/revel/revel#Request), 
[Params](https://godoc.org/github.com/revel/revel#Params) 
and [Response](https://godoc.org/github.com/revel/revel#Response).

```go
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
    ViewArgs   map[string]interface{} // Args passed to the template.
    Validation *Validation            // Data validation helpers
}
```



```go
// The request 
type Request struct {
	In              ServerRequest
	ServerHeader    *RevelHeader
	ContentType     string
	Format          string // "html", "xml", "json", or "txt"
	AcceptLanguages AcceptLanguages
	Locale          string
	WebSocket       ServerWebSocket
	Method          string
	RemoteAddr      string
	Host            string
	// URL request path from the server (built)
	URL             *url.URL
	// DEPRECATED use GetForm()
	Form url.Values
	// DEPRECATED use GetMultipartForm()
	MultipartForm *MultipartForm
}
```

```go
// These provide a unified view of the request params.
// Includes:
// - URL query string
// - Form values
// - File uploads
type Params struct {
    url.Values
    Files map[string][]*multipart.FileHeader
}
```

```go
type Response struct {
    Status      int
    ContentType string
    Headers     http.Header
    Cookies     []*http.Cookie
    Out http.ResponseWriter
}
```

- As part of handling a HTTP request, Revel instantiates an instance of a 
[revel.Controller](https://godoc.org/github.com/revel/revel#Controller).
- It then sets all of the properties on the embedded `revel.Controller`.

### Extending the Controller

A **Controller** is any type that embeds 
[revel.Controller](https://godoc.org/github.com/revel/revel#Controller) either directly or 
indirectly.
This means controllers may extend other classes, here is an example on how to do that. 
- Note in the `MyController` the `BaseController` reference is NOT a pointer

```go
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
```
