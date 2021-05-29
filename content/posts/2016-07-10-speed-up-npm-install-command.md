---
title: 用一行指令加速 npm install
author: appleboy
type: post
date: 2016-07-10T15:44:07+00:00
url: /2016/07/speed-up-npm-install-command/
dsq_thread_id:
  - 4974818988
categories:
  - DevOps
  - javascript
  - NodeJS
tags:
  - devops
  - javascript
  - Node.js

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24588632402/in/dateposted-public/" title="Npm-logo.svg"><img src="https://i2.wp.com/farm2.staticflickr.com/1564/24588632402_35c2cab0b6_z.jpg?resize=640%2C249&#038;ssl=1" alt="Npm-logo.svg" data-recalc-dims="1" /></a>

不久之前寫過一篇 [提升 npm install 安裝速度][1]，但是發現速度還是沒有變快，在 DevOps 的流程花在 `npm install` 的時間非常冗長，造成每次測試或 Deploy 都要花大量時間等待，且吃掉很多機器的資源，本篇要提供一個小技巧改善 npm install 安裝時間，其實簡單來說就是 cache 第一次安裝好的 `node_modules` 目錄，之後每次安裝就拿 cache 目錄來新增或減少 packages 即可。

<!--more-->

### 一行指令

底下一行指令請加入測試流程內，讓 CI Server 專注在測試

<pre><code class="language-bash">$ tar xf ../nm_cache.tar && \
  npm prune && \
  npm install && \
  tar cf ../nm_cache.tar node_modules</code></pre>

步驟很簡單，先拿上一次備份的 `node_modules`，再透過 `npm prune` 移除不必要的 package，再透過 `npm install` 安裝新的 package，最後一樣打包給下一次測試使用。這指令非常好用，不管你是不是用 npm@3 都很需要這指令加速 npm install。底下是我隨意拿一個 open source 專案來測試，先假設沒有 cache 機制。

<pre><code class="language-bash">$ rm -rf ~/.npm && rm -rf node_modules && time npm install

real    2m7.751s
user    1m8.704s
sys 0m19.272s</code></pre>

如果導入 cache 機制

<pre><code class="language-bash">$ time (tar xf ../nm_cache.tar && npm prune && rm -rf ~/.npm && npm install && tar cf ../nm_cache.tar node_modules)

> labs-web@0.0.1 postinstall /Users/mtk10671/git/labs-web
> node node_modules/fbjs-scripts/node/check-dev-engines.js package.json

real    0m32.370s
user    0m19.884s
sys 0m13.582s</code></pre>

從 2 分 7 秒變成 32 秒，大約提升了 4 倍，大家可以嘗試看看，這招在 Deploy 跟測試非常有感覺。

 [1]: https://blog.wu-boy.com/2016/01/speed-up-npm-install/