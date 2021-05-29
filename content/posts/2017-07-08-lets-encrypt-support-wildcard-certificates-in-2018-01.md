---
title: Let’s Encrypt 將在 2018 年一月支援 Wildcard Certificates
author: appleboy
type: post
date: 2017-07-08T04:17:55+00:00
url: /2017/07/lets-encrypt-support-wildcard-certificates-in-2018-01/
dsq_thread_id:
  - 5972698743
categories:
  - DevOps
tags:
  - https
  - Letsencrypt
  - SSL

---
[<img src="https://i1.wp.com/farm6.staticflickr.com/5803/23840721545_e0350b687f.jpg?w=840&#038;ssl=1" alt="Letsencrypt" data-recalc-dims="1" />][1]

[Let’s Encrypt][2] 宣布在 2018 年一月全面支援 [Wildcard Certificates][3]，目的就是讓全世界網站都支援 HTTPS 協定。自從 2015 年 12 月宣布免費支援申請 HTTPS 憑證，從原本的 40% 跳升到 58%，Let’s Encrypt 到現在總共支援了 47 million 網域。

<!--more-->

## 升級 API

2018 年 1 月 Let's Encrypt 將支援 [IETF-standardized ACME v2][4] 版本，到時候就可以自動申請 Wildcard Certificates。[Go 語言][5]的 [autocert packge][6] 及 [Caddy][7] 都要一併修正支援 v2 API 版本。未來只要申請一次，就可以使用在全部 sub domain (像是 *.example.com)。

## 結論

Let's Encrypt 讓 Web 開發者都可以享用到 HTTPS 的優勢，當然也造成不少問題，之前寫了幾篇關於 Let's Encrypt 可以參考。實在無法想像現在還有沒支援 HTTPS 的網站，之前台北市政府外包案出包『[智慧支付 App 忘記切換HTTPS加密傳輸][8]』，還是被一位外國人發現的。

  * [在 Go 語言用一行程式碼自動化安裝且更新 Let’s Encrypt 憑證][9]
  * [申請 Let’s Encrypt 免費憑證讓網站支援 HTTP2][10]

 [1]: https://www.flickr.com/photos/appleboy/23840721545/in/dateposted-public/ "Letsencrypt"
 [2]: https://letsencrypt.org/
 [3]: https://letsencrypt.org/2017/07/06/wildcard-certificates-coming-jan-2018.html
 [4]: https://letsencrypt.org/2017/06/14/acme-v2-api.html
 [5]: https://golang.org
 [6]: https://github.com/golang/crypto/blob/master/acme/autocert/autocert.go
 [7]: https://caddyserver.com
 [8]: http://www.ithome.com.tw/news/115159
 [9]: https://blog.wu-boy.com/2017/04/1-line-letsencrypt-https-servers-in-golang/
 [10]: https://blog.wu-boy.com/2016/10/website-support-http2-using-letsencrypt/