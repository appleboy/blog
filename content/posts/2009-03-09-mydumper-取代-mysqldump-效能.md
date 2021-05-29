---
title: mydumper 取代 mysqldump 效能
author: appleboy
type: post
date: 2009-03-09T02:36:08+00:00
url: /2009/03/mydumper-取代-mysqldump-效能/
views:
  - 9881
bot_views:
  - 529
dsq_thread_id:
  - 246847998
categories:
  - blog
  - FreeBSD
  - Linux
  - MySQL
  - sql
tags:
  - FreeBSD
  - Linux
  - MySQL

---
這是我在 [gslin 大神][1] 那邊看到的一篇文章：[mydumper (取代 mysqldump 的工具)][2]，[mysqldumper][3] 有平行跟效能方面壓力測試，效果跟時間都壓縮的比 [mysqldump][4] 還要快，簡單管理 output 資料，它把 database 每個資料表分別 dump 資料出來寫到檔案，方便觀看檔案資料，不過沒有支援 dump table 的 definitions，所以加速提取 data 寫入到檔案，gslin 大神也把它包進 [FreeBSD][5] [ports][6] 裡面，在 [database/mydumper][7] 這裡。 我想會把這個機制套用到我之前寫的 shell script 裡面：[[Linux&FreeBSD] 備份系統資料，MySQL 資料庫，PgSQL 資料庫的自動化 bash shell script 程式][8]，那 mydumper 用法也相當簡單，mydumper --help 就寫的很清楚了，跟 mysqldump 用法差沒多少： 

<pre class="brush: bash; title: ; notranslate" title="">-h, --host               連接到 hostname 伺服器
-u, --user               使用者名稱
-p, --password           使用者密碼
-P, --port               MySQL TCP/IP port 
-B, --database           Database 名稱
-t, --threads            Number of parallel threads
-o, --outputdir          輸出的檔案要存放在哪, 預設 ./export-*/
-c, --compress           gzip 壓縮每個檔案，多花一點時間
-x, --regex              Regular expression for 'db.table' matching</pre>

<!--more--> 如果要 dump 全部的資料庫： 

<pre class="brush: bash; title: ; notranslate" title="">mydumper -u [user] -p [password]</pre> 經過 gzip 壓縮 

<pre class="brush: bash; title: ; notranslate" title="">mydumper -u [user] -p [password] -c</pre> dump 單一資料庫 

<pre class="brush: bash; title: ; notranslate" title="">mydumper -u [user] -p [password] -c -B database</pre> dump 多重備份 mysql 跟 test 資料庫 

<pre class="brush: bash; title: ; notranslate" title="">mydumper -u [user] -p [password] -c --regex '^(?!(mysql|test))'</pre> 參考文章： 

[mydumper (取代 mysqldump 的工具)][2] 作者網站：[mydumper][3]

 [1]: http://blog.gslin.org
 [2]: http://blog.gslin.org/archives/2009/03/04/1956/
 [3]: http://dammit.lt/2009/02/03/mydumper/
 [4]: http://dev.mysql.com/doc/refman/5.1/en/mysqldump.html
 [5]: http://www.freebsd.org
 [6]: http://www.freebsd.org/ports/
 [7]: http://www.freshports.org/databases/mydumper/
 [8]: http://blog.wu-boy.com/2008/05/23/268/