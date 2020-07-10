---
title: Versioning
layout: manual
---

# Versioning
Go has released a new dependency tool called go mod, it creates a file called `go.mod` and eliminates the need for 
GOPATH dependencies in Go. This simplifies the build process and bring a single point of contact to control versions.
Revel has embraced this idea and added a new flag called `--gomod-flags` which allows you to interact directly with the `go.mod`
before the project is built/packaged/run or tested. For ideas on usage of the `go mod` here are some commands 
[commands](https://golang.org/cmd/go/#hdr-Edit_go_mod_from_tools_or_scripts)  

An example to change `github.com/revel/revel` to use the develop branch 
```
 revel build   --gomod-flags "edit -replace=github.com/revel/revel=github.com/revel/revel@develop" -a my_gocode -t build/my_gocode
```
