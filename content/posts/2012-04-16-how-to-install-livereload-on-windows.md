---
title: Windows 下安裝 Web Developer tool LiveReload
author: appleboy
type: post
date: 2012-04-16T03:08:05+00:00
url: /2012/04/how-to-install-livereload-on-windows/
dsq_thread_id:
  - 650997218
categories:
  - CSS
tags:
  - CSS
  - LiveReload

---
去年寫了一篇: <a href="http://blog.wu-boy.com/2011/10/how-to-install-livereload/" target="_blank">LiveReload 網頁程式設計師必備工具</a>，介紹如何在 FreeBSD 及 Linux 底下安裝 <a href="http://livereload.com/" target="_blank">Livereload</a>，相信過程也都不難，只是筆者目前有在 Windows 底下開發 Web，原本是透過 Linux 來使用 Livereload，但是我發現只有在 Chrome 才可以 Work，但是 FireFox 提供的 <a href="https://addons.mozilla.org/zh-tw/firefox/addon/livereload/" target="_blank">LiveReload :: Firefox 附加元件</a>，安裝之後，發現瀏覽器根本沒有出現按鈕讓使用者連接伺服器，所以這方法作罷，查了官網資料才知道已經有提供 Windows 安裝檔架設 Server，及 Browser extension 來連接伺服器。

<!--more-->

### 安裝 LiveReload Server

目前官網提供 <a href="http://download.livereload.com/LiveReload-0.0.3-Setup.exe" target="_blank">Pre-Alpha v0.0.3</a> 安裝包下載，下載之後，跟平常安裝 Window 軟體一樣，按下一步就可以了，完成後直接從程式集裡面啟動，並且加入需要偵測的目錄即可。

### 安裝 Browser extension

官網目前提供 <a href="http://help.livereload.com/kb/general-use/browser-extensions" target="_blank">Safari, Chrome, Firefox 2.0.8 版本</a>，大家可以根據 Browser 種類去下載，或是插入一段程式碼到 html file body 之前即可 

<pre class="brush: jscript; title: ; notranslate" title=""><script>document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1"></' + 'script>')</script></pre>