---
title: Database
layout: manual
---

Revel does not come *configured* with a database or ORM interface, and its up to the developer what and how to use. 

- The [appconf](appconf.html) does have a [`database`](appconf.html#database) section for usage.
- The [booking sample app](../samples/booking) has the initialisation for the an example ORM.

## Example Db Setup

Create an `InitDB()` function in for example  `github.com/username/my-app/app/init.go`.

{% highlight go %}
package app

import (
    "github.com/revel/revel"
    _ "github.com/lib/pq"
    "database/sql"
)

var DB *sql.DB

func InitDB() {
    connstring := fmt.Sprintf("user=%s password='%s' dbname=%s sslmode=disable", "user", "pass", "database")

    var err error
    DB, err = sql.Open("postgres", connstring)
    if err != nil {
        revel.INFO.Println("DB Error", err)
    }
    revel.INFO.Println("DB Connected")
}

func init() {

    revel.Filters = []revel.Filter{
        revel.PanicFilter,             // Recover from panics and display an error page instead.
        ... snipped ...
        revel.CompressFilter,          // Compress the result.
        revel.ActionInvoker,           // Invoke the action.
    }
    
    revel.OnAppStart(InitDB)
    ...
}

{% endhighlight %}


This can then be used in code
{% highlight go %}
import(
    "github.com/username/my-app/app"
)

func GetStuff() MyStruct {

    sql := "SELECT id, name from my_table "
    rows, err := app.DB.Query(sql)
    ... do stuff here ...
}

{% endhighlight %}