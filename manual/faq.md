---
title: Frequently Asked Questions
layout: manual
---

- [Revel at StackOverflow](http://stackoverflow.com/questions/tagged/revel)

## How do I integrate existing http.Handlers with Revel ?

As shown in the [concept diagram](concepts.html), the http.Handler is where Go
hands off the user's request for processing.  Revel's handler is extraordinarily
simple, it just creates the [Controller](controllers.html) instance and passes the request to the
[Filter Chain](filters.html).

Applications may integrate existing http.Handlers by overriding the default Handler:

{% highlight go %}
func installHandlers() {
    var (
        serveMux     = http.NewServeMux()
        revelHandler = revel.Server.Handler
    )
    serveMux.Handle("/",     revelHandler)
    serveMux.Handle("/path", myHandler)
    revel.Server.Handler = serveMux
}

func init() {
    revel.OnAppStart(installHandlers)
}
{% endhighlight %}


## What is the relationship between interceptors, filters, and modules ?

1. [Modules](modules.html) are packages that can be plugged into an application. They allow
sharing of controllers, views, assets, and other code between multiple Revel
applications (or from third-party sources).

2. [Filters](filters.html) are functions that may be hooked into the request processing
pipeline.  They generally apply to the application as a whole and handle
technical concerns, orthogonal to application logic.

3. [Interceptors](interceptors.html) are a convenient way to package data and behavior, since
embedding a type imports its interceptors and fields.  This makes interceptors
useful for things like verifying the login cookie and saving that information
into a field.  Interceptors can be applied to one or more controllers.

## Hot Reload is really slow with sqlite3 ?

- The [`github.com/mattn/go-sqlite3`](https://github.com/mattn/go-sqlite3) package has a five megabyte `.c` file.
- When building the package, this `.c` file is compiled and building a 5mb `.c` takes a while.
- So unless you `go install` it. the package is built every time you build a package which depends on it.
- See [bug 290](https://github.com/revel/revel/issues/290#issuecomment-52385218)

{% raw %}
    go install github.com/mattn/go-sqlite3
{% endraw %}


## Is there an SMTP mailer ?

Revel previously had a mailer, but this was removed ([#633](https://github.com/revel/revel/pull/633))
in favour of a third party flexibility/quality/DRY. See:

- [github.com/jordan-wright/email](https://github.com/jordan-wright/email)
- [Native Go](https://github.com/golang/go/wiki/SendingMail)

