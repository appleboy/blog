---
title: CSS layout 好幫手 Compass scss version of normalize.css
author: appleboy
type: post
date: 2012-09-13T01:53:03+00:00
url: /2012/09/compass-scss-version-of-normalize-css/
dsq_thread_id:
  - 841888037
categories:
  - Compass CSS Framework
  - CSS
tags:
  - Compass
  - Normalize.css

---
我相信網頁程式設計師都知道，網站一開始必須先使用 <a href="http://html5doctor.com/html-5-reset-stylesheet/" target="_blank">CSS Rest</a> 將所有的 browser layout 初始化，這樣可以讓以後 CSS debug 速度增加，也解決了很多跨瀏覽器的問題，昨天使用 <a href="https://github.com/sporkd/compass-h5bp" target="_blank">Compass-h5bp</a> 來自動產生 html5 template，但是發現版本並非是 <a href="http://html5boilerplate.com/" target="_blank">html5 boilerplate</a> 所提供的 V4.0.0 版本，專案裡面的 <a href="http://necolas.github.com/normalize.css/" target="_blank">Normalize.css</a> 也是舊版的，雖然有其他開發者提交 <a href="https://github.com/sporkd/compass-h5bp/pull/8" target="_blank">pull request</a>，但是作者似乎還沒 merge 到主分支，只是我好奇這個 tool 除了幫忙產生 html5 boilerplate，另外多了 <a href="http://compass-style.org/" target="_blank">Compass</a> 檔案，讓寫 Compass 前端工程師更加方便，由於 Normalize.css 還沒更新，所以我 fork 了 <a href="https://github.com/necolas/normalize.css" target="_blank">normalize.css 專案</a>，並且將 v2.0.1(IE 8+, Firefox 4+, Safari 5+, Opera, Chrome) 跟 v1.0.1 (Includes legacy browser support) 整合在同一支 scss 檔案，歡迎大家取用。 如果要支援 IE6/7 的話，請將 **<span style="color:green">$legacy_browser_support</span>** 設定為 true 即可。檔案可以由底下專案取得 [SCSS version of normalize.css][1]

 [1]: https://github.com/appleboy/normalize.scss/blob/master/normalize.scss