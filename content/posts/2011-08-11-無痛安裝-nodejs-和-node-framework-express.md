---
title: 無痛安裝 NodeJS 和 Node Framework Express
author: appleboy
type: post
date: 2011-08-11T07:25:04+00:00
url: /2011/08/無痛安裝-nodejs-和-node-framework-express/
dsq_thread_id:
  - 382902796
categories:
  - javascript
  - NodeJS
  - Ubuntu
tags:
  - Express
  - javascript
  - NodeJS

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6033708087/" title="nodejs-light by appleboy46, on Flickr"><img src="https://i1.wp.com/farm7.static.flickr.com/6199/6033708087_ff1a02a337_o.jpg?resize=260%2C71&#038;ssl=1" alt="nodejs-light" data-recalc-dims="1" /></a>
</div>

<a href="http://nodejs.org/" target="_blank">NodeJS</a> 是目前當紅的 Web 2.0 技術，去年 <a href="http://coscup.org/2010/zh-tw/program/" target="_blank">COSCUP 2010</a> 就有 <a href="http://www.KKBOX.com.tw" target="_blank">KKBOX</a> 資深工程師 ericpi 來探討這個議題，NodeJS 背後使用了 V8 引擎為基礎，沒看過用純 JS 來當 Server-Side 吧，台灣很紅的 Plurk 也是大量使用 NodeJS，然而每開發一種語言，就會想開始找搭配的 Framework，那就首推 <a href="http://expressjs.com/" target="_blank">Node Framework Express</a> 來撰寫程式，本篇是要介紹如何在 Ubuntu 10.10 無痛安裝 nodejs + express。 

### 下載 Nodejs 原始碼 直接到

<a href="http://nodejs.org/#download" target="_blank">官網下載 Stable 的版本</a>吧，目前是 node-v0.4.10.tar.gz，也可以先看看 <a href="http://nodejs.org/docs/v0.4.10/api/index.html" target="_blank">API Document</a> 

<pre class="brush: bash; title: ; notranslate" title=""># wget http://nodejs.org/dist/node-v0.4.10.tar.gz</pre>

<!--more-->

### 安裝 Ububtu 相關套件

<pre class="brush: bash; title: ; notranslate" title="">$ sudo apt-get install python libssl-dev g++</pre> 下面會使用最原始的編譯方式，所以必須安裝 g++ 套件，否則下 ./configure 的時候，會吐出來沒有安裝過的套件。 

### 安裝 Nodejs 套件 兩種方法：1.用 apt-get install nodejs 2. 用 tar 方式原始編譯 原始編譯過程如下: 

<pre class="brush: bash; title: ; notranslate" title="">$ mkdir ~/opt/ && cd opt
$ tar -zxvf node-v0.4.10.tar.gz 
$ cd node-v0.4.10/
$ ./configure --prefix=~/opt/node</pre> 到這裡，如果 compiler 成功，就會產生出 Makefile，如果中間遇到錯誤訊息，大概都是套件沒有安裝，接著執行 

<pre class="brush: bash; title: ; notranslate" title="">$ make && make install</pre>

### 將執行檔路徑放到 PATH 修改 ~/.bashrc，增加底下 

<pre class="brush: bash; title: ; notranslate" title="">export PATH="$HOME/opt/bin/:$PATH"
export NODE_PATH="$HOME/opt/node:$HOME/opt/node/lib/node_modules"
# 重新執行 shell 或者是重新登入即可
source ~/.bashrc
</pre> 上面安裝步驟都可以參考 

<a href="https://github.com/joyent/node/wiki/Installation" target="_blank">Building and Installing Node.js</a> 

### 安裝 Nodejs 管理套件 npm npm 就類似 Ruby 的 gem，安裝方式很容易 

<pre class="brush: bash; title: ; notranslate" title="">curl http://npmjs.org/install.sh | sh</pre> 假如您是用 apt-get 安裝 nodejs 的話，請修改 install.sh 

<pre class="brush: bash; title: ; notranslate" title=""># make sure that node exists
node=`which node 2>&1`</pre> 改成 

<pre class="brush: bash; title: ; notranslate" title=""># make sure that node exists
node=`which nodejs 2>&1`</pre> 接下來就是要安裝我們的開發環境 

<a href="http://expressjs.com/" target="_blank">Express</a> 這套 Nodejs Framework 

### 安裝 Express 安裝方式可以參考 

<a href="http://expressjs.com/guide.html" target="_blank">Express Guide</a> 

<pre class="brush: bash; title: ; notranslate" title="">$ npm install express -gd</pre> 解釋一下 -gd 的參數說明，-g 的用意是 executable install globally，也就是我們要在任何地方都可以執行 express 指令，另外 -d 則是將 node_modules 都安裝到 node lib 的目錄裡面，這樣開 express project 就不用再 npm install -d 了，大家可以透過底下兩個指令來瞭解 

<pre class="brush: bash; title: ; notranslate" title="">$ npm list -g
$ npm list</pre>

### 建立 Express 專案

<pre class="brush: bash; title: ; notranslate" title="">$ express foo && cd foo</pre> 直接執行 node app.js 如下 

<pre class="brush: bash; title: ; notranslate" title="">Express server listening on port 3000 in development mode</pre> 看到此訊息就是代表成功了，直接打開瀏覽器 http://localhost:3000 可以看到 Express 歡迎畫面 更多 Express Example 可以參考 

<a href="https://github.com/" target="_blank">github</a> 上面的 <a href="https://github.com/visionmedia/express" target="_blank">Express 專案</a> Ref: <a href="http://blog.labin.cc/?p=790" target="_blank">node.js第二講：安裝node.js與express.js</a> <a href="http://blog.labin.cc/?p=765" target="_blank">node.js第一講：簡介</a>