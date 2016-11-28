---
layout: quickstart
title: Controllers
--- 

A `Controller` is a container for the request actions. You could have every request tied to an action (function) in one controller
but a better practice would be to divide the work up amongst controllers in a logical manner, 
refer to the hotel application for an example.


## Coding Rules
Two important rules, the **Controller** must be the first type when defined in a file, the following example the `Foo`
controller will not be found
{% highlight go %}
type (
	Bar struct {
		*revel.Controller
	}
	Foo struct {
		*revel.Controller
	}
)
{% endhighlight %}

Coded properly it would be like this
{% highlight go %}
type (
	Bar struct {
		*revel.Controller
	}
)
type (
	Foo struct {
		*revel.Controller
	}
)
{% endhighlight %}

or this
{% highlight go %}
type Bar struct {
	*revel.Controller
}
type Foo struct {
	*revel.Controller
}
{% endhighlight %}


- The second rule is that a controller can only exist in a folder called *controllers/*
- If you intend to extend all your controllers from a common one make sure that the common one exists in a folder called *controllers/* as well, or none of your controllers will be found

## Extending the Controller
A **Controller** is any type that embeds `*revel.Controller` (directly or indirectly).
This means controllers may extend other classes, here is an example on how to do that. Note in the *MyController* the 
*BaseController* reference is NOT a pointer
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
