---
title: 利用 jQuery 動態改變網站 CSS
author: appleboy
type: post
date: 2010-10-07T10:05:49+00:00
url: /2010/10/利用-jquery-動態改變網站-css/
views:
  - 2651
bot_views:
  - 230
dsq_thread_id:
  - 246970384
categories:
  - CSS
  - javascript
  - jQuery
tags:
  - CSS
  - JavaScrpt
  - jQuery

---
繼前一篇所寫的『[jQuery 偵測瀏覽器版本, 作業系統(OS detection)][1]』，當我們遇到手機上網使用者，可以透過 javascript 來判斷目前使用者瀏覽器以及 OS，iPad user agent 如下: 

> Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10 我們必須分析上面字串來判斷是否用手機上網，手機網頁跟PC網頁大小一定有所不同，透過底下兩個方法來改變瀏覽器的畫面 

  * 自動導向手機網頁
  * 動態改變 CSS 兩個方法都不錯，如果決定使用前者，建議在 Server side 那邊做判斷，底下先列出 javascript, PHP, .htaccess 判斷檢查 

### The JavaScript

<pre class="brush: jscript; title: ; notranslate" title="">var isiPad = navigator.userAgent.match(/iPad/i) != null;</pre>

### The PHP

<pre class="brush: php; title: ; notranslate" title="">$isiPad = (bool) strpos($_SERVER['HTTP_USER_AGENT'],'iPad');</pre>

### The .htaccess

<pre class="brush: bash; title: ; notranslate" title="">RewriteCond %{HTTP_USER_AGENT} ^.*iPad.*$
RewriteRule ^(.*)$ http://ipad.yourdomain.com [R=301]</pre> 如果您在前端做判斷，那就使用 jQuery 方式: 

<pre class="brush: jscript; title: ; notranslate" title="">if(jQuery){
    jQuery("body").addClass("jq");
}
</pre> CSS 檔案: 

<pre class="brush: css; title: ; notranslate" title="">.someClass{
    display:block;
}
.jq .someClass{
    display:none;
}</pre> 如果不用 jQuery 就使用底下寫法: 

<pre class="brush: jscript; title: ; notranslate" title="">document.getElementsByTagName("body")[0].setAttribute("class", "js");</pre>

 [1]: http://blog.wu-boy.com/2010/10/06/2426/