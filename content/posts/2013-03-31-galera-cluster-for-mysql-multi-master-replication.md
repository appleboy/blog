---
title: Galera Cluster for MySQL Multi-master Replication
author: appleboy
type: post
date: 2013-03-31T04:48:55+00:00
url: /2013/03/galera-cluster-for-mysql-multi-master-replication/
categories:
  - Debian
  - InnoDB
  - Linux
  - MyISAM
  - MySQL
  - Ubuntu
tags:
  - Galera
  - HAProxy
  - InnoDB
  - Mariadb
  - MySQL
  - Percona

---
<div style="margin: 0 auto; text-align: center;">
  <a title="galera_mysql_replication by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/8603447002/"><img alt="galera_mysql_replication" src="https://i0.wp.com/farm9.staticflickr.com/8383/8603447002_050ecd1b53.jpg?resize=500%2C247&#038;ssl=1" data-recalc-dims="1" /></a>
</div> 最近公司買了幾台機架伺服器來處理 HTTP 跟 DB Load balancer，要做到 DB 的分散式架構，首先需要同步多台機器資料，也就是寫入或更動任意一台單筆資料，另外平行的機器也會同時進行更新。同步的好處可以用來做備援及分散處理連線，而要做到此功能，可子參考網路上評價不錯的 

<a href="http://www.codership.com/content/using-galera-cluster" target="_blank">Galera Cluster for MySQL</a> 方案。本篇會介紹在 <a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 或 <a href="http://www.centos.org/" target="_blank">CentOS</a> 6.x final 版本如何安裝 Galera 伺服器套件及設定。要架設 Galera Cluster Server，有兩種套件選擇，一個是 <a href="http://www.percona.com/software/percona-xtradb-cluster" target="_blank">Percona XtraDB Cluster</a> 另一個是 <a href="https://downloads.mariadb.org/mariadb-galera/" target="_blank">MariaDB Galera Cluster</a>，這次作者會介紹後者的安裝。 

### Galera Cluster 介紹 為什麼要選擇 Galera Cluster Server，它有什麼優點及功能呢？MySQL/Galera 是一套可以同步多台 MySQL/InnoDB 機器的叢集系統，底下可以列出功能。 

  * 同步複製資料
  * 可讀取和寫入叢集系統內任一節點
  * 自動偵測節點錯誤，如果有節點當機，則叢集系統自動移除該節點
  * 可任意擴充節點
  * 採用 row level 方式來平行複製資料 從上面功能看來，我們可以平行任意擴充節點，動態增加伺服器到叢集系統，要做到上面功能，就是利用 

<a href="http://www.codership.com/products/galera_replication" target="_blank">Galera library</a> 來做到同步資料處理，同步的詳細細節，可以參考 Galera library 連結。這邊就不再多描述了。 <!--more-->

### 安裝 Galera Cluster Server 本篇介紹的 MySQL Server 是使用 

<a href="https://mariadb.org/" target="_blank">MariaDB</a> 套件，而不是安裝原始的 MySQL。CentOS 和 Ubuntu 安裝方式雷同，前者是用 yum 後者則是 aptitude，在安裝前請先下載對應的 <a href="https://downloads.mariadb.org/mariadb/repositories/" target="_blank">repository 設定檔</a>。 CentOS 

<pre class="brush: bash; title: ; notranslate" title="">$ yum -y update && yum -y upgrade
$ yum -y install MariaDB-Galera-server MariaDB-client galera</pre> Ubuntu 

<pre class="brush: bash; title: ; notranslate" title="">$ aptitude -y update
$ aptitude -y install mariadb-galera-server-5.5 galera</pre> 啟動 MySQL 

<pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/mysql start</pre>

### 設定 Galera Cluster Server 先講一下環境，目前總共兩台 Galera Server，IP 分別是: Node\_1: 192.168.1.100 Node\_2: 192.168.1.101 建立 Node\_1, Node\_2 MySQL User，用來認證使用，先進入 MySQL Console. 

<pre class="brush: bash; title: ; notranslate" title="">$ mysql -u root -p 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 154
Server version: 10.0.1-MariaDB-mariadb1~precise-log mariadb.org binary distribution

