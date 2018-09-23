---
title: Messages
layout: manual
---

**Messages** are used to externalize pieces of text in order to be able to provide translations for them. Revel
supports message files organized per language, automatic locale look-up, cookie-based overrides and message 
nesting and arguments.

#### Glossary

* **Locale**: a combination of *language* and *region* that indicates a user language preference, eg. `en-US`.
* **Language**: the language part of a locale, eg. `en`. Language identifiers are expected to be [ISO 639-1 codes](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
* **Region**: the region part of a locale, eg. `US`. Region identifiers are expected to be [ISO 3166-1 alpha-2 codes](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).

## Implementation Methods
Revel allows you to implement internalization at template, or as embedded messages.

Templates when loading will automatically look for a region specific template first

    app/
        views/
            Index/App.html.en
            Index/App.html.fr
            ...

You can also include templates that will check for regions automatically using
the [i18ntemplate](templates.html#url). This tag acts like a traditional template tag
except that it will automatically choose the region based on the ViewArgs passed in.
(optionally the region may be specified as the third argument)
It can be used on a page like

{% raw %}
```html
<p>
  Embedded Regional Template Example 
  {{i18ntemplate "templateName" .}}
</p>

```
{% endraw %}
## Example Application

The way Revel handles message files and internationalization in general is similar to most other web frameworks out there. For those of you that wish to get
started straight away without going through the specifics, there is a sample application 
[`examples/i18n`](https://github.com/revel/examples/tree/master/i18n) which demonstrates the basics.

## Configuration

<table class="table table-striped">
    <thead>
        <tr>
            <th style="width: 15%">File</th>
            <th style="width: 25%">Option</th>
            <th style="width: 60%">Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <code>app.conf</code>
            </td>
            <td>
                <code><a href="appconf.html#i18ncookie">i18n.cookie</a></code>
            </td>
            <td>
                The name of the language cookie. Should always be prefixed with the Revel cookie prefix to avoid cookie name conflicts.
            </td>
        </tr>
        <tr>
            <td>
                <code>app.conf</code>
            </td>
            <td>
                <code><a href="appconf.html#i18ndefault_language">i18n.default_language</a></code>
            </td>
            <td>
                The default locale to use in case no preferred locale could be found.
            </td>
        </tr>
        <tr>
            <td>
                <code>app.conf</code>
            </td>
            <td>
                <code><a href="appconf.html#i18nlocaleparameter">i18n.locale.parameter</a></code>
            </td>
            <td>
                The name of the parameter to use for switching the current language of the application.
		The parameter value is checked before other methods to resolve the client locale.
            </td>
        </tr>
    </tbody>
</table>


## Message Files

Messages are defined in message files. These files contain the actual text that will be used while rendering the view (or elsewhere in your application if you so desire). 
When creating new message files, there are a couple of rules to keep in mind:

* All message files should be stored in the `messages/` directory in the application root.
* The file extension determines the *language* of the message file and should be an [ISO 639-1 code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
* Message files should be UTF-8 encoded. While this is not a hard requirement, it is best practice.
* Each message file is effectively a [goconfig file](https://github.com/revel/config) and supports all goconfig features.

### Organizing Message Files

There are no restrictions on message file names; a message file name can be anything as long as it has a valid extention. There is also no restriction on the *amount*
of files per language. When the application starts, Revel will parse all message files with a valid extension in the `messages/` directory and merge them according to their 
language. This means that you are free to organize the message files however you want.  

- Refer to [organization](organization.html) for the directory layout

For example, you may want to take a traditional approach and define one single message file per language:

    messages/
        messages.en
        messages.fr
        ...

Another approach would be to create *multiple files* for the *same language* and organize them based on the kind of messages they contain:

    messages/
        labels.en
        warnings.en
        labels.fr
        warnings.fr
        ...

<div class="alert alert-block"><strong>Important note:</strong> while it's technically possible to define the same <em>message key</em> in multiple files with the same language, this will result in unpredictable behaviour. When using multiple files per language, take care to keep your message keys unique so that keys will not be overwritten after the files are merged!</div>

### Message keys and values

A message file is for all intents and purposes a [goconfig file](https://github.com/revel/goconfig). This means that messages should be defined according to the tried and
tested key-value format:

{% highlight ini %}
key=value
{% endhighlight %}

For example:
{% highlight ini %}
greeting=Hello 
greeting.name=Rob
greeting.suffix=, welcome to Revel!
{% endhighlight %}

### Sections

A goconfig file is separated into *sections*. The *default section* always exists and contains any messages that are not defined in a specific section. For example:
{% highlight ini %}
[DEFAULT]
key=value

[SECTION]
key2=value2
{% endhighlight %}

The `key=value` message is implicitly put in the default section as it was not defined under another specific section.

For message files all messages should be defined in the *default section* unless they are specific to a certain region (see 
[Regions](#regions) for more information).

<div class="alert alert-info"><strong>Note:</strong> sections are a <em>goconfig</em> feature.</div>

### Regions

Region-specific messages should be defined in sections with the same name. For example, suppose that we want to greet all English speaking users with `"Hello"`, all British
users with `"Hey"` and all American users with `"Howdy"`. In order to accomplish this, we could define the following message file `greeting.en`:
{% highlight ini %}
greeting=Hello

[GB]
greeting=Hey

[US]
greeting=Howdy
{% endhighlight %}

For users who have defined English (`en`) as their preferred language, Revel would resolve `greeting` to `Hello`. Only in specific cases where the user's locale has been
explicitly defined as `en-GB` or `en-US` would the `greeting` message be resolved using the specific sections.

<div class="alert alert-danger"><strong>Important:</strong> messages defined under a [section] that is not a valid region are technically allowed but ultimately useless as they will never be resolved.</div>

### Referencing and arguments

#### Referencing

Messages in message files can reference other messages. This allows users to compose a single message from one or more other messages. The syntax for referencing other messages 
is `%(key)s`. For example:
{% highlight ini %}
greeting=Hello 
greeting.name=Rob
greeting.suffix=, welcome to Revel!
greeting.full=%(greeting)s %(greeting.name)s%(greeting.suffix)s
{% endhighlight %}

<div class="alert alert-info"> 
<p><strong>Notes:</strong></p>
<ul>
    <li>Referencing is a <em>goconfig</em> feature.</li>
    <li>Because message files are merged, it's perfectly possible to reference messages in other files provided they are defined for the same language.</li>
</ul>
</div>

#### Arguments

Messages support one or more arguments. Arguments in messages are resolved using the same rules as the go `fmt` package. For example:
{% highlight ini %}
greeting.name_arg=Hello %s!
{% endhighlight %}
Arguments are resolved in the same order as they are given, see [Resolving messages](#resolving_messages).

## Resolving the client locale

In order to figure out which locale the user prefers Revel will look for a usable locale in the following places:

1. Language Parameter value

   - If in `app.conf` the value for `i18n.locale.parameter` is set, 
   this will be the first method to resolve the client language preference. e.g. `i18n.locale.parameter=lang`.
   - If this parameter has a value, its value is assumed to be the current locale. 
   - All other resolution methods will be skipped when a language parameter value has been found.

2. Language cookie

    - For every request, Revel will look for a cookie with the name defined in the application configuration [`i18n.cookie`](appconf.html#i18ncookie). 
    - If such a cookie is found, its value is assumed to be the current locale. 
    - All other resolution methods will be skipped when a cookie has been found.

3. `Accept-Language` HTTP header

    - Revel will automatically parse the `Accept-Language` HTTP header for each incoming request. 
    - Each of the locales in the `Accept-Language` header value is evaluated and stored in order of qualification according to the 
      [HTTP specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4) - in the current `Request` instance. 
    - This information is used later by the various message resolving functions to determine the current locale.
    - For more information see [Parsed Accept-Language HTTP header](#parsed_acceptlanguage_http_header).

4. Default language

    - When all of the look-up methods above have returned no usable client locale, Revel will use the [`i18n.default_language`](appconf.html#i18ndefault_language) as 
      defined in the [`conf/app.conf`](appconf.html) file.

**Note:** When the requested message could not be resolved at all, a specially formatted string containing the original message is returned.

<div class="alert alert-info"><strong>Note:</strong> the <code>Accept-Language</code> header is <strong>always</strong> parsed and stored in the current <code>Request</code>, even when a language cookie has been found. In such a case, the values from the header are simply never used by the message resolution functions, but they're still available to the application in case it needs them.</div>

### Retrieving the current locale

The application code can access the current locale from within a `Request` using the `Request.Locale` property. For example:

{% highlight go %}
func (c App) Index() revel.Result {
	currentLocale := c.Request.Locale
	c.Render(currentLocale)
}
{% endhighlight %}

From a [template](templates.html), the current locale can be retrieved from the `currentLocale` property of `viewArgs`. For example:

{% capture ex %}{% raw %}
    <p>My Locale is: {{.currentLocale}}</p>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

### Parsed Accept-Language HTTP header

In case the application needs access to the `Accept-Language` HTTP header for the current request it can retrieve it from the `Request` instance of the `Controller`. The `AcceptLanguages` field 
- which is a slice of `AcceptLanguage` instances - contains all parsed values from the respective header, sorted per qualification with the most qualified values first in the slice. For example:

{% highlight go %}
func (c App) Index() revel.Result {
    // Get the string representation of all parsed accept languages
    c.ViewArgs["acceptLanguageHeaderParsed"] = c.Request.AcceptLanguages.String()
    // Returns the most qualified AcceptLanguage instance
    c.ViewArgs["acceptLanguageHeaderMostQualified"] = c.Request.AcceptLanguages[0]

    c.Render()
}
{% endhighlight %}

For more information see the [HTTP specification](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4).

## Resolving messages

Messages can be resolved from either a *controller* or a *view template*.

### Controller

Each controller has a `Message(message string, args ...interface{})` function that can be used to resolve messages using the current locale. For example:

{% highlight go %}
func (c App) Index() revel.Result {
	c.ViewArgs["controllerGreeting"] = c.Message("greeting")
	c.Render()
}
{% endhighlight %}

<a name="template"></a>

### Template

To resolve messages using the current locale from [templates](templates.html) there is a *template function* `msg` that you can use. For example:

{% capture ex %}{% raw %}
<p>Greetings without arguments: {{msg . "greeting"}}</p>
<p>Greetings: {{msg . "greeting.full.name" "Tommy Lee Jones"}}</p>
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %}

<div class="alert alert-info"><p><strong>Notes:</strong></p>
    <ul>
        <li>The signature of the <code>msg</code> function is <code>msg . "message name" "argument" "argument"</code>. If there are no arguments, simply do not include any.</li>
        <li>The <em>I18nFilter</em> filter must be enabled (default) or the <code>currentLocale</code> RenderArg set for message substitution to work.</li>
    </ul>
</div>

### Locale by URL
Adds ability to specify a parameter to be used to set the locale.

In revel app.conf set the `i18n.locale.parameter` to the parameter name.
```
i18n.locale.parameter=locale
```

In routes specify the route path with the locale
```
GET  /hotels/:locale       Hotels.Index
```