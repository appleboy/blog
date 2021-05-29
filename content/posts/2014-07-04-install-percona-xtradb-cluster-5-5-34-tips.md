---
title: 在 Debian 安裝 Percona Xtradb Cluster 5.5.34 注意事項
author: appleboy
type: post
date: 2014-07-04T02:29:40+00:00
url: /2014/07/install-percona-xtradb-cluster-5-5-34-tips/
dsq_thread_id:
  - 2816301250
categories:
  - MySQL
  - Percona XtraDB Cluster
tags:
  - Debian
  - MySQL
  - Percoba XtraDB Cluster
  - Percona
  - Percona MySQL

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12023069753/" title="percona by appleboy46, on Flickr"><img src="https://i1.wp.com/farm4.staticflickr.com/3820/12023069753_de60d0c86d_m.jpg?resize=240%2C234&#038;ssl=1" alt="percona" data-recalc-dims="1" /></a>
</div>

最近幫公司安裝新的三台機器，全部上 [Debian][1] 7.5 Server 版本，統一安裝 [Percona Xtradb Cluster][2] 最新版本 5.5.37。設定完第一台 Node，並且透過底下指令 boot up 成第一台 PXC。

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/mysql bootstrap-pxc</pre>
</div>

後續第二台要啟動跟第一台進行 SST，寫到一半直接噴底下錯誤訊息

> WSREP\_SST: [ERROR] Cleanup after exit with status:32 (20140702 10:57:28.004) WSREP\_SST: [INFO] Removing the sst\_in\_progress file (20140702 10:57:28.006) 140702 10:57:28 [ERROR] WSREP: Process completed with error: wsrep\_sst\_xtrabackup --role 'joiner' --address '192.168.1.101' --auth 'xxxxx:xxxxxx' --datadir '/var/lib/mysql/' --defaults-file '/etc/mysql/my.cnf' --parent '16042': 32 (Broken pipe) 140702 10:57:28 [ERROR] WSREP: Failed to read uuid:seqno from joiner script. 140702 10:57:28 [ERROR] WSREP: SST failed: 32 (Broken pipe)<!--more-->

在 [MySQL Performance Blog][3] 找到一篇 [5.5.34 Release Note][4]，裡面提到在 [5.5.34 版本][5]以後，請使用 `xtrabackup-v2` 這是之前的 `xtrabackup` 重新命名過來的。如果重新啟動，還是持續出現此問題的話，請將系統的 MySQL Data 目錄清空，重新跑 SST 拉資料。

$ rm -rf /var/lib/mysql/* $ /etc/init.d/mysql restart

基本上這樣就可以了，另外 MySQL 裝好時，預設都沒有開啟任何 Log 紀錄，請務必將 Log 打開，不然怎麼 Debug，底下附上 Debian 的 `my.cnf` 設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">
innodb_log_file_size = 64M
server-id               = 2
log_bin                 = /var/log/mysql/mysql-bin.log
log_error                      = /var/log/mysql/mysql-error.log
log_queries_not_using_indexes  = 1
slow_query_log                 = 1
slow_query_log_file            = /var/log/mysql/mysql-slow.log
long_query_time                = 1
default_storage_engine=InnoDB
binlog_format=ROW
log_slave_updates</pre>
</div>

另外 `/etc/mysql/conf.d/wsrep.cnf`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[MYSQLD]
wsrep_provider=/usr/lib/galera2/libgalera_smm.so
wsrep_cluster_address=gcomm://192.168.1.100,192.168.1.102
wsrep_sst_auth=xxxxx:xxxxx
wsrep_provider_options="gcache.size=2G"
wsrep_cluster_name=Percona
wsrep_sst_method=xtrabackup-v2
wsrep_node_name=db_02
wsrep_slave_threads=4
log_slave_updates
innodb_locks_unsafe_for_binlog=1
innodb_autoinc_lock_mode=2</pre>
</div>

注意 `wsrep_sst_method` 務必使用 `xtrabackup-v2`，如果是 CentOS 系統無此 xtrabackup-v2 指令時，請透過 `ln` 指令 Link 過去即可。結論就是沒事別亂升級系統，另外第二台要啟動進行 SST 時，可以打開看 `innobackupex.backup.log` 內是否有錯誤訊息，後續 Node 無法啟動的原因也會紀錄在此。

 [1]: https://www.debian.org/
 [2]: http://www.percona.com/software/percona-xtradb-cluster
 [3]: http://www.mysqlperformanceblog.com
 [4]: http://www.mysqlperformanceblog.com/2013/12/03/percona-xtradb-cluster-5-5-34-25-9-now-available/
 [5]: http://www.percona.com/doc/percona-xtradb-cluster/5.5/errata.html