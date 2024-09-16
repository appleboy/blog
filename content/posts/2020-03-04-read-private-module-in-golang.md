---
title: Go Modules 處理 Private GIT Repository 流程
author: appleboy
type: post
date: 2020-03-04T14:41:21+00:00
url: /2020/03/read-private-module-in-golang/
dsq_thread_id:
  - 7899742188
categories:
  - Docker
  - Drone CI
  - Golang
tags:
  - Docker
  - golang

---
![golang][1]

[Golang][2] 在 [1.14][3] 正式說明可以將 [Go Modules][4] 用在正式環境上了，還沒換上 Go Modules 的團隊，現在可以開始轉換了，轉換方式也相當容易啦，只要在原本的專案底下執行底下指令，就可以無痛轉移

```bash
go mod init project_path
go mod tidy
```

假設專案內有用到私有 Git Repository 該怎麼解決了？現在 go mod 會預設走 `proxy.golang.org` 去抓取最新的資料，但是要抓私有的，就需要透過其他方式:

```bash
go env -w GOPRIVATE=github.com/appleboy
```

上面代表告訴 go 指令，只要遇到 `github.com/appleboy` 就直接讀取，不需要走 Proxy 流程。拿 GitHub 當作範例，在本機端開發該如何使用？首先要先去申請 [Personal Access Token][5]，接著設定 Git

```bash
git config --global url."https://$USERNAME:$ACCESS_TOKEN@github.com".insteadOf "https://github.com"
```

其中 Username 就是 GitHub 帳號，Access token 就是上面的 [Personal Access Token][5]。如果在本機端執行，本身有 SSH Key 的話，就不需要這個 Access Token，直接用 SSH Key 就可以了。

```bash
git config --global url.ssh://git@your.private.git/.insteadOf https://your.private.git/
```

<!--more-->

## 教學影片

影片只上傳到 Udemy，如果對於課程內容有興趣，可以參考底下課程。

* [Go 語言基礎實戰 (開發, 測試及部署)][6]
* [一天學會 DevOps 自動化測試及部署][7]
* [DOCKER 容器開發部署實戰][8] (課程剛啟動，限時特價 $800 TWD)

如果需要搭配購買請直接透過 [FB 聯絡我][9]，直接匯款（價格再減 **100**）

## 搭配 Drone CI/CD

在串 CI/CD 的流程第一步就是下載 Go 套件，這時候也需要將上述步驟重新操作一次。首先撰寫 main.go

```go
package main

import (
  "fmt"

  hello "github.com/appleboy/golang-private"
)

func main() {
  fmt.Println("get private module")
  fmt.Println("foo:", hello.Foo())
}
```

其中 `golang-private` 是一個私有 repository。接著按照本機版的做法，複製到 [Drone][10] 的 YAML 檔案。

```yaml
steps:
- name: build
  image: golang:1.14
  environment:
    USERNAME:
      from_secret: username
    ACCESS_TOKEN:
      from_secret: access_token
  commands:
  - go env -w GOPRIVATE=github.com/$USERNAME
  - git config --global url."https://$USERNAME:$ACCESS_TOKEN@github.com".insteadOf "https://github.com"
  - go mod tidy
  - go build -o main .
```

## 使用 Dockerfile 編譯

現在 Docker 支援 Multiple Stage，基本上很多部署方式都朝向一個 Dockerfile 解決，當然 Go 語言也不例外，先看看傳統寫法:

```dockerfile
# Start from the latest golang base image
FROM golang:1.14 as Builder

RUN GOCACHE=OFF

RUN go env -w GOPRIVATE=github.com/appleboy

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy everything from the current directory to the Working Directory inside the container
COPY . .

ARG ACCESS_TOKEN
ENV ACCESS_TOKEN=$ACCESS_TOKEN

RUN git config --global url."https://appleboy:${ACCESS_TOKEN}@github.com".insteadOf "https://github.com"

# Build the Go app
RUN go build -o main .

CMD ["/app/main"]
```

從上面可以看到一樣在 Docker 使用 git 方式讀取 Private Repository，但是你會發現上面編譯出來的 Image 有兩個問題，第一個就是檔案大小特別大，當然你會說那就用 alpine 也可以啊，是沒錯，但是還是很大。另一個最重要的問題就是暴露了 `ACCESS_TOKEN`，先在本機端直接執行 docker build。

