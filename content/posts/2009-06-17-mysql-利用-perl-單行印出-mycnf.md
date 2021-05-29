---
title: '[MySQL] 利用 perl 單行印出 my.cnf'
author: appleboy
type: post
date: 2009-06-17T13:36:21+00:00
url: /2009/06/mysql-利用-perl-單行印出-mycnf/
views:
  - 7979
bot_views:
  - 531
dsq_thread_id:
  - 253263340
categories:
  - MySQL
tags:
  - MySQL
  - Perl

---
在 [MySQL Performance Blog][1] 裡面發現這篇：[How to pretty-print my.cnf with a one-liner][2]，利用一行 perl 指令把 my.cnf 的註解拿掉： 

<pre class="brush: bash; title: ; notranslate" title="">perl -ne 'm/^([^#][^\s=]+)\s*(=.*|)/ && printf("%-35s%s\n", $1, $2)' /etc/my.cnf</pre> 輸出為： 

<pre class="brush: bash; title: ; notranslate" title="">[client]
port                               = 3306
socket                             = /tmp/mysql.sock
[mysqld]
port                               = 3306
socket                             = /tmp/mysql.sock
skip-locking
key_buffer                         = 256M
max_allowed_packet                 = 1M
table_cache                        = 256
sort_buffer_size                   = 1M
read_buffer_size                   = 1M
read_rnd_buffer_size               = 4M
myisam_sort_buffer_size            = 64M
thread_cache_size                  = 8
query_cache_size                   = 16M
thread_concurrency                 = 8
log-slow-queries                   = /var/log/mysql/mysql-slow.log</pre> 當然同樣的，你也可以利用在 php.ini 或者是其他設定檔上面，提供我平常用 bash 指令來做的，只是沒有經過排版： 

<pre class="brush: bash; title: ; notranslate" title="">cat /usr/local/etc/php.ini | grep -v '^$' | grep -v '^[;]'</pre> 上面同樣的把空白行，以及開頭為 ; 的註解拿掉，同樣是可以做到。

 [1]: http://www.mysqlperformanceblog.com/
 [2]: http://www.mysqlperformanceblog.com/2009/06/15/how-to-pretty-print-mycnf-with-a-one-liner/