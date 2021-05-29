---
title: 使用 Docker BuildKit 加速編譯 Image
author: appleboy
type: post
date: 2020-04-26T05:29:32+00:00
url: /2020/04/speed-up-docker-build-using-docker-buildkit/
dsq_thread_id:
  - 7991987887
categories:
  - Docker
  - Golang
tags:
  - BuildKit
  - Docker
  - golang

---
[![docker buildkit][1]][1]

> [程式碼範例請看這邊][2]

之前就有看到 [Docker][3] 推出 [BuildKit][4] 功能，這次跟大家介紹什麼是 BuildKit。現在部署編譯流程肯定都會用到 Docker，不管測試及部署都盡量在 Docker 內實現，來做到環境隔離，但是要怎麼縮短 Docker 在編譯 Image 時間，這又是另外的議題，本篇跟大家介紹一個實驗性的功能就是 [BuildKit][4]，原始碼可以[參考這邊][5]，希望未來這實驗性的功能可以正式納入 Docker 官方，網路上其實可以找到很多方式來做 Docker Layer 的 Cache，我個人最常用的就是 `--cache-from` 機制，可以適用在任何 CI/CD 流程，詳細說明可以參考這篇『[在 docker-in-docker 環境中使用 cache-from 提升編譯速度][6]』，下面使用到的程式碼都可以直接參考[此 Repository][2]，我還是使用 [Go 語言][7]當作參考範例。

<!--more-->

## 教學影片

