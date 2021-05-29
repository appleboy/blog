---
title: MySQL 用 MySQLDump 備份 InnoDB 注意事項
author: appleboy
type: post
date: 2013-04-05T02:20:22+00:00
url: /2013/04/best-mysqldump-innodb-data/
dsq_thread_id:
  - 1187592118
categories:
  - InnoDB
  - MyISAM
  - MySQL
tags:
  - InnoDB
  - MyISAM
  - MySQL
  - Percona
  - XtraBackup

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8171305355/" title="mysql_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8488/8171305355_7fb578fdc9.jpg?w=300&#038;ssl=1" alt="mysql_logo" data-recalc-dims="1" /></a>
</div> 大家在備份 

<a href="http://www.mysql.com/" target="_blank">MySQL</a> 資料庫時一定是使 mysqldump 指令，不管是 MyISAM 或 <a href="http://dev.mysql.com/doc/refman/5.5/en/innodb-storage-engine.html" target="_blank">InnoDB</a> 都一樣， 在處理 InnoDB 格式備份時使用 **<span style="color:green">mysqldump -single-transaction</span>**，但是你會發現在大多的備份狀況都是 OK 的，只是有時候會發現有的資料表只有備份到 structure 而無備份到 Data？ 在 <a href="http://www.mysqlperformanceblog.com" target="_blank">MySQL Performance Blog</a> 看到這篇講解 <a href="http://www.mysqlperformanceblog.com/2012/03/23/best-kept-mysqldump-secret/" target="_blank">Best kept MySQLDump Secret</a>，此問題出在 how MySQL’s Transactions work with DDL，ALTER TABLE 會建立一個 temporary table，並且將該資料表資料複製過去，接著刪除原有資料表，最後將 temporary table 命名為原來資料表。 底下是原作者提到的原因 

> How does data visibility works in this case ? DDLs are not transactional and as such the running transaction will not see the contents of old table once it is dropped, transaction also will see the new table which was created after transaction was started, including table created by ALTER TABLE statement. Transactions however apply to DATA which is stored in this table and so data which was inserted after start of transaction (by ALTER TABLE statement) will not be visible. In the end we will get new structure in the dump but no data. 最好的解法就是改用 **<span style="color:green">mysqldump -lock-all-tables</span>**，但是備份的時候，資料庫是無法寫入，僅能讀取，也或者可以透過 <a href="http://blog.wu-boy.com/2013/01/percona-xtrabackup-innodb/" target="_blank">Percona Xtrabackup</a> 工具來備份 InnoDB。