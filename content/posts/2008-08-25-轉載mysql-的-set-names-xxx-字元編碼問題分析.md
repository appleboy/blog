---
title: '[轉載]MySQL 的 “SET NAMES xxx” 字元編碼問題分析'
author: appleboy
type: post
date: 2008-08-25T10:02:35+00:00
url: /2008/08/轉載mysql-的-set-names-xxx-字元編碼問題分析/
views:
  - 5528
bot_views:
  - 857
dsq_thread_id:
  - 246815544
categories:
  - Linux
  - MySQL
  - php
  - sql
tags:
  - MySQL
  - php
  - sql

---
轉載自: [PHPChina][1] 近來接受 BBT 的培訓，做一個投票系統。系統程式碼倒不是很難，但是我的時間主要花費在了研究字符集和編碼上面。MySQL 和 Apache 兩個系統的編碼（字符集）問題讓我費勁腦筋，吃盡苦頭。網上對這些問題的解決比較零散，比較片面，大部分是提供解決方法，卻不說為什麼。於是我將這幾天收穫總結一下，避免後來者再走彎路。這篇文章對 PHP 編寫有一點幫助（看完你就知道，怎樣讓你的 PHP 程式在大部分空間提供商的伺服器裡顯示正常），但是更多幫助在於網路伺服器的架設和設置。 先說 MySQL 的字符集問題。Windows 下可透過修改 my.ini 內的 

<pre class="brush: bash; title: ; notranslate" title=""># CLIENT SECTION
[mysql]
default-character-set=utf8
# SERVER SECTION
[mysqld]
default-character-set=utf8</pre>

<!--more--> 這兩個字段來更改資料庫的預設字符集。第一個是客戶端預設的字符集，第二個是伺服器端預設的字符集。假設我們把兩個都設為 utf8，然後在MySQL Command Line 裡面輸入 &#8220;show variebles like ‘character%’;”，可看到如下結果： 

<pre class="brush: bash; title: ; notranslate" title="">character_set_client   utf8
character_set_connection    utf8
character_set_database     utf8
character_set_results    utf8
character_set_server   utf8
character_set_system     utf8</pre> 其中的 utf8 隨著我們上面的設置而改動。此時，要是我們透過採用 UTF-8 的 PHP 程式從資料庫裡讀取資料，很有可能是一串 &#8220;?????” 或者是其他亂碼。網上查了半天，解決辦法倒是簡單，在連結資料庫之後，讀取資料之前，先執行一項查詢 &#8220;SET NAMES UTF8″，即在 PHP 裡為 mysql\_query(&#8220;SET NAMES UTF8&#8221;); 即可顯示正常（只要資料庫裡資料的字元正常）。為什麼會這樣？這句查詢 &#8220;SET NAMES UTF8″ 到底是什麼作用？ 到 MySQL 命令行輸入 &#8220;SET NAMES UTF8;&#8221;，然後執行 &#8220;show variables Like &#8216;character%'&#8221;，發現原來為 utf8 的那些變數 &#8220;character\_set\_client”、”character\_set\_connection”、 ”character\_set_results” 的值全部變為 utf8 了，原來是這 3 個變數在搗蛋。 查閱手冊，上面那句等於： 

<pre class="brush: bash; title: ; notranslate" title="">SET character_set_client = utf8;
SET character_set_results = utf8;
SET character_set_connection = utf8;</pre> 看看這 3 個變數的作用： 資料輸入路徑：client → connection → server； 資料輸出路徑：server → connection → results。 換句話說，每個路徑要經過 3 次改變字符集編碼。以出現亂碼的輸出為例，server 裡 utf8 的資料，傳入 connection 轉為 utf8，傳入 results 轉為 utf8，utf-8 頁面又把 results 轉過來。如果兩種字符集不相容，比如 utf8 和 utf8，轉化過程就為不可逆的，破壞性的。所以就轉不回來了。 但這裡要聲明一點，”SET NAMES UTF8″ 作用只是臨時的，MySQL 重啟後就恢復預設了。 接下來就說到 MySQL 在伺服器上的配置問題了。豈不是我們每次對資料庫讀寫都得加上 &#8220;SET NAMESUTF8″，以保證資料傳輸的編碼一致？能不能透過配置 MySQL 來達到那三個變數預設就為我們要想的字符集？手冊上沒說，我在網上也沒找到答案。所以，從伺服器配置的角度而言，是沒辦法省略掉那行程式碼的。 總結：為了讓你的網頁能在更多的伺服器上正常地顯示，還是加上 &#8220;SET NAMES UTF8″ 吧，即使你現在沒有加上這句也能正常瀏覽。 問題多多，多謝指正！ 參考網頁 1. 

[PHPChina: Apache和PHP網頁的編碼問題分析][2] 2. MySQL: [Character Set Support][3]

 [1]: http://www.phpchina.com/bbs/viewthread.php?tid=13861
 [2]: http://www.phpchina.com/bbs/thread-13860-1-1.html
 [3]: http://dev.mysql.com/doc/refman/5.0/en/charset.html