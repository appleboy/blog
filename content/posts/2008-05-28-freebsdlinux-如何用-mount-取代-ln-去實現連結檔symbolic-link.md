---
title: '[FreeBSD&Linux] 如何用 mount 取代 ln 去實現連結檔(Symbolic Link)'
author: appleboy
type: post
date: 2008-05-28T14:14:56+00:00
url: /2008/05/freebsdlinux-如何用-mount-取代-ln-去實現連結檔symbolic-link/
views:
  - 5170
bot_views:
  - 625
dsq_thread_id:
  - 250178493
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - Linux
  - mount

---
我們在 Linux 或者是 FreeBSD 底下如何建立連結檔(Symbolic Link) ，也就是在 Windows 底下的捷徑啦，這個在鳥哥的網站都有寫的很清楚：[連結檔的介紹： ln][1]，最重要搞清楚 hard link 跟 soft link 就可以了，簡單來說，hard link 只可以針對檔案，不可以對目錄，但是 soft link 就是可以對目錄了，因為她就像 Windows 底下的捷徑，那在 Linux 底下，大家常常在玩 FTP，一定會碰到需要利用 Link 的方式，但是如果你利用 ln 的方式的話，連接ftp，會沒辦法回到上一層目錄，就是有 chroot 的問題，那底下是我發現可以解決的方法，其實這算是月經題了，只是我想記錄下來。 在 Linux 底下，就是利用 mount 的指令： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 就是利用 mount --bind
#
mount --bind olddir newdir</pre> 在 FreeBSD 底下，利用 mount_nulls 指令 

<pre class="brush: bash; title: ; notranslate" title="">#
#  mount_nullfs olddir newdir
#
mount_nullfs olddir newdir</pre> 很簡單吧，大概是這樣，FTP 就不會出現不能回到上一層目錄的問題了

 [1]: http://linux.vbird.org/linux_basic/0230filesystem.php#ln