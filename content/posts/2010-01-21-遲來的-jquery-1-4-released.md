---
title: 遲來的 jQuery 1.4 Released
author: appleboy
type: post
date: 2010-01-21T09:37:07+00:00
url: /2010/01/遲來的-jquery-1-4-released/
views:
  - 4058
bot_views:
  - 370
dsq_thread_id:
  - 247021570
categories:
  - jQuery
tags:
  - jQuery

---
為了慶祝 [jQuery][1] 四週年慶，官方網站終於 Release 1.4 版本了，也大幅度修改了 [jQuery API 網站][2]，跟以往一樣，jQuery 提供兩種版本讓大家測試跟下載：[jQuery Minified][3] (23kb Gzipped)，這版本是利用 [Google Closure Compiler][4] 去壓縮，以往好像是用 [YUI Compressor][5]，另一版本就是沒經過壓縮：[jQuery Regular][6] (154kb)，當然 Google 也提供了 host 來讓 jQuery 有 cache 檔案作用，增加網站速度： <http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js> 1.4 版本的出來，最主要就是效能的改善，以及整個 Code Base 翻修，可以參考 [John Resig][7] 寫的 [JavaScript Function Call Profiling][8]，看到底下的圖，就大致上知道 1.4 的效能改善 [<img src="https://i2.wp.com/farm3.static.flickr.com/2771/4292816426_9fb5cb331a_o.jpg?resize=500%2C375&#038;ssl=1" title="4271690739_f0bced3a78 (by appleboy46)" alt="4271690739_f0bced3a78 (by appleboy46)" data-recalc-dims="1" />][9] [.css()][10] and [.attr()][11] 效能改善圖： [<img src="https://i2.wp.com/farm5.static.flickr.com/4037/4292818140_753f22920f_o.jpg?resize=500%2C375&#038;ssl=1" title="4271691147_fd72853fa4 (by appleboy46)" alt="4271691147_fd72853fa4 (by appleboy46)" data-recalc-dims="1" />][12] 整篇都在說明 jQuery 效能的部份，真的是改善很多，[Media Temple][13] 主機商也贊助 jQuery 14天的徵文活動，大家可以上去看看有很多影片都是在介紹 jQuery，最後得獎的人可以獲得 13" MacBook Pro，真是太吸引人了。 最後可以參考 [黑暗執行緒][14]大大寫的：[jQuery 1.4 小閱兵][15]

 [1]: http://jquery14.com/day-01
 [2]: http://api.jquery.com/
 [3]: http://code.jquery.com/jquery-1.4.min.js
 [4]: http://code.google.com/closure/compiler/
 [5]: http://developer.yahoo.com/yui/compressor/
 [6]: http://code.jquery.com/jquery-1.4.js
 [7]: http://ejohn.org/blog/
 [8]: http://ejohn.org/blog/function-call-profiling/
 [9]: https://www.flickr.com/photos/appleboy/4292816426/ "4271690739_f0bced3a78 (by appleboy46)"
 [10]: http://api.jquery.com/css/
 [11]: http://api.jquery.com/attr/
 [12]: https://www.flickr.com/photos/appleboy/4292818140/ "4271691147_fd72853fa4 (by appleboy46)"
 [13]: http://mediatemple.net/
 [14]: http://blog.darkthread.net/blogs/
 [15]: http://blog.darkthread.net/blogs/darkthreadtw/archive/2010/01/16/jquery-1-4.aspx