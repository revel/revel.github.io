---
title: Cache
layout: manual
---

Revel provides a [`Cache`](http://godoc.org/github.com/revel/revel/cache#Cache) library for server-side, temporary, low-latency
storage.  It is a good replacement for frequent database access to slowly
changing data, and it can also be using for implementing user sessions (if the
cookie-based sessions are insufficient).


## Expiration

Cache items are set with an expiration time, in one of three forms:

* a [`time.Duration`](http://golang.org/pkg/time/#Duration)
* `cache.DEFAULT` - the application-wide default expiration time, one hour by default (see [cache config](appconf.html#Cache))
* `cache.FOREVER` - will cause the item to never expire.

<div class="alert alert-info"><b>Important</b>: Callers can <b>not</b> rely on items being present in the cache, as
  the data is not durable, and a cache restart may clear all data.</div>

## Serialization

The Cache getters and setters automatically serialize values for callers, to
and from any type.  It uses the following mechanisms:

* if the value is already of type `[]byte`, the data is not touched
* if the value is of any integer type, it is stored as the ASCII representation
* else, the value is encoded using [`encoding/gob`](http://golang.org/pkg/encoding/gob/)

## Implementations

The Cache may be configured to be backed by one of the following implementations:

* a list of [memcached](http://memcached.org/) hosts
* a single [redis](http://redis.io) host
* an in-memory implementation

## Configuration

Configure the cache using these keys in [`conf/app.conf`](appconf.html):

* [`cache.expires`](appconf.html#cache.expires) - a string accepted by
  [`time.ParseDuration`](http://golang.org/pkg/time/#ParseDuration) to specify
  the default expiration duration.  (default 1 hour)
* [`cache.memcached`](appconf.html#cache.memcached) - a boolean indicating whether or not memcached should be
  used. (default `false`)
* [`cache.redis`](appconf.html#cache.redis) - a boolean indicating whether or not redis should be
  used. (default `false`)
* [`cache.hosts`](appconf.html#cache.hosts) - a comma separated list of hosts to use as backends.  If the backend is Redis,
  then only the first host in this list will be used.

## Cache Example

Here's an example of the common operations.  Note that callers may invoke cache
operations in a new goroutine if they do not require the result of the
invocation to process the request.

{% raw %}
<pre class="prettyprint lang-go">
import (
	"github.com/revel/revel"
	"github.com/revel/revel/cache"
)

func (c App) ShowProduct(id string) revel.Result {
	var product Product
	if err := cache.Get("product_"+id, &amp;product); err != nil {
	    product = loadProduct(id)
	    go cache.Set("product_"+id, product, 30*time.Minute)
	}
	return c.Render(product)
}

func (c App) AddProduct(name string, price int) revel.Result {
	product := NewProduct(name, price)
	product.Save()
	return c.Redirect("/products/%d", product.id)
}

func (c App) EditProduct(id, name string, price int) revel.Result {
	product := loadProduct(id)
	product.name = name
	product.price = price
	go cache.Set("product_"+id, product, 30*time.Minute)
	return c.Redirect("/products/%d", id)
}

func (c App) DeleteProduct(id string) revel.Result {
	product := loadProduct(id)
	product.Delete()
	go cache.Delete("product_"+id)
	return c.Redirect("/products")
}
</pre>
{% endraw %}

## Session usage

The Cache has a global key space -- to use it as a session store, callers should
take advantage of the session's UUID, as shown below:

{% raw %}
<pre class="prettyprint lang-go">
cache.Set(c.Session.Id(), products)

// and then in subsequent requests
err := cache.Get(c.Session.Id(), &amp;products)
</pre>
{% endraw %}
