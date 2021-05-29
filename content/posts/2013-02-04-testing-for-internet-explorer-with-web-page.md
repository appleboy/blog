---
title: 使用不同 IE 版本測試網站
author: appleboy
type: post
date: 2013-02-04T03:15:19+00:00
url: /2013/02/testing-for-internet-explorer-with-web-page/
dsq_thread_id:
  - 1063759059
categories:
  - Browser
  - Chrome
  - Firefox
  - IE
tags:
  - Chrome
  - Firefox
  - IE
  - modern.IE

---
<div style="margin: 0 auto; text-align: center;">
  <a title="ie-logo-small by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/8443574444/"><img alt="ie-logo-small" src="https://i2.wp.com/farm9.staticflickr.com/8216/8443574444_c01f821c31_m.jpg?resize=240%2C240&#038;ssl=1" data-recalc-dims="1" /></a>
</div> 大家還在為了測試不同 IE 版本而安裝虛擬機器 

<a href="https://www.virtualbox.org/" target="_blank">VirtulBox</a> 或 <a href="http://www.vmware.com/" target="_blank">VMware</a> 嗎？現在不必這麼麻煩了，可以到 <a href="http://www.modern.ie/" target="_blank">modern.IE</a> 直接測試 IE6/7/8/9/10 任何版本，或者是檢查網頁相容性以及 coding practices。 <!--more-->

### Scan your page

<a href="http://www.modern.ie/report" target="_blank">輸入網站 URL</a> 直接開始測試，測試項目其實蠻多的，包含偵測網站使用的 Framework，像是 <a href="http://jquery.com" target="_blank">jQuery</a>、<a href="http://modernizr.com/" target="_blank">Modernizr</a> 版本，如果太舊，會跟您回報提示目前最新版本號碼，另外為了相容各 IE 版本，請使用 <a href="http://msdn.microsoft.com/en-us/library/gg699338%28VS.85%29.aspx" target="_blank">Standards Mode</a>，也就是在 html 頁面使用 ****<span style="color: green;"><strong><!DOCTYPE html></strong></span>，還有檢查是否使用 <a href="http://www.alistapart.com/articles/responsive-web-design/" target="_blank">Responsive web design</a>，就是偵測 <a href="http://msdn.microsoft.com/en-us/library/ie/hh772370%28v=vs.85%29.aspx" target="_blank">media queries</a>。其實測試結果裡面有很多相關連結，有空都可以看看，都蠻不錯的。 

### Virtual tool 為了測試不同 IE 版本，大家安裝了許多機器，就是要偵測相容性，現在不必這麼麻煩了，請到 

<a href="http://www.browserstack.com/" target="_blank">BrowserStack.com</a> 註冊新帳號，並且安裝 <a href="https://addons.mozilla.org/en-US/firefox/addon/test-ie/" target="_blank">Firefox Addon</a> 或 <a href="https://chrome.google.com/webstore/detail/test-ie/eldlkpeoddgbmpjlnpfblfpgodnojfjl" target="_blank">Chrome Plugin</a>，安裝完成就可以直接選擇您要測試的 IE 版本，瀏覽器就會連上 Cloud based services 顯示各 IE 版本的結果，並且還有模擬滑鼠喔。 最後為了解決這些相容性問題，請務必調整專案的 Coding Standard，先閱讀 <a href="http://www.modern.ie/cross-browser-best-practices" target="_blank">20 tips for building modern sites while supporting old versions of IE</a>，按照此篇文章來開發新專案，像是使用 <a href="https://github.com/h5bp/html5-boilerplate" target="_blank">HTML5 Boilerplate</a>，用 <a href="http://blogs.msdn.com/b/ie/archive/2012/01/20/ie10-compat-inspector.aspx" target="_blank">IE Compat Inspector</a>，在 IE 瀏覽器上<a href="http://msdn.microsoft.com/en-US/library/ie/gg589507.aspx" target="_blank">按 F12 debug</a>，或使用 <a href="https://getfirebug.com/firebuglite" target="_blank">Firebug Lite</a>，另外可以使用線上工具來幫助偵測網站相容性，像是 <a href="http://validator.w3.org/" target="_blank">HTML validator</a>s, <a href="http://jigsaw.w3.org/css-validator/" target="_blank">CSS validators</a>, <a href="https://github.com/mishoo/UglifyJS" target="_blank">Uglify</a>, and <a href="https://github.com/jshint/jshint/" target="_blank">JSHint</a>, or <a href="http://gruntjs.com/" target="_blank">GruntJS</a> 等。更多詳細資訊可以參考上述連結。