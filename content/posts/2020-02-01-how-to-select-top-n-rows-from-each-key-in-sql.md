---
title: '[SQL] 如何從單一資料表取得每個 key 前 n 筆資料'
author: appleboy
type: post
date: 2020-02-01T13:38:24+00:00
url: /2020/02/how-to-select-top-n-rows-from-each-key-in-sql/
dsq_thread_id:
  - 7847324464
categories:
  - sql
tags:
  - MySQL
  - Postgres
  - SQLite

---
[![postgres][1]][1]

最近專案需求需要實現單筆資料的版本控制，所以會有一張表 (foo) 專門儲存 key 資料，而有另外一張表 (bar) 專門存 Data 資料，那在 bar 這張表怎麼拿到全部 key 的最新版本資料？底下先看看 schema 範例

<!--more-->

<pre><code class="language-sql">-- foo table
DROP TABLE IF EXISTS "foo";
CREATE TABLE `foo` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `name` TEXT NULL,
  `key` TEXT NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL
);

-- bar table
CREATE TABLE `bar` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
  `foo_id` INTEGER NULL, 
  `is_deleted` INTEGER NULL, 
  `timestamp` INTEGER NULL, 
  `created_at` DATETIME NULL, 
  `data` TEXT NULL, 
  `memo` TEXT NULL
)</code></pre>

其中 `foo` 資料表內的 name + key 是唯一值，所以會是一對多狀態，一把 key 會對應到 `bar` 內的多組資料。而 bar 內的 `timestamp` 則是用來處理版本控制，每一次的修改就會多出一組新的 `timestamp` 資料。底下會來介紹該如何取得每一把 key 的前幾筆 data 資料。

## 使用 UNION 方式

先講資料不多的時候可以透過 **UNION** 方式解決，如下:

<pre><code class="language-sql">select * from bar where foo_id=1 order by timestamp desc limit 3
UNION
select * from bar where foo_id=2 order by timestamp desc limit 3
UNION
select * from bar where foo_id=3 order by timestamp desc limit 3
.
.
.
select * from bar where foo_id=n order by timestamp desc limit 3</code></pre>

這個做法其實還不預期可以解決版本控制的問題，假設同一筆 `foo_id` 的資料在每一個 timestamp 版本筆數不一樣，這樣就會噴錯

| foo_id | timestamp | data    |
| ------ | --------- | ------- |
| 1      | 100       | test_01 |
| 1      | 100       | test_02 |
| 1      | 100       | test_03 |
| 1      | 101       | test_01 |
| 1      | 101       | test_02 |
| 1      | 101       | test_03 |
| 1      | 101       | test_04 |

如果只透過 **limit** 方式根本拿不到 timestamp 為 101 的資料 (因為有四筆，透過 limit 只能拿到 3 筆)。所以這個解法完全不適合。

## 使用 rank() 方式

[rank()][2] 方式可以在 [MySQL][3], [SQLite][4] 或 [Postgres][5] 都支援，由於目前我開發模式都是本機使用 SQLite，Production 環境則用 [Postgres][5]，所以在寫 SQL 同時都會兼顧是否三者都能並行 (執行開源專案養成的 XD)，這時候來實驗看看用 rank 來標記 timestamp:

<pre><code class="language-sql">SELECT bar.*, 
  rank() OVER (PARTITION BY foo_id ORDER BY "timestamp" DESC) as rank
  FROM bar</code></pre>

就會拿到底下資料

| foo_id | timestamp | data    | rank |
| ------ | --------- | ------- | ---- |
| 1      | 101       | test_01 | 1    |
| 1      | 101       | test_02 | 1    |
| 1      | 101       | test_03 | 1    |
| 1      | 101       | test_04 | 1    |
| 1      | 100       | test_01 | 2    |
| 1      | 100       | test_02 | 2    |
| 1      | 100       | test_03 | 2    |

這時候我們要拿 foo_id 為 1 時的資料，就可以透過 `rank = 1` 方式解決 limit 的問題。接下來需要處理如何拿每一個 foo_id 的最新版本 (timestamp) 資料。假設資料如下:

| foo_id | timestamp | data        |
| ------ | --------- | ----------- |
| 1      | 100       | 1\_test\_01 |
| 1      | 101       | 1\_test\_01 |
| 1      | 101       | 1\_test\_02 |
| 2      | 100       | 2\_test\_01 |
| 2      | 101       | 2\_test\_02 |
| 2      | 102       | 2\_test\_03 |
| 3      | 100       | 3\_test\_01 |
| 3      | 103       | 3\_test\_02 |
| 3      | 104       | 3\_test\_03 |
| 3      | 105       | 3\_test\_04 |

我們需要拿到最新的版本

  * foo_id 為 1 時的 101 版本
  * foo_id 為 2 時的 102 版本
  * foo_id 為 3 時的 105 版本

<pre><code class="language-sql">select bar.* from 
(SELECT bar.*, 
  rank() OVER (PARTITION BY foo_id ORDER BY "timestamp" DESC) as rank
  FROM bar) bar
  where rank = 1</code></pre>

資料如下:

| foo_id | timestamp | data        | rank |
| ------ | --------- | ----------- | ---- |
| 1      | 101       | 1\_test\_01 | 1    |
| 1      | 101       | 1\_test\_02 | 1    |
| 2      | 102       | 2\_test\_03 | 1    |
| 3      | 105       | 3\_test\_04 | 1    |

透過 `rank = 1` 就可以拿到每一筆 foo 的最新版本。接著假設我們想拿到 timestamp 為 102 的版本該如何處理，這時候我們就需要找尋每一筆 foo 的版本為最接近 102。

  * foo_id 為 1 時的 101 版本
  * foo_id 為 2 時的 102 版本
  * foo_id 為 3 時的 100 版本 (100 最今近 102)

<pre><code class="language-sql">select bar.* from 
(SELECT bar.*, 
  rank() OVER (PARTITION BY foo_id ORDER BY "timestamp" DESC) as rank
  FROM bar where "timestamp" &lt;= 102) bar
  where rank = 1</code></pre>

資料如下:

| foo_id | timestamp | data        | rank |
| ------ | --------- | ----------- | ---- |
| 1      | 101       | 1\_test\_01 | 1    |
| 1      | 101       | 1\_test\_02 | 1    |
| 2      | 102       | 2\_test\_03 | 1    |
| 3      | 100       | 3\_test\_01 | 1    |

以上就是透過 rank() 來解決資料版本控制問題。如果大家有更好的解法或建議，歡迎在底下留言。

 [1]: https://lh3.googleusercontent.com/TPxdqjL5VJkLQ0FQASqErBaBMi8w6uyPZLGEQ-s6ZX9_6-JMF21n5uD6CZyc_kJ31ZTBlyevmKsjYrIZK0Ts61eqd93wqsmx66uvSVhGn4JKAWb6i_1_ClO_j4G8NQ-pR31QRrqtgu4=w1920-h1080 "postgres"
 [2]: https://www.mysqltutorial.org/mysql-window-functions/mysql-rank-function/
 [3]: https://www.mysql.com/
 [4]: https://www.sqlite.org
 [5]: https://www.postgresql.org/