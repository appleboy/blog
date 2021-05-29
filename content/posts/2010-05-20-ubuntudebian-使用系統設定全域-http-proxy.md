---
title: '[Ubuntu/Debian] 使用系統設定全域 http Proxy'
author: appleboy
type: post
date: 2010-05-20T08:46:01+00:00
url: /2010/05/ubuntudebian-使用系統設定全域-http-proxy/
views:
  - 4199
bot_views:
  - 364
dsq_thread_id:
  - 248971864
categories:
  - Ubuntu
tags:
  - proxy
  - Ubuntu

---
如果想讓 Ubuntu/Debian 不管是 http 或者是 ftp 都可以透過 Proxy 去取得資料，就必須要設定系統 Proxy，目前任職公司就必須這樣設定，當然也可以透過其他方式出去(ex. ssh tunnel) 可以搜尋其他文章，底下分成兩種方式設定。 1. 利用 command line 方式設定 

<pre class="brush: bash; title: ; notranslate" title="">export http_proxy=http://username:password@proxyserver.net:port/
export ftp_proxy=http://username:password@proxyserver.netport/</pre> 寫入 ~/.bashrc 

<pre class="brush: bash; title: ; notranslate" title="">source ~/.bashrc </pre> 2. 利用 Desktop 介面設定 

<pre class="brush: bash; title: ; notranslate" title="">Settings-> Preference -> Network
系統\偏好設定\代理伺服器</pre> reference: 

[How to use apt-get behind proxy server (Ubuntu/Debian)][1] [Ubuntu Proxy的設定][2]

 [1]: http://blog.mypapit.net/2006/02/how-to-use-apt-get-behind-proxy-server-ubuntudebian.html
 [2]: http://goo.gl/SZYH