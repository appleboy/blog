---
title: 'PHP curl error: SSL certificate problem, verify that the CA cert is OK'
author: appleboy
type: post
date: 2011-05-16T03:46:18+00:00
url: /2011/05/php-curl-error-ssl-certificate-problem-verify-that-the-ca-cert-is-ok/
views:
  - 189
bot_views:
  - 91
dsq_thread_id:
  - 304828843
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
之前在 [CodeIgniter][1] 寫了 [CodeIgniter-Google-URL-Shortener-API][2] 縮短網址的 [goo.gl API Library][3]，也在[國外 CodeIgniter 論壇發表了一篇][4]，不過在論壇有人回覆安裝好之後不能使用，會直接噴出底下錯誤訊息: 

> Severity: Notice Message: Trying to get property of non-object Filename: controllers/google_url.php Line Number: 24 之後我在 Windows 利用 [Appserv][5] 架設好這環境，發現是同樣問題，但是在 [FreeBSD][6] 跟 [Ubuntu][7] 上面都不會出現這錯誤訊息，接著在程式馬上面看看 curl 吐出什麼資料: 

> Curl error: SSL certificate problem, verify that the CA cert is OK. Details: error:14090086:SSL routines:SSL3\_GET\_SERVER_CERTIFICATE:certificate verify failed 把這錯誤訊息拿去 Google 發現到這篇解法 [Curl: SSL certificate problem, verify that the CA cert is OK][8]，只要跳過驗證憑證就可以了 

<pre class="brush: php; title: ; notranslate" title="">curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, 0);</pre> 可以參考 

[PHP][9] 官方 [curl_setop][10]t 的設定說明。

 [1]: http://www.codeigniter.org.tw/
 [2]: https://github.com/appleboy/CodeIgniter-Google-URL-Shortener-API
 [3]: http://code.google.com/intl/zh-TW/apis/urlshortener/overview.html
 [4]: http://codeigniter.com/forums/viewthread/181379/
 [5]: http://www.appservnetwork.com/
 [6]: http://www.FreeBSD.org
 [7]: http://www.ubuntu.com/
 [8]: http://ademar.name/blog/2006/04/curl-ssl-certificate-problem-v.html
 [9]: http://php.net
 [10]: http://php.net/manual/en/function.curl-setopt.php