---
title: Template Engine
layout: manual
github:
  labels:
    - topic-template
godoc:
    - TemplateEngine
---

Revel allows for building and using custom template engines; the process for building your own engine is as follows

### Building a new Template Engine
A template engine must implement the [`TemplateEngine`](https://godoc.org/github.com/revel/revel#TemplateEngine)
interface. To register a new engine in Revel :
 - Define it as a module to be loaded in the `app.conf`.
 - In the `init()` function of the engine, register the engine in revel by calling:  
`RegisterTemplateLoader(key string, loader func(loader *TemplateLoader) (TemplateEngine, error)) (err error)`
 - Specify the template engines to be used by setting the 
  `template.engines` configuration option to the names of the engine to be used (a comma delimited list).

#### Template Engine Interface
- [Event(event int, arg interface{})](https://godoc.org/github.com/revel/revel#TemplateEngine) 
  Called when a `revel.TemplateRefresh` or `revel.TemplateRefreshComplete` occurs. This allows
   the engine to do a pre-initialize, before the templates are loaded, and could also do some
   form of memory release once the templates are loaded.

- [Handles(templateView *TemplateView) bool](https://godoc.org/github.com/revel/revel#TemplateEngine)
 Called for every view found, revel creates a [`Trevel.TemplateView`](https://godoc.org/github.com/revel/revel#TemplateView)
 instance and calls every engine to see if they are the one to be used to parse the view

- [ParseAndAdd(basePath *TemplateView) error](https://godoc.org/github.com/revel/revel#TemplateEngine)
  Called on application startup, or when templates have been changed. 
  
- [Name() string](https://godoc.org/github.com/revel/revel#TemplateEngine)
  Called to fetch the name of the template engine. 
  
- [Lookup(templateName string) revel.Template](https://godoc.org/github.com/revel/revel#TemplateEngine)
  Called to fetch the template, see below for what the template interface implements. 
  
There is a helper struct called [revel.EngineHandles](https://godoc.org/github.com/revel/revel#TemplateEngineHelper)
which can be used to examine the view to check to see if it contains a shebang or a file extenstion that matches the name of the engine
, see 
[revel.GoEngine](https://godoc.org/github.com/revel/revel#GoEngine) for some examples

#### Template Interface
- `Name() string` Name of template
- `Content() []string` The content of the template as a string (Used in error handling).
- `Render(wr io.Writer, context interface{}) error` Called by the server to render the template out the io.Writer, context contains the view args to be passed to the template.
- `Location() string` // The full path to the file on the disk.

There is a helper struct called `revel.TemplateView`, which implements the `Location` function,
see 
[revel.GoEngine](https://godoc.org/github.com/revel/revel#GoEngine) for some examples

