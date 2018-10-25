---
title: Revel Hooks
layout: manual
group: Reference
---
## Revel Application Start / Stop Hooks
Revel calls a set of functions, that users can register functions for, 
on startup of Revel and shutdown of Revel. For example the module/db package uses
the `OnAppStart` to open a database connection (and registers a `OnAppStop` function 
to close a database connection). On registration you can optionally pass in a priority level as
the second argument. The lowest priority gets activated first. 
 

You can register your own actions in the following way
```go
	revel.OnAppStop(func() {
		revel.RevelLog.Info("Opening the database (from module)")
		if err := Db.Close(); err != nil {
			revel.AppLog.Error("Failed to close the database", "error", err)
		}
	})

```

## Revel Module Hooks
Modules have an initialization hook that gets called after the module is loaded in Revel.
This callback passes the revel.Module object to the module so that you could perform some
additional processing on startup. The revel.Module contains a logger.Multilogger which is 
specifically initialized for the module. It is recommended to use that when logging in
modules.  
```go
func init() {
	revel.RegisterModuleInit(func(module *revel.Module) {
		moduleLogger = module.Log
		moduleLogger.Debug("Assigned Logger")
	})
}

```

## Revel Manual Shutdown
You can manually stop your Revel application by calling `revel.StopServer(nil)`.
This allows you to gracefully take down a server instance when needed. You can also
trigger a shutdown by killing the process using the interrupt level (CTRL+C or syscall.SIGINT).
Once triggered the server engine will stop processing requests and run the `OnAppStop` hooks.
This function call will block until the server is halted.
  

## Revel Event Hooks
The startup of Revel is event driven and as a developer you can tie into this process
by registration of an event handler object matching by passing a function of `revel.EventHandler`
 to `revel.AddInitEventHandler` like below


```go

	revel.AddInitEventHandler(func(event revel.Event, value interface{}) (returnType revel.EventResponse) {
		if event == revel.REVEL_BEFORE_MODULES_LOADED {
		  // Do something
		}

		return 0
	})

```

Developers can then perform specific actions based off the core Revel startup process.   

**Important** events are triggered in the same process thread, not on a separate channel, 
if you block an event Revel will not startup. 

Normally the process flow goes as follows
* REVEL_BEFORE_MODULES_LOADED
* REVEL_AFTER_MODULES_LOADED
* ENGINE_BEFORE_INITIALIZED
* TEMPLATE_REFRESH_REQUESTED (May have multiple refreshes depending on file monitoring)
* TEMPLATE_REFRESH_COMPLETED 
* (Triggered During OnAppStart)
    * ROUTE_REFRESH_REQUESTED (May have multiple refreshes depending on file monitoring)
    * ROUTE_REFRESH_COMPLETED
* ENGINE_STARTED

Shutdown can be triggered by `revel.StopServer()` which triggers a `ENGINE_SHUTDOWN_REQUEST` the
server is not shutdown until you receive a `ENGINE_SHUTDOWN` event

In the case where Revel does not start the following event is triggered
* REVEL_FAILURE