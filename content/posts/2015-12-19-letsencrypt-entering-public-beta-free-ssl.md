---
title: Letsencrypt 開放申請免費 SSL 憑證
author: appleboy
type: post
date: 2015-12-19T07:03:12+00:00
url: /2015/12/letsencrypt-entering-public-beta-free-ssl/
dsq_thread_id:
  - 4416567234
categories:
  - apache
  - Network
  - Nginx
  - SSL
tags:
  - Github
  - Letsencrypt
  - nginx
  - SSL
  - StartSSL

---
<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23840721545/in/dateposted-public/" title="Letsencrypt"><img src="https://i1.wp.com/farm6.staticflickr.com/5803/23840721545_e0350b687f.jpg?w=300&#038;ssl=1" alt="Letsencrypt" data-recalc-dims="1" /></a>
</div>

很高興在今年 12/03 [Letsencrypt][1] 宣布進入 [public beta 階段][2]，開放免費 SSL 提供給開發者或正式網站使用，在這之前屬於封測階段，必須透過申請的方式才可以拿到 SSL 憑證。在知道 Letsencrypt 之前，我都是使用免費的 [StartSSL][3]，這家申請的分式比較複雜，你可以在網路上找到許多[申請教學][4]，但是就是按部就班操作，就可以拿到一年份的 SSL 憑證，也就是一年申請一次啦，但是 Letsencrypt 申請的方式可以直接透過 command line 快速產生相對應的憑證，支援的 Plugin 也非常多 (像是 [Apache][5], [Nginx][6])，詳細的操作方式可以參考[線上文件][7]。這邊就不多說了，只要安裝好 Letsencrypt 指令，就可以無痛拿到各網站憑證，在 [Github][8] 上面你可以找到許多別人[寫好的 Plugin][9]，隨便挑一個來使用吧。

<!--more-->

使用 Letsencrypt 指令時，需要注意的是如果你要測試指令是否可以成功，你可以針對 [Letsencrypt Staging Server][10] 發送請求，也就是透過讀取設定檔 `--config cli.ini` 方式來測試，因為 Letsencrypt 正式申請憑證伺服器有底下限制，所以指令不要隨便亂下。Letsencrypt 目前有兩種限制 Registrations/IP address 及 Certificates/Domain。

`Registrations/IP` 限制就是每個 IP 只能在 3 小時內發送 10 次請求，如果超過 10 次就會被阻擋，所以申請成功的 Domain，不要隨便砍掉 `/etc/letsencrypt/accounts` 目錄，否則你就不能重複申請了。

`Certificates/Domain` 限制就是在七天內你的主 Domain 跟 sub Domain 夾起來只能申請五個，所以當你申請五個 domain 時，Letsencrypt 就會阻擋你申請下一個 domain 了，最後要注意的是，Letsencrypt 申請憑證使用期限是 `90` 天，官方建議如果使用在正式網站，請 60 天重新 renew 一次。

由於現在還是 public beta 階段，就請大家好好保護這免費的 Letsencrypt 網站，說到這裡，這樣還有人要去買憑證嗎？ＸＤ不過話說回來，如果有一天突然要收費，不知道會是多少錢？

 [1]: https://letsencrypt.org
 [2]: https://letsencrypt.org/2015/12/03/entering-public-beta.html
 [3]: https://www.startssl.com/
 [4]: https://www.google.com.tw/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=startSSL%20%E6%95%99%E5%AD%B8
 [5]: https://httpd.apache.org/
 [6]: http://nginx.org/
 [7]: https://letsencrypt.readthedocs.org/en/latest/
 [8]: https://github.com/
 [9]: https://github.com/search?utf8=%E2%9C%93&q=Letsencrypt
 [10]: https://acme-staging.api.letsencrypt.org/directory