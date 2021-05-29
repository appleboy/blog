---
title: 用 Docker Multi-Stage 編譯出 Go 語言最小 Image
author: appleboy
type: post
date: 2017-04-29T13:23:55+00:00
url: /2017/04/build-minimal-docker-container-using-multi-stage-for-go-app/
dsq_thread_id:
  - 5770768025
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - devops
  - Docker
  - golang

---
[<img src="https://i2.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_z.jpg?w=840&#038;ssl=1" alt="docker" data-recalc-dims="1" />][1]

之前應該沒寫過用 [Docker][2] 結合 Go 語言編譯出最小 Image 的文章，剛好趁這機會來介紹。其實網路上可以直接找到文章，像是這篇『[Building Minimal Docker Containers for Go Applications][3]』，那本文來介紹 Docker 新功能 [multi-stage builds][4]，此功能只有在 [17.05.0-ce][5] 才支援，看起來是 2017/05/03 號會 release 出來。我們拿 Go 語言的 Hello World 來介紹 Single build 及 Multiple build。

<!--more-->

## Single build

底下是 Go 語言 Hello World 範例:

<pre><code class="language-go">package main

import "fmt"

func main() {
    fmt.Println("Hello World!")
}</code></pre>

接著用 [alpine][6] 的 Go 語言 Image 來編譯出執行檔。

<pre><code class="language-bash">FROM golang:alpine
WORKDIR /app
ADD . /app
RUN cd /app && go build -o app
ENTRYPOINT ./app</code></pre>

接著執行底下編譯指令:

<pre><code class="language-bash">$ docker build -t appleboy/go-app .
$ docker run --rm appleboy/go-app</code></pre>

最後檢查看看編譯出來的 Image 大小，使用 `docker images | grep go-app`，會發現 Image 大小為 **258 MB**

## Multiple build

Multiple build 則是可以在 `Dockerfile` 使用多個不同的 Image 來源，請看看底下範例

<pre><code class="language-bash"># build stage
FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && go build -o app

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /src/app /app/
ENTRYPOINT ./app</code></pre>

從上面可以看到透過 `AS` 及 `--from` 互相溝通，以前需要寫兩個 Dockerfile，現在只要一個就可以搞定。最後一樣執行編譯指令:

<pre><code class="language-bash">$ docker build -t appleboy/go-app .
$ docker run --rm appleboy/go-app</code></pre>

會發現最後大小為 **6.35 MB**，比上面是不是小了很多。

## 最小 Image？

**6.35 MB** 是最小的 Image 了嗎？才單單一個 Hello World 執行檔，用 Docker 包起來竟然要 6.35，其實不用這麼大，我們可以透過 Dokcer 所提供的最小 Image: [scratch][7]，將執行檔直接包進去即可，在編譯執行檔需加入特定參數才可以:

<pre><code class="language-bash">$ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app</code></pre>

再透過 Docker 包起來

<pre><code class="language-bash">FROM centurylink/ca-certs

ADD app /

ENTRYPOINT ["/app"]</code></pre>

編譯出來大小為: **1.81MB**，相信這是最小的 Image 了。最後用 Docker 來包

<pre><code class="language-bash"># build stage
FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

# final stage
FROM centurylink/ca-certs
COPY --from=build-env /src/app /
ENTRYPOINT ["/app"]</code></pre>

## 結論

Multiple build 非常方便，這樣就可以將多個步驟全部合併在一個 Dockerfile 處理掉，像是底下例子

<pre><code class="language-bash">from debian as build-essential
arg APT_MIRROR
run apt-get update
run apt-get install -y make gcc
workdir /src

from build-essential as foo
copy src1 .
run make

from build-essential as bar
copy src2 .
run make

from alpine
copy --from=foo bin1 .
copy --from=bar bin2 .
cmd ...</code></pre>

用一個 Dockerfile 產生多個執行檔，最後再用 alpine 打包成 Image。

# 附上[本篇程式碼範例][8]

 [1]: https://www.flickr.com/photos/appleboy/25660808075/in/dateposted-public/ "docker"
 [2]: https://www.docker.com/
 [3]: https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/
 [4]: https://github.com/moby/moby/pull/32063
 [5]: https://github.com/moby/moby/releases/tag/v17.05.0-ce-rc1
 [6]: https://hub.docker.com/_/alpine/
 [7]: https://hub.docker.com/_/scratch/
 [8]: https://github.com/appleboy/docker-multi-stage-build