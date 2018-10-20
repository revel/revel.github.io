---
title: Session Engine
layout: manual
github:
  labels:
    - topic-Session
godoc:
    - SessionEngine
---

Revel allows for building and using custom session engines; 
the process for building your own engine is as follows

### Session Engine
A session engine must implement the [`SessionEngine`](https://godoc.org/github.com/revel/revel#SessionEngine)
interface. To register a new engine in Revel :
 - Define it as a module to be loaded in the `app.conf`.
 - In the `init()` function of the engine, register the engine in revel by calling:  
`revel.RegisterSessionEngine(f func() SessionEngine, name string) `
 - Only one session engine may be active at a time you can specify the active session engine in
  the app.conf 
  `session.engine` it defaults to `revel-cookie`, which is the standard engine.

[revel.GoEngine](https://godoc.org/github.com/revel/revel#SessionCookieEngine) for some examples

### Session Cookie Engine
The session cookie engine has the following limitations

* The size limit is 4kb.
* All data must be serialized to a `string` for storage.
* All data may be viewed by the user as it is **not encrypted**, but it is safe from modification.

The default lifetime of the session cookie is the browser lifetime.  This
can be overriden to a specific amount of time by setting the [session.expires](appconf.html#session.expires)
option in [conf/app.conf](appconf.html).  The format is that of
[time.ParseDuration](http://golang.org/pkg/time/#ParseDuration).

### Helper Classes
The [revel.Session](https://godoc.org/github.com/revel/revel/session#Session) structure helps with the
encoding and decoding of session objects. It has a couple of helper functions to assist
with this.  [revel.Session.Serialize()](https://godoc.org/github.com/revel/revel/session#Session.Serialize)
this converts the data to a `map[string]string` by serializing all non string objects to JSON
There is a corresponding [revel.Session.Load()](https://godoc.org/github.com/revel/revel/session#Session.Load)
function which takes a map[string]string and loads it into this object.

