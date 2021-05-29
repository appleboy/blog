---
title: '[SQL] MySQL ROW_NUMBER Simulation'
author: appleboy
type: post
date: 2009-07-15T02:48:34+00:00
url: /2009/07/sql-mysql-row_number-simulation/
views:
  - 12127
bot_views:
  - 804
dsq_thread_id:
  - 246703856
categories:
  - MySQL
  - php
  - sql
tags:
  - MSSQL
  - MySQL
  - php

---
在台大 [PTT Database][1] 版看到有人問一個問題，我覺得還不錯，問題如下：[網頁版][2] 

> 小弟在練習做一個系統遇到以下問題 志願 | 系所 | 功能 1 | a | 退選 2 | b | 退選 3 | c | 退選 4 | d | 退選 5 | e | 退選 網頁介面如上(用for迴圈+mysql\_fetch\_object抓出資料) 報名序號 | 姓名 | 志願1 | 志願2 | 志願3 | 志願4 | 志願5 1001 小王 a b c d e 資料庫欄位內容如上 想請問~若使用者想退選志願3~~照理說用update把志願3欄位清掉 網頁再一次抓資料會變成志願3的系所變空的~(如下表) 志願 | 系所 | 功能 1 | a | 退選 2 | b | 退選 3 | | 退選 4 | d | 退選 5 | e | 退選 有沒有辦法在select的時候排除空的那欄 也就是說抓資料的時候，以上述為例，只抓出4筆，變成下表 志願 | 系所 | 功能 1 | a | 退選 2 | b | 退選 3 | d | 退選 4 | e | 退選<!--more--> 我自己也有提供解法，MySQL 跟 MSSQL 都可以做到，單純 PHP 也是可以解決的，底下提供兩種解法，一種是 PHP，一種是 MySQL 可以解決： 

<pre class="brush: php; title: ; notranslate" title="">select 志願, 系所, 功能 from table where 系所 != '' order by 志願

$i = 1;
while()
{
  /*
  處理程式陣列
  */
  $i++;
}</pre> MySQL 解法： 

<pre class="brush: sql; title: ; notranslate" title="">SET @row = 0;
SELECT @row := @row +1 AS rk, 系所, 功能 from table
where 系所 != '' order by 志願</pre> MSSQL 解法： 

<pre class="brush: sql; title: ; notranslate" title="">SELECT ROW_NUMBER() OVER (ORDER BY NAME) NO, NAME FROM TABLE</pre> 可以參考 MySQL 這篇：

[MySQL Forums :: Transactions :: ROW_NUMBER Simulation][3]

 [1]: http://www.ptt.cc/bbs/Database/index.html
 [2]: http://www.ptt.cc/bbs/Database/M.1247394036.A.A50.html
 [3]: http://forums.mysql.com/read.php?97,162926,162926