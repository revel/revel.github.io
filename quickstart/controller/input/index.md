---
layout: quickstart
title: Quickstart
--- 
For a controller there are two components to map a request to an action and to determine how the data is processed 

The **[route]({{site.url}}/quickstart/controller/input/routing/index.html)** maps the request to the action, it also
provides url paramater mapping, templates also make use of this file to map a controller action and paramater to 
a linkable request.

The **[parameter]({{site.url}}/quickstart/controller/input/parameters/index.html)** or end function point also are 
intelligently designed. ie if paramaters are passed in which match the variables name in the function then those objects
will be populated via the paramater(s). This goes beyond simple string and ints, you can also populate structures so 
a fully populated form object is achievable with only one input.