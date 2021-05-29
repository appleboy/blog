---
title: Percona XtraDB Cluster 5.6 找合適 IST Donor
author: appleboy
type: post
date: 2014-02-09T12:55:55+00:00
url: /2014/02/percona-xtradb-cluster-5-6-ist-and-sst/
dsq_thread_id:
  - 2241985028
categories:
  - MySQL
  - MySQL 5.6
  - Percona XtraDB Cluster
tags:
  - Gcache
  - IST donor
  - MySQL
  - Percona XtraDB Cluster 5.6
  - Perocna XtraDB Cluster

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12023069753/" title="percona by appleboy46, on Flickr"><img src="https://i1.wp.com/farm4.staticflickr.com/3820/12023069753_de60d0c86d_m.jpg?resize=240%2C234&#038;ssl=1" alt="percona" data-recalc-dims="1" /></a>
</div>

Gcache 是用來紀錄 [MySQL][1] 最近所使用的 SQL Command，其本身是佔用記憶體空間，大小可以由 `wsrep_provider_options` 定義，如果有任何 MySQL Node 重新啟動，那麼可以經由 Live Node 內的 Gcache 將尚未同步的資料補上，同步資料的方式分為兩種一種為 IST(Incremental State Transfer) 另一種為 SST(State Snapshot Transfer)，但是同步資料時，管理者無法決定同步方式。先來看看 Gcache 一些特性

  * node 重新啟動，Gcache 資料會全部消失
  * Gcache 大小為固定，如果超過大小，則回刪除最早資料
  * 選擇 Donor node 會直接忽略 Gcache 狀態
  * Node 重新啟動，需要同步的資料並非在指定 Node Gcahe 內，則會啟動 SST 同步
  * 到目前版本為止，沒有任何方式可以知道 Gcache 狀態

根據以上特性可以知道，當 Node 重新啟動，很容易就執行 SST 模式，舉例子來說，當有 Node crashed 超過一個晚上，你要如何知道其他 Node 內的 Gcache 資料大於需要同步的資料量？或者是當 Cluster 內只有兩台機器，那重新啟動任何一台 Node 都會是跑 SST 同步。

<!--more-->

### PXC 5.6.15 RC1

去年 [Percona XtraDB Cluster][2] 推出 [PXC 5.6.15][3] 版本，此版本可以知道 Gcache 狀態，透過 [wsrep\_local\_cached_downto][4] 變數可以知道目前 Gcache 狀態，現在管理者就可以透過此參數來決定特定的 Node 進行 IST 同步，而不是 SST 同步。底下透過三台機器做實驗，並依照下面步驟。

  1. 停用 Node 2
  2. 停用 Node 3
  3. 啟用 Node 2

看到第3步驟，我們可以知道因為重新啟動的速度很快，所以 Node 2 肯定透過 IST 同步資料，最後從新啟動 Node 3 之前，我們可以透過 mysql 指令來看 `wsrep_local_cached_downto` 資料

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[root@node1 ~]# mysql -e "show global status like 'wsrep_local_cached_downto';"
+---------------------------+--------+
| Variable_name             | Value  |
+---------------------------+--------+
| wsrep_local_cached_downto | 889703 |
+---------------------------+--------+
[root@node2 mysql]# mysql -e "show global status like 'wsrep_local_cached_downto';"
+---------------------------+---------+
| Variable_name             | Value   |
+---------------------------+---------+
| wsrep_local_cached_downto | 1050151 |
+---------------------------+---------+</pre>
</div>

可以看到 Node 2 的值大於 Node 1，這代表 Node 2 有些資料尚未跟 Node 1 同步上，此時看看 Node 3 資料，也可以透過 `/var/lib/mysql/grastate.dat` 檔案來知道

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[root@node3 ~]# cat /var/lib/mysql/grastate.dat
# GALERA saved state
version: 2.1
uuid:    7206c8e4-7705-11e3-b175-922feecc92a0
seqno:   1039191
cert_index:</pre>
</div>

這時候會發現，node 3 資料比 node 2 資料還新，node 3 重新啟動後，如果是跟 node 2 同步的話，那就是會走 SST 機制，如果是跟 Node 1 則是走 IST 機制，當然走 IST 才是我們想要的結果，但是在 PXC 5.6.15 版本之前並非有參數可以讓系統管理者決定。所以這時候可以透過指定方式來跟 Node 1 同步

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ service mysql start --wsrep_sst_donor=node1</pre>
</div>

目前至少可以透過 `wsrep_local_cached_downto` 來知道 Gcache 狀態。本篇數據來自於 [Finding a good IST donor in Percona XtraDB Cluster 5.6][5]

 [1]: http://www.mysql.com/
 [2]: http://www.percona.com/software/percona-xtradb-cluster
 [3]: http://www.mysqlperformanceblog.com/2013/12/18/percona-xtradb-cluster-5-6-15-25-2-first-release-candidate-is-now-available/
 [4]: http://www.percona.com/doc/percona-xtradb-cluster/5.6/wsrep-status-index.html#wsrep_local_cached_downto
 [5]: http://www.mysqlperformanceblog.com/2014/01/08/finding-good-ist-donor-percona-xtradb-cluster-5-6/