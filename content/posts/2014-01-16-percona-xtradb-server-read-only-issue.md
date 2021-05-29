---
title: Percona XtraDB Server 出現 read only issue
author: appleboy
type: post
date: 2014-01-16T08:25:42+00:00
url: /2014/01/percona-xtradb-server-read-only-issue/
dsq_thread_id:
  - 2128902132
categories:
  - InnoDB
  - MySQL
  - Percona XtraDB Cluster
tags:
  - MySQL
  - Percona
  - Percona XtraDB Cluster
  - XtraDB

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8171305355/" title="mysql_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8488/8171305355_7fb578fdc9.jpg?w=300&#038;ssl=1" alt="mysql_logo" data-recalc-dims="1" /></a>
</div>

最近在整理 [Percona XtraDB Server][1] 將 Read Write 全部拆開，寫入部份只開一台 Node，讀取機器 Replica 則是越多越好，當然如果預計 write 都不會有任何 conflict 的話，那就不用拆開，read write 都可以在同一台即可，拆開的目的要解決 `Innodb transaction locking` 問題。今天遇到的是將機器讀寫都放在同一台，然後同時多台 Master 架構，結果跑在 [CodeIgniter][2] 上面出現底下錯誤訊息

> The MySQL server is running with the --read-only option so it cannot execute this statement
<!--more--> 出現這問題的時候，第一時間去看一下 

[Percona][3] cluster mysql 版本，發現不是踩到 [read-only blocks SELECT statements in PXC][4] 雷，這雷在 [Percona XtraDB Cluster 5.5.33-23.7.6][5] 被解掉了

> Server version: 5.5.34-55-log Percona XtraDB Cluster (GPL), wsrep_25.9.r3928
後來查到原因是 [MySQ][6]L User 權限不足，請將 `SUPER Privilege` 權限開啟。這樣 MySQL 使用者就可以忽略 `read_only = on` 參數，執行 SQL Command。

<div>
  <pre class="brush: sql; title: ; notranslate" title="">GRANT SUPER ON *.* TO 'ustv'@'%'</pre>
</div>

 [1]: http://www.percona.com/software/percona-server
 [2]: http://www.codeigniter.org.tw/
 [3]: http://www.percona.com/
 [4]: https://bugs.launchpad.net/percona-xtradb-cluster/+bug/1091099
 [5]: http://www.mysqlperformanceblog.com/2013/09/18/percona-xtradb-cluster-5-5-33-23-7-6-now-available/
 [6]: http://www.mysql.com/