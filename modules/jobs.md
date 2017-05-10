---
title: Schedules Jobs
layout: modules
github:
  labels:
    - topic-jobs
    - topic-runtime
---

The Revel [`Jobs`](https://godoc.org/github.com/revel/modules/jobs/app/jobs) module 
enables performing tasks asynchronously, outside of the request flow.

A **job** is either:
- [Recurring](#RecurringJobs), e.g. generating a daily report
- [One-off](#OneOffJobs), e.g. sending emails, updating a ledger, or creating a cache

## Config

The [`Jobs`](https://godoc.org/github.com/revel/modules/jobs/app/jobs) module
is optional **not** enabled by default. 

To activate add `module.jobs` to the [app.conf](/manual/appconf.html) file:

```ini
module.jobs = github.com/revel/modules/jobs
```

Additionally, in order to access the job monitoring page, you will need to add the module's routes to your app's `conf/routes`:

```
module:jobs
```

## Options

There are some [configuration settings](/manual/appconf.html#jobs) that place some limitations
job and its run, explained below with default values:

- [`jobs.pool = 10`](/manual/appconf.html#jobspool) - The number of jobs allowed to run simultaneously/concurrently
- [`jobs.selfconcurrent = false`](/manual/appconf.html#jobsselfconcurrent) - Allow a job to run only if previous instances are done
- [`jobs.acceptproxyaddress = false`](/manual/appconf#jobsacceptproxyaddress) - Accept `X-Forwarded-For` header value (which is spoofable) to allow or deny status page access

## Implementing Jobs

To create a Job, implement the [`cron.Job`]( https://github.com/revel/cron/blob/master/cron.go) interface.  The 
[`Job`](https://godoc.org/github.com/revel/modules/jobs/app/jobs#Job) interface has the following signature:

{% highlight go %}
type Job interface {
	Run()
}
{% endhighlight %}

For example:

{% highlight go %}
type MyJob struct {}

func (j MyJob) Run() {
   // Do something
}
{% endhighlight %}

## Startup Jobs

To run a task on application startup, use
[`revel.OnAppStart()`](https://godoc.org/github.com/revel/revel#OnAppStart) to register a function.
Revel runs these tasks serially, before starting the server.  Note that this
functionality does not actually use the jobs module, but it can be used to
submit a job for execution that doesn't block server startup.

{% highlight go %}
func init() {
    revel.OnAppStart(func() { jobs.Now(populateCache{}) })
}
{% endhighlight %}

<a name="RecurringJobs"></a>

## Recurring Jobs

Jobs may be scheduled to run on any schedule.  There are two options for expressing the schedule:

1. A cron specification
2. A fixed interval

Revel uses the [`cron`](https://godoc.org/github.com/revel/cron) to parse the
schedule and run the jobs.  The library provides a detailed description of the format accepted.

It's recommended thatJobs are registered using the
[`revel.OnAppStart()`](https://godoc.org/github.com/revel/revel#OnAppStart) hook, but they may be
registered at any later time.

Here are some examples:

{% highlight go %}
import (
    "time"
    
    "github.com/revel/revel"
    "github.com/revel/modules/jobs/app/jobs"
)

type ReminderEmails struct {
    // Filtered
}

func (e ReminderEmails) Run() {
    // Queries the DB
    // Sends some email
}

func init() {
    revel.OnAppStart(func() {
        jobs.Schedule("0 0 0 * * ?",  ReminderEmails{})
        jobs.Schedule("@midnight",    ReminderEmails{})
        jobs.Schedule("@every 24h",   ReminderEmails{})
        jobs.Every(24 * time.Hour,    ReminderEmails{})
    })
}
{% endhighlight %}

<a name="NamedSchedules"></a>

## Named Schedules

You can [define cron schedules](/manual/appconf.html#jobs) in your app's [`app.conf`](/manual/appconf.html) and reference them anywhere for easy reuse.

Simply define your **named cron schedule**:

    cron.workhours_15m = 0 */15 9-17 ? * MON-FRI

Then, reference it anywhere you would have used a cron spec.

{% highlight go %}
func init() {
    revel.OnAppStart(func() {
        jobs.Schedule("cron.workhours_15m", ReminderEmails{})
    })
}
{% endhighlight %}

<div class="alert alert-warning">
<b>IMPORTANT</b>: The schedule's name must begin with <b>`cron.`</b>.

</div>


<a name="OneOffJobs"></a>

## One-off Jobs

The jobs module allows you to schedule a job to be run once. You can control how long to wait before the job runs.

{% highlight go %}
type AppController struct { *revel.Controller }

func (c AppController) Action() revel.Result {
    // Handle the request.
    ...

    // Send them email asynchronously, right now.
    jobs.Now(SendConfirmationEmail{})

    // Or, send them email asynchronously after a minute.
    jobs.In(time.Minute, SendConfirmationEmail{})
}
{% endhighlight %}

## Registering Job Functions

It is possible to register any `func()` as a job by wrapping it in the [`jobs.Func`](https://godoc.org/github.com/revel/modules/jobs/app/jobs#Func) type.

{% highlight go %}
func sendReminderEmails() {
    // Query the DB
    // Send some email
}

func init() {
    revel.OnAppStart(func() {
        jobs.Schedule("@midnight", jobs.Func(sendReminderEmails))
    })
}
{% endhighlight %}


## Job Status

The jobs module provides a status page (`/@jobs` url) that shows:

- a list of the scheduled jobs
- the current status (**IDLE** or **RUNNING**)
- the previous and next run times

<div class="alert alert-info">For security purposes, the status page is limited to requests that originate
from 127.0.0.1.</div>

![Job Status Page](../img/jobs-status.png)



## Constrained Pool Size

It's possible to configure the job module to limit the number of jobs that are
allowed to run at the same time. This allows the developer to restrict the
resources that could be potentially in use by asynchronous jobs -- typically
interactive responsiveness is valued above asynchronous processing. When a pool
is full of running jobs, new jobs block to wait for running jobs to complete.

**Implementation Note**: The implementation blocks on a channel receive, which is
implemented to be [FIFO](http://en.wikipedia.org/wiki/FIFO) for waiting goroutines (but not specified/required to be
so). [See here for discussion](https://groups.google.com/forum/?fromgroups=#!topic/golang-nuts/CPwv8WlqKag).

## Future areas for development

* Allow access to the job status page with HTTP Basic Authentication credentials
* Allow administrators to run scheduled jobs interactively from the status page
* Provide more visibility into the job runner, e.g. the pool size, the job queue length, etc.
