---
title: '[MYSQL] 忘記 root 密碼，登不進去 phpMyAdmin 教學'
author: appleboy
type: post
date: 2007-12-31T15:53:55+00:00
url: /2007/12/mysql-忘記-root-密碼，登不進去-phpmyadmin-教學/
views:
  - 10043
bot_views:
  - 694
dsq_thread_id:
  - 246700203
categories:
  - FreeBSD
  - Linux
  - sql

---
**2011.06.24 Update: 修改語法** 剛剛在處理老闆的機器移機問題，雖然有給我 root 權限，可是 MySQL 密碼沒有給我 root 的，然後我去看程式，都沒有用到 root ，都是用普通使用者，所以就上網找一下忘記密碼怎麼處理，其實找到的方法就是利用 command line 的方法，相當方便，最終解決方法還是文字介面，作法如下 首先先 Kill 掉所有 MySQL 的連線 

<pre class="brush: bash; title: ; notranslate" title=""># on Linux
/etc/init.d/mysqld stop
# on FreeBSD
/usr/local/etc/rc.d/mysql-server stop
killall -9 mysqld
</pre> 然後進入 MySQL 安全模式 

<pre class="brush: bash; title: ; notranslate" title="">mysqld_safe -u root --skip-grant-tables &#038;
</pre> 然後利用文字介面修改 MySQL root 密碼 

<pre class="brush: bash; title: ; notranslate" title="">$ mysql -u root -p
> use mysql;
> UPDATE user SET password=password('這裡輸入你的密碼') where user='root';
> FLUSH PRIVILEGES;
> exit;
</pre>

### dump database

<pre class="brush: bash; title: ; notranslate" title="">$ mysqladmin -uroot -p flush-logs
$ mysqldump -B -uroot -p --opt phpbb2 > phpbb2_20020601.sql --databases 或 -B 日後會自動建立該資料庫</pre>

### dump table

<pre class="brush: bash; title: ; notranslate" title="">mysqldump phpbb2 -uroot -p --opt phpbb2_users > phpbb2_users_20020601.sql</pre>

### DB backup 如果另外一台電腦上沒有phpbb2這個DB記得要新增一個 

<pre class="brush: bash; title: ; notranslate" title="">mysql -uroot -p -e "CREATE DATABASE phpbb2"</pre> then mysql phpbb2 -uroot -p < phpbb2_20020601.sql[/code] Reference 

<http://www.study-area.org/tips/mysql_backup.htm>