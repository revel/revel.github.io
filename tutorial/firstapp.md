---
title: The 'Hello World' app
layout: tutorial
---

This page runs through the quick exercise of implementing a "Hello World"
application.

Let's start with the **myapp** project that was [created previously](createapp.html).

Edit the **app/views/App/Index.html** template to add this form, under the
included `flash.html` template:
{% highlight html %}
<form action="/App/Hello" method="GET">
    <input type="text" name="myName" /><br/>
    <input type="submit" value="Say hello!" />
</form>
{% endhighlight %}
Refresh the page to see our work.

![The Say Hello form](../img/AlohaForm.png)

Let's try submitting that form.

![Route not found](../img/HelloRouteNotFound.png)

That makes sense.  Add the action to **app/controllers/app.go**:
{% highlight go %}
func (c App) Hello(myName string) revel.Result {
    return c.Render(myName)
}
{% endhighlight %}

Next, we have to create the view.  Create a file
**app/views/App/Hello.html**, with this content:

{% capture ex %}{% raw %}
{{set . "title" "Home"}}
{{template "header.html" .}}

<h1>Hello {{.myName}}</h1>
<a href="/">Back to form</a>

{{template "footer.html" .}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

Refresh the page, and you should see a greeting:

![Hello revel](../img/HelloRevel.png)

Lastly, let's add some validation.  The name should be required, and at least
three characters.

To do this, let's use the [validation module](../manual/validation.html).  Edit
your action in **app/controllers/app.go**:
{% highlight go %}
func (c App) Hello(myName string) revel.Result {
    c.Validation.Required(myName).Message("Your name is required!")
    c.Validation.MinSize(myName, 3).Message("Your name is not long enough!")

    if c.Validation.HasErrors() {
        c.Validation.Keep()
        c.FlashParams()
        return c.Redirect(App.Index)
    }

    return c.Render(myName)
}
{% endhighlight %}
Now it will send the user back to `Index()` if they have not entered a valid
name. Their name and the validation error are kept in the
[Flash](../manual/sessionflash.html), which is a temporary cookie.

The provided `flash.html` template will show any errors or flash messages:

{% capture ex %}{% raw %}
{{if .flash.success}}
<div class="alert alert-success">
    {{.flash.success}}
</div>
{{end}}

{{if or .errors .flash.error}}
<div class="alert alert-error">
    {{if .flash.error}}
        {{.flash.error}}
    {{end}}
    {{if .errors}}
    <ul style="margin-top:10px;">
        {{range .errors}}
            <li>{{.}}</li>
        {{end}}
    </ul>
    {{end}}
</div>
{{end}}
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

When we submit that form with a name that fails validation, we want the form to retain the bad name, so that the user can edit it before re-submitting.  Amend the form you had added to your **app/views/App/Index.html** template:

{% capture ex %}{% raw %}
<form action="/App/Hello" method="GET">
    {{with $field := field "myName" .}}
        <input type="text" name="{{$field.Name}}" value="{{$field.Flash}}"/><br/>
    {{end}}
    <input type="submit" value="Say hello!" />
</form>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

Now when we submit a single letter as our name:

![Example error](../img/HelloNameNotLongEnough.png)

Success, we got an appropriate error and our input was saved for us to edit.

<hr>
#### Next >>
- Read more the [concepts](../manual/concepts.html)
- Look at the [samples](../samples/)
