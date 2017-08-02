---
title: Templates
layout: manual
github:
  labels:
    - topic-template
    - topic-controller
godoc:
    - Template
---

Revel by default uses Go's built in [html/template](http://golang.org/pkg/html/template/) 
package. For information regarding this template engine see [here](templates-go.html) 

To add a template engine you must include the module. For example
```
module.1.pongo2=github.com/revel/modules/template-engine/pongo2
module.2.ace=github.com/revel/modules/template-engine/ace
module.3.static=github.com/revel/modules/static
module.4.jobs=github.com/revel/modules/jobs
```

This specifies that the pongo2 and ace engines are added to the
main template parser, the order of the way the modules are loaded
is important as well, since that controls what view overrides another.
The first view found is always the view used, all others will be suppressed.
The two part key allows the modules to be sorted, after sorting the 
sort key is removed and in the routes table the route is referenced 
normally. 

The configuration file also needs an list of engines to be used on the views
this is where `template.engines` key in the configuration file comes into
play like

```
template.engines=pongo2,ace,go
```

The three template engines `pongo2,ace,go` will be used when rendering
templates. 

### How Revel Picks the Right Template Engine
The `template-engine` has a method called `Handles`, which accepts
the basic template information (path, and content). The engine then
can return true or false if it can parse the file or not. How it makes
this choice is up to the parser. Revel has a builtin function called 
`revel.EngineHandles`, which can be used to look for a 
`shebang` at the top of the template to see which template engine it belongs to,
it also looks for a secondary extension like `foo.ace.html` which would be 
identified as an `ace` template. Finally it could try to parse the code
and if that passes it can register itself for that.

## File Path Case Sensitivity
In the past we have maintained an all lower case template path, this
works in most cases but lead to some confusion. For example if you include
a file within your template you must type out the file and file path
in lower case. Now you can specify if 
the case sensitivity is on or off. The case sensitivity can be turned on
by setting an app configuration option per template engine like 
`go.tempate.path=case` will turn on case sensitivity on the `go` 
template engine (by default it is off). 

## Directory Scanning
Directories are scanned for templates in the following order:

1. The application `app/views/` directory and subdirectories.
2. revel core `templates/` directory.
3. Otherwise a `500` error as template not found (but in [dev mode](appconf.html#run-modes) shows debug info)

For example, given a controller/action `Hello.World()`, Revel will:

- look for a template file named `views/Hello/World.html`.
- and if not found, show `views/errors/500.html`
- and if that's not found, use Revel's built-in `templates/errors/500.html`

Template file names are case insensitive so the following will be treated as the same:

- `views/hello/world.html`
- `views/HeLlO/wOrLd.HtMl`

However, on `**nix` based file systems (and for example with `index.html` and `IndeX.html`), duplicate cased file names are
to be avoided as it is unpredictable which one will be considered.

Revel provides templates for error pages ([see code](https://github.com/revel/revel/tree/master/templates/errors))  and
these display the developer friendly compilation errors in [dev mode](appconf.html#run-modes). An
application may override them by creating a template of the equivalent template name, e.g. `app/views/errors/404.html`.


## Render Context

Revel executes the template using the [`ViewArgs`](https://godoc.org/github.com/revel/revel#Controller.ViewArgs) data `map[string]interface{}`.  Aside from
application-provided data, Revel provides the following entries:

* **errors** - the map returned by
  [`Validation.ErrorMap`](https://godoc.org/github.com/revel/revel#Validation.ErrorMap) (see [validation](validation.html))
* **flash** - the data [flashed](sessionflash.html#flash) by the previous request.

