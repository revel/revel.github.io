---
title: Templates
layout: manual
github:
  labels:
    - topic-template
    - topic-controller
godoc:
    - Template
---

`Revel` uses Go's built in [html/template](http://golang.org/pkg/html/template/) 
package, and Hot Topic 
is [different templating engines](https://github.com/revel/revel/projects/1)


Directories and scanned for templates in the follosing order:

1. The application `app/views/` directory and subdirectories.
2. revel core `templates/` directory.
3. Otherwise a `500` error as template not found (but in [dev mode](appconf.html#run-modes) shows debug info)

For example, given a controller/action `Hello.World()`, Revel will:

- look for a template file named `views/Hello/World.html`.
- and if not found, show `views/errors/500.html`
- and if that's not found, use Revel's built-in `templates/errors/500.html`

Template file names are case insensitive so the following will be treated as the same:

- `views/hello/world.html`
- `views/HeLlO/wOrLd.HtMl`

However, on `**nix` based file systems (and for example with `index.html` and `IndeX.html`), duplicate cased file names are
to be avoided as its unpredictable which one will be considered.

Revel provides templates for error pages ([see code](https://github.com/revel/revel/tree/master/templates/errors))  and
these display the developer friendly compilation errors in [dev mode](appconf.html#run-modes). An
application may override them by creating a template of the equivalent template name, e.g. `app/views/errors/404.html`.

#### Template Delimiters

Revel provides configurable [Template Delimiters](appconf.html#templates) via `app.conf`.

## Render Context

Revel executes the template using the [`RenderArgs`](https://godoc.org/github.com/revel/revel#Controller.RenderArgs) data `map[string]interface{}`.  Aside from
application-provided data, Revel provides the following entries:

* **errors** - the map returned by
  [`Validation.ErrorMap`](https://godoc.org/github.com/revel/revel#Validation.ErrorMap) (see [validation](validation.html))
* **flash** - the data [flashed](sessionflash.html#flash) by the previous request.

## Including Other Templates

Go Templates allow you to compose templates by inclusion.  For example:

{% capture ex %}{% raw %}
{{template "header.html" .}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

<div class="alert alert-info">Note: Paths are relative to <code>app/views</code></div>


<a name="functions"></a>

## Template Functions

- Go provides a few native [template functions](http://golang.org/pkg/html/template/#pkg-index).
- Revel adds to those. Read the documentation below or [check out the source code](https://godoc.org/github.com/revel/revel#pkg-variables).
    - [`append`](#append)
    - [`checkbox`](#checkbox)
    - [`date`](#date), [`datetime`](#datetime)
    - [`even`](#even)
    - [`field`](#field)
    - [`msg`](#msg)
    - [`nl2br`](#nl2br)
    - [`option`](#option)
    - [`pad`](#pad)
    - [`pluralize`](#pluralize)
    - [`radio`](#radio)
    - [`raw`](#raw)
    - [`set`](#set)
    - [`url`](#url)
    - [Custom Functions](#CustomFunctions)







<a name="append"></a>

### append

Add a variable to an array, or create an array; in the given context.

{% capture ex %}{% raw %}
{{append . "moreScripts" "js/jquery-ui-1.7.2.custom.min.js"}}

{{range .moreStyles}}
    <link rel="stylesheet" type="text/css" href="/public/{{.}}">
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="checkbox"></a>

### checkbox

Assists in constructing a HTML checkbox `input` element, eg:

{% capture ex %}{% raw %}
{{with $checkboxField := field "testField" .}}
    {{checkbox $checkboxField "someValue"}}
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="date"></a><a name="datetime"></a>

### date, datetime

Format a date according to the application's default [date](appconf.html#formatdate) and [datetime](appconf.html#formatdatetime) format.

The example below assumes `dateArg := time.Now()`:

{% capture ex %}{% raw %}
{{date .MyDate}}
{{datetime .MyDateTime}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="even"></a>

### even

Perform `$in % 2 == 0`. This is a convenience function that assists with table row coloring.

{% capture ex %}{% raw %}

{{range $index, $element := .results}}
<tr class="{{if even $index}}light-row{{else}}dark-row{{end}}">
    ...
</tr>
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}



<a name="field"></a>

### field

A helper for input fields [godoc](https://godoc.org/github.com/revel/revel#Field).

Given a field name, it returns a struct containing the following members:

* **Id**: the field name, converted to be suitable as a HTML element ID.
* **Name**: the field name
* **Value**: the value of the field in the current `RenderArgs`
* **Flash**: the [flash](sessionflash.html#flash) value of the field.
* **Error**: the error message, if any is associated with this field.
* **ErrorClass**: the raw string `"hasError"`, if there was an error, else `""`.

Example:

{% capture ex %}{% raw %}
{{with $field := field "booking.CheckInDate" .}}
    <p class="{{$field.ErrorClass}}">
    <strong>Check In Date:</strong>
    <input type="text" size="10" name="{{$field.Name}}"
            class="datepicker" value="{{$field.Flash}}"> *
    <span class="error">{{$field.Error}}</span>
    </p>
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}






<a name="msg"></a>

### msg
 - See [internationalization](i18n-messages.html#template)


<a name="nl2br"></a>

### nl2br

Convert newlines to HTML breaks.

{% capture ex %}{% raw %}
You said:
<div class="comment">{{nl2br .commentText}}</div>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="option"></a>

### option

Assists in constructing HTML `option` elements, in conjunction with the field
helper, eg:

{% capture ex %}{% raw %}
{{with $field := field "booking.Beds" .}}
<select name="{{$field.Name}}">
    {{option $field "1" "One king-size bed"}}
    {{option $field "2" "Two double beds"}}
    {{option $field "3" "Three beds"}}
</select>
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="pad"></a>

### pad

 Pads the given string with `&nbsp;`  to the given width, eg:.

{% capture ex %}{% raw %}
{{pad "my string", 8}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="pluralize"></a>

### pluralize

A helper for correctly pluralizing words.

{% capture ex %}{% raw %}
There are {{.numComments}} comment{{pluralize (len comments) "" "s"}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

<a name="radio"></a>

### radio

Assists in constructing HTML radio `input` elements, in conjunction with the field
helper, eg:

{% capture ex %}{% raw %}
{{with $field := field "booking.Smoking" .}}
    {{radio $field "true"}} Smoking
    {{radio $field "false"}} Non smoking
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

<a name="raw"></a>

### raw

Prints raw, unescaped, text.

{% capture ex %}{% raw %}
<div class="body">{{raw .blogBody}}</div>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

<a name="set"></a>

### set

Set a variable in the given context.

{% capture ex %}{% raw %}
{{set . "title" "Basic Chat room"}}

<h1>{{.title}}</h1>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


<a name="slug"></a>

### slug

 Create a slug

{% capture ex %}{% raw %}
{{slug "SomeThing String"}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}




<a name="url"></a>

### url

Outputs the [reverse route](routing.html#reverse-routing) for a `Controller.Action`, eg:

{% capture ex %}{% raw %}
<a href="{{url "MyApp.ContactPage"}}">Contact</a>
Click <a href="{{url "Products.ShowProduct" 123}}">here</a> for more.
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

<a name="CustomFunctions"></a>

## Custom Functions

Applications may register custom functions for use in templates.

Here is an example:

{% highlight go %}
func init() {
    revel.TemplateFuncs["my_eq"] = func(a, b interface{}) bool {
        return a == 0  || a == b
    }
}
{% endhighlight %}




## Examples

The [sample applications](/examples/index.html) try to demonstrate effective use of
Go Templates.  In particular, please take a look at [Booking app](/examples/booking.html) templates:

* [`examples/booking/app/views/header.html`](https://github.com/revel/examples/blob/master/booking/app/views/header.html)
* [`examples/booking/app/views/hotels/book.html`](https://github.com/revel/examples/blob/master/booking/app/views/hotels/book.html)

It takes advantage of the helper functions to set the title and extra styles in
the template itself.

For example, the header looks like this:

{% capture ex %}{% raw %}
<html>
    <head>
    <title>{{.title}}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" media="screen" href="/public/css/main.css">
    <link rel="shortcut icon" type="image/png" href="/public/img/favicon.png">
    {{range .moreStyles}}
        <link rel="stylesheet" type="text/css" href="/public/{{.}}">
    {{end}}
    <script src="/public/js/jquery-1.3.2.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/public/js/sessvars.js" type="text/javascript" charset="utf-8"></script>
    {{range .moreScripts}}
        <script src="/public/{{.}}" type="text/javascript" charset="utf-8"></script>
    {{end}}
    </head>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

And templates that include it look like this:

{% capture ex %}{% raw %}
{{set . "title" "Hotels"}}
{{append . "moreStyles" "ui-lightness/jquery-ui-1.7.2.custom.css"}}
{{append . "moreScripts" "js/jquery-ui-1.7.2.custom.min.js"}}
{{template "header.html" .}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}


