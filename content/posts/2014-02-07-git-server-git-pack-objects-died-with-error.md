---
title: 'Git Server 噴 git upload-pack: git-pack-objects died with error'
author: appleboy
type: post
date: 2014-02-07T10:32:36+00:00
url: /2014/02/git-server-git-pack-objects-died-with-error/
dsq_thread_id:
  - 2233012472
categories:
  - Git
  - Git
  - Linux
tags:
  - git
  - GitLab

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8455538800/" title="Git-Logo-2Color by appleboy46, on Flickr"><img src="https://i0.wp.com/farm9.staticflickr.com/8523/8455538800_30f65954f8.jpg?w=840&#038;ssl=1" style="max-width: 250px;" alt="Git-Logo-2Color" data-recalc-dims="1" /></a>
</div>

透過 [Gitlab][1] 架設 [Git][2] Server 來放一些 Document 資料，由於個人 Document 都是 pdf 檔案，所以整個 Git Repository 就非常肥大，今天在 Clone 下來的時候，不僅是主機 CPU 飆高，然後記憶體被吃到快沒了，最後還噴出底下錯誤訊息

<div>
  <pre class="brush: bash; title: ; notranslate" title="">remote: Counting objects: 4912, done.
remote: fatal: Out of memory, malloc failed
error: git upload-pack: git-pack-objects died with error.
fatal: git upload-pack: aborting due to possible repository corruption on the remote side.
remote: aborting due to possible repository corruption on the remote side.
fatal: early EOF
fatal: index-pack failed</pre>
</div>

<!--more--> 網路上查到這篇 

[Git clone error + remote: fatal: Out of memory, malloc failed + error: git upload-pack: git-pack-objects died with error.][3] 解法，裡面提到在每次 clone 專案時，Git 都會將資料壓縮並且存放到記憶體，所以如果 Repository 超過 100MB，你就會發現記憶體漸漸減少，然後整個炸掉，解法就是設定此 Repository 讓大家直接下載檔案，不要先丟到記憶體內，所以請打開 `config` 設定檔案，裡面寫入

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[pack]
    window = 0</pre>
</div>

 [1]: http://gitlab.org/
 [2]: http://git-scm.com/
 [3]: http://linuxhospital.wordpress.com/2013/10/14/git-clone-error-remote-fatal-out-of-memory-malloc-failed-error-git-upload-pack-git-pack-objects-died-with-error/