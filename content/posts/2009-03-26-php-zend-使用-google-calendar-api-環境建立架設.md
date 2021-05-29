---
title: '[PHP] Zend 使用 Google Calendar API – 環境建立架設'
author: appleboy
type: post
date: 2009-03-26T13:15:02+00:00
url: /2009/03/php-zend-使用-google-calendar-api-環境建立架設/
views:
  - 10403
bot_views:
  - 406
dsq_thread_id:
  - 248975252
categories:
  - Linux
  - php
  - Zend Framework
tags:
  - google
  - Zend Framework

---
最近又玩了 Googl 的 API：[Google Calendar APIs and Tools][1]，這個 API 可以讓 PHP 開發者對於使用 Google Canledar 有很大的幫助，可以新增事件，刪除事件，修改事件，或者是更改事件，相信在 Google 的 API 裡面都寫的很詳細，這 API 是由 Zend 底下所開發出來的，在 Zend Framework 底下是小 API 模組，大家可以在 [這裡][2] 下載到最新的版本 [Zend Gdata 1.7.7][2]，大家也可以直接在 [Zend Framework][3] 底下做開發，目前支援 PHP5，如果對 Google 月曆不會用的，可以上網找一下，很多 [教學][4] 的喔，底下是要針對開發環境建立做介紹。 針對 [Google Calendar PHP API][5] 教學大家可以先看看，今天先教大家建置環境，環境用在 [Zend Framework][6] 底下的作法，那架設 Zend Framework 可以參考我上一篇文章：[[PHP] Zend Framework 安裝筆記教學 Appserv + Zend Framework (一)][7]，如果是在 Zend Framwork 底下安裝的話，那必須把 .htaccess 裡面的導向 index.php 的功能 mark 起來，不然就跑不過去喔，不然就是另開一個資料夾，就不需要搭配 Zend Framework，那就在 (www 或者是 data)資料夾，多開一個 GClab 資料夾，把檔案解壓縮到裡面。 1. 新增 google 帳號的設定檔案 config.inc.php 

<pre class="brush: php; title: ; notranslate" title="">/*
* Google 帳號密碼，以及 calendar ID
*/
$googleAccount = 'xxxxxxx@gmail.com';
$googlePassword = '';	
$calendarID = 'xxxxxxxx@gmail.com';</pre>

<!--more--> 2. 設定 include_path 的相關性 

<pre class="brush: php; title: ; notranslate" title="">/*
* 這邊是在設定程式把Zend Gdata Library 載入程式碼中
*/
define ('P_S', PATH_SEPARATOR);
/* Zend_framework 請寫下面這行 */
set_include_path('.' .P_S . '../library' . P_S . '../application/models/' . P_S . get_include_path());
/* 非 Zend_framework 請 copy 下面 */
set_include_path('.' .P_S . './library' . P_S . get_include_path());
require_once 'Zend/Loader.php';
Zend_Loader::loadClass('Zend_Gdata');
Zend_Loader::loadClass('Zend_Gdata_AuthSub');
Zend_Loader::loadClass('Zend_Gdata_ClientLogin');

Zend_Loader::loadClass('Zend_Gdata_HttpClient');
Zend_Loader::loadClass('Zend_Gdata_Calendar');</pre> 3. 加入兩個 function 

<pre class="brush: php; title: ; notranslate" title="">/*
* 取得 event 資訊
*/
function getEvent($client, $eventId) 
{
  $gdataCal = new Zend_Gdata_Calendar($client);
  $query = $gdataCal->newEventQuery();
  $query->setUser('default');
  $query->setVisibility('private');
  $query->setProjection('full');
  $query->setEvent($eventId);

  try {
    $eventEntry = $gdataCal->getCalendarEventEntry($query);
    return $eventEntry;
  } catch (Zend_Gdata_App_Exception $e) {
    var_dump($e);
    return null;
  }
}

