---
title: '[FreeBSD & Linux Ubuntu] Proftpd 支援 UTF-8 + MYSQL 虛擬帳號 + Quota 限制'
author: appleboy
type: post
date: 2008-04-25T15:26:56+00:00
url: /2008/04/freebsd-linux-ubuntu-proftpd-支援-utf-8-mysql-虛擬帳號-quota-限制/
views:
  - 7018
bot_views:
  - 1142
dsq_thread_id:
  - 246815746
categories:
  - FreeBSD
  - Linux
  - Ubuntu
tags:
  - Linux
  - MySQL
  - proftpd
  - quota

---
今天突然想到要玩一下 [Proftpd][1] 的 MYSQL 虛擬帳號認證部份，我是用 FreeBSD 7.0 Release 下去安裝的，剛剛去看了一下官方網站，從 1.3.1rc1 版開始，支援 UTF-8 傳送跟接收了，請看 [RELEASE_NOTES-1.3.1rc1][2]，所以1.2.10版本之前的都不支援 UTF-8 不過台灣有人 patch 出來可以支援 Big5，現在都不用了，裡面有一段簡介 

> UseUTF8 Disables use of UTF8 encoding for file paths. If the &#8211;enable-nls configure option is used, then UTF8 encoding support will be enabled by default.  如果你的 server 是用此版本，或者是更高，請在編譯的時候加入 &#8211;enable-nls 

> &#8211;enable-nls This configure option enables handling of translated message catalogs for response messages, and also enables handling of UTF8 paths in client commands.<!--more--> 這樣就可以處理 Client UTF-8 的支援問題了 實驗環境： 

> FreeBSD 7.0 Release Ubuntu 7.10 proftpd-1.3.1_12 安裝方式：FreeBSD 版本 & Linux Ubuntu 7.10 

<pre class="brush: bash; title: ; notranslate" title="">#
# FreeBSD
#
cd /usr/ports/ftp/proftpd-mysql
make install clean

#
# Linux
#
apt-get install proftpd-mysql</pre> 其餘的大概就是 apache 跟 mysql 要事先裝好，還有 phpmyadmin 

<pre class="brush: bash; title: ; notranslate" title="">#
# Linux 安裝
#
apt-get install mysql-server mysql-client libmysqlclient12-dev phpmyadmin
#
# FreeBSD
#
cd /usr/ports/www/apache22/; make install clean
cd /usr/ports/databases/mysql51-server/; make install clean
cd /usr/ports/databases/phpmyadmin/; make install clean
#
# 設定 mysql 密碼
#
mysqladmin -u root password yourrootsqlpassword
</pre> 再來進入主題，MYSQL 帳號認證部份，首先建立資料庫 

<pre class="brush: sql; title: ; notranslate" title="">CREATE DATABASE `ftp` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;</pre> 建立使用者資料表，這個資料表是紀錄使用者的所有資料 

