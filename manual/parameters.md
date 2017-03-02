---
title: Request Parameters and Binding
layout: manual
---

- Revel tries to make the conversion of request parameters into the desired Go type as easy and painless as possible. 
- The conversion from a http request `string` sent by client to another type is referred to as **data binding**.

## Request Parameters

All request parameters are collected into the single [`Params`](https://godoc.org/github.com/revel/revel#Params) object which includes:

* The URL **/:path** parameters, eg `c.Params.Route.Get("path")`
* The URL **?query** parameters, eg `c.Params.Query.Get("query")`
* Submitted **Form** values , eg `c.Params.Form.Get("form_val")`
* **File** multipart uploads, eg `c.Params.Files.Get("file_name")`
* Find in all above eg `c.Params.Get("foo")`

**Important:**

- All params except `File` are golang's native [`url.Values`](http://www.golang.org/pkg/net/url/#Values) which provide the accessors.
- All values are map to slices, a `.Get()` will return first. Use map directly to get at multiple values.
- Revel's data-binding mechanisms helps with non-string values such as dates or floats.

- Golang's native [`url.Values`](http://www.golang.org/pkg/net/url/#Values) provides accessors for simple values
- Revel's data-binding mechanisms helps with non-string values such as dates or floats

## Action arguments

Parameters may be accepted directly as method arguments by the action.  For
example:

{% highlight go %}
func (c AppController) Action(name string, ids []int, user User, img []byte) revel.Result {
	...
}
{% endhighlight %}

- Before invoking the action, Revel asks its Binder to convert parameters of those names to the requested data type.  
- If the binding is unsuccessful for any reason, the parameter will have the zero value for its type.

## Binder

- To bind a parameter to a data type, use Revel's [`Binder`](https://godoc.org/github.com/revel/revel#Binder).  
- The [`Binder`](https://godoc.org/github.com/revel/revel#Binder) is integrated with the [`Params`](https://godoc.org/github.com/revel/revel#Params) object.

{% highlight go %}
// Example params to binder
func (c SomeController) Action() revel.Result {
	var ids []int
	c.Params.Bind(&ids, "ids")
	...
}
{% endhighlight %}

The following data types are supported by Revel out of the box:

* Integers of all widths
* Booleans
* Pointers to any supported type
* Slices of any supported type
* Structs
* time.Time for dates and times
* \*os.File, \[\]byte, io.Reader, io.ReadSeeker for file uploads

The following sections describe the syntax for these types.  It is also useful
to refer to [the source code of](../docs/src/binder.html) if more detail is required.

### Booleans

The string values `"true"`, `"on"`, and `"1"` are all treated as `true`,  otherwise it is `false`.

### Slices

There are two supported syntaxes for binding slices; **ordered** and **unordered**.

#### Ordered:

	?ids[0]=1
	&ids[1]=2
	&ids[3]=4

- results in a slice of `[]int{1, 2, 0, 4}`

#### Unordered:

	?ids[]=1
	&ids[]=2
	&ids[]=4

- results in a slice of `[]int{1, 2, 4}`

<div class="alert alert-info">Note: Only ordered slices should be used when binding a slice of structs:</div>

	?user[0].Id=1
	&user[0].Name=rob
	&user[1].Id=2
	&user[1].Name=jenny

### Structs

Structs are bound using simple dot notation:

	?user.Id=1
	&user.Name=rob
	&user.Friends[]=2
	&user.Friends[]=3
	&user.Father.Id=5
	&user.Father.Name=Hermes

Will bind the struct:
{% highlight go %}
type User struct {
    Id int
    Name string
    Friends []int
    Father User
}
{% endhighlight %}

<div class="alert alert-info">Note: Properties must be exported in order to be bound.</div>

### Date / Time

- The SQL standard date time formats of `2006-01-02`, `2006-01-02 15:04` are built in.
- Alternative formats may be added to the application (see [appconf](appconf.html#formatting)), using [golang native constants](http://golang.org/pkg/time/#pkg-constants).  
- Add a pattern to recognize to the [`TimeFormats`](https://godoc.org/github.com/revel/revel#TimeFormats) variable, like the example below.

{% highlight go %}
func init() {
    revel.TimeFormats = append(revel.TimeFormats, "01/02/2006")
}
{% endhighlight %}

### File Uploads

<a name="file_uploads"></a>

File uploads can be bound to any of the following types:

* \*os.File
* \[\]byte
* io.Reader
* io.ReadSeeker

This is a wrapper around the upload handling provided by
[Go's multipart package](http://golang.org/pkg/mime/multipart/).  The bytes
stay in memory unless they exceed a threshold (10MB by default), in which case
they are written to a temp file.

- See the [upload sample app](https://github.com/revel/samples/tree/master/upload)

<div class="alert alert-info">Note: Binding a file upload to <i>os.File</i> requires Revel to write it to a
temp file (if it wasn't already), making it less efficient than the other types.</div>

### Custom Binders

The application may define its own binders to take advantage of this framework.

It need only implement the [`Binder`](https://godoc.org/github.com/revel/revel#Binder) `interface` and register the type for which it
should be called:

{% highlight go %}
var myBinder = revel.Binder{
	Bind: func(params *revel.Params, name string, typ reflect.Type) reflect.Value {...},
	Unbind: func(output map[string]string, name string, val interface{}) {...},
}

func init() {
	revel.TypeBinders[reflect.TypeOf(MyType{})] = myBinder
}
{% endhighlight %}

<hr>
- See the godocs for [`Binder`](https://godoc.org/github.com/revel/revel#Binder), [`Params`](https://godoc.org/github.com/revel/revel#Params)
