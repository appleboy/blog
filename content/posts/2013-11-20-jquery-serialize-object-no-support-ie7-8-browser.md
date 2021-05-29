---
title: jquery-serialize-object 不支援 IE7,8 瀏覽器?
author: appleboy
type: post
date: 2013-11-20T06:54:03+00:00
url: /2013/11/jquery-serialize-object-no-support-ie7-8-browser/
dsq_thread_id:
  - 1981615218
categories:
  - Browser
  - IE
  - javascript
  - jQuery
tags:
  - browser
  - IE
  - JavaScrpt
  - jQuery

---
最近專案需求用到 <a href="https://github.com/macek/jquery-serialize-object" target="_blank">jQuery Serialize Object plugin</a>，它能夠自動將 Form 表單內的值，全部轉成 object 或 json 字串，減少開發者每次都要寫抓取 Form 表單內全部欄位的值。此套件安裝及使用方法都很容易，安裝可以透過 <a href="http://bower.io/" target="_blank">Bower</a> 方式，或者是下載 source code 直接 include 即可，在 IE 7 或 8 為什麼沒辦法使用呢，原因是作者使用了 <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach" target="_blank">Array.prototype.forEach</a>，此語法需要 JavaScript 1.6 版本，很抱歉，在 IE8 並不支援 forEach 寫法，所以 <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript" target="_blank">Mozilla Javascript 開發者文件</a>內有提供 Compatibility 方法： if (!Array.prototype.forEach) { Array.prototype.forEach = function (fn, scope) { 'use strict'; var i, len; for (i = 0, len = this.length; i < len; ++i) { if (i in this) { fn.call(scope, this[i], i, this); } } }; }[/code] 但是既然這是 <a href="http://plugins.jquery.com/" target="_blank">jQuery Plugin</a>，就可以透過 jQuery 內建的 <a href="http://api.jquery.com/each/" target="_blank">each</a> 函式來解決，最後發了 <a href="https://github.com/macek/jquery-serialize-object/pull/14" target="_blank">Pull request</a> 給作者，就看作者收不收了 XD