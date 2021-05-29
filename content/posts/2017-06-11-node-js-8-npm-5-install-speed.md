---
title: Node.js 8 搭配 npm 5 速度
author: appleboy
type: post
date: 2017-06-11T05:02:28+00:00
url: /2017/06/node-js-8-npm-5-install-speed/
dsq_thread_id:
  - 5899507974
categories:
  - NodeJS
tags:
  - Node.js
  - npm
  - yarn

---
[<img src="https://i1.wp.com/c7.staticflickr.com/6/5712/29998255630_b40ff9df74_z.jpg?w=840&#038;ssl=1" alt="yarn-kitten-full" data-recalc-dims="1" />][1]

這個月 [Node.js][2] 釋出 8.0 版本，搭配的就是 npm [v5.0.0][3] 版本，[上一篇][4]寫到如何透過 [Yarn][5] 指令移除 devDependencies 內的 Package 套件，減少 node_modules 大小，有網友提到那 npm 5 的速度為何？其實筆者已經好久沒有用 npm 了，但是有人提問，我就立馬來測試看看 npm vs yarn 的速度，詳細數據可以參考此[專案說明][6]。測試方法如下

<!--more-->

## 設定環境

底下是測試環境版本

  * node version: `v8.0.0`
  * npm verison: `5.0.0`
  * yarn verison: `0.24.6`

## 初次安裝 (沒有任何快取)

先把 node_modules 刪除，及系統相關 Cache 目錄都移除

```bash
$ npm cache verify
$ rm -rf ~/.npm/_cacache/
$ time npm install
```

npm 花費時間: 1m43.370s

```bash
$ yarn cache clean
$ time yarn install
```

yarn 花費時間: 1m1.707s

## 保留系統快取目錄

執行完第一次安裝後，我們把 node_modules 移除後再安裝一次試試看

```bash
$ rm -rf node_moduels
$ time npm install
```

npm 花費時間: 0m38.819s

```bash
$ rm -rf node_moduels
$ time yarn install
```

yarn 花費時間: 0m24.219s

## 保留系統快取目錄及 node_modules

最後保留 node_modules 目錄，再執行一次安裝

```bash
$ time npm install
```

npm 花費時間: 0m11.216s

```bash
$ time yarn install
```

yarn 花費時間: 0m0.954s

## 結論

大家可以發現，雖然 npm 改進不少速度，但是 Yarn 還是優勝許多，這邊可以總結，已經在使用 yarn 的，可以繼續使用，尚未使用 yarn 的開發者，可以嘗試使用看看。另外 npm 5 現在執行 npm install --save 會預設產生出 `package-lock.json` 跟 yarn 產生的 `yarn.lock` 是類似的東西，除非專案內已經有 `npm-shrinkwrap.json`，否則 npm 會自動幫專案產生喔。詳細情形可以看 [Replace metadata + fetch + cache code][7]。npm cache 指令可以看此[文件][8]。

 [1]: https://www.flickr.com/photos/appleboy/29998255630/in/dateposted-public/ "yarn-kitten-full"
 [2]: https://nodejs.org/en/
 [3]: https://github.com/npm/npm/releases/tag/v5.0.0
 [4]: https://blog.wu-boy.com/2017/06/downsize-node_modules-to-improve-deploy-speed/
 [5]: https://yarnpkg.com/en/
 [6]: https://github.com/appleboy/npm-vs-yarn
 [7]: https://github.com/npm/npm/pull/15666
 [8]: https://github.com/npm/npm/blob/latest/doc/cli/npm-cache.md