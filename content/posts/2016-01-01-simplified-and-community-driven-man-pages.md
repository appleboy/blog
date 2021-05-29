---
title: 快樂學習 Linux 指令懶人包
author: appleboy
type: post
date: 2016-01-01T08:03:32+00:00
url: /2016/01/simplified-and-community-driven-man-pages/
dsq_thread_id:
  - 4451419810
categories:
  - Linux
  - Ubuntu
tags:
  - Github
  - tldr

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/13158675193/" title="github-logo"><img src="https://i2.wp.com/farm3.staticflickr.com/2238/13158675193_2892abac95.jpg?resize=500%2C198&#038;ssl=1" alt="github-logo" data-recalc-dims="1" /></a>

以前在推廣 Linux 的時候，大家最不喜歡 Command Line 介面，都是被 Windows 慣壞了，相信剛接觸 Linux 最痛苦的就是學習指令，新人學習指令遇到困難，上網發問，一定會看到有人回答說，怎麼不看 man page，但是每個指令的 man page 都非常的長，連我自己看到都直接關掉，何況是剛入門 Linux 的新人。現在 [Github][1] 上面有看到這專案 [tldr][2]，這專案把每個指令文件簡單化，讓剛學習 Linux 的新人可以快速上手，像是底下 `find` 指令

<!--more-->

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24017172161/in/datetaken-public/" title="Screen Shot 2016-01-01 at 3.51.28 PM"><img src="https://i1.wp.com/farm6.staticflickr.com/5759/24017172161_a2cebe7efc_z.jpg?resize=640%2C298&#038;ssl=1" alt="Screen Shot 2016-01-01 at 3.51.28 PM" data-recalc-dims="1" /></a>

官網提供各式語言的安裝方式，底下透過 [Node.js][3] 安裝方法。

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ npm install -g tldr</pre>
</div>

看了一下文件，好多人貢獻，好多小技巧可以學習，像是用 `cp` 指令備份並且改副檔名

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ cp README.{md,backup}</pre>
</div>

或直接改副檔名

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ cp README.md{,.backup}</pre>
</div>

在沒看到這文件之前，都是使用最傳統的方式

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ cp README.md README.backup</pre>
</div>

 [1]: https://github.com
 [2]: http://tldr-pages.github.io/
 [3]: https://nodejs.org/en/