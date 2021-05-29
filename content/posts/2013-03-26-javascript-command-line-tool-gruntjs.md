---
title: Javascript command line tool GruntJS 介紹
author: appleboy
type: post
date: 2013-03-26T07:35:21+00:00
url: /2013/03/javascript-command-line-tool-gruntjs/
dsq_thread_id:
  - 1165337908
categories:
  - javascript
  - NodeJS
tags:
  - Grunt
  - GruntJS
  - NodeJS
  - npm

---
**Update: 補上一張執行後的截圖 2013.03.27** 

<div style="margin: 0 auto; text-align: center;">
  <a title="gruntlogo by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/8591850168/"><img alt="gruntlogo" src="https://i2.wp.com/farm9.staticflickr.com/8244/8591850168_ca0e125ffa_n.jpg?resize=320%2C320&#038;ssl=1" data-recalc-dims="1" /></a>
</div>

<a href="http://gruntjs.com/" target="_blank">GruntJS</a> 是一套 JavaScript Task Runner，為什麼官網會這樣寫呢？網站上線之前，是不是需要經過測試，壓縮，及品質控管，這些 Task 該如何實現，在 GruntJS 還沒出現之前，大家可以透過 Linux command 的方式來達成，但是對於前端工程師而言，多學習 command line 真的是要他們的命，所以 GruntJS 解決了此問題，將所有的 Task 用 Javascript 方式設定就可以自動佈署或測試。GruntJS 的 Plugin 也非常多且完整，像是大家常用的 <a href="http://coffeescript.org/" target="_blank">CoffeeScript</a>、<a href="http://handlebarsjs.com/" target="_blank">Handlebars</a>、<a href="http://jade-lang.com/" target="_blank">Jade</a>、<a href="http://www.jshint.com/" target="_blank">JsHint</a>、<a href="http://lesscss.org/" target="_blank">Less</a>、<a href="http://sass-lang.com/" target="_blank">Sass</a>、<a href="http://compass-style.org/" target="_blank">Compass</a>、<a href="http://learnboost.github.com/stylus/" target="_blank">Stylus</a>…等都有支援。更多好用的 Plugin 可以在<a href="http://gruntjs.com/plugins" target="_blank">官網搜尋頁面</a>上找到。 

### 安裝方式 Grunt 可以透過 

<a href="http://nodejs.org/" target="_blank">Node.js</a> 的管理工具 <a href="https://npmjs.org/" target="_blank">npm</a> 方式來安裝，Windows 只要到 Node.js 官網下載安裝包，直接按下一步即可安裝完畢，Linux 可以透過 NVM 方式來管理 Node.js 版本，可以參考作者之前寫的 <a href="http://blog.wu-boy.com/2013/01/node-version-manager/" target="_blank">Node Version Manager 版本管理 NVM</a>。需要注意的是 Grunt 0.4.x 需要 Node.js <span style="color: red;"><strong>>= 0.8.0</strong></span> 版本才可以。 <!--more--> 如果之前已經安裝 Grunt 請先移除安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ npm uninstall -g grunt</pre> Linux 請切換到 root 使用者來安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ npm install -g grunt-cli</pre>

### 準備新專案 在使用 Grunt 指令前，請在專案目錄內新增 

**<span style="color:green">package.json</span>** 及 **<span style="color:green">Gruntfile.js</span>** 檔案 **<span style="color:red">package.json</span>**: 此檔案紀錄專案 metadata 以便將來做成 npm module，另外也會記載專案內所用到 Grunt plugins 版本資訊，像是 <a href="https://npmjs.org/doc/json.html#devDependencies" target="_blank">devDependencies</a> 設定。 **<span style="color:red">Gruntfile.js</span>**: 此檔案可以用 Coffscript.coffee 撰寫，用來紀錄工作內容及相關 Plugins 載入. PS. 如果是用 Grunt 0.3.x 版本，請命名為 **<span style="color:red">grunt.js</span>** 

### package.json 此檔案記載專案相關資訊，也包含了 GruntJS 所需要用到的 Plugins，範例如下(官網提供) 

<pre class="brush: bash; title: ; notranslate" title="">{
  "name": "my-project-name",
  "version": "0.1.0",
  "devDependencies": {
    "grunt": "~0.4.1",
    "grunt-contrib-jshint": "~0.1.1",
    "grunt-contrib-nodeunit": "~0.1.2"
  }
}</pre> 建立此檔案後，在專案目錄內，執行 

<span style="color:green"><strong>npm install</strong></span>，會發現專案內多了 **<span style="color:red">node_modules</span>** 目錄。可以將此目錄名稱加入到 <span style="color:green"><strong>.gitignore</strong></span>，免的不小心 commit 到伺服器。如果不想手動更改 devDependencies 資訊，其實可以透過 <span style="color:green"><strong>npm install grunt --save-dev</strong></span> 方式加入到 devDependencies 裡。 

