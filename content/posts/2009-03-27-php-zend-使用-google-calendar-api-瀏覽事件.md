---
title: '[PHP] Zend 使用 Google Calendar API – 瀏覽事件'
author: appleboy
type: post
date: 2009-03-27T04:09:30+00:00
url: /2009/03/php-zend-使用-google-calendar-api-瀏覽事件/
views:
  - 15254
bot_views:
  - 423
dsq_thread_id:
  - 247241279
categories:
  - Linux
  - php
  - Zend Framework
tags:
  - google
  - php
  - Zend Framework

---
昨天寫了一篇 [[PHP] Zend 使用 Google Calendar API - 環境建立架設][1]，相信應該是非常簡單才對，那今天來介紹一下實做 Google Calendar API 的瀏覽、新增、刪除、修改事件的功能，在官方網站都有詳細的 API 功能介紹，我只不過把功能整合完整一點，詳細請看 [Google Calendar API With PHP][2]。 1. 瀏覽功能：建立 index.php 

<pre class="brush: php; title: ; notranslate" title="">/*
* include 昨天新增的config.inc.php 檔案
*/
include('config.inc.php');
/*
* 提供Calendar 的服務名稱
*/
$service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
/*
* 登入帳號密碼
*/
$client = Zend_Gdata_ClientLogin::getHttpClient($googleAccount, $googlePassword, $service);</pre>

<!--more--> 登入帳號密碼部份，請開啟 PHP 的 module：php_openssl.so，不然會出現底下錯誤訊息： 

> Fatal error: Uncaught exception 'Zend\_Gdata\_App\_HttpException' with message 'Unable to Connect to ssl://www.google.com:443. Error #46482968: Unable to find the socket transport "ssl" - did you forget to enable it when you configured PHP?' in C:\AppServ\www\Zend\library\Zend\Gdata\ClientLogin.php:140 Stack trace: #0 C:\AppServ\www\Zend\GClab\index.php(5): Zend\_Gdata_ClientLogin::getHttpClient('xxxxx@gma...', '', 'cl') #1 解決方法就是修改 php.ini 檔案，打開 extension=php_openssl.dll 這個 module 就可以了，參考網站：[[PHP] Unable to find the socket transport "ssl"][3]，接下來在 config.inc.php 加入底下的 function 參數： $client = 認證通過的變數 $startDate = 選擇起始時間 $endDate = 選擇結束時間 

<pre class="brush: php; title: ; notranslate" title="">function outputCalendarByDateRange($client, $startDate='2009-01-01',  $endDate='2009-12-31') 
{
  $gdataCal = new Zend_Gdata_Calendar($client);
  $query = $gdataCal->newEventQuery();
  $query->setUser('default');
  $query->setVisibility('private');
  $query->setProjection('full');
  /*
  * 可以指定 order by starttime or lastmodified 
  * starttime 起始時間
  * lastmodified 最後修改    
  */  
  $query->setOrderby('starttime');
  $query->setStartMin($startDate);
  $query->setStartMax($endDate);
  $eventFeed = $gdataCal->getCalendarEventFeed($query);
  foreach ($eventFeed as $event) {
    echo "

<h2>
  <a href=\"event.php?id=".basename($event->id->text)."\">" . $event->title->text .  "</a>
</h2>\n";
    echo "

<ul>
  \n";
      echo "\t
  
  <li>
    <b>內容:</b>".$event->content->text."
  </li>\n";
      foreach ($event->where as $where) {
        echo "\t
  
  <li>
    <b>地點:</b>" . $where->valueString . "
  </li>\n";
      }  
      foreach ($event->when as $when) {
        echo "\t
  
  <li>
    <b>起始時間: </b>" . $when->startTime . "
  </li>\n";
        echo "\t
  
  <li>
    <b>結束時間: </b>" . $when->endTime . "
  </li>\n";
      } 
      echo "\t\t
</ul>\n";
    echo "\t</li>\n";
    echo "</ul>\n";
  }
  
}</pre> 這樣我們就可以整個輸出 index.php 檔案了喔，那原始檔案如下： 

<pre class="brush: php; title: ; notranslate" title=""><?php
include('config.inc.php');
$service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME; // 提供Calendar 的服務名稱
$client = Zend_Gdata_ClientLogin::getHttpClient($googleAccount, $googlePassword, $service);
?>






<?php
outputCalendarByDateRange($client,'2009-01-01','2009-12-01');
?>

 </pre> 上一篇：

[[PHP] Zend 使用 Google Calendar API - 環境建立架設][1] 下一篇：[[PHP] Zend 使用 Google Calendar API - 編輯事件][4]

 [1]: http://blog.wu-boy.com/2009/03/26/1075/
 [2]: http://code.google.com/apis/calendar/docs/1.0/developers_guide_php.html
 [3]: http://blog.sunflier.com/?p=572
 [4]: http://blog.wu-boy.com/2009/03/28/1096/