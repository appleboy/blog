---
title: '[FreeBSD]解決swap不夠的情況：Add Swap Space'
author: appleboy
type: post
date: 2008-06-21T09:43:17+00:00
url: /2008/06/freebsd解決swap不夠的情況：add-swap-space/
views:
  - 4956
bot_views:
  - 511
dsq_thread_id:
  - 246785337
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - swap

---
最近在使用 FreeBSD 架站，apache + MySQL + PHP，但是最近常常會吐出來 swap 不夠的情形，然後系統就會吐出下面訊息 

> Jun 19 20:59:57 backup kernel: swap\_pager\_getswapspace(7): failed Jun 19 20:59:57 backup kernel: swap\_pager\_getswapspace(16): failed Jun 19 20:59:57 backup kernel: swap\_pager\_getswapspace(2): failed Jun 19 20:59:57 backup kernel: swap\_pager\_getswapspace(5): failed 目前上網看到的解決方法，都是增加 swap 的容量，那底下是在 FreeBSD 下面得作法： <!--more-->

[參考 FreeBSD 官網提供的教學][1] 第一步：先確定系統的 kernel 是否開啟 md 

<pre class="brush: bash; title: ; notranslate" title="">#
# cd /usr/src/sys/i386/conf
# vi GENERIC
#
device md # Memory "disks"</pre> 第二步：查看自己系統的 swap 資訊 

<pre class="brush: bash; title: ; notranslate" title="">#
# 系統 swap 資訊
#
Device          1K-blocks     Used    Avail Capacity
/dev/da0s1b       2062848       60  2062788     0%</pre> 第三步：建立系統的 swap 資訊 

<pre class="brush: bash; title: ; notranslate" title="">#
# 如果你要新增1G的話，那就是把 count=64 改成 count=1024
#
dd if=/dev/zero of=/usr/swap0 bs=1024k count=64</pre> 第四步：設定權限 

<pre class="brush: bash; title: ; notranslate" title="">#
# 設定 swap 權限
#
chmod 0600 /usr/swap0</pre> 第五步：設定開機自動加入 

<pre class="brush: bash; title: ; notranslate" title="">#
# /etc/rc.conf
#
swapfile="/usr/swap0"   # Set to name of swapfile if aux swapfile desired.</pre> 重新啟動電腦，或者是下底下指令就可以看到了 

<pre class="brush: bash; title: ; notranslate" title="">#
# 下底下指令
#
mdconfig -a -t vnode -f /usr/swap0 -u 0 &#038;& swapon /dev/md0</pre>

 [1]: http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/adding-swap-space.html