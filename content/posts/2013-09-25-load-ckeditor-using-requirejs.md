---
title: RequireJS 搭配 CKEditor
author: appleboy
type: post
date: 2013-09-25T02:20:42+00:00
url: /2013/09/load-ckeditor-using-requirejs/
dsq_thread_id:
  - 1794281131
categories:
  - javascript
  - jQuery
tags:
  - CKeditor
  - jQuery
  - RequireJs

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/9911959726/" title="requirejs-logo by appleboy46, on Flickr"><img src="https://i0.wp.com/farm4.staticflickr.com/3677/9911959726_a40988a62d_o.png?resize=200%2C200&#038;ssl=1" alt="requirejs-logo" data-recalc-dims="1" /></a>
</div> 網頁編輯器大家推薦的就 

<a href="http://ckeditor.com/" target="_blank">CKEditor</a> 或 <a href="http://www.tinymce.com/" target="_blank">TinyMCE</a>，兩套各有優缺點，CKEditor 雖然功能最完整，也是最肥了，雖然官網可以自己挑選 plugin 來簡化肥肥的 source code。如果是單純用在後台管理，我還是推薦 CKEditor，給前端使用者的話，就推薦 TinyMCE 了，畢竟前台還是要以輕量為主。 <!--more--> CKEditor 用法很簡單，官網有提供搭配 

<a href="http://docs.ckeditor.com/#!/guide/dev_jquery" target="_blank">jQuery Adapter</a> 的方法，只要 include 下列三個檔案即可。 

<pre class="brush: xml; title: ; notranslate" title=""></pre> 接著在程式碼載入 CKEditor 

<pre class="brush: jscript; title: ; notranslate" title="">$('textarea.editor').ckeditor();</pre> 或 

<pre class="brush: jscript; title: ; notranslate" title="">$.when( $( '.editors' ).ckeditor().promise ).then( function() {
    // Now all editors have already been created.
} );</pre> 那該如何跟 

<a href="http://requirejs.org/" target="_blank">RequireJS</a> 整合，首先設定套件相依性，由於會用到 <a href="http://jquery.com/" target="_blank">jQuery</a> 

<pre class="brush: jscript; title: ; notranslate" title="">require.config({
  paths: {
    jquery: '../vendor/jquery/jquery',
  },
  shim: {
    'libs/ckeditor/ckeditor': {
        exports: 'CKEDITOR'
    },
    'libs/ckeditor/adapters/jquery': {
        deps: ['jquery', 'libs/ckeditor/ckeditor']
    }
  },
  urlArgs: (new Date()).getTime()
});</pre> 接著要使用的時候透過底下載入即可 

<pre class="brush: jscript; title: ; notranslate" title="">define([
    'jquery',
    'libs/ckeditor/ckeditor',
    'libs/ckeditor/adapters/jquery'
    ], function($) {
    $('textarea.editor').ckeditor();
});</pre> 到這邊沒有問題，接著搭配 

<a href="http://github.com/jrburke/r.js/" target="_blank">r.js</a>，將全部 Javascript 編譯整合成單個檔案，這時候你會發現編譯出來的檔案，無法載入 CKeditor，原因在於 CKeditor 會動態讀取 config.js 及相關設定檔，但是找不到路徑，所以必須在 index.html 內加入 CKEditor 全域路徑變數 

<pre class="brush: jscript; title: ; notranslate" title="">window.CKEDITOR_BASEPATH = window.location.pathname + 'assets/js/libs/ckeditor/';</pre> 這樣編譯完成的檔案就可以順利載入 CKEditor。 Ref: 

<a href="http://stackoverflow.com/questions/8713194/how-to-load-ckeditor-via-requirejs" target="_blank">How to load ckeditor via requirejs</a>