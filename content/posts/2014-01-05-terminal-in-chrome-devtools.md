---
title: 在 Chrome 瀏覽器使用 Terminal 終端機
author: appleboy
type: post
date: 2014-01-05T13:43:46+00:00
url: /2014/01/terminal-in-chrome-devtools/
dsq_thread_id:
  - 2093400920
categories:
  - Browser
  - Chrome
  - javascript
  - NodeJS
tags:
  - Chrome
  - Chrome Developer Tool
  - Node.js

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i2.wp.com/farm8.staticflickr.com/7350/9333443162_20e7e5d5f2_m.jpg?w=840&#038;ssl=1" alt="Google Chrome" data-recalc-dims="1" />
</div>

## 簡介

不知道大家有無在瀏覽器內直接連上 Terminal 終端機，今天來介紹 [DevTools Terminal][1]，這是一套 [Chrome extension][2]，它可以讓您在 [Chrome 瀏覽器][3]直接使用 Terminal，平常開發程式，一定會常常切換瀏覽器及 Terminal 軟體，現在開發者可以直接在瀏覽器連上 Terminal，並且開始使用 [Git][4], [Grunt][5], wget 甚至 [Vim][6] 等指令。

[<img src="https://i2.wp.com/farm3.staticflickr.com/2837/11773943433_e0f20349fb.jpg?resize=500%2C282&#038;ssl=1" alt="Screenshot from 2014-01-05 20:36:26" data-recalc-dims="1" />][7]

<!--more-->

## 為什麼要在瀏覽器內使用 Terminal

在開發網站過程，你一定會用到底下工具:

  * 編輯器 [Sublime][8], Vim 用來撰寫程式
  * 瀏覽器 Chrome 用來 debug 看結果
  * Terminal 終端機用來 update package 等

現在 Terminal 甚至用到 [Grunt][5] 等開發工具，每天都在這三種介面切換，是不是很浪費時間，雖然 [Chrome 推出了 Workspace][9] 讓開發者可以直接在瀏覽器內寫程式，但是這還不夠阿。所以 DevTools Terminal 幫你完成了這個故事，開發者可以直接用 Chrome 瀏覽器完成上述三件事情。

## 安裝方式

底下測試環境為 [Ubuntu 系統][10]，首先安裝 [Chrome extension][11]，完成後，請按下 `Ctrl` + `Shift` + `I`，會開啟 DevTools，會看到多一個 `Terminal tab`。如果系統並非為 Mac OS，那就必須透過 Node.js Proxy 才可以連上 Terminal。

<div>
  <pre class="brush: bash; title: Install command; notranslate" title="Install command">
$ npm install -g devtools-terminal
</pre>
</div>

安裝完成後，開啟新的 Terminal console 並執行底下指令:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ devtools-terminal</pre>
</div>

預設會開啟 `8080` port，帳號為 `admin`，如果要改變預設值，請建立新檔案 `terminal.js` (檔案名稱可以自行更換)，內容寫入

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">exports.config = {
    users: {
        admin: {
            password: "",
            cwd: process.cwd() //working directory
        }
    },
    port: 8080
};</pre>
</div>

透過指令:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ devtools-terminal --config terminal.js</pre>
</div>

可以在 Terminal 介面執行 Grunt，畫面如下

[<img src="https://i2.wp.com/farm3.staticflickr.com/2891/11774682713_66f180ea30.jpg?resize=500%2C441&#038;ssl=1" alt="Screenshot from 2014-01-05 21:22:15" data-recalc-dims="1" />][12]

## 總結

[Chrome Developer Tools][13] 實在是太強大了，我個人比較期待是否有整合 [Compass][14]，現在只有支援 Sass 3.0 版本以上，當然如果能在瀏覽寫程式是很方便，但是有時候開啟 DevTools 時候，記憶體都會被吃的很高，導致 Chrome 當機，所以其實還是要看狀況使用，但是能透過 chrome 來連接其他伺服器 Terminal，此功能對於常使用 console 的開發者是一大福音。

 [1]: https://github.com/petethepig/devtools-terminal
 [2]: https://chrome.google.com/webstore/category/extensions
 [3]: http://www.google.com/intl/zh-TW/chrome/
 [4]: http://git-scm.com/
 [5]: http://gruntjs.com/
 [6]: http://www.vim.org/
 [7]: https://www.flickr.com/photos/appleboy/11773943433/ "Screenshot from 2014-01-05 20:36:26 by appleboy46, on Flickr"
 [8]: http://www.sublimetext.com/
 [9]: http://blog.wu-boy.com/2013/07/coding-on-workspace-of-chrome-developer-tools/
 [10]: http://www.ubuntu.com/
 [11]: https://chrome.google.com/webstore/detail/devtools-terminal/leakmhneaibbdapdoienlkifomjceknl?hl=en
 [12]: https://www.flickr.com/photos/appleboy/11774682713/ "Screenshot from 2014-01-05 21:22:15 by appleboy46, on Flickr"
 [13]: https://developers.google.com/chrome-developer-tools/
 [14]: http://compass-style.org/