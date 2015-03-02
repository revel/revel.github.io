---
title: Cache
layout: manual
---

Revel provides a [`Cache`](http://godoc.org/github.com/revel/revel/cache#Cache) library for server-side, temporary, low-latency
storage.  It is a good replacement for frequent database access to slowly
changing data. It can also be using for implementing user sessions if for example
cookie-based sessions are insufficient.

## Implementations

The Cache may be configured to be backed by one of the following implementations:

* a list of [memcached](http://memcached.org/) hosts
* a single [redis](http://redis.io) host
* the 'in-memory' implementation

## Expiration

Cache items are set with an expiration time, in one of three forms:

* a [`time.Duration`](http://golang.org/pkg/time/#Duration)
* `cache.DEFAULT` - the application-wide default expiration time, one hour by default (see [cache config](appconf.html#cache))
* `cache.FOREVER` - will cause the item to never expire

<div class="alert alert-info"><b>Important</b>: Callers can <b>not</b> rely on items being present in the cache, as
  the data is not durable, and a cache restart may clear all data.</div>

## Serialization

The [`Cache'](http://godoc.org/github.com/revel/revel/cache) getters and setters automatically serialize values for callers, to
and from any type.  It uses the following mechanisms:

* If the value is already of type `[]byte`, the data is not touched
* If the value is of any integer type, it is stored as the ASCII representation
* Else, the value is encoded using [`encoding/gob`](http://golang.org/pkg/encoding/gob/)



## Configuration

Configure the cache using these keys in [`conf/app.conf`](appconf.html):

* [`cache.expires`](appconf.html#cacheexpires) 
    - a string accepted by  [`time.ParseDuration`](http://golang.org/pkg/time/#ParseDuration) to specify
        the default expiration duration.  (default 1 hour)
* [`cache.memcached`](appconf.html#cachememcached) 
    - a boolean indicating whether or not memcached should be
        used. (default `false`)
* [`cache.redis`](appconf.html#cacheredis) 
    - a boolean indicating whether or not redis should be
        used. (default `false`)
* [`cache.hosts`](appconf.html#cachehosts) 
    - a comma separated list of hosts to use as backends.  If the backend is Redis,
        then only the first host in this list will be used.

## Cache Example

Here's an example of the common operations.  Note that callers may invoke cache
operations in a new goroutine if they do not require the result of the
invocation to process the request.

{% highlight go %}
import (
	"github.com/revel/revel"
	"github.com/revel/revel/cache"
)

func (c App) ShowProduct(id string) revel.Result {
	var product *Product 
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
{% endhighlight %}

## Session usage

The Cache has a global key space,  to use it as a [session](sessionflash.html) store, callers should
take advantage of the session's UUID, as shown below:

{% highlight go %}
cache.Set(c.Session.Id(), products)

// and then in subsequent requests
err := cache.Get(c.Session.Id(), &amp;products)
{% endhighlight %}

<hr>
- See the godocs for [cache](http://godoc.org/github.com/revel/revel/cache) package
- Issues tagged with [`cache`](https://github.com/revel/revel/labels/cache)