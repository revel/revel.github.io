---
title: Creating a new Revel application
layout: tutorial
---

Use the `revel` [command line tool](../manual/tool.html) to create an empty project in your GOPATH and run it:
{% highlight sh %}
$ export GOPATH="/home/me/gostuff"
$ cd $GOPATH
$ revel new myapp
~
~ revel! http://revel.github.io
~
Your application is ready:
    /home/me/gostuff/src/myapp

You can run it with:
    revel run myapp

$ revel run myapp
~
~ revel! http://revel.github.io
~
2012/09/27 17:01:54 run.go:41: Running myapp (myapp) in dev mode
2012/09/27 17:01:54 harness.go:112: Listening on :9000
{% endhighlight %}
Another Example
{% highlight sh %}
$ revel new github.com/myaccount/mynewapp
$ revel run github.com/myaccount/mynewapp
{% endhighlight %}
Open your browser to [http://localhost:9000/](http://localhost:9000/) to see a notification that your app is ready.

![Your Application Is Ready](../img/YourApplicationIsReady.png)

- The generated project structure is described in [organization](../manual/organization.html)
- The HTTP port settings is in [`conf/appconf`](../manual/appconf.html#HTTP)

**Next: [Learn how Revel handles requests.](requestflow.html)**
