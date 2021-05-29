---
title: 如何使用 PPA 升級 Ubunut Firefox 瀏覽器到 4.0
author: appleboy
type: post
date: 2011-03-25T05:50:44+00:00
url: /2011/03/如何使用-ppa-升級-ubunut-firefox-瀏覽器到-4-0/
views:
  - 447
bot_views:
  - 162
dsq_thread_id:
  - 262625896
categories:
  - Ubuntu
  - www
tags:
  - Firefox
  - Ubuntu

---
[<img src="https://i2.wp.com/farm6.static.flickr.com/5266/5557399853_16c4b21191.jpg?resize=500%2C309&#038;ssl=1" alt="FireFox_4_about" data-recalc-dims="1" />][1] 作者目前使用 [Ubuntu][2] 10.10 (maverick) 桌面環境，也是台灣 [MozTW][3] 成員之一，這次 [FireFox 4.0 Release][4] 介面有些改變，使用上來也非常順手，記憶體好像吃的比較少了？(有待商榷)，現在就來升級 FireFox 吧，兩種升級方式，如果不熟悉 Command Line 就用 GUI 升級，另一種升級方式就是用 apt-get upgrade 啦。 如果用 Windows 請到[這裡下載][5] 

### 利用 GUI 介面升級 (Install firefox 4 using GUI) 我的環境是英文，所以底下寫的是英文安裝方式: 按照底下步驟進行 

<pre class="brush: bash; title: ; notranslate" title="">Applications > Ubuntu Software Center > Edit > Software Sources </pre> 之後點選 "Other Software" 選擇左下角 "Add" 按鈕，接著把底下文字輸入 

<pre class="brush: bash; title: ; notranslate" title="">ppa:mozillateam/firefox-stable</pre> 最後到底下升級，就可以開始使用 FireFox 4 了 

<pre class="brush: bash; title: ; notranslate" title="">System > Administration > Update Manager</pre>

### 文字介面升級 (Install firefox 4 using terminal) 只要鍵入三行指令即可 

<pre class="brush: bash; title: ; notranslate" title="">$ sudo add-apt-repository ppa:mozillateam/firefox-stable
$ sudo apt-get update
$ sudo apt-get upgrade</pre> 沒圖沒真相啦，底下附上桌面截圖 

[<img src="https://i2.wp.com/farm6.static.flickr.com/5024/5557399847_7afb451e72.jpg?resize=500%2C313&#038;ssl=1" alt="firefox_4" data-recalc-dims="1" />][6] Reference: [How to install firefox 4 in ubuntu using PPA][7] [Firefox 4 正式版現已推出，帶給您更棒的網路體驗][8]

 [1]: https://www.flickr.com/photos/appleboy/5557399853/ "FireFox_4_about by appleboy46, on Flickr"
 [2]: http://www.ubuntu.com/
 [3]: http://moztw.org/
 [4]: http://www.mozilla.com/en-US/firefox/fx/
 [5]: http://www.mozilla.com/en-US/firefox/all.html
 [6]: https://www.flickr.com/photos/appleboy/5557399847/ "firefox_4 by appleboy46, on Flickr"
 [7]: http://www.ubuntugeek.com/how-to-install-firefox-4-in-ubuntu-using-ppa.html
 [8]: http://www.freegroup.org/2011/03/firefox-4/