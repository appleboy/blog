---
title: 用 Go 語言減少 node_modules 容量來加速部署
author: appleboy
type: post
date: 2017-11-21T02:40:50+00:00
url: /2017/11/downsize-node-modules-with-golang/
dsq_thread_id:
  - 6298642961
categories:
  - DevOps
  - Golang
  - NodeJS
tags:
  - devops
  - drone
  - golang
  - Node.js
  - yarn

---
[![][1]][1]

之前寫過一篇『[減少 node_modules 大小來加速部署 Node.js 專案][2]』文章，透過 [Yarn][3] 指令可以移除不必要的模組，剩下的模組佔據整個專案大部分容量，那該如何針對留下的模組來瘦身呢？這週看到 [Node.js][4] 大神 [TJ][5] 又發了一個 [Go 語言][6]專案叫做 [node-prune][7]，此專案用來移除在 `node_modules` 內不必要的檔案，那哪些才是不必要的檔案呢？

<!--more-->

## 預設刪除列表

底下是 node-prune 預設刪除的`檔案列表`

<pre><code class="language-go">var DefaultFiles = []string{
    "Makefile",
    "Gulpfile.js",
    "Gruntfile.js",
    ".DS_Store",
    ".tern-project",
    ".gitattributes",
    ".editorconfig",
    ".eslintrc",
    ".jshintrc",
    ".flowconfig",
    ".documentup.json",
    ".yarn-metadata.json",
    ".travis.yml",
    "LICENSE.txt",
    "LICENSE",
    "AUTHORS",
    "CONTRIBUTORS",
    ".yarn-integrity",
}</code></pre>

預設`刪除目錄`

<pre><code class="language-go">var DefaultDirectories = []string{
    "__tests__",
    "test",
    "tests",
    "powered-test",
    "docs",
    "doc",
    ".idea",
    ".vscode",
    "website",
    "images",
    "assets",
    "example",
    "examples",
    "coverage",
    ".nyc_output",
}</code></pre>

預設刪除的`副檔名`

<pre><code class="language-go">var DefaultExtensions = []string{
    ".md",
    ".ts",
    ".jst",
    ".coffee",
    ".tgz",
    ".swp",
}</code></pre>

作者也非常好心，開了 `WithDir`, `WithExtensions` ... 等接口讓開發者可以動態調整名單。其實這專案不只可以用在 Node.js 專案，也可以用在 PHP 或者是 Go 專案上。

## 產生執行檔

對於非 Go 的開發者來說，要使用此套件還需要額外安裝 Go 語言環境才可以正常編譯出 Binary 檔案，也看到有人提問[無法搞定 Go 語言環境][8]，所以我直接 [Fork 此專案][9]，再搭配 [Drone CI][10] 方式輕易產生各種環境的 Binary 檔案，現在只有產生 Windows, Linux 及 MacOS。大家可以從底下連結直接下載來試試看。下載完成，放到 `/usr/local/bin` 底下即可。使用方式很簡單，到專案底下直接執行 `node-prune`

<pre><code class="language-bash">$ node-prune

         files total 16,674
       files removed 4,452
        size removed 18 MB
            duration 1.547s</code></pre>

# [下載連結][11]

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://blog.wu-boy.com/2017/06/downsize-node_modules-to-improve-deploy-speed/
 [3]: https://yarnpkg.com/en/
 [4]: https://nodejs.org/en/
 [5]: https://github.com/tj
 [6]: https://golang.org
 [7]: https://github.com/tj/node-prune
 [8]: https://github.com/tj/node-prune/issues/14
 [9]: https://github.com/appleboy/node-prune
 [10]: https://blog.wu-boy.com/drone-devops/
 [11]: https://github.com/appleboy/node-prune/releases/tag/1.0.0