---
title: '[AJAX] google map 的應用～'
author: appleboy
type: post
date: 2008-10-04T14:44:02+00:00
url: /2008/10/ajax-google-map-的應用～/
views:
  - 11609
bot_views:
  - 1107
dsq_thread_id:
  - 246768921
categories:
  - AJAX
  - Linux
  - Network
  - php
  - wordpress
tags:
  - AJAX
  - google
  - Linux
  - php

---
嗯嗯，我自己的 blog 有在寫美食，就會有美食地點，當然我覺得把 [google map api][1] 整合進來，是不錯的方法，其實 google map 也提供了只要輸入地址，就可以直接幫妳對應經度跟緯度的值，這樣就可以利用 ajax 的技術把資料庫裡面的地址都加上 google map 了，至少之前 [高雄線上][2] 是這樣加上所有店家資訊的地址 google map，其實要使用 google map 相當容易，其實妳只要按照下面步驟就可以了： 

<ol class="doublespace">
  <li>
    <a href="http://code.google.com/apis/maps/signup.html">Sign up for a Google Maps API key.</a>
  </li>
  <li>
    Read the <a href="http://code.google.com/apis/maps/documentation/index.html">Maps API Concepts</a>.
  </li>
  <li>
    Check out some <a href="http://code.google.com/apis/maps/documentation/examples/">Maps API Examples</a>.
  </li>
  <li>
    Read the <a href="http://code.google.com/apis/maps/documentation/reference.html">Maps API Reference</a>.
  </li>
</ol>

<!--more--> 1. 先申請 

[google map 的 api key][3] 填入網址之後，他會給妳一組 api key 就是 js 要寫入的部份，底下是官方提供的範例： 

<pre class="brush: xml; title: ; notranslate" title="">

  
  
    

<div id="map" style="width: 500px; height: 300px">
  
</div>
  
</pre> 裡面其中的這一段： 

<pre class="brush: jscript; title: ; notranslate" title="">#
# google map api key
</pre> 其實可以利用 Google&#8217;s AJAX APIs 改寫成： 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 如果你要用 google translate language api 可以用： 

<pre class="brush: jscript; title: ; notranslate" title="">//google language api
google.load("language", "1");</pre> 接下來是使用官方提供的地址轉換經度緯度功能，然後在小小的修改就可以了： 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 接下來只要在blog文章裡面使用： 

<pre class="brush: xml; title: ; notranslate" title=""><div id="map_address2" style="width: 500px; height: 300px">
  
</div>
</pre> 這樣就可以了喔

 [1]: http://code.google.com/apis/maps/
 [2]: http://www.kaoh.com.tw/
 [3]: http://code.google.com/apis/maps/signup.html