---
title: '[DataBase] 備份 MySQL 3.23.49 轉到 MySQL 5 utf8 轉換到 utf8'
author: appleboy
type: post
date: 2008-05-09T01:00:53+00:00
url: /2008/05/database-備份-mysql-32349-轉到-mysql-5-utf8-轉換到-utf8/
views:
  - 6220
bot_views:
  - 766
dsq_thread_id:
  - 247402994
categories:
  - FreeBSD
  - Linux
  - MySQL
  - sql
tags:
  - MySQL

---
最近在幫友人處理他們web跟資料庫的轉移，然後發現他們的資料庫是很古早的資料庫 MySQL 3.23.49 版本，相當古老吧，因為那個時候我才正值大二時代，剛開始接觸電腦的時候而已，連最基本的資料庫都不知道是什麼，哈哈經過這麼久終於發展到 MySQL 5版本了，不過從 MySQL 4.x 開始支援的 Unicode 系統，所以當時也有很多人遇到轉換問題，我今天也遇到相同問題，不過是在轉換到 Linux Centos 5.1 版本底下，原本機器使用 Red Hat Linux 7.3，真是一個很舊的版本，因為 Red Hat Linux 已經到 9.0 版本了，而且目前不維護了。 之前版本轉換都沒有什麼問題，就是 4.x 轉到 5.x 版本，參可我之前寫的這篇 [[Mysql] 資料庫備份[big5]utf8轉換成utf-8][1]，如果這篇文章解決不了的話，那就可能用我底下的方法了，不過過上面那個方法不適合用在 3.23 轉到 5.x 版，因為還是會發生亂碼現象，可是這只會發生在 Linux 底下，因為我用 FreeBSD 7.0 R 版，在這環境底下是沒有問題的，所以今天很囧，都在處理 Linux 的部份，哈哈，所以大家還是去用 FreeBSD 吧 <!--more--> 步驟一：利用 mysqldump 指令把資料庫 dump 出來 

<pre class="brush: bash; title: ; notranslate" title="">#
# dump 遠端 mysql
#
# -h mysql host
# -u username
mysqldump --default-character-set=utf8 -h xxx.xxx.xxx.xxx -u db_user -p db_name > backup.sql</pre> 步驟二：把 big5 檔案轉換成 utf-8 檔案，利用 iconv 

<pre class="brush: bash; title: ; notranslate" title="">#
# icnv 指令
#
iconv -c -f CP950 -t UTF-8 backup.sql > backup_utf8.sql</pre> 步驟三：編輯檔案，取代&#8221;許蓋功&#8221;，及跳脫字元&#8221;\&#8221; 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 vi 編輯器的取代指令，也可以用 sed
#
vi backup_utf8.sql
#
# 轉換 utf8 table
#
:%s/InnoDB/InnoDB DEFAULT CHARSET=utf8/g
#
# 取代許功蓋
#
:%s/功\\/功/g
:%s/許\\/許/g
:%s/功\\/功/g
#
# 檢查是否有跳脫字元
#</pre> 步驟四：恢復資料庫 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 mysql 這個指令就可以恢復了
#
mysql --default-character-set=utf8 -u root -p db_name &lt; backup.sql[/code]

步驟五：在 php 前端程式加上
[code lang="php"]
/*
如果前台也是 unicode UTF-8 就不必加了
*/
mysql_query("SET NAMES utf8");
[/code]
因為資料庫相當龐大，所以在恢復的時候遇到下面問題：




<blockquote>
  ERROR 1153 (08S01) at line 1002: Got a packet bigger than 'max_allowed_packet' bytes
</blockquote>

當然我在 google 找到答案了：
Packet too large ： http://dev.mysql.com/doc/refman/4.1/en/packet-too-large.html

在 Linux 主機加上 /etc/my.cnf
[mysqld]
max_allowed_packet=64M</pre> 在 FreeBSD 主機加上 /var/db/mysql/my.cnf 這樣就可以了 目前 MySQL 有提供四個範例檔，皆位於 /usr/local/share/mysql/ 目錄中，四個檔案的開頭皆為 my-*。關於其中的差別，可觀看其中的頭幾行說明，然後將範例本身或修改過後，置於特定目錄中即可。 

> my-huge.cnf，記憶體 1G-2G。 my-large.cnf，記憶體 512M。 my-medium.cnf，記憶體 32-64M。 my-small.cnf，記憶體 <= 64M。 my-innodb-heavy-4G.cnf，使用 INNODB，且記憶體 4G。<pre class="brush: bash; title: ; notranslate" title="">#
# 複製檔案
#
cp /usr/local/share/mysql/my-medium.cnf /var/db/mysql/my.cnf </pre> 參考網站： http://dev.mysql.com/doc/refman/4.1/en/packet-too-large.html 

[如何修正 MySQL 資料庫的 encoding][2] [MySQL 字元集支援【翻譯】][3] [[encoding] MySQL 4.1.x SET NAMES UTF8][4]

 [1]: http://blog.wu-boy.com/2007/04/08/92/
 [2]: http://www.jeffhung.net/blog/articles/jeffhung/253/
 [3]: http://linux0911.no-ip.info/Discuz/archiver/tid-1494.html
 [4]: http://blog.dragon2.net/2005/10/24/228.php