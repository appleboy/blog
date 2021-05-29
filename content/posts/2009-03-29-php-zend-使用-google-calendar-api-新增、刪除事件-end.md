---
title: '[PHP] Zend 使用 Google Calendar API – 新增、刪除事件 – END'
author: appleboy
type: post
date: 2009-03-29T01:00:09+00:00
url: /2009/03/php-zend-使用-google-calendar-api-新增、刪除事件-end/
views:
  - 8872
bot_views:
  - 446
dsq_thread_id:
  - 250517428
categories:
  - Linux
  - php
  - Zend Framework
tags:
  - php
  - Zend Framework

---
這篇算是 [Google Calendar API][1] 的結尾文章了，只剩下新增、刪除兩個功能尚未說明，那這兩個功能野蠻簡單的，底下就來介紹如何新增單一事件功能，看看是否要增另外新檔案放 form 的表單，我是把表單放入 index.php 再把資料傳送到 news.php 此檔案，先介紹 form 表單： 

<pre class="brush: xml; title: ; notranslate" title=""></pre>

<!--more--> 這介面我想也不必多說解釋，基本的 html，一些格式也必須遵照 

[Google Calendar API][1] 的指示下去設定，所以並不需要修改什麼，copy 過去就可以了。 將 POST data 傳送到 news.php，就必須開始處理資料，要注意的是 Title 跟 When 這兩個欄位必填，所以要檢查欄位是否有填寫完整，最好還是搭配 trim 函式，empty 判斷是否空值。 

<pre class="brush: php; title: ; notranslate" title="">/*
* Title 和when 是必要的欄位，這邊做個檢查
*/
if($_POST['title'] != ''&& $_POST['startDate'] != ''&& $_POST['startTime'] != ''&& $_POST['endDate'] != ''&& $_POST['endTime'] != '')
{
  $title = $_POST['title'];
  $where = $_POST['where'];
  $content = $_POST['content'];
  $startDate = $_POST['startDate'];
  $startTime = $_POST['startTime'];
  $endDate = $_POST['endDate'];
  $endTime = $_POST['endTime'];
}
else
{
  die("[<a href=\"./\">back</a>]

<hr />

<b>Warning</b>: Too few arguments.");
}</pre> 接下來新增事件函式到 config.inc.php： 

<pre class="brush: php; title: ; notranslate" title="">function createEvent ($client, $title = 'Tennis with Beth',
    $desc='Meet for a quick lesson', $where = 'On the courts',
    $startDate = '2008-01-20', $startTime = '10:00',
    $endDate = '2008-01-20', $endTime = '11:00', $tzOffset = '+08')
{
  $gdataCal = new Zend_Gdata_Calendar($client);
  $newEvent = $gdataCal->newEventEntry();
  
  $newEvent->title = $gdataCal->newTitle($title);
  $newEvent->where = array($gdataCal->newWhere($where));
  $newEvent->content = $gdataCal->newContent("$desc");
  
  $when = $gdataCal->newWhen();
  $when->startTime = "{$startDate}T{$startTime}:00.000{$tzOffset}:00";
  $when->endTime = "{$endDate}T{$endTime}:00.000{$tzOffset}:00";
  $newEvent->when = array($when);

  // Upload the event to the calendar server
  // A copy of the event as it is recorded on the server is returned
  $createdEvent = $gdataCal->insertEvent($newEvent);
  return $createdEvent->id->text;
}</pre> 注意回傳值就是整個 event 的資訊，所以可以直接拿來用了，底下丟入對應的資料： 

<pre class="brush: php; title: ; notranslate" title="">$createdEvent = createEvent($client, $title,
    $content,
    $where, 
    $startDate, $startTime, $endDate, $endTime, '+08' );</pre> 最後一個欄位是台灣時區 Offset 就必須 +08，這點是該注意的地方，那剩下的就是輸出資料了： 

<pre class="brush: php; title: ; notranslate" title=""><?php
echo "<h2>" . $createdEvent->title->text .  "</h2>\n";
echo "

<ul>
  \n";
  echo "\t
  
  <li>
    <b>內容:</b>".$createdEvent->content->text."
  </li>\n";
  foreach ($createdEvent->where as $where) {
      echo "\t
  
  <li>
    <b>地點:</b>" . $where->valueString . "
  </li>\n";//地點
  }
  foreach ($createdEvent->when as $when) {
      echo "\t
  
  <li>
    <b>開始時間:</b>" . $when->startTime . "
  </li>\n";
      echo "\t
  
  <li>
    <b>結束時間:</b>" . $when->endTime . "
  </li>\n";
  }
  echo "\t
  
  <li>
    <b>事件ID:</b>".basename($createdEvent->id->text)."
  </li>\n";
  echo "
</ul>\n";
?></pre> 這樣就代表成功了喔，接下來可以選擇刪除事件，只要知道 event 的 ID 值，就可以進行刪除事件的動作： 

<pre class="brush: php; title: ; notranslate" title=""><?php
include('config.inc.php');
$eventId = ( isset($_POST['id']) ) ? $_POST['id'] : $_GET['id'];

$service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME; // 提供Calendar 的服務名稱
$client = Zend_Gdata_ClientLogin::getHttpClient($googleAccount, $googlePassword, $service);

$eventEntry = getEvent($client, $eventId);
$title = $eventEntry->title->text;
/* 
* 刪除 event 
*/
$eventEntry->delete();
?></pre> 刪除事件的程式比較簡單，就是呼叫 delete() 功能，將它刪除，那這一系列的 Zend Google Calendar API 告一段落了，如果有問題可以進行留言。 上一篇：

[[PHP] Zend 使用 Google Calendar API - 編輯事件][2] 參考資料： [Google Calendar API Doc][3] [[教學] 在PHP 中使用Google Calendar API - Part 1 環境建立][4] [[教學] 在PHP 中使用Google Calendar API - Part 2 取得事件列表][5] [[教學] 在PHP 中使用Google Calendar API - Part 3 檢視單一事件][6] [[教學] 在PHP 中使用Google Calendar API - Part 4 新增事件(含提醒)][7] [[教學] 在PHP 中使用Google Calendar API - END 刪除事件(含補充)][8]

 [1]: http://code.google.com/apis/calendar/
 [2]: http://blog.wu-boy.com/2009/03/28/1096/
 [3]: http://code.google.com/apis/calendar/docs/1.0/developers_guide_php.html
 [4]: http://function1122.blogspot.com/2008/07/php-google-calendar-api-part-1.html
 [5]: http://function1122.blogspot.com/2008/07/php-google-calendar-api-part-2.html
 [6]: http://function1122.blogspot.com/2008/07/php-google-calendar-api-part-3.html
 [7]: http://function1122.blogspot.com/2008/07/php-google-calendar-api-part-4.html
 [8]: http://function1122.blogspot.com/2008/08/php-google-calendar-api-end.html