---
title: 在本機端快速產生網站免費憑證
author: appleboy
type: post
date: 2018-07-06T02:36:54+00:00
url: /2018/07/mkcert-zero-config-tool-to-make-locally-trusted-development-certificates/
dsq_thread_id:
  - 6775759841
categories:
  - DevOps
  - Golang
tags:
  - certificate
  - golang

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1785/43227213371_a041db0810_o.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

大家看到網站免費憑證，一定會想到 [Let's encrypt][2] 服務商提供一個網域可以使用 100 個免費憑證，如果您有很多 subdomain 需求，還可以申請獨立一張 [wildcard 憑證][3]，但是這是在伺服器端的操作，假設在本機端開發，該如何快速產生憑證，這樣開啟瀏覽器時，就可以看到綠色的 https 字眼

[<img src="https://i2.wp.com/farm1.staticflickr.com/921/43177490822_974612c015_z.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][4]

<!--more-->

## 安裝 mkcert

本篇介紹一個用 [Go 語言][5]寫的工具叫做 [mkcert][6]，此工具目前只有支援 MacOS 及 Linux 環境，未來會支援 Windows，如果有在玩 Windows 的開發者，也可以直接開 PR 啦。安裝方式非常簡單。在 MacOS 可以用 brew

<pre><code class="language-bash">$ brew install mkcert
$ brew install nss # if you use Firefox</code></pre>

## 使用 mkcert

第一步驟就是先初始化目錄

<pre><code class="language-bash">$ mkcert -install</code></pre>

接著看看有幾個網站 domain 需要在本機端使用可以一次申請

<pre><code class="language-bash">$ mkcert myapp.dev example.com
Using the local CA at "/Users/xxxxxx/Library/Application Support/mkcert" ✨

Created a new certificate valid for the following names 📜
 - "example.com"
 - "myapp.dev"

The certificate is at "./example.com+1.pem" and the key at "./example.com+1-key.pem" ✅</code></pre>

## 撰寫簡單 https 服務

這邊用 Go 語言當例子

<pre><code class="language-go">package main

import (
    "log"
    "net/http"
)

func helloServer(w http.ResponseWriter, req *http.Request) {
    w.Header().Set("Content-Type", "text/plain")
    w.Write([]byte("This is an example server.\n"))
}

func main() {
    log.Println("Server listen in 443 port. Please open https://localhost/hello")
    http.HandleFunc("/hello", helloServer)
    err := http.ListenAndServeTLS(":443", "ssl/localhost.pem", "ssl/localhost-key.pem", nil)
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}</code></pre>

其中 `ssl/localhost.pem` 跟 `ssl/localhost-key.pem` 就是剛剛透過 mkcert 產生出來的金鑰。透過 curl 工具，可以快速驗證是否成功:

<pre><code class="language-bash">$ curl -v https://localhost/hello
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* Cipher selection: ALL:!EXPORT:!EXPORT40:!EXPORT56:!aNULL:!LOW:!RC4:@STRENGTH
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/cert.pem
  CApath: none
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Client hello (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS change cipher, Client hello (1):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: O=mkcert development certificate
*  start date: Jul  5 02:06:09 2018 GMT
*  expire date: Jul  6 02:06:09 2028 GMT
*  subjectAltName: host "localhost" matched cert&#039;s "localhost"
*  issuer: O=mkcert development CA
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7f8fca805800)
> GET /hello HTTP/2
> Host: localhost
> User-Agent: curl/7.54.0
> Accept: */*
>
* Connection state changed (MAX_CONCURRENT_STREAMS updated)!
&lt; HTTP/2 200
&lt; content-type: text/plain
&lt; content-length: 27
&lt; date: Fri, 06 Jul 2018 02:30:54 GMT
&lt;
This is an example server.
* Connection #0 to host localhost left intact</code></pre>

上面範例放在 [go-training 專案][7]內，歡迎大家取用。

 [1]: https://i1.wp.com/farm2.staticflickr.com/1785/43227213371_a041db0810_o.png?ssl=1
 [2]: https://letsencrypt.org/
 [3]: https://community.letsencrypt.org/t/acme-v2-and-wildcard-certificate-support-is-live/55579
 [4]: https://i2.wp.com/farm1.staticflickr.com/921/43177490822_974612c015_z.jpg?ssl=1
 [5]: https://golang.org
 [6]: https://github.com/FiloSottile/mkcert
 [7]: https://github.com/go-training/training/tree/master/example21-simple-golang-https-tls