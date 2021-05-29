---
title: Git 版本控制 branch model 分支模組基本介紹
author: appleboy
type: post
date: 2011-03-02T04:45:34+00:00
url: /2011/03/git-版本控制-branch-model-分支模組基本介紹/
views:
  - 3112
bot_views:
  - 256
dsq_thread_id:
  - 246687871
categories:
  - Git
tags:
  - git
  - git branch

---
我相信大家對於 [Git][1] 版本控制不陌生了，Git 最大強項就是可以任意建立 branch，讓您開發程式不需要擔心原本的程式碼會被動到，造成不知道該怎麼恢復原來的狀態。為了不影響產品發展，branch 對於大型工作團隊就顯得更重要了，今天在網路上看到一篇 [A successful Git branching model][2] 文章，裡面把 branch 使用方式寫得非常清楚，底下我會透過指令來說明如何使用簡單 branch 指令，當然請大家先去 [github][3] 註冊申請帳號，如果不想申請帳號，也可以自己在 local 端去執行。

底下所引用的圖片都是經由 [A successful Git branching model][2] 文章所提供。

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5488984404/" title="git-flow by appleboy46, on Flickr"><img src="https://i0.wp.com/farm6.static.flickr.com/5293/5488984404_4f693eec32_z.jpg?resize=480%2C640&#038;ssl=1" alt="git-flow" data-recalc-dims="1" /></a>
</div>

看到這張圖其實就說明了 branch 最重要的精神:『無限建立分支』，大家也不用害怕看不懂這張圖，底下說明 branch 分支狀況

<!--more-->

主要分支

  * master 主程式(除非重大 bug，則會分出 hotfix 分支)
  * develop 開發分支(用來在另外分支出 Release, feature)

次要分支

  * Hotfixes(由 master 直接分支，馬上修正 bug)
  * Feature(由 develop 直接分支，開發新功能)
  * Release(由 develop 直接分支，開發下一版 Release)

## 主要分支 ( The main branches )

當專案開始執行時，我們這時候必須將程式碼分成兩部份，一個是 master 另一個就是 develop，master 主要用來 Release 產品專用，沒事就不要去動它，假如要繼續開發新功能，或者是修正 Bug issue 就利用 develop 這分支來開發，等待開發完成，要 Release 下一版產品時就將 develop merge 到 origin/master 分支，這樣才對，避免有人把 origin/master 改爛，底下這張圖就說明了一切:

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5488387425/" title="bm002 by appleboy46, on Flickr"><img src="https://i2.wp.com/farm6.static.flickr.com/5140/5488387425_8e74788092.jpg?resize=254%2C378&#038;ssl=1" alt="bm002" data-recalc-dims="1" /></a>
</div>

## 次要分支 ( Supporting branches )

次要分支這裡包含了 Hotfixes, Feature, Release，其中 Hotfixes 用來修正產品最重大 bug，所以由 origin/master 直接分支出來，修正之後在 merge 回 master 跟 develop。Feature 跟 Release 都是從 develop 分支出來，最後都 merge 回 develop branch，主分支 master 再去 merge develop，這樣就完成了。上面的例子，不一定套用在各專案，因為 branch 免錢，要多少有多少，不一定完全都要 follow 此方法。

## 新功能分支 ( Feature branches )

> branch off from: develop Must merge back into: develop

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5488387469/" title="fb by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.static.flickr.com/5060/5488387469_0fc00f8589.jpg?resize=133%2C352&#038;ssl=1" alt="fb" data-recalc-dims="1" /></a>
</div>

看到上面圖說明，我想大家都很清楚，develop 分支出 Feature branch，用來開發產品新功能，等到開發完整之後，在直接 merge 回 develop，底下直接用實際例子來操作:

直接由 develop 開出分支 myfeature，並且直接切換過去

<pre><code class="language-bash">git checkout -b myfeature develop</code></pre>

直接下 git branch 觀看目前位置

<pre><code class="language-shell">develop
  master
* myfeature</code></pre>

經過編輯修改並且 commit

<pre><code class="language-bash">git add test.php
git commit -a -m "Add: test.php"</code></pre>

合併分支:先切換到 develop

<pre><code class="language-bash">$ git checkout develop
Switched to branch &#039;develop&#039;</code></pre>

利用 --no-ff 合併分支(稍後說明為什麼使用 --no-ff)

<pre><code class="language-bash">$ git merge --no-ff myfeature
Merge made by recursive.
 test.php |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 test.php</code></pre>

刪除 myfeature 分支

<pre><code class="language-bash">$ git branch -d myfeature
Deleted branch myfeature (was dedf7ed).</code></pre>

將資料上傳

<pre><code class="language-bash">$ git push origin develop</code></pre>

