---
title: MySQL 5.6 UUID 複製資料到 Slave Server
author: appleboy
type: post
date: 2014-01-23T03:20:08+00:00
url: /2014/01/mysql-5-6-uuid-cloning-slave-server/
dsq_thread_id:
  - 2161299116
categories:
  - MySQL
  - MySQL 5.6
tags:
  - MySQL
  - MySQL 5.6
  - Percona
  - Percona XtraBackup
  - Replication
  - XtraBackup

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8171305355/" title="mysql_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8488/8171305355_7fb578fdc9.jpg?w=300&#038;ssl=1" alt="mysql_logo" data-recalc-dims="1" /></a>
</div>

在 [MySQL Performance Blog][1] 看到這篇 [Beware of MySQL 5.6 server UUID when cloning slaves][2]，裡面提到如果是要複製資料到 Slave 機器，大部分的使用者肯定是將 `/var/lib/mysql` 目錄整個 copy 到 Slave 機器上。如果是 [MySQL 5.6][3] Server 目錄內會有 `auto.cnf` 設定檔，這是 MySQL 5.6 新的功能叫做 [server_uuid][4]，在啟動 MySQL 後，就會自動建立 `auto.cnf` 檔案，此檔案就像是 `my.cnf` 或 `my.ini` 設定檔一樣，只是內容只有支援 `[auto]` 並且只有支援 `server_uuid` 這 key 值，例如

<!--more-->

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[auto]
server_uuid=8a94f357-aab4-11df-86ab-c80aa9429562</pre>
</div>

注意的是此檔案是系統自動建立，請勿自行修改內容。如果將 `/var/lib/mysql` 複製到其他機器，就會出現 server uuid 衝突，所以請務必小心，複製到新的伺服器後，請把 `auto.cnf` 移除，讓系統重新建立新的 uuid，如果是用 [Percona XtraBackup][5] 就不會出現此問題。

 [1]: http://www.mysqlperformanceblog.com/
 [2]: http://www.mysqlperformanceblog.com/2014/01/21/beware-mysql-5-6-server-uuid-cloning-slaves/
 [3]: http://dev.mysql.com/tech-resources/articles/whats-new-in-mysql-5.6.html
 [4]: http://dev.mysql.com/doc/refman/5.6/en/replication-options.html#sysvar_server_uuid
 [5]: http://www.percona.com/software/percona-xtrabackup