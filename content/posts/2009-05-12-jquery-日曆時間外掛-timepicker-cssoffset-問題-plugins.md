---
title: '[jQuery] 日曆時間外掛 timepicker CSS/Offset 問題 | Plugins'
author: appleboy
type: post
date: 2009-05-12T06:07:42+00:00
url: /2009/05/jquery-日曆時間外掛-timepicker-cssoffset-問題-plugins/
views:
  - 15294
bot_views:
  - 664
dsq_thread_id:
  - 247044567
categories:
  - jQuery
tags:
  - jQuery

---
最近把之前弄的 [jQuery][1] 日期外掛拿出來看看，筆記過兩篇：<a href="http://blog.wu-boy.com/2008/05/13/251/" target="_blank">[jQuery筆記] 時間日期外掛：timepicker | jQuery Plugins</a> 跟 <a href="http://blog.wu-boy.com/2008/04/30/194/" target="_blank">[jQuery筆記] 好用的日期函式 datepicker</a>，目前在寫活動的開始時間跟結束時間會用到這兩個外掛，網路上有找到整合日期跟時間的程式，不過效果都不是我很喜歡，因為在時間方面想要設定可以分隔5分鐘，或者是10分鐘間隔，有沒有網友可以提供更好的 jQuery 外掛，可以將日曆跟時間整合在一起，用單一 input 欄位就可以控制，也可以設定間隔時間，目前是搭配這兩個外掛同時使用，也可以達到同樣效果。 timepicker [作者網站][2]，愈到了一個問題，只要網頁裡面有用到 [jQuery Show][3] 跟 [hide][4] 都會讓 timepicker 程式判斷 [CSS/offset][5] 發生錯誤，導致功能無法顯示在正確的地方，會跑到網頁其他位置，解決方法就是當滑鼠 click input 欄位時，再去呼叫取得目前 offset 的位置。 

<pre class="brush: jscript; title: ; notranslate" title="">var elmOffset = $(elm).offset();
$tpDiv.appendTo('body').css({'top':elmOffset.top + 'px', 'left':elmOffset.left+ 'px'}).hide();</pre> 這樣就可以正確顯示在 input 下方，連這個都可以遇到地雷 XD

 [1]: http://jquery.com/
 [2]: http://labs.perifer.se/timedatepicker/
 [3]: http://docs.jquery.com/Show
 [4]: http://docs.jquery.com/Hide
 [5]: http://docs.jquery.com/CSS/offset