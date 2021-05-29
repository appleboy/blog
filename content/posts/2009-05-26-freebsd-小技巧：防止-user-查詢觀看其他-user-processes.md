---
title: '[FreeBSD] 小技巧：防止 user 查詢觀看其他 user Processes'
author: appleboy
type: post
date: 2009-05-26T07:48:49+00:00
url: /2009/05/freebsd-小技巧：防止-user-查詢觀看其他-user-processes/
views:
  - 6242
bot_views:
  - 391
dsq_thread_id:
  - 247328578
categories:
  - FreeBSD
tags:
  - FreeBSD

---
看了這篇：[FreeBSD Prevent Users From Seeing Information About Processes Owned by Other Users][1]，裡面寫到如何防止其他使用者登入 ssh 觀看到其他使用者的一些動作，平常一般使用者可以利用 ps aux 指令關看到所有 Processes 的狀況，包含了系統所有使用者，這篇就是介紹如何關閉使用者查看其他不屬於自己的 Processes，作法有兩種，底下分別介紹，效果是一樣的： 1. 寫入 /etc/sysctl.conf 

<pre class="brush: bash; title: ; notranslate" title="">echo 'security.bsd.see_other_uids=0' >> /etc/sysctl.conf
echo 'security.bsd.see_other_gids=0' >> /etc/sysctl.conf</pre> 2. 直接在 command line 執行 

<pre class="brush: bash; title: ; notranslate" title="">sysctl security.bsd.see_other_uids=0
sysctl security.bsd.see_other_gids=0</pre> 兩種效果是一樣的，當然可以查詢目前的系統狀況 

<pre class="brush: bash; title: ; notranslate" title="">sysctl -a | grep security</pre>

 [1]: http://www.cyberciti.biz/faq/freebsd-disable-ps-sockstat-command-information-leakage/