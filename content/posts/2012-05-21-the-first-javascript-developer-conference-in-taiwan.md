---
title: 台灣第一屆 JavaScript Conference Developer 會議
author: appleboy
type: post
date: 2012-05-21T06:39:43+00:00
url: /2012/05/the-first-javascript-developer-conference-in-taiwan/
dsq_thread_id:
  - 698159518
categories:
  - javascript
tags:
  - AngularJS
  - Backbone.js
  - Gaia
  - JavaScrpt
  - JSDC
  - Spinejs

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm6.staticflickr.com/5454/7238452668_82262e37dc_o.png?w=840&#038;ssl=1" alt="JSDC 2012" data-recalc-dims="1" />
</div>

自從去年辦了台灣第一屆 [2011 PHP Conference][1]，2012年開始又來新的第一屆 [Javascript Conference][2]，在去年的 PHP 會議由於第一次開始舉辦 PHP Conference，所以比較少人投稿，導致議程裡面出現<del>很多</del> Javascript 議題，這也是很多朋友的疑問 XD。底下來回顧 JSDC 5/19 (六) 個人參加的議程。由於早上差不多10點半才到，所以前兩場議程(Key Note - Ericsk, [Node.JS on Windows Azure][3])就沒有聽到了，比較可惜。如果沒去聽現場的，可以到[官方網站下載投影片][4]參考。 <!--more-->

### Key Note - Andreas Gal

這場最主要是介紹 [Mozilla B2G Project][5]，這是去年 Mozilla 的計畫，也在今年二月發表一些 demo 範例，以前程式設計師開發 Mobile device 需要用到大量的 Native API，現在可以利用 HTML5 + Javascript 開發任何驚人的 Application，大家可以在 Github 找到此專案 [Gaia][6]，另外可以參考 [Boot to Gecko Wiki][7]，現場有 Demo 手機可以玩看看。

### JavaScript在Big Data方面的應用

這場其實就是推廣 Windows Azure 一些功能還有用 Javascript 處理大量資料，Map Reduce 的 work flow，投影片可以參考[這裡][8]，個人對於 Windows 系列的產品沒有很大的興趣，結論就是只有網站夠大才需要考慮到這些應用，不然一般的架構就可以做完了。

### JavaScript MVC compare

這場是由 [TonyQ][9] 主講，相信大家對於他已經很熟悉，在台北每個禮拜都有舉辦 Javascript 小聚會，可以參考 [Facebook javascript.tw Group][10]，這場介紹如何選擇一套 Javascript Framework，現場也提到如果想玩新的 Framework，請由全新專案開始，不要拿舊有的網站來開刀，那會是拿石頭丟自己的腳，以老闆角度來想，為啥要導入新的架構，除非你有很大的說服力，不然請打消這個念頭，此主題有提到 [AngularJS][11]、[Backbone.js][12]、[Spine][13]、[JavaScript MVC][14]，講者提到下面幾個重點，對於找一套好的 Framework 非常有幫助:

  * Project Dependency
  * Dependency Management
  * Model-View-Controll structure
  * Entry point
  * Testing

<span style="color:green"><strong>Project Dependency:</strong></span> 首先在用任何一套 JS Framework 之前，必需要先瞭解此套件的相依性，例如 Spine.js 需要 include [jQuery][15] 或 [zepto][16]，另外還需要 [CoffeeScript][17]。那 Backbone.js 呢？就需要 include [underscore.js][18] 跟 jQuery，所以每一套 Framework 都要瞭解相依性，以及自己撰寫開發的 script 是否可以相依並存，這點是非常重要。

<span style="color:green"><strong>Dependency Management:</strong></span> 如何解決相依性管理，這點是就是要瞭解這些 Framework 如何整合而外的 Library，像是 Backbone.js 用了 [AMD][19] (Asynchronous Module Definitions) 架構，要瞭解管理這些額外套件，以及整合各大 opensource 架構，例如 [Require.js][20]。

<span style="color:green"><strong>Entry Point:</strong></span> 各大 JS Framework 的主要特性，當您選一套喜歡的 Framework，一定會有您自己心目中想要的架構，才會繼續使用它吧，這點大家都必須要先清楚知道，而不是大家用，您就用。像 [Sencha Touch][21]，它就是 script base，你只要會寫 javascript 就可以了，不用理會 html dom 元件如何產生出來，因為在 Sencha 底層就幫忙把 Html Layout 處理完畢。Backbone.js 呢，它提供了 URL Routing 功能，這點非常方便，讓後專程式設計師可以專心寫 API，輸出 JSON 格式就可以了。AngularJS 就是以 html 當作 Base，利用 **<span style="color:green">ng-*</span>** 插入到 html tag 來產生前端效果。

<span style="color:green"><strong>Model-View-Controler:</strong></span> 我想大家一定聽過很多 MVC Framework，像是 [CodeIgniter][22], [Django][23], [Yii][24], [Zend Framework][25] …等太多了，那前端的 MVC 呢？這是大家很少注意，也很少使用的地方，個人認為要選擇一套前端 MVC Framework 必須包含 Controller，利用 URL Routing 功能來達到 JS File 的分離，Model 用來連接後端 API，View 則是 Template Engines，以及可以自訂各種不同的 Event。

