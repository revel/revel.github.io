---
title: Validation
layout: manual
---

Revel provides built-in functionality for validating [parameters](parameters.html). The main parts are:

* A [`Validation`](https://godoc.org/github.com/revel/revel#Validation) context collects and manages validation errors (keys and messages).
* Helper functions that checks data and put errors into the context.
* A template function that gets error messages from the [`Validation`](https://godoc.org/github.com/revel/revel#Validation) context by key.

See the [validation sample app](../samples/validation.html) for some
in-depth examples.

## Inline Error Messages

This example demonstrates field validation with inline error messages.

{% highlight go %}
func (c MyApp) SaveUser(username string) revel.Result {
	// Username (required) must be between 4 and 15 letters (inclusive).
	c.Validation.Required(username)
	c.Validation.MaxSize(username, 15)
	c.Validation.MinSize(username, 4)
	c.Validation.Match(username, regexp.MustCompile("^\\w*$"))

	if c.Validation.HasErrors() {
		// Store the validation errors in the flash context and redirect.
		c.Validation.Keep()
		c.FlashParams()
		return c.Redirect(Hotels.Settings)
	}

	// All the data checked out!
	...
}
{% endhighlight  %}

Step by step:

1. Evaluate four different conditions on `username` ([`Required`](https://godoc.org/github.com/revel/revel#Validation.Required),
   [`MinSize`](https://godoc.org/github.com/revel/revel#Validation.MinSize), 
   [`MaxSize`](https://godoc.org/github.com/revel/revel#Validation.MaxSize), [`Match`](https://godoc.org/github.com/revel/revel#Validation.Match)).
2. Each evaluation returns a [ValidationResult](https://godoc.org/github.com/revel/revel#ValidationResult). Failed `ValidationResult`'s are stored in the `Validation` context.
3. As part of building an app, Revel records the name of the variable being
   validated, and uses that as the default key in the validation context (to be looked up later).
4. [`Validation.HasErrors()`](https://godoc.org/github.com/revel/revel#Validation.HasErrors) returns `true` if the the context is non-empty.
5. [`Validation.Keep()`](https://godoc.org/github.com/revel/revel#Validation.Keep) tells Revel to serialize the `ValidationErrors` to the [Flash](sessionflash.html#Flash) cookie.
6. Revel returns a [redirect](results.html#Redirect) to the `Hotels.Settings` action.

The `Hotels.Settings` action renders a template:

{% capture ex %}{% raw %}
{{/* app/views/Hotels/Settings.html */}}
...
{{if .errors}}Please fix errors marked below!{{end}}
...
<p class="{{if .errors.username}}error{{end}}">
    Username:
    <input name="username" value="{{.flash.username}}"/>
    <span class="error">{{.errors.username.Message}}</span>
</p>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

It does three things:

1. Checks the `errors` map for the `username` key to see if that field had an error.
2. Prefills the input with the flashed `username` param value.
3. Shows the error message next to the field.  (We didn't specify any error message, but each validation function provides one by default.)

**Note:** The [`field`](templates.html#field) template helper function makes writing templates that use
the validation error framework a little more convenient.

## Top Error Messages

The template can be simplified if error messages are collected in a single place
(e.g. a big red box at the top of the screen.)

There are only two differences from the previous example:

1. We specify a `Message` instead of a `Key` on the `ValidationError`
2. We print all messages at the top of the form.

Here's the code.

{% highlight go %}
func (c MyApp) SaveUser(username string) revel.Result {
	// Username (required) must be between 4 and 15 letters (inclusive).
	c.Validation.Required(username).Message("Please enter a username")
	c.Validation.MaxSize(username, 15).Message("Username must be at most 15 characters long")
	c.Validation.MinSize(username, 4).Message("Username must be at least 4 characters long")
	c.Validation.Match(username, regexp.MustCompile("^\\w*$")).Message("Username must be all letters")

	if c.Validation.HasErrors() {
		// Store the validation errors in the flash context and redirect.
		c.Validation.Keep()
		c.FlashParams()
		return c.Redirect(Hotels.Settings)
	}

	// All the data checked out!
	...
}
{% endhighlight %}

.. and the template:

{% capture ex %}{% raw %}
{{/* app/views/Hotels/Settings.html */}}
...
{{if .errors}}
<div class="error">
    <ul>
    {{range .errors}}
        <li> {{.Message}}</li>
    {{end}}
    </ul>
</div>
{{end}}
...
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<hr>
- See the godocs for [validation.go](../docs/godoc/validation.html), [validators.go](../docs/godoc/validators.html)

