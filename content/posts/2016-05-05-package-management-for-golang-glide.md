---
title: Golang 套件管理工具 Glide
author: appleboy
type: post
date: 2016-05-05T01:00:15+00:00
url: /2016/05/package-management-for-golang-glide/
dsq_thread_id:
  - 4800934901
categories:
  - Golang
tags:
  - glide
  - golang

---
[![][1]][1]

套件版本管理已經是各大語言不可或缺的工具，像是 [Node.js][2] 有 [npm][3]，[PHP][4] 有 [Composer][5]，[Ruby][6] 有 [RVM][7] 等...，都已經發展很成熟了，但是在 [Golang][8] 語言呢，在 Go 1.5 以後的版本，可以透過 `GO15VENDOREXPERIMENT` 或 [Glide][9] 來管理套件版本，在 Go 官方網站也有整理一份 [Wiki][10]，開發者可以選一套適合自己的來使用，而今天要介紹這套 [Glide][11]，在開始之前，大家先來了解 Go 提出的 `vendor experiment`。

<!--more-->

## vendor experiment

Golang 1.5 版本提出 `vendor experiment` 功能，讓每個 Package 都可以擁有自己的 `vendor` 目錄，當 compiler 要找尋 import package 時，會預設先從 `vendor` 目錄找起，如果沒有的話就會繼續找 `$GOPATH` 最後找 `$GOROOT`。底下來看一個 Project 範例。

### example

<pre><code class="language-bash">- $GOPATH/src/github.com/example/foo
  |
  -- main.go
  |
  -- vendor/
       |
       -- github.com/example/bar</code></pre>

在這範例可以看到有主程式 `main.go`，在 main.go 內 import `github.com/example/bar`，系統就會把相關 import package 都下載到 `vendor` 目錄，取代原本會下載到 `$GOPATH` 目錄，這邊要注意的是，開發中的專案目錄（在這範例是 `github.com/example/foo`），**務必要放在 `$GOPATH` 目錄內**。如果你還在用 go 1.5 版本，請記得加上環境變數 `GO15VENDOREXPERIMENT=1`，1.6 版本已經預設將 `GO15VENDOREXPERIMENT` 設定為 1 了，不知道環境變數可以透過 `go env` 看看目前 go 變數狀態。

## Glide 套件管理

Glide 是 golang 套件管理工具，用來管理專案的 `vendor` 目錄，開發者可以透過 Glide 建議各專案的 `glide.yaml` 設定檔，並且定義相關套件版本資訊，Glide 會負責將套件下載到 `vendor` 目錄內。底下是 Glide 安裝方式。

### 安裝 Glide

安裝 Glide 非常簡單，可以直接到 [Github 下載 Binary][11] 執行檔，或者是透過 go 來安裝

<pre><code class="language-bash">$ go get github.com/Masterminds/glide
$ cd $GOPATH/src/github.com/Masterminds/glide && make install</code></pre>

### 使用 Glide

在專案內直接執行底下指令來建立 `glide.yaml` 設定檔

<pre><code class="language-bash">$ glide init
# 或
$ glide create</code></pre>

產生出來的 `glide.yaml` 格式如下

<pre><code class="language-yml">package: github.com/appleboy/gorush
import:
- package: gopkg.in/yaml.v2
- package: gopkg.in/redis.v3
- package: github.com/Sirupsen/logrus
  version: v0.10.0
- package: github.com/appleboy/gin-status-api
- package: github.com/fvbock/endless
- package: github.com/gin-gonic/gin
- package: github.com/google/go-gcm
- package: github.com/sideshow/apns2
  subpackages:
  - certificate
  - payload
- package: github.com/stretchr/testify
- package: github.com/asdine/storm
- package: github.com/appleboy/gofight
- package: github.com/buger/jsonparser</code></pre>

如果原本專案內就有使用 [Godep][12], [GPM][13], or [GB][14] 等套件管理，Glide 會自動把該套件無痛整合進來。完成後可以透過 `glide up` 或 `glide install` 來安裝相關套件。兩個指令差別在哪？如果專案內沒有 `glide.lock` 檔案，當您執行 `glide install` 後，其實系統會先執行 `glide up` 產生 `glide.lock` 檔案，glide.lock 內記錄了所以套件版本資訊。你可以把 glide.lock 想像成 PHP 的 `composer.lock`。

<pre><code class="language-yml">hash: 4e05c4dd1a8106a87fee3b589dd32aecc7ffeb1246bed8f8516b32fe745034d6
updated: 2016-05-04T14:26:47.161898051+08:00
imports:
- name: github.com/alecthomas/kingpin
  version: e1543c77ba157565dbf7b3e8e4e15087a120397f
- name: github.com/alecthomas/template
  version: a0175ee3bccc567396460bf5acd36800cb10c49c
  subpackages:
  - parse</code></pre>

也就是專案內使用了 A 套件，A 又使用了 B，這樣 Glide 會把套件 hash 值記錄在 `glide.lock` 檔案內，其他開發者下載您的專案後，只需要下 `glide install` 就可以開始 build binary 了。如果要安裝單一套件呢，可以使用 `glide get` 指令，該指令會將新的套件寫入 `glide.yaml` 設定檔。

<pre><code class="language-bash">$ glide get --all-dependencies -s -v github.com/gin-gonic/gin</code></pre>

  * `--all-dependencies`: 下載相依套件全部的 dependencies
  * `-s`: 下載後刪除 .git 目錄
  * `-v`: 移除 `Godeps/_workspace` 等相關目錄

當然你也可以指定套件版號

<pre><code class="language-bash">$ glide get --all-dependencies -s -v github.com/gin-gonic/gin#v1.0rc1</code></pre>

如果是想更新全部 dependencies 寫到 `glide.lock`，可以直接下底下指令，Glide 會把套件 dependencies 全部下載到 `vender` 內，就好比執行 `go get -d -t ./...` 指令一樣。

<pre><code class="language-bash">$ glide update --all-dependencies --resolve-current</code></pre>

## 結論

使用套件管理後，務必將 `glide.lock` 加入版本控制，更新時請務必看看各套件的 Changelog，並且將測試寫完整。如果是 API 測試，可以參考之前寫的一篇測試工具 [用 gofight 來測試 golang web API handler][15]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]:  https://nodejs.org/en/
 [3]: https://www.npmjs.com/
 [4]: https://php.net
 [5]: https://getcomposer.org/
 [6]: https://www.ruby-lang.org/en/
 [7]: https://rvm.io/
 [8]: https://golang.org/
 [9]: https://glide.sh/
 [10]: https://github.com/golang/go/wiki/PackageManagementTools
 [11]: https://github.com/Masterminds/glide
 [12]: https://github.com/tools/godep
 [13]: https://github.com/pote/gpm
 [14]: https://getgb.io/
 [15]: https://blog.wu-boy.com/2016/04/gofight-tool-for-api-handler-testing-in-golang/