在說明 git merge --no-ff 之前，大家先看底下的圖。

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5488984566/" title="merge-without-ff by appleboy46, on Flickr"><img src="https://i0.wp.com/farm6.static.flickr.com/5054/5488984566_359f74ecc2.jpg?resize=463%2C414&#038;ssl=1" alt="merge-without-ff" data-recalc-dims="1" /></a>
</div>

有沒有很清楚發現差別，右邊是正常的 merge，會將原本的 commit log 合併成一條，然而如果加上 <span style="color:green"><b>--no-ff</b></span> option 的話，commit log 會紀錄您是開分支出去的，清楚紀錄您的分支操作步驟，建議大家多使用此方法，畢竟預設的 merge 看到的效果不是我想要的。

## 產品分支 (Release branches)

> May branch off from: develop Must merge back into: develop and master

`Release branch` 跟 `Feature branch` 不同點就是: 前者需要 merge 回 master，後者不需要，所以操作步驟會多一點，但是觀念不變啦。底下實際看個例子，操作一次，大家就可以熟悉了。

從 develop 開新分支 release-1.3

<pre><code class="language-bash">git checkout -b release-1.3 develop</code></pre>

經過一堆 commit message

<pre><code class="language-bash">git commit -a -m "Update: release 1.3"</code></pre>

切回去主分支 master

<pre><code class="language-bash">git checkout master</code></pre>

master 合併 release-1.3 分支

<pre><code class="language-bash">git merge --no-ff release-1.3</code></pre>

在 master 上面加上新 tag

<pre><code class="language-bash">git tag -a v1.3 -m "Release v1.3 Tag"</code></pre>

切換到 develop 分支

<pre><code class="language-bash">git checkout develop</code></pre>

一樣是 merge release-1.3

<pre><code class="language-bash">git merge --no-ff release-1.3</code></pre>

上傳資料

<pre><code class="language-bash">git push</code></pre>

將新 Tag v1.3 更新到 origin/master

<pre><code class="language-bash">git push origin v1.3</code></pre>

刪除 release-1.3 分支

<pre><code class="language-bash">
$ git branch -d release-1.3
Deleted branch release-1.3 (was 2c92042).</code></pre>

## 重大 issue 分支 ( Hotfix branches )

> May branch off from: master, Must merge back into: develop and master

Branch naming 命名方式: `hotfix-*`

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/5488387579/" title="hotfix-branches1 by appleboy46, on Flickr"><img src="https://i1.wp.com/farm6.static.flickr.com/5018/5488387579_e94bf6ed82.jpg?resize=307%2C422&#038;ssl=1" alt="hotfix-branches1" data-recalc-dims="1" /></a>
</div>

當我們產品線發現 critical bug 時，這就要從 master 拉出 hotfix-* 分支，儘快將 bug 解決，並且同時 merge 到 develop 跟 master，底下實際例子操作:

從 master 開新分支 hotfix-1.3.1

<pre><code class="language-bash">git checkout -b hotfix-1.3.1 master</code></pre>

修改檔案，並且 commit

<pre><code class="language-bash">git commit -a -m "Hotfix: release 1.3.1"</code></pre>

切換到 master

<pre><code class="language-bash">git checkout master</code></pre>

merge hotfix-1.3.1 分支

<pre><code class="language-bash">git merge --no-ff hotfix-1.3.1</code></pre>

加上修正過後的 Tag

<pre><code class="language-bash">git tag -a v1.3.1 -m "Hotfix v1.3.1 Tag"</code></pre>

切換到 develop 分支

<pre><code class="language-bash">git checkout develop</code></pre>

一樣是 merge hotfix-1.3.1 分支

<pre><code class="language-bash">git merge --no-ff hotfix-1.3.1</code></pre>

合併過後就刪除 hotfix-1.3.1 分支

<pre><code class="language-bash">git branch -d hotfix-1.3.1</code></pre>

上傳資料

<pre><code class="language-bash">git push</code></pre>

將 Tag v1.3.1 上傳

<pre><code class="language-bash">git push origin v1.3.1</code></pre>

可以直接看看我的例子 [<https://github.com/appleboy/test/network>][4] 畫出來的 network 圖就是長那樣...

看完上面例子，是否清楚瞭解 branch 的基本用法，其實不會很難，看圖說故事而已，git Tag 的用法可以參考之前寫的一篇:『[git-版本控制-如何使用標籤tag][5]』。如果有任何問題，都可以在此留言。

 [1]: http://git-scm.com/
 [2]: http://nvie.com/posts/a-successful-git-branching-model/
 [3]: https://github.com/
 [4]: https://github.com/appleboy/test/network
 [5]: http://blog.wu-boy.com/2010/11/git-%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6-%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8%E6%A8%99%E7%B1%A4tag/