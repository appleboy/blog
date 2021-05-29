---
title: '[jQuery] Confirm Plugin 動態新增表單欄位'
author: appleboy
type: post
date: 2009-02-18T03:04:55+00:00
url: /2009/02/jquery-confirm-plugin，動態新增表單欄位/
views:
  - 12161
bot_views:
  - 601
dsq_thread_id:
  - 247200779
categories:
  - blog
  - jQuery
tags:
  - javascript
  - jQuery
  - php

---
最近在實做多重檔案上傳，寫過一篇 <a href="http://blog.wu-boy.com/2009/01/03/677/" target="_blank">[PHP] pear 模組 HTTP_Upload 多重檔案上傳 Multiple files upload</a>，那一開始我先設定只能上傳5個檔案，後來想想動態的話比較方便，畢竟現在網站都講求 web2.0，所以就利用 [jQuery][1] 來動態新增 input file 欄位，作法其實很簡單，不難的喔。其實還有 [jQuery Confirm Plugin][2] 可以利用它來確定使用者是否刪除檔案。 之前介紹的上傳檔案 html 部份： 

<pre class="brush: xml; title: ; notranslate" title="">
 
 
  
 
</pre>

<!--more--> 改成： 

<pre class="brush: xml; title: ; notranslate" title="">
 
 
  
 
</pre> jQuery 的部份： 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).ready(function(){
  $("#add_button").click
  (
    function()
    {
      $("#add_file_button").append('<input type="file" name="f[]" />&nbsp;檔案名稱：<input type="text" name="file_show_name[]" value="" size="32" maxlength="64" /><br />');      
    }
  );
  $("a[id='del_file[]']").click(function(){
      if (confirm('確定刪除檔案')) {
        return true;
      }
      return false;
  });    
});</pre> 這樣大致少就可以了喔，可以動態新增檔案，那處理檔案上傳部份，可以利用 

[PHP][3] 的 for 加上 count 函式，來處理動態表單。

 [1]: http://jquery.com/
 [2]: http://nadiana.com/jquery-confirm-plugin
 [3]: http://www.php.net