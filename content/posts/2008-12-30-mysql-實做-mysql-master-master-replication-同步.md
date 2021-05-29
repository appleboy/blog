---
title: '[MySQL] 實做 MySQL Master-Master Replication 同步'
author: appleboy
type: post
date: 2008-12-30T14:10:59+00:00
url: /2008/12/mysql-實做-mysql-master-master-replication-同步/
views:
  - 15453
bot_views:
  - 1713
dsq_thread_id:
  - 246717952
categories:
  - FreeBSD
  - Linux
  - MySQL
  - sql
  - Ubuntu
tags:
  - FreeBSD
  - Linux
  - MySQL

---
今天無聊實做了 [MySQL][1] 資料庫同步化，那可以先看看 [MySQL Master Slave Replication][2]，中文網站可以上 google 查詢或者是看看這一篇：[MySQL 設定 Replication (Master &#8211; Slave)][3]，基本上設定還蠻容易的，如果會 Master 同步到 Slave 的話，那 MySQL Master-Master 只是在用相同的方法在做一遍，如果不懂 MMM 的可以先參考這一篇：[MySQL Master-Master Replication Manager(1) &#8211; 簡介][4]，這篇寫的很清楚，今天看了文章，我實做起來，遇到一些問題，其實還蠻奇怪的，所以底下就來紀錄一下步驟，順便也說明一下。 實做兩台 Ubuntu 機器： db1：192.168.1.1 db2：192.168.1.2 先設定 db1： 目前我都是在 Ubuntu 7.10 底下實做的，那基本上只要有支援 MySQL 的 Linux 或者 FreeBSD 機器都可以實做這個方法： **<span style="color: #ff0000;">步驟一：先修改 my.cnf 這個檔案：</span>** FreeBSD 的話在：/var/db/mysql/my.cnf Ubuntu：/etc/mysql/my.cnf 有的版本是在 /etc/my.cnf 所以不太一定，請依照自己的作業系統 修改： 

<pre class="brush: bash; title: ; notranslate" title="">#
# bind-address 請 mark 起來，因為我們必須讓 MySQL Listen 各個不同的 IP Address
#bind-address           = 127.0.0.1
#
# server id 請記得每台機器都設定不同喔
#
server-id               = 1
log_bin                 = /var/log/mysql/mysql-bin.log</pre>

<!--more--> 步驟一的部份也請先在 db2 的機器先設定一次，然後重新啟動 mysql 

**<span style="color: #ff0000;">步驟二：設定 mysql 權限</span>** 

<pre class="brush: sql; title: ; notranslate" title="">mysql -u root -p
#
# 先設定 replication 這個帳號密碼是 slave 這個可以自己改掉
#
mysql> GRANT replication slave on *.* to 'replication'@'%' identified by 'slave';
#
#  這個是官方的寫法，可以按照這底下去寫就可以了
# 
mysql> change master to master_host='192.168.1.2', master_port=3306, master_user='replication', master_password='slave';
#
# 底下是 Master 機器的 bin log file
# master_log_file='mysql-bin.000004',
# master_log_pos=98;
# 可以利用 SHOW MASTER STATUS; 來取得這兩個的值
mysql> change master to master_host='192.168.1.2', master_port=3306, master_user='replication', master_password='slave', master_log_file='mysql-bin.000004', master_log_pos=98;</pre> 先到 db2 執行 SHOW MASTER STATUS; 會得到底下結果 

<pre class="brush: bash; title: ; notranslate" title="">+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      189 |              |                  |
+------------------+----------+--------------+------------------+</pre> 那這樣就可以知道 master\_log\_file=&#8217;mysql-bin.000001&#8242;, master\_log\_pos=189; 

**<span style="color: #ff0000;">步驟三：測試觀看 mysql slave</span>** 重新啟動 mysql 

<pre class="brush: bash; title: ; notranslate" title="">/etc/init.d/mysql restart
#
# 啟動 slave 
#
mysql> START slave;
#
# 觀看 slave 狀態 
#
mysql> show slave status \G;</pre>

[<img src="https://i1.wp.com/farm4.static.flickr.com/3126/3149923289_d645d2d6c9.jpg?resize=473%2C500&#038;ssl=1" title="1 (by appleboy46)" alt="1 (by appleboy46)" data-recalc-dims="1" />][5] 請注意下面這兩行必須為 YES 

<pre class="brush: bash; title: ; notranslate" title="">Slave_IO_Running: Yes
Slave_SQL_Running: Yes</pre> 這樣才算代表成功了，不然就是失敗的。 先設定 db2： 

**<span style="color: #ff0000;">步驟一：先修改 my.cnf 這個檔案：</span>** FreeBSD 的話在：/var/db/mysql/my.cnf Ubuntu：/etc/mysql/my.cnf 有的版本是在 /etc/my.cnf 所以不太一定，請依照自己的作業系統 修改： 

<pre class="brush: bash; title: ; notranslate" title="">#
# bind-address 請 mark 起來，因為我們必須讓 MySQL Listen 各個不同的 IP Address
#bind-address           = 127.0.0.1
#
# server id 請記得每台機器都設定不同喔
#
server-id               = 1
log_bin                 = /var/log/mysql/mysql-bin.log</pre>

**<span style="color: #ff0000;">步驟二：設定 mysql 權限</span>** 

<pre class="brush: sql; title: ; notranslate" title="">mysql -u root -p
#
# 先設定 replication 這個帳號密碼是 slave 這個可以自己改掉
#
mysql> GRANT replication slave on *.* to 'replication'@'%' identified by 'slave';
#
#  這個是官方的寫法，可以按照這底下去寫就可以了
# 
mysql> change master to master_host='192.168.1.1', master_port=3306, master_user='replication', master_password='slave';
#
# 底下是 Master 機器的 bin log file
# master_log_file='mysql-bin.000004',
# master_log_pos=98;
# 可以利用 SHOW MASTER STATUS; 來取得這兩個的值
mysql> change master to master_host='192.168.1.1', master_port=3306, master_user='replication', master_password='slave', master_log_file='mysql-bin.000004', master_log_pos=98;</pre>

**<span style="color: #ff0000;">步驟三：測試觀看 mysql slave</span>** 重新啟動 mysql 

<pre class="brush: bash; title: ; notranslate" title="">/etc/init.d/mysql restart
#
# 啟動 slave 
#
mysql> START slave;
#
# 觀看 slave 狀態 
#
mysql> show slave status \G;</pre> 如果遇到 

<pre class="brush: bash; title: ; notranslate" title="">Slave_IO_Running: no
Slave_SQL_Running: no</pre> 這樣的話請依照下面步驟： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 停止跟清除 SLAVE 
#
mysql> STOP SLAVE;
mysql> RESET SLAVE;
#
# 停止 mysql
#
/etc/init.d/mysql stop
#
# 刪除 bin log 檔案
#
rm -rf /var/log/mysql/mysql-bin.*
#
# 啟動 mysql 
#
/etc/init.d/mysql start
#
# 在設定一次 master ip 資訊
#
mysql> change master to master_host='192.168.1.1', master_port=3306, master_user='replication', master_password='slave';
#
# 啟動 slave
#
mysql> START SLAVE;</pre> 參考網站： 

[How To Set Up Database Replication In MySQL][6] [MySQL Master Master Replication][7] [MySQL Master-Master Replication Manager(2) &#8211; 環境建置、架設][8]

 [1]: http://www.mysql.com/
 [2]: http://dev.mysql.com/doc/refman/5.0/en/replication.html
 [3]: http://plog.longwin.com.tw/my_note-app-setting/2008/03/11/mysql_replication_master_slave_set_2008
 [4]: http://plog.longwin.com.tw/news-technology/2008/10/21/mysql-master-replication-manager-mmm-intro-2008
 [5]: https://www.flickr.com/photos/appleboy/3149923289/ "1 (by appleboy46)"
 [6]: http://www.howtoforge.com/mysql_database_replication
 [7]: http://www.howtoforge.com/mysql_master_master_replication
 [8]: http://plog.longwin.com.tw/news-technology/2008/10/22/mysql-master-replication-manager-mmm-build-2008