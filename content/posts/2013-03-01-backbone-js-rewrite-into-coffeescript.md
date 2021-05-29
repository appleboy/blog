---
title: Backbone.js rewrite into CoffeeScript?
author: appleboy
type: post
date: 2013-03-01T13:56:59+00:00
url: /2013/03/backbone-js-rewrite-into-coffeescript/
dsq_thread_id:
  - 1112104010
categories:
  - Backbone.js
  - javascript
tags:
  - Backbone.js
  - CoffeeScript
  - JavaScrpt

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/7059615321/" title="backbone by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.staticflickr.com/5338/7059615321_097833dea8.jpg?resize=451%2C80&#038;ssl=1" alt="backbone" data-recalc-dims="1" /></a>
</div> 看到 

<a href="https://github.com/gsamokovarov" target="_blank">@gsamokovarov</a> 提出將 <a href="http://backbonejs.org/" target="_blank">Backbone.js</a> 改寫成 <a href="http://coffeescript.org/" target="_blank">CoffeeScript</a> 架構的 <a href="https://github.com/documentcloud/backbone/pull/2317" target="_blank">Pull request</a>，結果官方團隊其中一位開發作者回應了一張圖，代表他的心情 XD，各位有興趣可以點上面連結看看，後來有其他人回應說，為什麼官方不用 CoffeeScript 來寫了，發此 Pull Request 的作者也有說，他只是將架構改成 CoffeeScript 讓大家參考看看而已，沒有真的希望可以納入整個 Backbone.js 專案，如果有其他開發者需要的話，一樣可以 fork 此<a href="https://github.com/gsamokovarov/backbone.coffee" target="_blank">專案</a>，說明文件也用 <a href="http://jashkenas.github.com/docco/" target="_blank">docco</a> 產生好了，可以參考此<a href="http://gsamokovarov.github.com/backbone.coffee/" target="_blank">連結</a>，官方作者也提到，大部份的第3方 Library 還是不會使用 CoffeeScript 來當作基底開發，畢竟並非所有人都知道 CoffeeScript，如果官方想這麼開發的話，早就再 2010 年丟釋出 Backbone.js 的時候就直接採用了，不會拖到現在還沒出來，當然最後官方也希望將此 pull request 寫到 wiki 裡面給大家參考，等待原作者補開發動機及細節。