---
title: '[jQuery]判斷 checkbox 是否選取，實現全選跟全部取消'
author: appleboy
type: post
date: 2008-12-23T05:50:02+00:00
url: /2008/12/jquery判斷-checkbox-是否選取，實現全選跟全部取消/
views:
  - 18206
bot_views:
  - 1293
dsq_thread_id:
  - 246706925
categories:
  - AJAX
  - javascript
  - jQuery
  - Network
  - www
tags:
  - javascript
  - jQuery

---
在 jQuery 底下要如何實現這個功能，其實還蠻簡單的，首先看 html 部份

<pre><code class="language-html">&lt;input name="user_active_col[]" type="checkbox" value="1"&gt; 1
&lt;input name="user_active_col[]" type="checkbox" value="2"&gt; 2
&lt;input name="user_active_col[]" type="checkbox" value="3"&gt; 3
&lt;input name="user_active_col[]" type="checkbox" value="4"&gt; 4
&lt;input name="user_active_col[]" type="checkbox" value="5"&gt; 5
&lt;input name="clickAll" id="clickAll" type="checkbox"&gt; 全選</code></pre>

<!--more-->

jQuery 部份如下：

<pre><code class="language-js">$("#clickAll").click(function() {
   if($("#clickAll").prop("checked")) {
     $("input[name=&#039;user_active_col[]&#039;]").each(function() {
         $(this).prop("checked", true);
     });
   } else {
     $("input[name=&#039;user_active_col[]&#039;]").each(function() {
         $(this).prop("checked", false);
     });
   }
});</code></pre>

可以不用 loop 方式，直接用一行解取代上面程式碼

<pre><code class="language-js">$("input[name=&#039;user_active_col[]&#039;]").prop("checked", true);</code></pre>