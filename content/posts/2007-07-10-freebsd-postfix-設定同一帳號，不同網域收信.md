---
title: '[FreeBSD] Postfix 設定同一帳號，不同虛擬網域收信'
author: appleboy
type: post
date: 2007-07-11T04:09:05+00:00
url: /2007/07/freebsd-postfix-設定同一帳號，不同網域收信/
views:
  - 4679
bot_views:
  - 788
dsq_thread_id:
  - 246801270
categories:
  - FreeBSD
  - mail

---
如果一台機器要管理多的網域的email，大家一定會遇到如果2個domain分別是 aaaa.com.tw，bbbb.com.tw，但是兩間公司都有 suport@aaaa.com.tw，suport@bbbb.com.tw，這樣子就會造成衝突，因為這兩間公司負責人不同，那要怎麼導向不同帳號呢，所以我們作法如下 

  * 建立收發特定信的使用者帳號：真正收到信件的系統帳號 
  * 建立虛擬郵件伺服器位址與帳號對照表：郵件位址跟收信帳號對照表 

<!--more--> 比如兩個網域如下： 

> aaaa.com.tw bbbb.com.tw 首先要先建立系統帳號：通常我會下列設定 帳號：使用者名稱.網域名稱 所以我設定如下 appleboy.aaaa -> appleboy@aaaa.com.tw appleboy.bbbb -> appleboy@bbbb.com.tw 然後使用freebsd pw 的新增指令 

<pre class="brush: bash; title: ; notranslate" title="">pw useradd -m -n appleboy.aaaa -s /sbin/nologin
pw useradd -m -n appleboy.bbbb -s /sbin/nologin
</pre> 然後再來是設定 postfix main.cf 

<pre class="brush: bash; title: ; notranslate" title="">mydestination = $myhostname, localhost
#mydestination 不要把虛擬的網域設定在裡面
#設定虛擬網域在下面
virtual_alias_domains = aaaa.com.tw, bbbb.com.tw
virtual_alias_maps = hash:/usr/local/etc/postfix/virtual
</pre> 最後打開 /usr/local/etc/postfix/virtual 設定對照表 

<pre class="brush: bash; title: ; notranslate" title=""># AUTHOR(S)
#        Wietse Venema
#        IBM T.J. Watson Research
#        P.O. Box 704
#        Yorktown Heights, NY 10598, USA
#
#                                                                     VIRTUAL(5)
appleboy@bbbb.com.tw  appleboy.bbbb
appleboy@aaaa.com.tw  appleboy.aaaa
</pre> 然後重新啟動postfix 

<pre class="brush: bash; title: ; notranslate" title="">postmap /usr/local/etc/postfix/virtual
postfix reload
</pre> 然後看 log 檔案 

<pre class="brush: bash; title: ; notranslate" title="">Jul 11 10:49:06 FreeBSD postfix/local[40760]: AF6A32840C: to=&lt;appleboy.aaaa@aaaa.com.tw>, orig_to=&lt;appleboy@aaaa.com.tw>, relay=local, delay=8, delays=0.25/0.01/0/7.8, dsn=2.0.0, status=sent (delivered to command: /usr/local/bin/procmail -a "$EXTENSION")
</pre>