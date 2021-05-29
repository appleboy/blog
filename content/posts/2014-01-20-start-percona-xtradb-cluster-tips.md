---
title: 啟動 Percona XtraDB Cluster 注意事項
author: appleboy
type: post
date: 2014-01-20T06:50:45+00:00
url: /2014/01/start-percona-xtradb-cluster-tips/
dsq_thread_id:
  - 2147405989
categories:
  - MySQL
  - Percona XtraDB Cluster
tags:
  - MySQL
  - Percona XtraDB Cluster
  - XtraDB Cluster

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12023069753/" title="percona by appleboy46, on Flickr"><img src="https://i1.wp.com/farm4.staticflickr.com/3820/12023069753_de60d0c86d_m.jpg?resize=240%2C234&#038;ssl=1" alt="percona" data-recalc-dims="1" /></a>
</div>

在 [Percona XtraDB Cluster][1] 推出 [5.5.28][2] 以前，最簡單的啟動方式就是打開 `my.cnf` 設定 `wsrep_urls` 在 `[mysqld_safe]` section 內。假設我們有三台 Node 分別為底下 IP:

  * node1 = 192.168.1.100
  * node2 = 192.168.1.101
  * node3 = 192.168.1.102

<!--more-->

以前的設定方式為

<div>
  <pre class="brush: bash; title: ; notranslate" title="">wsrep_urls=gcomm://192.168.1.100:4567,gcomm://192.168.1.101:4567,gcomm://192.168.1.102:4567</pre>
</div>

當啟動 MySQL 時，Percona 會先去偵測 Cluster 內的 192.168.1.100 是否存在，如果不存在就在往下找，最後偵測 192.168.1.102 也不存在時，這時候 MySQL 就是啟動失敗，為了避免這情形，也就是全部的 Node Crash 狀況下，還是可以將 Cluster 啟動，可以改成底下設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">wsrep_urls=gcomm://192.168.1.100:4567,gcomm://192.168.1.101:4567,gcomm://192.168.1.102:4567,gcomm://</pre>
</div>

這在網路上很常看到此設定，如果全部的 Node 都不存在，表示此 Cluster 也就不存在，這時候我們就重新啟動 Cluster。但是 `wsrep_urls` 在 [5.5.28][2] 版本已經被列為 deprecated，所以請改用 `wsrep_cluster_address` 參數

<div>
  <pre class="brush: bash; title: ; notranslate" title="">wsrep_cluster_address=gcomm://192.168.1.100,192.168.1.101,192.168.1.102</pre>
</div>

大家看到此設定可以知道，不用在重複宣告 `4567` port 以及 `gcomm://`，但是這時候也會遇到如果全部的 Node 都關閉了，這樣 Cluster 也就消失了，有兩種方式可以啟動 Cluster。

  * 使用任何一個 Node 將 `wsrep_cluster_address` 改成 `gcomm://`，但是這樣很麻煩，等其他 Node 啟動後，還是要在改回來
  * 使用底下的 command 來啟動

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/myslqd start --wsrep-cluster-address="gcomm://"</pre>
</div>

此方式不用修改 `my.cnf` 設定，其他 Node 啟動成功後，再將此 Node 重新啟動即可。

Reference: [How to start a Percona XtraDB Cluster][3]

 [1]: http://www.percona.com/software/percona-xtradb-cluster
 [2]: http://www.percona.com/doc/percona-xtradb-cluster/5.5/release-notes/Percona-XtraDB-Cluster-5.5.28.html
 [3]: http://www.mysqlperformanceblog.com/2013/01/29/how-to-start-a-percona-xtradb-cluster/