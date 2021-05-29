---
title: HTML5 Boilerplate 不再支援 legacy browser
author: appleboy
type: post
date: 2013-02-13T12:22:35+00:00
url: /2013/02/html5-boilerplate-drop-legacy-browser/
dsq_thread_id:
  - 1080997665
categories:
  - www
tags:
  - Boilerplate
  - html5

---
<a href="http://html5boilerplate.com/" target="_blank">HTML5 Boilerplate</a> 在 V5.0 版本將不支援舊有瀏覽器，包含 <a href="http://windows.microsoft.com/zh-TW/internet-explorer/download-ie" target="_blank">IE</a>6/7. <a href="http://www.mozilla.org/en-US/firefox/fx/" target="_blank">Firefox</a> 3.6 (Mozilla 已經不再維護) 及 <a href="https://www.apple.com/tw/safari/" target="_blank">Safari</a> 4，詳細資料可以參考 V5.0 的 Milestone (<a href="https://github.com/h5bp/html5-boilerplate/issues/1050" target="_blank">Drop legacy browser support</a>) 下一版本會有哪些改變呢？ 

  * html tag 將不會出現 conditional comments
  * <a href="http://necolas.github.com/normalize.css/" target="_blank">normalize.css</a> 升級到 2.1.x
  * main.css 移除 IE6/7 Hacks 部份 此次重大改變包含移除 IE conditional classes，因為 

<a href="http://msdn.microsoft.com/en-us/library/ms537512%28v=VS.85%29.aspx" target="_blank">IE 10+ 將不再支援 conditional comments</a>，至於 normalize.css 轉換到 2.1.x 版本，如果有用 <a href="http://sass-lang.com/" target="_blank">Sass</a> 的朋友們，可以參考我改的 <a href="https://github.com/appleboy/normalize.scss" target="_blank">normalize.scss</a>，非常期待 Version 5 出來，會拿掉很多 legacy code。