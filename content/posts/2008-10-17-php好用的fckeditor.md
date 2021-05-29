---
title: '[PHP]好用的FCKeditor'
author: appleboy
type: post
date: 2008-10-17T05:09:51+00:00
url: /2008/10/php好用的fckeditor/
views:
  - 9209
bot_views:
  - 2664
dsq_thread_id:
  - 249125718
categories:
  - Network
  - php
  - www
tags:
  - FCKeditor
  - html
  - php

---
最近在玩這一套 [FCKeditor][1] 線上 HTML 編輯系統，這目前很多 opensource 都有利用這一套編輯系統來搭配，我覺得還蠻方便的，所以很多後台或者是前台都會使用，我想這已經是現在的趨勢了，然而要安裝這個也相當容易，官方網站都寫的很清楚，可以先使用他們線上的 [demo][2]，如果要加入到自己的系統，他們也有提供一些文件讓大家參考：[線上文件][3]，其實他們支援各大語法：asp，php，Python&#8230; 一堆，安裝方法也很容易，底下寫一下安裝方法： 1. 首先先下載  [FCKeditor][1] 這一套軟體： [點我下載][4] 目前是這個版本：FCKeditor\_2.6.3.zip 2. 裡面有一些 sample 可以使用 fckeditor/\_samples/default.html 3. 如果你要使用在自己的系統裡面起加入底下語法： 

<pre class="brush: php; title: ; notranslate" title="">$root_path = './';
include($root_path . "fckeditor/fckeditor.php");
$sBasePath = "fckeditor/";

//實體化  FCKeditor  並指定欄位名稱
$oFCKeditor  =  new  FCKeditor('file_data');
$oFCKeditor->BasePath = $sBasePath;

//預設的語言，zh表繁體中文
$oFCKeditor->Config['DefaultLanguage'] = 'zh';

//預設填入的內容
$oFCKeditor->Value = '

<p>
  This is some <strong>sample text</strong>. You are using <a href="http://www.fckeditor.net/">FCKeditor</a>.
</p>' ;

//直接輸出FCKeditor表單
$oFCKeditor->Create(); </pre> 基本上這樣大致上就完成了喔。很容易吧

 [1]: http://www.fckeditor.net/
 [2]: http://www.fckeditor.net/demo
 [3]: http://docs.fckeditor.net/
 [4]: http://www.fckeditor.net/download