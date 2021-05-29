---
title: 透過 https 下載套件，取代 git protocol
author: appleboy
type: post
date: 2015-03-14T08:39:04+00:00
url: /2015/03/replace-git-with-https-protocol-for-bower/
dsq_thread_id:
  - 3594200276
categories:
  - Git
tags:
  - Bower
  - git
  - npm

---
[<img src="https://i0.wp.com/farm9.staticflickr.com/8523/8455538800_30f65954f8.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

現在前端套件幾乎都會透過 [Bower][2] 來下載，而 Bower 預設使用 git protocol 來下載原始檔案，如果遇到 timeout 逾時，也就是無法透過 `git://` 方式，就必須要切換成 `https://` 下載，蠻多人遇到此問題，網路上找到這篇 [bower install - github.com connection timed out][3] 解答。在 Console 視窗噴出底下錯誤訊息，就請改用 https 方式。

> Additional error details: fatal: unable to connect to github.com: github.com[0: 192.30.252.130]: errno=Connection timed out 
切換方式很容易，請在 Console 鍵入底下指令

<pre><code class="language-bash">$ git config --global url."https://".insteadOf git://</code></pre>

遇到 `bower install` 卡卡的也可以用這招 ＸＤ

 [1]: https://i0.wp.com/farm9.staticflickr.com/8523/8455538800_30f65954f8.jpg?ssl=1
 [2]: http://bower.io/
 [3]: https://github.com/angular/angular-phonecat/issues/141