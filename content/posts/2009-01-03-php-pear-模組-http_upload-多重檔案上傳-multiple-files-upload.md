---
title: '[PHP] pear 模組 HTTP_Upload 多重檔案上傳 Multiple files upload'
author: appleboy
type: post
date: 2009-01-03T10:10:23+00:00
url: /2009/01/php-pear-模組-http_upload-多重檔案上傳-multiple-files-upload/
views:
  - 10001
bot_views:
  - 816
dsq_thread_id:
  - 246920282
categories:
  - php
tags:
  - php

---
自從上次介紹了 [[PHP]好用的上傳 pear 模組 HTTP_Upload][1]，最近又要使用到多重的檔案上傳，就又去看了一下官網的 [document][2] 寫的還蠻詳細的，大家去看看大概就知道我的作法了，底下是我的寫法： html 部份 

<pre class="brush: xml; title: ; notranslate" title="">
 
 
  
 
</pre>

<!--more--> 上傳後 PHP 處理的結果： 

<pre class="brush: php; title: ; notranslate" title=""><?php
$upload = new HTTP_Upload("en");
$files = $upload->getFiles();
/* 處理自訂檔名 */
$i = "0";
/* file_show_name array number */
foreach($files as $file){
  if (PEAR::isError($file)) {
      echo $file->getMessage();
  }
  /* 檔案上傳後 */  
  if ($file->isValid()) 
  {
    
    $file->setName("uniq");
    
    $moved = $file->moveTo($upload_dir);
    if (!PEAR::isError($moved)) 
    {
      /* 寫到資料庫裡面 */
      $sql = "INSERT INTO " . FILES_TABLE . " (`file_id`, `file_type`, `dateline` , `filesize` , `filename` , `file_real_name`, `file_show_name` , `extention`) VALUES ('".$list_id."', '".$type."', '".$time."', '".$file->getProp("size")."', '".$file->getProp("name")."', '".$file->getProp("real")."', '".$_POST['file_show_name'][$i]."', '".$file->getProp("ext")."')";        
      if( !($result = $db->sql_query($sql)) )
      {
      	die("Could not query config information " . $sql);
      }                     
      $fid = $db->sql_nextid();
    } 
    else {
      echo $moved->getMessage();
    }
  } 
  elseif ($file->isMissing()) 
  {
  } 
  elseif ($file->isError()) 
  {
    echo $file->errorMsg();
  }
  /* 處理 file_show_name array number */
  $i++;
}  
?></pre>

 [1]: http://blog.wu-boy.com/2008/10/24/563/
 [2]: http://pear.php.net/manual/en/package.http.http-upload.php#package.http.http-upload.examples.multiple