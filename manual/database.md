---
title: Database
layout: manual
---

Revel does not come *configured* with a database or ORM interface. Its up to the developer what to use and how to use. 

- The [booking sample application](../samples/booking.html) has an example ORM using GORM.

## Config
- The [appconf](appconf.html) does have a [`database`](appconf.html#database) section for usage.
- Use [`revel.Config`](../docs/godoc/config.html) to access.
{% highlight go %}
func InitDB() {
    driver := revel.Config.StringDefault("db.user", "root")
    connect_string := revel.Config.StringDefault("db.spec", "")
    
    Db, err = sql.Open(driver, connect_string)
    ....
}
{% endhighlight %}



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