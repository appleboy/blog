---
title: CodeIgniter Error Handler 處理
author: appleboy
type: post
date: 2013-02-01T02:54:37+00:00
url: /2013/02/codeigniter-error-handler/
dsq_thread_id:
  - 1058198560
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - Error
  - php

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div>

<a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> 在處理 PHP Error handler 是直接呼叫內建的 Exceptions Class 顯示在瀏覽器上，如果有打開 log，系統另外會紀錄在 **<span style="color:green">application/logs</span>** 目錄。這是 CodeIgniter 預設作法，但是我希望能把這些錯誤訊息都紀錄到 Database，相關 Notice, Error 訊息都一律寫到 DB 裡面，但是如果用 extend 系統內的 Exceptions 是完全做不到的，所以我寫了一個 Library 只要直接 include 系統就可以直接開始紀錄，因為在 PHP 你會遇到無數種 User experience，都會產生相關錯誤訊息，在產品上線都會將 **<span style="color:red">display_errors</span>** 設定為 0，不要讓使用者看到任何錯誤訊息，但是我們還是需要全部的錯誤訊息阿，底下來看看如何安裝 Log Library。 

### 建立 log table 可以直接參考

<a href="https://github.com/appleboy/CodeIgniter-Log-Library/blob/master/sql/mysql.sql" target="_blank">連結</a>，或者是複製底下資料貼到 phpMyAdmin。 

<pre class="brush: sql; title: ; notranslate" title="">--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `errno` int(2) NOT NULL,
  `errtype` varchar(32) CHARACTER SET utf8 NOT NULL,
  `errstr` text CHARACTER SET utf8 NOT NULL,
  `errfile` varchar(255) CHARACTER SET utf8 NOT NULL,
  `errline` int(4) NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;</pre>

<!--more-->

### 安裝 如果你熟悉 

<a href="http://getsparks.org/" target="_blank">CodeIgniter getsparks</a>，可以透過 command line 安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ php tools/spark install -v1.0.0 codeigniter-log</pre> 那也可以透過複製檔案的方式安裝: 

<pre class="brush: bash; title: ; notranslate" title="">$ cp config/log.php your_application/config/
$ cp libraries/Lib_log.php your_application/libraries/
$ cp controllers/example.php your_application/controllers/</pre>

### 使用方式 如果是透過 getsparks 安裝，請將底下程式碼寫到 

**<span style="color:green">__construct function</span>** 裡面 

<pre class="brush: php; title: ; notranslate" title="">$this->load->spark('codeigniter-log/1.0.0');</pre> 如果是手動安裝，請改成底下 

<pre class="brush: php; title: ; notranslate" title="">$this->load->library('lib_log');</pre> 接著可以在程式碼任何地方紀錄您要的錯誤訊息 

<pre class="brush: php; title: ; notranslate" title="">trigger_error("User error via trigger.", E_USER_ERROR);
trigger_error("Warning error via trigger.", E_USER_WARNING);
trigger_error("Notice error via trigger.", E_USER_NOTICE);</pre> 可以參考 

<a href="https://github.com/appleboy/CodeIgniter-Log-Library/blob/master/controllers/example.php" target="_blank">Example</a> Screenshot:<img src="https://i2.wp.com/farm9.staticflickr.com/8077/8431391071_7970f8fc05_c.jpg?w=600&#038;ssl=1" alt="" data-recalc-dims="1" /> 如果有任何問題，可以參考 <a href="https://github.com/appleboy/CodeIgniter-Log-Library" target="_blank">Github 專案</a> 或 getspark