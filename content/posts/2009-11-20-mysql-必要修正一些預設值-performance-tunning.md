---
title: '[MySQL] 必要修正一些預設值 (performance tunning)'
author: appleboy
type: post
date: 2009-11-20T04:47:06+00:00
url: /2009/11/mysql-必要修正一些預設值-performance-tunning/
views:
  - 5687
bot_views:
  - 406
dsq_thread_id:
  - 246813052
categories:
  - MySQL
tags:
  - MySQL

---
參考了一篇：『[Fixing Poor MySQL Default Configuration Values][1]』，裡面提到了四個 [MySQL][2] 預設值相當沒有意義，所以 [Jeremy Zawodny][3] 提出了修改，也解釋了為什麼這四個會降低 MySQL 的效能。 1. max\_connect\_errors: 當使用者連接 MySQL 出現錯誤，伺服器就會根據 connect_timeout 所設定時間之後，而放棄等待，放棄之後會有 counter 來紀錄連接失敗的次數，當達到 [max\_connect\_errors][4] 設定值，伺服器就會 locked out client 端，這會衍生一個問題，那就是可以惡搞同一台網站，把 MySQL 搞爛，造成封鎖，不過解決方法就是把 max\_connect\_errors 設定成 (max\_connect\_errors=1844674407370954751) 2. connect\_timeout: 這跟上面 max\_connect\_errors 是有相當大的關係，MySQL 預設 connect\_timeout 是五秒，可是在網路繁忙的時候，也許需要花費比較多的時間來做連接， 但是預設值是五秒的話，這樣會一直 time out，造成 counter 持續增加，屆時會超過 max\_connect\_errors 設定值，所以必須把 connect\_timeout 設定提高到 15 or 20，這樣就可以了 (connect\_timeout = 20) 3. skip-name-resolve: 在每次的 MySQL 連線，伺服器端會偵測 Client 的 DNS 反解，這步驟真的有點多餘 綜合上面結論，請加入 my.cnf 一些設定 

<pre class="brush: bash; title: ; notranslate" title="">max_connect_errors = 1844674407370954751
connect_timeout = 20
skip-name-resolve
slave_net_timeout = 30</pre> Reference: 

[無論如何都應該修改的 MySQL 預設值][5] [線上環境的 MySQL 預設值修改(Jeremy 建議)][6]

 [1]: http://jeremy.zawodny.com/blog/archives/011421.html
 [2]: http://www.mysql.com/
 [3]: http://jeremy.zawodny.com
 [4]: http://dev.mysql.com/doc/refman/5.0/en/server-system-variables.html#sysvar_max_connect_errors
 [5]: http://blog.gslin.org/archives/2009/11/10/2154/
 [6]: http://plog.longwin.com.tw/my_note-unix/2009/11/17/mysql-default-value-modify-by-jeremy-2009