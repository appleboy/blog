---
title: Sysbench 測試 Percona XtraDB Server 效能
author: appleboy
type: post
date: 2014-01-15T11:00:15+00:00
url: /2014/01/sysbench-test-percona-xtradb-server-performance/
dsq_thread_id:
  - 2124987554
categories:
  - InnoDB
  - MySQL
  - Percona XtraDB Cluster
tags:
  - Galera
  - MySQL
  - Percona
  - Percona XtraDB Cluster
  - Sysbench
  - XtraDB

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8171305355/" title="mysql_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8488/8171305355_7fb578fdc9.jpg?w=300&#038;ssl=1" alt="mysql_logo" data-recalc-dims="1" /></a>
</div>

今天拿 [MySQL benchmark tool - Sysbench][1] 來測試看看 [Percona XtraDB Server][2] + [Haproxy][3] 效能如何，實驗主機是執行在 [CentOS][4] 6.4 版本，記憶體 128 G，在 CentOS 本身用 Yum 安裝 Sysbench 時，內建的版本為 0.4.12，單機測試 MySQL 效能不會出現任何錯誤，但是只要是透過 Haproxy，並且有兩台以上的 Server，就會噴出底下錯誤訊息:

> ALERT: failed to execute mysql\_stmt\_execute(): Err1317 Query execution was interrupted
<!--more--> 碰到這問題，在網路上找到一篇 

[sysbench duplicate entries][5]，裡面提到請使用 Sysbench 0.5.0 版本就不會噴出此錯誤，直接看 [sysbench 0.5 for CentOS 6][6] 這篇，裡面有 CentOS 64 打包好的 [rpm package][7]，下載後透過 rpm 指令安裝即可

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ rpm -ivh sysbench-0.5-3.el6_.x86_64.rpm</pre>
</div>

安裝完成，實際底下測試看看

### 建立測試用資料庫

請先建立 `sbtest` 資料庫

<div>
  <pre class="brush: bash; title: ; notranslate" title="">mysql> create database sbtest;</pre>
</div>

### 產生測試用資料

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ sysbench --test=oltp --db-driver=mysql --mysql-engine-trx=yes --mysql-table-engine=innodb --mysql-host=127.0.0.1 --mysql-port=3307 --mysql-user=xxxx --mysql-password=xxxxx --oltp-auto-inc=off --test=/usr/share/doc/sysbench/tests/db/oltp.lua --oltp-table-size=1000000 prepare</pre>
</div>

請注意 `mysql-port` 請務必填寫 Haproxy port，`--oltp-table-size` 用來產生多少筆資料，先產生 100 萬筆資料，大小大概是 270 MB

### 開始測試

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ sysbench --test=oltp --db-driver=mysql --mysql-engine-trx=yes --mysql-table-engine=innodb --mysql-host=127.0.0.1 --mysql-port=3307 --mysql-user=xxxx --mysql-password=xxxxx --oltp-auto-inc=off --test=/usr/share/doc/sysbench/tests/db/oltp.lua --oltp-table-size=100000 --num-threads=100 run</pre>
</div>

差別在於最後執行的步驟 `run`，上一個步驟則是 `prepare`

### 看結果

會跑出底下的數據給您參考

<div>
  <pre class="brush: bash; title: ; notranslate" title="">OLTP test statistics:
    queries performed:
        read:                            172102
        write:                           48943
        other:                           22293
        total:                           243338
    transactions:                        10000  (46.37 per sec.)
    deadlocks:                           2293   (10.63 per sec.)
    read/write requests:                 221045 (1025.00 per sec.)
    other operations:                    22293  (103.37 per sec.)

General statistics:
    total time:                          215.6540s
    total number of events:              10000
    total time taken by event execution: 21427.5778s
    response time:
         min:                                 53.45ms
         avg:                               2142.76ms
         max:                              22097.26ms
         approx.  95 percentile:            5689.02ms

Threads fairness:
    events (avg/stddev):           100.0000/43.42
    execution time (avg/stddev):   214.2758/0.75</pre>
</div>

### 清除測試資料

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ sysbench --test=oltp --db-driver=mysql --mysql-engine-trx=yes --mysql-table-engine=innodb --mysql-host=127.0.0.1 --mysql-port=3307 --mysql-user=xxx --mysql-password=xxx --oltp-auto-inc=off --test=/usr/share/doc/sysbench/tests/db/oltp.lua --oltp-table-size=1000000 cleanup</pre>
</div>

請直接下 `cleanup` 即可

參考資料: [MySQL benchmark tool - sysbench][8]

 [1]: https://launchpad.net/sysbench
 [2]: http://www.percona.com/software/percona-server
 [3]: http://haproxy.1wt.eu/
 [4]: http://www.centos.org/
 [5]: http://www.percona.com/forums/questions-discussions/percona-xtradb-cluster/9405-sysbench-duplicate-entries
 [6]: http://www.lefred.be/node/154
 [7]: http://en.wikipedia.org/wiki/RPM_Package_Manager
 [8]: http://blog.xuite.net/misgarlic/weblogic/56170203-MySQL+benchmark+tool+-+sysbench