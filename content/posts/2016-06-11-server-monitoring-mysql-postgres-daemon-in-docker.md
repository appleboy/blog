---
title: 在 Docker 偵測 MySQL 或 Postgres 是否啟動
author: appleboy
type: post
date: 2016-06-11T08:42:23+00:00
url: /2016/06/server-monitoring-mysql-postgres-daemon-in-docker/
dsq_thread_id:
  - 4901638883
categories:
  - Docker
  - MySQL
tags:
  - devops
  - Docker
  - MySQL
  - Postgres

---
<a title="Screen Shot 2016-06-11 at 6.58.22 PM" href="https://www.flickr.com/photos/appleboy/27525281071/in/dateposted-public/" data-flickr-embed="true"><img src="https://i2.wp.com/c2.staticflickr.com/8/7626/27525281071_50bc0dec77_o.png?resize=591%2C580&#038;ssl=1" alt="Screen Shot 2016-06-11 at 6.58.22 PM" data-recalc-dims="1" /></a>

監控 Service 是否存活也是 [DevOps][1] 重要的一環，此篇來紀錄在 [Docker][2] 內偵測 [MySQL][3] 或 [Postgres][4] 是否已經啟動。在 Docker 自動測試內，其中一步就是建立 Database 環境，底下為測試步驟:

<!--more-->

### 測試步驟

  * 啟動 Database 服務
  * 執行 Database Migration
  * 關閉 Database 服務

但是在 Docker 啟動 Database 服務後，如果直接執行 Migration，會遇到 Database 尚未啟動，所以造成 Database Migration 失敗，這也是本篇要教大家如何偵測 MySQL 或 Postgres 是否啟動。

### 啟動 Database 服務

在 Docker 要啟動 Database 服務相當容易，底下分別為 MySQL 及 Postgres 啟動步驟

```bash
# Postgres
$ docker run --name some-postgres \
  -d postgres:latest

# MySQL
$ docker run --name some-mysql \
  -d -e MYSQL_ROOT_PASSWORD=1234 \
  mysql:latest
```

### 偵測 Database 服務

透過 [Docker exec][5] 指令偵測 MySQL 及 Postgres 是否啟動，Postgres 透過 `pg_isready` 指令，Mysql 則是使用 `mysqladmin`

```bash
# Postgres
$ docker exec some-postgres pg_isready -h 127.0.0.1
127.0.0.1:5432 - accepting connections

# MySQL
$ docker exec some-mysql mysqladmin -uroot -p123 ping
mysqld is alive
# 或者是直接執行單一 SQL 語法
$ docker exec some-mysql mysql -uroot -p123 \
  -e "SHOW Databases;"
```

在 Docker 內如果是用 `mysqladmin ping` 的方式，我發現會抓不到 `$?` 錯誤代碼，所以還是建議用後者方式，透過執行單一 SQL 方式，在 [HAProxy][6] 搭配 [Percona XtraDB Cluster][7] 也是透過後者來偵測，詳情可以參考之前寫的『[Percona XtraDB Cluster 搭配 HAProxy][8]』。知道如何偵測後，就要寫 While 迴圈每一秒持續偵測。

```bash
while ! pg_isready -h postgres; do
  output "Database service is unavailable - sleeping"
  sleep 1
done
```

完成上述偵測步驟，就可以正常執行 Databse Migration

<a title="Screen Shot 2016-06-11 at 2.04.02 PM" href="https://www.flickr.com/photos/appleboy/26984299474/in/dateposted-public/" data-flickr-embed="true"><img src="https://i2.wp.com/c3.staticflickr.com/8/7345/26984299474_5de0fa4ddb_z.jpg?resize=640%2C357&#038;ssl=1" alt="Screen Shot 2016-06-11 at 2.04.02 PM" data-recalc-dims="1" /></a>

 [1]: http://www.ithome.com.tw/news/96861
 [2]: https://www.docker.com/
 [3]: https://www.mysql.com/
 [4]: https://www.postgresql.org/
 [5]: https://docs.docker.com/engine/reference/commandline/exec/
 [6]: http://www.haproxy.org/
 [7]: https://www.percona.com/software/mysql-database/percona-xtradb-cluster
 [8]: https://blog.wu-boy.com/2014/01/percona-xtradb-cluster-reference-architecture-with-haproxy/