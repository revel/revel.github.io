---
title: Creating a new Revel application
layout: tutorial
---

Use the [`revel`](/manual/tool.html#mew) command line tool to create a new application in your GOPATH and run it:
```commandline

$ export GOPATH="/home/me/gostuff"
$ cd $GOPATH
$ revel new -a myapp
~
~ revel! http://revel.github.io
~
Your application is ready:
    /home/me/gostuff/src/myapp

You can run it with:
    revel run -a myapp

$ revel run -a myapp
~
~ revel! http://revel.github.io
~
Revel executing: run a Revel application
WARN  20:12:59 harness.go:114: No http.addr specified in the app.conf listening on localhost interface only. This will not allow external access to your application 
Proxy server is listening on  :9000
```

Another Example
```commandline

$ revel new -a github.com/myaccount/myapp
$ revel run -a github.com/myaccount/myapp
```
Open your browser to [http://localhost:9000/](http://localhost:9000/) to see a notification that your app is ready.

![Your Application Is Ready](/img/YourApplicationIsReady.png)

- The generated project structure is described in [organization](/manual/organization.html)
- The HTTP port settings is in [`conf/app.conf`](/manual/appconf.html#httpport)
- There are a number of additional commands that can be run for revel see the  [Revel tool document](/manual/tool.html) for a complete list 


<a href="requestflow.html" class="btn btn-sm btn-success" role="button">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a> [How Revel handles requests.](requestflow.html)
