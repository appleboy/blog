---
title: '[Linux&FreeBSD] Find 指令用法教學'
author: appleboy
type: post
date: 2009-01-13T06:35:59+00:00
url: /2009/01/linuxfreebsd-find-指令用法教學/
views:
  - 20011
bot_views:
  - 3489
dsq_thread_id:
  - 246847248
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - Linux

---
筆記一下自己常用的 [find][1] 指令，適用於 [FreeBSD][2] 或者是 [Linux][3] 各大 distribution，系統管理這個指令就相當重要了，在搭配 grep，sed，awk，perl 可以快速找到自己要的檔案。我自己本身很常用到 grep，find，awk 這些撰寫 shell script。 底下先來介紹一下 find： 1. 找出 . 底下的 php 檔案 

<pre class="brush: bash; title: ; notranslate" title="">#
#
find . -name "*.php"</pre> 2. 找出 . 底下非 php 副檔名檔案 

<pre class="brush: bash; title: ; notranslate" title="">#
#
find . -not -name "*.php"</pre>

<!--more--> 3. 刪除 . 底下 php 檔案，有兩種作法 

<pre class="brush: bash; title: ; notranslate" title="">#
# 系統詢問之後才刪除
# 先把 -exec 後面的東西先清掉， 用 -print 來先確認輸出
# rm 可以多用 -i 的參數來加以確認
find . -name "*.php" -exec rm -i {} \;
#
# 系統直接刪除
find . -delete -name "*.php"
find . -name "*.php" | xargs /bin/rm -rf</pre> 4. 如何刪除 7 天前之料呢？ 

<pre class="brush: bash; title: ; notranslate" title="">find /path_name -type f -mtime +7 -exec rm '{}' \;
find /path_name -type f -mtime +7  | xargs /bin/rm -rf
find /path_name -delete -type f -mtime +7</pre> 5. 找出7天以內修改的資料 

<pre class="brush: bash; title: ; notranslate" title="">#
#
find . -type f -mtime -7 -name "*.php"</pre> 6. find 後只顯示目錄名稱不顯示路徑 

<pre class="brush: bash; title: ; notranslate" title="">find . -maxdepth 1 -type d  -exec basename {} \;
find . -maxdepth 1 -type d | awk -F"/" '{print $NF}'
find . -maxdepth 1 -type d | sed 's!.*\/\([^\/]*\).*!\1!g'</pre> 7. find 後只顯示目錄名稱不顯示路徑，也不顯示第一個 . 目錄 

<pre class="brush: bash; title: ; notranslate" title="">#
#
find . -maxdepth 1 -mindepth 1 -type d -exec basename {} \;</pre> 8. -mmin (minutes) or -mtime (24 hour periods, starting from now) For example: 

<pre class="brush: bash; title: ; notranslate" title="">find . -mtime 0   # find files modified between now and 1 day ago
                  # (i.e., within the past 24 hours)
find . -mtime -1  # find files modified less than 1 day ago
                  # (i.e., within the past 24 hours, as before)
find . -mtime 1   # find files modified between 24 and 48 hours ago
find . -mtime +1  # find files modified more than 48 hours ago

find . -mmin +5 -mmin -10 # find files modifed between
                          # 6 and 9 minutes ago</pre> 參考資料 http://content.hccfl.edu/pollock/Unix/FindCmd.htm http://www.linux.ie/newusers/beginners-linux-guide/find.php

 [1]: http://linux.about.com/od/commands/l/blcmdl1_find.htm
 [2]: http://www.freebsd.org
 [3]: http://en.wikipedia.org/wiki/Linux