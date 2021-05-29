---
title: Go Module 如何發佈 v2 以上版本
author: appleboy
type: post
date: 2019-06-07T02:54:51+00:00
url: /2019/06/how-to-release-the-v2-or-higher-version-in-go-module/
dsq_thread_id:
  - 7462449915
categories:
  - Golang
tags:
  - go module
  - golang

---
[![golang logo][1]][1]

[Go Module][2] 是 [Golang][3] 推出的一套件管理系統，在 Go 1.11 推出後，許多 Package 也都陸續支援 Go Module 取代舊有的套件管理系統，像是 govendor 或 dep 等，而再過不久之後，保留 vendor 的方式也會被移除，畢竟現在開發已經不需要在 `GOPATH` 目錄底下了。對於 Go Module 不熟的話，建議先看官方今年寫的一篇[教學部落格][4]，底下是教學會涵蓋的範圍

  * Creating a new module.
  * Adding a dependency.
  * Upgrading dependencies.
  * Adding a dependency on a new major version.
  * Upgrading a dependency to a new major version.
  * Removing unused dependencies.

而本篇最主要會跟大家探討如何發佈 v2 以上的套件版本。

<!--more-->

## 教學影片

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## go.mod 版本管理

使用 `go mod init` 之後會在專案目錄產生 go.mod 檔案，裡面可以看到像是底下的訊息

```go
module github.com/go-ggz/ggz

go 1.12

require (
    firebase.google.com/go v3.8.0+incompatible
    github.com/appleboy/com v0.0.1
    github.com/appleboy/gofight/v2 v2.0.0
    gopkg.in/nicksrandall/dataloader.v5 v5.0.0
    gopkg.in/testfixtures.v2 v2.5.3
    gopkg.in/urfave/cli.v2 v2.0.0-20180128182452-d3ae77c26ac8
)
```

Go module 版本發佈請遵守 [semver.org][5] 規範，當然不只有 Go 語言，發佈其他語言的套件也請務必遵守。而在 Go module 內有說明『[Semantic Import Versioning][2]』裡面大意大致上是說，如果你的套件版本是 v1 以下，像是 `v1.2.3`，可以直接透過 `go get xxxx` 方式將套件版本寫入 `go.mod`，但是看上面的例子，可以發現有些奇怪的字眼，像是 `+incompatible` 等。如果是看到像底下的套件

```go
firebase.google.com/go v3.8.0+incompatible
```

表示使用此套件版本大於 `v1` 這時候是不可以直接下 `go get firebase.google.com/go`，而要在最後補上 `v4`，不過這也要看該套件是否有支援 v2, v3, v4 等版本號套件，像 `firebase` 就不支援 `v2, v3` 直接跳到 v4 去了。

```go
$ go get firebase.google.com/go/v4
```

就如同上面的

```go
    github.com/appleboy/gofight/v2 v2.0.0
    gopkg.in/nicksrandall/dataloader.v5 v5.0.0
    gopkg.in/testfixtures.v2 v2.5.3
```

而可以發現 gopkg.in 服務已經符合 semver 的需求在做後面補上了 `.v2` 或 `.v5` 所以並不會出現 `+incompatible` 字眼，另外在看 Go Module 也支援直接抓 Git 單個 Commit ID，相當方便。指令如下

```bash
go get github.com/appleboy/gorush@36a2e18
```

可以看到在 `go.mod` 出現如下:

```go
github.com/appleboy/gorush v1.12.1-0.20200623031759-36a2e181aa9b
```

## 發佈 v2 以上版本方式

官方提供了兩種做法讓開發者可以發佈 v2 以上版本，一種是透過主 branch，另一種是建立版本目錄，底下來一一說明，第一種是直接在主 branch，像是 `master` 內的 `go.mod` 內補上版本，底下是範例:

```go
module github.com/appleboy/gofight/v2
```

這時候你就可以陸續發佈 v2 版本的 Tag。大家可以發現這個方式，是不需要建立任何 sub folder，而另外一種方式是不需要改動 `go.mod`，直接在專案目錄內放置 `v2` 目錄，然後把所有程式碼複製一份到該目錄底下，接著繼續開發，這方式我個人不太建議，原因檔案容量會增加很快，也不好維護。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://github.com/golang/go/wiki/Modules#semantic-import-versioning
 [3]: https://golang.org
 [4]: https://blog.golang.org/using-go-modules
 [5]: https://semver.org/