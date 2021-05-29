---
title: Go 語言框架 Gin 終於發佈 v1.2 版本
author: appleboy
type: post
date: 2017-07-06T06:29:33+00:00
url: /2017/07/go-framework-gin-release-v1-2/
dsq_thread_id:
  - 5967537003
categories:
  - Golang
tags:
  - Gin
  - golang

---
[<img src="https://i2.wp.com/farm5.staticflickr.com/4094/35582011972_dd73f48a9f.jpg?w=840&#038;ssl=1" alt="19807878_1634683919888714_743883353_o" data-recalc-dims="1" />][1]

上週跟 [Gin][2] 作者 [@javierprovecho][3] 討論要發佈新版本，很快地經過一兩天，作者終於整理好 [v1.2][4] 版本，除了釋出新版本外，也換了有顏色的 Logo，真心覺得很好看。大家來看看 v1.2 釋出哪些功能，或修正哪些問題。

<!--more-->

## 如何升級

首先來看看如何升級版本，建議還沒有用 vendor 工具的開發者，是時候該導入了。底下可以透過 [govender][5] 來升級 Gin 框架。

<pre><code class="language-bash">$ govendor fetch github.com/gin-gonic/gin@v1.2
$ govendor fetch github.com/gin-gonic/gin/render</code></pre>

由於我們新增 `Template Func Maps`，所以 `render` 套件也要一併升級喔。

## 從 godeps 轉換到 govender

Gin 專案本來是用 godeps，但是在套件處理上有些問題，所以我們決定換到穩定些的 [govender][5]，看看之後 Go 團隊開發的 [dep][6] 可不可以完全取代掉 govendor。

## 支援 Let's Encrypt

我另外開一個專案 [autotls][7] 讓 Gin 也可以支援 [Let's Encrypt][8]，這專案可以用在 [net/http][9] 套件上，所以基本上支援全部框架，除非搭建的 Http Server 不是用 net/http。使用方式很簡單，如下:

### 用一行讓 Web 支援 TLS

<pre><code class="language-go">package main

import (
    "log"

    "github.com/gin-gonic/autotls"
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()

    // Ping handler
    r.GET("/ping", func(c *gin.Context) {
        c.String(200, "pong")
    })

    log.Fatal(autotls.Run(r, "example1.com", "example2.com"))
}</code></pre>

### 自己客製化 Auto TLS Manager

開發者可以將憑證存放在別的目錄，請修改 `/var/www/.cache`

<pre><code class="language-go">package main

import (
    "log"

    "github.com/gin-gonic/autotls"
    "github.com/gin-gonic/gin"
    "golang.org/x/crypto/acme/autocert"
)

func main() {
    r := gin.Default()

    // Ping handler
    r.GET("/ping", func(c *gin.Context) {
        c.String(200, "pong")
    })

    m := autocert.Manager{
        Prompt:     autocert.AcceptTOS,
        HostPolicy: autocert.HostWhitelist("example1.com", "example2.com"),
        Cache:      autocert.DirCache("/var/www/.cache"),
    }

    log.Fatal(autotls.RunWithManager(r, &m))
}</code></pre>

## 支援 Template Func 功能

首先讓開發者可以調整 template 分隔符號，原本是用 `{{` 及 `}}`，現在可以透過 Gin 來設定客製化符號。

<pre><code class="language-go">    r := gin.Default()
    r.Delims("{[{", "}]}")
    r.LoadHTMLGlob("/path/to/templates"))</code></pre>

另外支援 Custom Template Funcs

<pre><code class="language-go">    ...

    func formatAsDate(t time.Time) string {
        year, month, day := t.Date()
        return fmt.Sprintf("%d/%02d/%02d", year, month, day)
    }

    ...

    router.SetFuncMap(template.FuncMap{
        "formatAsDate": formatAsDate,
    })

    ...

    router.GET("/raw", func(c *Context) {
        c.HTML(http.StatusOK, "raw.tmpl", map[string]interface{}{
            "now": time.Date(2017, 07, 01, 0, 0, 0, 0, time.UTC),
        })
    })

    ...</code></pre>

打開 `raw.tmpl` 寫入

<pre><code class="language-bash">Date: {[{.now | formatAsDate}]}</code></pre>

執行結果:

<pre><code class="language-bash">Date: 2017/07/01</code></pre>

## 增加 Context 函式功能

在此版發佈前，最令人煩惱的就是 Bind Request Form 或 JSON 驗證，因為 Gin 會直接幫忙回傳 400 Bad Request，很多開發者希望可以自訂錯誤訊息，所以在 v1.2 我們將 `BindWith` 丟到 [deprecated 檔案][10]，並且打算在下一版正式移除。

<pre><code class="language-go">// BindWith binds the passed struct pointer using the specified binding engine.
// See the binding package.
func (c *Context) BindWith(obj interface{}, b binding.Binding) error {
    log.Println(`BindWith(\"interface{}, binding.Binding\") error is going to
    be deprecated, please check issue #662 and either use MustBindWith() if you
    want HTTP 400 to be automatically returned if any error occur, of use
    ShouldBindWith() if you need to manage the error.`)
    return c.MustBindWith(obj, b)
}</code></pre>

如果要自訂訊息，請用 `ShouldBindWith`

<pre><code class="language-go">package main

import (
    "github.com/gin-gonic/gin"
)

type LoginForm struct {
    User     string `form:"user" binding:"required"`
    Password string `form:"password" binding:"required"`
}

func main() {
    router := gin.Default()
    router.POST("/login", func(c *gin.Context) {
        // you can bind multipart form with explicit binding declaration:
        // c.MustBindWith(&form, binding.Form)
        // or you can simply use autobinding with Bind method:
        var form LoginForm
        // in this case proper binding will be automatically selected
        if c.ShouldBindWith(&form) == nil {
            if form.User == "user" && form.Password == "password" {
                c.JSON(200, gin.H{"status": "you are logged in"})
            } else {
                c.JSON(401, gin.H{"status": "unauthorized"})
            }
        }
    })
    router.Run(":8080")
}</code></pre>

大致上是這些大修正，剩下的小功能或修正，請直接參考 [v1.2 releases log][4]。

 [1]: https://www.flickr.com/photos/appleboy/35582011972/in/dateposted-public/ "19807878_1634683919888714_743883353_o"
 [2]: https://github.com/gin-gonic/gin
 [3]: https://github.com/javierprovecho
 [4]: https://github.com/gin-gonic/gin/releases/tag/v1.2
 [5]: https://github.com/kardianos/govendor
 [6]: https://github.com/golang/dep
 [7]: https://github.com/gin-gonic/autotls
 [8]: https://letsencrypt.org
 [9]: https://golang.org/pkg/net/http/
 [10]: https://github.com/gin-gonic/gin/blob/v1.2/deprecated.go