<pre class="brush: sql; title: ; notranslate" title="">#
# username 使用者帳號
# uid 系統的 uid 這個可以自己隨便給個數字，不要重複到系統帳號
# gid 系統的 gid 這個看你用途是什麼來去對應
# password 使用者密碼
# homedir 使用者家目錄
# shell 使用者的 shell 最好是填 /sbin/nologin
#
CREATE TABLE IF NOT EXISTS `ftp` (
  `username` varchar(60) default NULL,
  `uid` int(11) NOT NULL,
  `gid` int(11) default NULL,
  `password` varchar(30) default NULL,
  `homedir` varchar(60) default NULL,
  `shell` varchar(32) default '/usr/bin/nologin',
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;</pre> 接下來建立 group 資料表 

<pre class="brush: sql; title: ; notranslate" title="">#
# groupname 群組帳號
# gid 系統的 gid 這個對應到系統 /etc/group 的 gid 值，也可以不用，看你怎麼用
# members 這個群組的成員
#
CREATE TABLE IF NOT EXISTS `groups` (
  `groupname` varchar(30) NOT NULL default '',
  `gid` int(11) NOT NULL default '0',
  `members` varchar(255) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
</pre> members 這個比較重要的是，每個成員都是以逗點隔開的喔，所以一個群組可以無限多個成員，例如 

<pre class="brush: bash; title: ; notranslate" title="">#
# 這樣一直隔開
#
test1,test2,test3
</pre> 接下來就是去修改 proftpd.conf 了 

<pre class="brush: bash; title: ; notranslate" title="">#
# 關掉反查 DNS
#
UseReverseDNS off

DefaultAddress ::
#
# 使用 mysql 資料庫為主
#
SQLBackend mysql

# SQLAuthTypes Backend
# 密碼認證 已 PASSWORD() 產生為主
# 密碼使用明碼 Plaintext
SQLAuthTypes Plaintext

#
# 開啟認證
#
SQLAuthenticate on
#
# MySQL 連線資訊，資料庫名稱@主機 帳號 密碼
#
SQLConnectInfo ftp@localhost root wwwadmin080225
#
# 使用者資料庫欄位
#
SQLUserInfo ftp username password uid gid homedir shell
#
# 群組資料庫欄位
#
SQLGroupInfo groups groupname gid members
#
# SQL Log 檔
#
SQLLogFile /var/log/proftpd/sql.log
#
# 當 Home 目錄不存在，會自己產生。
#
SQLHomedirOnDemand on
#
# SQL Log 格式，當正確登入時，要執行的 SQL 語法
#
SQLLog PASS updatecount
#
#  updatecount 增加登入跟時間
#
SQLNamedQuery updatecount UPDATE "count=count+1, accessed=now() where userid='%u'" ftp
#
# SQL Log 格式，當儲存或刪除檔案時，要執行的 SQL 語法
#
SQLLog STOR,DELE modified
# 
# modified 語法 
#
SQLNamedQuery modified UPDATE "modified=now() where userid='%u'" ftp
</pre> 接下來是要介紹如何設定 quota ，然后建立 mysql 相關資料表 

<pre class="brush: sql; title: ; notranslate" title="">#
#quota_type 硬碟限額的鑒別,可以設置單各使用者，也可以設置一各組中的全部使用者，還可以設置全部使用者
#bytes_in_avail 上傳最大位元組數，就是FTP使用者空間容量 (設置個字段的時候是以byte(位元組)為單位，如果要限額在10M，那就是10240000,下面也一樣)
#bytes_out_avail 下載最大位元組數，需要注意的是，這個字段中記錄的是使用者總共能從伺服器上下載多少資料，資料是累計的。
#bytes_xfer_avail 總共可傳輸的文件的最大位元組數(上傳和下載流量)需要注意的是，這個字段中記錄的是使用者總共能傳輸文件的最大位元組數，資料是累計的。
#files_in_avail INT 總共能上傳文件的數目
#files_out_avail INT 能從伺服器上下載文件的總數目
#files_xfer_avail INT 總共可傳輸文件的數目(上傳和下載) 
#
CREATE TABLE quotalimits (
name VARCHAR(30),
quota_type ENUM("user", "group", "class", "all") NOT NULL,
per_session ENUM("false", "true") NOT NULL,
limit_type ENUM("soft", "hard") NOT NULL,
bytes_in_avail FLOAT NOT NULL,
bytes_out_avail FLOAT NOT NULL,
bytes_xfer_avail FLOAT NOT NULL,
files_in_avail INT UNSIGNED NOT NULL,
files_out_avail INT UNSIGNED NOT NULL,
files_xfer_avail INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE quotatallies (
name VARCHAR(30) NOT NULL,
quota_type ENUM("user", "group", "class", "all") NOT NULL,
bytes_in_used FLOAT NOT NULL,
bytes_out_used FLOAT NOT NULL,
bytes_xfer_used FLOAT NOT NULL,
files_in_used INT UNSIGNED NOT NULL,
files_out_used INT UNSIGNED NOT NULL,
files_xfer_used INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8; </pre> 再來是修改 proftpd.conf 的檔案 

<pre class="brush: bash; title: ; notranslate" title="">#
# 硬碟限額部分
#
QuotaDirectoryTally on
#
#硬碟限額單位 b | Kb | Mb| Gb
#
QuotaDisplayUnits "Kb"
#
# 啟動 Quota
#
QuotaEngine on
#
# 硬碟限額日志記錄
#
QuotaLog "你的LOG路徑"
#
# 打開硬碟限額資訊，當登陸FTP帳戶后，使用命令 "quote SITE QUOTA" 后可顯示當前使用者的硬碟限額
#
QuotaShowQuotas on
#
#以下是SQL調用語句，不用修改直接拷貝過去
#
SQLNamedQuery get-quota-limit SELECT "name, quota_type, per_session, limit_type, bytes_in_avail, bytes_out_avail, bytes_xfer_avail, files_in_avail, files_out_avail, files_xfer_avail FROM quotalimits WHERE name = '%{0}' AND quota_type = '%{1}'"

SQLNamedQuery get-quota-tally SELECT "name, quota_type, bytes_in_used, bytes_out_used, bytes_xfer_used, files_in_used, files_out_used, files_xfer_used FROM quotatallies WHERE name = '%{0}' AND quota_type = '%{1}'"

SQLNamedQuery update-quota-tally UPDATE "bytes_in_used = bytes_in_used + %{0}, bytes_out_used = bytes_out_used + %{1}, bytes_xfer_used = bytes_xfer_used + %{2}, files_in_used = files_in_used + %{3}, files_out_used = files_out_used + %{4}, files_xfer_used = files_xfer_used + %{5} WHERE name = '%{6}' AND quota_type = '%{7}'" quotatallies

SQLNamedQuery insert-quota-tally INSERT "%{0}, %{1}, %{2}, %{3}, %{4}, %{5}, %{6}, %{7}" quotatallies 
</pre> 首先呢，先建立一個 group 給 ftp 

<pre class="brush: bash; title: ; notranslate" title="">#
# FreeBSD 建立 FTP group
#
pw group add ftp
mkdir /home/ftp
chown appleboy:ftp /home/ftp
#
# ftp 這個群組的都可以在資料夾底下新增刪除
#
chmod 775 /home/ftp
</pre>

<pre class="brush: sql; title: ; notranslate" title="">#
# 新增 sql 語法
#
INSERT INTO `ftp` (`username`, `uid`, `gid`, `password`, `homedir`, `shell`) VALUES
('test1', 1500, 1004, '1234', '/home/ftp', '/sbin/nologin');
INSERT INTO `groups` (`groupname`, `gid`, `members`) VALUES
('ftp', 1004, 'appleboy,test1,test2');
INSERT INTO `quotalimits` (`name`, `quota_type`, `per_session`, `limit_type`, `bytes_in_avail`, `bytes_out_avail`, `bytes_xfer_avail`, `files_in_avail`, `files_out_avail`, `files_xfer_avail`) VALUES
('test1', 'user', 'false', 'soft', 1024000, 0, 204800, 500, 0, 10);
</pre> 然後在利用 lftp 去做測試，測試結果如下： 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3123/2440410011_bc6fb3853f.jpg?resize=500%2C176&#038;ssl=1" title="1 (by appleboy46)" alt="1 (by appleboy46)" data-recalc-dims="1" />][3] 參考網站： <http://www.myunix.idv.tw/forum/viewtopic.php?p=622> [http://howtoforge.com/proftpd\_mysql\_virtual\_hosting\_p2][4]

 [1]: http://www.proftpd.org/
 [2]: http://www.proftpd.org/docs/RELEASE_NOTES-1.3.1rc1
 [3]: https://www.flickr.com/photos/appleboy/2440410011/ "1 (by appleboy46)"
 [4]: http://howtoforge.com/proftpd_mysql_virtual_hosting_p2