/*
* 更新 event 資訊，title 名稱，地點，內容
*/
function updateEvent ($client, $eventId, $newTitle, $where, $desc) 
{
  $gdataCal = new Zend_Gdata_Calendar($client);
  if ($eventOld = getEvent($client, $eventId)) {
    echo "Old title: " . $eventOld->title->text . "<br />";
    $eventOld->title = $gdataCal->newTitle($newTitle);
    $eventOld->where = array($gdataCal->newWhere($where));
    $eventOld->content = $gdataCal->newContent($desc);
    try {
      $eventOld->save();
    } catch (Zend_Gdata_App_Exception $e) {
      var_dump($e);
      return null;
    }
    $eventNew = getEvent($client, $eventId);
    echo "New title: " . $eventNew->title->text . "<br />";
    return $eventNew;
  } else {
    return null;
  }
}</pre> 整個 config.inc.php 檔案如下 

<pre class="brush: php; title: ; notranslate" title=""><?php
/*
* Google 帳號密碼，以及 calendar ID
*/
$googleAccount = 'xxxxx@gmail.com';
$googlePassword = '';	
$calendarID = 'xxxxxx@gmail.com';

//這邊是在設定程式把Zend Gdata Library 載入程式碼中
define ('P_S', PATH_SEPARATOR);
set_include_path('.' .P_S . '../library' . P_S . '../application/models/' . P_S . get_include_path());
require_once 'Zend/Loader.php';
Zend_Loader::loadClass('Zend_Gdata');
Zend_Loader::loadClass('Zend_Gdata_AuthSub');
Zend_Loader::loadClass('Zend_Gdata_ClientLogin');
Zend_Loader::loadClass('Zend_Gdata_HttpClient');
Zend_Loader::loadClass('Zend_Gdata_Calendar');


function getEvent($client, $eventId) 
{
  $gdataCal = new Zend_Gdata_Calendar($client);
  $query = $gdataCal->newEventQuery();
  $query->setUser('default');
  $query->setVisibility('private');
  $query->setProjection('full');
  $query->setEvent($eventId);

  try {
    $eventEntry = $gdataCal->getCalendarEventEntry($query);
    return $eventEntry;
  } catch (Zend_Gdata_App_Exception $e) {
    var_dump($e);
    return null;
  }
}


function updateEvent ($client, $eventId, $newTitle, $where, $desc) 
{
  $gdataCal = new Zend_Gdata_Calendar($client);
  if ($eventOld = getEvent($client, $eventId)) {
    echo "Old title: " . $eventOld->title->text . "

<br />";
    $eventOld->title = $gdataCal->newTitle($newTitle);
    $eventOld->where = array($gdataCal->newWhere($where));
    $eventOld->content = $gdataCal->newContent($desc);
    try {
      $eventOld->save();
    } catch (Zend_Gdata_App_Exception $e) {
      var_dump($e);
      return null;
    }
    $eventNew = getEvent($client, $eventId);
    echo "New title: " . $eventNew->title->text . "<br />";
    return $eventNew;
  } else {
    return null;
  }
}

?></pre> 打開瀏覽器，輸入：http://localhost/資料夾/config.inc.php，如果沒有錯誤訊息，那就是成功了喔，看看明天可不可以來寫新增修改刪除範例，還有可以瀏覽整個 Google Calendar 畫面。 下一篇：

[[PHP] Zend 使用 Google Calendar API - 瀏覽事件][8]

 [1]: http://code.google.com/apis/calendar/
 [2]: http://framework.zend.com/download/webservices
 [3]: http://framework.zend.com/
 [4]: http://www.google.com.tw/search?q=google+calendar+%E6%95%99%E5%AD%B8&ie=utf-8&oe=utf-8&aq=t&rlz=1R1GGGL_en___TW320&client=firefox-a
 [5]: http://code.google.com/apis/calendar/docs/1.0/developers_guide_php.html
 [6]: http://framework.zend.com
 [7]: http://blog.wu-boy.com/2009/03/24/1060/
 [8]: http://blog.wu-boy.com/2009/03/27/1081/