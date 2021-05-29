---
title: Front End Engineer 前端設計師必備工具 Live.js
author: appleboy
type: post
date: 2011-11-04T03:46:41+00:00
url: /2011/11/front-end-engineer-love-livejs/
dsq_thread_id:
  - 461579684
categories:
  - CSS
  - javascript
tags:
  - CSS
  - javascript
  - Live.js
  - LiveReload

---
<div style="margin: 0 auto; text-align: center;">
  <a title="Livejs by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/6311229214/"><img src="https://i0.wp.com/farm7.static.flickr.com/6058/6311229214_14677a9114.jpg?resize=304%2C105&#038;ssl=1" alt="Livejs" data-recalc-dims="1" /></a>
</div> 在不久之前介紹一篇: 

<a href="http://blog.wu-boy.com/2011/10/how-to-install-livereload/" target="_blank">LiveReload 網頁程式設計師必備工具</a>，該篇適合用在寫後端+前端的開發者，對於剛開始摸網頁的初學者可能不是很容易就上手，加上在 Windows 或 Linux 上面需要一點安裝步驟。不久之前在 <a href="http://www.codeigniter.org.tw/irc" target="_blank">IRC 頻道 #codeigniter.tw</a> 有網友熱心提供一套好用工具 <a href="http://livejs.com/" target="_blank">Live.js</a>，這一套幫助您開發前端設計的部份，也就是 Javascript Html 跟 CSS，一樣讓您不用在切換視窗 Alt+TAB，只要您任何時間修改了 HTML + CSS + Javascript，視窗就會自動重新 reload，底下整理該工具特性 

  * 只有支援 Html JavaScript CSS 三種格式
  * 只有支援網站 Local 檔案，也就是必須是同網域
  * 並不支援 File:// 協定，換句話說必須有 Web Server (<a href="http://www.apache.org/" target="_blank">Apache</a> or <a href="http://www.lighttpd.net/" target="_blank">Lighttpd</a> or <a href="http://wiki.nginx.org/" target="_blank">Nginx</a>)

<!--more--> 大家一定很想知道為什麼 Live.js 可以知道檔案更改的狀態，其實原理蠻簡單的，在 JS 每秒偵測一次全部 js html css 檔案，比對 Header 內容，只要是跟原本 Header value 有不相同，js 跟 html 會用 

<span style="color:red"><strong>document.location.reload();</strong></span>  方式重新整理，另外 CSS 部份則是會 Remove 舊的 link，換上新的 <span style="color:red"><strong>css?now=new Date() * 1</strong></span>。原理大致上是如此，接著我們該如何使用它呢，非常簡單，只要把下面的 Link 直接拉到 Chrome 的 Tool Bar 即可。 use the bookmarklet! Drag the following link to your bookmarks bar: [Live.js][1]

 [1]: javascript:(function(){document.body.appendChild(document.createElement('script')).src='http://livejs.com/live.js#css,notify';})(); "Drag me to your bookmarks bar!"