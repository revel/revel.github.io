---
title: Pongo 2
layout: modules
github:
  labels:
    - topic-template-engine
---
 The [PONGO2](https://github.com/flosch/pongo2) Template Engine

- Pongo2 templates may be identified by a `shebang` on the first line 
(preferred method) or changing the file extension to home.pongo2.html. 

- Pongo2 templates can be set to be case sensitive by setting
`pongo2.tempate.path=case`, default is not case sensitive. If case sensitivity is 
off the templates are compiled using lower case
- Currently the only functions built in are as follows, pongo2 
  does not have access to `revel.TemplateFuncs` 
  (pull requests writing a bridge for this would be welcome):
  - field
  - radio
  - option
  - url
  - checkbox
  - append
  
  Samples implementation below  

##### Details
pongo2 is the successor of [pongo](https://github.com/flosch/pongo), a Django-syntax like templating-language.

Install/update using `go get` (no dependencies required by pongo2):
```
go get -u github.com/flosch/pongo2
```

[Try pongo2 out in the pongo2 playground.](https://www.florian-schlachter.de/pongo2/)
{% raw %}
```
{%append "moreStyles" "ui-lightness/jquery-ui-1.7.2.custom.css"%}
{%append "moreScripts" "js/jquery-ui-1.7.2.custom.min.js"%}
{% include "header.html" %}

<h1>Book hotel</h1>

<form method="POST" action="{%url "Hotels.Book" hotel.HotelId%}">
  <p>
    <strong>Name:</strong> {{hotel.Name}}
  </p>
  <p>
    <strong>Address:</strong> {{hotel.Address}}
  </p>
  <p>
    <strong>City:</strong> {{hotel.City}}
  </p>
  <p>
    <strong>State:</strong> {{hotel.State}}
  </p>
  <p>
    <strong>Zip:</strong> {{hotel.Zip}}
  </p>
  <p>
    <strong>Country:</strong> {{hotel.Country}}
  </p>
  <p>
    <strong>Nightly rate:</strong> {{hotel.Price}}
  </p>
  {%with field = "booking.CheckInDate"|field %}
    <p class="{{field.ErrorClass}}">
      <strong>Check In Date:</strong>
      <input type="text" size="10" name="{{field.Name}}" class="datepicker" value="{{field.Flash}}">
      * <span class="error">{{field.Error}}</span>
    </p>
  {% endwith %}
  {%with field = "booking.CheckOutDate"|field %}
    <p class="{{field.ErrorClass}}">
      <strong>Check Out Date:</strong>
      <input type="text" size="10" name="{{field.Name}}" class="datepicker" value="{{field.Flash}}">
      * <span class="error">{{field.Error}}</span>
    </p>
  {% endwith %}
  <p>
    <strong>Room preference:</strong>
    {%with field = "booking.Beds"|field %}
    <select name="{{field.Name}}">
      {%option field "1" "One king-size bed"%}
      {%option field "2" "Two double beds"%}
      {%option field "3" "Three beds"%}
    </select>
    {% endwith %}
  </p>
  <p>
    <strong>Smoking preference:</strong>
    {%with field = "booking.Smoking"|field %}
      {%radio field "true"%} Smoking
      {%radio field "false"%} Non smoking
    {% endwith %}
  </p>
  {%with field = "booking.CardNumber"|field %}
    <p class="{{field.ErrorClass}}">
      <strong>Credit Card #:</strong>
      <input type="text" name="{{field.Name}}" size="16" value="{{field.Flash}}">
      * <span class="error">{{field.Error}}</span>
    </p>
  {% endwith %}
  {%with field = "booking.NameOnCard"|field %}
    <p class="{{field.ErrorClass}}">
      <strong>Credit Card Name:</strong>
      <input type="text" name="{{field.Name}}" size="16" value="{{field.Flash}}">
      * <span class="error">{{field.Error}}</span>
    </p>
  {% endwith %}
  <p>
    <strong>Credit Card Expiry:</strong>
    {%with field = "booking.CardExpMonth"|field %}
    <select name="{{field.Name}}">
      {%option field "1" "Jan"%}
      {%option field "2" "Feb"%}
      {%option field "3" "Mar"%}
      {%option field "4" "Apr"%}
      {%option field "5" "May"%}
      {%option field "6" "Jun"%}
      {%option field "7" "Jul"%}
      {%option field "8" "Aug"%}
      {%option field "9" "Sep"%}
      {%option field "10" "Oct"%}
      {%option field "11" "Nov"%}
      {%option field "12" "Dec"%}
    </select>
    {% endwith %}
    {%with field = "booking.CardExpYear"|field %}
    <select name="{{field.Name}}">
      {%option field "2008" "2008"%}
      {%option field "2009" "2009"%}
      {%option field "2010" "2010"%}
      {%option field "2011" "2011"%}
      {%option field "2012" "2012"%}
    </select>
    {% endwith %}
  </p>
  <p class="buttons">
    <input type="submit" value="Proceed">
    <a href="{%url "Hotels.Show" hotel.HotelId %}">Cancel</a>
  </p>
</form>

<script type="text/javascript" charset="utf-8">
$(function() {
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});
});
</script>

{% include "footer.html" %}

```
{% endraw %}
