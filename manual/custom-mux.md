---
title: Custom Mux
layout: manual
group: Reference
---

Revel provides an ability to add a custom Mux into the framework. This is useful if you are
using a package that already includes a HTTP mux (such as Go swagger or Hugo). 
You use the [AddInitEventHandler](/manual/startup-shutdown.html#revel_event_hooks) 
to inject the 
mux into the server engine. You pass the prefix of the path that will be handled by the mux
and the `http.HandlerFunc` in the case were the Go engine is used (or `fasthttp.RequestHandler` 
for the FastHTTP engine). The mux is called for every request that begins with the prefix

**Notes**

* Revel [filters](manual/filters.html) are not called for the custom MUX. 
* Requests will still be logged. 


Below is a small implementation of this

```go
	revel.AddInitEventHandler(func(event revel.Event, i interface{}) revel.EventResponse {
		switch event {
		case revel.ENGINE_BEFORE_INITIALIZED:
            revel.AddHTTPMux("/this/is/a/test", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
                fmt.Fprintln(w, "Hi there, ", r.URL.Path)
                w.WriteHeader(200)
            }))
            revel.AddHTTPMux("/this/is/", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
                fmt.Fprintln(w, "Hi there, shorter prefix", r.URL.Path)
                w.WriteHeader(200)
            }))
    
		}
		return 0
	})

```
