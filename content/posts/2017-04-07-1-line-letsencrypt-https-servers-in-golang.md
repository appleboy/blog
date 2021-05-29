---
title: 在 Go 語言用一行程式碼自動化安裝且更新 Let’s Encrypt 憑證
author: appleboy
type: post
date: 2017-04-07T03:23:57+00:00
url: /2017/04/1-line-letsencrypt-https-servers-in-golang/
dsq_thread_id:
  - 5703182014
categories:
  - Golang
  - Nginx
tags:
  - caddy
  - Docker
  - golang
  - nginx

---
[![][1]][1]

在去年寫了一篇『[申請 Let’s Encrypt 免費憑證讓網站支援 HTTP2][2]』教學，如果您是用 Nginx，就可以參考該篇教學讓您的伺服器支援 HTTPS，而 [Google Security Blog][3] 也宣布在 56 版本以後將會提示 non-secure 網站，讓使用者可以選擇性瀏覽網站。[Let’s Encrypt][4] 官方也[公布去年 2016 發了多少張憑證][5]，相當驚人，想必大家對 HTTPS 已經有相當程度的瞭解。底下這張圖說明 2016 年 Let’s Encrypt 發憑證總量的狀況

[<img src="https://i2.wp.com/c1.staticflickr.com/3/2820/33499997070_dfa4f1cf7c_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-04-07 at 9.52.40 AM" data-recalc-dims="1" />][6]

此篇會介紹在 [Go 語言][7]如何跟 Let’s Encrypt 串接，底下有兩種方式。

<!--more-->

## 使用 Caddy 伺服器

大家可以把 [Caddy][8] 想成跟 [Nginx][9] 同等關係，不同的是 Caddy 是一套完全用 Go 語言打造的伺服器，這邊就會介紹 Caddy 怎麼設定 HTTPS 憑證。先假設 domain 為 example.com，底下就是讓此 domain 自動掛上憑證的 `Caddyfile` 設定檔

```bash
example.com {
  proxy / localhost:3000
}
```

上面設定會自動將 `http` 轉換成 `https`，也就是在瀏覽器鍵入 <http://example.com> Caddy 會自動換成 <https://example.com。如果是> Nginx 呢？看看底下設定

```bash
server {
  listen 0.0.0.0:80;
  server_name example.com;

  location /.well-known/acme-challenge/ {
    alias /var/www/dehydrated/;
  }

  return 301 https://example.com$request_uri;
}

server {
  # listen 80 deferred; # for Linux
  # listen 80 accept_filter=httpready; # for FreeBSD
  listen 0.0.0.0:443 ssl http2;

  ssl_certificate /etc/dehydrated/certs/example.com/fullchain.pem;
  ssl_certificate_key /etc/dehydrated/certs/example.com/privkey.pem;

  # The host name to respond to
  server_name codeigniter.org.tw;
}
```

很明顯可以看出，用 Caddy 大勝 Nginx 設定檔簡易程度。另外 Let’s Encrypt 憑證會在三個月後過期，如果是使用 Caddy，可以不用擔心過期問題，Caddy 會自動在三個月內幫忙更新憑證有效日期，如果是 Nginx，請寫 Script 並且放到 [Crontab][10] 內。結論就是 Caddy 自動幫忙處理申請+更新憑證，而 Nginx 都必須手動打造。

## 使用 Go 語言 autocert package

相信很多 Go 開發者不希望前面有 Proxy Server 像是 Caddy 或 Nginx，而是希望 Go Binary 可以直接 Listen 443 port，這樣好處就是 Performance 會是最好，缺點就是一台機器只能使用一個 application。而 Go 語言要實現整合 Let’s Encrypt 相當容易，只需要引入 [autocert][11] 套件，底下是範例程式碼: (使用 [Gin][12] framework)

#### [程式碼範例][13]

```go
package main

import (
    "crypto/tls"
    "net/http"

    "github.com/gin-gonic/gin"
    "golang.org/x/crypto/acme/autocert"
)

func main() {
    r := gin.Default()

    // Ping handler
    r.GET("/ping", func(c *gin.Context) {
        c.String(200, "pong")
    })

    m := autocert.Manager{
        Prompt:     autocert.AcceptTOS,
        HostPolicy: autocert.HostWhitelist("example1.com", "example2.com"),
        Cache:      autocert.DirCache("/var/www/.cache"),
    }

    s := &http.Server{
        Addr:      ":https",
        TLSConfig: &tls.Config{GetCertificate: m.GetCertificate},
        Handler:   r,
    }
    s.ListenAndServeTLS("", "")
}
```

