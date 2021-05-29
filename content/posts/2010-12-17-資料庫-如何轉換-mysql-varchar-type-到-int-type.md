---
title: '[資料庫] 如何轉換 Mysql varchar type 到 int type'
author: appleboy
type: post
date: 2010-12-17T06:14:23+00:00
url: /2010/12/資料庫-如何轉換-mysql-varchar-type-到-int-type/
views:
  - 943
bot_views:
  - 195
dsq_thread_id:
  - 246862593
categories:
  - MySQL
  - sql
tags:
  - MySQL

---
先來說明為什麼有時候需要用到轉換 varchar 到 int 型態，就是因為 order by 的問題，幫學校修改 Mysql 錯誤排序，前人設計全部都用 varchar 型態去存資料，當然包含了學生入學年度，以前不會遇到這問題，但是到了民國100年，就會發生排序錯誤，底下來講個例子，這樣大家就可以瞭解了。 建立 test 資料表，並且先增兩個欄位分別是 a(<span style="color:red"><strong>varchar</strong></span>) 跟 b(<span style="color:green"><strong>int</strong></span>)，個別輸入 100, 90 兩列資料 

<pre class="brush: bash; title: ; notranslate" title="">mysql> select * from test;
+------+------+
| a    | b    |
+------+------+
| 100  |  100 |
| 90   |   90 |
+------+------+
</pre> 先針對 varchar 排序 order by a DESC 

<pre class="brush: bash; title: ; notranslate" title="">mysql> select * from test order by a desc;
+------+------+
| a    | b    |
+------+------+
| 90   |   90 |
| 100  |  100 |
+------+------+</pre> 再來針對 int 排序 order by b DESC 

<pre class="brush: bash; title: ; notranslate" title="">mysql> select * from test order by b desc;
+------+------+
| a    | b    |
+------+------+
| 100  |  100 |
| 90   |   90 |
+------+------+</pre>

<!--more--> 上面例子很明顯，只有 

<span style="color:green"><strong>int</strong></span> 欄位才是我們真正想的排序，可是 <span style="color:red"><strong>varchar</strong></span> 就會出現錯誤，解決方式很容易，利用 [Cast Functions and Operators][1] 

<pre class="brush: bash; title: ; notranslate" title="">mysql> select * from test ORDER BY CAST(`a` AS DECIMAL(10,2)) DESC;
+------+------+
| a    | b    |
+------+------+
| 100  |  100 |
| 90   |   90 |
+------+------+</pre> 關鍵點就在 

<span style="color:green"><strong>ORDER BY CAST(`a` AS DECIMAL(10,2)) DESC;</strong></span>

 [1]: http://dev.mysql.com/doc/refman/5.0/en/cast-functions.html