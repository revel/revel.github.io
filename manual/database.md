---
title: Database
layout: manual
github:
  labels:
    - topic-controllers
godoc:
    - Config
---

Revel does not come *configured* with a database or ORM interface. There are modules like
[GORM](https://github.com/revel/modules/tree/master/gorm) that can be used to provide this
functionality. But ultimately it's up to the developer what to use and how to use. 

- The [booking sample application](/examples/booking.html) has an example 
   [ORM](https://en.wikipedia.org/wiki/Object-relational_mapping) using [GORP](https://github.com/go-gorp/gorp).

## Config
- The [appconf](appconf.html) does have a [`database`](appconf.html#database) section for usage.
- Use [revel.Config](https://godoc.org/github.com/revel/config#Context) to access.
```go
func InitDB() {
    driver := revel.Config.StringDefault("db.driver", "mysql")
    connect_string := revel.Config.StringDefault("db.connect", "root:root@locahost/test")
    
    Db, err = sql.Open(driver, connect_string)
    ....
}
```



## Example Db Setup

Create an `InitDB()` function in for example  `github.com/username/my-app/app/init.go`.

```go
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

```


This can then be used in code
```go
import(
    "github.com/username/my-app/app"
)

func GetStuff() MyStruct {

    sql := "SELECT id, name from my_table "
    rows, err := app.DB.Query(sql)
    ... do stuff here ...
}

```
