---
title: Ace Template Engine
layout: modules
github:
  labels:
    - topic-template-engine
---
 The [ACE](https://github.com/yosssi/ace) Template Engine
 
- Ace templates have full access to the `revel.TemplateFuncs`, any function 
 defined in there can be used by the this engine

- Ace files must be identified by using a `shebang` on the first line 
(preferred method) or changing the file extension to home.ace.html. 

- Ace templates can be set to be case sensitive by setting
`ace.tempate=case`, default is not case sensitive. If case sensitivity
is off internal imports must be done using lower case

- All function registered in `revel.TemplateFuncs` are available for use 
inside the ace framework

##### Details
Ace is a little different of a templating system, its output is a 
standard go template but there is no concept of template sets, 
instead you build a composite template using
 a *base* template and an *inner* template. The 
 *inner* template can only contain items like : 
 {% raw %}
   ```
= content main
  h2 Inner Template - Main : {{.Msg}}

= content sub
  h3 Inner Template - Sub : {{.Msg}}
     
   ```
   {% endraw %}
The base template can contain items like
 {% raw %}
```
= doctype html
html lang=en
  head
    meta charset=utf-8
    title Ace example
    = css
      h1 { color: blue; }
  body
    h1 Base Template : {{.Msg}}
    #container.wrapper
      = yield main
      = yield sub
      = include inc .Msg
    = javascript
      alert('{{.Msg}}');
```
{% endraw %}

You are allowed to include one *inner* template with the base template,
to do so in Revel you can extend your controller from the ace controller
and call `RenderAceTemplate(base ,inner string)` which will insert
the inner template using the outer template.
