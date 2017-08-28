---
title: Server Engine
layout: manual
github:
  labels:
    - engine
godoc: 
    - ServerEngine
---
The Revel server engine gives the developer the freedom to implement the server however
they would like to choose. By default the Go HTTP engine is used, but you can also use
the fasthttp engine or the newrelic engine. Or configure an engine to meet your needs.
For example you can design an engine to listen on multiple IP addresses and serve out
your website that way. 

### Registration
To register `revel.RegisterServerEngine(name string, loader func()revel.ServerEngine)` to register
your server engine.

###App.conf
- **server.engine** Defaults to `go`. Specify the engine you wish to use.  
If you are using a module server engine you must declare the module in the modules section. 

  
### Server Engines
To implement your own custom server engine by implementing the 
`revel.ServerEngine`.

```go
type ServerEngine interface {
	// Initialize the server (non blocking)
	Init(init *EngineInit)
	// Starts the server. This will block until server is stopped
	Start()
	// Fires a new event to the server
	Event(event int, args interface{})
	// Returns the engine instance for specific calls
	Engine() interface{}
	// Returns the engine Name
	Name() string
	// Returns any stats
	Stats() map[string]interface{}
}
type EngineInit struct {
	Address,
	Network string
	Port     int
	Callback func(ServerContext)
}

```

####Interface methods

- `Init()` Called when the server engine is created, it is called passing in a 
`revel.EngineInit` object which contains the basic data needed to initialize 
the engine and the `Engine.Callback` which is how the server conveys the 
request/response traffic to revel. This is called before any `revel.StartupHooks` are called
- `Start()` Called as the final step. This call is not expected to return unless the 
  engine has shutdown
- `Event()` The event interface will receive events from the `revel.InitEventHandler`
- `Name()` is the name of the engine which will match the app.conf parameter
- `Stats()` is called to retrieve any statistics the engine may want to provide



See
`revel.GOHttpServer` for an example

####Server Context
The server context is the communication bridge between Revel and the `revel.ServerEngine`

```go
	ServerContext interface {
		GetRequest() ServerRequest
		GetResponse() ServerResponse
	}

	// Callback ServerRequest type
	ServerRequest interface {
		GetRaw() interface{}
		Get(theType int) (interface{}, error)
		Set(theType int, theValue interface{}) bool
	}
	// Callback ServerResponse type
	ServerResponse interface {
		ServerRequest
	}
	// Callback WebSocket type
	ServerWebSocket interface {
		ServerResponse
		MessageSendJson(v interface{}) error
		MessageReceiveJson(v interface{}) error
	}

	// Expected response for HTTP_SERVER_HEADER type (if implemented)
	ServerHeader interface {
		SetCookie(cookie string)
		GetCookie(key string) (value ServerCookie, err error)
		Set(key string, value string)
		Add(key string, value string)
		Del(key string)
		Get(key string) (value []string)
		SetStatus(statusCode int)
	}

	// Expected response for FROM_HTTP_COOKIE type (if implemented)
	ServerCookie interface {
		GetValue() string
	}

	// Expected response for HTTP_MULTIPART_FORM
	ServerMultipartForm interface {
		GetFile() map[string][]*multipart.FileHeader
		GetValue() url.Values
		RemoveAll() error
	}
	StreamWriter interface {
		WriteStream(name string, contentlen int64, modtime time.Time, reader io.Reader) error
	}

```
As you can see the majority of communications are done through a Set/Get with a key.
The key determines what Revel is expecting for the the data.
 
```go
const (
	/* Minimum Engine Type Values */
	_ = iota
	ENGINE_RESPONSE_STATUS
	ENGINE_WRITER
	ENGINE_PARAMETERS
	ENGINE_PATH
	ENGINE_REQUEST
	ENGINE_RESPONSE
)
const (
	/* HTTP Engine Type Values Starts at 1000 */
	HTTP_QUERY          = ENGINE_PARAMETERS
	HTTP_PATH           = ENGINE_PATH
	HTTP_BODY           = iota + 1000
	HTTP_FORM           = iota + 1000
	HTTP_MULTIPART_FORM = iota + 1000
	HTTP_METHOD         = iota + 1000
	HTTP_REQUEST_URI    = iota + 1000
	HTTP_REMOTE_ADDR    = iota + 1000
	HTTP_HOST           = iota + 1000
	HTTP_SERVER_HEADER  = iota + 1000
	HTTP_STREAM_WRITER  = iota + 1000
	HTTP_WRITER         = ENGINE_WRITER
)
```

The minimum requirements for Revel to operate are the `ENGINE` constants, the `HTTP`
constants provide an enriched experience for the 
 
