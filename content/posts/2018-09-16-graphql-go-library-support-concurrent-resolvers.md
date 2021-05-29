---
title: Go 語言的 graphQL-go 套件正式支援 Concurrent Resolvers
author: appleboy
type: post
date: 2018-09-16T03:35:36+00:00
url: /2018/09/graphql-go-library-support-concurrent-resolvers/
dsq_thread_id:
  - 6914356588
categories:
  - Golang
tags:
  - golang
  - GraphQL

---
[![][1]][1]

要在 [Go 語言][2]寫 graphQL，大家一定對 [graphql-go][3] 不陌生，討論度最高的套件，但是我先說，雖然討論度是最高，但是效能是最差的，如果大家很要求效能，可以先參考此[專案][4]，裡面有目前 Go 語言的 graphQL 套件比較效能，有機會在寫另外一篇介紹。最近 graphql-go 的作者把 Concurrent Resolvers 的解法寫了一篇 [Issue 來討論][5]，最終採用了 [Resolver returns a Thunk][6] 方式來解決 Concurrent 問題，這個 PR 沒有用到額外的 goroutines，使用方式也最簡單

```go
"pullRequests": &graphql.Field{
    Type: graphql.NewList(PullRequestType),
    Resolve: func(p graphql.ResolveParams) (interface{}, error) {
        ch := make(chan []PullRequest)
        // Concurrent work via Goroutines.
        go func() {
            // Async work to obtain pullRequests.
            ch <- pullRequests
        }()
        return func() interface{} {
            return <-ch
        }, nil
    },
},
```

## 使用方式

先用一個簡單例子來解釋之前的寫法會是什麼形式

```go
package main

import (
    "encoding/json"
    "fmt"
    "log"
    "time"

    "github.com/graphql-go/graphql"
)

type Foo struct {
    Name string
}

var FieldFooType = graphql.NewObject(graphql.ObjectConfig{
    Name: "Foo",
    Fields: graphql.Fields{
        "name": &graphql.Field{Type: graphql.String},
    },
})

type Bar struct {
    Name string
}

var FieldBarType = graphql.NewObject(graphql.ObjectConfig{
    Name: "Bar",
    Fields: graphql.Fields{
        "name": &graphql.Field{Type: graphql.String},
    },
})

// QueryType fields: `concurrentFieldFoo` and `concurrentFieldBar` are resolved
// concurrently because they belong to the same field-level and their `Resolve`
// function returns a function (thunk).
var QueryType = graphql.NewObject(graphql.ObjectConfig{
    Name: "Query",
    Fields: graphql.Fields{
        "concurrentFieldFoo": &graphql.Field{
            Type: FieldFooType,
            Resolve: func(p graphql.ResolveParams) (interface{}, error) {
                type result struct {
                    data interface{}
                    err  error
                }
                ch := make(chan *result, 1)
                go func() {
                    defer close(ch)
                    time.Sleep(1 * time.Second)
                    foo := &Foo{Name: "Foo's name"}
                    ch <- &result{data: foo, err: nil}
                }()
                r := <-ch
                return r.data, r.err
            },
        },
        "concurrentFieldBar": &graphql.Field{
            Type: FieldBarType,
            Resolve: func(p graphql.ResolveParams) (interface{}, error) {
                type result struct {
                    data interface{}
                    err  error
                }
                ch := make(chan *result, 1)
                go func() {
                    defer close(ch)
                    time.Sleep(1 * time.Second)
                    bar := &Bar{Name: "Bar's name"}
                    ch <- &result{data: bar, err: nil}
                }()
                r := <-ch
                return r.data, r.err
            },
        },
    },
})

func main() {
    schema, err := graphql.NewSchema(graphql.SchemaConfig{
        Query: QueryType,
    })
    if err != nil {
        log.Fatal(err)
    }
    query := `
        query {
            concurrentFieldFoo {
                name
            }
            concurrentFieldBar {
                name
            }
        }
    `
    result := graphql.Do(graphql.Params{
        RequestString: query,
        Schema:        schema,
    })
    b, err := json.Marshal(result)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%s", b)
    /*
        {
          "data": {
            "concurrentFieldBar": {
              "name": "Bar's name"
            },
            "concurrentFieldFoo": {
              "name": "Foo's name"
            }
          }
        }
    */
}
```

接著看看需要多少時間來完成執行

```shell
$ time go run examples/concurrent-resolvers/main.go | jq
{
  "data": {
    "concurrentFieldBar": {
      "name": "Bar's name"
    },
    "concurrentFieldFoo": {
      "name": "Foo's name"
    }
  }
}

real    0m4.186s
user    0m0.508s
sys     0m0.925s
```

總共花費了四秒，原因是每個 resolver 都是依序執行，所以都需要等每個 goroutines 執行完成才能進入到下一個 resolver，上面例子該如何改成 Concurrent 呢，很簡單，只要將 return 的部分換成

```go
return func() (interface{}, error) {
    r := <-ch
    return r.data, r.err
}, nil
```

執行時間如下

```shell
$ time go run examples/concurrent-resolvers/main.go | jq
{
  "data": {
    "concurrentFieldBar": {
      "name": "Bar's name"
    },
    "concurrentFieldFoo": {
      "name": "Foo's name"
    }
  }
}

real    0m1.499s
user    0m0.417s
sys     0m0.242s
```

從原本的 4 秒多，變成 1.5 秒，原因就是兩個 resolver 的 goroutines 會同時執行，最後才拿結果。

## 心得

有了這功能後，比較複雜的 GraphQL 語法，就可以用此方式加速執行時間。作者也用 MongoDB + graphql 寫了一個[範例][7]，大家可以參考看看。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org
 [3]: https://github.com/graphql-go/graphql
 [4]: https://github.com/appleboy/golang-graphql-benchmark
 [5]: https://github.com/graphql-go/graphql/issues/389
 [6]: https://github.com/graphql-go/graphql/pull/388
 [7]: https://gist.github.com/chris-ramon/e90e245ae79d664ec2f22e4c5682ea3b