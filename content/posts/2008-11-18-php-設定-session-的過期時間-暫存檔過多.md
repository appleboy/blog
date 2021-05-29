---
title: '[PHP] 設定 session 的過期時間 & 暫存檔過多'
author: appleboy
type: post
date: 2008-11-18T11:40:31+00:00
url: /2008/11/php-設定-session-的過期時間-暫存檔過多/
views:
  - 11708
bot_views:
  - 2714
dsq_thread_id:
  - 246733010
categories:
  - Linux
  - php
tags:
  - php

---
目前在 PHP 網站裡面，大部分的網站都是利用 session 的技術來達到驗證使用者帳號密碼，那 PHP 預設 SESSION 是把他寫入檔案，那 Linux 底下會放在 /tmp 裡面，你會發現網站越多人，裡面檔案就會越多，一串亂碼的檔案 sess_*，那底下是可以寫在程式裡面設定多久可以刪除這些過期的 Session 檔案 底下轉貼自：[Cross-Browser Session Starter][1] 

<pre class="brush: php; title: ; notranslate" title=""><?php
function start_session($expire = 0)
{
    if ($expire == 0) {
        $expire = ini_get('session.gc_maxlifetime');
    } else {
        ini_set('session.gc_maxlifetime', $expire);
     }

    if (empty($_COOKIE['PHPSESSID'])) {
        session_set_cookie_params($expire);
        session_start();
    } else {
        session_start();
        setcookie('PHPSESSID', session_id(), time() + $expire);
     }
}
?> </pre>

<!--more--> 那還有另外一種方法可以清除 sess_*，可以設定 php.ini 或者是利用 find 指令搭配 crontab 來刪除，請參考：

[PHP session 暫存檔過多的注意事項][2]，這一篇寫的還蠻清楚的，不過我自己目前作法都是把 session 存放到 DB 裡面，然後利用程式去對資料表的資料做刪除動作，這也方便我統計目前線上人數。 參考： [PHP 設定 session 的過期時間][3]

 [1]: http://www.finalwebsites.com/snippets.php?id=42
 [2]: http://plog.longwin.com.tw/my_note-unix/2008/10/16/php-too-more-session-file-set-2008
 [3]: http://plog.longwin.com.tw/programming/2008/10/08/php-set-session-expire-time-2008