```bash
docker build \
  --build-arg ACCESS_TOKEN=test1234 \
  -t appleboy/golang-module-private .
```

接著使用底下指令可以直接查到每個 Layer 的下了什麼指令以及帶入什麼參數？

```bash
docker history --no-trunc \
  appleboy/golang-module-private
```

會發現有一行可以看到您申請的 `ACCESS_TOKEN`

```bash
/bin/sh -c #(nop)  ENV ACCESS_TOKEN=xxxxxxx
```

如果您的 docker image 放在 docker hub 上面並且是公開的，就會直接被拿走，至於拿走做啥就不用說了吧，等於你的 GitHub 帳號被盜用一樣。要用什麼方式才可以解決這問題呢？很簡單就是透過 multiple stage

```dockerfile
# Start from the latest golang base image
FROM golang:1.14 as Builder

RUN GOCACHE=OFF

RUN go env -w GOPRIVATE=github.com/appleboy

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy everything from the current directory to the Working Directory inside the container
COPY . .

ARG ACCESS_TOKEN
ENV ACCESS_TOKEN=$ACCESS_TOKEN

RUN git config --global url."https://appleboy:${ACCESS_TOKEN}@github.com".insteadOf "https://github.com"

# Build the Go app
RUN go build -o main .

FROM scratch

COPY --from=Builder /app/main /

CMD ["/main"]
```

用 multiple stage 不但可以將 Image size 減到最小，還可以防禦特定 ARGS 被看到破解。透過上述方式就可以成功讀取私有 git repository，並且達到最佳的安全性。

## 整合 Drone 自動化上傳 Docker Image

```yml
- name: build-image
  image: plugins/docker
  environment:
    ACCESS_TOKEN:
      from_secret: access_token
  settings:
    username:
      from_secret: username
    password:
      from_secret: password
    repo: appleboy/golang-module-private
    build_args_from_env:
      - ACCESS_TOKEN
```

上面簡單的透過 `environment` 傳遞 ACCESS_TOKEN 進到 ARGS 設定。用 Drone 其實就很方便自動編譯並且上傳到 Docker Hub 或是自家的 Private Registry。

## 整合 Gitea Action

如果你是使用 [Gitea][11] 的話，也可以透過 Gitea Action 來達到相同的效果，只要在 Gitea 的設定檔案底下加入底下設定即可。

```yaml
jobs:
  release-image:
    runs-on: ubuntu-latest
    container:
      image: catthehacker/ubuntu:act-20.04
    env:
      USERNAME: srv-gaisf
      TOKEN: latest
    steps:
      - name: setup git config
        run: |
          git config --global \
          url."https://${{ env.USERNAME }}:${{ env.TOKEN }}@example.com".insteadOf \
          "https://example.com"
```

如果要放在 Docker Build Args 裡面，也可以透過底下方式

```yaml
- name: Build and Push
  uses: docker/build-push-action@v4
  with:
    context: .
    file: Dockerfile
    platforms: |
      linux/amd64
    push: ${{ github.event_name != 'pull_request' }}
    provenance: false
    sbom: false
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
    target: internalimage
    build-args: |
      LIC_DVCBOT_NET_KEY=${{ secrets.LIC_DVCBOT_NET_KEY }}
```

[11]:https://gitea.com

[1]: https://lh3.googleusercontent.com/_swpUXXC6aFQLaC3ooXMAgebOkHkgCl7M3RVH6Yrs2vDF-4T_dlUhHUz3MMmdtsV5H_vi6r5-fu_fpSI0RFtmYtmwVIK_zzRIO_YhrmIa3-PATRnyUtfVPtU4J7sxhkF_aQzXjGDdbU=w1920-h1080
[2]: https://golang.org/
[3]: https://golang.org/doc/go1.14#introduction
[4]: https://github.com/golang/go/wiki/Modules
[5]: https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
[6]: https://www.udemy.com/course/golang-fight/?couponCode=202002
[7]: https://www.udemy.com/course/devops-oneday/?couponCode=202002
[8]: https://www.udemy.com/course/docker-practice/?couponCode=20200222
[9]: http://facebook.com/appleboy46
[10]: https://drone.io/
