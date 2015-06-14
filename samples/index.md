---
title: Sample applications
layout: samples
---

Revel provides a few sample applications to demonstrate typical usage. 

These are in a separate [github.com/revel/samples](https://github.com/revel/samples/) repository.

{% highlight sh %}
go get -d github.com/revel/samples
revel run github.com/revel/samples/booking
{% endhighlight  %}

* [Booking](booking.html) 
  - A database-driven hotel-booking application,
  including user management.
* [Chat](chat.html) 
  - A chat room demonstrating active refresh, long-polling (comet), and [websocket](../manual/websockets.html) implementations.
* [Validation](validation.html) 
  - A demonstration of the [validation](../manual/validation.html) system.
* [Upload](upload.html) 
  - Demonstrates single and multiple file uploads.
* [Twitter OAuth](twitter-oauth.html) 
  - A sample app that displays mentions and allows posting to a Twitter account using OAuth.
* [Facebook OAuth2](facebook-oauth2.html) 
  - A sample app that displays Facebook user information using OAuth2.


