---
title: PHP+MySQL 環境下 SQL Injection 攻防戰
author: appleboy
type: post
date: 2009-12-06T05:11:25+00:00
url: /2009/12/phpmysql-環境下-sql-injection-攻防戰/
views:
  - 8806
bot_views:
  - 412
dsq_thread_id:
  - 246789494
categories:
  - php
  - sql
tags:
  - php

---
在 [OurMySQL Blog][1] 看到這篇：『[PHP+MySQL环境下SQL Injection攻防总结][2]』寫的相當不錯，裡面有一些觀念，可以讓初學 PHP & MySQL 的使用者知道如何防護 [SQL Injection (資料隱碼)][3]，內容提到 [magic\_quotes\_gpc][4] 在 on 跟 off 的狀況如何防護，但是可以清楚看到 [PHP][5] 官方文件提到在 PHP 5.3.0 magic\_quotes\_gpc 預設已經是關閉，在 PHP 6.0 之後正式移除，所以內容寫的 magic\_quotes\_gpc 狀況，可以大致上瞭解就好，真正防護 SQL Injection 是需要寫程式或者是考慮很多方式去防護。 一般在做文章查詢，都會使用 <span style="color: #008000;">/articles.php?id=123</span> 網址傳送方式，以 $_GET['id'] 送到 PHP 頁面去做處理，如果駭客想要測試是否可以利用 SQL Injection 做攻擊，可以在網址列加上 <span style="color: #008000;">/articles.php?id=123</span><span style="color: #ff0000;">'</span>，請注意網址後面多出 <span style="font-size:11pt;color: #ff0000;">'</span>，如果沒有把 $_GET['id'] 做處理的話，就會出現底下錯誤訊息： 

> <span style="color: #ff0000;">supplied argument is not a valid MySQL result resource in</span> 這是因為平常在寫 SQL 語法，會是底下這種寫法： 

<pre class="brush: php; title: ; notranslate" title="">$sql = "SELECT id, title, content FROM articles WHERE id = '".$_GET['id']."'";
$result = mysq_query($sql);</pre> 因為沒有處理跳脫字元 '，所以造成 SQL 語法錯誤，才會出現該錯誤訊息，但是如果又針對跳脫字元做防護得時候，還有另一種攻擊方式： 

> <span style="color: #008000;">/articles.php?id=0 union select 1,2,load_file(char(47,101,116,99,47,112,97,115,115,119,100))</span> 其中的數字就是/etc/passwd 字符串的ASCII，除此之外，還可以使用字串 16 進位方式： 

> <span style="color: #008000;">/articles.php?id=0 union select 1,2,load_file(0×2f6574632f706173737764)</span> 可以參考一下 [MySQL LOAD\_FILE(file\_name)][6]，底下文章提到了很多方式解決。 <!--more--> 1：字串過濾可以使用 

[intval][7]，[floatval][8]、或者是 [settype][9] 等函式來處理。 2：MySQL 執行 SQL command 的時候，一律用 mysql\_real\_escape_string 方式過濾字串 3：選擇一套好的處理 MySQL Query 的套件，盡量不要自己寫，可以參考各大 Open Source, ex: [phpBB][10]、[PDO][11] 的 prepare 處理 4：使用 [apache mod_rewrite][12] 功能，將網址隱藏，或者是編碼 5：將錯誤提示關閉：display_errors=off，不過個人不建議這個做啦。 6：MySQL 權限設定，不要將有 File 權限(ex: root)的使用者設定在網站使用。 針對第二點寫一個 PHP 過濾： 

<pre class="brush: php; title: ; notranslate" title="">if( is_array($_POST) && !get_magic_quotes_gpc())
{
	while( list($k, $v) = each($_POST) )
	{
		$$k = mysql_real_escape_string(trim($v));
	}
	@reset($_POST);
}</pre>

<pre class="brush: php; title: ; notranslate" title="">function set_var(&$result, $var, $type, $multibyte = false)
{
	settype($var, $type);
	$result = $var;
  
	if ($type == 'string')
	{
		$result = trim(htmlspecialchars(str_replace(array("\r\n", "\r", "\0"), array("\n", "\n", ''), $result), ENT_COMPAT, 'UTF-8'));
		if (!empty($result))
		{
			// Make sure multibyte characters are wellformed
			if ($multibyte)
			{
				if (!preg_match('/^./u', $result))
				{
					$result = '';
				}
			}
			else
			{
				// no multibyte, allow only ASCII (0-127)
				$result = preg_replace('/[\x80-\xFF]/', '?', $result);
			}
		}

		$result = (STRIP) ? stripslashes($result) : $result;
	}
	
}</pre>

 [1]: http://www.ourmysql.com/
 [2]: http://www.ourmysql.com/archives/791
 [3]: http://en.wikipedia.org/wiki/SQL_injection
 [4]: http://tw2.php.net/manual/en/info.configuration.php#ini.magic-quotes-gpc
 [5]: http://tw2.php.net/
 [6]: http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_load-file
 [7]: http://tw2.php.net/manual/en/function.intval.php
 [8]: http://tw2.php.net/manual/en/function.floatval.php
 [9]: http://tw2.php.net/manual/en/function.settype.php
 [10]: http://www.phpbb.com/
 [11]: http://tw2.php.net/manual/en/book.pdo.php
 [12]: http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html