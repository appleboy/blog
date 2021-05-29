---
title: 解決 WordPress 2.5 版本 RSS 摘要無法斷行
author: appleboy
type: post
date: 2008-04-16T12:41:20+00:00
url: /2008/04/解決-wordpress-25-版本-rss-摘要無法斷行/
views:
  - 2920
bot_views:
  - 818
dsq_thread_id:
  - 247280351
categories:
  - blog
  - Linux
  - wordpress
tags:
  - rss
  - wordpress

---
今天在升級我的blog：[小惡魔電腦技術 &#8211; AppleBOY’s Blog][1] 跟 [小惡魔的生活日記][2]，利用自己寫的： [[Wordpress] Upgrade 2.2.x to 2.5 無痛升級法 For Linux or FreeBSD][3] 這篇升級，但是升級好之後還去 [WordPress歡樂正體中文交流所][4] 把教學貼過去，然後順便看看其他文章，看到這篇 [更新至2.5後 RSS Reader問題][5]，然後我自己去測試也發現同樣問題，裡面有一個人說沒問題，我是不知道他怎麼測試的，我自己是發生同樣問題。 <!--more--> 問題就是當你使用 rss 訂閱文章的時候，會發先 google reader 不會幫你做斷行動作，或者是一些 html 的語法，這與我之前用到的發現不太一樣，rss 輸出會變成下面這張圖這樣 

[<img src="https://i0.wp.com/farm4.static.flickr.com/3146/2417923597_d912904109.jpg?resize=500%2C213&#038;ssl=1" title="wordpress_rss_01 (by appleboy46)" alt="wordpress_rss_01 (by appleboy46)" data-recalc-dims="1" />][6] 然後你去後台更改設定都是沒有用的，google reader 還是會把整篇文章都讀出來 [<img src="https://i2.wp.com/farm4.static.flickr.com/3023/2417925983_ef31b118b3.jpg?resize=500%2C355&#038;ssl=1" title="wordpress_rss_02 (by appleboy46)" alt="wordpress_rss_02 (by appleboy46)" data-recalc-dims="1" />][7] 後台這個設定根本就沒有作用，所有 reader 並不會做判斷 解決方法就是下載一個大陸人寫的外掛：[wp-CJK-excerpt][8] ，下載點：[點我][9] 裝好之後再去看 rss 的輸出 [<img src="https://i0.wp.com/farm3.static.flickr.com/2197/2418757212_25db9a60e5.jpg?resize=500%2C383&#038;ssl=1" title="wordpress_rss_03 (by appleboy46)" alt="wordpress_rss_03 (by appleboy46)" data-recalc-dims="1" />][10] 這比較正常了，可以正常輸出跟 read more了 [<img src="https://i1.wp.com/farm4.static.flickr.com/3295/2418761302_cab578bfc1.jpg?resize=500%2C237&#038;ssl=1" title="wordpress_rss_04 (by appleboy46)" alt="wordpress_rss_04 (by appleboy46)" data-recalc-dims="1" />][11]

 [1]: http://blog.wu-boy.com
 [2]: http://life.wu-boy.com
 [3]: http://blog.wu-boy.com/2008/04/16/177/
 [4]: http://www.robbin.cc/vb/index.php
 [5]: http://www.robbin.cc/vb/showthread.php?t=1493
 [6]: https://www.flickr.com/photos/appleboy/2417923597/ "wordpress_rss_01 (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/2417925983/ "wordpress_rss_02 (by appleboy46)"
 [8]: http://yskin.net/2006/07/mulberrykit.html
 [9]: http://ygxstg.tuk.livefilestore.com/y1p86L9xed_X54PIfgqmM3PN1YqyBGxJ8ktf15Fs4V9YBjXYSUvmw5QZISC6XkT0Cqlox7VsXX83aiJgCri0NHSMaIy5wnTX42t/wp-CJK-excerpt.zip?download
 [10]: https://www.flickr.com/photos/appleboy/2418757212/ "wordpress_rss_03 (by appleboy46)"
 [11]: https://www.flickr.com/photos/appleboy/2418761302/ "wordpress_rss_04 (by appleboy46)"