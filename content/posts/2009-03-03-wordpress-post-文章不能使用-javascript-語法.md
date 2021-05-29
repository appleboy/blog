---
title: '[WordPress] post 文章不能使用 javascript 語法'
author: appleboy
type: post
date: 2009-03-03T12:38:12+00:00
url: /2009/03/wordpress-post-文章不能使用-javascript-語法/
views:
  - 6758
bot_views:
  - 514
dsq_thread_id:
  - 246785424
categories:
  - AJAX
  - javascript
  - Linux
tags:
  - google
  - javascript
  - plugin
  - wordpress

---
之前寫了一篇讓 wordpress 可以支援 [Google Map API][1] 的教學：[[AJAX] google map 的應用][2]，不過我將 WordPress 升級到 WordPress 2.8-bleeding-edge 版本，發現 javascript 語言就不能使用了，因為在寫 javascript 的時候，有利用到 <br /> 這個 Tag，不過送出後轉出來的 javascript 語言會變成編碼過後，" 會變成 &#8221; Big5 編碼，所以這個問題很困擾我，去找一下 ，Wordpress 把斷行完全用 wpautop 這個函式下去取代，所以你只要在內容寫入 <br / > 都會消失，不然就是出現怪問題。 這個問題也不是無解，在網路上找到兩個解法： 1. [inline-js - wordpress plugin][3] 您只要在 javascript 語言包一層 tag 就可以了 

<pre class="brush: jscript; title: ; notranslate" title=""></pre>

<!--more--> 2. 

<a href="http://www.automateyourbusiness.com/updates/2007/07/18/javascript-in-wordpress-posts/" target="_blank">Javascript In WordPress Posts</a> 這個外掛，下載點（適用至wordpress2.7）：[wp-ayb-javascriptinposts.zip][4]，參考文章：[讓wordpress文章(post和page)可以使用javascript][5] 這外掛就是將 wpautop 拿掉，自行寫取代函式，將 javascript 支援，不過目前有一個小 bug，那就是如果 script 裡面有 ' 的話，要把他先取代成 "，不然所有的 ' 都會變成 \\'，這樣 javascript 就不會動了喔 我個人是利用 2 這個方式，感覺比較容易。

 [1]: http://code.google.com/apis/maps/
 [2]: http://blog.wu-boy.com/2008/10/04/532/
 [3]: http://www.ooso.net/inline-js
 [4]: http://www.automateyourbusiness.com/downloads/wp-ayb-javascriptinposts.zip
 [5]: http://andy.diimii.com/2009/02/%E8%AE%93wordpress%E6%96%87%E7%AB%A0post%E5%92%8Cpage%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8javascript/