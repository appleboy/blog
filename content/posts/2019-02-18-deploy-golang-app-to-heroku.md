---
title: 快速部署網站到 Heroku 雲平台
author: appleboy
type: post
date: 2019-02-18T02:56:19+00:00
url: /2019/02/deploy-golang-app-to-heroku/
dsq_thread_id:
  - 7239630090
categories:
  - DevOps
  - Docker
  - Git
  - Golang
tags:
  - Docker
  - golang
  - Heroku

---
[![部署網站到 Heroku 平台][1]][1]

大家在寫開源專案時，一定需要一個免費的雲空間來放置網站，方便其他開發者在 [GitHub][2] 看到時，可以先點選 Demo 網站來試用，也許開發者可以使用 GitHub 提供的免[費靜態網站][3]，但是如果是跑 [Golang][4] 或是其他語言 [Node.js][5] 就不支援了，本篇來介紹 [Heroku 雲平台][6]，它提供了開發者免費的方案，您可以將 GitHub 儲存庫跟 Heroku 結合，快速的將程式碼部署上去，Heroku 會給開發者一個固定的 URL (含有 HTTPS 憑證)，也可以動態的用自己買的網域。最重要的是 Heroku 提供了兩種更新方式，第一為 Git，只要開發者將程式碼 Push 到 Heroku 儲存庫，Heroku 就可以自動判斷開發者上傳的語言，並進行相對應的部署，另一種方式為 [Docker][7] 部署，只要在儲存庫內放上 Dockerfile，透過 [Heroku CLI][8] 指令就可以將 Docker 容器上傳到 [Heroku Docker Registry][9]，並且自動部署網站。底下我們來透過簡單的 Go 語言專案: [Facebook Account Kit][10] 來說明如何快速部署到 Heroku。

<!--more-->

## 教學影片

歡迎訂閱[我的 Youtube 頻道][11]

## 使用 Git 部署

註冊網站後，可以直接在後台建立 App，此 App 名稱就是未來的網站 URL 前置名稱。進入 App 的後台，切換到 Deploy 的 Tab 可以看到 Heroku 提供了三種方式，本文只會講其中兩種，在開始之前請先安裝好 [Heroku CLI][12] 工具，底下所有操作都會以 CLI 介面為主。用 Git 來部署是最簡單的，開發者可以不用考慮任何情形，只要將程式碼部署到 Heroku 上面即可。在 Go 語言只要觸發 Push Event 系統會預設使用 go1.11.4 來編譯環境，產生的 Log 如下:

<pre><code class="language-go">-----> Go app detected
-----> Fetching jq... done
 !!    
 !!    Go modules are an experimental feature of go1.11
 !!    Any issues building code that uses Go modules should be
 !!    reported via: https://github.com/heroku/heroku-buildpack-go/issues
 !!    
 !!    Additional documentation for using Go modules with this buildpack
 !!    can be found here: https://github.com/heroku/heroku-buildpack-go#go-module-specifics
 !!    
 !!    The go.mod file for this project does not specify a Go version
 !!    
 !!    Defaulting to go1.11.4
 !!    
 !!    For more details see: https://devcenter.heroku.com/articles/go-apps-with-modules#build-configuration
 !!    
-----> Installing go1.11.4
-----> Fetching go1.11.4.linux-amd64.tar.gz... done
 !!    Installing package '.' (default)
 !!    
 !!    To install a different package spec add a comment in the following form to your `go.mod` file:
 !!    // +heroku install ./cmd/...
 !!    
 !!    For more details see: https://devcenter.heroku.com/articles/go-apps-with-modules#build-configuration
 !!    
-----> Running: go install -v -tags heroku . </code></pre>

系統第一步會偵測該專案使用什麼語言，就會產生相對應得環境，所以用 Git 方式非常簡單，開發者不需要額外設定就可以看到網站已經部署完畢，底下是 Git 基本操作，首先是登入 Heroku 平台。這邊會打開瀏覽器登入視窗。

<pre><code class="language-sh">$ heroku login</code></pre>

新增 Heroku 為另一個 Remote 節點

<pre><code class="language-sh">$ heroku git:clone -a heroku-demo-tw
$ cd heroku-demo-tw</code></pre>

簡單編輯程式碼，並且推到 Heroku Git 服務

<pre><code class="language-sh">$ git add .
$ git commit -am "make it better"
$ git push heroku master</code></pre>

## 使用 Docker 部署

