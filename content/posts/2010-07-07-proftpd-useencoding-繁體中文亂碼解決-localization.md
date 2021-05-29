---
title: ProFTPD UseEncoding 繁體中文亂碼解決 Localization
author: appleboy
type: post
date: 2010-07-07T08:07:13+00:00
url: /2010/07/proftpd-useencoding-繁體中文亂碼解決-localization/
views:
  - 2768
bot_views:
  - 288
dsq_thread_id:
  - 246977016
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - proftpd

---
<img src="https://i0.wp.com/farm5.static.flickr.com/4096/4770121725_6a997912c6_o.png?w=840&#038;ssl=1" alt="Proftpd" data-recalc-dims="1" /> [ProFTPD][1] 一直都是我最喜歡使用的 FTP 伺服器，設定方式簡單淺顯易懂，最近在用 [PSPad][2] 寫程式，發現使用內建 FTP 功能時候，連不上 [FreeBSD][3] 架設的 ProFTPD，連線過程出現許多亂碼，所以造成 PSPad 斷線出現錯誤，解決方式就是利用 [mod_lang][4] 模組，設定 [UseEncoding][5] 讓系統可以顯示 Big5 中文編碼，FreeBSD Ports 請勾選 

<pre class="brush: bash; title: ; notranslate" title="">[X] NLSUOTA Use nls (builds mod_lang)</pre> 自行編譯請按照底下步驟 

<pre class="brush: bash; title: ; notranslate" title="">./configure --enable-nls
make
make install </pre>

### UseEncoding 設定

<pre class="brush: bash; title: ; notranslate" title="">Syntax: UseEncoding on|off|local-charset client-charset
Default: None
Context: "server config", <VirtualHost>, <Global>
Module: mod_lang
Compatibility: 1.3.2rc1</pre> 在 1.3.2rc1 版本之後才有支援，請複製底下設定，貼到 proftpd.conf 

<pre class="brush: bash; title: ; notranslate" title=""># 简体中文環境
UseEncoding UTF-8 GBK
# 繁体中文環境
UseEncoding UTF-8 Big5</pre> Reference: 

[ProFTPD module mod_lang][4] [centos上解決proftp中文亂碼問題][6]

 [1]: http://www.proftpd.org/
 [2]: http://www.pspad.com/
 [3]: http://www.freebsd.org
 [4]: http://www.proftpd.org/docs/modules/mod_lang.html
 [5]: http://www.proftpd.org/docs/modules/mod_lang.html#UseEncoding
 [6]: http://wanglq.blog.51cto.com/783560/340741