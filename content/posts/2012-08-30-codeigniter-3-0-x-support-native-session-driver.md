---
title: CodeIgniter 3.0.x 支援 Native Session Driver
author: appleboy
type: post
date: 2012-08-30T12:54:11+00:00
url: /2012/08/codeigniter-3-0-x-support-native-session-driver/
dsq_thread_id:
  - 824263224
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 看來 

<a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> 團隊看到大家的心聲了，在 2.0.x 版本的時候就已經有人開始發 patch 讓 CI 可以支援 Native Session，也就是透過 session_start 來存取 session，而不是本來的 cookie session，很高興 <a href="http://philsturgeon.co.uk/" target="_blank">philsturgeon</a> (<a href="http://fuelphp.com/" target="_blank">Fuel Framework</a> 作者) 今天將此功能 merge 進來 3.0.x 分支，另外 Session 也同時抽出來變成 <a href="http://www.codeigniter.org.tw/user_guide/general/drivers.html" target="_blank">Driver</a> 而不是單一個 <a href="http://www.codeigniter.org.tw/user_guide/general/libraries.html" target="_blank">Library</a> 了，詳細可以看<a href="https://github.com/EllisLab/CodeIgniter/commit/1e40c21" target="_blank">此 Patch 連結</a>，也因為這樣所以之前自己寫的 <a href="https://github.com/appleboy/CodeIgniter-Native-Session" target="_blank">CodeIgniter-Native-Session</a> 可以功成身退了。目前官方同時維護兩個分支，2.1.x 另外是 3.0.x，後者是專門開發新功能，有機會在慢慢介紹。