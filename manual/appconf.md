---
title: app.conf
layout: manual
github:
  labels:
    - topic-config
godoc: 
    - Config
---

The application config file is at `conf/app.conf` relative to your app root. It
uses the syntax accepted by [revel/config](https://github.com/revel/config)
which is similar to [INI](http://en.wikipedia.org/wiki/INI_file) files. We'll
cover the general structure here. See [comprehensive keys](appconf-keys) for
a list of all built-in config keys and their values.

## Example

Two sections, `dev` (develop) and `prod` (production):
```ini
app.name = myapp
app.secret = pJLzyoiDe17L36mytqC912j81PfTiolHm1veQK6Grn1En3YFdB5lvEHVTwFEaWvj
http.addr =
http.port = 9000

my_stuff.foo = 1234
my_stuff.bar = Sheebang!

# Development settings
[dev]
results.pretty = true
watch = true
http.addr = 192.168.1.2

log.trace.output = off
log.info.output  = stderr
log.warn.output  = stderr
log.error.output = stderr

# Production settings
[prod]
results.pretty = false
watch = false
http.port = 9999

log.trace.output = off
log.info.output  = off
log.warn.output  = %(app.name)s.log
log.error.output = %(app.name)s.log
```

Config values can be accesed via the [revel.Config](https://godoc.org/github.com/revel/revel#Config) variable, more [below](#customproperties)

```go
driver := revel.Config.StringDefault("db.driver", "mysql")
ena := revel.Config.BoolDefault("myapp.remote.enabled", false)
```
    


## Run Modes
Each section is a **Run Mode** and selected with the [`revel run`](tool.html#run) command, eg.

    revel run bitbucket.org/mycorp/my-app dev


- The keys at the top level (eg `app`, `http`) are not within any `[section]`  and apply to all run modes (ie default).  
- This allows values to be overridden (or introduced) as required in each run mode `[section]`.
- Also not in the example above,  *keys* under the `[prod]` section applies only to `prod` mode.  
- The run mode is chosen at runtime by the argument provided to the [`revel run`](tool.html#run). eg:
  - `revel run my-app`  - will start in `dev` mode as the default
  - `revel run my-app prod` - will start with `prod` mode.

Revel creates new apps with **dev** and **prod** run modes defined, but the developer may
create any sections they wish.

### Environment variables

Besides static configuration, Revel also supports dynamic configuration by injecting
**environment variables** or the value of other parameters.

In most cases, you'll want to load sensitive values from environment variables
rather than storing them in your configuration file. The syntax for including an
environment variable is similar to the shell syntax: `${ENV_VAR_NAME}`.

### Example

```ini
app.name = chat
http.port = 9000

db.driver = ${CHAT_DB_DRIVER}
db.spec = ${CHAT_DB_SPEC}
```
Revel will then load the `CHAT_DB_DRIVER` and `CHAT_DB_SPEC` environment variables
and inject them into the config at runtime.

### Composing other parameters

To incorporate the value of one parameter into another, you can "unfold" it by using
the `%(var_name)s` syntax (note the 's' at the end).

### Example
```ini
app.name = chat
http.port = 9000

log.warn.output = %(app.name)s.log
log.error.output = %(app.name)s.log
```
Will be parsed by revel/config as:
```ini
app.name=chat
http.port=9000

log.warn.output = chat.log
log.error.output = chat.log
```

<a name="customproperties"></a>


## Custom properties

The developer may define custom keys and access them via the
`revel.Config` variable, which exposes a
[simple api](https://godoc.org/github.com/revel/revel#MergedConfig).

### Example

In your `app.conf`:

```ini
myapp.remote = 120.2.3.5
myapp.remote.enabled = true
```

In your Go code:

```go
var remoteServer string
if revel.Config.BoolDefault("myapp.remote.enabled", false) {
    remoteServer = revel.Config.StringDefault("myapp.remote", "0.0.0.0")
    DoSomethingTo( remoteServer )
}
```


## External app.conf

Since v0.13, Revel has supported loading a external `app.conf` from a given
directory. It's a convenient way to override or add config values to the
application. Please make sure `app.conf` is in the given path.

### Example

```go
age:
func init() {
    revel.ConfPaths = []string{"/etc/myapp/conf"}
}
```


<a name="BuiltinProperties"></a>

## Built-in properties

- [Application](#application)
- [HTTP](#HTTP)
- [Results](#results)
- [Internationalization](#internationalization)
- [Watch](#watch)
- [Cookies](#cookies)
- [Session](#session)
- [Templates](#templates)
- [Formatting](#formatting)
- [Database](#database)
- [Build](#build)
- [Logging](#logging)
- [Cache](#cache)
- [Jobs](#jobs)
- [Modules](#modules)
- [Error Handling](#error-handling)

<a name="application"></a>

### Application settings

#### `app.name`

The human-readable application name. This is used for some console output and
development web pages.

### Example
```ini
  app.name = Booking example application
```

Default: `Auto Generated` For example: github.com/myaccount/myrevelapp, `app.name = myrevelapp`


#### `app.secret`

The secret key used for cryptographic operations, see [`revel.Sign`](https://godoc.org/github.com/revel/revel#Sign).  
- Revel also uses it internally to sign [session](session.html) cookies.  
- Setting it to empty string disables signing and is not recommended.
- It is set to a random string when initializing a new project with [`revel new`](tool.html#new)

### Example
```ini
  app.secret = pJLzyoiDe17L36mytqC912j81PfTiolHm1veQK6Grn1En3YFdB5lvEHVTwFEaWvj
```

Default: Auto Generated random seed value

#### `app.behind.proxy`

If `true` Revel will resolve client IP address from HTTP headers `X-Forwarded-For` and `X-Real-Ip` in the order. By default Revel will get client IP address from http.Request's RemoteAddr. Set to `true` if Revel application is running behind the proxy server like nginx, haproxy, etc.

### Example
```ini
  app.behind.proxy = true
```

Default: `false`

<a name="HTTP"></a>

### HTTP settings

#### `http.port`

The port to listen on.

### Example:
```ini
  http.port = 9000
```

#### `http.addr`

The IP address on which to listen.

- On Linux, an address of 0.0.0.0 will listen on all interfaces assigned to the host
- on Windows, an empty string is silently converted to `"localhost"`
- An empty string is converted to localhost for security reasons.

Default: "localhost"


#### `harness.port`

Specifies the port for the application to listen on, when run by the harness.
For example, when the harness is running, it will listen on `http.port`, run the
application on `harness.port`, and reverse-proxy requests.  Without the harness,
the application listens on `http.port` directly.

By default, a random free port will be chosen.  This is only necessary to set
when running in an environment that restricts socket access by the program.

Default: `0`


#### `http.ssl`

If true, Revel's web server will configure itself to accept SSL connections. This
requires an X509 certificate and a key file.

Default: `false`


#### `http.sslcert`

Specifies the path to an X509 certificate file.

Default: ""


#### `http.sslkey`

Specifies the path to an X509 certificate key.

Default: ""

#### `http.timeout.read`

Read timeout specifies a time limit for `http.Server.ReadTimeout` in seconds
made by a single client. A Timeout of zero means no timeout.

### Example
```ini
  http.timeout.read = 300
```

Default: `90`

#### `http.timeout.write`

Write timeout specifies a time limit for `http.Server.WriteTimeout` in seconds
made by a single client. A Timeout of zero means no timeout.

### Example
```ini
  http.timeout.write = 120
```

Default: `60`


<a name="results"></a>

### Results

#### `results.chunked`

Determines whether the template rendering should use
[chunked encoding](en.wikipedia.org/wiki/Chunked_transfer_encoding).  Chunked
encoding can decrease the time to first byte on the client side by sending data
before the entire template has been fully rendered.

Default: `false`


#### `results.pretty`

Configures [`RenderXML`](https://godoc.org/github.com/revel/revel#Controller.RenderXML) 
and [`RenderJSON`](https://godoc.org/github.com/revel/revel#Controller.RenderJSON) 
to produce indented XML/JSON.

### Example
```ini
  results.pretty = true
```

Default: `false`



### Internationalization


#### `i18n.default_language`

Specifies the default language for messages when the requested locale is not
recognized.  If left unspecified, a dummy message is returned to those requests.

### Example
```ini
  i18n.default_language = en
```

Default: ""


#### `i18n.cookie`

Specifies the name of the cookie used to store the user's locale.

Default: `%(cookie.prefix)_LANG` (see cookie.prefix)




### Watch

Revel watches your project and supports hot-reload for a number of types of
source. To enable watching:
```ini
  watch = true
```

If `false`, nothing will be watched, regardless of the other `watch.*`
configuration keys.  (This is appropriate for production deployments)

Default: `true`

#### `watch.mode`

- If `watch.mode = "eager"`, the server starts to recompile the application every time the application's files change.
- If `watch.mode = "normal"`, the server recompiles with a request eg a browser refresh.

Default: `"normal"`

#### `watch.templates`

If `true`, Revel will watch the `views/` template directory (and sub-directories) for changes and reload them as necessary.

Default: `true`


#### `watch.routes`

If `true`, Revel will watch the [`app/routes`](routing.html) file for changes and reload as necessary.

Default: `false`


#### `watch.code`

If `true`, Revel will watch the Go code for changes and rebuild your application
as necessary.  This runs the [`harness`](#harnessport) as a reverse-proxy to the application.

All code within the application's `app/` directory, or any sub-directory is watched.

Default: `true`


### Cookies

Revel components use the following cookies by default:

* `REVEL_SESSION`
* `REVEL_LANG`
* `REVEL_FLASH`
* `REVEL_ERRORS`


#### `cookie.prefix`

Revel uses this property as the prefix for the Revel-produced cookies. This is
so that multiple REVEL applications can coexist on the same host.

### Example
```ini
  cookie.prefix = MY
```
would result in the following cookie names:

* `MY_SESSION`
* `MY_LANG`
* `MY_FLASH`
* `MY_ERRORS`

Default: `REVEL`


#### `cookie.secure`

A secure cookie has the secure attribute enabled and is only used via HTTPS,
ensuring that the cookie is always encrypted when transmitting from client to
server. This makes the cookie less likely to be exposed to cookie theft via
eavesdropping.

```ini
  cookie.secure = false
```

Default: `false` in `dev` mode, otherwise `true`


#### `cookie.samesite`

The SameSite attribute of the Set-Cookie HTTP response header allows you to declare if your cookie should be restricted to a first-party or same-site context. As of mid-2020, browsers are warning that cookies that do not have SameSite set will soon be blocked unless they also have Secure set. So once browsers start enforcing this, for local development where you are not using SSL and thus cannot use Secure, you will likely need to set `cookie.samesite` to `strict`. And where possible, it is best practice to set to `strict` in production too.

```ini
  cookie.samesite = default
  cookie.samesite = lax
  cookie.samesite = strict
  cookie.samesite = none
```

Default: `default`




### Session

#### `session.expires`

Revel uses this property to set the expiration of the [session](sessionflash.html#session) cookie.
Revel uses [ParseDuration](http://golang.org/pkg/time/#ParseDuration) to parse the string.
The default value is 30 days. It can also be set to `"session"` to allow session only
expiry. Please note that the client behaviour is dependent on browser configuration so
the result is not always guaranteed.




### Templates

#### `template.go.delimiters`

Specifies an override for the left and right delimiters used in the templates.  
The delimiters must be specified as "LEFT\_DELIMS RIGHT\_DELIMS"

Default: \{\{ \}\}




### Formatting

#### `format.date`

Specifies the default date format for the application.  Revel uses this in two places:

* Binding dates to a `time.Time` (see [parameters](parameters.html))
* Printing dates using the `date` template function (see [template funcs](templates.html))

Default: `2006-01-02`


#### `format.datetime`

Specifies the default datetime format for the application.  Revel uses this in two places:

* Binding dates to a `time.Time` (see [parameters](parameters.html))
* Printing dates using the `datetime` template function (see [template funcs](templates.html))

Default: `2006-01-02 15:04`




### Database

#### `db.import`

Specifies the import path of the desired database/sql driver for the db module.

Default: ""


#### `db.driver`

Specifies the name of the database/sql driver (used in
[`sql.Open`](http://golang.org/pkg/database/sql/#Open)).

Default: ""


#### `db.spec`

Specifies the data source name of your database/sql database (used in
[`sql.Open`](http://golang.org/pkg/database/sql/#Open)).

Default: ""



### Build

#### `build.tags`

[Build tags](http://golang.org/cmd/go/#Compile_packages_and_dependencies) to use
when building an application.

Default: ""


### Logging

See [logging](logging.html) for details.



### Cache

The [cache](cache.html) module is a simple interface to a heap or distributed cache.



#### `cache.expires`

Sets the default duration before cache entries are expired from the cache.  It
is used when the caller passes the constant `cache.DEFAULT`.

It is specified as a duration string acceptable to
[`time.ParseDuration`](http://golang.org/pkg/time/#ParseDuration)

(Presently it is not possible to specify a default of `FOREVER`)

Default: `1h` (1 hour)




#### `cache.memcached`

If true, the cache module uses [memcached](http://memcached.org) instead of the
in-memory cache.

Default: `false`



#### `cache.redis`

If true, the cache module uses [redis](http://redis.io) instead of the
in-memory cache.

Default: `false`


#### `cache.hosts`

A comma-separated list of memcached hosts.  Cache entries are automatically
sharded among available hosts using a deterministic mapping of cache key to host
name.  Hosts may be listed multiple times to increase their share of cache
space.

Default: ""

<a name="jobs"></a>


### Scheduled Jobs

The [jobs](/modules/jobs.html) module allows you to run [scheduled](/modules/jobs.html#RecurringJobs) or [ad-hoc](/modules/jobs.html#OneOff) jobs.



#### `jobs.pool`

- The number of jobs allowed to run concurrently.
- Default is `10`.
- If zero (`0`), then there is no limit imposed.

```ini
  jobs.pool = 4
```

#### `jobs.selfconcurrent`

If `true` (default is `false`), allows a job to run even if previous instances of that job are still in
progress.

```ini
  jobs.selfconcurrent = true
```


#### `jobs.acceptproxyaddress`

If `true` (default is `false`), the status page will accept the `X-Forwarded-For` header as the remote
address used to allow or deny public access. This is diabled by default as the header value can be spoofed
and therefore is not trustable. You should only use this if you are access your Revel app via a reverse
proxy (e.g. Nginx). It is not recommended to allow this is production mode due to the security implications.

```ini
  jobs.acceptproxyaddress = true
```



#### Named Schedules

[Named cron schedules](/modules/jobs.html#NamedSchedules) may be configured by setting a key of the form:
```ini
  cron.schedulename = @hourly
```
The names schedule may be referenced upon submission to the job runner. For
example:
```go
  jobs.Schedule("cron.schedulename", job)
```





### Modules

- [Modules](modules.html) may be added to an application by specifying their base import path.
- An empty import path disables the module.
```ini
  module.testrunner = github.com/revel/modules/testrunner

  ## FIXME mymodule crashes so disabled for now
  # module.mymodulename = /path/to/mymodule
  module.mymodulename =
```





### Error Handling

 - An optional value to wrap error `path` and `line` locations with a hyper link.
 - Disabled by default; does not wrap error location with link.
 - An example using Sublime Text's custom URI scheme:
```ini
  error.link = "subl://open?url=file://{% raw %}{{Path}}{% endraw %}&line={% raw %}{{Line}}{% endraw %}"
```






## Areas for development

* Allow inserting command line arguments as config values or otherwise
  specifying config values from the command line.


