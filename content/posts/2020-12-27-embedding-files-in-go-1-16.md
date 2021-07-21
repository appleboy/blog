---
title: Go 1.16 推出 Embedding Files
author: appleboy
type: post
date: 2020-12-27T08:32:08+00:00
url: /2020/12/embedding-files-in-go-1-16/
dsq_thread_id:
  - 8331861884
categories:
  - Golang
tags:
  - Docker
  - golang

---
[![golang logo][1]][1]

[Go 語言][2]官方維護團隊 rsc 之前在 [GitHub Issue][3] 上面提出要在 go command line 直接支援 Embedding Files，沒想到過沒幾個月，就直接實現出來了，並且預計在 2021 的 [go 1.16][4] 版本直接支援 [embed 套件][5]。有了這個功能，就可以將靜態檔案或專案設定檔直接包起來，這樣部署就更方便了。底下來看看官方怎麼使用。

<!--more-->

## 影片教學

{{< youtube EKeQmftmpV8 >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][6]
  * [一天學會 DevOps 自動化測試及部署][7]
  * [DOCKER 容器開發部署實戰][8]

如果需要搭配購買請直接透過 [FB 聯絡我][9]，直接匯款（價格再減 **100**）

## embed package

直接看官方給的例子:

```go
package main

import (
	"embed"
)

//go:embed hello.txt
var s string

//go:embed hello.txt
var b []byte

//go:embed hello.txt
var f embed.FS

func main() {
	print(s)
	print(string(b))
	data, _ := f.ReadFile("hello.txt")
	print(string(data))
}
```

可以看到關鍵字: `go:embed`，透過註解就可以將靜態檔案直接使用在開發上面，另外也可以引用多個檔案或多個目錄:

```go
package server

import "embed"

// content holds our static web server content.
//go:embed image/* template/*
//go:embed html/index.html
var content embed.FS
```

可以看到 `go:embed` 支援多個目錄，單一檔案或多個檔案都可以，假如沒有用到 `embed.FS`，請在 import 時加上 `_`，範例如下:

```go
package main

import _ "embed"

//go:embed hello.txt
var s string

//go:embed hello.txt
var b []byte

func main() {
    print(s)
    print(string(b))
}
```

有了這個 Package 後，再也不需要[第三方套件 Resource Embedding][10] 了，底下來看看如何將 embed 套件整合進 [Gin][11]？

## 整合 Gin Framework

先假設 Gin 需要包含靜態圖片及 Template，底下是目錄結構:

```bash
├── assets
│   ├── favicon.ico
│   └── images
│       └── example.png
├── go.mod
├── go.sum
├── main.go
└── templates
    ├── foo
    │   └── bar.tmpl
    └── index.tmpl
```

該如何將 Template 跟 assets 目錄直接打包進 Go 呢？直接看 `main.go`

```go
package main

import (
    "embed"
    "html/template"
    "net/http"

    "github.com/gin-gonic/gin"
)

//go:embed assets/* templates/*
var f embed.FS

func main() {
    router := gin.Default()
    templ := template.Must(template.New("").ParseFS(f, "templates/*.tmpl", "templates/foo/*.tmpl"))
    router.SetHTMLTemplate(templ)

    // example: /public/assets/images/example.png
    router.StaticFS("/public", http.FS(f))

    router.GET("/", func(c *gin.Context) {
        c.HTML(http.StatusOK, "index.tmpl", gin.H{
            "title": "Main website",
        })
    })

    router.GET("/foo", func(c *gin.Context) {
        c.HTML(http.StatusOK, "bar.tmpl", gin.H{
            "title": "Foo website",
        })
    })

    router.GET("favicon.ico", func(c *gin.Context) {
        file, _ := f.ReadFile("assets/favicon.ico")
        c.Data(
            http.StatusOK,
            "image/x-icon",
            file,
        )
    })

    router.Run(":8080")
}
```

開發者可以很簡單用兩行就將靜態檔案直接包進來:

```go
//go:embed assets/* templates/*
var f embed.FS
```

靜態檔案的 route 可以直接透過底下設定:

```go
// example: /public/assets/images/example.png
router.StaticFS("/public", http.FS(f))
```

也可以透過 `ReadFile` 讀取單一檔案:

```go
router.GET("favicon.ico", func(c *gin.Context) {
    file, _ := f.ReadFile("assets/favicon.ico")
    c.Data(
        http.StatusOK,
        "image/x-icon",
        file,
    )
})
```

程式範例可以直接在[這邊找到][12]。

## 心得

Go 團隊真的蠻用心的，會比一些常用核心的功能納入官方維護，以保持後續的更新，有了這項功能，在 Go 的部署流程，直接可以略過靜態檔案加入 Docker 內了。未來專案有些保密檔案也可以透過此方式直接在 CI 流程內先換掉，再進行 go build 了。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org
 [3]: https://github.com/golang/go/issues/41191
 [4]: https://tip.golang.org/doc/go1.16
 [5]: https://tip.golang.org/pkg/embed/
 [6]: https://www.udemy.com/course/golang-fight/?couponCode=202012
 [7]: https://www.udemy.com/course/devops-oneday/?couponCode=202012
 [8]: https://www.udemy.com/course/docker-practice/?couponCode=202012
 [9]: http://facebook.com/appleboy46
 [10]: https://github.com/avelino/awesome-go#resource-embedding
 [11]: https://gin-gonic.com/
 [12]: https://github.com/go-training/training/tree/master/example40-embedding-files
