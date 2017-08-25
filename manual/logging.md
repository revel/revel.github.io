---
title: Logging
layout: manual
github:
  labels:
    - topic-log
godoc:
    - AppLog
    - RevelLog
---

When logging in Revel you should use the [controller.Log](https://godoc.org/github.com/revel/revel#Controller)
If you have services running in the background you should use the [revel.AppLog](https://godoc.org/github.com/revel/revel#AppLog)

**Internally Revel uses [log15](https://github.com/inconshreveable/log15) to do the core work, more
information about the log handlers can be found there.**  

Below is the logger interface.
```go
	MultiLogger interface {
		// New returns a new Logger that has this logger's context plus the given context
		New(ctx ...interface{}) MultiLogger

		// SetHandler updates the logger to write records to the specified handler.
		SetHandler(h LogHandler)

		Debug(msg string, ctx ...interface{})
		Debugf(msg string, params ...interface{})
		Info(msg string, ctx ...interface{})
		Infof(msg string, params ...interface{})
		Warn(msg string, ctx ...interface{})
		Warnf(msg string, params ...interface{})
		Error(msg string, ctx ...interface{})
		Errorf(msg string, params ...interface{})
		Crit(msg string, ctx ...interface{})
		Critf(msg string, params ...interface{})

		//// Logs a message as an Crit and exits
		Fatal(msg string, ctx ...interface{})
		Fatalf(msg string, params ...interface{})
		//// Logs a message as an Crit and panics
		Panic(msg string, ctx ...interface{})
		Panicf(msg string, params ...interface{})
	}

```   

###Usage  

####Log Contexts
Logging using these `Debug,Info,Warn,Error,Crit` methods will expect the 
message values in key value pairs. For example `revel.AppLog.Debug("Hi there")` 
is fine `revel.AppLog.Debug("Hi there", 25)` will panic (only passed one argument for
 the context). `revel.AppLog.Debug("Hi there","age",25,"sex","yes","state",254)` is fine. 
 This will produce a log message that includes the context age,sex,state like .
```go
INFO 2017/08/02 22:31:41 test.go:168: Hi There                           age=25 sex=yes state=254
```
or in json like
```json
{"caller":"test.go:168","lvl":3,"t":"2017-08-02T22:34:08.303112145-07:00", 
"age":25,"sex":"yes","state":254}
```
If you want you can fork a new log from the control logger to continue using in your code or to pass to the model - consider this
```go

func (c *FooController) Edit(id int) revel.Result {
  log := c.Log.New("id",id)
  log.Debug("Reading the output")
  output,err := model.Load(log, id)
  if err!=nil {
    log.Errorf("Failed to load :%s",err.Error())
  }
  ...
}
```
Could produce the following output (if an error occurred)
```ini
INFO 22:31:41 app test.go:168: Reading the output                                id=25
ERROR 22:31:41 app test.go:168: Failed to load: Not Found                        id=25

```

####Log formats
Logging using these `Debugf,Infof,Warnf,Errorf,Critf` methods allows you to output a formatted string for the message. like
`revel.AppLog.Debugf("Hi %s ", "Grace")`. Only existing contexts will be applied to them. For example look at the log.Errorf below 
```go

func (c *FooController) Edit(id int) revel.Result {
  log := c.Log.New("id",id)
  log.Debug("Reading the output")
  output,err := model.Load(log, id)
  if err!=nil {
    log.Errorf("Failed to load :%s",err.Error())
  }
  ...
}
```
Could produce the following output (if an error occurred)
```ini
INFO 22:31:41 app test.go:168: Reading the output                                id=25
ERROR 22:31:41 app test.go:168: Failed to load: Not Found                        id=25

```


###App.conf
 
 Configuration examples
1) All log messages that match the filter `module=app` to stdout, 
all messages that are error messages send to stderr. Order is significant here, 
the second statement `log.error.output = stderr` replaces the error handler 
specified by the `log.all` of the first line. 

```ini
log.all.filter.module.app = stdout # Log all loggers for the application to the stdout
log.error.output = stderr          # Log all loggers for Revel errorws to the stderr
```


 2) Existing configurations will work as well, you can even expand on them
```ini
log.debug.output = stdout        # Outputs to the stdout
log.info.output  = myloghandler  # Outputs to the function in LogFunctionMap
log.warn.output  = stderr        # Outputs to the stderr
log.request.output = myloghandler
log.error.output = somefile/log.json          # Outputs to the file specified file using JSON format
log.error.filter.module.revel = stdout               # Filters based on context module.revel, outputs to stdout
log.error.filter.module.revel.context.route = stdout # Filters based on context module.revel, context route outputs to stdout 
log.critical.output  = stderr        # Outputs to the stderr
```

To summarize the log output can be a named function contained in `logger.LogFunctionMap`. If that
 function does not exist then it is assumed to be a file name, the file name extension will choose
 the output format. The `stderr` and `stdout` are two predefined functions which may be overriden if desired

####Filtered logging
A filtered log file can specify a series of key, values that will only be logged to if *ALL* the 
keys and values match a context in the log. For example the following will log at level error
to the stdout if the log message contains the context `module=revel`
```ini
log.error.filter.module.revel = stdout 
```
Filters are *additive*, they do not replace existing error handlers - for example in the 
following error messages that are logged with the context of `module=revel` will be sent to the
`stdout` and to the json file
```ini
log.all.output = stdout 
log.error.filter.module.revel = /var/log/revel/revel.json 
```
Filters may be empty so that you can make use the additive feature, the following sends all errors to both 
`stdout` and `all-errors.json ` 
```ini
log.all.output = stdout 
log.error.filter = /var/log/revel/all-errors.json 
```

####File logging
For file logging revel uses [lumberjack.Logger](https://github.com/natefinch/lumberjack) 
to stream the output to file. The following configuration options can be set
```ini
log.compressBackups = true # Compress the backups after rotation default true
log.maxsize = 1024         # The max file size before rotation in MB degault 10G
log.maxagelog.maxage= 14   # The max age of the file before rotation occurs default 14 days
log.maxbackups = 14        # The max number of old log files to keep default 14
```
These are global options, you can however apply unique options by 
[Customizing Log Handling](#customizing_log_handling) 


#####More configuration options
```ini
log.colorize = true   # Turns off colorization for console output
log.smallDate = true  # Outputs just the time for the terminal output
```

#####Customizing Log Handling

The following code adds a new output called stdoutjson 
```go
	logger.LogFunctionMap["stdoutjson"]=
		func(c *logger.CompositeMultiHandler, options *logger.LogOptions) {
			// Set the json formatter to os.Stdout, replace any existing handlers for the level specified
			c.SetJson(os.Stdout, options)
		}
	logger.LogFunctionMap["longtermstorage"]=
		func(c *logger.CompositeMultiHandler, options *logger.LogOptions) {
			options.SetExtendedOptions("maxAgeDays",30,"maxSizeMB",1024*10,"maxBackups",50)
			c.SetJsonFile("/var/log/revel/longterm.json", options)
		}
```
This setting in `app.conf` would activate the above logger for all log messages of level Warn
and error messages from the `module=revel`
```ini
log.warn.output = stdoutjson
log.error.filter.module.revel = longtermstorage 
``` 

*It is important to note that your logger function may be called with a `nil` `options.Ctx` 
 (this is the `revel.Config`).*

#####The special cases 
 - `log.request.output` assigns a handler for messages which are on the info channel and have the 
`section=requestlog` assigned to them. If `log.request.output` is not specified then messages will
be logged directly to the same handler handling the `info` log level. 
 
 - `log.trace` usage in initialization files is deprecated and replace by `log.debug`
 - If `log.critical` is not specified and `log.error` has been. Then the error handler 
 will receive the critical messages as well

 

####Deprecated Logs
The following loggers are deprecated, the will continue to function but will output something like this 
`INFO  22:16:10    app harness.go:190: * LOG DEPRECATED * Listening on :9000    module=app section=deprecated `
```go
revel.TRACE
revel.INFO
revel.WARN
revel.ERROR
```


#### Internal structure

Revel provides a single root logger called [revel.RootLog](https://godoc.org/github.com/revel/revel#RootLog). 
The logger is forked into the following loggers
 - [revel.RevelLog](https://godoc.org/github.com/revel/revel#AppLog) Contains context of `module=revel`
 - [revel.AppLog](https://godoc.org/github.com/revel/revel#AppLog) Contains context of `module=app`
 - [module.Log](https://godoc.org/github.com/revel/revel#Module) on Startup of revel, 
 it contains the context of `module=modulename`.

[revel.AppLog](https://godoc.org/github.com/revel/revel#AppLog) is forked to create a logger for 
 - [controller.Log](https://godoc.org/github.com/revel/revel#Controller)  
 A new instance is created on every request, and contains context information like, 
        the source ip, request path and request method. 
        **If the controller handling the response is from a module it will be forked from 
        [module.Log](https://godoc.org/github.com/revel/revel#Module)**

####Request logger
Sample format: terminal format
```ini
log.request.output = stdout
```
be logged directly to the same handler handling the `info` log level. 


	INFO 2017/08/02 22:31:41 server-engine.go:168: Request Stats                            ip=::1 path=/public/img/favicon.png method=GET action=Static.Serve namespace=static\\ start=2017/08/02 22:31:41 status=200 duration_seconds=0.0007656

JSON Format
```ini
log.request.output = /var/log/revel/requestlog.json
```

	{"action":"Static.Serve","caller":"server-engine.go:168","duration_seconds":0.00058336,"ip":"::1","lvl":3,
	 "method":"GET","msg":"Request Stats","namespace":"static\\","path":"/public/img/favicon.png",
	 "start":"2017-08-02T22:34:08-0700","status":200,"t":"2017-08-02T22:34:08.303112145-07:00"}

<hr>
- Issues tagged with [`log`](https://github.com/revel/revel/labels/topic-log)
