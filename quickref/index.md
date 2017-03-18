---
title: Quick Ref
layout: quickref
---

[revel.Config](https://godoc.org/github.com/revel/revel#Config),  [manual](/manual/appconf.html)
- [Routing](/manual/routing.html)
- [Static Files](/manual/routing.html#StaticFiles)
- [InterceptorFunc](https://godoc.org/github.com/revel/revel#InterceptorFunc), [InterceptorMethod](https://godoc.org/github.com/revel/revel#InterceptorMethod),  [manual](/manual/interceptors.html)
- [Filters](https://godoc.org/github.com/revel/revel#Filters), [manual](/manual/filters.html)
  - [OnAppStart](https://godoc.org/github.com/revel/revel#OnAppStart)
- [Logging](/manual/logging.html), [config](/manual/appconf.html#logging)
- [Debugging](/manual/debug.html)

[Controller](https://godoc.org/github.com/revel/revel#Controller), [manual](/manual/controllers.html)
- [Request](https://godoc.org/github.com/revel/revel#Request)
  - [Params](https://godoc.org/github.com/revel/revel#Params), [manual](/manual/parameters.html)
    - [Binder](https://godoc.org/github.com/revel/revel#Binder), [manual](/manual/parameters.html#binder)
    - [Validation](https://godoc.org/github.com/revel/revel#Validation), [manual](/manual/validation.html)
- [Result](https://godoc.org/github.com/revel/revel#Result), [manual](/manual/results.html)
  - [RenderJson](https://godoc.org/github.com/revel/revel#Controller.RenderJson), [manual](/manual/results.html#RenderJson)
  - [RenderTemplate()](https://godoc.org/github.com/revel/revel#Controller.RenderTemplate), [Template](https://godoc.org/github.com/revel/revel#Template), [manual](/manual/templates.html), [config](/manual/appconf.html#templates)
    - [Template Functions](/manual/templates.html#functions)
  - [ErrorResult](https://godoc.org/github.com/revel/revel#ErrorResult), [RenderError()](https://godoc.org/github.com/revel/revel#Controller.RenderError)
  - [NotFound()](https://godoc.org/github.com/revel/revel#Controller.NotFound), [Todo()](https://godoc.org/github.com/revel/revel#Controller.Todo)
- [Session](https://godoc.org/github.com/revel/revel#Session), [manual](/manual/sessionflash.html#session), [config](/manual/appconf.html#session)
  - [Flash](https://godoc.org/github.com/revel/revel#Flash), [manual](/manual/sessionflash.html#flash)
  - [Controller.SetCookie()](https://godoc.org/github.com/revel/revel#Controller.SetCookie)
- [Cache](https://godoc.org/github.com/revel/revel#Cache), [manual](/manual/cache.html), [config](/manual/appconf.html#cache)

[Modules](/modules/index.html), [routing](/manual/routing.html#modules)
- [Jobs](https://godoc.org/github.com/revel/revel#Jobs), [manual](/modules/jobs.html),  [config](/manual/appconf.html#jobs)
- [TestSuite](https://godoc.org/github.com/revel/revel/testing#TestSuite), [manual](/modules/jobs.html)