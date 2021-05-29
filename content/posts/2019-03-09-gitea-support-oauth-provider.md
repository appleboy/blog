---
title: 開源專案 Gitea 支援 OAuth Provider
author: appleboy
type: post
date: 2019-03-09T04:52:49+00:00
url: /2019/03/gitea-support-oauth-provider/
dsq_thread_id:
  - 7281185259
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - droneci
  - gitea

---
[![Gitea][1]][1]

很高興看到 [Gitea][2] 正式支援 [OAuth Provider][3] 了，此功能經歷了四個月終於正式合併進 master 分支，預計會在 [1.8 版本][4]釋出，由於此功能已經進 master，這樣我們就可以把原本 Drone 透過帳號密碼登入，改成使用 OAtuh 方式了，增加安全性。但是在使用之前，Drone 需要合併 [drone/go-login@3][5] 及 [drone/drone@2622][6]。如果您會使用 Go 語言，不妨現在就可以來試試看了，透過 go build 來編譯原始碼。

<!--more-->

## 影片教學

有興趣可以參考線上教學

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 安裝 Gitea

由於 Gitea 還沒轉到 [Go module][7] (已經有另外一個 PR 再處理 Vendor)，所以請 clone 專案原始碼到 `GOPATH` 底下

```bash
$ git clone https://github.com/go-gitea/gitea.git \
  /go/src/code.gitea.io/gitea
```

接著切換到專案目錄，編譯出 SQLite 的 Binary

```bash
$ TAGS="sqlite sqlite_unlock_notify" make
```

編譯完成後，直接執行

```bash
$ ./gitea web
2019/03/09 12:26:03 [T] AppPath: /Users/appleboy/git/go/src/code.gitea.io/gitea/gitea
2019/03/09 12:26:03 [T] AppWorkPath: /Users/appleboy/git/go/src/code.gitea.io/gitea
2019/03/09 12:26:03 [T] Custom path: /Users/appleboy/git/go/src/code.gitea.io/gitea/custom
2019/03/09 12:26:03 [T] Log path: /Users/appleboy/git/go/src/code.gitea.io/gitea/log
2019/03/09 12:26:03 Serving [::]:3000 with pid 18284
```

打開瀏覽器登入後，進入右上角使用者設定，就可以建立新的 Application。

[![][8]][8]

其中 `Redirect URL` 請填上 drone 的 URL `http://localhost:8080/login`

## 安裝 [Drone][9]

在上面有提到需要合併兩個 PR ([drone@go-login#3][10] 及 [drone@drone#2622][11]) 才能使用此功能，等不及的朋友們就自己先 Fork 來使用吧。先假設已經合併完成。

```bash
$ cd $GOPAHT/drone
$ go build ./cmd/drone-server
```

然後建立 `server.sh` 將環境變數寫入

```bash
#!/bin/sh
export DRONE_GITEA_SERVER=http://localhost:3000
export DRONE_GITEA_CLIENT_ID=49de7c23-3bed-45a1-a78e-89c8ba4db07b
export DRONE_GITEA_CLIENT_SECRET=8GhG9XvPJEpaOroVocmJPAQArO5Zz7KMLQ5df0eG91c=
./drone-server
```

啟動 drone 服務，會看到一些 Info 訊息:

```bash
$ ./server.sh 
{"level":"info","msg":"main: internal scheduler enabled","time":"2019-03-09T12:39:21+08:00"}
{"level":"info","msg":"main: starting the local build runner","threads":2,"time":"2019-03-09T12:39:21+08:00"}
{"acme":false,"host":"localhost:8080","level":"info","msg":"starting the http server","port":":8080","proto":"http","time":"2019-03-09T12:39:21+08:00","url":"http://localhost:8080"}
{"interval":"30m0s","level":"info","msg":"starting the cron scheduler","time":"2019-03-09T12:39:21+08:00"}
```

打開瀏覽器輸入 `http://localhost:8080` 就可以看到跳轉到 OAuth 頁面

[![][12]][13]

## 心得

現在 Gitea 已經支援 OAuth Provider，未來可以再接更多第三方服務，這樣就可以不用透過帳號密碼登入，避免讓第三方服務存下您的密碼。

 [1]: https://lh3.googleusercontent.com/SrQvhDJm5NMkrxrut0lACspnz6iQSFCX3vlbtGCuAcwO-i_4iJCJ6trK3V2F6Q6s6fQ_EcSglwAL0qO0aLaTRtk4Ca32EI7Ks1H7u_nI9jC6xn3PF9hhgccjkbN3irX5pGi9kV-vIxk=w1920-h1080 "Gitea"
 [2]: https://gitea.io "Gitea"
 [3]: https://github.com/go-gitea/gitea/pull/5378 "OAuth Provider "
 [4]: https://github.com/go-gitea/gitea/milestone/32 "1.18 版本"
 [5]: https://github.com/drone/go-login/pull/3 "drone/go-login"
 [6]: https://github.com/drone/drone/pull/2622 "drone/drone@2622"
 [7]: https://blog.wu-boy.com/2018/10/go-1-11-support-go-module/ "Go module"
 [8]: https://lh3.googleusercontent.com/PPql-MM_46UuURU-Y-w6iI7E673mEvMT49BmDd5joskzDx7mzCuTdMLThZSI6getcl_-lSfyJr0d5YOsFN4j57qUEVto-SKFGzFxLdevK3saSqVeLEnPd2BtIxLrbXOxSvJPlqZQwXs=w1920-h1080
 [9]: https://drone.io/
 [10]: https://github.com/drone/go-login/pull/3 "drone@go-login#3"
 [11]: https://github.com/drone/drone/pull/2622 "drone@drone#2622"
 [12]: https://lh3.googleusercontent.com/hmLWyzXVezGiaOQlsv3hN_l_wymxU3nrpjgGomhkbx5_I7K8-phnkKtXpZRyWZwuDiifhKIU7LCsKnY6Gjl84kGCFdv3UoMF0y192ZkxdIZeYFAwS8y75zzA0RWpEBW8iO9GYlEWKwk=w1920-h1080
 [13]: http://https://lh3.googleusercontent.com/hmLWyzXVezGiaOQlsv3hN_l_wymxU3nrpjgGomhkbx5_I7K8-phnkKtXpZRyWZwuDiifhKIU7LCsKnY6Gjl84kGCFdv3UoMF0y192ZkxdIZeYFAwS8y75zzA0RWpEBW8iO9GYlEWKwk=w1920-h1080