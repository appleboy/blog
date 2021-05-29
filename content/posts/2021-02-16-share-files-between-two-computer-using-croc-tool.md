---
title: 兩台電腦透過 croc 工具來傳送檔案 (簡單, 加密, 快速)
author: appleboy
type: post
date: 2021-02-16T03:46:33+00:00
url: /2021/02/share-files-between-two-computer-using-croc-tool/
dsq_thread_id:
  - 8399735279
categories:
  - DevOps
  - Golang
tags:
  - croc
  - devops
  - golang

---
![croc][1]

兩台電腦之間該如何傳送檔案，其實方法有超多種的，像是 FTP 或透過 SSH 方式來傳送檔案，但是這些方法步驟都有點複雜，FTP 需要架設 FTP 服務，SSH 要學習 SCP 指令，那有沒有更好的方式從單一電腦點對點傳送檔案到另一台呢？傳送過程需要快速又要安全，本篇介紹一套用 [Go 語言][2]寫的工具叫 [croc][3]，詳細的介紹可以參考看看[作者的 Blog 介紹][4]，此工具有底下功能及優勢。

<!--more-->

## 影片教學

{{< youtube lq9SRsxse4o >}}

  * 00:00​ 兩台電腦該如何傳送檔案?
  * 01:40​ 介紹 croc 工具優勢跟特點
  * 03:24​ 如何使用 croc 工具
  * 05:34​ 自行產生 secret code 方式
  * 06:36​ croc relay server 介紹
  * 07:11​ 自行架設 relay server
  * 10:25​ 心得 (簡單, 快速, 安全)

## 工具特點及優勢

  1. 用 relay 方式讓任意兩台電腦傳送檔案
  2. 點對點加密 (使用 [PAKE][5])
  3. 跨平台傳送檔案 (Windows, Linux, Mac)
  4. 一次可以傳送多個檔案或整個目錄
  5. 支援續傳
  6. 不需要自行架設服務或使用 port-forwarding 相關技術
  7. 優先使用 ipv6，而 ipv4 當作備援
  8. 可以使用 socks5 proxy

## 使用方式

使用方式如同底下這張圖所表示

![croc][1] 

傳送端只需要執行 `croc send file.txt` 即可

```sh
$ croc send ~/Downloads/data.csv
Sending 'data.csv' (632.9 kB)
Code is: cabinet-rodeo-mayday
On the other computer run

croc cabinet-rodeo-mayday
```

上面可以看到會自動產生一個 `secret code`，接著在另外一台電腦執行底下指令

```sh
$ croc cabinet-rodeo-mayday
Accept 'data.csv' (632.9 kB)? (y/n) y

Receiving (<-111.243.108.9:51032)
```

當然你可以自訂 `secret code`

```sh
croc send --code appleboy ~/Downloads/data.csv
```

由於此工具是透過 relay server 方式來進行傳送，所以指令會預設連到官方所架設的服務器

```go
// DEFAULT_RELAY is the default relay used (can be set using --relay)
var (
    DEFAULT_RELAY      = "croc.schollz.com"
    DEFAULT_RELAY6     = "croc6.schollz.com"
    DEFAULT_PORT       = "9009"
    DEFAULT_PASSPHRASE = "pass123"
)
```

假設你想要自己架設 relay server 呢？很簡單，這工具也讓開發者很快架設一台 relay server，只要執行底下

```sh
$ croc relay
[info]  2021/02/16 11:38:59 starting croc relay version v8.6.7-05640cd
[info]  2021/02/16 11:38:59 starting TCP server on 9010
[info]  2021/02/16 11:38:59 starting TCP server on 9012
[info]  2021/02/16 11:38:59 starting TCP server on 9009
[info]  2021/02/16 11:38:59 starting TCP server on 9013
[info]  2021/02/16 11:38:59 starting TCP server on 9011
```

可以指定單一 port:

```sh
$ croc relay --ports 3001
[info]  2021/02/16 11:39:22 starting croc relay version v8.6.7-05640cd
[info]  2021/02/16 11:39:22 starting TCP server on 3001
```

接著在傳送檔案也要跟著換掉 relay server

```sh
$ croc --relay 127.0.0.1:3001 send ~/Downloads/data.csv
Sending 'data.csv' (632.9 kB)
Code is: saddle-origin-horizon
On the other computer run

croc --relay 127.0.0.1:3001 saddle-origin-horizon
```

可以看到需要加上 `--relay 127.0.0.1:3001` 就可以完成了，所以很簡單的架設 relay server，這樣官方服務掛了，你也可以在任意一台電腦裝上 relay server 了。

## 心得

croc 工具強調的就是: 簡單 + 安全 + 快速，三大優勢，讓大家可以更容易點對點傳送檔案，加上 CLI 工具在任何平台都可以下載 (Windows, Mac, 及 Linux)，只需要一個指令就可以裝好此工具，跟其他朋友傳送檔案。未來會再多介紹一些好用工具給大家。

 [1]: https://lh3.googleusercontent.com/VHlioiLpLfqBnh5PnGjYhU6l7dZ2V3PURxz5RfulFL74xYYr4kL5EgkOa-OfLQyIALLgmRIcKlLHnbIENFe0cyv82XQW5ia0HgeNwm4u2ijNsjSQQjkrY4JJjloB_pHTOT-EtxzxOlw=w1920-h1080
 [2]: https://golang.org
 [3]: https://github.com/schollz/croc
 [4]: https://schollz.com/blog/croc6/
 [5]: https://en.wikipedia.org/wiki/Password-authenticated_key_agreement
