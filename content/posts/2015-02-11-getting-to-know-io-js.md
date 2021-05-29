---
title: 您不可不知的 io.js
author: appleboy
type: post
date: 2015-02-11T06:05:43+00:00
url: /2015/02/getting-to-know-io-js/
dsq_thread_id:
  - 3505226280
categories:
  - io.js
  - javascript
tags:
  - iojs
  - javascript
  - Node.js

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/15859123853" title="9950313 by Bo-Yi Wu, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7401/15859123853_d945160802_o.png?resize=200%2C200&#038;ssl=1" alt="9950313" data-recalc-dims="1" /></a>
</div>

[io.js][1] 至今已經成立了快三個月，目前也快速推出到 1.2.0 版本了，相信很多人都不太知道為什麼會多一個 io.js 組織，這組織是 fork 自 [Joyent's Node.js][2] 相容於 [npm][3] 原始平台。

<!--more-->

# 為什麼 fork Node.js

這就是大家所好奇的地方，iojs 團員皆來自於 Node.js 核心開發團隊，在去年八月，內部成立了 Node Forward 社群組織來試圖改善 Node.js。

> A broad community effort to improve Node, JavaScript, and their ecosystem through open collaboration.
然而總是事與願違，底下就是為什麼要 fork Node.js 主因

> Some problems require broader ownership and contributorship than have traditionally been applied, while others are so dispersed between tiny projects that they require new collaborative space to grow. Node Forward is a place where the collaboration necessary to solve these issues can take place. 
最終因為商標版權的限制下，核心團員才決定直接 fork Node.js，這就是 io.js 的誕生。Isaac Schlueter (核心開發團員之一) 在部落格發表了[一篇心得提到為什麼要這麼做][4]，一個關鍵點，就是未來 io.js 還是希望能夠跟 Node.js 專案合併，而不是現在這樣分成兩個專案。

# io.js 新變化

io.js 使用 [semantic versioning (semver)][5] 釋出 1.0.0 版本，用此版本來區分 Node.js。jQuery 官方部落格也[指出使用 semver 的重要性][6]

> One of those best practices is semantic versioning, or semver for short. In a practical sense, semver gives developers (and build tools) an idea of the risk involved in moving to a new version of software. Version numbers are in the form of MAJOR.MINOR.PATCH with each of the three components being an integer. In semver, if the MAJOR number changes it indicates there are breaking changes in the API and thus developers need to beware.
## 最新 V8 Engine

io.js 更新內部 V8 Engine 到 `3.31.74.1` 版本，讓開發者可以直接使用 JavaScript ES6 新功能，而不需要加上 `--harmony` 參數

## ES6 新功能

底下的新功能都不用加上任何 Flag 就可以正常使用

  * Block scoping ([let][7], [const][8])
  * Collections ([Map][9], [WeakMap][10], Set, [WeakSet][11])
  * [Generators][12]
  * Binary and Octal literals
  * [Promises][13]
  * [New String methods][14]
  * [Symbols][15]
  * [Template strings][16]

## 新模組

io.js 內建了兩個實驗性新模組

  * smalloc: 讓您透過 allocation/deallocation/copying 存取外部記憶體。
  * v8: 暴露 iojs 中 v8 的 events and interfaces。

更多資料可以直接參考 [io.js 版本紀錄][17].

## 執行 io.js

執行 io.js 就如同執行 node.js 一樣，只是名稱變了而已

Node.js

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ node app.js</pre>
</div>

io.js

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ iojs app.js</pre>
</div>

## Node 版本管理

相信大家都是使用 Node version manager (nvm) 工具來管理多個 node 版本，您可以透過底下指令來找到 io.js 版本列表

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ nvm ls-remote v1
    iojs-v1.0.0
    iojs-v1.0.1
    iojs-v1.0.2
    iojs-v1.0.3
    iojs-v1.0.4
    iojs-v1.1.0
    iojs-v1.2.0</pre>
</div>

個人建議一定要裝上 nvm 工具，此工具可以讓您隨時切換 node 版本，包含 iojs 各版本，確保測試無誤

# 開始使用 io.js？

這問題很多人一定會問自己，現在要把專案換到 io.js 上了嗎？我個人覺得，舊有專案如果在 Node.js 跑的很順，就不建議切換，如果是新專案，又想跑 JavaScript ES6 Feature，就可以直接嘗試看看跑 io.js 1.2.0 版本。本文翻譯自 [Getting to know io.js][18]。如內容有誤，請儘速告知。

 [1]: http://iojs.org/
 [2]: https://github.com/joyent/node
 [3]: https://www.npmjs.com/
 [4]: http://blog.izs.me/post/104685388058/io-js
 [5]: http://semver.org/lang/zh-TW/
 [6]: http://blog.jquery.com/2014/10/29/jquery-3-0-the-next-generations/
 [7]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let
 [8]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const
 [9]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map
 [10]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap
 [11]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakSet
 [12]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Generator
 [13]: https://developer.mozilla.org/en-US/docs/Mozilla/JavaScript_code_modules/Promise.jsm/Promise
 [14]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String
 [15]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
 [16]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/template_strings
 [17]: https://github.com/iojs/io.js/blob/v1.x/CHANGELOG.md
 [18]: https://developer.atlassian.com/blog/2015/01/getting-to-know-iojs/