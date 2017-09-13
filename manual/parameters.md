---
title: Request Parameters and JSON
layout: manual
github:
  labels:
    - topic-controller
godoc: 
    - Request
    - Params
    - Binder
---

**Revel** tries to make the conversion of request 
  data into the desired Go types as easy and painless as possible. 
- The conversion from a http request `string` sent 
  by client to another type is referred to as **data binding**.
- JSON data is processed when the http header ContentType is `application/json` 
or `text/json`

## Request Parameters

All request parameters are collected into a single [Params](https://godoc.org/github.com/revel/revel#Params) object which includes:


### URL path

The URL **/:path** parameters for the route

```go
// path = /book/:author/:book
author := c.Params.Route.Get("author")
book := c.Params.Route.Get("book")
```

### Query Vars

The URL **?query=** parameters

```go
// url = /foo?sort=asc&active=1
s := c.Params.Query.Get("sort")
act := c.Params.Query.Get("active")
```

### Form Vars

Submitted POST **Form** values
```go
v := c.Params.Form.Get("form_val")
```

### File Uploads

**File** multipart [file uploads](#file_uploads)

```go
f := c.Params.Files.Get("file_name")
```

### Combined Params

All the above combined, they values are mapped in a special way.
Params is a `map[string][]string` 
Query parameters are assigned to the map first, then form 
parameters will be appended to the the query results.

For example lets say a form is posted to `foo?a=3` and the form contained 
`a=4,b=hi`. The map Params map would look like `{"a":["3","4"],"b":["hi"]}`

Finally two special groups of parameters are assigned to the map 
(overriding both Query and Forms). They are the [URL :parameters](routing.html) as specified
in the `route` file, and the [Fixed Paramaters](routing.html) as specified in the `route` file 
as well.
```go
c.Params.Get("foo")
```
### JSON Data

Posted JSON data is read when the http header ContentType is `application/json` 
or `text/json`. The raw bytes are stored in the `Param.JSON []byte`  

JSON data will be automatically unmarshalled to the first structure or map that is 
encountered in the [Action Argument](routing.md).

When calling `c.Params.Bind(target,paramname)`, JSON data is always ignored, you can call
`c.Params.BindJSON(target)` to bind the JSON data to the specified object. You must pass
a pointer to the `c.Params.BindJSON(target)` function. 

```go
func (c Hotels) Show() revel.Result {
    var jsonData map[string]interface{}
    c.Params.BindJSON(&jsonData)
    ...
}
```


**Important:**

- All params except `File` are golang's native [url.Values](http://www.golang.org/pkg/net/url/#Values) which provide the accessors.
- All values are map to slices, a `.Get()` will return first. Use map directly to get at multiple values.
- Revel's data-binding mechanisms helps with non-string values such as [dates](#date_time) or floats.
- Golang's native [url.Values](http://www.golang.org/pkg/net/url/#Values) provides accessors for simple values.

## Action arguments

Parameters may be accepted directly as method arguments by the action.  For
example:

```go
func (c AppController) DoWork(name string, ids []int, user User, img []byte) revel.Result {
	...
}
```

- Before invoking the action (in this case the AppController.DoWork method), 
Revel asks its Binder to convert parameters of those names to the requested data type.  
- If the binding is unsuccessful for any reason, the parameter will have the zero value for its type.


<a name="binder"></a>

## Binder

- To bind a parameter to a data type, use Revel's [Binder](https://godoc.org/github.com/revel/revel#Binder).  
- The [Binder](https://godoc.org/github.com/revel/revel#Binder) is integrated with the 
[`Params`](https://godoc.org/github.com/revel/revel#Params) object.

```go
// Example params to binder
func (c SomeController) DoResponse() revel.Result {
	var ids []int
	c.Params.Bind(&ids, "ids")
	...
}
```

The following data types are supported by Revel out of the box:

* Integers of all widths
* Booleans
* Pointers to any supported type
* Slices of any supported type
* Structs
* Maps
* Maps of Structs
* time.Time for dates and times
* \*os.File, \[\]byte, io.Reader, io.ReadSeeker for file uploads

The following sections describe the syntax for these types.  It is also useful
to refer to [the source code](https://github.com/revel/revel/blob/master/binder.go) if more detail is required.

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

<div class="alert alert-warning"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> Only ordered slices should be used when binding a slice of structs:</div>

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
```go
type User struct {
    Id int
    Name string
    Friends []int
    Father User
}
func (c SomeController) Method(user *User) revel.Result {

}
```
### Maps

Maps are bound using simple dot notation:

	?user.Id=1
	&user.Name=rob
	&user.Friends[]=2
	&user.Friends[]=3
	&user.Father.Id=5
	&user.Father.Name=Harry

Will bind the map:
```go
foo := map[string]interface{}{}
c.Params.Bind(foo, "ids")

```
`foo={"user":{"Id":1,"Name":"rob","Friends":[2,3],"Father":{"Id":5,"Name":"Harry"}}}`
### Maps of Structs

If you predefine a map you can manually bind the parameter to it:

	?user.Id=1
	&user.Name=rob
	&user.Friends[]=2
	&user.Friends[]=3
	&user.Father.Id=5
	&user.Father.Name=Hermes

Will bind this map with a struct inside of it:
```go
type User struct {
    Id int
    Name string
    Friends []int
    Father User
}
map[string]interface{}
foo := map[string]*User{}{"user":&User{}}
c.Params.Bind(foo, "ids")
```
Notice how this differs from the struct example, in the struct example we defined a parameter 
of type `*User`, in behind the scenes Revel took any parameter name starting with `user` and assigned
it to the struct. In this example we define a map and a precreated struct instance of `User`. If we 
did not precreate this instance Revel would have populated a map within the map.  

<div class="alert alert-warning"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> Properties must be exported in order to be bound.</div>

<a name="date_time"></a>

### Date / Time

- The SQL standard date time formats of `2006-01-02`, `2006-01-02 15:04` are built in.
- Alternative formats may be added to the application (see [app.conf](appconf.html#formatting)), using [golang native constants](http://golang.org/pkg/time/#pkg-constants).  
- Add a pattern to recognize to the [TimeFormats](https://godoc.org/github.com/revel/revel#TimeFormats) variable, like the example below.

```go
func init() {
    revel.TimeFormats = append(revel.TimeFormats, "01/02/2006")
}
```


<a name="file_uploads"></a>

### File Uploads

File uploads can be bound to any of the following types:

* \*os.File
* \[\]byte
* io.Reader
* io.ReadSeeker

This is a wrapper around the upload handling provided by
[Go's multipart package](http://golang.org/pkg/mime/multipart/).  The bytes
stay in memory unless they exceed a threshold (10MB by default), in which case
they are written to a temp file.

- See the [upload sample app](https://github.com/revel/examples/tree/master/upload)

<div class="alert alert-warning"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> Binding a file upload to <i>os.File</i> requires Revel to write it to a
temp file (if it wasn't already), making it less efficient than the other types.</div>

### Custom Binders

The application may define its own binders to take advantage of this framework.

It needs only to implement the [Binder](https://godoc.org/github.com/revel/revel#Binder) `interface` and register the type for which it
should be called:

```go
var myBinder = revel.Binder{
	Bind: func(params *revel.Params, name string, typ reflect.Type) reflect.Value {...},
	Unbind: func(output map[string]string, name string, val interface{}) {...},
}

func init() {
	revel.TypeBinders[reflect.TypeOf(MyType{})] = myBinder
}
```

