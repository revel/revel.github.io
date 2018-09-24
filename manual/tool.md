---
title: Revel tool
layout: manual
---

## Revel Tool

The command line tool `revel` is similar to the `go generate` tool. It's purpose is to
simplify the development process of a web application by automating some of the 
repetitive steps. When used it 
reads the source code (and configuration) of your project and generates the source 
files for the routes, 
generates a main entry point for the application, 
downloads any missing packages (using `deps` if vendor folder is found)
and can start your application running in a proxy. 

You can optionally increase the verbosity of this process by adding a `-d` or `--debug` 
to any of the commands listed below

The Revel command package contains no dependencies on the Revel webframework. This allows 
the Revel team to make changes to either package individually without affecting your build 
environment.   

```sh 
$ revel
Usage:
  revel [OPTIONS] <command>

Application Options:
  -v, --debug              If set the logger is set to verbose
      --historic-run-mode  If set the runmode is passed a string not json
  -X, --build-flags=       These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands                           

Help Options:
  -h, --help               Show this help message

Available commands:
  build
  clean
  new
  package
  run
  test
  version

```

<a name="version"></a>

#### Version

- Displays the Revel Framework and Go version, 
if you are using a vendor folder you need to pass in the application path  

```commandline
    revel  version -h
           Usage:
             build [OPTIONS] version [version-OPTIONS]
           
           Application Options:
             -d, --debug                 If set the logger is set to verbose
           
           Help Options:
             -h, --help                  Show this help message
           
           [version command options]
                 -a, --application-path= Path to application folder

```


<a name="new"></a>
#### `revel new`
```commandline
Usage:
  revel [OPTIONS] new [new-OPTIONS]

Application Options:
  -v, --debug                 If set the logger is set to verbose
      --historic-run-mode     If set the runmode is passed a string not json
  -X, --build-flags=          These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands

Help Options:
  -h, --help                  Show this help message

[new command options]
      -a, --application-path= Path to application folder
      -s, --skeleton=         Path to skeleton folder (Must exist on GO PATH)
      -V, --vendor            True if project should contain a vendor folder to be initialized. Creates the vendor folder and the 'Gopkg.toml' file in the root
      -r, --run               True if you want to run the application right away

```
Creates the directory structure and copy files from a skeleton to initialize an application quickly.

- Copies files from the [`skeleton/`](https://github.com/revel/cmd/tree/develop/revel/skeleton) directory
- Under multi `GOPATH` scenario, Revel detects the current working directory with `GOPATH` and generates the project
- Skeleton is an optional argument, provided as an alternate skeleton path
- Interestingly you can create a new app and run using the `-r` by doing a
`revel new -a github.com/me/myapp -r` 

```commandline
revel new -a bitbucket.org/myorg/my-app
```

<a name="run"></a>
#### `revel run`
```commandline 
Usage:
  revel [OPTIONS] run [run-OPTIONS]

Application Options:
  -v, --debug                 If set the logger is set to verbose
      --historic-run-mode     If set the runmode is passed a string not json
  -X, --build-flags=          These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands

Help Options:
  -h, --help                  Show this help message

[run command options]
      -a, --application-path= Path to application folder
      -m, --run-mode=         The mode to run the application in
      -p, --port=             The port to listen
      -n, --no-proxy          True if proxy server should not be started. This will only update the main and routes files on change

// run in dev mode
revel run -a github.com/mycorp/mega-app

// run in prod mode on port 9999
revel run -a github.com/mycorp/mega-app -m prod -p 9999
```
Run creates a proxy container to run your application in, it also can watch your file for changes
and if any changes are made it can redeploy the application (if Go source files are changed), or
recompile the templates. It also downloads all necessary libraries if they are not in the GOPATH

- Creates main and routes Go source files and compiles the project for you 
- Runs a Proxy which will display any compile errors or template errors
- Watches files for any modifications, relaunches application if changes detected
- You can turn off the proxy with the `--no-proxy` flag if you want the process to only
update the go files.
- Interesting feature running on port 0 will start the proxy listener on a random open port so
you don't need to keep track of what ports are being used 

```commandline
    revel run -a github.org/mememe/mega-app -m prod
```

<a name="build"></a>
#### `revel build `
```commandline

Usage:
  revel [OPTIONS] build [build-OPTIONS]

Application Options:
  -v, --debug                 If set the logger is set to verbose
      --historic-run-mode     If set the runmode is passed a string not json
  -X, --build-flags=          These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands

Help Options:
  -h, --help                  Show this help message

[build command options]
      -t, --target-path=      Path to target folder. Folder will be completely deleted if it exists
      -a, --application-path= Path to application folder
      -m, --run-mode=         The mode to run the application in
      -s, --include-source    Copy the source code as well

```

- Build the Revel web application named by the given import path.
- This allows it to be deployed and run on a machine that lacks a Go installation.
- (v0.20) By default the go source tree is no longer added to the build results.
instead only the folders specified in the app.conf `` are included (recursively) in the package.
You can override this behavior by including the `--include-source` to the command
- By specifying the `--run-mode` you can further reduce the size of the packaged module since
this will restrict the number of modules included in the package to be deployed


```commandline
    revel build -a github.org/mememe/mega-app /path/to/deploy/mega-app -m prod
```

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="package"></a>
#### `revel package`
```commandline
Usage:
  revel [OPTIONS] package [package-OPTIONS]

Application Options:
  -v, --debug                 If set the logger is set to verbose
      --historic-run-mode     If set the runmode is passed a string not json
  -X, --build-flags=          These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands

Help Options:
  -h, --help                  Show this help message

[package command options]
      -m, --run-mode=         The mode to run the application in
      -a, --application-path= Path to application folder
      -s, --include-source    Copy the source code as well

```

- Build the Revel web application named by the given import path.
- This allows it to be deployed and run on a machine that lacks a Go installation.
- (v0.20) By default the go source tree is no longer added to the build results.
instead only the folders specified in the app.conf `` are included (recursively) in the package.
You can override this behavior by including the `--include-source` to the command
- By specifying the `--run-mode` you can further reduce the size of the packaged module since
this will restrict the number of modules included in the package to be deployed

```commandline
    revel package -a github.com/revel/revel/examples/chat -m prod
    > Your archive is ready: chat.tar.gz

```

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="clean"></a>

#### `revel clean`
```commandline
Usage:
  revel [OPTIONS] clean [clean-OPTIONS]

Application Options:
  -v, --debug                 If set the logger is set to verbose
      --historic-run-mode     If set the runmode is passed a string not json
  -X, --build-flags=          These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands

Help Options:
  -h, --help                  Show this help message

[clean command options]
      -a, --application-path= Path to application folder

```

- Clean the Revel web application named by the given import path
- Deletes the `app/tmp` directory.
- Deletes the `app/routes` directory.
```commandline
    revel clean github.com/revel/examples/booking
```

<a name="test"></a>
#### `revel test`
```commandline
Usage:
  revel [OPTIONS] test [test-OPTIONS]

Application Options:
  -v, --debug                 If set the logger is set to verbose
      --historic-run-mode     If set the runmode is passed a string not json
  -X, --build-flags=          These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands

Help Options:
  -h, --help                  Show this help message

[test command options]
      -m, --run-mode=         The mode to run the application in
      -a, --application-path= Path to application folder
      -f, --suite-function=   The suite.function

```
- Run all tests for the Revel app named by the given import path.
```commandline
    revel test -a github.com/revel/examples/booking -m dev
```
