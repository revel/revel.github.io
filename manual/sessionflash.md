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

Revel provides two cookie-based storage mechanisms for convenience, [Session](#session) and [Flash](#flash).

{% highlight go %}
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
{% endhighlight %}

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

Revel's concept of *session* is a string map, stored as a cryptographically signed cookie.

This has some implications:

* The size limit is 4kb.
* All data must be serialized to a `string` for storage.
* All data may be viewed by the user as it is **not encrypted**, but it is safe from modification.

The default lifetime of the session cookie is the browser lifetime.  This
can be overriden to a specific amount of time by setting the [session.expires](appconf.html#session.expires)
option in [conf/app.conf](appconf.html).  The format is that of
[time.ParseDuration](http://golang.org/pkg/time/#ParseDuration).

```go
func (c MyController) MyMethod() revel.Result {
    c.Session["foo"] = "bar"
    c.Session["bar"] = 1 // Error - value needs to be a string
    delete(c.Session, "abc") // Removed item from session
    return c.Render()
}
```



<a name="flash"></a>


## Flash

The Flash provides single-use string storage. It is useful for implementing
[the Post/Redirect/Get pattern](http://en.wikipedia.org/wiki/Post/Redirect/Get),
or for transient "Operation Successful!" or "Operation Failed!" messages.

Here's an example of that pattern:

{% highlight go %}
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
{% endhighlight %}

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



