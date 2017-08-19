---
title: Websockets
layout: manual
---

Revel provides support for [Websockets](http://en.wikipedia.org/wiki/WebSocket).

To handle a Websocket connection:

1. Add a route using the `WS` method.
2. Add an action that accepts a `revel.ServerWebSocket` parameter.

See the example [chat application](/examples/chat.html)

## Simple Websocket Example

Add this to the [`conf/routes`](routing.html) file:

	WS /app/feed Application.Feed

Then write an action like this:

```go
import "github.com/revel/revel"

func (c App) Feed(user string, ws revel.ServerWebSocket) revel.Result {
	...
}
```

