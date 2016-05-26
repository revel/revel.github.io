---
title: Filters
layout: manual
---

**Filters** are the middleware and are individual functions that make up the
request processing pipeline.  They execute all of the framework's functionality.

The [`Filter`](https://godoc.org/github.com/revel/revel#Filter) `type` is a simple function:

{% highlight go %}
type Filter func(c *Controller, filterChain []Filter)
{% endhighlight %}

Each filter is responsible for pulling the next filter off of the filter chain
and invoking it. Below is the default filter stack:

{% highlight go %}
// The default set of global filters.
// Can be set in an application on initialization.
var Filters = []Filter{
	PanicFilter,             // Recover from panics and display an error page instead.
	RouterFilter,            // Use the routing table to select the right Action
	FilterConfiguringFilter, // A hook for adding or removing per-Action filters.
	ParamsFilter,            // Parse parameters into Controller.Params.
	SessionFilter,           // Restore and write the session cookie.
	FlashFilter,             // Restore and write the flash cookie.
	ValidationFilter,        // Restore kept validation errors and save new ones from cookie.
	I18nFilter,              // Resolve the requested language
	InterceptorFilter,       // Run interceptors around the action.
	CompressFilter,          // Compress the result.
	ActionInvoker,           // Invoke the action.
}
{% endhighlight %}

## Filter chain configuration

### Global configuration

Applications may configure the filter chain by **re-assigning** the [`revel.Filters`](https://godoc.org/github.com/revel/revel#Filters)
variable in `init()`. By default this will be in [`app/init.go`](https://github.com/revel/revel/blob/master/skeleton/app/init.go) for a newly
generated app.

{% highlight go %}
func init() {
	// The filters for my app
	revel.Filters = []Filter{
		PanicFilter,             // Recover from panics and display an error page instead.
		RouterFilter,            // Use the routing table to select the right Action
		FilterConfiguringFilter, // A hook for adding or removing per-Action filters.
		ParamsFilter,            // Parse parameters into Controller.Params.
		SessionFilter,           // Restore and write the session cookie.
		FlashFilter,             // Restore and write the flash cookie.
		ValidationFilter,        // Restore kept validation errors and save new ones from cookie.
		I18nFilter,              // Resolve the requested language
		InterceptorFilter,       // Run interceptors around the action.
		CompressFilter,          // Compress the result.
		ActionInvoker,           // Invoke the action.
	}
}
{% endhighlight %}

Every [`Request`](https://godoc.org/github.com/revel/revel#Request) is sent down this chain, from top to bottom.

### Per-Action configuration

Although all requests are sent down the `revel.Filters` chain, Revel also
provides a
`FilterConfigurator`,
which allows the developer to add, insert, or remove filter stages based on the
`Action` or `Controller`.

This functionality is implemented by the [`FilterConfiguringFilter`](https://godoc.org/github.com/revel/revel#FilterConfiguringFilter), itself a
filter stage.

## Implementing a Filter

### Keep the chain going

Filters are responsible for invoking the next filter to continue the request
processing.  This is generally done with an expression as shown here:

{% highlight go %}
var MyFilter = func(c *revel.Controller, fc []revel.Filter) {
	// .. do some pre-processing ..

	fc[0](c, fc[1:]) // Execute the next filter stage.

	// .. do some post-processing ..
}
{% endhighlight %}

### Getting the app Controller type

Filters receive the base [`*Controller`](https://godoc.org/github.com/revel/revel#Controller) type as an
argument, rather than the actual Controller type that was invoked.  If your
filter requires access to the actual Controller type that was invoked, it may
grab it with the following trick:

{% highlight go %}
var MyFilter = func(c *revel.Controller, fc []revel.Filter) {
	if ac, err := c.AppController.(*MyController); err == nil {
		// Have an instance of *MyController...
	}

	fc[0](c, fc[1:]) // Execute the next filter stage.
}
{% endhighlight %}

<div class="alert alert-info">
Note: this pattern is frequently an indicator that
<a href="interceptors.html"><code>interceptors</code></a> may be a better mechanism to accomplish the
desired functionality.
</div>

<hr>
- See the godocs for [`Filters`](https://godoc.org/github.com/revel/revel#Filters), [`FilterConfiguringFilter`](https://godoc.org/github.com/revel/revel#FilterConfiguringFilter)
- Issues tagged with [`filter`](https://github.com/revel/revel/labels/topic-filter)
