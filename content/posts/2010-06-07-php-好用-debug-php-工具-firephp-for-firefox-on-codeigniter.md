---
title: '[PHP] 好用 Debug PHP 工具 FirePHP for FireFox on CodeIgniter'
author: appleboy
type: post
date: 2010-06-07T11:30:56+00:00
url: /2010/06/php-好用-debug-php-工具-firephp-for-firefox-on-codeigniter/
views:
  - 6619
bot_views:
  - 400
dsq_thread_id:
  - 246772261
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - Firefox
  - FirePHP
  - php

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i0.wp.com/www.firephp.org/images/FirePHP_Large_White.png?w=840" alt="FirePHP" data-recalc-dims="1" />
</div> 之前介紹過 javascript FireFox Debug 工具 

[FireBug][1] ([Using firebug for firefox 除錯 javascript][2])，今天來介紹 PHP 除錯工具 [FirePHP][3]，它可以輸出 PHP 資料到 FireBug console 介面，方便解決 PHP 相關問題，而不會去影響線上網站的畫面，安裝方式非常簡單，請先安裝 [FireFox addon for FirePHP][4]，重新啟動 FireFox 這樣就安裝成功了，接下來就是 include FirePHP Library 檔案，就可以正常使用了。另外還會介紹如何安裝到 [CodeIgniter PHP Framework][5] Firebug: <https://addons.mozilla.org/en-US/firefox/addon/1843> FirePHP: <https://addons.mozilla.org/en-US/firefox/addon/6149> 底下先看畫面： 

<pre class="brush: php; title: ; notranslate" title="">$array = array("a" => "1", "b" => "2");
$firephp->info($array, "info");
$firephp->warn($array, "warn");
$firephp->error($array, "error");</pre>

[<img src="https://i0.wp.com/farm5.static.flickr.com/4072/4677599187_64c5568b73_o.png?resize=444%2C200&#038;ssl=1" alt="FirePHP" data-recalc-dims="1" />][6] 

## Install FirePHP 安裝 Ref : 

<http://www.firephp.org/HQ/Install.htm> 在 Zend Framework 已經有開發完成，可以參考：[FirePHP and Zend Framework 1.6][7] 下載檔案：[Download FirePHPCore library version 0.3.1][8] 

## unzip FirePHP (解壓縮) 您會發現 FirePHPCore 底下有四個檔案，其中 fb.php && FirePHP.class.php 給 PHP 5 用的，另外兩個 fb.php4 && FirePHP.class.php4 則是給 PHP 4 專屬，本文只會以 PHP 5 當作範例。 

## include FirePHP file 新增一個 index.php 檔案，在最上面寫入： 

<pre class="brush: php; title: ; notranslate" title="">require_once('FirePHPCore/FirePHP.class.php');</pre>

## Start output buffering 假設您在 php.ini 有設定 

[output_buffering][9] 為 on，就可以省略此步驟 

<pre class="brush: php; title: ; notranslate" title="">ob_start();</pre>

## 測試完整檔案

<pre class="brush: php; title: ; notranslate" title=""><?
require_once('FirePHPCore/FirePHP.class.php');
ob_start();
$var = array('i'=>10, 'j'=>20);
$firephp = FirePHP::getInstance(true); 
$firephp->log($var, 'WARN');
?></pre> FirePHP 預設是啟動的，如果您要將此關閉，可以使用底下程式碼將其關閉： 

<pre class="brush: php; title: ; notranslate" title="">/**
   * Enable and disable logging to Firebug
   * 
   * @param boolean $Enabled TRUE to enable, FALSE to disable
   * @return void
   */
$firephp->setEnabled(false);</pre> 也可以自訂選項： 

<span style="color:green">maxObjectDepth</span> 顯示 object 資料深度 <span style="color:green">maxArrayDepth</span> 顯示 array 資料深度 <span style="color:green">useNativeJsonEncode</span> 設定為 false 就是代表使用 FirePHPCore 內建 JSON encoder 來取代 PHP 內建 json_encode()。 <span style="color:green">includeLineNumbers</span> 顯示檔案名稱以及行號資訊 

<pre class="brush: php; title: ; notranslate" title="">// Defaults:
$options = array('maxObjectDepth' => 10,
                 'maxArrayDepth' => 20,
                 'useNativeJsonEncode' => true,
                 'includeLineNumbers' => true);</pre>

&nbsp;

# Install FirePHP on CodeIgniter 1. move 

<span style="color:red">fb.php</span> and <span style="color:red">FirePHP.class.php</span> into <span style="color:green">system/application/libraries</span> directory. 2. rename <span style="color:red">FirePHP.class.php</span> to <span style="color:green">Firephp.php</span>, and <span style="color:red">fb.php</span> to <span style="color:green">Fb.php</span>. 3. edit <span style="color:green">Firephp.php</span> file. 

<pre class="brush: php; title: ; notranslate" title="">#
# Find  
#
<?php
#
# Replace
#
if ( ! defined('BASEPATH')) exit('No direct script access allowed');
[/code]

edit <span style="color:green">Fb.php file</span>

#
# Find  
#


<?php
#
# Replace
#
if ( ! defined('BASEPATH')) exit('No direct script access allowed');
[/code]

Edit <span style="color:green">config/autoload.php</span> file

#
# Find
#
$autoload['libraries'] = array();
#
# Replace
#
$autoload['libraries'] = array("firephp", "fb");
</pre>

### How to use it?

<pre class="brush: php; title: ; notranslate" title="">function index()
{
  $a = "test";
  $array = array("a" => "1", "b" => "2");		
  //$this->firephp->log($a, 'ERROR');
  //$this->firephp->log($a, 'ERROR');    
  $this->fb->setEnabled(true);    
  $this->fb->info($array, "info");
  $this->fb->warn($array, "warn");
  $this->fb->error($array, "error");
  $this->fb->group('Test Group');
  $this->fb->log('Hello World');
  $this->fb->groupEnd();
}
</pre>

 [1]: http://getfirebug.com/
 [2]: http://blog.wu-boy.com/2010/01/05/1943/
 [3]: http://www.firephp.org/
 [4]: https://addons.mozilla.org/en-US/firefox/addon/6149/
 [5]: http://codeigniter.com/
 [6]: https://www.flickr.com/photos/appleboy/4677599187/ "Flickr 上 appleboy46 的 FirePHP"
 [7]: http://www.christophdorn.com/Blog/2008/09/02/firephp-and-zend-framework-16/
 [8]: http://www.firephp.org/DownloadRelease/FirePHPLibrary-FirePHPCore-0.3.1
 [9]: http://us.php.net/manual/en/outcontrol.configuration.php#ini.output-buffering