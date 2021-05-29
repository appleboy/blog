---
title: '[MySQL]left, right, inner, outer join 使用方法'
author: appleboy
type: post
date: 2009-01-24T12:09:39+00:00
url: /2009/01/mysqlleft-right-inner-outer-join-使用方法/
views:
  - 34831
bot_views:
  - 2201
dsq_thread_id:
  - 246698393
categories:
  - FreeBSD
  - Linux
  - MySQL
  - sql
tags:
  - MySQL

---
最近在高雄面試的時候，被問到的資料庫問題，什麼是 left join，out join，inner join，其實這些都是寫基本 SQL 語法需要知道的，當然我比較少用到 out join，不過還是要知道一下比較好喔，底下來說明一下這些，整理一些心得

## 表格 test1 資料表

[<img src="https://i2.wp.com/farm4.static.flickr.com/3327/3222461660_4203972953_o.jpg?resize=171%2C92&#038;ssl=1" title="2 (by appleboy46)" alt="2 (by appleboy46)" data-recalc-dims="1" />][1]

## 表格 test2 資料表

[<img src="https://i1.wp.com/farm4.static.flickr.com/3328/3222461636_c25a9bf9e5_o.jpg?resize=126%2C121&#038;ssl=1" title="1 (by appleboy46)" alt="1 (by appleboy46)" data-recalc-dims="1" />][2]

<!--more-->

首先大概是了解 inner 跟 outer 的差別，初學者大概都會使用 inner 這也是我們常常在用的 SQL，inner 就是 join 兩個資料表只顯示匹對的資料，另外一種 outer 就是不管是否有匹對，都會將資料顯示出來，又分為 LEFT, RIGHT, FULL join。

join 總共分為六種 

  1. Inner Join
  2. Natural Join
  3. Left Outer Join
  4. Right Outer Join
  5. Full Outer Join
  6. Cross Join

### Inner Join

```sql
--
-- 這算是最普通的 join 方法
--
SELECT a.*, b.* FROM `test1` as a, `test2` as b where a.id = b.id
```

### Natural Join

```sql
--
-- 利用兩資料表相同欄位，自動連接上
SELECT a.*, b.* FROM `test1` as a NATURAL JOIN `test2` as b
```

### Left, Right join

```sql
--
-- 這兩個其實是相同的，left join 就是顯示左邊表格所有資料，如果匹對沒有的話，就是顯示 NULL
-- right 則是相反
SELECT a.*, b.* FROM `test1` as a LEFT JOIN `test2` as b on a.id = b.id
```

### Full Outer Join

這個可以利用 SQL UNION 處理掉，這只是聯集 Left 跟 Right

### Cross Join

在 MySQL 語法裡面，它相同於 INNER Join，但是在標準 SQL 底下，它們不盡相同 

```sql
SELECT * FROM t1 LEFT JOIN (t2, t3, t4)
                 ON (t2.a=t1.a AND t3.b=t1.b AND t4.c=t1.c)
```

同等於

```sql
SELECT * FROM t1 LEFT JOIN (t2 CROSS JOIN t3 CROSS JOIN t4)
                 ON (t2.a=t1.a AND t3.b=t1.b AND t4.c=t1.c)
```

取一段 MySQL 官網的文字：

> In MySQL, CROSS JOIN is a syntactic equivalent to INNER JOIN (they can replace each other). In standard SQL, they are not equivalent. INNER JOIN is used with an ON clause, CROSS JOIN is used otherwise.

## 參考資料

  * [<http://dev.mysql.com/doc/refman/5.0/en/join.html>][3]
  * [<http://www.oreillynet.com/pub/a/network/2002/04/23/fulljoin.html>][4]
  * [SQL Join語法筆記][5]
  * [<http://www.wellho.net/mouth/158_MySQL-LEFT-JOIN-and-RIGHT-JOIN-INNER-JOIN-and-OUTER-JOIN.html>][6]

 [1]: https://www.flickr.com/photos/appleboy/3222461660/ "2 (by appleboy46)"
 [2]: https://www.flickr.com/photos/appleboy/3222461636/ "1 (by appleboy46)"
 [3]: http://dev.mysql.com/doc/refman/5.0/en/join.html
 [4]: http://www.oreillynet.com/pub/a/network/2002/04/23/fulljoin.html
 [5]: http://www.wretch.cc/blog/sky4s/2250385
 [6]: http://www.wellho.net/mouth/158_MySQL-LEFT-JOIN-and-RIGHT-JOIN-INNER-JOIN-and-OUTER-JOIN.html