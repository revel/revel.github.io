---
title: Websockets
layout: manual
---

Revel provides support for [Websockets](http://en.wikipedia.org/wiki/WebSocket).

To handle a Websocket connection:

1. Add a route using the `WS` method.
2. Add an action that accepts a `*websocket.Conn` parameter.

See the example [chat application](../samples/chat.html)

## Simple Websocket Example

Add this to the [`conf/routes`](routing.html) file:

	WS /app/feed Application.Feed

Then write an action like this:

{% highlight go %}
import "golang.org/x/net/websocket"

func (c App) Feed(user string, ws *websocket.Conn) revel.Result {
	...
}
{% endhighlight %}

