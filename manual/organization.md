---
title: Organization
layout: manual
---


Revel requires itself and the user application to be installed into a GOPATH layout as prescribed by the go command line tool.  (See "GOPATH Environment Variable" in the [go command documentation](http://golang.org/cmd/go/))

<a name="DefaultLayout"></a>

## Default Layout

Below is the default layout of a Revel application called `sample`, within a
typical Go installation.

- `my_gocode/`                  - GOPATH root
  - `src/`                      - GOPATH src/ directory
    - `github.com/revel/revel/`               - Revel source code
    - `bitbucket.org/me/sample/` - Sample app root
        - `app/`               - app sources
            - `controllers/`     - app [controllers](controllers.html)
                - `init.go`      - [interceptor](interceptors.html) registration
            - `models/`          - app domain models
            - `routes/`          - [reverse routes](routing.html#ReverseRouting) (generated code)
            - `views/`           - [templates](templates.html)
        - `tests/`           -  [test suites](testing.html)
        - `conf/`            - configuration files
            - `app.conf`       - [main configuration](appconf.html) file
            - `routes`         -  [routes](routes.html) definition file
        - `messages/`        - i18n [message](i18n-messages.html) files
        - `public/`          - [static/public assets](routing.html#StaticFiles)
            - `css/`           - stylesheet files
            - `js/`            - javascript files
            - `images/`        - image files


## app/ directory

The `app/` directory contains the source code and templates for your application.

- `app/controllers/` - All controllers are required here
- `app/views` - All templates are required here

Beyond that, the application may organize its code however it wishes.  Revel
will [watch](/manual/appconf.html#watch) all directories under `app/` and rebuild when it
notices any changes.  Any dependencies outside of `app/` will not be watched for
changes, it is the developer's responsibility to recompile when necessary.

Additionally, Revel will import any packages within `app/` (or imported
[modules](/modules/index.html)) that contain `init()` functions on startup, to ensure
that all of the developer's code is initialized.

The `app/init.go` file is a conventional location to register all of the
[interceptor](interceptors.html) hooks.  The order of `init()` functions is
undefined between source files from the same package, so collecting all of the
interceptor definitions into the same file allows the developer to specify (and
know) the order in which they are run.  (It could also be used for other
order-sensitive initialization in the future.)

## conf/ directory

The `conf/` directory contains the application's configuration files. There are
two main configuration files:

- [`app.conf`](appconf.html) - the main configuration file for the application
- [`routes`](routing.html) - the URL routing definition file.

## messages/ directory

The `messages/` directory contains all [localized](i18n-messages.html) message files.

## public/ directory

Resources stored in the `public/` directory are [static assets that are served
directly by the web server](routing.html#StaticFiles).  Typically it is split into three standard
sub-directories for `images/`, `css/` stylesheets and `js/` JavaScript files.

The names of these directories may be anything and  the developer need only update the [routes](routing.html).