### Gruntfile.js 可以透過 Gruntfile.coffee 或 Gruntfile.js 來產生檔案，此命名適用於 0.4.x 版本，如果是 0.3.x 版本請命名為 grunt.js。此檔案會包含底下部份 

<pre class="brush: bash; title: ; notranslate" title="">* wrapper 寫法
* 專案及任務設定
* 載入 Grunt Plugins 和任務內容
* 定義特定任務</pre> 拿官網的例子來介紹: 

<pre class="brush: jscript; title: ; notranslate" title="">module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! &lt;%= pkg.name %> &lt;%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'src/&lt;%= pkg.name %>.js',
        dest: 'build/&lt;%= pkg.name %>.min.js'
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Default task(s).
  grunt.registerTask('default', ['uglify']);

};</pre> 在 package.json 裡面設定安裝 

<a href="https://github.com/gruntjs/grunt-contrib-uglify" target="_blank">grunt-contrib-uglify</a> 套件，uglify 任務就是將 Javascript 檔案壓縮，當我們執行 grunt 指令時，Grunt 會執行預設的任務 uglify。上面有提到四點 Grunt 檔案會包含的項目，其中第一點是 wrapper 寫法，也就是上面例子內的 

<pre class="brush: jscript; title: ; notranslate" title="">module.exports = function(grunt) {
  // Do grunt-related things in here
};</pre> 接著注意專案的設定，也就是底下內容 

<pre class="brush: jscript; title: ; notranslate" title="">// Project configuration.
grunt.initConfig({
  pkg: grunt.file.readJSON('package.json'),
  uglify: {
    options: {
      banner: '/*! &lt;%= pkg.name %> &lt;%= grunt.template.today("yyyy-mm-dd") %> */\n'
    },
    build: {
      src: 'src/&lt;%= pkg.name %>.js',
      dest: 'build/&lt;%= pkg.name %>.min.js'
    }
  }
});</pre> 所有的工作項目設定都會寫在 g

<a href="http://gruntjs.com/grunt#grunt.initconfig" target="_blank">runt.initConfig</a> 裡面，看到第一行 <span style="color:green"><strong>grunt.file.readJSON("package.json")</strong></span>，將 package.json 內容讀到 pkg 變數，接著參數設定就可以使 **<span style="color:red"><% %></span>** 方式讀取。uglify 工作項目內的 options 設定可以直接參考 <a href="https://github.com/gruntjs/grunt-contrib-uglify" target="_blank">grunt-contrib-uglify</a>，我們可以定義多個 target 來區分多個工作內容，範例如下 

<pre class="brush: jscript; title: ; notranslate" title="">// Project configuration.
grunt.initConfig({
  pkg: grunt.file.readJSON('package.json'),
  uglify: {
    options: {
      banner: '/*! &lt;%= pkg.name %> &lt;%= grunt.template.today("yyyy-mm-dd") %> */\n'
    },
    build: {
      src: 'src/&lt;%= pkg.name %>.js',
      dest: 'build/&lt;%= pkg.name %>.min.js'
    },
    my_target_1: {
      options: {
        sourceMap: 'path/to/source-map.js'
      },
      files: {
        'dest/output.min.js': ['src/input.js']
      }
    },
    my_target_2: {
      options: {
        sourceMap: 'path/to/source-map.js',
        sourceMapRoot: 'http://example.com/path/to/src/',
        sourceMapIn: 'example/coffeescript-sourcemap.js'
      },
      files: {
        'dest/output.min.js': ['src/input.js']
      }
    }
  }
});</pre> 完成基本 Grunt Plugin 設定，接著將此 Plugin 載入 

<pre class="brush: jscript; title: ; notranslate" title="">// Load the plugin that provides the "uglify" task.
grunt.loadNpmTasks('grunt-contrib-uglify');</pre> 最後定義預設的任務 

<pre class="brush: jscript; title: ; notranslate" title="">// Default task(s).
grunt.registerTask('default', ['uglify']);</pre> Grunt 設定檔就完成了，可以來進行測試，我們可以直接下 

**<span style="color:green">grunt</span>** 指令，系統會自動跑預設任務，也就是 uglify，也或者如果有多個任務時，你只想執行 uglify 任務，請將指令改成 **<span style="color:green">grunt uglify</span>**，如果是想要執行 uglify 任務內的 my\_target\_2 項目呢？請直接下 **<span style="color:green">grunt uglify:my_target_2</span>**。 基本介紹到這裡，大家對於 Grunt.js 應該都有基本的瞭解。最後補張執行後的圖 

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8594641220/" title="GruntJS by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8525/8594641220_7f993b2ac0.jpg?resize=486%2C500&#038;ssl=1" alt="GruntJS" data-recalc-dims="1" /></a>
</div>