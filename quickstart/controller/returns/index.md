---
layout: quickstart
title: Quickstart
--- 
Actions must return a [`revel.Result`](../docs/godoc/results.html#Result), which
handles the response generation.  It adheres to a simple interface:

<pre class="prettyprint lang-go">
type Result interface {
	Apply(req *Request, resp *Response)
}
</pre>

[`revel.Controller`](../docs/godoc/controller.html#Controller) provides a couple
methods to produce Results:

* Render, RenderTemplate - render a template, passing arguments.
* RenderJson, RenderXml - serialize a structure to json or xml.
* RenderText - return a plaintext response.
* Redirect - redirect to another action or URL
* RenderFile - return a file, generally to be downloaded as an attachment.
* RenderError - return a 500 response that renders the errors/500.html template.
* NotFound - return a 404 response that renders the errors/404.html template.
* Todo - return a stub response (500)

Additionally, the developer may define their own `revel.Result` and return that.

