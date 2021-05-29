---
title: '[PHP] 善用 ignore_user_abort() 函式'
author: appleboy
type: post
date: 2007-06-22T10:35:16+00:00
url: /2007/06/php-善用-ignore_user_abort-函式/
views:
  - 5198
bot_views:
  - 842
dsq_thread_id:
  - 246703125
categories:
  - apache
  - php
  - www
tags:
  - php

---
話說最近在為了上傳圖片經過縮圖的時間來煩惱，只不過我在想，為甚麼我上傳圖片還要等待縮圖時間才可以，然而無名小站，只需要上傳時間，縮圖是在它機器背景執行，後來發現一個函式非常好用，那就是 

<pre class="brush: php; title: ; notranslate" title="">ignore_user_abort(true);
</pre>

<http://tw2.php.net/manual/tw/function.ignore-user-abort.php> 無名在上傳圖片的php檔案，肯定有加上這個函式，他的好處是使用者如果關掉瀏覽器，但是php還是會繼續執行，也就是無名可以把檔案上傳之後，重新導向到使用者的相簿，程式可以如下 

<pre class="brush: php; title: ; notranslate" title="">ignore_user_abort(true);
set_time_limit(0);
for($i = 1; $i &lt; 6; $i++){
if($_FILES['userfile' . $i]['size']){
/*
上傳圖檔寫在這裡
*/
}
}
//上傳好導向相簿
if($_POST['mode'] == 'add'){
header("Location:index.php");
}
/*
然後這裡在進行縮圖，他就會在背景中執行
*/
if($_POST['mode'] == 'add'){
for($i = 1; $i &lt; 6; $i++){
convert_sh($upload_floder,$file_name[$i],$small_size[$i]);
}
}
?&gt;
</pre> 其實 ignore\_user\_abort(true); 根本就是變相的 unix 底下的 crontab ，還蠻好用的，好處很多，不過用的地方要注意就是了，並不是每個php檔案都需要用這個函式。