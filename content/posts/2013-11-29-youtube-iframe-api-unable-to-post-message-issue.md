---
title: Youtube IFrame API Unable to post message Issue
author: appleboy
type: post
date: 2013-11-29T08:43:31+00:00
url: /2013/11/youtube-iframe-api-unable-to-post-message-issue/
dsq_thread_id:
  - 2009403810
categories:
  - Google
  - javascript
  - jQuery
tags:
  - API
  - google
  - IFrame
  - javascript
  - Youtube API

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/11113610676/" title="Solid_color_You_Tube_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5474/11113610676_bcbbbe5164_n.jpg?resize=320%2C128&#038;ssl=1" alt="Solid_color_You_Tube_logo" data-recalc-dims="1" /></a>
</div>

<a href="https://developers.google.com/youtube/iframe_api_reference" target="_blank">YouTube IFrame Player API</a> 提供了簡單的介面及方法，讓網站可以快速整合 Youtube 影片，但是不得不說 Google 針對 Youtube API 時常改版，所以就會常常碰道友時候可以動，有時後不可以動。<a href="http://apiblog.youtube.com/2011/02/https-support-for-youtube-embeds.html" target="_blank">Youtube 在 2011 公告開始支援 https protocol</a>，所以現在很多網站存取 Youtube API 時，都會使用底下寫法 

<pre class="brush: jscript; title: ; notranslate" title=""></pre>

<!--more--> 也就是你的網站只支援 

**<span style="color:green">http://</span>** 時，就會去讀取 **<span style="color:green">http://www.youtube.com/iframe_api</span>**，但是透過 YT.Player 物件來產生多個 Youtube 影音時，就會出現底下錯誤訊息，導致 Javascript API 無法控制 Youtube 影片 

> Unable to post message to http://www.youtube.com Recipient has origin: https://www.youtube.com/ 這問題在 <a href="http://stackoverflow.com" target="_blank">Stackoverflow</a> 被提出來多次，我自己針對 Youtube API 產生下面的解法，只要按照底下方式操作，就不會產生任何錯誤訊息了 1. load iframe api <a href="https://www.youtube.com/player_api" target="_blank">https://www.youtube.com/player_api</a> 2. load iframe src path: <a href="https://www.youtube.com/embed/0GN2kpBoFs4?rel=0" target="_blank">https://www.youtube.com/embed/0GN2kpBoFs4?rel=0</a> 如果有使用 YT.Player 動態產生 Youtube 元件，請務必檢查 src 的 protocol 

<pre class="brush: jscript; title: ; notranslate" title="">setTimeout(function(){
    var url = $('#iframe_youtube').prop('src');
    if (url.match('^http://') {
        $('#iframe_youtube').prop('src', url.replace(/^http:\/\//i, 'https://'));
    }
}, 500);</pre> 如果確定都是透過 https:// 來跟 Youtube 溝通，那就不會產生 postMessage 無法收到的問題，這解法我也有更新在 

<a href="https://code.google.com/p/gdata-issues/issues/detail?id=4697#c13" target="_blank">Google 論壇上</a>，另外原發問者也有將我提供的解法，轉到 <a href="http://stackoverflow.com/questions/20063255/unable-to-post-message-to-http-www-youtube-com-recipient-has-origin-https-w" target="_blank">Stackoverflow 解答區</a>，大致上是這樣。