{{< youtube ZSUw4UvnRWI >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][8]
  * [一天學會 DevOps 自動化測試及部署][9]
  * [DOCKER 容器開發部署實戰][10] (課程剛啟動，限時特價 $900 TWD)

如果需要搭配購買請直接透過 [FB 聯絡我][11]，直接匯款（價格再減 **100**）

## 事前準備

由於 [BuildKit][4] 是實驗性的功能，預設安裝好 Docker 是不會啟動這功能。目前只有支援編譯 Linux 容器。請透過底下方式來啟動:

```shell=
DOCKER_BUILDKIT=1 docker build .
```

下完指令後，你會發現整個 output 結果不太一樣了，介面變得比較好看，也看到每個 Layer 編譯的時間

```shell=
[+] Building 0.1s (15/15) FINISHED                                                                                     
 => [internal] load .dockerignore                                                                                 0.0s
 => => transferring context: 2B                                                                                   0.0s
 => [internal] load build definition from Dockerfile                                                              0.0s
 => => transferring dockerfile: 545B                                                                              0.0s
 => [internal] load metadata for docker.io/library/golang:1.14-alpine                                             0.0s
 => [1/10] FROM docker.io/library/golang:1.14-alpine                                                              0.0s
 => [internal] load build context                                                                                 0.0s
 => => transferring context: 184B                                                                                 0.0s
 => CACHED [2/10] RUN apk add bash ca-certificates git gcc g++ libc-dev                                           0.0s
 => CACHED [3/10] WORKDIR /app                                                                                    0.0s
 => CACHED [4/10] COPY go.mod .                                                                                   0.0s
 => CACHED [5/10] COPY go.sum .                                                                                   0.0s
 => CACHED [6/10] RUN go mod download                                                                             0.0s
 => CACHED [7/10] COPY main.go .                                                                                  0.0s
 => CACHED [8/10] COPY foo/foo.go foo/                                                                            0.0s
 => CACHED [9/10] COPY bar/bar.go bar/                                                                            0.0s
 => CACHED [10/10] RUN go build -o /app -v -tags netgo -ldflags '-w -extldflags "-static"' .                      0.0s
 => exporting to image                                                                                            0.0s
 => => exporting layers                                                                                           0.0s
 => => writing image sha256:6cc56539b3191d5efd87fb4d05181993d013411299b5cefb74047d2447b4d0c9                      0.0s
 => => naming to docker.io/appleboy/demo                                                                          0.0s
```

如果要詳細的編譯步驟，請加上 `--progress=plain`，就可以看到詳細的過程。其實我覺得重點在每個步驟都實際追加了時間，對於在開發上或者是 CI/CD 的流程上都相當有幫助。另外可以在 docker daemon 加上 config 就可以不用加上 `DOCKER_BUILDKIT` 環境變數

```json
{
  "debug": true,
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
```

請記得重新啟動 Docker 讓新的設定生效。

## 不使用 BuildKit 編譯

這邊我們直接拿 Go 語言基本範例來測試看看到底省下多少時間，程式碼都可以在[這裡找到][2]，底下是範例:

```go
package main

import (
    "net/http"

    "gin/bar"
    "gin/foo"

    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()
    r.GET("/ping", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": "pong",
        })
    })
    r.GET("/ping2", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": "pong2",
        })
    })
    r.GET("/ping100", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": foo.Foo(),
        })
    })
    r.GET("/ping101", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": bar.Bar(),
        })
    })
    r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
```

接著撰寫 Dockerfile

```dockerfile
FROM golang:1.14-alpine

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>"

RUN apk add bash ca-certificates git gcc g++ libc-dev
WORKDIR /app
# Force the go compiler to use modules
ENV GO111MODULE=on
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY main.go .
COPY foo/foo.go foo/
COPY bar/bar.go bar/

ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -o /app -v -tags netgo -ldflags '-w -extldflags "-static"' .

CMD ["/app"]
```

可以看到如果 go.mode 跟 go.sum 如果沒有任何變動，基本上 go module 檔案自然就可以透過 docker cache layer 處理。但是每次只要程式碼有任何異動，最後的 go build 會從無到有編譯，請看底下結果:

```sh
docker build --progress=plain -t appleboy/docker-demo -f Dockerfile .
#14 [10/10] RUN go build -o /app -v -tags netgo -ldflags '-w -extldflags "-s...
#14 0.391 gin/foo
#14 0.403 gin/bar
#14 0.412 github.com/go-playground/locales/currency
#14 0.438 github.com/gin-gonic/gin/internal/bytesconv
#14 0.441 github.com/go-playground/locales
#14 0.449 golang.org/x/sys/unix
#14 0.464 net
#14 0.471 github.com/gin-gonic/gin/internal/json
#14 0.508 github.com/go-playground/universal-translator
#14 0.511 github.com/leodido/go-urn
#14 0.694 github.com/golang/protobuf/proto
#14 0.754 gopkg.in/yaml.v2
#14 1.535 github.com/mattn/go-isatty
#14 1.789 net/textproto
#14 1.790 crypto/x509
#14 1.920 vendor/golang.org/x/net/http/httpproxy
#14 1.978 vendor/golang.org/x/net/http/httpguts
#14 2.019 github.com/go-playground/validator/v10
#14 2.434 crypto/tls
#14 3.043 net/http/httptrace
#14 3.085 net/http
#14 4.211 net/rpc
#14 4.212 github.com/gin-contrib/sse
#14 4.212 net/http/httputil
#14 4.372 github.com/ugorji/go/codec
#14 6.322 github.com/gin-gonic/gin/binding
#14 6.322 github.com/gin-gonic/gin/render
#14 6.517 github.com/gin-gonic/gin
#14 6.819 gin
#14 DONE 7.8s
```

總共花了 7.8 秒，但是各位想想，在自己電腦開發時，不會這麼久，而是會根據修正過的 Go 檔案才會進行編譯，但是在 CI/CD 流程怎麼做到呢？其實可以發現在電腦裡面都有 Cache 過已經編譯過的檔案。在 Linux 環境會是 `/root/.cache/go-build`。那我們該如何透過 buildKit 加速編譯？

## 使用 BuildKit 編譯

先來看看在 Dockerfile 該如何改進才可以讓編譯加速？底下看看

```dockerfile
# syntax = docker/dockerfile:experimental
FROM golang:1.14-alpine

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>"

RUN --mount=type=cache,target=/var/cache/apk apk add bash ca-certificates git gcc g++ libc-dev
WORKDIR /app

# Force the go compiler to use modules
ENV GO111MODULE=on
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
RUN --mount=type=cache,target=/go/pkg/mod go mod download
COPY main.go .
COPY foo/foo.go foo/
COPY bar/bar.go bar/

ENV GOOS=linux
ENV GOARCH=amd64
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build go build -o /app -v -tags netgo -ldflags '-w -extldflags "-static"' .

CMD ["/app"]
```

首先看到第一行是務必要填寫

```dockerfile
# syntax = docker/dockerfile:experimental
```

接著使用 `--mount` 方式進行檔案 cache，可以在任何 `RUN` 的步驟進行。所以可以看到在 go build 地方使用了:

```dockerfile
RUN --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build
```

可以看到此步驟將 go module 及 build 後的檔案全部 cache 下來，這樣下次編譯的時候，就會自動將檔案預設放在對應的位置，加速編譯流程

```sh
docker build --progress=plain -t appleboy/docker-buildkit -f Dockerfile.buildkit .
#16 [stage-0 10/10] RUN --mount=type=cache,target=/go/pkg/mod --mount=type=c...
#16 0.381 gin/foo
#16 0.447 gin
#16 DONE 1.2s
```

可以看到修改了檔案後，編譯的結果跟在自己電腦上一模一樣，縮短了六秒時間，在大型的 Go 專案省下的時間可不少啊。

## 心得

現在 CI/CD 的工具不確定都有支持 docker buildKit，可能要自己做實驗試試看，像是現在 GitHub Action 官方也[不支援 docker buildkit][12]。如果是全部自己架設的話，基本上可以完全使用 docker buildKit + docker cache-from 兩者一起用，相信會省下不少時間啊。[程式碼範例請看這邊][2]

 [1]: https://lh3.googleusercontent.com/fr-DxVaFf3lryJs-FUfDOp-azBpG7_atca4zJGuipRMUshXX-ICZXB9PdrqevF8DHRwUhG8gVrfI8jSv5LjS0Yj4R-dovaucEyCZ8U6hz68iYYU30RTFqdjO-u8ozGaPmPsyD5Ax-4c=w1920-h1080 "docker buildkit"
 [2]: https://github.com/go-training/docker-buildkit-demo
 [3]: https://docker.com
 [4]: https://docs.docker.com/develop/develop-images/build_enhancements/
 [5]: https://github.com/moby/buildkit
 [6]: https://blog.wu-boy.com/2019/02/using-cache-from-can-speed-up-your-docker-builds/
 [7]: https://golang.org
 [8]: https://www.udemy.com/course/golang-fight/?couponCode=202004
 [9]: https://www.udemy.com/course/devops-oneday/?couponCode=202004
 [10]: https://www.udemy.com/course/docker-practice/?couponCode=202004
 [11]: http://facebook.com/appleboy46
 [12]: https://github.com/docker/github-actions/issues/12
