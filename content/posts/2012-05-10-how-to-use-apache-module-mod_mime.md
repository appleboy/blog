---
title: 如何使用 Apache Module mod_mime
author: appleboy
type: post
date: 2012-05-10T04:25:16+00:00
url: /2012/05/how-to-use-apache-module-mod_mime/
dsq_thread_id:
  - 683440069
categories:
  - apache
  - javascript
tags:
  - apache
  - javascript
  - RequireJs

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7168729996/" title="apache_software_foundation_logo_3074 by appleboy46, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8151/7168729996_452646f0f2_n.jpg?resize=320%2C169&#038;ssl=1" alt="apache_software_foundation_logo_3074" data-recalc-dims="1" /></a>
</div>

<a href="http://httpd.apache.org/" target="_blank">Apache</a> 可以透過 <a href="http://httpd.apache.org/docs/current/mod/mod_mime.html" target="_blank">mod_mime</a> 模組且根據使用者定義的副檔名來 response data 給 Client 端，此功能可以應用在前台搭配 Template Library，例如 <a href="http://mustache.github.com/" target="_blank">Mustache Logic-less templates</a>，透過此 Apache 模組 可以在 html 檔案將定義好全部 Template，一次讀取進來，底下舉個例子: 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 我們希望 apache 能夠讀取 assets/templates/test1.mustache，並且將檔案內容放到 script 裡面，這時候就必須在 apache httpd.conf 定義 

**<span style="color:green">text/x-mustache-template</span>** 

<pre class="brush: bash; title: ; notranslate" title="">&lt;IfModule mime_module>
    AddType text/x-mustache-template .mustache
    AddOutputFilter INCLUDES .mustache
&lt;/IfModule>
</pre>

<!--more--> 接著必須設定網站根目錄可以輸出 include file 

<pre class="brush: bash; title: ; notranslate" title="">&lt;Directory "C:/xampp/htdocs">
    Options All
    AllowOverride All
    SetOutputFilter INCLUDES
    Order allow,deny
    Allow from all
&lt;/Directory></pre> 上面例子是 

<a href="http://www.apachefriends.org/zh_tw/index.html" target="_blank">xampp</a> httpd.conf 檔，設定完成後重新啟動 apache，大家就可以發現，原本的 js 就會變成 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 這有個缺點就是，之後在轉移機器，就要在重新設定 Apache，為了省掉這個步驟，推薦大家使用 

<a href="http://requirejs.org/" target="_blank">RequireJs</a> 模組: <a href="http://requirejs.org/docs/download.html#text" target="_blank">Text plugin</a>。