---
title: 用 GitHub Actions 部署 Go 語言服務
author: appleboy
type: post
date: 2019-12-14T11:44:47+00:00
url: /2019/12/deploy-golang-app-using-github-actions/
dsq_thread_id:
  - 7763765781
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - Docker
  - Github
  - GitHub Actions
  - golang

---
![][1]

[GitHub Actions][2] 也推出一陣子了，相信有不少雷，也是有很多優勢，未來在 GitHub 上面串接任何開源專案，都可以免費使用，過幾年可以看看 GitHub Actions 對 [Travis][3] 的影響是多少？本篇要來介紹如何透過 GitHub Actions 來部署 [Go 語言][4]服務，會用一個簡單 httpd 範例教大家如何透過 [Docker][5] 方式來更新。使用 Go 語言基本服務流程大致上會是『測試 -> 編譯 -> 上傳 -> 啟動』，透過這四個步驟來學習 GitHub Actions 該如何設定。

  * 測試: Unit Testing 多一層保護
  * 編譯: 透過 go build 編譯出 Binary 檔案
  * 上傳: 寫 Dockerfile 將 Binary 包進容器內
  * 啟動: 透過 docker-compose 方式來更新服務

<!--more-->

## 影片介紹

同步放在 Udemy 平台上面，有興趣的可以直接參考底下:

  * [Go 語言基礎實戰 (開發, 測試及部署)][6]
  * [一天學會 DevOps 自動化測試及部署][7]

## 啟動 GitHub Actions

只要在專案內建立 `.github/workflows/` 目錄，裡面可以放置多個 YAML 檔案，上傳至 GitHub，就可以開始使用了。我們先在該目錄建立一個 `deploy.yml` 檔案

```yaml
name: Build and Test
on:
  push:
    branches:
      - master
  pull_request:
jobs:
  lint:
    strategy:
      matrix:
        platform: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.platform }}
    steps:
    - name: hello world
      run: |
        echo "Hello World"
```

可以看到現在可以直接在 GitHub 上面執行 Ubuntu 或 Windows 或 MacOS，詳細版本資訊可以[參考這邊][8]。接著針對 GO 語言四個步驟來分別撰寫 YAML 設定。

## Go 語言流程

第一個步驟是下載專案原始碼，這邊跟其他 CI/CD 工具不一樣的是預設流程不會 checkout source code，必須要自己指定。

```yaml
steps:
- name: Check out code
  uses: actions/checkout@v1
```

第二個步驟是安裝 Go 語言環境，原因 Ubuntu 環境預設是空的，所以任何語言都需要再額外安裝:

```yaml
strategy:
  matrix:
    go-version: [1.13.x]
steps:
- name: Install Go
  uses: actions/setup-go@v1
  with:
    go-version: ${{ matrix.go-version }}
```

第三步驟是測試

```yaml
- name: Tesing
  run: |
    go test -v .
```

第四步驟是編譯 binary 檔案

```yaml
- name: Build binary
  run: |
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -a -o release/linux/amd64/helloworld
```

第五個步驟是將 binary 檔案包成容器上傳到 Docker Hub:

```yaml
- name: Publish to Registry
  uses: elgohr/Publish-Docker-Github-Action@2.9
  with:
    name: appleboy/helloworld
    username: appleboy
    password: ${{ secrets.docker_password }}
    dockerfile: docker/helloworld/Dockerfile.linux.amd64
```

其中 Dockerfile 內容為:

```dockerfile
FROM plugins/base:linux-amd64

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="helloworld" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

EXPOSE 8080

COPY release/linux/amd64/helloworld /bin/

ENTRYPOINT ["/bin/helloworld"]
```

最後步驟為連線到遠端伺服器並重新啟動服務，最簡單方式就是透過 [docker-compose][9] 來重新啟動。這邊透過 [ssh-actions][10] 

```yaml
- name: Update the API service
  uses: appleboy/ssh-action@v0.0.6
  with:
    host: ${{ secrets.ssh_host }}
    username: deploy
    key: ${{ secrets.ssh_key }}
    script_stop: true
    script: |
      cd golang && docker-compose pull && docker-compose up -d
```

全部設定檔如下:

```yaml
name: Build and Test
on:
  push:
    branches:
      - master
  pull_request:
jobs:
  build:
    strategy:
      matrix:
        platform: [ubuntu-latest]
    runs-on: ${{ matrix.platform }}
    steps:
    - name: Install Go
      uses: actions/setup-go@v1
      with:
        go-version: ${{ matrix.go-version }}

    - name: Check out code
      uses: actions/checkout@v1

    - name: Tesing
      run: |
        make test

    - name: Build binary
      run: |
        make build_linux_amd64

    - name: Publish to Registry
      uses: elgohr/Publish-Docker-Github-Action@2.9
      with:
        name: appleboy/helloworld
        username: appleboy
        password: ${{ secrets.docker_password }}
        dockerfile: docker/helloworld/Dockerfile.linux.amd64

    - name: Update the API service
      uses: appleboy/ssh-action@v0.0.6
      with:
        host: ${{ secrets.ssh_host }}
        username: deploy
        key: ${{ secrets.ssh_key }}
        script_stop: true
        script: |
          cd golang && docker-compose pull && docker-compose up -d
```

## 使用容器當做基底

從上面的設定檔我會有個疑問，就是每一個 Job 都要從最初始化安裝環境，像上面就是安裝 Go 語言環境。那能不能直接選用 Go 官方提供的容器當作基底，這樣就可以少裝一個步驟，答案是可以的，每一個 Job 都可以指定不同的容器來啟動

```yaml
jobs:
  build:
    strategy:
      matrix:
        platform: [ubuntu-latest]
    runs-on: ${{ matrix.platform }}
    container: golang:1.13
```

上面這段意思是就是，先拿 Ubuntu 當作系統，在上面跑 `golang:1.13`，這樣 `build` 這個 Job 就是以官方的容器當作基底做後續處理。也就是不再依賴 `actions/setup-go@v1` 套件了。

## 心得

雖然 GitHub Actions 已經正式 Release 了，但是要用在 Production 可能還需要等一陣子，原因是貿然轉換過來，需要一些時間來確認是否全部的流程都有人寫成 Plugin 放在 [Marketplace][11]，找不到的話，就必須要自己去撰寫，有好處也有壞處。

 [1]: https://lh3.googleusercontent.com/NI2lnMOEhkrZJ-x_bmre_RoQxLnzYcpPXVB_p6eBMmPQ73yDgoftVmUHvk0P86Tt2MM_Q23IHNu7qq7j99RXzTEzG95BU1u1vdpell9krVGHlUmW3Ng7J7egj1LHugWHcHoezCty9o0=w1920-h1080
 [2]: https://github.com/features/actions
 [3]: https://travis-ci.org/
 [4]: https://golang.org
 [5]: https://docker.com
 [6]: https://www.udemy.com/course/golang-fight/?couponCode=20191202
 [7]: https://www.udemy.com/course/devops-oneday/?couponCode=20191202
 [8]: https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#jobsjob_idruns-on
 [9]: https://docs.docker.com/compose/
 [10]: https://github.com/appleboy/ssh-action
 [11]: https://github.com/marketplace?type=actions