程式碼內有兩個地方需要注意，一個是 `HostWhitelist` 這是綁定特定 Domain，請務必填寫，當然你也可以填空，但是這樣任意 Domain 指向你的機器，就可以直接對 Let’s Encrypt 請求憑證，所以請務必填上自己的 Domain，另一個是 `DirCache` 這是憑證存放的目錄，你可以任意指定到其他目錄，第一次請求會比較久，原因是憑證還沒下來。上面範例你會發現，哪是一行，看起來就是好幾行才完成此功能，在不久之前(本週) [@bradfitz][14] (Go 語言 HTTP 核心開發者) 開發了 `Listener` 函示 (相關 [Commit][15])，讓開發者可以用一行取代上面冗長的程式碼:

#### [程式碼範例][16]

```go
package main

import (
    "log"
    "net/http"

    "github.com/gin-gonic/gin"
    "golang.org/x/crypto/acme/autocert"
)

func main() {
    r := gin.Default()

    // Ping handler
    r.GET("/ping", func(c *gin.Context) {
        c.String(200, "pong")
    })

    log.Fatal(http.Serve(autocert.NewListener("example1.com", "example2.com"), r))
}
```

現在只要填入您的 Domain 就可以綁定憑證及自動更新 (不必擔心三個月會過期)，這邊你會問，那憑證是放在哪裡呢？

  * MacOS 放在 `/Users/xxxx/Library/Caches/golang-autocert`
  * Windows `${HOMEDRIVE}/${HOMEPATH}` 加上依序先找 `APPDATA`, `CSIDL_APPDATA`, `TEMP`, `TMP` 全域變數的目錄
  * Linux 放在家目錄內 `.cache/golang-autocert` 目錄

如果是搭配 Docker，你可以指定 `XDG_CACHE_HOME` 變數來轉換您想要的目錄。請在 Dockerfile 內放入

```bash
ENV XDG_CACHE_HOME /var/lib/.cache
```

這樣 docker 會把憑證放在 `/var/lib/.cache/golang-autocert` 內，使用者不用管憑證放哪裡，因為就算消失了，下次重新啟動，自然會在產生一次。最後要講的是，如何用 Go 語言實現 `http` 轉到 `https` 呢？非常簡單，請參考底下程式碼

#### [程式碼範例][17]

```go
var g errgroup.Group

g.Go(func() error {
  return http.ListenAndServe(":http", http.RedirectHandler("https://example.com", 303))
})
g.Go(func() error {
  return http.Serve(autocert.NewListener("example.com"), handler)
})

if err := g.Wait(); err != nil {
  log.Fatal(err)
}
```

## 總結

不管是用 Caddy 或者是 Go 語言 autocert 套件都是非常簡單，如果寫 Open Source 專案，基本上就是用 Go 語言內建的 autocert 來實現 Let’s Encrypt 串接，方便大家下載 Binary 直接 Listen 443 Port。不熟 Go 語言，就試試看 Caddy 伺服器吧。相信跑過一陣子你會發現 Caddy 的好處。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://blog.wu-boy.com/2016/10/website-support-http2-using-letsencrypt/
 [3]: https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html
 [4]: https://letsencrypt.org/
 [5]: https://letsencrypt.org/2017/01/06/le-2016-in-review.html
 [6]: https://www.flickr.com/photos/appleboy/33499997070/in/dateposted-public/ "Screen Shot 2017-04-07 at 9.52.40 AM"
 [7]: https://golang.org
 [8]: https://caddyserver.com/
 [9]: https://nginx.org/en/
 [10]: http://linux.vbird.org/linux_basic/0430cron.php
 [11]: https://godoc.org/golang.org/x/crypto/acme/autocert
 [12]: https://github.com/gin-gonic/gin
 [13]: https://github.com/go-training/training/blob/master/example10-simple-http-server/server/server05.go
 [14]: https://github.com/bradfitz
 [15]: https://github.com/golang/crypto/commit/b020702ab212964a017cbb8f7db52b5367017a4d
 [16]: https://github.com/go-training/training/blob/master/example10-simple-http-server/server/server06.go
 [17]: https://github.com/go-training/training/blob/master/example10-simple-http-server/server/server07.go