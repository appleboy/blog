---
title: CodeIgniter 初始化 Library 流程
author: appleboy
type: post
date: 2013-12-20T15:52:13+00:00
url: /2013/12/codeigniter-load-library-process/
dsq_thread_id:
  - 2063175442
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div>

好久沒寫 <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> 相關文章，這次看到在論壇有人發問 <a href="http://www.codeigniter.org.tw/forum/viewtopic.php?f=6&t=3885" target="_blank">application/libraries 優先權</a>，想說把整個 CodeIgniter 如何讀取 Library 的流程整個寫下來，其實也不會很難，但是就是要照著 CI 定義的規則來命名檔名以及 Class。假設要讀取 Email Library，我們可以透過底下方式讀取

<div>
  <pre class="brush: php; title: ; notranslate" title="">$this-&gt;load-&gt;library('email');</pre>
</div>

<!--more--> CI 會先將第一個字母大寫 Email 字串，接著小寫 email 字串開始進行搜尋檔案動作，搜尋的優先順序會先從你是否有擴充核心 Library，也就是 config.php 內定義 

**<span style="color:green">subclass_prefix</span>**，那 CI 預設的 Prefix 就是 **<span style="color:green">MY_</span>**，底下列出 CI 判斷檔案是否存在的列表

<div>
  <pre class="brush: bash; title: ; notranslate" title="">1. application/libraries/MY_Email.php
2. application/libraries/Email.php
3. system/libraries/Email.php
4. application/libraries/MY_email.php
5. application/libraries/email.php
6. system/libraries/email.php</pre>
</div>

假設 1. application/libraries/MY_Email.php 存在時，系統會認定您有擴充 Library，所以會將 application/libraries/Email.php 同時讀取進來，也就是 include 兩個檔案

<pre class="brush: php; title: ; notranslate" title="">include_once('application/libraries/Email.php');
include_once('application/libraries/MY_Email.php');</pre>

這時候你會發現在 application/libraries/MY_Email.php 裡面的宣告會是

<div>
  <pre class="brush: php; title: ; notranslate" title="">class MY_Email extends CI_Email {

}</pre>
</div>

所以很自然的可以擴充 Email Library。假如 1. application/libraries/MY\_Email.php 不存在，系統很自然接著讀取 2. application/libraries/Email.php 或 3. system/libraries/Email.php。所以讀取檔案的結論就是 MY\_ 命名開頭為優先。最後來看看如何 initialize Class。此部份會跟檔案命名有很大的關係，如果以 MY_ 為檔名開頭，那 Class 就要宣告為

<div>
  <pre class="brush: php; title: ; notranslate" title="">class MY_Email {

}</pre>
</div>

以擴充 Email 例子來說會變成底下程式碼載入

<div>
  <pre class="brush: php; title: ; notranslate" title="">class CI_Email {
    ....
}

class MY_Email extends CI_Email {
    ....
}</pre>
</div>

如果是非 MY_ 開頭的 Library，例如自訂 ses.php 的話，裡面的 Class 可以取名為

<div>
  <pre class="brush: php; title: ; notranslate" title="">class CI_Ses {
    ....
}


class MY_Ses {
    ....
}


class Ses {
    ....
}</pre>
</div>

這三種方式都可以，讀取順序為由上到下，但是一般我們都是以最後一個為主。所以假設你覆蓋系統內建的 Email library，你可以建立 application/libraries/Email.php，並且檔案內容宣告為底下即可

<div>
  <pre class="brush: php; title: ; notranslate" title="">class Email {
    ....
}</pre>
</div>

最後可以參考<a href="http://www.codeigniter.org.tw/user_guide/general/creating_libraries.html" target="_blank">線上文件</a>