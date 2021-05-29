---
title: 優化 Percona XtraDB Cluster for write hotspots
author: appleboy
type: post
date: 2015-06-20T07:31:46+00:00
url: /2015/06/optimizing-percona-xtradb-cluster-for-write-hotspots/
dsq_thread_id:
  - 3863767616
categories:
  - InnoDB
  - MySQL
  - Percona XtraDB Cluster
tags:
  - MySQL
  - Percoba XtraDB Cluster
  - Percona

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12023069753/" title="percona by appleboy46, on Flickr"><img src="https://i1.wp.com/farm4.staticflickr.com/3820/12023069753_de60d0c86d_m.jpg?resize=240%2C234&#038;ssl=1" alt="percona" data-recalc-dims="1" /></a>
</div>

在 [Percona Blog][1] 上看到這篇 [Optimizing Percona XtraDB Cluster for write hotspots][2] 優化多重寫入 MySQL 的狀況，舉例來說，要計算 global counter 的時候，就會遇到很頻繁的寫入 (write hotspot)，目前是不能同時寫入資料到同一個 record，會造成 performance 降低，所以大家開始導入 [Percona XtraDB Cluster][3] 來解決同時間寫入到同一個 record，大家都認為，搞了三台 Percona Server，可以將寫入的動作分散到其他兩台，就不會遇到 Lock 問題，但是實際上根本就不是這樣。

<!--more-->

## 在獨立 Server 同時執行 SQL 語法

簡單舉例，底下有三個 SQL 語法

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># T1
UPDATE t SET ... WHERE id = 100
 
# T2
UPDATE t SET ... WHERE id = 100
 
# T3
UPDATE t SET ... WHERE id = 101</pre>
</div>

我們執行上述語法，會發現產生 row lock 在 T1 或 T2，而 T3 則會同時間執行完畢，因為 T3 不是存取同一筆資料，讓我們假設 InnoDB 先執行 T1，這時候 T2 就要等到 T1 執行完畢，才可以接著執行 T2。

## 同時執行寫入到 multiple nodes (PXC)

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/18789799978" title="Screen Shot 2015-06-20 at 2.48.56 PM by Bo-Yi Wu, on Flickr"><img src="https://i1.wp.com/c1.staticflickr.com/1/255/18789799978_343b15b9b7_z.jpg?resize=640%2C323&#038;ssl=1" alt="Screen Shot 2015-06-20 at 2.48.56 PM" data-recalc-dims="1" /></a>
</div>

看到上述圖，我們先假設 T1 先在 Node 1 執行，T1 會同步執行到 Node 2 和 Node 3，在這同時，T2 在 Node 2 執行就會碰到 certification test fail，這時後，T2 執行失敗，就會執行 roll back，這時候解法就是變成 T2 要 retry。結論就是 PXC 架構多台寫入解決方案不適合的。

## 結論

如果需要大量寫入，正確的解決方式就是將寫入寫到同一台 server，這樣全部的 Lock 都會發生在同一台，但是 PXC 架構跟獨立一台 server 效能上來比，後者還是會比較好。另外的解法就是減少寫入，將計算 counter 這狀況先寫到 redis server，等到一段時間再同步到 MySQL Server。

 [1]: https://www.percona.com/blog
 [2]: https://www.percona.com/blog/2015/06/03/optimizing-percona-xtradb-cluster-write-hotspots/
 [3]: https://www.percona.com/software/percona-xtradb-cluster