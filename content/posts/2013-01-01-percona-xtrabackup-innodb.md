---
title: Percona XtraBackup InnoDB 備份工具
author: appleboy
type: post
date: 2013-01-01T04:13:33+00:00
url: /2013/01/percona-xtrabackup-innodb/
dsq_thread_id:
  - 1002247557
categories:
  - InnoDB
  - MyISAM
  - MySQL
tags:
  - InnoDB
  - MySQL
  - Percona
  - XtraBackup

---
<a href="http://www.percona.com/software/percona-xtrabackup/" target="_blank">Percona XtraBackup</a> 是一套 compiled C 程式，用於備份 MySQL InnoDB 資料庫，過去備份 MyISAM 或 InnoDB 都是透過 mysqldump 指令，或者是直接 copy **<span style="color: #008000;">/var/lib/mysql</span>** 目錄當作備份(這方法盡量少做，請確定 MySQL 版本一致)，XtraBackup 用於備份 InnoDB 資料部份，請注意這邊，真的只有"備份資料"，而不是全部(結構跟資料)，底下仔細介紹如何安裝: 

### 安裝方式 大家可以選擇透過 

<a href="http://www.percona.com/doc/percona-xtrabackup/installation/yum_repo.html" target="_blank">yum</a> 或 <a href="http://www.percona.com/doc/percona-xtrabackup/installation/apt_repo.html" target="_blank">apt</a> Repository 方式安裝，下面介紹 apt 方式即可。 <!--more-->

<pre class="brush: bash; title: ; notranslate" title="">$ gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
$ gpg -a --export CD2EFD2A | sudo apt-key add -
</pre> 將 apt 伺服器寫入 

**<span style="color: #008000;">/etc/apt/sources.list</span>** 

<pre class="brush: bash; title: ; notranslate" title="">deb http://repo.percona.com/apt VERSION main
deb-src http://repo.percona.com/apt VERSION main
</pre> VERSION 請至換 Ubuntu Server 版號，如果您想測試實驗性版本請加入底下連結 

<pre class="brush: bash; title: ; notranslate" title="">deb http://repo.percona.com/apt VERSION main experimental
deb-src http://repo.percona.com/apt VERSION main experimental
</pre>

### 注意事項 根據不同的 MySQL 版本來選擇 XtraBackup 指令，可以參考 

<a href="http://www.percona.com/doc/percona-xtrabackup/xtrabackup_bin/choosing_binary.html" target="_blank">Choosing the Right Binary</a>，所以大家不要用錯指令了。 透過寫入 my.cnf 可以設定備份目錄，此步驟可以省略 

<pre class="brush: bash; title: ; notranslate" title="">[xtrabackup]
target_dir = /home/backups/mysql/
</pre>

### 完整備份 可以備份 InnoDB data and log files 從 /var/lib/mysql/ 到 /home/backups/mysql/ 

<pre class="brush: bash; title: ; notranslate" title="">$ xtrabackup --defaults-file=/etc/mysql/my.cnf --backup --target-dir=/home/backup/mysql --datadir=/var/lib/mysql
</pre> --defaults-file 吃 MySQL 設定檔，我們可以另外指定 --target-dir 備份目錄，如果之前你有寫入 my.cnf，指令就可以少寫 --target-dir，備份完成以後，我們需要 Prepare 兩次 MySQL Data 

<pre class="brush: bash; title: ; notranslate" title="">$ xtrabackup --defaults-file=/etc/mysql/my.cnf --prepare --target-dir=/home/backup/mysql
</pre> 看到底下訊息就代表成功了 

<pre class="brush: bash; title: ; notranslate" title="">xtrabackup: starting shutdown with innodb_fast_shutdown = 1
130101 11:55:26  InnoDB: Starting shutdown...
130101 11:55:30  InnoDB: Shutdown completed; log sequence number 450927116
</pre>

### 恢復備份資料 XtraBackup 程式並非用於備份 MyISAM 資料及 .frm 檔案，所以必須分開備份，底下是用於恢復 InnoDB 資料 

<pre class="brush: bash; title: ; notranslate" title="">$ cd /home/backup/mysql/
$ rsync -rvt --exclude 'xtrabackup_checkpoints' --exclude 'xtrabackup_logfile' ./ /var/lib/mysql
$ chown -R mysql:mysql /var/lib/mysql/
$ service mysql restart
</pre> 另外請記的先備份 .frm 檔案，沒 .frm 檔案，備份資料就沒有用了。