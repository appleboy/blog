---
title: '提升  npm install 安裝速度'
author: appleboy
type: post
date: 2016-01-31T03:36:24+00:00
url: /2016/01/speed-up-npm-install/
dsq_thread_id:
  - 4538034721
categories:
  - javascript
  - NodeJS
tags:
  - ied
  - Node.js
  - npm
  - pnpm

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24588632402/in/dateposted-public/" title="Npm-logo.svg"><img src="https://i2.wp.com/farm2.staticflickr.com/1564/24588632402_35c2cab0b6_z.jpg?resize=640%2C249&#038;ssl=1" alt="Npm-logo.svg" data-recalc-dims="1" /></a>

[npm][1] 是 [Node.js][2] 套件管理模組，相信大家對 npm 不會很陌生，如果對於 npm 不了解的，可以參考[阮一峰][3]寫的[這篇文章][4]，今天要來探討的是如何提升 `npm install` 的安裝速度，如果你正在嘗試 npm@3 版本，我建議可以先換到 npm@2 的版本會比較快（為什麼呢？底下有數據會說話）。[Github issue][5] 上也蠻多速度上的討論，然而前幾天有網友[發表一篇][6]關掉 `progress` 提升不少速度，實際上我們可以拿專案來測試 npm@2 及 npm@3 的速度看看。

<!--more-->

npm@2 測試如下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ rm -rf ~/.npm && rm -rf node_modules && time npm install

real    0m50.443s
user    0m43.468s
sys     0m17.817s</pre>
</div>

npm@3 測試如下 (關閉 progress)

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm set progress=false && rm -rf ~/.npm && rm -rf node_modules && time npm install

real    1m1.417s
user    0m10.825s
sys     0m2.880s
</pre>
</div>

npm@3 測試如下 (啟動 progress)

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm set progress=true && rm -rf ~/.npm && rm -rf node_modules && time npm install

real    1m37.965s
user    0m14.065s
sys     0m3.350s</pre>
</div>

看了上面數據，你還會想用 npm@3 版本嗎？如果 npm 無法滿足您要的速度，沒關係，可以參考另外一套 node 套件管理模組 [ied][7]。

### ied

為什麼會出現這專案呢？那就是因為 npm@3 performance 沒有變得更好，反而更差了，這時候就會有強者跳出來寫一套 [ied][7] 跟 npm 相容的套件管理模組，不過這套件目前[尚未支援完整的 npm 指令][8] (像是無法安裝 private 模組)，用起來問題也蠻多的，但是速度提升了非常多，底下來看看數據：

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ rm -rf ~/.ied_cache && rm -rf node_modules && time ied install

real    0m16.260s
user    0m5.739s
sys     0m2.264s</pre>
</div>

速度從原本的 1 分鐘，變成 16 秒，但是我對於 ied 產生的目錄結構不是很喜歡，ied 會將 cache 資料放到 `~/.ied_cache` 內，並且在 node_modules 內是透過 symbolic links 方式來串接（參考底下附圖），這樣看起來跟 npm@3 的結構上沒啥區別，還是把每個相依套件都放到第一層目錄了。

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24078151444/in/dateposted-public/" title="Screen Shot 2016-01-30 at 8.15.11 PM"><img src="https://i2.wp.com/farm2.staticflickr.com/1640/24078151444_dd9445cdba_o.png?resize=530%2C805&#038;ssl=1" alt="Screen Shot 2016-01-30 at 8.15.11 PM" data-recalc-dims="1" /></a>

### pnpm

最後來介紹本週 [@rstacruz][9] 寫另外一套高效能的 node 管理模組，作者有說到 [pnpm][10] (Performant npm) 的靈感來自於 ied，我個人推薦這套的原因是，pnpm 會將 cache 存在 `.store` 底下，外面才用 symbolic links 連接，可以參考底下圖示

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24338651099/in/dateposted-public/" title="Screen Shot 2016-01-30 at 8.15.29 PM"><img src="https://i2.wp.com/farm2.staticflickr.com/1623/24338651099_bc4e3bb77a_o.png?resize=566%2C193&#038;ssl=1" alt="Screen Shot 2016-01-30 at 8.15.29 PM" data-recalc-dims="1" /></a>

另外此作者開發速度蠻快的，這也是我選這套的原因之一，底下附上數據

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ rm -rf node_modules && time pnpm install

real    0m9.132s
user    0m5.411s
sys     0m2.253s
</pre>
</div>

最後如果不想用 `pnpm` 或 `ied` 而想用原生 npm 指令，可以直接透過 `--cache-min` 參數來完成。原本 npm 安裝套件後都會存放一份到 `~/.npm` 目錄內，假設目前的 node_modules 內沒有該套件，就會先從網路上下載，而並非從 `~/.npm` 內直接拉過來。如果要先從 `~/.npm` 目錄內找安裝包，必須要加上 `--cache-min` 參數，參考如下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm install --cache-min 9999999 &lt;package-name&gt;</pre>
</div>

### 總結

把上面數據整理起來

<div>
  <pre class="brush: bash; title: ; notranslate" title="">npm@2                   0m50.443s
npm@3 disable progress  1m1.417s
npm@3 enable progress   1m37.965s
ied                     0m16.260s
pnpm                    0m9.132s</pre>
</div>

packages 內容為：

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">"dependencies": {
  "babel-preset-es2015": "^6.3.13",
  "browserify": "^13.0.0",
  "chalk": "^1.1.1",
  "debug": "^2.2.0",
  "minimist": "^1.2.0",
  "mkdirp": "^0.5.1"
}
</pre>
</div>

不管你是用 ied 或 pnpm 時間都比用 npm 版本來得快，但是目前支援度會是比較低，可以拿目前專案測試看看，最保險的就是拿 npm@2 來安裝管理套件。

 [1]: https://www.npmjs.com/
 [2]: https://nodejs.org/en/
 [3]: http://www.ruanyifeng.com/
 [4]: http://www.ruanyifeng.com/blog/2016/01/npm-install.html
 [5]: https://github.com/npm/npm/issues/9632
 [6]: https://github.com/npm/npm/issues/11283
 [7]: https://github.com/alexanderGugel/ied
 [8]: https://github.com/alexanderGugel/ied/issues/7
 [9]: https://github.com/rstacruz
 [10]: https://github.com/rstacruz/pnpm