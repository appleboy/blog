---
title: '[Linux&FreeBSD] 備份系統資料，MySQL 資料庫，PgSQL 資料庫的自動化 bash shell script 程式'
author: appleboy
type: post
date: 2008-05-23T03:02:47+00:00
url: /2008/05/linuxfreebsd-備份系統資料，mysql-資料庫，pgsql-資料庫-shell-script/
views:
  - 6622
bot_views:
  - 3268
dsq_thread_id:
  - 246705916
categories:
  - FreeBSD
  - Linux
  - MySQL
tags:
  - FreeBSD
  - Linux

---
來分享一個自己寫的 bash shell script，本身管理系上一些伺服器，但是要每天備份資料庫，系統檔案，以防系統整個 crash 掉，但是這個 script 可以對單一一台電腦做備份動作，當然裡面還可以加上 rsync 的動作，遠端備份到不同機器上面，我覺得這樣也可以，我在 Sayay BBS 上面的 ghost 大大版上看到 [[Backup] Amanda][1]，這套看起來不錯，可是一直沒有時間去玩，她網站的架構圖如下： [<img src="https://i2.wp.com/farm4.static.flickr.com/3155/2513451293_ab18ac6449.jpg?resize=500%2C311&#038;ssl=1" title="chart-amanda-network (by appleboy46)" alt="chart-amanda-network (by appleboy46)" data-recalc-dims="1" />][2] http://amanda.zmanda.com/ 上面這個我還沒玩過，最近沒啥時間可以玩，不過大家可以去試試看，我目前還是用我自己寫的 script，那下面就是大概會介紹怎麼使用我的 bash script，非常簡單，很適合個人 linux 主機的備份喔。 <!--more-->

> ############################################### # # 日期：2008.05.22 # 作者：appleboy ( appleboy.tw AT gmail.com) # 網站：<http://blog.wu-boy.com> # ############################################### 本檔案歡迎大家拿去使用，也可以進行修改，加上功能，或者是減少功能，目前有的功能如下： 1. 備份系統各類檔案 ex: /etc，/var/www/html 2. 備份 MySQL 資料庫，支援遠端備份 3. 備份 PgSQL 資料庫 4. 定期刪除幾天前備份資料，避免系統空間過於浪費 5. 每天定期 FreeBSD port tree 更新 6. 支援 rsync 備份到遠端系統 步驟一：就是下載這個 script 檔案，然後放到系統的哪個資料夾，然後修改檔案第一行 

<pre class="brush: bash; title: ; notranslate" title="">#!/usr/local/bin/bash
#
# 使用 bash run my script，上面是 FreeBSD 路徑
# Linux 請用 /bin/bash
</pre> 步驟二：開始設定 script 基本設定 ######### 開始設定 ########## 

<pre class="brush: bash; title: ; notranslate" title="">#
# 設定刪除幾天前資料
#
RETENTION_PERIOD="14"</pre> 你可以選擇刪除幾天前的資料，寫14的話，就是保溜14天以內的資料喔 

<pre class="brush: bash; title: ; notranslate" title="">#
# 設定檔案名稱
#
backup_system_file="www_database.txt"
backup_mysql_file="mysql_database.txt"
backup_pgsql_file="pgsql_database.txt"</pre> 選擇你要備份的地方： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 您所要備份的地方
#
backup_home="/home/backup"
</pre> 首先：www_database.txt，這個檔案裡面請寫你要備份的資料夾，範例如底下： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 格式：
# 備份資料夾  壓縮檔名
/usr/local/etc etc.tar.gz
/usr/home/appleboy appleboy.tar.gz
/usr/local/www/apache22/data www-data.tar.gz</pre> mysql_database.txt 部份： 

<pre class="brush: bash; title: ; notranslate" title="">#
# mysql 資料庫部份格式
# 主機名稱 資料庫名稱 資料庫character_set
localhost AP  utf8
localhost WebHD  utf8
</pre> pg_database.txt 部份 

<pre class="brush: bash; title: ; notranslate" title="">#
# 只需要填入 database 就好
#
adwii</pre> 以上檔案，請不要在檔案裡面加上註解，或者是在第一行加入 # ，這樣都不行的喔 

<pre class="brush: bash; title: ; notranslate" title="">#
# 是否啟動備份系統檔案：1：備份 0：略過
#
data_enable_backup="0"
#
# 設定mysql相關參數
#
mysql_db_user="backup"
mysql_db_passwd="wwwadmin"
#
# 是否啟動備份 mysql：1：備份 0：略過
#
mysql_enable_backup="0"
#
# 設定pgsql相關參數
#
pgsql_db_user="appleboy"
pgsql_db_passwd="XXXXX"
#
# 是否啟動備份 pgsql：1：備份 0：略過
#
pgsql_enable_backup="0"
#
# 備份到遠端系統 rsync
#
rsync_enable="0"
password_file="/usr/local/etc/rsyncd/XXXX.secret"
rsync_backup_dir="${backup_home}/*"
rsync_remote_dir="appleboy@XXX.XXX.XXX::wuboy"
#
# 更新 FreeBSD port tree
#
port_tree_enable="0"

#
# 備份路徑
#
back_www_dir="${backup_home}/www_data"
back_mysql_db_dir="${backup_home}/mysql_db"
back_pgsql_db_dir="${backup_home}/pgsql_db"
log_dir="${backup_home}/log"
</pre> 上面說明還蠻清楚的吧，基本上剛開始預設功能都是關閉的，如果你要啟動她，就是把 0 改成 1 

[觀看 back_up.sh 檔案][3] [www_database.txt 檔案][4] [pgsql_database.txt 檔案][5] [www_database.txt 檔案][6] 上面檔案都是 UTF-8 格式，所以大家可以依照你系統的狀況調整，當全部設定好之後，接下來就是設定每天自動執行 

<pre class="brush: bash; title: ; notranslate" title="">#
# 設定每天早上 5點39分 執行這個檔案 
#
39      5    *       *       *       root    /usr/local/bin/bash /usr/home/backup/      back_up.sh 1> /dev/null 2>&#038;1</pre> 如果大家有問題請在這裡留言

 [1]: http://www.zmanda.com/
 [2]: https://www.flickr.com/photos/appleboy/2513451293/ "chart-amanda-network (by appleboy46)"
 [3]: http://blog.wu-boy.com/wp-content/uploads/2008/05/back_upsh.txt
 [4]: http://blog.wu-boy.com/wp-content/uploads/2008/05/www_database.txt
 [5]: http://blog.wu-boy.com/wp-content/uploads/2008/05/pgsql_database.txt
 [6]: http://blog.wu-boy.com/wp-content/uploads/2008/05/www_database1.txt