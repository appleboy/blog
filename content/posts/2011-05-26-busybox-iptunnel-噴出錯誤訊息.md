---
title: busybox iptunnel 噴出錯誤訊息
author: appleboy
type: post
date: 2011-05-26T06:42:49+00:00
url: /2011/05/busybox-iptunnel-噴出錯誤訊息/
views:
  - 74
bot_views:
  - 99
dsq_thread_id:
  - 314114517
categories:
  - Embedded System
tags:
  - Busybox
  - Embedded System

---
最近在弄新案子，用的是 [Atheros][1] solution (被[高通][1]買下)，發現 SDK 裡面已經有更新到 [Busybox][2] 1.15，由於在建 ipv6 tunnel 時候必須用到 ip 這指令，當然必須支援 iptunnel，當我把 busybox 選項打開就噴出底下錯誤訊息: 

> busybox-1.01/networking/libiproute/libiproute.a(iptunnel.o):iptunnel.c:(.text+0x574): more undefined references to \`_\_cpu\_to_be16' follow 在 Google 大神指示下找到[一篇答案][3] 修改 networking/libiproute/iptunnel.c 

<pre class="brush: bash; title: ; notranslate" title="">#include <asm/types.h> 
# 後面加上 
#include <asm/byteorder.h></pre>

 [1]: http://www.qca.qualcomm.com/
 [2]: http://www.busybox.net/
 [3]: http://groups.google.com/group/linux.debian.user.german/browse_thread/thread/76cd0c6ff94af074