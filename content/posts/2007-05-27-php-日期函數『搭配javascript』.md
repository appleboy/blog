---
title: '[PHP] 日期函數『搭配javascript』'
author: appleboy
type: post
date: 2007-05-28T02:07:17+00:00
url: /2007/05/php-日期函數『搭配javascript』/
views:
  - 3655
bot_views:
  - 653
dsq_thread_id:
  - 254279919
categories:
  - php
  - www

---
剛剛發現一個好玩的函數，用在購物車的時候，可以選擇發表團購日期，跟結束日期，下面我是設定發起日後14天之內要下架，還不錯用 大家參考看看吧，其實做出很多功能，大家修改函數就可以了 function jmp2\_date\_ex($str,$str1,$str2,$sy,$ey){ global $$str; $$str=str_replace("-","/",$$str); $nextWeek = time() + (14 \* 24 \* 60 * 60); $sy=date("Ymd"); $ey=date("Ymd",$nextWeek); echo "<input id='$str' name='$str' type='text' size=8 value='".$$str."' readonly style='height:18;font-size:9pt'>"; ?> <? } [/code]