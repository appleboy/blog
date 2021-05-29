---
title: '[PHP]好用的上傳 pear 模組 HTTP_Upload'
author: appleboy
type: post
date: 2008-10-24T06:08:41+00:00
url: /2008/10/php好用的上傳-pear-模組-http_upload/
views:
  - 8762
bot_views:
  - 1884
dsq_thread_id:
  - 246706875
categories:
  - php
tags:
  - php

---
在台大 [ptt][1] BBS 上面看到有人推文上傳功能可以交給 [pear HTTP_Upload][2] 來跟 PHP 搭配使用，自己去看了一下[官方線上文件][3]，教學還蠻容易的，大概看過範例就可以瞭解了，上傳之後的檔案，在搭配之前我寫的 [[PHP] header下載檔案 搭配資料庫][4] 

> \* Can handle from one file to multiple files. \* Safe file copying from tmp dir. \* Easy detecting mechanism of valid upload, missing upload or error. \* Gives extensive information about the uploaded file. \* Rename uploaded files in different ways: as it is, safe or unique \* Validate allowed file extensions * Multiple languages error messages support (es, en, de, fr, it, nl, pt_BR) 1. 首先下載官方檔案：[點我][5] 2. 撰寫 PHP 程式： 

<pre class="brush: php; title: ; notranslate" title="">$root_path = './';
include($root_path . 'config.php');
/* 把 pear HTTP_Upload 檔案 include 進來 */
require_once($root_path . 'includes/pear/Upload.php');
$upload = new HTTP_Upload("en");
/* form 的 file 欄位名稱 */
$file = $upload->getFiles("upload_file_01");

if ($file->isValid()) 
{
  /* 設定上傳檔案之後，以亂數取檔名 */
  $file->setName("uniq");
  
  /* 檔案資訊 */
  echo "

<pre>";
  print_r($file->getProp());
  echo "</pre>";  
  /* 印出所有檔案資訊 */
  # $file->getProp("size") 檔案大小
  # $file->getProp("name") 亂數取檔名
  # $file->getProp("real") 上傳的真正檔名
  # $file->getProp("ext") 上傳的副檔名
  $moved = $file->moveTo("upload_data/1/");
  if (!PEAR::isError($moved)) 
  {
    $sql = "INSERT INTO " . FILES_TABLE . " (`userid` , `file_type`, `dateline` , `filesize` , `filename` , `file_real_name`, `extention`) VALUES (
																					'{$userdata[user_id]}', '1', '{$time}', '{$file->getProp("size")}', '{$file->getProp("name")}', '{$file->getProp("real")}', '{$file->getProp("ext")}')";
    if( !($result = $db->sql_query($sql)) )
    {
    	die("Could not query config information " . $sql);
    }        
    DisplayErrMsg("您已經完成上傳資料，在結束上傳日期前，都可以修改

<br /><br />". sprintf($lang['Click_return_forum'], "<a href='./upload.php'>", "</a>"));
  } 
  else {
    echo $moved->getMessage();
  }
} 
elseif ($file->isMissing()) 
{
  echo "No file was provided.";
} 
elseif ($file->isError()) 
{
  echo $file->errorMsg();
}
</pre>

 [1]: http://www.ptt.cc
 [2]: http://pear.php.net/package/HTTP_Upload
 [3]: http://pear.php.net/manual/en/package.http.http-upload.php
 [4]: http://blog.wu-boy.com/2007/05/25/106/
 [5]: http://pear.php.net/package/HTTP_Upload/download