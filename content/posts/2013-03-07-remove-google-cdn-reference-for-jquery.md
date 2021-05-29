---
title: Remove Google CDN reference for jQuery?
author: appleboy
type: post
date: 2013-03-07T04:03:35+00:00
url: /2013/03/remove-google-cdn-reference-for-jquery/
dsq_thread_id:
  - 1122417306
categories:
  - javascript
  - jQuery
tags:
  - AMD
  - Bower
  - jQuery
  - RequireJs

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8442641115/" title="OQAAAI1PPrJY0nBALB7mkvju3mkQXqLmzMhxEjeb4gp8aujEUQcLfLyy-Sn4gZdkAas6-k8eYbQlGDE-GCjKfF5gIrUA15jOjFfLRv77VBd5t-WfZURdP9V3PdmT by appleboy46, on Flickr"><img src="https://i0.wp.com/farm9.staticflickr.com/8378/8442641115_8564013cea.jpg?resize=500%2C123&#038;ssl=1" alt="jquery logo" data-recalc-dims="1" /></a>
</div> 在 

<a href="http://html5boilerplate.com/" target="_blank">html5-boilerplate</a> 看到有人發 <a href="https://github.com/h5bp/html5-boilerplate/pull/1327" target="_blank">Remove Google CDN reference for jQuery</a> 的 pull request，發現國外鄉民其實蠻有趣的，也很會表達自己的想法，根據 <a href="http://statichtml.com/about.html" target="_blank">Steve Webster</a> 在 2011/11/21 寫了一篇 <a href="http://statichtml.com/2011/google-ajax-libraries-caching.html" target="_blank">Caching and the Google AJAX Libraries</a> 裡面的結論是: 使用 <a href="https://developers.google.com/speed/libraries/devguide?hl=zh-TW" target="_blank">Google CDN Library</a> 對於第一次訪問網站並沒有很大的幫助，其實這句話非常有疑問，如果網站不想 host 一些 static file 又想要用 CDN 的話，Google 絕對是最好的選擇，<a href="https://github.com/h5bp/html5-boilerplate/pull/1327#issuecomment-14537298" target="_blank">底下就有人反駁</a> Google CDN 還是比自己 host 檔案快很多，所以此 pull request 好像沒有啥意義。 <!--more--> 最好的解法，還是把全部的 script 檔案統一包成一個檔案，減少 http request (

<a href="http://developer.yahoo.com/performance/rules.html#num_http" target="_blank">bundling jQuery up with the rest of your site's JavaScript</a>)，那官方期望的解決方式就是用 <a href="https://github.com/twitter/bower" target="_blank">Bower</a> + <a href="https://github.com/amdjs/amdjs-api/wiki/AMD" target="_blank">AMD</a> + <a href="http://requirejs.org/docs/optimization.html" target="_blank">r.js</a>，對於一個上線網站，假如沒有做到這些事情，我想也不用考慮到 Google CDN 的速度了。