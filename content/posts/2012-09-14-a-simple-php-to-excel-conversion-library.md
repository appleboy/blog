---
title: 簡易 PHP Excel Generator Library
author: appleboy
type: post
date: 2012-09-14T12:47:15+00:00
url: /2012/09/a-simple-php-to-excel-conversion-library/
dsq_thread_id:
  - 843816661
categories:
  - php
tags:
  - Excel
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div> 因為專案需求，必須將資料庫資料輸出成簡易 Excel 檔案，如果要用 PHP 取裡 Excel 文件，我想大家首推一定是 

<a href="http://phpexcel.codeplex.com/" target="_blank">PHPExcel</a>，不管你要對 Excel 做任何處理都一定辦的到，但是專案只需要 generate excel 簡易表格出來，有需要這麼強大的 PHPExcel，網路上找到一個非常簡易的 Library 那就是 <a href="http://code.google.com/p/php-excel/" target="_blank">php-excel</a> 作者似乎現在沒再更新了，不過已經夠專案使用了，PHP 程式碼也非常簡單。 

### How to use 程式碼很簡易 

<pre class="brush: php; title: ; notranslate" title="">$header = array('編號', '姓名', '電話'); 
$body = array('1', '小惡魔', '0934353289'); 
$xls = new Excel_XML;
$xls->addRow($header);
$xls->addRow($body);
$xls->generateXML("test");</pre> 或是將資料寫成多為陣列 

<pre class="brush: php; title: ; notranslate" title="">$body = array(array('編號', '姓名', '電話'), array('1', '小惡魔', '0934353289')); 
$xls = new Excel_XML;
$xls->addArray($body);
$xls->generateXML("test");</pre> 結論就是殺雞焉用牛刀，就這個簡易 Library 就對了。