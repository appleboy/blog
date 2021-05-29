---
title: '[FreeBSD筆記] 快速搜尋 ports 軟體 psearch'
author: appleboy
type: post
date: 2009-01-04T13:41:54+00:00
url: /2009/01/freebsd筆記-快速搜尋-ports-軟體/
views:
  - 4945
bot_views:
  - 732
dsq_thread_id:
  - 246895998
categories:
  - FreeBSD
  - www
tags:
  - FreeBSD
  - ports

---
在 [FreeBSD][1] 內建的搜尋 [ports][2] 指令搜尋速度有點慢，加上搜尋出來還蠻難找的，所以推薦一個搜尋 ports 軟體：[psearch][3]，支援 regular expression 安裝方式： 

<pre class="brush: bash; title: ; notranslate" title="">#
# ports 安裝
#
cd /usr/ports/ports-mgmt/psearch
make install clean
rehash;</pre> 使用方法： 

<pre class="brush: bash; title: ; notranslate" title="">options:
  -V, --version        顯示版本資訊
  -h, --help           顯示 help 資訊
  -c CATEGORY, --category=CATEGORY
                       快速搜尋方式，可以指定資料夾，例如：www，chinese
  -f FILE, --file=FILE 指定 INDEX 的檔案 Default: "/usr/ports/INDEX-7"
  -l, --long           顯示詳細的 ports 資訊介紹
  -m, --maintainer     取代 ports 的簡短訊息，顯示維護者資訊
                       也可以搜尋 ports 的維護者所有維護的 ports
  -n, --name           顯示標準的訊息，基本的版本訊息
  -o, --or             搜尋任何符合 PATTERN 的 ports 資訊
  -s, --search_long    顯示 ports 詳細的資訊，速度較慢
  -v INVERSE_PATTERN, --inverse=INVERSE_PATTERN
                       反向搜尋 ports 名稱</pre>

<!--more--> 範例： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 搜尋  appleboy 維護者所有 ports
#
psearch -m appleboy
#
#  搜尋指定 www 資料夾 apache 名稱，但是不包含 p5
#
psearch -c www -n apache -v p5
#
# 搜尋 apache 顯示全部維護者 email
#
psearch -m -n apache</pre>

 [1]: http://www.freebsd.org/
 [2]: http://www.freebsd.org/ports/
 [3]: http://www.freebsd.org/cgi/cvsweb.cgi/ports/ports-mgmt/psearch/