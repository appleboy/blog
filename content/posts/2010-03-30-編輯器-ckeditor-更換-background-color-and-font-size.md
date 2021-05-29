---
title: '[編輯器] CKeditor 更換 background-color and font-size'
author: appleboy
type: post
date: 2010-03-30T12:21:52+00:00
url: /2010/03/編輯器-ckeditor-更換-background-color-and-font-size/
views:
  - 4927
bot_views:
  - 723
dsq_thread_id:
  - 249223273
categories:
  - javascript
  - www
tags:
  - CKeditor
  - FCKeditor

---
[<img src="https://i2.wp.com/farm5.static.flickr.com/4024/4476260884_a9464cf0e5_o.png?resize=182%2C134&#038;ssl=1" alt="logo" data-recalc-dims="1" />][1] 相信大家在製作 Web 過程，一定會用到編輯器，然而 [CKeditor][2] 前身 [FCKeditor][3] 非常有名，FCKeditor 運行了六年之久，在去年2009年的時候，轉換成了 CKeditor，目前開發團隊也專注於此版本，現在已經推出到 [CKEditor 3.2 released!][4]，可以參考 [CKEditor 3.x - Developer's Guide][5]，裡面也整合了 [jQuery][6]，替很多開發者想到更多管道去整合網站，然而今天設計網站，需要改變編輯器的背景顏色，預設是白色背景，但是並非所有網站都是白色呈現，所以才需要動到背景顏色，這樣好讓使用者可以融入整個背景，在 [Plurk][7] 發表了這問題，也找了官方論壇，都沒有發現正確解答，官方論壇有篇類似問題：[Change the background color of the CKEditor text area][8]，這篇自己試過是沒有用的，正確解法可以參考 CKeditor 的 [API][9]:[contentsCss][10]。 1. 首先在 CKeditor 根目錄建立新檔案：mysitestyles.css 

<pre class="brush: css; title: ; notranslate" title="">body
{
  /* Font */
  font-family: Arial, Verdana, sans-serif;
  font-size: 12px;

  /* Text color */
  color: #f0f0f0;

  /* Remove the background color to make it transparent */
  background-color: #353c42;
}

html
{
  /* #3658: [IE6] Editor document has horizontal scrollbar on long lines
  To prevent this misbehavior, we show the scrollbar always */
  _overflow-y: scroll
}

img:-moz-broken
{
  -moz-force-broken-image-icon : 1;
  width : 24px;
  height : 24px;
}
img, input, textarea
{
  cursor: default;
}</pre> 2. 設定 config.js 檔案(Ckeditor 目錄裡面) 

<pre class="brush: jscript; title: ; notranslate" title="">CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	config.uiColor = '#AADC6E';
	config.contentsCss = '/path/ckeditor/mysitestyles.css';
};</pre> 重點在於 

<span style="color:green">config.contentsCss = '/path/ckeditor/mysitestyles.css';</span> 這行，在 Path 部份，請注意由根目錄開始寫起喔。 另外解法，就是用 [jQuery Adapter][11]，header 加入： 

<pre class="brush: xml; title: ; notranslate" title=""></pre> 使用 Ckeditor 方式如下： html: 

<pre class="brush: xml; title: ; notranslate" title=""><textarea id="test" name="test" style="width: 400px; height: 200px" />&lt;/textarea></pre> javascript 

<pre class="brush: jscript; title: ; notranslate" title="">$('#test').ckeditor({ contentCss: '/path/ckeditor/mysitestyles.css' });</pre> 就提供這兩種解法給大家參考。

 [1]: https://www.flickr.com/photos/appleboy/4476260884/ "Flickr 上 appleboy46 的 logo"
 [2]: http://ckeditor.com/
 [3]: http://zh.wikipedia.org/zh-tw/FCKeditor
 [4]: http://ckeditor.com/blog/CKEditor_3.2_released
 [5]: http://docs.cksource.com/CKEditor_3.x/Developers_Guide
 [6]: http://jquery.com/
 [7]: http://plurk.com
 [8]: http://goo.gl/3iyL
 [9]: http://docs.cksource.com/ckeditor_api/
 [10]: http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html#.contentsCss
 [11]: http://docs.cksource.com/CKEditor_3.x/Developers_Guide/jQuery_Adapter