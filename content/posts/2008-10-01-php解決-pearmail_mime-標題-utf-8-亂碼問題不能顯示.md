---
title: '[PHP]解決 PEAR::Mail_Mime 標題 UTF-8 亂碼問題(不能顯示)'
author: appleboy
type: post
date: 2008-10-01T02:17:30+00:00
url: /2008/10/php解決-pearmail_mime-標題-utf-8-亂碼問題不能顯示/
views:
  - 14368
bot_views:
  - 1962
dsq_thread_id:
  - 250498646
categories:
  - FreeBSD
  - Linux
  - mail
  - Network
  - php
  - www
tags:
  - Linux
  - mail
  - PEAR
  - php

---
話說大家在寫 PHP 的時候，一定會很常用到 mail 這個函式，畢竟一個網站一定會有很多需要用到寄信的地方，我先給大家推薦一下 [PEAR::Mail_Mime][1] 跟 [PEAR::Mail][2] 這兩個 Pear 的套件，用起來相當不錯，支援 html 跟 UTF-8 或者是 Big5 編碼，我之前寫過一篇 <a title="Permanent Link to [PHP] 好用的 PEAR - PHP Mail and Mail_Mime" rel="bookmark" href="http://blog.wu-boy.com/2007/12/18/129/">[PHP] 好用的 PEAR &#8211; PHP Mail and Mail_Mime</a>，裡面寫的還蠻詳細的，不過上次有一個問題還沒解決，就是如果用 UTF-8 編碼的標題，會顯示不出來，[Gmail][3] 收到的話就會是 no subject，然後昨天用了一個非常笨的解決方法，改成把標題使用 Big5 就可以了，解決方法如下： **Update：感謝 darkhero 提供解決方法：** 如果要用 UTF-8 的標題： 

<pre class="brush: php; title: ; notranslate" title="">$param['head_charset'] = 'utf-8';
  $hdrs = array(
                'From'    => 'appleboy.tw@gmail.com',
                'Subject' => '=?utf8?B?' . base64_encode($subj) . '?=', 
                'Content-type' => 'text/html; charset=utf-8'
                ); </pre> 先讓主機支援 PEAR： 

<pre class="brush: bash; title: ; notranslate" title="">#
#  FreeBSD ports 安裝
cd /usr/ports/devel/pear
make install clean</pre>

<!--more--> 然後當然是自己寫一個 send mail 函式來使用，這樣以後就呼叫這個 function 就可以了 

<pre class="brush: php; title: ; notranslate" title="">function send_mail($to, $subj, $body)
{
  global $db,$userdata, $board_config;
  include(Document_root . '/includes/Mail.php');
  include(Document_root . '/includes/Mail/mime.php');
  $html = '
          
          
          
          '.$body.'
          
          ';
  //$file = '/home/appleboy/adwii/AB2.jpg';
  $crlf = "\n";
  //$param['text_charset'] = 'utf-8';
  $param['html_charset'] = 'utf-8';
  $param['head_charset'] = 'Big5';
  $hdrs = array(
                'From'    => 'appleboy.tw@gmail.com',
                'Subject' => iconv("UTF-8","BIG5",$subj), 
                'Content-type' => 'text/html; charset=utf-8'
                );
  $mime = new Mail_mime($crlf);
  $mime->setTXTBody($text);
  $mime->setHTMLBody($html);
  //$mime->addAttachment($file, 'text/plain', 'AB2.jpg');
  $body = $mime->get($param);
  $hdrs = $mime->headers($hdrs);
  //echo $body;
  $mail =&#038; Mail::factory('mail');
  $mail->send($board_config['board_email'] . ', ' . $to, $hdrs, $body);
}</pre> 這是我之前寫的函式，裡面標題本來不能用的，我系統跟程式都是使用 UTF-8，標題也是都利用 UTF-8 設定，可是標題顯示步來，那就改用 Big5 吧，所以是設定如下 

<pre class="brush: php; title: ; notranslate" title="">$param['head_charset'] = 'Big5';
  $hdrs = array(
                'From'    => 'appleboy.tw@gmail.com',
                'Subject' => iconv("UTF-8","BIG5",$subj), 
                'Content-type' => 'text/html; charset=utf-8'
                );
</pre> 先把 $param[&#8216;head_charset&#8217;] = &#8216;UTF-8&#8217;; 裡面設定改成 Big5 這樣就可以了，然後在 Subject 轉成 Big5 利用 

[PHP iconv][4] 函式就可以了，然後在隨便測試一下就可以 work 了

 [1]: http://pear.php.net/package/Mail_Mime
 [2]: http://pear.php.net/package/Mail
 [3]: http://mail.google.com
 [4]: http://tw.php.net/iconv