Copyright (c) 2000, 2012, Oracle, Monty Program Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>

</pre> 建立 cluster 使用者，密碼為 1234，針對 % 跟 localhost 同時建立。 

<pre class="brush: bash; title: ; notranslate" title="">MariaDB [(none)]> GRANT USAGE ON *.* to cluster@'%' IDENTIFIED BY '1234';
MariaDB [(none)]> GRANT ALL PRIVILEGES on *.* to cluster@'%';
MariaDB [(none)]> GRANT USAGE ON *.* to cluster@'localhost' IDENTIFIED BY '1234';
MariaDB [(none)]> GRANT ALL PRIVILEGES on *.* to cluster@'localhost';</pre> 在 192.168.1.100 建立 Galera 設定檔 

**<span style="color:green">/etc/mysq/conf.d/wsrep.cnf</span>** 

<pre class="brush: bash; title: ; notranslate" title="">[MYSQLD]                                                                                                              
wsrep_provider=/usr/lib64/galera/libgalera_smm.so                                                                     
wsrep_cluster_address="gcomm://"                                               
wsrep_sst_auth=cluster:1234</pre> 重新啟動 mysqld 會看到多 listen 4567 port 

<pre class="brush: bash; title: ; notranslate" title="">tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      1118/mysqld
tcp        0      0 0.0.0.0:4567            0.0.0.0:*               LISTEN      1118/mysqld</pre> 在 192.168.1.101 建立 Galera 設定檔 

**<span style="color:green">/etc/mysq/conf.d/wsrep.cnf</span>** 並且將 cluster address 設定為 192.168.1.100 

<pre class="brush: bash; title: ; notranslate" title="">[MYSQLD]                                                                                                              
wsrep_provider=/usr/lib64/galera/libgalera_smm.so                                                                     
wsrep_cluster_address="gcomm://192.168.1.100:4567"                                               
wsrep_sst_auth=cluster:1234</pre> 設定完成後，重新啟動 mysql 

<pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/mysql restart</pre> 要怎麼驗證設定成功呢？可以透過 mysql console 來確認 

<pre class="brush: bash; title: ; notranslate" title="">$ mysql -e "SHOW STATUS LIKE 'wsrep%';"</pre> 可以看到結果如下 

<pre class="brush: bash; title: ; notranslate" title="">+----------------------------+--------------------------------------------------------------+
| wsrep_local_state_uuid     | b4e876e0-8c1e-11e2-0800-8da732edfe2a                         |
| wsrep_protocol_version     | 4                                                            |
| wsrep_last_committed       | 516                                                          |
| wsrep_replicated           | 0                                                            |
| wsrep_replicated_bytes     | 0                                                            |
| wsrep_received             | 3                                                            |
| wsrep_received_bytes       | 282                                                          |
| wsrep_local_commits        | 0                                                            |
| wsrep_local_cert_failures  | 0                                                            |
| wsrep_local_bf_aborts      | 0                                                            |
| wsrep_local_replays        | 0                                                            |
| wsrep_local_send_queue     | 0                                                            |
| wsrep_local_send_queue_avg | 0.000000                                                     |
| wsrep_local_recv_queue     | 0                                                            |
| wsrep_local_recv_queue_avg | 0.000000                                                     |
| wsrep_flow_control_paused  | 0.000000                                                     |
| wsrep_flow_control_sent    | 0                                                            |
| wsrep_flow_control_recv    | 0                                                            |
| wsrep_cert_deps_distance   | 0.000000                                                     |
| wsrep_apply_oooe           | 0.000000                                                     |
| wsrep_apply_oool           | 0.000000                                                     |
| wsrep_apply_window         | 0.000000                                                     |
| wsrep_commit_oooe          | 0.000000                                                     |
| wsrep_commit_oool          | 0.000000                                                     |
| wsrep_commit_window        | 0.000000                                                     |
| wsrep_local_state          | 4                                                            |
| wsrep_local_state_comment  | Synced                                                       |
| wsrep_cert_index_size      | 0                                                            |
| wsrep_causal_reads         | 0                                                            |
| wsrep_incoming_addresses   | xxx.xxx.xxx.xxx:3306,xxx.xxx.xx.xxx:3306,xxx.xxx.xxx.xx:3306 |
| wsrep_cluster_conf_id      | 45                                                           |
| wsrep_cluster_size         | 3                                                            |
| wsrep_cluster_state_uuid   | b4e876e0-8c1e-11e2-0800-8da732edfe2a                         |
| wsrep_cluster_status       | Primary                                                      |
| wsrep_connected            | ON                                                           |
| wsrep_local_index          | 0                                                            |
| wsrep_provider_name        | Galera                                                       |
| wsrep_provider_vendor      | Codership Oy &lt;info@codership.com>                            |
| wsrep_provider_version     | 23.2.4(r147)                                                 |
| wsrep_ready                | ON                                                           |
+----------------------------+--------------------------------------------------------------+
</pre> 看到上述結果，有一個非常重要的數值，那就是 

