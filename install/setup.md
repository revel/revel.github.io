---
title: Basic Setup
layout: install
---

<div class="alert alert-info">

NOTE: The setup described below is not a definitive guide, but rather pointers on how to get up and running

</div>


## Install Go

Before you can use Revel, [install Go](http://golang.org/doc/install) needs to be installed.

- See the official [Go installation guide](https://golang.org/doc/install).
    - [Ubuntu](https://github.com/golang/go/wiki/Ubuntu)
    - [Windows](https://golang.org/doc/install#windows)

## Set GOPATH environment variable

If you have not created a GOPATH as part of the installation, do so now. The `GOPATH`
is a directory where all of your Go code will live. Here is one way of setting it up:

1. Make a directory: `mkdir ~/gocode`
2. Tell Go to use that as your GOPATH: `export GOPATH=~/gocode`
3. Save your GOPATH so that it will apply to all future shell sessions: `echo export GOPATH=$GOPATH >> ~/.bash_profile`

Note that depending on your shell, you may need to adjust (3) to write the export into a different configuration file (e.g. *~/.bashrc*, *~/.zshrc, etc.).



## Install git and hg

Git and Mercurial are required to allow `go get` to clone various dependencies.

* [Installing Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)
* [Installing Mercurial](https://www.mercurial-scm.org/downloads)

