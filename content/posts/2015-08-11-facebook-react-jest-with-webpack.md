---
title: Facebook React Jest 搭配 Webpack 測試
author: appleboy
type: post
date: 2015-08-11T03:31:58+00:00
url: /2015/08/facebook-react-jest-with-webpack/
dsq_thread_id:
  - 4021576116
categories:
  - javascript
  - NodeJS
  - React
tags:
  - Facebook
  - Facebook React
  - Jest
  - Less
  - React
  - Webpack

---
<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/19850322514/in/dateposted-public/" title="logo_og"><img src="https://i2.wp.com/farm1.staticflickr.com/462/19850322514_1f88fd5d6c_n.jpg?resize=320%2C320&#038;ssl=1" alt="logo_og" data-recalc-dims="1" /></a>
</div>

寫 [Facebook React][1] 就是要搭配 [Webpack][2]，Webpack 已經是前端開發的必備工具，要測試 React Component 就是要用 Facebook 開發的 [Jest 框架][3]，使用 Webpack 也許會搭配 [Less][4] or [Sass][5] Loader 讓每個 component 都可以獨立有 CSS 檔案。要在 JS 內直接引入 CSS 檔案寫法如下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">import '!style!css!less!./Schedule.less';
import React, { Component } from 'react';</pre>
</div>

<!--more-->

透過 webpack 就可以把這些 header 檔案 build 成單一檔案，但是遇到的問題是，如果搭配 Jest 測試，我們使用了 [babel-jest][6] 來做 script preprocessor 如下

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">{
  "devDependencies": {
    "babel-jest": "*",
    "jest-cli": "*"
  },
  "scripts": {
    "test": "jest"
  },
  "jest": {
    "scriptPreprocessor": "&lt;rootDir&gt;/node_modules/babel-jest",
    "testFileExtensions": ["es6", "js"],
    "moduleFileExtensions": ["js", "json", "es6"]
  }
}</pre>
</div>

接著執行 `npm test`，可以看到會噴出 !style!css!less!./Schedule.less not found，原因就是 babel 看不懂 `!style!css!less!`，這是 webpack loader 特有的寫法，要解決這問題有兩種方式

  * 所有 Less 檔案全部寫在 Top 目錄內的 app.js
  * 改寫 script preprocessor

第一種方法就是把 less 檔案都獨立寫到最外層的 app.js 檔案，因為通常 app.js 幾乎不用寫測試，裡面只是單純的 initial component 而已，這是一種方法，但是我覺得不是很好，第二種做法是直接將 babel-jest 轉出來的程式碼將 less 部分抽掉，再跑測試。首先在主目錄建立 `jest-script-preprocessor.js` 內容如下，透過 [Regular expression][7] 將 .less 模組去掉。

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">var babelJest = require('babel-jest');

module.exports = {
  process: function(src, filename) {
    return babelJest.process(src, filename)
      .replace(/require\(\'[^\']+\.less\'\);/gm, '');
  }
};</pre>
</div>

然後修改 `scriptPreprocessor` 為

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">"jest": {
  "scriptPreprocessor": "&lt;rootDir&gt;/jest-script-preprocessor",
  "unmockedModulePathPatterns": [
    "&lt;rootDir&gt;/node_modules/react",
    "&lt;rootDir&gt;/node_modules/react-tools"
  ],
  "testFileExtensions": [
    "js",
    "jsx"
  ],
  "moduleFileExtensions": [
    "js",
    "json",
    "jsx"
  ]
}</pre>
</div>

最後建立 `__tests__` 目錄，寫下第一個測試檔案

<div>
  <pre class="brush: jscript; title: ; notranslate" title="">jest.dontMock('../index');

import React from 'react/addons';
let TestUtils = React.addons.TestUtils;
let About;

describe('About Test', () =&gt; {

  beforeEach(function() {
    About = require('../index');
  });

  it('should exists', function() {
    // Render into document
    let about = TestUtils.renderIntoDocument(&lt;About /&gt;);
    expect(TestUtils.isCompositeComponent(about)).toBeTruthy();
  });
});
</pre>
</div>

現在 Jest 也內建產生 coverage report 只要加上 `--coverage` 參數即可

<div>
  <pre class="brush: bash; title: ; notranslate" title="">Using Jest CLI v0.4.18
 PASS  src/components/About/__tests__/About.js (2.109s)
1 test passed (1 total)
Run time: 2.381s
------------|----------|----------|----------|----------|----------------|
File        |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
------------|----------|----------|----------|----------|----------------|
 About/     |      100 |      100 |      100 |      100 |                |
  index.jsx |      100 |      100 |      100 |      100 |                |
------------|----------|----------|----------|----------|----------------|
All files   |      100 |      100 |      100 |      100 |                |
------------|----------|----------|----------|----------|----------------|

All reports generated</pre>
</div>

詳細資訊可以參考 Jest Issue 有網友發了 [How to test with Jest when I'm using webpack][8] 問題，有興趣的朋友們可以參考看看。

 [1]: http://facebook.github.io/react/
 [2]: https://webpack.github.io/
 [3]: http://facebook.github.io/jest/
 [4]: http://lesscss.org/
 [5]: http://sass-lang.com/
 [6]: https://github.com/babel/babel-jest
 [7]: https://en.wikipedia.org/wiki/Regular_expression
 [8]: https://github.com/facebook/jest/issues/334