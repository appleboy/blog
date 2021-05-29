---
title: '[FreeBSD] send-pr porter committer 需要注意事項'
author: appleboy
type: post
date: 2009-09-22T14:03:56+00:00
url: /2009/09/freebsd-send-pr-committer-需要注意事項/
views:
  - 10138
bot_views:
  - 730
dsq_thread_id:
  - 255537158
categories:
  - FreeBSD
tags:
  - FreeBSD
  - ports
  - send-pr

---
[<img src="https://i2.wp.com/farm3.static.flickr.com/2495/3944776064_38690ab101.jpg?resize=457%2C75&#038;ssl=1" title="logo-red (by appleboy46)" alt="logo-red (by appleboy46)" data-recalc-dims="1" />][1] 來紀錄一下最近使用 [send-pr][2] 的心得，send-pr 就是提交問題 problem report (PR) 到 [FreeBSD][3] Support 中心，您也可以透過 send-pr 發送新的 ports 給 FreeBSD 中心，最近 [CodeIgniter][4] V1.7.2 的 Release，所以把 CI 的 patch 送給中心並且 CC 給 maintainer，/usr/bin/send-pr 這支 shell script 在 FreeBSD 用處可多了，不單只是 ports 的問題，也有 www, i386, ia64 的問題，都可以透過它回報給總部喔。 要瞭解 ports 怎麼產生，或者是怎麼製作 patch 都可以參考 [FreeBSD Porter's Handbook][5]，文件是英文的，請大家多多包含，不過還是有[中文的文件][6]，通常 patch 是還蠻簡單的，底下紀錄我做的步驟，以及如何測試 ports 正確性。其實步驟不難啦。 <!--more--> 首先您要先把 ports 複製到別的地方 # 複製到自己的目錄 

<pre class="brush: bash; title: ; notranslate" title="">cp -R /usr/ports/www/codeigniter .</pre> # 切換目錄 cd codeigniter # 改版本資訊，或者是修正 Makefile 

<pre class="brush: bash; title: ; notranslate" title="">PORTVERSION=    1.7.1 -> 1.7.2 </pre> # 修正 checksum file，自動改變 distinfo，

[參考這裡][7] 

<pre class="brush: bash; title: ; notranslate" title="">make makesum</pre> # 修正 pkg-plist 這還蠻重要的，可以

[參考這裡][8]，過程還蠻複雜的，產生目錄檔案結構。如何測試 port 正確性 先裝 [ports-mgmt/portlint][9]，用來檢查 Makefile 正確性 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/ports-mgmt/portlint; make install clean</pre> 裝好之後，就可以使用下面指令： 

<pre class="brush: bash; title: ; notranslate" title="">portlint -a
cd  .. ; diff -ruN xxx.orig xxx > ~/xxx.diff
send-pr -a ~/xxx.diff -c 長輩的e-mail</pre> 測試變數的方法，可以在終端機打入 

<pre class="brush: bash; title: ; notranslate" title="">make -V XXXXX</pre> 來觀看變數是不是有定義，或者是寫錯 

<pre class="brush: bash; title: ; notranslate" title="">port diff # 用來看跟原來 ports 檔案，您修改了多少東西</pre> 還有一篇必看的，就是 committer 怎麼處理送來的 problem:

[Problem Report Handling Guidelines][10]，還有一篇：[Writing FreeBSD Problem Reports][11]

 [1]: https://www.flickr.com/photos/appleboy/3944776064/ "logo-red (by appleboy46)"
 [2]: http://www.freebsd.org/cgi/man.cgi?query=send-pr&sektion=1
 [3]: http://www.freebsd.org
 [4]: http://codeIgniter.com
 [5]: http://www.freebsd.org/doc/en/books/porters-handbook/
 [6]: http://www.freebsd.org/doc/zh_TW/books/porters-handbook/
 [7]: http://www.freebsd.org/doc/en/books/porters-handbook/porting-checksum.html
 [8]: http://www.freebsd.org/doc/en/books/porters-handbook/plist-autoplist.html
 [9]: http://www.freebsd.org/cgi/url.cgi?ports/ports-mgmt/portlint/pkg-descr
 [10]: http://www.freebsd.org/doc/en_US.ISO8859-1/articles/pr-guidelines/article.html
 [11]: http://www.freebsd.org/doc/en_US.ISO8859-1/articles/problem-reports/article.html