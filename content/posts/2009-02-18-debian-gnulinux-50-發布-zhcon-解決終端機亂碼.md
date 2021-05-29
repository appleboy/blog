---
title: '[Debian] GNU/Linux 5.0 發布 zhcon 解決終端機亂碼'
author: appleboy
type: post
date: 2009-02-18T07:28:14+00:00
url: /2009/02/debian-gnulinux-50-發布-zhcon-解決終端機亂碼/
views:
  - 12320
bot_views:
  - 759
dsq_thread_id:
  - 246708701
categories:
  - Debian
  - Linux
  - Ubuntu
tags:
  - Debian
  - Linux
  - Ubuntu

---
[Debian][1] 釋出了 GNU/Linux 5.0 發布，[官方新聞][2] 於2009年02月14日發佈出來，最近想說把自己的 NB 要換成 Debian 5.0 版本，不過之前都是在玩 Ubuntu 的狀況下，所以就找 i386 的 ISO 檔案，利用虛擬機器 [VirtualBox][3]，之前也沒有玩過虛擬機器，都是直接燒光碟，拿主機來硬幹，哈哈，不過想說學習一下 VitualBox 來試試看，我參考了一篇 [VirtualBox指南][4]，寫的很不錯，我就拿來使用 Debian 5.0 了，不過安裝過程其實還蠻簡易的，可以參考這篇：[[教學]圖解Debian Desktop安裝筆記(1)][5]，這篇寫的很好，也淺顯易懂，安裝好之後，開機 grub 畫面如下： [<img title="2009-02-18_151709 (by appleboy46)" src="https://i1.wp.com/farm4.static.flickr.com/3651/3289226153_da7c30e54c.jpg?resize=500%2C320&#038;ssl=1" alt="2009-02-18_151709 (by appleboy46)" data-recalc-dims="1" />][6] <!--more--> 成功的登入畫面： 

[<img title="2009-02-18_152046 (by appleboy46)" src="https://i0.wp.com/farm4.static.flickr.com/3606/3290049016_d9eac5938e.jpg?resize=500%2C320&#038;ssl=1" alt="2009-02-18_152046 (by appleboy46)" data-recalc-dims="1" />][7] 安裝成功之後，接下來會遇到的就是終端機亂碼問題啦，其實因為我沒玩過 VirtualBox 的關係，所以不會遇到此問題，我都是利用 SSH 遠端的方式，來處理問題，不過這個也不難解決，只要安裝了 zhcon 這套軟體，就可以了。 底下是亂碼： [<img src="https://i1.wp.com/farm4.static.flickr.com/3650/3289234093_467309d29b.jpg?resize=500%2C320&#038;ssl=1" title="2009-02-18_152247 (by appleboy46)" alt="2009-02-18_152247 (by appleboy46)" data-recalc-dims="1" />][8] 先將 

> deb http://opensource.nchc.org.tw/debian/ etch main 寫到 /etc/apt/source.list 裡面，利用 apt-get 安裝 zhcon 軟體 

<pre class="brush: bash; title: ; notranslate" title="">apt-get install zhcon</pre> 剛開始下 zhcon 指令會造成畫面當掉，全部都是黑色的，我 google 了一下找到一篇 

[Debian unstable中的2.6.26内核不支持zhcon了！一用zhcon就会死机！][9]，裡面寫到解法： 

<pre class="brush: bash; title: ; notranslate" title="">alias zhcon='zhcon --utf8 --drv=vga' </pre> 這樣就可以成功了，執行畫面如下： 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3521/3290029236_25bf6a18df.jpg?resize=500%2C421&#038;ssl=1" title="2009-02-18_150459 (by appleboy46)" alt="2009-02-18_150459 (by appleboy46)" data-recalc-dims="1" />][10] 所以其實還蠻簡單的，接下來安裝自行要的軟體了

 [1]: http://debian.org
 [2]: http://debian.org/News/2009/20090214.zh-tw.html
 [3]: http://www.virtualbox.org/
 [4]: http://www.peachwaneversay.blogspot.com/2007/06/virtualbox_09.html
 [5]: http://maxubuntu.blogspot.com/2008/12/debian-desktop.html
 [6]: https://www.flickr.com/photos/appleboy/3289226153/ "2009-02-18_151709 (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/3290049016/ "2009-02-18_152046 (by appleboy46)"
 [8]: https://www.flickr.com/photos/appleboy/3289234093/ "2009-02-18_152247 (by appleboy46)"
 [9]: http://www.linuxsir.org/bbs/thread337539-2.html
 [10]: https://www.flickr.com/photos/appleboy/3290029236/ "2009-02-18_150459 (by appleboy46)"