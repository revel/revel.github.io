---
title: Modules Overview
layout: manual
---

**Modules** are packages that can be plugged into an application. They allow sharing of controllers, views, assets, and 
other code between multiple Revel applications or from third-party sources.

A module should have the [same layout](organization.html#DefaultLayout) as a Revel application's layout. The "hosting" application will merge it in as follows:

1. Any templates in `module/app/views` will be added to the Template Loader search path
2. Any controllers in `module/app/controllers` will be treated as if they were in your application
3. The assets are made available, via a route action of the form `Static.ServeModule("modulename","public")`
4. Routes can be included in your application with the route line of `module:modulename` - see [routing](routing.html#modules)

Revel comes with some built in modules such as [testing](testing.html) and [jobs](jobs.html).

There is also a seperate [modules repository](https://github.com/revel/modules), although this is under development.

## Enabling a module

In order to add a module to your app, add a line to [`conf/app.conf`](appconf.html#modules):
{% highlight ini %}
module.mymodulename = go/import/path/to/module
{% endhighlight %}

An empty import path disables the module:
{% highlight ini %}
module.mymodulename =
{% endhighlight %}

For example, to enable the [test runner](testing.html) module:
{% highlight ini %}
module.testrunner = github.com/revel/modules/testrunner
{% endhighlight %}

## Routing a module
- See the [modules config](routing.html#modules) in [`app/routes`](routing.html)