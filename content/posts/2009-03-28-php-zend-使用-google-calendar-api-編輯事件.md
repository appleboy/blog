---
title: '[PHP] Zend 使用 Google Calendar API – 編輯事件'
author: appleboy
type: post
date: 2009-03-28T01:41:08+00:00
url: /2009/03/php-zend-使用-google-calendar-api-編輯事件/
views:
  - 9912
bot_views:
  - 327
dsq_thread_id:
  - 249192517
categories:
  - Linux
  - php
  - Zend Framework
tags:
  - php
  - Zend Framework

---
上一篇介紹了瀏覽 Google Calendar API 範圍內所有的事件，有沒有發現在 index.php 就有瀏覽單一事件的連結，我們透過 API 可以取得單一事件的 evenID，取得的方式就是透過 [basename][1] 函式： 

<pre class="brush: php; title: ; notranslate" title="">basename($event->id->text)</pre> 我們可以利用 $_GET 方式讀取到 evenID 值，傳送到 event.php 來接收 

<pre class="brush: php; title: ; notranslate" title="">$eventId = ( isset($_POST['id']) ) ? $_POST['id'] : $_GET['id'];</pre> 1. 新增 event.php 檔案，寫入開頭： 

<pre class="brush: php; title: ; notranslate" title=""><?php
include('config.inc.php');
/*
* 首頁傳來的 event id 值
*/
$eventId = ( isset($_POST['id']) ) ? $_POST['id'] : $_GET['id'];

$service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
$client = Zend_Gdata_ClientLogin::getHttpClient($googleAccount, $googlePassword, $service);
/*
* 讀取單一事件資料
*/
$eventEntry = getEvent($client, $eventId);
/*
* 讀取單一事件地點
*/
foreach ($eventEntry->where as $where) {
  $whereValue = $where->valueString;//地點
}
?></pre>

<!--more--> 讀取單一事件可寫成一個 getEvent function 到 config.inc.php 檔案，只要傳入 even ID 直進去就可以了。 

<pre class="brush: php; title: ; notranslate" title="">function getEvent($client, $eventId) 
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
}</pre> 2. 編輯事件表格： 

<pre class="brush: xml; title: ; notranslate" title=""></pre> 必須將 event id 寫入 hidden 裡面，傳送到 edit.php 3. 顯示單一事件： 

<pre class="brush: php; title: ; notranslate" title=""><?php
echo "<h2>" . $eventEntry->title->text .  "</h2>\n";
echo "

<ul>
  \n";
  echo "\t
  
  <li>
    <b>內容:</b>".nl2br($eventEntry->content->text)."
  </li>\n";
  foreach ($eventEntry->where as $where) 
  {
    echo "\t
  
  <li>
    <b>地點:</b>" . $where->valueString . "
  </li>\n";//地點
  }
  foreach ($eventEntry->when as $when) 
  {
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
    <b>事件ID:</b>".basename($eventEntry->id->text)."
  </li>\n";
  echo "
</ul>\n";
?></pre> 當我們編輯好，送出到 edit.php 頁面，就可以利用 updateEvent function 來達到更新資料，官網上面只有更新 title，我加入了地點跟 content 內容更新，這樣會比較實用，程式碼如下： 

<pre class="brush: php; title: ; notranslate" title="">function updateEvent ($client, $eventId, $newTitle, $where, $desc) 
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
}</pre> 最後把 event.php 檔案，跟 edit.php 檔案程式碼寫在下面，有需要用到的可以拿去用。 event.php： 

<pre class="brush: php; title: ; notranslate" title=""><?php
include('config.inc.php');
/*
* 首頁傳來的 event id 值
*/
$eventId = ( isset($_POST['id']) ) ? $_POST['id'] : $_GET['id'];

$service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
$client = Zend_Gdata_ClientLogin::getHttpClient($googleAccount, $googlePassword, $service);
/*
* 讀取單一事件資料
*/
$eventEntry = getEvent($client, $eventId);
/*
* 讀取單一事件地點
*/
foreach ($eventEntry->where as $where) {
  $whereValue = $where->valueString;//地點
}
?>




[

<a href="./">上一頁</a>] [<a href="delete.php?id=<?=basename($eventEntry->id->text)?>">刪除</a>]


<div>
  <?
?>
  
  
</div>



<hr />

<?php
echo "<h2>" . $eventEntry->title->text .  "</h2>\n";
echo "

<ul>
  \n";
  echo "\t
  
  <li>
    <b>內容:</b>".nl2br($eventEntry->content->text)."
  </li>\n";
  foreach ($eventEntry->where as $where) 
  {
    echo "\t
  
  <li>
    <b>地點:</b>" . $where->valueString . "
  </li>\n";//地點
  }
  foreach ($eventEntry->when as $when) 
  {
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
    <b>事件ID:</b>".basename($eventEntry->id->text)."
  </li>\n";
  echo "
</ul>\n";
?>

</pre> edit.php 程式碼： 

<pre class="brush: php; title: ; notranslate" title=""><?php
include('config.inc.php');
$eventId = ( isset($_POST['id']) ) ? $_POST['id'] : $_GET['id'];
$newTitle = ( isset($_POST['title']) ) ? $_POST['title'] : $_GET['title'];
$newWhere = ( isset($_POST['where']) ) ? $_POST['where'] : $_GET['where'];
$newContent = ( isset($_POST['content']) ) ? $_POST['content'] : $_GET['content'];
$service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME; 
$client = Zend_Gdata_ClientLogin::getHttpClient($googleAccount, $googlePassword, $service);

updateEvent ($client, $eventId, $newTitle, $newWhere, $newContent);
echo "觀看內容:<a href='event.php?id=".$eventId."'>".$newTitle."</a>";

?>
</pre> 上一篇：

[[PHP] Zend 使用 Google Calendar API - 瀏覽事件][2] 下一篇：[[PHP] Zend 使用 Google Calendar API - 新增、刪除事件 - END][3]

 [1]: http://tw2.php.net/basename
 [2]: http://blog.wu-boy.com/2009/03/27/1081/
 [3]: http://blog.wu-boy.com/2009/03/29/1109/