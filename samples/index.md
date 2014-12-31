---
title: Sample applications
layout: samples
---

Revel provides a few samples to demonstrate typical usage. There are in the [github.com/revel/samples/](https://github.com/revel/samples/) repository.

* [Booking](booking.html) - A database-driven hotel-booking application,
  including user management.
* [Chat](chat.html) - A chat room demonstrating active refresh, long-polling
  (comet), and websocket implementations.
* [Validation](validation.html) - A demonstration of the validation system.
* [Twitter OAuth](twitter-oauth.html) - A sample app that displays mentions and
  allows posting to a Twitter account using OAuth.
* [Facebook OAuth2](facebook-oauth2.html) - A sample app that displays Facebook
  user information using OAuth2.

The samples can generally be run easily, for example:

    % go get github.com/revel/samples
    $ revel run github.com/revel/samples/chat
