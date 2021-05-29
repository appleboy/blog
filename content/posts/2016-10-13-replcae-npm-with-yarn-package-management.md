---
title: 用 Yarn 取代 Npm 管理 JavaScript 套件版本
author: appleboy
type: post
date: 2016-10-13T07:19:44+00:00
url: /2016/10/replcae-npm-with-yarn-package-management/
dsq_thread_id:
  - 5219300526
categories:
  - DevOps
  - javascript
  - NodeJS
tags:
  - devops
  - javascript
  - node
  - npm
  - yarn

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29998255630/in/dateposted-public/" title="yarn-kitten-full"><img src="https://i1.wp.com/c7.staticflickr.com/6/5712/29998255630_b40ff9df74_z.jpg?resize=640%2C287&#038;ssl=1" alt="yarn-kitten-full" data-recalc-dims="1" /></a>

新一代戰神 [Yarn][1] 終於在昨天出爐了，Yarn 跟 [Npm][2] 一樣都是 JavaScript 套件版本管理工具，但是 Npm 令人詬病的是安裝都是非常的慢，快取機制用起來效果也不是很好，所以 Yarn 的出現解決了這些問題，透過 Yarn 安裝過的套件都會在家目錄產生 Cache (目錄在 `~/.yarn-cache/`)，也就是只要安裝過一次，下次砍掉 `node_modules` 目錄重新安裝都會從 Cache 讀取。Yarn 詳細的功能架構可以參考 Facebook 發表的 [Yarn: A new package manager for JavaScript][3]，本篇不會教大家怎麼使用 Yarn，因為指令實在是太容易了，可以參考官方提供的[如何從 npm 轉換到 yarn][4]，底下則是來測試比較兩者安裝套件的速度。

<!--more-->

### 前置準備

你可以用任何機器會筆電來做底下測試，或者是直接拿此 [Dockerfile][5] 在個人環境先產生乾淨的 Image，Dockerfile 內容很短，也可以從底下複製

    FROM node:6.7.0
    
    RUN curl -o- -L https://yarnpkg.com/install.sh | bash && \
      echo "" >> ~/.bashrc && \
      echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc
    
    CMD /bin/bash

請準備好底下版本

  * node version: v6.7.0
  * npm verison: 3.10.3
  * yarn verison: 0.15.1

可以自己拿任何專案的 `package.json` 或是下載我放在 [Github 的 package.json][6] 來做測試。

### 測試 package 安裝速度

第一階段就是沒有任何 Cache 之下來測試安裝速度

```bash
$ npm cache clean
$ npm install
```

結果: 93.00 秒

```bash
$ yarn cache clean
$ yarn install
```

結果: 42.80s

第二階段就是保留 `node_modules` 目錄，在下一次安裝

```bash
$ npm install
```

結果: 13.00 秒

```bash
$ yarn install
```

結果: 0.16 秒 (注意連 1 秒都不到 XD)

### 結論

|                       | npm     | yarn    |
| --------------------- | ------- | ------- |
| install without cache | 93000ms | 42800ms |
| install with cache    | 13000ms | `160ms` |

上面表格將數據整理好，如果要搞 Devops 至少可以省下將近 13 秒的時間，如果是 Local 團隊開發省下的時間更多了。結論就是大家趕快從 npm 轉到 yarn 吧，yarn 出來不到一個禮拜已經超過 1 萬多個 Star 了，看到開發團隊內包含了許多 [Google 前端大神][7]，這讓我更放心的轉換到 Yarn。寫完本篇才發現官方也有提供[效能比較表][8]。本文提到的數據及檔案都有一併放到 [Github Repo][9]

 [1]: https://yarnpkg.com/
 [2]: https://www.npmjs.com/
 [3]: https://code.facebook.com/posts/1840075619545360
 [4]: https://yarnpkg.com/en/docs/migrating-from-npm
 [5]: https://github.com/appleboy/npm-vs-yarn/blob/master/Dockerfile
 [6]: https://github.com/appleboy/npm-vs-yarn/blob/master/package.json
 [7]: https://github.com/orgs/yarnpkg/people
 [8]: https://yarnpkg.com/en/compare
 [9]: https://github.com/appleboy/npm-vs-yarn