**<span style="color:green">wsrep_ready</span>**，正確值是 ON，另外看看 **<span style="color:green">wsrep_cluster_size</span>** 是否跟您設置 Node 的數量相同，這兩個如果都正確，那就表示設定成功了，由於上面 192.168.1.100 是主 Cluster Server，現在我們必須互相設定雙方 Address 也就是設定如下 

<pre class="brush: bash; title: ; notranslate" title="">node 01: gcomm://192.168.1.101
node 02: gcomm://192.168.1.100</pre> 設定如上述的好處就是，當 Node 01 關機時，資料還是在 Node 2 繼續運作，等到 Node 01 恢復上線後，資料又會從 Node 02 同步複製過來。 

### 增加新 Node 我們可以任意新增多台 Node 到 Cluster 叢集系統裡，設置過程非常簡易 

<pre class="brush: bash; title: ; notranslate" title="">1. 安裝 MariaDB Server
2. 安裝 Galera Library
3. 設定 wsrep_cluster_address="gcomm://192.168.1.100:4567"</pre> 設定完成，就可以看到資料庫已經同步複製資料到新 Node 上面。如果遇到任何一台 Node 突然關機，不用緊張，系統會保持目前的資料，等到機器上線時，又會從 

**<span style="color:green">gcomm://another_node_ipaddress</span>** 同步後續的資料。 

### 動態設定 gcomm:// 如果新增一台新的 Node，我們就必須改動其它 Node 的 gcomm:// 設定，並且重新啟動 mysqld 服務，這樣會有些微時間影響，我們可以透過直接修改 GLOBAL wsrep\_cluster\_address 的值 

<pre class="brush: bash; title: ; notranslate" title="">$ mysql -e "SHOW VARIABLES LIKE 'wsrep_cluster_address';"                                                             
+-----------------------+-------------------------------------------------+                                           
| Variable_name         | Value                                           |                                           
+-----------------------+-------------------------------------------------+                                           
| wsrep_cluster_address | gcomm://xxx.xxx.xxx.xx:4567,xxx.xxx.xx.xxx:4567 |                                           
+-----------------------+-------------------------------------------------+ 

mysql> SET GLOBAL wsrep_cluster_address='gcomm://192.168.1.100:4567';
Query OK, 0 ROWS affected (3.51 sec)

mysql> SHOW VARIABLES LIKE 'wsrep_cluster_address';
+-----------------------+---------------------------+
| Variable_name         | VALUE                     |
+-----------------------+---------------------------+
| wsrep_cluster_address | gcomm://192.168.1.100:4567|
+-----------------------+---------------------------+
</pre> 最後需要注意的地方是，由於我們每一台機器都互相設定，如果要關閉全部 Node 機器,請務必將第一台重新設定 

**<span style="color:green">gcomm://</span>** 為空值，讓後續重新啟動的機器可以先連上此機器進行同步， 這次把 MySQL Replication 安裝設定完成，也就是完成架構圖的最下面部份 

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8603231970/" title="Server-load-balancers by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8402/8603231970_693a6e0de5.jpg?resize=463%2C500&#038;ssl=1" alt="Server-load-balancers" data-recalc-dims="1" /></a>
</div> 之後會介紹如何透過 

<a href="http://haproxy.1wt.eu/" target="_blank">HAproxy</a> 來處理 MySQL Load Balancer。