---
title: '[SQL] 隨機選取資料 (MSSQL,ACCESS,MYSQL)'
author: appleboy
type: post
date: 2007-08-16T03:15:31+00:00
url: /2007/08/sql-隨機選取資料-mssqlaccessmysql/
views:
  - 5319
bot_views:
  - 768
categories:
  - sql
  - www

---
這個功能還蠻需要的，底下就是三個例子 以下方法，可以幫助隨機取得廣告資料、最新消息等，隨機產生資料。 使用 SQL 語法的 TOP n 來指定取得筆數，再用 ORDER BY 的方式，來亂數取得資料，並排序。 

<pre class="brush: sql; title: ; notranslate" title="">MS SQL：SELECT TOP 1 * FROM Table WHERE 條件 ORDER BY NEWID()

ACCESS：SELECT TOP 1 * FROM Table WHERE 條件 ORDER BY RND(數字欄位名稱)

MYSQL：SELECT * FROM Table ORDER BY RAND() LIMIT 1
</pre>

<http://blog.xuite.net/jameschih/java/8308864>