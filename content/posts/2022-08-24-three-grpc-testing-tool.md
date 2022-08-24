---
title: "三種好用的 gRPC 測試工具"
date: 2022-08-24T16:29:31+08:00
author: appleboy
type: post
slug: three-grpc-testing-tool
share_img: https://i.imgur.com/ZfDNgPP.png
categories:
  - Golang
tags:
  - golang
  - grpc
  - testing
---

![grpc flow proposal](https://i.imgur.com/ZfDNgPP.png)

最近在用 [Go 語言][2]實作微服務，溝通的接口採用 [gRPC][1]，除了可以透過 gRPC 支援的[第三方語言][3]來寫客戶端的測試之外，有沒有一些好用的工具來驗證檢查 gRPC 實現的接口。剛好今年看到 [Postman][5] 宣布[開始支援 gRPC][4]，相信大家對於 Postman 工具並不會太陌生，畢竟測試 [Websocket][9] 或 RESTful API 都是靠這工具呢。本篇除了介紹 Postman 之外，還有一套 CLI 工具 [grpcurl][6] 及一套 GUI 工具 [grpcui][7] 也是不錯用，後面這兩套都是由同一家公司 [FullStory][8] 開源出來的專案，底下就來一一介紹。

[1]:https://grpc.io/
[2]:https://go.dev
[3]:https://grpc.io/docs/languages/
[4]:https://blog.postman.com/postman-now-supports-grpc/
[5]:https://www.postman.com/
[6]:https://github.com/fullstorydev/grpcurl
[7]:https://github.com/fullstorydev/grpcui
[8]:https://www.fullstory.com/blog/tag/engineering/
[9]:https://en.wikipedia.org/wiki/WebSocket

<!--more-->

## 測試 gRPC 服務

我有寫好一個[測試範例版本][31]，gRPC 定義的 proto 檔案可以[從這邊查看][32]

```proto
syntax = "proto3";

package gitea.v1;

message GiteaRequest {
  string name = 1;
}

message GiteaResponse {
  string giteaing = 1;
}

message IntroduceRequest {
  string name = 1;
}

message IntroduceResponse {
  string sentence = 1;
}

service GiteaService {
  rpc Gitea(GiteaRequest) returns (GiteaResponse) {}
  rpc Introduce(IntroduceRequest) returns (stream IntroduceResponse) {}
}
```

[31]:https://github.com/go-training/proto-go-sample
[32]:https://github.com/go-training/proto-def-demo

## grpcurl

相信大家都有用過強大的 [curl][11] 工具，而 [grpcurl][6] 可以想像成 curl 的 gRPC 版本，安裝方式非常簡單，可以到 [Relase 頁面][12]找你要的 OS 版本，如果本身是 Go 開發者可以透過 go install 安裝

```sh
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```

MacOS 環境可以透過 Homebrew 安裝

```sh
brew install grpcurl
```

或者透過 Docker 來執行也可以的

```sh
# Download image
docker pull fullstorydev/grpcurl:latest
# Run the tool
docker run fullstorydev/grpcurl api.grpc.me:443 list
```

先把測試環境搭建起來，就可以在本地端測試 8080 連接埠

```sh
$ grpcurl -plaintext localhost:8080 list
gitea.v1.GiteaService
grpc.health.v1.Health
ping.v1.PingService
```

由於本地端沒有 SSL 憑證，所以請加上 `-plaintext` 參數才可以使用，詳細參數可透過 `-h` 查看，接下來打第一個測試接口

```sh
grpcurl \
  -plaintext \
  -d '{"name": "foobar"}' \
  localhost:8080 \
  gitea.v1.GiteaService/Gitea
```

會拿到底下結果

```sh
{
  "giteaing": "Hello, foobar!"
}
```

如果服務有加上 Health Check 可以直接使用底下指令

```sh
grpcurl \
  -plaintext \
  -d '{"service": "gitea.v1.GiteaService"}' \
  localhost:8080 \
  grpc.health.v1.Health/Check
```

可以拿到底下結果

```sh
{
  "status": "SERVING"
}
```

服務如果有支援 Server Streaming RPC 也是同樣用法

```sh
grpcurl \
  -plaintext \
  -d '{"name": "foobar"}' \
  localhost:8080 \
  gitea.v1.GiteaService/Introduce
```

可以看到 Server 會回應兩個訊息

```sh
{
  "sentence": "foobar, How are you feeling today 01 ?"
}
{
  "sentence": "foobar, How are you feeling today 02 ?"
}
```

[11]:https://curl.se/
[12]:https://github.com/fullstorydev/grpcurl/releases

## grpcui

除了上面 grpcurl 外，同一個團隊也推出 Web UI 的 gRPC 測試工具 [grpcui][7]，安裝方式跟 grpcurl 一樣，這邊就不多做說明了，grpcui 也支援全部 RPC 功能，包含 streaming 等。底下一行指令就可以啟動 GUI 畫面了

```sh
grpcui -plaintext localhost:8080
```

![page](https://i.imgur.com/9zxxMUL.png)

此頁面已經幫忙把 Service 及可以用的 Method 都準備完畢了，你也不用知道任何服務提供哪些 Method，相當方便，選擇不同的 Service 及 Method，畫面上的 Request Data 都會隨著變動

![page](https://i.imgur.com/p9E6dNq.png)

填寫完 Request Form 在切換到 Raw Request (JSON) 就可以看到 JSON Format 的資料

![page](https://i.imgur.com/VufszkU.png)

按下 invoke 後，可以看到結果

![page](https://i.imgur.com/dASAJkw.png)

測試 Streaming 結果

![page](https://i.imgur.com/452vYw4.png)

## Postman

相信大家最熟悉的還是 Postman，測試任何服務都離不開此工具，也很高興今年一月看到支援了 gRPC Beta 版本，打開軟體後，按下左上角 New 就可以看到底下畫面，選擇 gRPC Request

![page](https://i.imgur.com/MZA3SyP.png)

左邊 API 可以把所有服務的 proto 資料寫進去

![page](https://i.imgur.com/ZHrbUzl.png)

接著就可以透過 New Request 來選擇了，並且執行 invoke

![page](https://i.imgur.com/bQojRPF.png)

Stream Testing 如下

![page](https://i.imgur.com/68QnE8a.png)

## 心得

grpcurl CLI 工具可以在基本沒有桌面的 Linux 環境中使用，所以這邊算蠻推薦的，但是 Postman 在使用前都需要手動將 Proto 的資料寫進去，才可以測試使用，所以我更強烈推薦使用 grpcui 可以直接動態讀取 proto 資訊，將資訊轉成 Request Form，減少查詢資料屬性的時間。
