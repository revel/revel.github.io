---
title: Namespace
layout: manual
---


## Namespace 

Namespace definition begins with the application configuration. Modules are defined inside the configuration file by `module.static=github.com/revel/modules/static` this defines the revel namespace of the word `static` to all the controllers and templates within the module. To reference the name space use the backslash in front of your controller action like below.

Route mapping inside the route file would be defined like

    *       /favicon.png                  static\Static.Serve("folder")

Module routing remains unchanged

    *      /debug/                          module:testrunner

Reverse routing has an optional namespace as well.

    <td><a href="{{url `jobs\Jobs.Run` $index}}">Start</a></td>

### Namespace in the application
#### Referencing Namespace within the route file. 
Given you had a line in the configuration importing a module like   `module.jobs=jobs` Route mapping inside the route file would be defined like.

    *       /run/:id                  jobs\Jobs.Run

To remain backwards compatible routes without a namespace will be matched to the first controller/name within the same module space or global space. Another words, if you have a definition like below in your app folder it will be matched to the first app controller that is called `Jobs` with a function `Run`

    *       /run/:id                  Jobs.Run

#### Wildcard matching
You can limit the wildcard matching to a single module by having the namespace in the route like the following. 

    *       /jobs/:controller/:action                  jobs\:controller.:action

Any route definitions in a module will be assumed that they are limited to only that module, unless that module prefixes a route path with a namespace 

#### Referencing Namespace within the template. 
You can reference a controller by its namespace within the application template by adding the `namespace\\` operator before the controller action. For example like given the module was defined in `app.conf` like  `module.myjobs=jobs` then to reference the controller action Jobs.Run the namespace should be appended in front like

    <td><a href="{{url `myjobs\Jobs.Run` $index}}">Start</a></td>

To remain backwards compatible the namespace reference is not required and the synatx `{{url \`Jobs.Run\` $index}}` will work, but it will use the first controller called `Jobs` with the action `Run` to perform the reverse route.

### Namespaces in a Module 
When building a module the application namespace that the module is imported into is unknown. So we introduce a special letter sequence **\_LOCAL\_\\** to indicate that these letters will need to be replaced within the template before the engine receives it. Then the template reverse routes function (the `url` template function) you should define the key `_LOCAL_(.module)\` in front of `url`. The `(.module)` portion is only needed if this is referencing a different module in another namespace (see next section for more details) . When revel reads the template file it will rewrite the `_LOCAL_(.module)\` portion with the namespace of the defined for example:

    <td><a href="{{url `_RNS_\Jobs.Run` $index}}">Start</a></td>

Given that the module is imported as `module.myjobs=jobs` The template would then be realized as 

    <td><a href="{{url `myjobs\Jobs.Run` $index}}">Start</a></td>

**Note** to remain backwards compatible the revel engine will attempt to reverse lookup a `Controller.Action` across all available controllers. If two controllers have the same name and action the default will be to match the first one. This will be slightly slower then a fully qualified lookup (one that has a namespace defined) is.

If a module requires another module, then there may be a conflict between how that module imported its module vs how the application imported the module. The correct way to map a imported module would be to specify the module to be included in the app.conf of the module like `module.myjobs=jobs`, then reference it in the template like the following

    <td><a href="{{url `_LOCAL_.myjobs\Jobs.Run` $index}}">Start</a></td>

In a module routes file this would be similarly done like

    *       /favicon.png                  _LOCAL_.static\Static.Serve("folder")
