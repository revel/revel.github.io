---
title: Versioning
layout: manual
---

# Repeatable Builds

The goal of vendoring is to have repeatable builds. The Go language has been trending toward using
the [dep tool](https://golang.github.io/dep/) which is almost in final format. Adding vendoring
to a project now is fairly simple. Create a `Gopkg.toml` file in your application root,
and run `dep ensure`. The contents of the `Gopkg.toml` could be

```text
required = ["github.com/revel/revel", "github.com/revel/modules", "github.com/revel/cmd"]

[[constraint]]
name = "github.com/revel/revel"
version = "0.20.0"

[[constraint]]
  name = "github.com/revel/modules"
  version = "0.20.1"

[[constraint]]
  name = "github.com/revel/cmd"
  version = "0.20.1"

``` 

Doing a `dep ensure` will download all the files into the folder adjacent to the Gopkg.toml folder.

**Note**
The two main components of Revel are `revel/revel` and `revel/modules`. They are specified as being
required so the dep tool will always download them even if your source code does not include them.

The third required package we said is `revel/cmd`. This package contains the revel tool, so if you
always want the same build tool you would specify it as well. Even though it is downloaded you need
to install it. So your *setup* sequence should be something like

```text
dep ensure 
go install github.com/revel/cmd/revel
```

This will, download the required packages then compile the package  `github.com/revel/cmd/revel` 
and place it in your $GOPATH/bin folder.
Optionally can use the `go build` command to create the `revel` tool elsewhere.

## Prune Section
`Gopkg.toml` files can include a prune section, **do not** prune `unused-packages`, 
also **do not** prune `non-go`. At most your prune section should look like is the following. 
If you create a new project that is [vendored](/manual/tool.html#new_vendored)
it will be created without a prune section  

```ini
[prune]
  go-tests = true
```     