<span style="color:green"><strong>Testing:</strong></span> 前端的 Testing 就看專案需求了，這部份就不多寫了，可以參考 [QUnit][26]

### Introducing Mojito

這場由 Yahoo 前端工程師 [David Shariff][27] 來介紹 [Mojito MVC application framework][28]，現在前端工程師非常辛苦，因為有太多的 Device 要支援: Android, iPhone, iPad, Windows Phone, other Device…等，每個 Application 用到不同的 Language，每出一個產品，前端做到死，所以 Yahoo 提出了解決方案: [Cocktails][29] Mojito。Mojito 實現一種 Language base，支援各式不同的 Devices，包涵各種不同的 Screen Size。Mojito 語言就是 JavaScript，Client, Server 全部都是。大家可以到 [Yahoo Github][30] 找到完整 Source Code。Mojito 整合了 [YUI3][31] 及 [Node.js][32] 當作伺服器端。個人覺得這套好用的原因在於架構清楚，並且幫忙分離檔案目錄結構，這樣對於共同開發團隊非常有幫助。

### Noder eyes for frontend guys

這場由 [Fillano][33] 主講，主要是給大家一堆寫 Node.js 之前所需要的 Javascript 知識，像是單一執行緒，或者是會碰到 async mode，以上都是寫 JS 的工程師會遇到的，投影片值得一看再看，請參考[此下載連結][34]

### Non-MVC Web Framework

[永遠的大四生 Fred][35] 所講的一套 MVC Web Framework，base on node.js，講者提到台北一堆神人都自己寫一套[][36] Framework，所以講者也自己創了一套 XD，原本是 [RedTea (淡定紅茶 Framework)][37]，後來作者把 Express Framewrok 導入，讓開發者更趨向於使用 Express Framework，並且結合 RedTea 所有功能，衍生出另外一套 [Kamalan Web Framework][38] 詳細可以參考作者 blog: [【JSDC.tw 2012 簡報檔釋出】Non-MVC Web Framework][36]

### Refactoring with Backbone.js

由 [Jace Ju][39] 主講，如何幫網站擦屁股，這是我這次去會議看到最多程式碼的一個 Section，主要是把網站本身的 jQuery 程式碼重構成 [Backbone.js][12]，對於新人來說是非常好的學習，大家可以看看[簡報檔][40]，裡面有講者一步一步詳細分析該如何重構整個 Javascript，完整的把 Backbone.js 導入到開發專案，相信看完此 Slide，會有更多人投入 Backbone.js。

### 心得

個人蠻喜歡參加這種大型會議，可以學習到不同的架構，聽到不同的心得，以及瞭解目前大家開發主流的工具及語言，希望下次能有機會可以分享自己的心得 XD。

 [1]: http://phpconf.tw/2011
 [2]: http://jsdc.tw/2012/
 [3]: http://jsdc.tw/2012/sliders/NodeJSOnWindowsAzure.pptx
 [4]: http://jsdc.tw/2012/Sessions
 [5]: http://www.mozilla.org/en-US/b2g/
 [6]: https://github.com/andreasgal/gaia
 [7]: https://developer.mozilla.org/en/Mozilla/Boot_to_Gecko
 [8]: https://skydrive.live.com/?cid=27a3bf26ba2e285e&resid=27A3BF26BA2E285E!474&id=27A3BF26BA2E285E%21474
 [9]: http://www.plurk.com/tonyq
 [10]: https://www.facebook.com/groups/javascript.tw/
 [11]: http://angularjs.org/
 [12]: http://documentcloud.github.com/backbone/
 [13]: http://spinejs.com/
 [14]: http://javascriptmvc.com/
 [15]: http://jQuery.com
 [16]: http://zeptojs.com/
 [17]: http://coffeescript.org/
 [18]: http://underscorejs.org/
 [19]: https://github.com/amdjs/amdjs-api/wiki/AMD
 [20]: http://requirejs.org/
 [21]: http://www.sencha.com/products/touch/
 [22]: http://www.codeigniter.org.tw/
 [23]: https://www.djangoproject.com/
 [24]: http://www.yiiframework.com/
 [25]: http://framework.zend.com/
 [26]: http://docs.jquery.com/QUnit
 [27]: http://www.davidshariff.com/
 [28]: http://developer.yahoo.com/cocktails/mojito/
 [29]: http://developer.yahoo.com/blogs/ydn/posts/2011/11/yahoo-announces-cocktails-%E2%80%93-shaken-not-stirred/
 [30]: https://github.com/yahoo/mojito/
 [31]: http://yuilibrary.com/projects/yui3/
 [32]: http://nodejs.org/
 [33]: http://fillano.blog.ithome.com.tw/
 [34]: https://docs.google.com/presentation/d/1C17qEZdFJTyXnl_diWjShQldb8Kx4AH4wd9TG0lyohM/edit#slide=id.p
 [35]: http://fred-zone.blogspot.com
 [36]: http://fred-zone.blogspot.com/2012/05/jsdctw-2012-non-mvc-web-framework.html
 [37]: https://github.com/cfsghost/redtea
 [38]: https://github.com/cfsghost/Kamalan
 [39]: http://www.jaceju.net/
 [40]: https://speakerdeck.com/u/jaceju/p/refactoring-with-backbonejs