---
title: '[PHP] 好用的 PEAR – PHP Mail and Mail_Mime'
author: appleboy
type: post
date: 2007-12-18T12:24:57+00:00
url: /2007/12/php-好用的-pear-php-mail-and-mail_mime/
views:
  - 9689
bot_views:
  - 933
categories:
  - Linux
  - mail
  - php
  - www
tags:
  - mail
  - PEAR
  - php

---
今天在寫期末的 Project，我的專題是寫無線 802.1X 認證，搭配 FreeBADIUS Server，然後我在搭配網頁整合認證機制，然後我在做使用者帳號申請部份，需要靠 Email 認證，但是我去看官網，介紹好像也沒什麼，在寄信的時候常常會遇到亂碼，不然就是寄信 html 部份會有問題，或者是不能附加檔案之類的，然後網路上找不到一個好用的 class ，所以就用了 [PEAR::Mail_Mime][1] 跟 [PEAR::Mail][2]，這兩個套件還不錯用，如果想寄單純的信件，就用 PEAR::Mail 這個就可以了，如果要搭配 html 網頁，就要搭上 PEAR::Mail_Mime <!--more--> 接下來就是介紹怎麼安裝了，首先你的系統要有搭配 php pear 的套件 cd /usr/ports/devel/pear make install 不過你如果裝 php5 的套件的話，她會順便一起裝進去，我想這不是重點 再來就是下載 PEAR::Mail 跟 PEAR::Mail_Mime 套件 其實作法很簡單，就是下載程式都丟到 includes 裡面，然後要用到的時候，利用底下 

<pre class="brush: php; title: ; notranslate" title="">define('Document_root',dirname(__FILE__));
</pre> 這個相當好用，取得絕對路徑，之後只要寫成下面底下就好 

<pre class="brush: php; title: ; notranslate" title="">include(Document_root . '/includes/Mail.php');
include(Document_root . '/includes/Mail/mime.php');
</pre> 再來是最普通的寄送範例： 

<pre class="brush: php; title: ; notranslate" title="">include(Document_root . '/includes/Mail.php');
  $recipients = 'joe@example.com';
  $headers['From']    = 'richard@phpguru.org';
  $headers['To']      = 'joe@example.com';
  $headers['Subject'] = 'Test message';
  $body = 'Test message';
  $mail_object =&#038; Mail::factory('mail');
  $mail_object->send($recipients, $headers, $body);
</pre> 裡面有一行 $mail\_object =& Mail::factory(&#8216;mail&#8217;); 這個有三種方式 mail, sendmail, smtp mail: 這是不需要任何參數的 sendmail:需要 sendmail 的程式路徑跟她所需要的參數 smtp：需要 mail 主機位址，port，是否需要認證，帳號密碼之類的 當然我們用最普通的就好，那就是 mail 就可以，不過前提你要先架好 mail Server Mail\_Mime 的部分: 這部份比較複雜，我們先看範例： 

<pre class="brush: php; title: ; notranslate" title="">include(Document_root . '/includes/Mail.php');
  include(Document_root . '/includes/Mail/mime.php');
  $text = '我是小惡魔我是小惡魔我是小惡魔我是小惡魔';
  $html = '
  
  
  
  

<p>
  Hello World!
</p>
  

<p>
  我是小惡魔
</p>
  

<p>
  我是小惡魔
</p>
  

<p>
  我是小惡魔
</p>
  

<p>
  我是小惡魔
</p>
  
  ';
  $file = '/home/appleboy/adwii/AB2.jpg';
  $crlf = "\n";
  $param['text_charset'] = 'utf-8';
  $param['html_charset'] = 'utf-8';
  $param['head_charset'] = 'utf-8';
  $hdrs = array(
                'From'    => 'appleboy@example.org',
                'Subject' => '系統資訊',
                'Content-type' => 'text/plain; charset=utf-8'
                );
  $mime = new Mail_mime($crlf);
  $mime->setTXTBody($text);
  $mime->setHTMLBody($html);
  $mime->addAttachment($file, 'text/plain', 'AB2.jpg');
  $body = $mime->get($param);
  $hdrs = $mime->headers($hdrs);
  //echo $body;
  $mail =&#038; Mail::factory('mail');
  $mail->send('appleboy@example.org', $hdrs, $body);
</pre> 這個範例，可以附加檔案，跟寫 html 格式的 mail 寄信到對方 $mime->addAttachment($file, &#8216;text/plain&#8217;, &#8216;AB2.jpg&#8217;); 這一行就是寄送附加檔案，附加檔案的格式如下 

<pre class="brush: php; title: ; notranslate" title="">function addAttachment($file,
                           $c_type      = 'application/octet-stream',
                           $name        = '',
                            $isfile     = true,
                           $encoding    = 'base64',
                           $disposition = 'attachment',
                           $charset     = '',
                            $language   = '',
                           $location    = '')
</pre> 1.使用 Mail\_mime() 建立新的 Mail\_mime 物件(constructor)。 2.至少要使用 setTXTBody(), setHTMLBody(), addHTMLImage() 或 addAttachment() 四者其中之一建立內文或附檔。（當然通常的情況不只使用一個囉） 3.使用 get() 傳回內文。 4.使用 headers() 傳回檔頭。 5.利用傳回的內文與檔頭丟給 Mail::send() 送信。 reference 

<http://pear.php.net/manual/en/package.mail.mail.intro.php> <http://blog.xuite.net/noi1/yamesz/8928129> <http://pear.php.net/manual/en/package.mail.mail-mime.example.php>

 [1]: http://pear.php.net/package/Mail_Mime
 [2]: http://pear.php.net/package/Mail