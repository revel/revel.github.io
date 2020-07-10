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

You can optionally increase the verbosity of this process by adding a `-v` or `--debug` 
to any of the commands listed below

The Revel command package contains no dependencies on the Revel webframework. This allows 
the Revel team to make changes to either package individually without affecting your build 
environment.   

```commandline 
$ revel
Usage:
  revel [OPTIONS] <command>

Application Options:
  -v, --debug                If set the logger is set to verbose
      --historic-run-mode    If set the runmode is passed a string not json
      --historic-build-mode  If set the code is scanned using the original parsers, not the go.1.11+
  -X, --build-flags=         These flags will be used when building the application. May be specified multiple times, only applicable for Build, Run, Package, Test commands
      --gomod-flags=         These flags will execute go mod commands for each flag, this happens during the build process

Available commands:
  build
  clean
  new
  package
  run
  test
  version
```

You can optionally increase the verbosity of this process by adding a `-v` or `--debug` 
to any of the commands listed below

The Revel command package contains no dependencies on the Revel webframework. This allows 
the Revel team to make changes to either package individually without affecting your build 
environment.   

##### Application Options
These are global options available with any command.
* -v, --debug : Turns on the logger to be verbose in logging, may offer up clues as to what is not working
* --historic-run-mode : Passes the run mode as a string, not a json object. Not compatible with project using go.mod
* -- historic-build-mode : Parses the source files using go/build library. Not recommended with project using go.mod
* -X --build-flags= Go build flags to be used when building the app, may be specified multiple times for multiple flags
* --gomod-flags= commands to be run using `go mod <your command here>` spaces will be assumes to be split arguments example below
handy for modifying the go.mod file before it is used for a build.  
```
 revel build   --gomod-flags "edit -replace=github.com/revel/revel=github.com/revel/revel@develop" -a my_gocode -t build/my_gocode
```

<a name="version"></a>

#### Version

- Displays the Revel Framework and Go version, 
if you want to view the version for a particular project you need to pass in the application path.
All version management is maintained in the go.mod file which is located in the root of your project. You can
modify that file using the `go mod edit` [commands](https://golang.org/cmd/go/#hdr-Edit_go_mod_from_tools_or_scripts)
or directly with a text editor. You can also pass in commands that Revel will run before building a project like:

```
revel build   --gomod-flags "edit -replace=github.com/revel/revel=github.com/revel/revel@develop" -a my_gocode -t build/my_gocode
```    


```commandline
$ revel  version -h
Usage:
  revel [OPTIONS] version [version-OPTIONS]

Help Options:
  -h, --help                  Show this help message

[version command options]
      -a, --application-path= Path to application folder

```

#### New
```commandline
revel new -h
Usage:
  revel [OPTIONS] new [new-OPTIONS]

Help Options:
  -h, --help                  Show this help message

[new command options]
      -a, --application-path= Path to application folder
      -s, --skeleton=         Path to skeleton folder (Must exist on GO PATH)
      -p, --package=          The package name, this becomes the repfix to the app name, if defined vendored is set to true
          --no-vendor         True if project should not be configured with a go.mod, this requires you to have the project on the GOPATH, this is only compatible with go
                              versions v1.12 or older
      -r, --run               True if you want to run the application right away

```
Creates the directory structure and copy files from a skeleton to initialize an application quickly.
Since version 1 this will initialize a go.mod file in the project folder and the project is not required to be in a GOPATH

- Copies files from the [`skeleton/`](https://github.com/revel/skeletons) package
- The location of the project is dependent on a few variables
  - If the import path is an absolute path the location will be there
  - If the path is a relative path the current working directory is checked
- Skeleton is an optional argument, the default skeleton is in
https://github.com/revel/skeletons/tree/master/basic/bootstrap4 but you can specify a different
git repository by entering in the path like below.
```commandline
./revel new test/me2.com/myproject git://github.com/revel/skeletons:basic/bootstrap4
Revel executing: create a skeleton Revel application
Your application has been created in:
   /home/me/mygopath/src/test/me2.com/myproject

You can run it with:
   revel run -a  test/me2.com/myproject

```
Or you can specify a local filesystem path by 
```commandline
revel new github.com/me/myapp/ -s path/to/my/skeleton
```

Supported Schemes for the skeleton path
* file:// (or none), expects to find the skeleton on the path specified
* http:// Git repository, will access like git clone http://....
* https:// Git repository, will access like git clone https://....
* git:// Git repository, will access like git clone git://....

- You can create a new app and run using the `-r` by doing a
`revel new -a github.com/me/myapp -r` 

```commandline
revel new -a bitbucket.org/myorg/my-app
```


<a name="run"></a>
#### Run
```commandline 
$ revel run -h
Usage:
  revel [OPTIONS] run [run-OPTIONS]

[run command options]
      -a, --application-path= Path to application folder
      -m, --run-mode=         The mode to run the application in
      -p, --port=             The port to listen (default: -1)
      -n, --no-proxy          True if proxy server should not be started. This will only update the main and routes files on change
```
Example usage
```
// run in dev mode
$ revel run -a github.com/mycorp/mega-app

// run in prod mode on port 9999
$ revel run -a github.com/mycorp/mega-app -m prod -p 9999
```
Run creates a proxy container to run your application in, it also can watch your file for changes
and if any changes are made it can redeploy the application (if Go source files are changed), or
recompile the templates. It also downloads all necessary libraries

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
#### Build
```commandline
revel build -h
Usage:
  revel [OPTIONS] build [build-OPTIONS]

[build command options]
      -a, --application-path= Path to application folder
      -t, --target-path=      Path to target folder. Folder will be completely deleted if it exists
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
- The tool ignores any directory beginning with a period and only includes folders 
in `conf,public,app/views`. this is configured by `package.folders` in the app.conf 


```commandline
    revel build -a github.org/mememe/mega-app /path/to/deploy/mega-app -m prod
```

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="package"></a>
#### Package
```commandline
revel package -h
Usage:
  revel [OPTIONS] package [package-OPTIONS]

[package command options]
      -a, --application-path= Path to application folder
      -t, --target-path=      Full path and filename of target package to deploy
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
- The tool ignores any directory beginning with a period and only includes folders 
in `conf,public,app/views`. this is configured by `package.folders` in the app.conf 

```commandline
    revel package -a github.com/revel/revel/examples/chat -m prod
    > Your archive is ready: chat.tar.gz

```

<div class="alert alert-danger"><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> WARNING: The target path will be completely deleted, if it already exists!</div>

<a name="clean"></a>

#### Clean
```commandline
revel clean -h
Usage:
  revel [OPTIONS] clean [clean-OPTIONS]

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
#### Test
```commandline
revel test -h
Usage:
  revel [OPTIONS] test [test-OPTIONS]

[test command options]
      -a, --application-path= Path to application folder
      -m, --run-mode=         The mode to run the application in
      -f, --suite-function=   The suite.function

```
- Run all tests for the Revel app named by the given import path.
```commandline
    revel test -a github.com/revel/examples/booking -m dev
```
