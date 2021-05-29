---
title: 壓縮 Javascript 和 CSS 檔案 script command
author: appleboy
type: post
date: 2013-02-21T10:45:48+00:00
url: /2013/02/compress-css-javascript-script-command/
dsq_thread_id:
  - 1096414228
categories:
  - CSS
  - Embedded System
  - javascript
  - NodeJS
tags:
  - NodeJS
  - npm
  - sqwish
  - UglifyJS

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6033708087/" title="nodejs-light by appleboy46, on Flickr"><img src="https://i1.wp.com/farm7.static.flickr.com/6199/6033708087_ff1a02a337_o.jpg?resize=260%2C71&#038;ssl=1" alt="nodejs-light" data-recalc-dims="1" /></a>
</div> 網站上站前要做的事情非常多，其中一項為大家所知就是壓縮 

<a href="http://www.w3schools.com/css/" target="_blank">CSS</a> 跟 <a href="http://www.w3schools.com/js/default.asp" target="_blank">JavaScript</a> 檔案，減少 Http request 流量，網路上已經有非常多的 Compressor tool，像是 <a href="https://developers.google.com/closure/compiler/" target="_blank">Google Closure Compiler</a> 或 <a href="http://yui.github.com/yuicompressor/" target="_blank">YUI Compressor</a>，都是用來壓縮 JS 或 CSS 檔案，這次寫了 script 來壓縮整個網站目錄裡的 js 或 css 檔案，不過 script 所使用的 Compressor command 是 Node Base 的 tool，分別是 <a href="https://github.com/mishoo/UglifyJS2" target="_blank">UglifyJS</a> 及 <a href="https://github.com/ded/sqwish" target="_blank">sqwish</a> 這兩套，當然使用 command 之前，請務必先安裝好 <a href="http://nodejs.org/" target="_blank">Node.js</a> 最新版本啦，不過沒安裝也沒關係，底下有懶人安裝 script command。這些 tool 對於 Embedded System 在 build firmware 相當有用，可以減少不少 code size 阿。 可以直接看<a href="https://github.com/appleboy/minify-tool" target="_blank">專案說明</a>，就可以不必看底下步驟了 <!--more-->

### 系統環境安裝 由於系統內必須安裝 Node.js，才會有 

<a href="https://npmjs.org/" target="_blank">NPM</a> 指令，我們可以透過 <a href="https://github.com/appleboy/nvm" target="_blank">NVM</a> 來管理機器各個 Node.js 版本。別擔心，已經有寫好 script 可以一鍵安裝，非常懶人。 

<pre class="brush: bash; title: ; notranslate" title="">$ git clone https://github.com/appleboy/minify-tool.git build
$ chmod +x ./build/minify
$ ./build/install.sh</pre> 上述執行完成，就可以使用 UglifyJS 及 sqwish command 了。 

### 使用方式 接著想針對不同專案來壓縮其目錄內所有的 js 及 css 檔案，執行方式如下 

<pre class="brush: bash; title: ; notranslate" title="">$ ./build/minify your_project_folder_path</pre> 如果你想保留原來目錄，而另外產生新的目錄來執行，可以透過 [--output|-o] 參數來執行 

<pre class="brush: bash; title: ; notranslate" title="">$ ./build/minify your_project_folder_path -o output_folder_path</pre> 這樣就可以了，非常簡單，目前只有支援 UglifyJS 及 sqwish command，將來預計還會支援各種壓縮工具，如果有什麼好用的工具可以介紹，請歡迎留言。 最後補上 Script 專案目錄: 

<a href="https://github.com/appleboy/minify-tool" target="_blank">minify-tool</a>