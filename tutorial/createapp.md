---
title: Creating a new Revel application
layout: tutorial
---

Use the [`revel`](/manual/tool.html#mew) command line tool to create a new application in your GOPATH and run it:
```commandline

$ export GOPATH="/home/me/gostuff"
$ cd $GOPATH
$ revel new myapp
Revel executing: create a skeleton Revel application
Your application has been created in:
   /home/me/gostuff/myapp

You can run it with:
   revel run -a  myapp

$ revel run -a myapp
Revel executing: run a Revel application
WARN  11:21:51 harness.go:170: No http.addr specified in the app.conf listening on localhost interface only. This will not allow external access to your application 
INFO  11:21:52    app     run.go:32: Running revel server                      
INFO  11:21:52    app   plugin.go:9: Go to /@tests to run the tests.           
Revel engine is listening on.. localhost:40935
Revel proxy is listening, point your browser to : 9000
```

*Notes* When you run an application through the command line tool `revel` it is run as a proxy
that is why you see the revel engine is listening on port X and Revel proxy is listening on 
port Y


Open your browser to [http://localhost:9000/](http://localhost:9000/) to see a notification that your app is ready.

![Your Application Is Ready](/img/YourApplicationIsReady.png)

- The generated project structure is described in [organization](/manual/organization.html)
- The HTTP port settings is in [`conf/app.conf`](/manual/appconf.html#httpport)
- There are a number of additional commands that can be run for revel see the  [Revel tool document](/manual/tool.html) for a complete list 


<a href="requestflow.html" class="btn btn-sm btn-success" role="button">Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a> [How Revel handles requests.](requestflow.html)
