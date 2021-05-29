---
title: Go 語言 1.11 版本推出 go module
author: appleboy
type: post
date: 2018-10-16T04:48:07+00:00
url: /2018/10/go-1-11-support-go-module/
dsq_thread_id:
  - 6973763514
categories:
  - Golang
tags:
  - golang

---
[<img src="https://i1.wp.com/farm1.staticflickr.com/908/40093179410_53df4bb9e8_z.jpg?w=840&#038;ssl=1" alt="Go-Logo_Blue" data-recalc-dims="1" />][1] 

本篇來聊聊 [Go 語言][2]在 1.11 版本推出的 [新功能][3]，相信大家也許還不知道此功能是做什麼用的，我們來回顧看看在初學 Go 語言的時候，最令人困擾的就是 `GOPATH`，所有的專案都必須要在 GOPATH 底下開發，然而在更久前還沒有 Vendor 時候，兩個專案用不同版本的同一個 Package 就必須要使用多個 GOPATH 來解決，但是隨著 Vendor 在 1.5 版的推出，解決了這問題，所以現在只要把專案放在 GOPATH 底下，剩下的 Package 管理都透過 Vendor 目錄來控管，在很多大型開源專案都可以看到把 Vendor 目錄放入版本控制已經是基本的 Best Practice，而 go module 推出最大功能用來解決 GOPATH 問題，也就是未來開發專案，**隨意讓開發者 clone 專案到任何地方都可以**，另外也統一個 Package 套件管理，不再需要 `Vendor` 目錄，底下舉個實際例子來說明。 

<!--more-->

## 影片介紹

此影片同步在 [Udemy 課程][4]內，如果有購買課程的朋友們，也可以在 Udemy 上面觀看，如果想學習更多 Go 語言教學，現在可以透過 **$1800** 價格購買。

## 傳統 go vendor 管理

先看個例子:

```go
package main

import (
    "fmt"

    "github.com/appleboy/com/random"
)

func main() {
    fmt.Println(random.String(10))
}
```

將此專案放在 `$GOPATH/src/github.com/appleboy/test` 這是大家寫專案必定遵守的目錄規則，而 vendor 管理則會從 [PackageManagementTools][5] 選擇一套。底下是用 [govendor][6] 來當作例子

```shell
$ govendor init
$ govendor fetch github.com/appleboy/com/random
```

最後用 `go build` 產生 binary

```shell
$ go build -v -o main .
```

如果您不在 `GOPATH` 裡面工作，就會遇到底下錯誤訊息:

    Error: Package "xxxx" not a go package or not in GOPATH

如果換到 Go 1.11 版本的 module 功能就能永久解決此問題

## 使用 go module

用 go module 解決兩個問題，第一專案內不必再使用 vendor 管理套件，第二開發者可以任意 clone 專案到任何地方，直接下 go build 就可以拿到執行檔了。底下是使用方式

```shell
project
--> main.go
--> main_test.go
```

初始化專案，先啟動 `GO111MODULE` 變數，在 go 1.11 預設是 `auto`

```shell
$ export GO111MODULE=on
$ go mod init github.com/appleboy/project
```

可以看到專案會多出一個 `go.mod` 檔案，用來記錄使用到的套件版本，如果本身已經在使用 vendor 管理，那麼 `mod init` 會自動將 vendor 紀錄的版本寫入到 `go.mod`。接著執行下載

```shell
$ go mod download
```

專案內會多出 `go.sum` 檔案，其實根本不用執行 `go mod download`，只要在專案內下任何 `go build|test|install` 指令，就會自動將 pkg 下載到 `GOPATH/pkg/mod` 內

```shell
$ tree ~/go/pkg/mod/github.com/
/Users/mtk10671/git/go/pkg/mod/github.com/
└── appleboy
    └── com@v0.0.0-20180410030638-c0b5901f9622
        ├── LICENSE
        ├── Makefile
        ├── README.md
        ├── array
        │   ├── array.go
        │   └── array_test.go
        ├── convert
        │   ├── convert.go
        │   └── convert_test.go
        ├── file
        │   ├── file.go
        │   └── file_test.go
        ├── random
        │   ├── random.go
        │   └── random_test.go
        └── vendor
            └── vendor.json
```

目前 go module 還在實驗階段，如果升級套件或下載套件有任何問題，請透過底下指令將 pkg 目錄清空就可以了。

```shell
$ go clean -i -x -modcache
```

## 心得

由於 go module 的出現，現在所有的開源專案都相繼支援，但是又要相容於 1.10 版本之前 (含 1.10)，所以變成要維護 `go.mod` 及 `vendor` 兩種版本。我個人感覺 go module 解決 GOPATH 問題，不再依賴此環境變數，讓想入門 Go 語言的開發者，可以快速融入開發環境。

# [程式碼範例][7]

 [1]: https://www.flickr.com/photos/appleboy/40093179410/in/dateposted-public/ "Go-Logo_Blue"
 [2]: https://golang.org
 [3]: https://github.com/golang/go/wiki/Modules
 [4]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-TOP
 [5]: https://github.com/golang/go/wiki/PackageManagementTools
 [6]: https://github.com/kardianos/govendor
 [7]: https://github.com/go-training/training/tree/master/example22-go-module-in-go.11