Heroku 也提供免費的 Docker Registry 讓開發者可以寫 [Dockerfile][13] 來部署，底下是透過 [Docker multiple stage][14] 來編譯 Go 語言 App

<pre><code class="language-docker">FROM golang:1.11-alpine as build_base
RUN apk add bash ca-certificates git gcc g++ libc-dev
WORKDIR /app
# Force the go compiler to use modules
ENV GO111MODULE=on
# We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
RUN go mod download

# This image builds the weavaite server
FROM build_base AS server_builder
# Here we copy the rest of the source code
COPY . .
ENV GOOS=linux
ENV GOARCH=amd64
RUN go build -o /facebook-account-kit -tags netgo -ldflags '-w -extldflags "-static"' .

### Put the binary onto base image
FROM plugins/base:linux-amd64
LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>"
EXPOSE 8080
COPY --from=server_builder /app/templates /templates
COPY --from=server_builder /app/images /images
COPY --from=server_builder /facebook-account-kit /facebook-account-kit
CMD ["/facebook-account-kit"]</code></pre>

這裡面有一個小技巧，讓每次 Docker 編譯時可以 cache 住 golang 的 vendor，就是底下這兩行啦

<pre><code class="language-dockerfile"># We want to populate the module cache based on the go.{mod,sum} files.
COPY go.mod .
COPY go.sum .
RUN go mod download</code></pre>

這時候只要我們沒有動過 `go.*` 相關檔案，每次編譯時系統就會自動幫忙 cache 相關 vendor 套件，加速網站部署，完成上述設定後，接著用 Heroku CLI 來完成最後步驟。首先在開發電腦上面必須安裝好 Docker 環境，可以透過底下指令來確認電腦是否有安裝好 Docker

<pre><code class="language-sh">$ docker ps</code></pre>

現在可以登入 Container Registry Now you can sign into Container Registry.

<pre><code class="language-sh">$ heroku container:login</code></pre>

上傳 Docker 映像檔到 Heroku，這邊會在 Local 直接編譯產生 Image

<pre><code class="language-sh">$ heroku container:push web</code></pre>

上面步驟只是上傳而已，並非部署上線，透過底下指令才能正確看到網站更新。

<pre><code class="language-sh">$ heroku container:release web</code></pre>

## 心得

上面所有的程式碼都可以在[這邊找到][15]，這邊我個人推薦使用 Docker 方式部署，原因很簡單，如果使用 Docker 部署，未來您不想使用 Heroku，就可以很輕易地轉換到 [AWS][16] 或 [GCP][17] 等平台，畢竟外面的雲平台不可以提供 Git 服務並且自動部署。使用 Docker 形式也可以減少很多部署的工作，對於未來轉換平台來說是非常方便的。

 [1]: https://lh3.googleusercontent.com/jx4kYMmehnuyhVbEhvZKNEQwjCAgcTg2JIQamusY9-SuIbEEvJl2zXLJidfq-m9Oy1PQrROA9GQxdjjSiRVsvAGIj3tikwT0ZNB9XhciyCwjE60XE_jDJIqqEMmaKqwDzCMirK0u7Hw=w1920-h1080 "部署網站到 Heroku 平台"
 [2]: https://github.com "GitHub"
 [3]: https://pages.github.com/ "費靜態網站"
 [4]: https://golang.org "Golang"
 [5]: https://nodejs.org/ "Node.js"
 [6]: https://www.heroku.com/ "Ｈeroku 雲平台"
 [7]: https://www.docker.com/ "Docker"
 [8]: https://devcenter.heroku.com/articles/heroku-cli "Heroku CLI"
 [9]: https://devcenter.heroku.com/articles/container-registry-and-runtime "Heroku Docker Registry"
 [10]: https://github.com/go-training/facebook-account-kit "Facebook Account Kit"
 [11]: http://bit.ly/youtube-boy "我的 Youtube 頻道"
 [12]: https://devcenter.heroku.com/articles/heroku-command-line "Heroku CLI"
 [13]: https://github.com/go-training/facebook-account-kit/blob/1faa35cf83e3e00c8b48e3047d676c379a1aef44/Dockerfile#L1 "Dockerfile"
 [14]: https://blog.wu-boy.com/2017/04/build-minimal-docker-container-using-multi-stage-for-go-app/ "Docker multiple stage"
 [15]: https://github.com/go-training/facebook-account-kit "這邊找到"
 [16]: https://aws.amazon.com/ "AWS"
 [17]: https://cloud.google.com/gcp "GCP"