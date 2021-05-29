---
title: Go 1.15 新增 Module cache 環境變數
author: appleboy
type: post
date: 2020-06-13T13:45:47+00:00
url: /2020/06/go-module-cache-variable-gomodcache/
dsq_thread_id:
  - 8073931133
categories:
  - Drone CI
  - Golang
tags:
  - drone
  - golang

---
[![golang logo][1]][1]

相信各位開發者在寫 [Go 語言][2]專案，現在肯定都是使用 [Go module][3] 了，而 Go Module 檔案預設寫在 `/go/pkg/mod` 目錄內，要串 CI/CD 流程時，由於不在專案路徑底下，所以每一個 Container 無法共用 `/go/pkg/mod` 路徑，造成重複下載第三方套件，其實跨容器的解決方式可以透過 [Drone][4] 的 [Temporary Volumes][5] 方式解決，但是最終希望跑完編譯流程時，可以將最後的 mod 目錄打包留到下次的 CI/CD 部署流程使用，這時候如果可以改變 `/go/pkg/mod` 路徑，就可以動態調整目錄結構了。底下是針對 Drone 這套部署工具進行解說。

<!--more-->

## 教學影片

{{< youtube B3EnHwCCSz4 >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][6]
  * [一天學會 DevOps 自動化測試及部署][7]
  * [DOCKER 容器開發部署實戰][8]

如果需要搭配購買請直接透過 [FB 聯絡我][9]，直接匯款（價格再減 **100**）

## GOMODCACHE 環境變數

[Go 1.15][10] 開始支援 `GOMODCACHE` 環境變數，此變數預設是 `GOPATH[0]/pkg/mod`，現在這個路徑可以透過環境變數進行修正了。本篇教學會使用 [meltwater/drone-cache][11] 套件來完成 go module 的 cache 機制，加快後續每次的 CI/CD 部署。要進行 cache 前，我們需要在 pipeline 先建立 Temporary Volumes

<pre><code class="language-yaml">volumes:
- name: cache
  temp: {}</code></pre>

有了這個暫時性的空間，就可以在不同步驟的容器內看到相同的檔案了。接著設定編譯 Go 專案的步驟

<pre><code class="language-yaml">- name: build
  pull: always
  image: golang:1.15-rc
  commands:
  - make build
  environment:
    CGO_ENABLED: 0
    GOMODCACHE: &#039;/drone/src/pkg.mod&#039;
    GOCACHE: &#039;/drone/src/pkg.build&#039;
  when:
    event:
      exclude:
      - tag
  volumes:
  - name: cache
    path: /go</code></pre>

這邊可以注意，由於 Go 1.15 尚未釋出 (預計 2020/08)，所以先用了 rc 版本。這邊可以注意我們修改了 `GOMODCACHE`，將原本 mod 內容放到 `/drone/src/pkg.mod` 而 `/drone/src` 就是專案目錄了，所以記得設定一個不會用到的目錄名稱，請使用絕對路徑。

## 使用 build cache

在 CI/CD 編譯流程，第一個步驟就是將遠端備份好的 mod 檔案下載到容器內，並且解壓縮到 `GOMODCACHE` 所指定的路徑。

<pre><code class="language-yaml">- name: restore-cache
  image: meltwater/drone-cache
  environment:
    AWS_ACCESS_KEY_ID:
      from_secret: aws_access_key_id
    AWS_SECRET_ACCESS_KEY:
      from_secret: aws_secret_access_key
  pull: always
  settings:
    debug: true
    restore: true
    cache_key: &#039;{{ .Repo.Name }}_{{ checksum "go.mod" }}_{{ checksum "go.sum" }}_{{ arch }}_{{ os }}&#039;
    bucket: drone-cache-demo
    region: ap-northeast-1
    local_root: /
    archive_format: gzip
    mount:
      - pkg.mod
      - pkg.build
  volumes:
  - name: cache
    path: /go</code></pre>

這邊可以看到我是使用了 AWS S3 做為背後的 Storage，你也可以透過 SFTP 或其他方式來做變化。在 `archive_format` 請選擇 gzip，可以讓檔案更小些。接著會進行一系列 Go 的流程，像是測試，編譯，打包 ... 等等，最後會將 `pkg.mod` 進行打包再上傳到 AWS S3。

<pre><code class="language-yaml">- name: rebuild-cache
  image: meltwater/drone-cache
  pull: always
  environment:
    AWS_ACCESS_KEY_ID:
      from_secret: aws_access_key_id
    AWS_SECRET_ACCESS_KEY:
      from_secret: aws_secret_access_key
  settings:
    rebuild: true
    cache_key: &#039;{{ .Repo.Name }}_{{ checksum "go.mod" }}_{{ checksum "go.sum" }}_{{ arch }}_{{ os }}&#039;
    bucket: drone-cache-demo
    region: ap-northeast-1
    archive_format: gzip
    mount:
      - pkg.mod
      - pkg.build
  volumes:
  - name: cache
    path: /go</code></pre>

## 程式碼[請參考這邊][12]

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org
 [3]: https://blog.golang.org/using-go-modules
 [4]: https://cloud.drone.io
 [5]: https://docs.drone.io/pipeline/docker/syntax/volumes/temporary/
 [6]: https://www.udemy.com/course/golang-fight/?couponCode=202006
 [7]: https://www.udemy.com/course/devops-oneday/?couponCode=202006
 [8]: https://www.udemy.com/course/docker-practice/?couponCode=202006
 [9]: http://facebook.com/appleboy46
 [10]: https://tip.golang.org/doc/go1.15
 [11]: https://github.com/meltwater/drone-cache
 [12]: https://cloud.drone.io/go-training/drone-cache-demo
