---
title: Booking
layout: examples
godoc: 
    - Controller
    - InterceptMethod
    - Flash
---

The Booking sample app demonstrates:

* Using an SQL (SQLite) database and configuring the Revel DB module.
* Using the third party [GORP](https://github.com/go-gorp/gorp) *ORM-ish* library
* [Interceptors](/manual/interceptors.html) for checking that a user is logged in.
* Using [validation](/manual/validation) and displaying inline errors

<a class="btn btn-success btn-sm" href="https://github.com/revel/examples/tree/master/booking" role="button"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Browse Source</a>

~~~
	booking/app/
		models		   # Structs and validation.
			booking.go
			hotel.go
			user.go

		controllers
			init.go    # Register all of the interceptors.
			gorp.go    # A plugin for setting up Gorp, creating tables, and managing transactions.
			app.go     # "Login" and "Register new user" pages
			hotels.go  # Hotel searching and booking

		views
			...
~~~

## sqlite Installation

The booking app uses [go-sqlite3](https://github.com/mattn/go-sqlite3) database driver (which wraps the native C library).  

### To install on OSX:

1. Install [Homebrew](http://mxcl.github.com/homebrew/) if you don't already have it.
2. Install pkg-config and sqlite3:

~~~
$ brew install pkgconfig sqlite3
~~~

### To install on Ubuntu:

	$ sudo apt-get install sqlite3 libsqlite3-dev

Once you have SQLite installed, it will be possible to run the booking app:

	$ revel run github.com/revel/examples/booking

## Database / Gorp Plugin

[`app/controllers/init.go`](https://github.com/revel/examples/blob/master/booking/app/controllers/init.go) 
initializes the users requests:

* BeforeRequest: Begins a transaction and stores the Transaction on the Controller
* AfterRequest: Commits the transaction.  Panics if there was an error.

[`conf/app.conf`](https://github.com/revel/examples/blob/master/booking/conf/app.conf) 
tells revel how to initialize GORP, and to include the GORP module. 

[`app/controllers/app.go`](https://github.com/revel/examples/blob/master/booking/app/controllers/app.go#L17) 
The controllers embed  the gorpController.Controller. This controller makes the database
connection available inside it and provides commit and rollback functionality



## Interceptors

[`app/controllers/init.go`](https://github.com/revel/examples/blob/master/booking/app/controllers/init.go) 
registers the [interceptors](/manual/interceptors.html) that run before every method ([InterceptorMethod](https://godoc.org/github.com/revel/revel#InterceptorMethod)):

```go

func init() {
	revel.OnAppStart(Init)
	revel.InterceptMethod(Application.AddUser, revel.BEFORE)
	revel.InterceptMethod(Hotels.checkUser, revel.BEFORE)
}
```

As an example, `checkUser` looks up the username in the session and redirects
the user to log in if they are not already.

```go

func (c Hotels) checkUser() revel.Result {
	if user := c.connected(); user == nil {
		c.Flash.Error("Please log in first")
		return c.Redirect(Application.Index)
	}
	return nil
}
```

[Check out the user management code in app.go](https://github.com/revel/examples/blob/master/booking/app/controllers/app.go)

## Validation

The booking app does quite a bit of validation.

For example, here is the routine to validate a booking, from
[models/booking.go](https://github.com/revel/examples/blob/master/booking/app/models/booking.go):

```go

func (booking Booking) Validate(v *revel.Validation) {
	v.Required(booking.User)
	v.Required(booking.Hotel)
	v.Required(booking.CheckInDate)
	v.Required(booking.CheckOutDate)

	v.Match(b.CardNumber, regexp.MustCompile(`\d{16}`)).
		Message("Credit card number must be numeric and 16 digits")

	v.Check(booking.NameOnCard,
		revel.Required{},
		revel.MinSize{3},
		revel.MaxSize{70},
	)
}
```

Revel applies the validation and records errors using the name of the
validated variable (unless overridden).  For example, `booking.CheckInDate` is
required; if it evaluates to the zero date, Revel stores a `ValidationError` in
the validation context under the key "booking.CheckInDate".

Subsequently, the
[Hotels/Book.html](https://github.com/revel/examples/blob/master/booking/app/views/Hotels/Book.html)
template can easily access them using the [`field`](/manual/templates.html#field) helper:

{% capture ex %}{% raw %}
```html
{{with $field := field "booking.CheckInDate" .}}
<p class="{{$field.ErrorClass}}">
    <strong>Check In Date:</strong>
    <input type="text" size="10" name="{{$field.Name}}" class="datepicker" value="{{$field.Flash}}">
    * <span class="error">{{$field.Error}}</span>
ss</p>
{{end}}

```
{% endraw %}{% endcapture %}
{% highlight htmldjango %}{{ex}}{% endhighlight %} 


The [`field`](/manual/templates.html#field) template helper looks for errors in the validation context, using
the field name as the key.
