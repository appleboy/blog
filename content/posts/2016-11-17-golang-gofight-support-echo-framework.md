---
title: 輕量級 Gofight 支援 Echo 框架測試
author: appleboy
type: post
date: 2016-11-17T15:19:57+00:00
url: /2016/11/golang-gofight-support-echo-framework/
dsq_thread_id:
  - 5311533820
categories:
  - Golang
  - Testing
tags:
  - gofight
  - golang
  - Testing

---
[![][1]][1]

[Gofight][2] 是一套用 [Golang][3] 撰寫的輕量級測試工具，專門測試 Golang Web Framework API，可以參考之前一篇教學: [用 gofight 來測試 golang web API handler][4]，在 [Echo][5] 框架發布 [v3.0.0][6] 之前，Echo 不支援 golang 標準的 `http.Request` 及 `http.ResponseWriter`，反倒是支援 [fasthttp][7]，所以我發了 [Issue][8] 希望作者可以支援原生的 http 標準，最後沒有得到回應。就在前幾天 Echo 在 v3.0.0 版本把 `fasthttp` 拿掉，這樣 Gofight 就可以移除特定函示，改用原生 http。

<!--more-->

## gofight v1 寫法 (舊式)

舊版 [gofight v1][9] 針對 Echo 框架測試寫法

<pre><code class="language-go">func TestEchoPostFormData(t *testing.T) {
    r := New()

    r.POST("/form").
        SetBody("a=1&b=2").
        RunEcho(framework.EchoEngine(), func(r EchoHTTPResponse, rq EchoHTTPRequest) {
            data := []byte(r.Body.String())

            a, _ := jsonparser.GetString(data, "a")
            b, _ := jsonparser.GetString(data, "b")

            assert.Equal(t, "1", a)
            assert.Equal(t, "2", b)
            assert.Equal(t, http.StatusOK, r.Status())
        })
}</code></pre>

## gofight v2 寫法 (新式)

新版 [gofight v2][10] 針對 Echo 框架測試寫法

<pre><code class="language-go">func TestEchoPut(t *testing.T) {
    r := New()

    r.PUT("/update").
        SetBody("c=1&d=2").
        Run(framework.EchoEngine(), func(r HTTPResponse, rq HTTPRequest) {
            data := []byte(r.Body.String())

            c, _ := jsonparser.GetString(data, "c")
            d, _ := jsonparser.GetString(data, "d")

            assert.Equal(t, "1", c)
            assert.Equal(t, "2", d)
            assert.Equal(t, http.StatusOK, r.Code)
        })
}</code></pre>

可以看到只要取代底下 func 就可以無痛轉換

  * `RunEcho` => `Run`
  * `EchoHTTPResponse` => `HTTPResponse`
  * `EchoHTTPRequest` => `HTTPRequest`

## 載入新版方式

### 下載 Gofight v2

    $ go get gopkg.in/appleboy/gofight.v2

### 載入 Gofight v2

<pre><code class="language-go">import "gopkg.in/appleboy/gofight.v2"</code></pre>

## 後記

Gofight 有用 [glide][11] 做 vendor 套件控管，但是支援 Echo 框架後，發現測試突然壞了，產生了[另外 Issue][12]，如果是使用 `go get -d -t ./...` 安裝方式就沒有問題，之後再找時間解決此問題。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://github.com/appleboy/gofight
 [3]: https://golang.org/
 [4]: https://blog.wu-boy.com/2016/04/gofight-tool-for-api-handler-testing-in-golang/
 [5]: https://echo.labstack.com/
 [6]: https://github.com/labstack/echo/releases/tag/v3.0.0
 [7]: https://github.com/valyala/fasthttp
 [8]: https://github.com/labstack/echo/issues/439
 [9]: http://gopkg.in/appleboy/gofight.v1
 [10]: http://gopkg.in/appleboy/gofight.v2
 [11]: https://github.com/Masterminds/glide
 [12]: https://github.com/appleboy/gofight/issues/41