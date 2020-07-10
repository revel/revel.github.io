---
title: Session / Flash Scopes
layout: manual
github:
  labels:
    - topic-session
godoc: 
    - Session
    - Flash
---

Revel provides  [Flash](#flash) cookie based method to set temporary transient data. It also
provides [Session](#session) backed data to provide persistent user state data.

```go

// A signed cookie, and thus limited to 4kb in size.
// Restriction: Keys may not have a colon in them.
type Session map[string]string

// Flash represents a cookie that gets overwritten on each request.
// It allows data to be stored across one page at a time.
// This is commonly used to implement success or error messages.
// e.g. the Post/Redirect/Get pattern: http://en.wikipedia.org/wiki/Post/Redirect/Get
type Flash struct {
	Data, Out map[string]string
}
```

NOTE: To set your own cookie, use [Controller.SetCookie()](https://godoc.org/github.com/revel/revel#Controller.SetCookie)
```go
func (c MyController) MyMethod() revel.Result {
    new_cookie := &http.Cookie{Name: "foo", Value: "Bar"}
    c.SetCookie(new_cookie)
    return c.Render()
}
```

<a name="session"></a>

## Session
 [revel.Session](https://godoc.org/github.com/revel/revel/session#Session) is a 
map[string]interface{}. By default you can still interact with string data as if it was
a map[string]string. If you store objects in the session they must be able to convert to
JSON and you must use the [revel.Session.Get()](https://godoc.org/github.com/revel/revel/session#Session.Get)
function to extract the data. The `Session.Get` call will automatically inflate the object 
if it exists in the map. The inflated result will be a `map[string]interface{}`. You can
also do a [revel.Session.GetInto()](https://godoc.org/github.com/revel/revel/session#Session.GetInto)
passing a reference to the object you want inflated. and it will populate that object if 
it exists. If the session object does not exist, a [SESSION_VALUE_NOT_FOUND](https://godoc.org/github.com/revel/revel/session#pkg-variables)
error is returned.

The default session engine is the [revel-cookie engine](/manual/session-engine#cookie) 

```go
func (c MyController) getUser(username string) models.User {
	user = &models.User{}
	_,  err := c.Session.GetInto("fulluser", user, false)
	if err==nil && user.Username == username {
		return user
	}
	// more
	
}

func (c MyController) MyMethod() revel.Result {

    c.Session["foo"] = "bar"
    c.Session["bar"] = 1 
    delete(c.Session, "abc") // Removed item from session
    return c.Render()
}


```






## Flash

The Flash provides single-use string storage. It is useful for implementing
[the Post/Redirect/Get pattern](http://en.wikipedia.org/wiki/Post/Redirect/Get),
or for transient "Operation Successful!" or "Operation Failed!" messages.

Here's an example of that pattern:

```go
// Show the Settings form
func (c App) ShowSettings() revel.Result {
	return c.Render()
}

// Process a post
func (c App) SaveSettings(setting string) revel.Result {
    // Make sure `setting` is provided and not empty
    c.Validation.Required(setting)
    if c.Validation.HasErrors() {
        // Sets the flash parameter `error` which will be sent by a flash cookie
        c.Flash.Error("Settings invalid!")
        // Keep the validation error from above by setting a flash cookie
        c.Validation.Keep()
        // Copies all given parameters (URL, Form, Multipart) to the flash cookie
        c.FlashParams()
        return c.Redirect(App.ShowSettings)
    }
    saveSetting(setting)
    // Sets the flash cookie to contain a success string
    c.Flash.Success("Settings saved!")
    return c.Redirect(App.ShowSettings)
}
```

Walking through this example:

1. User fetches the settings page.
2. User posts a setting (POST)
3. Application processes the request, saves an error or success message to the flash, and redirects the user to the settings page (REDIRECT)
4. User fetches the settings page, whose template shows the flashed message. (GET)

It uses two convenience functions:

1. `Flash.Success(message string)` is an abbreviation of `Flash.Out["success"] = message`
2. `Flash.Error(message string)` is an abbreviation of `Flash.Out["error"] = message`

Flash messages may be referenced by key in [templates](templates.html).  For example, to access
the success and error messages set by the convenience functions, use these
expressions:

{% capture ex %}{% raw %}
{{.flash.success}}
{{.flash.error}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

Here is a second scenario where you want the flash variables returned without using a
redirect

```go
func (c Controller) Submit(Input UserName) revel.Result {
    Input.Validate(c.Validation);
    if c.Validation.HasErrors() {

        data := map[string]string{}
        for key, vals := range c.Params.Values {
            data[key] = strings.Join(vals, ",")
        }
        c.RenderArgs["flash"] =  data

        // Display input page
        return c.RenderTemplate("test.html")
    }
    ...
    }
```

