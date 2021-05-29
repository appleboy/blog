---
title: '[PHP]解決網站被 SQL injection 攻擊'
author: appleboy
type: post
date: 2008-06-26T08:26:51+00:00
url: /2008/06/php解決網站被-sql-injection-攻擊/
views:
  - 9036
bot_views:
  - 1182
dsq_thread_id:
  - 246746674
categories:
  - MySQL
  - php
  - sql
  - www
tags:
  - MySQL
  - php
  - sql

---
其實這個安全性的問題，在目前台灣網站都存在這樣的問題，大家平常用 $\_POST，$\_GET 用得很順利，但是沒有想過帳號密碼被 SQL injection 破解，當網站被破解了，基本上你損失就是相當嚴重，網路上也有很多攻擊方式，不過這方法是最常被拿出來講的，我自己有一套解決方式，除了比較重要的地方，就是輸入帳號密碼的地方要加強防護之外，加上數字驗證碼，還要 check 帳號的特性，我底下是我驗證帳號密碼機制 

<pre class="brush: php; title: ; notranslate" title="">if($user_name == '' || $user_passwd == ''){
    	ErrMsg("帳號或密碼不得空白");
    }
    if (!preg_match('/^\w+$/', $user_name)){
    	ErrMsg("請勿攻擊本站台");
    }</pre>

<!--more--> 上面可以解決帳號只能輸入數字加上英文，然後底下在過濾很多特殊字元加上 

[addslashes][1] 或者是用 [mysql\_escape\_string()][2] 

<pre class="brush: php; title: ; notranslate" title="">if( !get_magic_quotes_gpc() )
{
	if( is_array($_GET) )
	{
		while( list($k, $v) = each($_GET) )
		{
			if( is_array($_GET[$k]) )
			{
				while( list($k2, $v2) = each($_GET[$k]) )
				{
					$_GET[$k][$k2] = addslashes($v2);
				}
				@reset($_GET[$k]);
			}
			else
			{
				$_GET[$k] = addslashes($v);
			}
		}
		@reset($_GET);
	}

	if( is_array($_POST) )
	{
		while( list($k, $v) = each($_POST) )
		{
			if( is_array($_POST[$k]) )
			{
				while( list($k2, $v2) = each($_POST[$k]) )
				{
					$_POST[$k][$k2] = addslashes($v2);
				}
				@reset($_POST[$k]);
			}
			else
			{
				$_POST[$k] = addslashes($v);
			}
		}
		@reset($_POST);
	}

	if( is_array($_COOKIE) )
	{
		while( list($k, $v) = each($_COOKIE) )
		{
			if( is_array($_COOKIE[$k]) )
			{
				while( list($k2, $v2) = each($_COOKIE[$k]) )
				{
					$_COOKIE[$k][$k2] = addslashes($v2);
				}
				@reset($_COOKIE[$k]);
			}
			else
			{
				$_COOKIE[$k] = addslashes($v);
			}
		}
		@reset($_COOKIE);
	}
}</pre> 上面那段，可以避免利用特殊字元做 SQL injection 攻擊，這部份程式碼是我去 trace 

[PHPBB2][3] code 裡面寫的^^。

 [1]: http://tw2.php.net/manual/en/function.addslashes.php
 [2]: http://tw2.php.net/manual/en/function.mysql-escape-string.php
 [3]: http://www.phpbb.com/