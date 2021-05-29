---
title: 架設 Go Proxy 服務加速 go module 下載速度
author: appleboy
type: post
date: 2019-07-10T22:54:14+00:00
url: /2019/07/speed-up-go-module-download-using-go-proxy-athens/
dsq_thread_id:
  - 7525768579
categories:
  - DevOps
  - Docker
  - Drone CI
  - Golang
tags:
  - go module
  - golang

---
[![golang logo][1]][1]

[Go 語言][2]在 1.11 推出 go module 來統一市面上不同管理 Go 套件的工具，像是 [dep][3] 或 govendor 等，還不知道如何使用 go module，可以參考之前寫的一篇文章『[Go Module 導入到專案內且搭配 Travis CI 或 Drone 工具][4]』，在團隊內如果每個人在開發專案時，都透過網路去下載專案使用到的套件，這樣 10 個人就會浪費 10 個人的下載時間，並且佔用公司網路頻寬，所以我建議在公司內部架設一台 Go Proxy 服務，減少團隊在初始化專案所需要的時間，也可以減少在跑 CI/CD 流程時，所需要花費的時間，測試過公司 CI/CD 流程，有架設 Go Proxy，一般來說可以省下 1 ~ 2 分鐘時間，根據專案使用到的相依性套件用量來決定花費時間。本篇來介紹如何架設 [ATHENS][5] 這套開源 Go Proxy 專案。

<!--more-->

## 教學影片

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 架設 ATHENS 服務

你也可以使用外面公開的 GO Proxy 服務，非 China 地區請使用 [goproxy.io][6]，如果在中國內地，請使用 [gorpoxy.cn][7]，會降低不少 CI/CD 時間。架設 ATHENS 並不難，只需要透過 [Docker][8] 一個指令就可以完成，更詳細的步驟可以參考[官方文件][9]

```bash
export ATHENS_STORAGE=~/athens-storage
mkdir -p $ATHENS_STORAGE
docker run -d -v $ATHENS_STORAGE:/var/lib/athens \
   -e ATHENS_DISK_STORAGE_ROOT=/var/lib/athens \
   -e ATHENS_STORAGE_TYPE=disk \
   --name athens-proxy \
   --restart always \
   -p 3000:3000 \
   gomods/athens:latest
```

其中 `ATHENS_STORAGE` 請定義一個實體空間路徑，存放從網路抓下來的第三方套件，當然 ATHENS 還有支援不同的 storage type，像是 Memory, AWS S3 或公司內部有架設 [Minio][10]，都是可以設定的。

## 如何使用 Go Proxy

使用方式非常簡單，只要在您的開發環境加上一些環境變數

```bash
$ export GO111MODULE=on
$ export GOPROXY=http://127.0.0.1:3000
```

接著專案使用的任何 Go 指令，只要需要 Donwload 第三方套件，都會先詢問公司內部的 Proxy 服務，如果沒有就會透過 Proxy 抓一份下來 Cache，下次有團隊同仁需要用到，就不需要上 Internet 抓取了。

至於 CI/CD 流程該如何設定呢？非常簡單，底下是 [drone][11] 的設定方式:

```yml
- name: embedmd
  pull: always
  image: golang:1.12
  commands:
  - make embedmd
  environment:
    GO111MODULE: on
    GOPROXY: http://127.0.0.1:3000
  volumes:
  - name: gopath
    path: /go
```

## 心得

團隊如果尚未導入 GO Proxy 的朋友們，請務必導入，不然就要自己 cache mod 目錄，但是我覺得不是很方便就是了，架設一台 Proxy，不用一分鐘，但是可以省下團隊開發及部署很多時間，這項投資很值得的。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org
 [3]: https://github.com/golang/dep
 [4]: https://blog.wu-boy.com/2018/12/go-module-integrate-with-travis-or-drone/
 [5]: https://github.com/gomods/athens
 [6]: https://goproxy.io/
 [7]: https://github.com/goproxy/goproxy.cn
 [8]: https://www.docker.com/
 [9]: https://docs.gomods.io/install/
 [10]: https://min.io/
 [11]: https://github.com/drone/drone