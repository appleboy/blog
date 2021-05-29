---
title: Geany 編輯器搭配 sshfs 參數注意事項
author: appleboy
type: post
date: 2011-12-24T08:17:43+00:00
url: /2011/12/linux-geany-sshfs-flag/
dsq_thread_id:
  - 514642291
categories:
  - Linux
tags:
  - Geany
  - Linux
  - SSH
  - sshfs
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6562683991/" title="geany_vectorized_free by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7155/6562683991_065975d0dd_m.jpg?resize=240%2C191&#038;ssl=1" alt="geany_vectorized_free" data-recalc-dims="1" /></a>
</div>

<a href="http://www.geany.org/" target="_blank">Geany</a> 是一套我覺得在 Linux 作業系統底下蠻簡易及輕量的程式編輯器，之前撰寫一篇 <a href="http://blog.wu-boy.com/2011/07/linux-geany-fuse/" target="_blank">Linux 程式開發編輯器 Geany + Fuse 遠端掛載</a> 簡易介紹如何使用 <a href="http://fuse.sourceforge.net/" target="_blank">Fuse</a>，這次發現一個小問題，就是掛載要儲存檔案時候出現底下錯誤訊息 

> Error renaming temporary file: Operation not permitted. The file on disk may now be truncated! 此錯誤訊息發生在用 Fuse 掛載遠端系統所造成，原先掛載指令如下 

<pre class="brush: bash; title: ; notranslate" title="">sshfs appleboy@xxxx.com.tw:/home/appleboy /home/git/CN 
-p 22 -o reconnect,sshfs_sync -o uid=1000,gid=1000</pre> 我們只需要另外加上 

<span style="color:green"><strong>workaround=rename</strong></span> flag 及可以解決此問題 

<pre class="brush: bash; title: ; notranslate" title="">sshfs appleboy@www.cn.ee.ccu.edu.tw:/home/appleboy /home/git/CN 
-p 22 -o reconnect,sshfs_sync -o uid=1000,gid=1000 
-o workaround=rename</pre> 測試環境為 Ubuntu 10.10.