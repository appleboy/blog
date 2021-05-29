---
title: '[Linux] Ubuntu 6.06 Proftpd + Mysql 安裝方式'
author: appleboy
type: post
date: 2006-10-21T16:17:51+00:00
url: /2006/10/linux-ubuntu-606-proftpd-mysql-安裝方式/
bot_views:
  - 1847
views:
  - 4816
dsq_thread_id:
  - 247274322
categories:
  - Linux
  - Ubuntu
tags:
  - Linux
  - MySQL
  - proftpd
  - Ubuntu

---
ProFTPD Version 1.2.10 Mysql Version 4.1.0 支援 UTF8 請確定你的proftpd有支援sql module 

<pre class="brush: bash; title: ; notranslate" title="">proftpd -l | grep mysql

proftpd -l | grep sql
mod_sql.c
mod_sql_mysql.c
mod_quotatab_sql.c</pre> 確定有支援之後 再來就是建立mysql資料庫 * 建立 proftp 資料庫 

<pre class="brush: sql; title: ; notranslate" title="">CREATE DATABASE `ftp` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;</pre> * 建立使用者資料表 

<pre class="brush: sql; title: ; notranslate" title="">CREATE TABLE `ftp` (
`username` varchar( 60 ) default NULL ,
`uid` int( 11 ) NOT NULL ,
`gid` int( 11 ) default NULL ,
`password` varchar( 30 ) default NULL ,
`homedir` varchar( 60 ) default NULL ,
`shell` varchar( 11 ) default ‘/bin/false’,
PRIMARY KEY ( `uid` ) ,
UNIQUE KEY ( `username` )
) TYPE = MYISAM;</pre> 此資料表是在紀錄使用者的基本資訊，uid是使用者系統uid，gid是使用者group的id，passwd使用者的密碼 homedir為使用者登入的家目錄， shell可以為該使用者指定相應的shell * 建立使用者群組資料表 

<pre class="brush: sql; title: ; notranslate" title="">CREATE TABLE `groups` (
`groupname` varchar( 30 ) NOT NULL default ‘’,
`gid` int( 11 ) NOT NULL default ‘0′,
`members` text default NULL
) TYPE = MYISAM;</pre> 其中grpname是組的名稱，gid是系統組的ID，members是組的成員。注意：多成員，他們之間要用逗號隔開，不能使用空格 例如 3個使用者 test1 test2 test3 ，members就要寫 (test1,test2,test3) #設置MySQL認證： SQLConnectInfo 資料庫 資料庫帳號 資料庫密碼 #設置user資料表資訊『對應你的設定的資料表』 SQLUserInfo ftp username password uid gid homedir shell #設置group資料表資訊『對應你的設定的資料表』 SQLGroupInfo groups groupname gid members #設定使用者密碼編碼方式 ex：Plaintext 純文字 SQLAuthTypes Plaintext #設定mysql log檔 SQLLogFile /var/log/sql.log PersistentPasswd off #如果home目錄不存在，則系統會為根據它的home項新建一個目錄： SQLHomedirOnDemand on 再來呢，建立ftp的專屬group，當然你如果有許多群組，請自行建立 1. 建立groupgroupadd ftpgroup 2. 建立一個使用者home目錄 

<pre class="brush: bash; title: ; notranslate" title="">useradd -G ftpgroup -d /home/ftp -m -s /bin/false ftp</pre> 為FTPUSR建立HOME，把所有的FTP user 活動空間全放在此目錄下： 

<pre class="brush: bash; title: ; notranslate" title="">mkdir /home/ftp #剛剛建立使用者已經建立了
chown -R ftp:ftpgroup /home/ftp</pre> 開始建立ftp的使用者，可以的話利用phpmyadmin 

<pre class="brush: sql; title: ; notranslate" title="">INSERT INTO user (`userid`, `passwd`, `uid`, `gid`, `home`, `shell`) values (’test’, ‘1234′, ‘1000′, ‘1001′, ‘/home/ftp/’, ‘/bin/false’ );
INSERT INTO `groups` VALUES (’ftpgroup’, 1001, ‘test’);
</pre> 上面那個是新增group對應使用者，如果你有多個使用者對應到同一個group 那麼你就要修改 group 改成 VALUES (’ftpgroup’, 1001, ‘test1,test2,test3′) 所以每增加一個使用者，就要去修改一次，有點麻煩，不過寫程式就可以解決了 大致上是如此，有問題在提出吧 我的proftpd.conf設定檔 http://bbs.ee.ndhu.edu.tw/~appleboy/proftpd.conf