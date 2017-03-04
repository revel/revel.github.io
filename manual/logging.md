---
title: Logging
layout: manual
gh_labels:
- topic-logging

---

Revel provides four loggers:

* [TRACE](https://godoc.org/github.com/revel/revel#TRACE) - debugging information only.
* [INFO](https://godoc.org/github.com/revel/revel#INFO) - informational.
* [WARN](https://godoc.org/github.com/revel/revel#WARN) - something unexpected but not harmful.
* [ERROR](https://godoc.org/github.com/revel/revel#ERROR) - someone should take a look at this.

Example usage:
{% highlight go %}
now := time.Now()
revel.TRACE.Printf("%s", now.String())
{% endhighlight %}
Each of these is a variable to a default [go logger](http://golang.org/pkg/log/).

Loggers may be configured in [app.conf](appconf.html#Logging).  Here is an example:
{% highlight ini %}
app.name = sampleapp

[dev]
log.trace.output = stdout
log.info.output  = stdout
log.warn.output  = stderr
log.error.output = stderr

log.trace.prefix = "TRACE "
log.info.prefix  = "INFO  "

log.trace.flags  = 10
log.info.flags   = 10

[prod]
log.trace.output = off
log.info.output  = off
log.warn.output  = log/%(app.name)s.log
log.error.output = log/%(app.name)s.log
{% endhighlight %}

In **dev** mode:

* even the most detailed logs will be shown.
* everything logged at **info** or **trace** will be prefixed with its logging
level.
* default logger flag is 19 (`Ldate|Ltime|Lshortfile`)

In **prod** mode:

* **info** and **trace** logs are ignored.
* both warnings and errors are appended to the **log/sampleapp.log** file.
* default logger flag is 3 (`Ldate|Ltime`)

To specify logger flags, you must calculate the flag value from
[the flag constants](http://www.golang.org/pkg/log/#constants).  For example, to
the format `01:23:23 /a/b/c/d.go:23 Message` requires the flags
`Ltime | Llongfile = 2 | 8 = 10`.

Note: Revel creates the log directory if it does not already exists and if it's not a absolute path then it prefix the Revel base path.

For example:
{% highlight ini %}
#Revel Base Path:
/srv/www/sampleapp

# and log config is
log.warn.output  = log/%(app.name)s.log

# Result of log location is
/srv/www/myapp/log/sampleapp.log
{% endhighlight %}

### Turn Off Colorize

Revel provides a way to turn of the colorize in the logger.

{% highlight ini %}
log.colorize = false
{% endhighlight %}

Default: true

### Request Access Log

Revel provides request access log since v0.13, you can set the output via`app.conf`. Request log will have following values of RequestStartTime, ClientIP, ResponseStatus, RequestLatency, HTTPMethod and URLPath.

Sample output:
{% highlight sh %}
2016/05/25 18:17:17.806 127.0.0.1 200  162.269µs GET /
2016/05/25 18:17:17.810 127.0.0.1 200  204.896µs GET /public/css/bootstrap.css
2016/05/25 18:17:17.811 127.0.0.1 200  108.862µs GET /public/js/jquery-1.9.1.min.js
{% endhighlight %}

For Example:

{% highlight ini %}
log.request.output = log/%(app.name)s-request.log
{% endhighlight %}

<hr>
- Issues tagged with [`log`](https://github.com/revel/revel/labels/topic-log)
