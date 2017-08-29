---
title: App Config Keys
layout: manual
github:
  labels:
    - topic-config
godoc: 
    - Config
---


This is a comprehensive list of keys and their possible values for the Revel
`app.conf` file. See [general information](appconf) for an overview on how to use the `app.conf` file.


## Harness

| Option | Default | Description   |
|---------------|----|---------------|
|`error.link` | | Link to use for errors when building |
|`harness.port` | `0` | The default port used by the harness |
|`watch.mode` | `normal` | Valid values `normal`, `eager` if eager application is rebuilt immediately when a source file is changed (instead of waiting for a new request)
|`watch.gopath` | `false` | Watch GOPAth for changes
|`watch` | `true` | Watch files for changes
|`watch.code` | `true` | Watch source code for changes

## Core application

| Option | Default | Description   |
|---------------|----|---------------|
|`app.behind.proxy` | `` | True if behind a proxy  |
|`app.name` | `` | The name of the application  |
|`app.root` | `` | The application root |
|`app.secret` | `` | The secret hashing key |
|`build.tags` | | Any build tags for the cmd tool|
|`cache.hosts` | `` | The name of the (redis) host to provide caching |
|`cache.memcached` | `false` | True if cache should be in memory |
|`cache.redis` | `false` | True if cache should be in redis |
|`cache.redis.maxidle`| `10` | The max idle time |
|`cache.redis.maxactive`| `0` | The max active time |
|`cache.redis.password` | `` | The password of the redis cache server |
|`cache.redis.protocol` | `tcp` | The protocol of the redis cache server |
|`cache.redis.timeout.connect`| `10000` | The max time to connect in ms |
|`cache.redis.timeout.read`| `5000` | The max time to read in ms |
|`cache.redis.timeout.write`| `5000` | The max time to write in ms |
|`cookie.domain` | `` | The domain of the cookie |
|`cookie.prefix` | `` | The name of the cookie prefix  |
|`cookie.secure` |  `http.ssl` | True if secure cookie |
|`format.date` | `"2006-01-02"` | The default format of date |
|`format.datetime` | `"2006-01-02 15:04"` | The default format of date time |
|`http.host`  | `localhost` | The hostname |
|`http.addr` | `` | The http address |
|`http.port` | `9000` | The http port to listen on |
|`http.timeout.read` | `0` | The time in seconds to wait for a read to finish |
|`http.timeout.write` | `0` | The time in seconds to wait for a write to finish |
|`httpmaxrequestsize` | `32M` | As implemented by the server engine |  
|`http.sslcert` | `` | The SSL Certificate path |
|`http.sslkey` | `` | The SSL Key path |
|`http.ssl` | `` | True if HTTPS should be used |
|`log.fatal.output` | `stderr` | The output of fatal messages |
|`log.error.output` | `stderr` | The output of error messages |
|`log.debug.output` | `stderr` | The output of debug messages |
|`log.info.output` | `stderr` | The output of info messages |
|`log.colorize` | `true` | True if log output should be colorized |
|`mode.dev` | `false` | True if in dev mode |
|`revel.cache.controller.stack` | `10` | The number of user controller instances to precreate (each user instance gets a Controller instance injected into it during routing)  |
|`revel.cache.controller.maxstack` | `100` | The number of instances to store and reuse |
|`revel.controller.stack` | `100` | The number of controller instances to precreate of Controllers |
|`revel.controller.maxstack` | `200` | The number of instances to store and reuse |
|`results.compressed` | `false` | Set to True if you want the compress filter to compress the results  |
|`results.chunked` | `false` | Set to True if you want the results chunked on return |
|`results.trim.html` | `false` | Set to True if you want the results trimmed (whitespace removed) |
|`results.pretty` | `false` | Set to True if you want the JSON results or XML results  prettified |
|`server.context.stack` | `100` | The number of instances to precreate of server response & request handlers |
|`server.context.maxstack` | `200` | The number of instances to store and reuse |
|`server.form.stack` | `100` | The number of instances to precreate of server multipart form objects |
|`server.form.maxstack` | `200` | The number of instances to store and reuse |
|`server.engine` | `go` | The Server Engine to use |
|`server.request.max.multipart.filesize` | `32M` | The max file size that will be accepted via upload file |
|`template.engines`| `go` | The comma delimited list of template engines to use, the first engine in the list will be the default engine |
|`watch.routes` | `true` | Watch routes file for code changes
|`watch.templates` | `true` | Watch template files for code changes

## Modules

### NewRelic Server Engine

| Option | Default | Description   |
|---------------|----|---------------|
|`app.name` | `My App` | Reporting name to newrelic | 
|`server.newrelic.license` | | Newrelic license|
|`server.newrelic.addfilter` | `true` | Inject the newrelic filter into revel.Filters automatically (or you can include it yourself by adding `NewRelicFilter` to your filter chain|

### FastHTTP Server Engine

| Option | Default | Description   |
|---------------|----|---------------|
|`server.newrelic.license` | | Newrelic license|

### Ace Template Engine

| Option | Default | Description   |
|---------------|----|---------------|
|`ace.template.path` | `lower` | Change the template case to lower, valid values `lower`,`case` invalid values assume `lower` | 

### Pongo2 Template Engine

| Option | Default | Description   |
|---------------|----|---------------|
|`pongo2.template.path` | `lower` | Change the template case to lower, valid values `lower`,`case` invalid values assume `lower` | 

### Go Template Engine

| Option | Default | Description   |
|---------------|----|---------------|
|`go.template.path` | `lower` | Change the template case to lower, valid values `lower`,`case` invalid values assume `lower` | 
|`template.go.delimiters` | `` | The template delimiter to use for all go templates

### Jobs Engine

| Option | Default | Description   |
|---------------|----|---------------|
|`jobs.pool` | `10` | Number of jobs that can run at once | 
|`jobs.acceptproxyaddress` | `false` | If true allow external proxy access for jobs page | 
|`jobs.selfconcurrent` | `false` | Can a single job run multiple (concurrent) times | 

