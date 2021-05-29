---
title: '[WWW] firefox and IE 的 greasemonkey'
author: appleboy
type: post
date: 2008-02-23T08:30:43+00:00
url: /2008/02/www-firefox-and-ie-的-greasemonkey/
views:
  - 6127
bot_views:
  - 767
dsq_thread_id:
  - 246757808
categories:
  - blog
  - www
tags:
  - Firefox
  - Greasemonkey
  - javascript
  - windows

---
最近發現這種新玩意，那就是猴子外掛 [Greasemonkey][1]，這一套我在 FireFox 有找到，用起來還不錯，可是一些 for ie 的網站，就使用不到了，所以我又另外去找了 [Greasemonkey][1] for ie 的版本，不過 for ie 的版本有兩套，一套是我想要，另一套我測試起來不是我想要的。 先介紹 for ie 的 [Greasemonkey][1]，總共有兩套 1.[gm4ie][2] 這一套了，其實相當不錯，不過有一個缺點，就是如果你的網站是用 iframe 做的化，他必需要重新 reload 整個網站，才會有作用，所以我並不打算用這套，不然他還是蠻方便的 2.[Trixie][3] 這個，就有符合到我的要求了，不過他在設定上面格式都要先寫好 

<pre class="brush: jscript; title: ; notranslate" title="">// ==UserScript==
// @name          Server2
// @description	  .
// @namespace     http://musicplayer.sourceforge.net/greasemonkey
// @include       http://xxxxxxxxx/index2/main_down.php*
// @include       http://xxxxxxxxx/index2/main_down.php*
</pre> 所有套用的網站，都要寫在 // @include 這個裡面才會有作用，然後在用 ie alt+t +x 就可以更改 reload 設定了 3. 

[Greasemonkey :: Firefox Add-ons][4] FireFox 的部份，這個外掛裝好，你在啟動他的時候，會要求你選擇編輯 js 的軟體，請務必選 notepad.exe ，不然你選擇其他程式，你就會編輯不到檔案，那他檔案的放置位置如下 C:\Documents and Settings\你的帳號\Application Data\Mozilla\Firefox\Profiles\qvq3wzwh.default\gm_scripts

 [1]: http://zh.wikipedia.org/wiki/Greasemonkey
 [2]: http://www.gm4ie.com/
 [3]: http://www.bhelpuri.net/Trixie/
 [4]: https://addons.mozilla.org/en-US/firefox/addon/748