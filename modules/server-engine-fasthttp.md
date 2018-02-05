---
title: FastHTTP Server Engine
layout: modules
github:
  labels:
    - topic-server-engine
---
This module wraps the [FastHTTP](https://github.com/valyala/fasthttp) server engine.
Please note that it does not support WebSockets.

### Setup

Set the following keys in your application’s app.conf:
- **server.engine** You must set this to `fasthttp` in order to use this server engine
- **module.fasthttp** You must set this to `github.com/revel/modules/server-engine/fasthttp` to register the fasthttp server engine

### Other Notes

All features from supported by a regular HTTP engine is supported by this server engine.
Memory usage is decreased because this engine makes reuse of allocated structures to
handle requests. This should also increase overall runtime performance and throughput.
Results are not buffered as well.
