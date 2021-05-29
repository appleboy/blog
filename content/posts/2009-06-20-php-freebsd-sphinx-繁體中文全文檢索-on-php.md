---
title: '[PHP] FreeBSD Sphinx 繁體中文全文檢索 on PHP'
author: appleboy
type: post
date: 2009-06-20T05:10:32+00:00
url: /2009/06/php-freebsd-sphinx-繁體中文全文檢索-on-php/
views:
  - 16450
bot_views:
  - 873
dsq_thread_id:
  - 246729440
categories:
  - FreeBSD
  - php
tags:
  - FreeBSD
  - php
  - sphinx

---
[<img class="alignleft size-full wp-image-1467" title="sphinx" src="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2009/06/sphinx.jpg?resize=200%2C51" alt="sphinx" data-recalc-dims="1" />][1] 最近想說幫之前替代役單位來把全文檢索的中文部份搞定，所以找了一些全文檢索的 open source，挑了這套網路上評價還不錯的 [Sphinx][1]，目前 Sphinx 支援的作業系統如下： 

  * Linux 2.4.x, 2.6.x (various distributions)
  * Windows 2000, XP
  * FreeBSD 4.x, 5.x, 6.x
  * NetBSD 1.6, 3.0
  * Solaris 9, 11
  * Mac OS X 雖然上面寫 FreeBSD 只支援到 6.X，但是我測試是在 FreeBSD 7.1-RELEASE-p6 的環境，所以相當 ok 的，底下是我安裝在 FreeBSD 的心得筆記，PHP 官網上面有支援 

[Search Engine Extensions][2] 的介紹，包含了 [mnoGoSearch][3]、[Sphinx][4] — Sphinx Client、[Swish][5] — Swish Indexing，可以利用 pecl 來安裝 Sphinx，目前版本：0.9.9-rc1。 <!--more--> 1. FreeBSD ports 安裝： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/textproc/sphinxsearch-devel; make install clean
#
# 把 MySQL 勾選起來</pre> 2. 讓 php 支援 Sphinx 套件 

<pre class="brush: bash; title: ; notranslate" title="">#
# 先下載官方網站 Sphinx sphinx-0.9.8.1.tar.gz
wget http://www.sphinxsearch.com/downloads/sphinx-0.9.8.1.tar.gz
#
# 解壓縮之後進入 sphinx/api/libsphinxclient/
./buildconf.sh && ./configure && make install</pre> 做上面步驟是確保 pecl 安裝 sphinxclient 所需要的 library sphinxclient.c 或者是 sphinxclient.h，必須放在 /usr/local/include 裡面，最後就可以用 pecl 指令安裝： 

<pre class="brush: bash; title: ; notranslate" title="">pecl install sphinx</pre> 3.接下來修改 php.ini 加入： 

<pre class="brush: bash; title: ; notranslate" title="">extension=sphinx.so</pre> 不過你也可以不用裝 sphinx client 的部份，因為官網友提供 php 的 sphinx Class 讓您使用，你打開了 sphinx.so 就會衝突重複定義。 4. 修改 /usr/local/etc/sphinx.conf 設定檔，那底下是我目前設定： 

<pre class="brush: bash; title: ; notranslate" title="">source src1
{
	type					= mysql
	sql_host				= localhost
	sql_user				= root
	sql_pass				= xxxxxxxxxxxxxxxxx
	sql_db					= dar
	sql_port				= 3306	# optional, default is 3306
	sql_query_pre			= SET NAMES utf8
	sql_query = \
	    SELECT  rid, groupNum, itemNum, itemName, volName, collecNum \
	    FROM th_series
	
	sql_ranged_throttle	= 0
	sql_query_info		= SELECT * FROM  th_series WHERE rid=$id
}
source src1throttled : src1
{
	sql_ranged_throttle			= 100
}
index test1
{
	source			= src1
	path			= /var/db/sphinxsearch/data/test1
	docinfo			= extern 
	mlock			= 0
	morphology		= none
	min_word_len		= 1
	charset_type		= utf-8
	min_infix_len		= 1
	ngram_len				= 1
	html_strip				= 0
}
index dist1
{
	type				= distributed
	local				= test1
	local				= test1stemmed
	agent				= localhost:3313:remote1
	agent				= localhost:3314:remote2,remote3
	agent_connect_timeout	= 1000
	agent_query_timeout		= 3000
}
indexer
{
	mem_limit			= 256M
}
searchd
{
	listen				= 0.0.0.0
	listen				= 3312
	log					= /var/log/searchd.log
	query_log			= /var/log/sphinx-query.log
	read_timeout		= 5
	client_timeout		= 300
	max_children		= 300
	pid_file			= /var/run/sphinxsearch/searchd.pid
	max_matches			= 10000
}
</pre> 注意：charset\_type 必須改為 utf-8，然後必須加上 charset\_table 跟 ngram_chars 這樣中文檢索就沒有問題了，可以參考 ihower 這篇：

[全文搜尋 Sphinx on Rails][6]，官方討論區有人問過：[full-text searching in Chinese document.][7] 此篇務必看過，對中文搜尋有很大的幫助。 5. 建立索引： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 針對 test1 索引
/usr/local/bin/indexer test1
#
# 全部索引
/usr/local/bin/indexer --all</pre> 6. 查詢： 

<pre class="brush: bash; title: ; notranslate" title="">#
# -i 針對 test1 索引搜尋，-l 1 顯示一筆資料
search -i test1 -l 1 "臺灣"</pre>

[<img src="https://i0.wp.com/farm4.static.flickr.com/3380/3642442931_aac75b16af.jpg?resize=500%2C294&#038;ssl=1" title="sphinx_search (by appleboy46)" alt="sphinx_search (by appleboy46)" data-recalc-dims="1" />][8] 7. 架設 sphinx 伺服器： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 建立 4567 port 索引伺服器
searchd --console --nodetach --port 4567 -i test1</pre> listen 0.0.0.0 跟 port 4567，提供 php 做查詢動作。 詳細更多設定可以參考 

[Sphinx 0.9.9 reference manual][9] 或者是中文：[sphinx search中文][10]

 [1]: http://sphinxsearch.com/
 [2]: http://tw.php.net/manual/en/refs.search.php
 [3]: http://tw.php.net/manual/en/book.mnogosearch.php
 [4]: http://tw.php.net/manual/en/book.sphinx.php
 [5]: http://tw.php.net/manual/en/book.swish.php
 [6]: http://ihower.idv.tw/blog/archives/1716
 [7]: http://www.sphinxsearch.com/forum/view.html?id=587
 [8]: https://www.flickr.com/photos/appleboy/3642442931/ "sphinx_search (by appleboy46)"
 [9]: http://sphinxsearch.com/docs/current.html
 [10]: http://www.sphinxsearch.org/