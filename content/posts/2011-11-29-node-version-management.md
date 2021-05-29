---
title: Node.js Version Management 多版本管理
author: appleboy
type: post
date: 2011-11-29T05:37:19+00:00
url: /2011/11/node-version-management/
dsq_thread_id:
  - 487073104
categories:
  - javascript
  - NodeJS
tags:
  - CoffeeScript
  - javascript
  - NodeJS
  - npm

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6033708087/" title="nodejs-light by appleboy46, on Flickr"><img src="https://i1.wp.com/farm7.static.flickr.com/6199/6033708087_ff1a02a337_o.jpg?resize=260%2C71&#038;ssl=1" alt="nodejs-light" data-recalc-dims="1" /></a>
</div> 相信大家對於 

<a href="http://nodejs.org" target="_blank">Node.js</a> 版本 Release 太快而感到困擾，每次新版出來，就要開始升級原本的版本，加上測試及修改，一定會浪費不少時間在上面，不管是任何語言我都希望能有一套 Version Management 來管理各版本之間的差異，以及讓使用者可以隨時切換版本來使用測試。那今天來介紹一套 <a href="https://github.com/visionmedia/n" target="_blank">Node.js Version Management</a>，這隻程式是用 shell script 下去撰寫，可以安裝多版本在 Linux 本機上面，隨時都可以切換不同版本測試。此作者也是 <a href="http://expressjs" target="_blank">expressjs Framework</a> 發起者。 <!--more--> 相信操作方式非常簡單，可以參考 

<a href="https://github.com/visionmedia/n" target="_blank">Readme</a> 來安裝測試，我要另外補充的是在 <a href="http://blog.nodejs.org/2011/11/25/node-v0-6-3/" target="_blank">0.6.3</a> 的版本，官方已經 <a href="http://npmjs.org/" target="_blank">npm</a> (node package manager) 包在裏面了，也就是安裝好此版本，就可以直接使用 npm 指令。但是在 <a href="https://github.com/visionmedia/n" target="_blank">Node.js Version Management</a> 似乎沒有加上 npm 的指令功能，所以我也發了 <a href="https://github.com/visionmedia/n/pull/43" target="_blank">pull request</a> 給作者，不知道作者會不會加上去就是了。如果想先使用，可以透過我的 <a href="https://github.com/appleboy/" target="_blank">github</a> 來安裝。 

### 安裝 Node.js Version Management

<pre class="brush: bash; title: ; notranslate" title="">$ git clone https://appleboy@github.com/appleboy/nvm.git
$ cd n
$ cp bin/n /usr/local/bin</pre>

### 使用 npm 安裝 nodejs 0.6.3 

<pre class="brush: bash; title: ; notranslate" title="">$ n 0.6.3</pre> 安裝 

<a href="http://jashkenas.github.com/coffee-script/" target="_blank">Coffee-script</a> 套件 

<pre class="brush: bash; title: ; notranslate" title="">$ n npm 0.6.3 install coffee-script</pre> 查詢以安裝套件 

<pre class="brush: bash; title: ; notranslate" title="">$ n npm 0.6.3 list</pre> PS. 

**<span style="color:red">npm 只有大於或等於 0.6.3 版本才有內建</span>**