---
title: MySQL count(“欄位”) vs mysql_num_rows 速度？
author: appleboy
type: post
date: 2009-03-30T11:28:35+00:00
url: /2009/03/mysql-count欄位-vs-mysql_num_rows-速度？/
views:
  - 12920
bot_views:
  - 674
dsq_thread_id:
  - 246801530
categories:
  - Linux
  - php
tags:
  - MySQL
  - php
  - PHPBB

---
在 FreeBSD ports 裡面還沒看到 chinese/phpbb3 的 ports，目前只有 [chinsan][1] 維護的 [chinese/phpbb-tw ports][2]，之前版本是 2.0.22 版本，後來我 commit 到 2.0.23 版本，不過 PHPBB 官網已經不再維護或者是開發 2.0.X 版本了，現在以 PHPBB3 為版本開發，也針對了 PHP6 跟 PHP 5 的相容性做了很大的改變，所以基本上如果在 2.0.X 版本加了很多外掛，那就沒辦法升級到 phpBB3 版本了，畢竟 code 實在改變太多了，找個時間把 chinese/phpbb3-tw commit 進去，不然也可以到 [www/phpbb3][3] 做安裝。 為什麼會提到 [phpBB][4] 呢，今天在 trace [phpBB3][4] 的 code，發現原本在 phpBB2 裡面有支援 [mysql\_num\_rows][5] function，用來讓程式可以取出 sql 的個數，不過在 [phpBB3][4] 竟然就把這個 function 拿掉了。 phpBB2 mysql4.php 程式： 

<pre class="brush: php; title: ; notranslate" title="">function sql_numrows($query_id = 0)
{
	if( !$query_id )
	{
		$query_id = $this->query_result;
	}

	return ( $query_id ) ? mysql_num_rows($query_id) : false;
}</pre>

<!--more--> 這樣可以利用 $db->sql_numrows 取得回傳個數 

<pre class="brush: php; title: ; notranslate" title="">/*
* 取得 sql 回傳個數
*/
$sql = "SELECT * FROM " . CONFIG_TABLE;
$result = $db->sql_query($sql);
$all_list_count = $db->sql_numrows($result);</pre> 在 phpBB3 變成另外一個作法 

<pre class="brush: php; title: ; notranslate" title="">/*
* 利用 coumt() 來取得個數
*/
$sql = "SELECT COUNT(config_name) AS num_configs FROM " . CONFIG_TABLE;
$result = $db->sql_query($sql);
$all_list_count = (int) $db->sql_fetchfield('num_configs');</pre> 於是我就想比較一下執行的速度：count(*) 

<pre class="brush: php; title: ; notranslate" title="">$sql = "SELECT COUNT(config_name) AS num_configs 
FROM " . CONFIG_TABLE;
$starttime = explode(' ', microtime());
$starttime = $starttime[1] + $starttime[0];
$result = $db->sql_query($sql);
$all_list_count = (int) $db->sql_fetchfield('num_configs');
echo $all_list_count;
$endtime = explode(' ', microtime());
$endtime = $endtime[1] + $endtime[0];
echo $endtime - $starttime;
$db->sql_freeresult($result);</pre> 輸出結果：0.000408172607422 

<pre class="brush: php; title: ; notranslate" title="">$sql = "SELECT *
FROM " . CONFIG_TABLE;
$starttime = explode(' ', microtime());
$starttime = $starttime[1] + $starttime[0];
$result = $db->sql_query($sql);
$row = $db->sql_numrows($result);
echo $row;
$endtime = explode(' ', microtime());
$endtime = $endtime[1] + $endtime[0];
echo $endtime - $starttime;
$db->sql_freeresult($result);</pre> 輸出結果：0.000455141067505 發現利用 count(*) 的速度比較快，這是自己發現的結論啦，至少 

[phpBB3][4] 目前的作法是採用 count(*) 的方式下去解，而並非利用 [mysql\_num\_rows][5] 方式。^^

 [1]: http://chinsan2.twbbs.org/wp/
 [2]: http://www.freshports.org/chinese/phpbb-tw/
 [3]: http://www.freshports.org/www/phpbb3/
 [4]: http://www.phpbb.com/
 [5]: http://tw2.php.net/mysql-num-rows