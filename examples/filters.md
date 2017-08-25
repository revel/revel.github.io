---
title: Filters
layout: examples
godoc: 
    - Filters
---

User contributed examples:

#### Asset pipeline
Use the [Train](https://github.com/shaoshing/train) asset pipline in revel

init.go

``` go
func init() {
  revel.Filters = []revel.Filter{
        AssetsFilter,
        revel.PanicFilter,             // Recover from panics and display an error page instead.
        revel.RouterFilter,            // Use the routing table to select the right Action (Controller.Method)
        revel.FilterConfiguringFilter, // A hook for adding or removing per-Action filters.
        revel.ParamsFilter,            // Parse parameters into Controller.Params.
        revel.SessionFilter,           // Restore and write the session cookie.
        revel.FlashFilter,             // Restore and write the flash cookie.
        revel.ValidationFilter,        // Restore kept validation errors and save new ones from cookie.
        revel.I18nFilter,              // Resolve the requested language
        revel.InterceptorFilter, // Run interceptors around the Action.
        revel.CompressFilter,    // Compress the result.
        revel.ActionInvoker,     // Invoke the Action (Controller.Method).
  }

  train.ConfigureHttpHandler(nil)
  http.ListenAndServe(":3000", nil)
  revel.TemplateFuncs["javascript_tag"] = train.JavascriptTag
  revel.TemplateFuncs["stylesheet_tag"] = train.StylesheetTag
}

// Server /assets with [train]
var AssetsFilter = func(c *revel.Controller, fc []revel.Filter) {
    path := c.Request.URL.Path
    if strings.HasPrefix(path, "/assets") {
        train.ServeRequest(c.Response.Out, c.Request.Request)
    } else {
        fc[0](c, fc[1:])
    }
}
```
