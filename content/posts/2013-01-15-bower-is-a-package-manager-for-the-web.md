---
title: Bower 管理網站套件的好工具
author: appleboy
type: post
date: 2013-01-15T03:34:00+00:00
url: /2013/01/bower-is-a-package-manager-for-the-web/
dsq_thread_id:
  - 1026289335
categories:
  - javascript
  - NodeJS
  - www
tags:
  - Bower
  - Twitter

---
**Update: bower 在 0.9.0 版以前可以使用 <span style="color:red">component.json</span>，但是為了避免跟其他工具命名衝突，故 0.9.0 以後版本請改為 <span style="color:green">bower.json</span>** <a href="http://twitter.github.com/bower/" target="_blank">bower</a> 是 <a href="http://twitter.com" target="_blank">Twitter</a> 團隊開發的一套網頁工具，用來管理或安裝 Web 開發所需要的 Package，像是 CSS 和 JavaScript，也可以依據套件的相依性來安裝，簡單來說，開發者不用再去煩惱套件相依性問題，以及時間久了想更新最新版本，還要到各 Package 網站來下載，這些步驟都省了，一個指令就可以全部做完上述的步驟。 

### 安裝 Bower 管理套件 透過 

<a href="http://nodejs.org/" target="_blank">Node.js</a> 的 npm 工具來安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ npm install bower -g</pre>

<!--more-->

### 使用方式 可以透過 bower --help 來查看如何使用，底下來一一介紹，假設要安裝 jQuery 套件，請執行底下指令 

<pre class="brush: bash; title: ; notranslate" title="">$ bower install bootstrap spine jquery</pre> 接著該如何查詢已經安裝的套件: 

<pre class="brush: bash; title: ; notranslate" title="">$ bower list</pre> 執行上述指令，會列出專案安裝的套件名稱及版號 

<pre class="brush: bash; title: ; notranslate" title="">/home/www
├── backbone-amd#0.9.9
├── handlebars#1.0.0-rc.1
├── jquery#1.8.3
├── requirejs#2.1.2
└── underscore-amd#1.4.3</pre> 移除已安裝的套件: 

<pre class="brush: bash; title: ; notranslate" title="">$ bower uninstall jquery</pre> 升級已安裝套件: 

<pre class="brush: bash; title: ; notranslate" title="">$ bower update jquery</pre> 搜尋套件: 

<pre class="brush: bash; title: ; notranslate" title="">$ bower search jquery</pre>

### Bower 設定檔 bower 預設安裝的目錄是 components 所以一般 bower install 後，你會看到專案目錄底下會多個 components/xxxx，要改變路徑其實很簡單，你可以在自己家目錄新增 

<span style="color:green">~/bowerrc</span> 檔案，或者是在專案裡面增加 <span style="color:green">.bowerrc</span> 設定檔，檔案內容如下 

<pre class="brush: bash; title: ; notranslate" title="">{
    "directory" : "assets/javascript/vendor"
}</pre> 這樣就可以將套件安裝在 

<span style="color:green"><strong>assets/javascript/vendor</strong></span> 目錄 

### Bower 套件相依性 在專案目錄底下新增 

<span style="color:green"><strong><del datetime="2013-08-20T07:36:58+00:00">component.json</del></strong></span> <span style="color:green"><strong>bower.json</strong></span> 檔案，裡面寫入 (或者可透過 bower init 來初始化專案) 

<pre class="brush: bash; title: ; notranslate" title="">{
    "name": "xxxxx",
    "version": "1.0.0",
    "dependencies": {
        "jquery": "1.8.3",
        "backbone-amd": null,
        "underscore-amd": null,
        "requirejs": null
    }
}</pre> 完成存檔後，請在專案目錄底下執行 bower install，會發現所有套件都會被安裝到 

<span style="color:green"><strong>assets/javascript/vendor</strong></span> 目錄，版號的定義請按照 <a href="http://semver.org" target="_blank">semver 標準</a>。 上述 bower 安裝的套件，如果搭配 git 控制的話，就不要將上述安裝的原始擋加入版本控制，可以新增 <span style="color:green"><strong>assets/javascript/vendor</strong></span> 目錄，並且在該目錄丟入 .gitignore，接著在將 <span style="color:green"><strong>assets/javascript/vendor</strong></span> 寫入 .gitignore 即可。