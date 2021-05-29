---
title: 用 gofight 來測試 golang web API handler
author: appleboy
type: post
date: 2016-04-06T07:18:21+00:00
url: /2016/04/gofight-tool-for-api-handler-testing-in-golang/
dsq_thread_id:
  - 4724060664
categories:
  - Golang
  - Testing
tags:
  - gofight
  - golang
  - Testing

---
[![][1]][1]

身為一位後端工程師，如果專案初期階段不導入測試，等到專案越來越大時，您就會發現，解了一個 bug，又產生好多個額外 bug，讓產品一直處於不穩定狀態。後端最主要提供前端或手機端 RESTFul API，所以今天來介紹一套 [gofight][2] 工具，用來測試 [Golang][3] 的 http [handler][4]，讓開發者可以送 Form, JSON, Raw 資料，後端處理後，可以拿到 response 資料，透過 [Testify][5] 來測試資料是否符合需求。

目前大部份的 Golang Web Framework 都可以透過 [gofight][2] 來測試，除非作者有把 `ServeHTTP` 改成自己定義 Response，不然基本上都是可以支援的，我自己測試了 [Gin][6], [Mux][7], [HttpRouter][8] 都是可以使用的，底下來看看 [gofight][2] 該如何使用。

<!--more-->

## 安裝方式

```bash
$ go get -u github.com/appleboy/gofight
```

`-u` 代表將 local 端程式碼更新到最新

## 使用方式

不多說直接先看例子，用 golang 基本的 http handler

```go
package main

import (
  "io"
  "net/http"
)

func BasicHelloHandler(w http.ResponseWriter, r *http.Request) {
  io.WriteString(w, "Hello World")
}

func BasicEngine() http.Handler {
  mux := http.NewServeMux()
  mux.HandleFunc("/", BasicHelloHandler)

  return mux
}
```

撰寫測試

```go
package main

import (
  "github.com/appleboy/gofight"
  "github.com/stretchr/testify/assert"
  "net/http"
  "testing"
)

func TestBasicHelloWorld(t *testing.T) {
  r := gofight.New()

  r.GET("/").
    // trun on the debug mode.
    SetDebug(true).
    Run(BasicEngine(), func(r gofight.HTTPResponse, rq gofight.HTTPRequest) {

      assert.Equal(t, "Hello World", r.Body.String())
      assert.Equal(t, http.StatusOK, r.Code)
    })
}
```

### 自訂 header

透過 `SetHeader` 可以自訂 Request header

```go
func TestBasicHelloWorld(t *testing.T) {
  r := gofight.New()
  version := "0.0.1"

  r.GET("/").
    // trun on the debug mode.
    SetDebug(true).
    SetHeader(gofight.H{
      "X-Version": version,
    }).
    Run(BasicEngine(), func(r gofight.HTTPResponse, rq gofight.HTTPRequest) {

      assert.Equal(t, version, rq.Header.Get("X-Version"))
      assert.Equal(t, "Hello World", r.Body.String())
      assert.Equal(t, http.StatusOK, r.Code)
    })
}
```

### 自訂 Form Data

透過 `SetFORM` 來傳送 Form Data

```go
func TestPostFormData(t *testing.T) {
  r := gofight.New()

  r.POST("/form").
    SetFORM(gofight.H{
      "a": "1",
      "b": "2",
    }).
    Run(BasicEngine(), func(r HTTPResponse, rq HTTPRequest) {
      data := []byte(r.Body.String())

      a, _ := jsonparser.GetString(data, "a")
      b, _ := jsonparser.GetString(data, "b")

      assert.Equal(t, "1", a)
      assert.Equal(t, "2", b)
      assert.Equal(t, http.StatusOK, r.Code)
    })
}
```

### 自訂 JSON Data

透過 `SetJSON` 來傳送 JSON Data

```go
func TestPostJSONData(t *testing.T) {
  r := gofight.New()

  r.POST("/json").
    SetJSON(gofight.D{
      "a": 1,
      "b": 2,
    }).
    Run(BasicEngine, func(r HTTPResponse, rq HTTPRequest) {
      data := []byte(r.Body.String())

      a, _ := jsonparser.GetInt(data, "a")
      b, _ := jsonparser.GetInt(data, "b")

      assert.Equal(t, 1, int(a))
      assert.Equal(t, 2, int(b))
      assert.Equal(t, http.StatusOK, r.Code)
    })
}
```

### 自訂 RAW Data

透過 `SetBody` 來傳送 RAW Data

```go
func TestPostRawData(t *testing.T) {
  r := gofight.New()

  r.POST("/raw").
    SetBody("a=1&b=1").
    Run(BasicEngine, func(r HTTPResponse, rq HTTPRequest) {
      data := []byte(r.Body.String())

      a, _ := jsonparser.GetString(data, "a")
      b, _ := jsonparser.GetString(data, "b")

      assert.Equal(t, "1", a)
      assert.Equal(t, "2", b)
      assert.Equal(t, http.StatusOK, r.Code)
    })
}
```

更多測試可以直接參考 [gofight_test.go][9] 程式碼

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://github.com/appleboy/gofight
 [3]: https://golang.org/
 [4]: https://golang.org/pkg/net/http/#Handler
 [5]: https://github.com/stretchr/testify
 [6]: https://github.com/gin-gonic/gin
 [7]: https://github.com/gorilla/mux
 [8]: https://github.com/julienschmidt/httprouter
 [9]: https://github.com/appleboy/gofight/blob/master/gofight_test.go