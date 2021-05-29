---
title: '[FC4] 限制connection 連線數目「架設war3伺服器」'
author: appleboy
type: post
date: 2006-09-24T23:58:32+00:00
url: /2006/09/fc4-限制connection-連線數目「架設war3伺服器」/
views:
  - 2959
bot_views:
  - 778
dsq_thread_id:
  - 247370764
categories:
  - FreeBSD
  - Linux
  - www
tags:
  - FreeBSD
  - Linux
  - mrtg
  - snmp

---
fc4作業系統 預設 有連線數目的限制 還有使用者連線的限制 不過解決方法很容易 [http://www.ithome.com.tw/plog/index.php?op=ViewArticle&articleId=761&blogId=131][1] 我查到的解決方式 我改完之後如下 

> core file size (blocks, -c) 0 data seg size (kbytes, -d) unlimited file size (blocks, -f) unlimited pending signals (-i) 16255 max locked memory (kbytes, -l) 32 max memory size (kbytes, -m) unlimited open files (-n) 819200 pipe size (512 bytes, -p) 8 POSIX message queues (bytes, -q) 819200 stack size (kbytes, -s) 10240 cpu time (seconds, -t) unlimited max user processes (-u) 102400 virtual memory (kbytes, -v) unlimited file locks (-x) unlimited ulimit：顯示（或設定）用戶可以使用的資源限制 ulimit -a 顯示用戶可以使用的資源限制 ulimit unlimited 不限制用戶可以使用的資源，但本設定對可打開的最大文件數（max open files） 和可同時執行的最大進程數（max user processes）無效 ulimit -n <可以同時打開的檔案數> 設定用戶可以同時打開的最大檔案數（max open files） 例如：ulimit -n 8192 如果本參數設定過小，對於併發訪問量大的網站，可能會出現too many open files的錯誤 ulimit -u <可以執行的最大併發進程數> 設定用戶可以同時執行的最大進程數（max user processes） 例如：ulimit -u 1024

 [1]: http://www.ithome.com.tw/plog/index.php?op=ViewArticle&articleId=761&blogId=131 "http://www.ithome.com.tw/plog/index.php?op=ViewArticle&articleId=761&blogId=131"