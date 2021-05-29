---
title: '[PHP]如何使用 flush() 跟 ob_flush()'
author: appleboy
type: post
date: 2008-07-28T06:02:17+00:00
url: /2008/07/php如何使用-flush-跟-ob_flush/
views:
  - 8419
bot_views:
  - 642
dsq_thread_id:
  - 247281304
categories:
  - php
tags:
  - php

---
比如說我們想要緩衝網頁資料，如利用 [sleep()][1] 這個函式，那我們不想要等整個 php 執行完畢才輸出畫面，那就是需要緩衝輸出，在 [酷學園][2] 的這篇 http://phorum.study-area.org/index.php/topic,52757.0.html 有討論到，所以我實際去測試一下，大概如下： 

<pre class="brush: php; title: ; notranslate" title=""><?php

ob_flush();
echo "這是第一行<br />";
flush();
sleep(2);

for ($i=10; $i>0; $i--)
{
    echo $i . "

<br />";
    ob_flush();
    flush();
    sleep(1);
}
ob_end_flush();
?></pre> 我覺得相當不錯用，大家可以參考看看。酷學園那篇，我測試好像沒有這種效果，Orz，不知道我測試錯誤，還是啥的地方搞錯 http://blog.goalercn.com/blogview.asp?logID=348

 [1]: http://tw.php.net/sleep
 [2]: http://phorum.study-area.org