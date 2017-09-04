---
title: NewRelic Server Engine
layout: modules
github:
  labels:
    - topic-server-engine
---
This module wraps the Go HTTP server and inserts a filter to track each request
using [NewRelic](http://newrelic.com).

### Setup

Set the following keys in your application's `app.conf`:
- **server.engine** Set to `newrelic`
- **server.newrelic.license** Set to your NewRelic license key
- **server.newrelic.addfilter** Inserts filter into `revel.Filters` at position 2 to log every request. Default: `true`

### Other Notes
To access the `newrelic.Application` instance, embed the `RelicController` into your Revel controller and call the `GetRelicApplication()` method.
 
