---
title: '[MySQL] outer join 使用'
author: appleboy
type: post
date: 2008-01-27T06:56:17+00:00
url: /2008/01/mysql-outer-join-使用/
views:
  - 3712
bot_views:
  - 538
dsq_thread_id:
  - 247227659
categories:
  - sql

---
之前我遇到問題，有兩個表格 a 跟 b，分別利用 id 當作連接，當你使用 where a.id = b.id 的時候，當 b 資料表沒有對應到的時候，撈出來的資料就會少一筆，問題如下 

> : 想請教各位大大， : 如果我現在有兩個table t1,t2 : Table t1: : uid INT : name NCHAR(10) : Table t2: : uid INT : t1\_id INT 參考到t1.uid : 我下一個SQL query: : SELECT t1.name, COUNT(t2.uid) : FROM t1,t2 : WHERE t2.t1\_id=t1.uid : GROUP BY t1.name : 這樣會計算出每個t1.name項目在t2中所出現的次數。 : 但是如果次數為零時就不會顯示出來。 : 想請教大家，怎樣修改可以讓次數為零的t1.name也顯示出來呢? 解決方法：就是利用 outer join 

<pre class="brush: sql; title: ; notranslate" title="">$sql = "SELECT t1.t_name, count(t2.uid) as aa FROM " . $xoopsDB->prefix('teacher') . " as t1 LEFT OUTER JOIN " . $xoopsDB->prefix('student') . " as t2  on t1.tid = t2.st_teacher group by t1.t_name";
</pre> Xoops 寫法