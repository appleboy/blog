---
title: WordPress plugin 加強網址 SEO
author: appleboy
type: post
date: 2011-02-21T04:42:34+00:00
url: /2011/02/wordpress-plugin-seo/
views:
  - 253
bot_views:
  - 177
dsq_thread_id:
  - 247304905
categories:
  - php
  - wordpress
tags:
  - php
  - wordpress

---
由於網站 [SEO][1] 在大家心中都是非常重要，現在製作網站也都考慮了很多 SEO 的問題，其中一個功能就是可不可以自訂網址，Wordpress 很早之前就支援了此功能，站長我呢，在創站的時候使用 <span style="color:green"><strong>blog.wu-boy.com/2011/02/17/2542</strong></span>，為了使搜尋引擎更可以快速找到本站，所以打算將網址改成 **<span style="color:green">blog.wu-boy.com/2011/02/php-codeigniter-google-url-shortener-api-library/</span>**，在後台 Permalink Settings 可以自訂部落格網址，將網址格式改成 <span style="color:red"><strong>/%year%/%monthnum%/%postname%/</strong></span>，可是改了之後，之前搜尋引擎及別人引用的網址就會變成 **<span style="color:red">404 NOT Found</span>**，為瞭解決此問題，必須寫一支 Mapping Url 程式，讓之前的舊網址轉到新網址，剛好在 [Roga Blog][2] 找到一篇 [加強部落格的 SEO][3]，提供了轉換的 plugin，底下是該程式碼: 

<pre class="brush: php; title: ; notranslate" title=""><?php
/*
Plugin Name: roga's url hotfix
Plugin URI: http://blog.roga.tw/2011/02/%E5%8A%A0%E5%BC%B7%E9%83%A8%E8%90%BD%E6%A0%BC%E7%9A%84-seo/
Description: redirect http requests.
Version: 0.1
Author: roga
Author URI: http://blog.roga.tw
License: GPL v2
*/

function roga_wrap()
{
	GLOBAL $wpdb;
	$request_uri = getenv('REQUEST_URI');

	$array = explode('/', $request_uri);

	$status = TRUE;

	foreach($array as $row)
	{
		if( ! is_numeric($row) && ! empty($row)) $status = FALSE;
	}

	if(count($array) != 5 || $status != TRUE)
		return NULL;

	$post_id = (int) $array[4]; // http://blog.roga.tw/2011/02/16/2484

	$wp_result = $wpdb->get_row("SELECT `post_type`, `post_name`, `post_date` FROM `$wpdb->posts` WHERE `ID` = $post_id ");

	if( ! isset($wp_result))
		return NULL;

	$post_type = $wp_result->post_type;
	$post_name = $wp_result->post_name;
	$post_date = $wp_result->post_date;

	if($post_type == 'revision')
		return NULL;

	$time = strtotime($post_date);
	$year = date('Y', $time);
	$month = date('m', $time);
	//  old:   /%year%/%monthnum%/%day%/%post_id%
	//  new:   /%year%/%monthnum%/%postname%/
	$new_request_uri = "/$year/$month/$post_name";
	$http_host = getenv('HTTP_HOST');

	$logfile = WP_CONTENT_DIR . "/cache/wp-roga-redirect.log";
	if(file_exists($logfile))
		file_put_contents($logfile, sprintf("[%s] %s -> %s / %s " . PHP_EOL, date_i18n("Y-m-d H:i:s"), $request_uri, urldecode($new_request_uri), getenv('HTTP_USER_AGENT')), FILE_APPEND);

	header("Status: 301 Moved Permanently");
	header("Location: http:/$http_host$new_request_uri");
	exit();
}

add_action('init', 'roga_wrap');
</pre>

<!--more--> Roga 的作法相當容易，先去 parse 原先的 url，比如說本來是 

<span style="color:green"><strong>blog.wu-boy.com/2011/02/17/2542</strong></span>，程式先把 2011/02/17/2542 取出，在利用 array 取得 2542 這個唯一 POST ID，接下來去資料庫找尋該筆資料，把 postname 取出在轉換 Url 即可用 <span style="color:green"><strong>301 Moved Permanently</strong> 告訴搜尋引擎改網址</span>。 在程式最前面發現一個小 bug，今天我們 parse <span style="color:green"><strong>blog.wu-boy.com/2011/02/17/2542</strong></span> 沒問題，假如是此網址呢 <span style="color:green"><strong>blog.wu-boy.com/2011/02/17/2542/</strong></span> 你會發現 WordPress 馬上吐出 <span style="color:red"><strong>404 Not Found</strong></span> 錯誤訊息，原因就是出在 array 的取法，所以我修改了程式，patch 檔如下: 

<pre class="brush: diff; title: ; notranslate" title="">--- url2.php	2011-02-21 11:19:56.000000000 +0800
+++ url.php	2011-02-21 11:20:35.000000000 +0800
@@ -12,8 +12,7 @@
 function roga_wrap()
 {
 	GLOBAL $wpdb;
-	$request_uri = getenv('REQUEST_URI');
-
+	$request_uri = trim(getenv('REQUEST_URI'), '/');
 	$array = explode('/', $request_uri);
 
 	$status = TRUE;
@@ -23,10 +22,9 @@
 		if( ! is_numeric($row) && ! empty($row)) $status = FALSE;
 	}
 
-	if(count($array) != 5 || $status != TRUE)
+	if(count($array) != 4 || $status != TRUE)
 		return NULL;
-
-	$post_id = (int) $array[4]; // http://blog.roga.tw/2011/02/16/2484
+	$post_id = (int) $array[3]; // http://blog.roga.tw/2011/02/16/2484
 
 	$wp_result = $wpdb->get_row("SELECT `post_type`, `post_name`, `post_date` FROM `$wpdb->posts` WHERE `ID` = $post_id ");
 
@@ -51,11 +49,10 @@
 	$logfile = WP_CONTENT_DIR . "/cache/wp-roga-redirect.log";
 	if(file_exists($logfile))
 		file_put_contents($logfile, sprintf("[%s] %s -> %s / %s " . PHP_EOL, date_i18n("Y-m-d H:i:s"), $request_uri, urldecode($new_request_uri), getenv('HTTP_USER_AGENT')), FILE_APPEND);
-
+		
 	header("Status: 301 Moved Permanently");
-	header("Location: http:/$http_host$new_request_uri");
+	header("Location: http://$http_host$new_request_uri");
 	exit();
 }
</pre>

 [1]: http://en.wikipedia.org/wiki/Search_engine_optimization
 [2]: http://blog.roga.tw
 [3]: http://blog.roga.tw/2011/02/%E5%8A%A0%E5%BC%B7%E9%83%A8%E8%90%BD%E6%A0%BC%E7%9A%84-seo/