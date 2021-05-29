---
title: '[筆記] 在 Ubuntu mount DVD ISO  檔案'
author: appleboy
type: post
date: 2012-01-25T13:42:39+00:00
url: /2012/01/ubuntu-mount-dvd-iso-on-ubuntu/
dsq_thread_id:
  - 552110833
categories:
  - Debian
  - Linux
  - Ubuntu
tags:
  - Linux
  - mount
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div> 在網路上常常下載 

<a href="http://en.wikipedia.org/wiki/ISO_image" target="_blank">ISO 檔案</a>，<a href="http://zh.wikipedia.org/zh-tw/Microsoft_Windows" target="_blank">Windows</a> 底下可以透過虛擬光碟看到檔案內容，可是到了 <a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 系統該如何知道 ISO 裡面放了哪些檔案呢？其實很簡單，可以透過 mount 指令就可以做到了喔，參考 Ubuntu 台灣論壇: <a href="http://www.ubuntu-tw.org/modules/newbb/viewtopic.php?post_id=8406" target="_blank">如何mount iso檔? [論壇 - Ubuntu基本設定]</a> 

<pre class="brush: bash; title: ; notranslate" title="">$ mount /iso/ubuntu.iso /home/appleboy/ISO/ -t iso9660 -o loop</pre> 執行完上述指令，可以發現桌面會多出 DVD 光碟圖示，直接點選就可以了