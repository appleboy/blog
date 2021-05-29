---
title: Node Version Manager 版本管理 NVM
author: appleboy
type: post
date: 2013-01-09T10:34:07+00:00
url: /2013/01/node-version-manager/
dsq_thread_id:
  - 1015916994
categories:
  - io.js
  - javascript
  - NodeJS
tags:
  - iojs
  - NodeJS
  - nvm

---
**2015.02.12 官方已經支援 nvm install stable，補上 io.js 說明**

<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6033708087/" title="nodejs-light by appleboy46, on Flickr"><img src="https://i1.wp.com/farm7.static.flickr.com/6199/6033708087_ff1a02a337_o.jpg?resize=260%2C71&#038;ssl=1" alt="nodejs-light" data-recalc-dims="1" /></a>
</div>

本篇不是要介紹 <a href="http://nodejs.org/" target="_blank">Node.js</a>，是要介紹管理 Node.js 版本的工具，之前是玩 <a href="https://github.com/visionmedia" target="_blank">Visionmedia</a> 開發的 <a href="https://github.com/visionmedia/n" target="_blank">n</a>，後來跳到玩 <a href="https://github.com/creationix" target="_blank">Creationix</a> 開發的 <a href="https://github.com/creationix/nvm" target="_blank">nvm</a> tool，目前支援 stable command，也就是下 `nvm install stable` (直接裝好 v0.12.0)。

# 安裝方式

可以使用 `curl` 或 `wget` 方式安裝

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | bash
$ wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | bash</pre>
</div>

# 使用方式

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># 安裝最新穩定版本
$ nvm install stable
# 移除最新穩定版本
$ nvm uninstall stable
# 使用穩定版本
$ nvm use stable
$ nvm run unstable --version</pre>
</div>

如果有玩 [io.js][1] 可以下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ nvm install iojs</pre>
</div>

 [1]: https://iojs.org/