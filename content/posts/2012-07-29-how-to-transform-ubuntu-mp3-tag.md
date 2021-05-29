---
title: 解決 Ubuntu MP3 亂碼
author: appleboy
type: post
date: 2012-07-29T03:34:56+00:00
url: /2012/07/how-to-transform-ubuntu-mp3-tag/
dsq_thread_id:
  - 783874267
categories:
  - Ubuntu
tags:
  - MP3
  - Ubuntu

---
在 Ubuntu 底下使用 <a href="http://projects.gnome.org/rhythmbox/" target="_blank">Rhythmbox Music Player</a> 來聽音樂，但是 import 整個 MP3 目錄之後，會看到全部都是亂碼的列表，解決方式就是用 <a href="http://easytag.sourceforge.net/" target="_blank">EasyTag</a> 軟體先將 MP3 標題轉碼，方式也很簡單，底下跟著操作就可以了。 

### 安裝 EasyTag 透過 apt-get 方式安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ sudo aptitude -y install easytag</pre>

### 轉馬步驟 打開偏好設定(Alt+P) 

[<img src="https://i0.wp.com/farm8.staticflickr.com/7252/7666075554_32b16bd1ff.jpg?resize=500%2C350&#038;ssl=1" alt="Screenshot from 2012-07-29 11:27:37" data-recalc-dims="1" />][1] 看到左下角(Character Set for reading ID3 Tag3)，先選擇您的語言，看是中文歌單，還是日文，選完之後先將程式關閉，關閉之前如果系統通知說要轉換，請務必先取消，之後再打開此軟體，直到看到歌單 Tags 可以正確顯示，才進行轉換。 參考網站: <a href="http://victe.blogspot.tw/2008/04/ubuntump3-tag.html" target="_blank">[Ubuntu]MP3 tag亂碼解決—不用任何指令</a>

 [1]: https://www.flickr.com/photos/appleboy/7666075554/ "Screenshot from 2012-07-29 11:27:37 by appleboy46, on Flickr"