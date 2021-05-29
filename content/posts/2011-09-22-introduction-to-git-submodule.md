---
title: Git Submodule 介紹與使用
author: appleboy
type: post
date: 2011-09-22T12:30:44+00:00
url: /2011/09/introduction-to-git-submodule/
dsq_thread_id:
  - 422474189
dsq_needs_sync:
  - 1
categories:
  - Git
tags:
  - git
  - Github
  - 版本控制

---
自己用 <a href="http://git-scm.com/" target="_blank">Git</a> 已經很長一段時間了，沒用過 git submodule 的話真的是對不起自己，今天來筆記 <a href="http://book.git-scm.com/5_submodules.html" target="_blank">Git Submodule</a> 一些操作步驟及說明。

## git Submodule 使用時機

大家在開發新專案的時候，不知道有沒有用到其他專案的程式碼，像是 Web 專案，也許會用到 <a href="http://www.blueprintcss.org/" target="_blank">Blueprintcss CSS Framwork</a> 或者是 <a href="http://sass-lang.com/" target="_blank">Sass</a>，這些專案目前都放在 <a href="http://github.com" target="_blank">Github</a> 上面進行維護，以前的作法就是先 git clone 下來，把要的檔案分別複製到自己專案，可是問題來了，如果官方更新了程式碼，那自己的專案如何更新呢？難道是重複步驟把檔案複製到原來地方嗎？這樣會不會太麻煩，這時候就是需要 <span style="color:green"><strong>git submodule</strong></span> 來幫助大家進行程式碼的更新，這樣隨時隨地都可以取得最新的程式碼。補充說明一點，git 目前無法針對單一專案底下的單一檔案或目錄進行 clone，而必須 clone 整個目錄，這點跟 <a href="http://subversion.tigris.org/" target="_blank">svn</a> 有很大的不同，所以 git 可以建立各個不同的 submodule 來整合成一個大型 Project。換句話說就是: 在您的專案底下，**<span style="color:red">你可以任意將其他人的專案掛載在自己任何目錄底下</span>**。

<!--more-->

## 建立 Git Submodule

在練習 git 指令之前請先註冊好 github 帳號，並且開一個測試 repository，建立 Submodule 非常容易，範例如下:

<pre><code class="language-bash">git submodule add &lt;repository&gt; [&lt;path&gt;]</code></pre>

實際指令範例:

<pre><code class="language-bash">git submodule add https://github.com/appleboy/CodeIgniter-TW-Language user_guide</code></pre>

下這指令之前請注意最後面的 <span style="color:red"><strong>path</strong></span> 部份，請勿先建立空的目錄，也就是如果該目錄存在，就會衝突，所以並不需要額外幫 module 建立目錄，指令完成結果如下:

<pre><code class="language-bash">Cloning into user_guide...
remote: Counting objects: 32, done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 32 (delta 12), reused 32 (delta 12)
Unpacking objects: 100% (32/32), done.</code></pre>

這時候在目錄底下打入指令 git status，你會發現多了兩個檔案需要 commit

<pre><code class="language-bash"># On branch master
# Changes to be committed:
#   (use "git reset HEAD &lt;file&gt;..." to unstage)
#
#       new file:   .gitmodules
#       new file:   user_guide
#</code></pre>

注意第一個檔案 .gitmodules，裡面紀錄 submodule 的對應關係，我們實際打開看內容:

<pre><code class="language-bash">[submodule "user_guide"]
    path = user_guide
    url = https://github.com/appleboy/CodeIgniter-TW-Language</code></pre>

裡面寫的很清楚，之後如果要清除 sub module 也是要從這檔案移除相關設定，接著就是直接 commit 到 project 底下吧

<pre><code class="language-bash">git commit -a -m "first commit with submodule codeigniter user guide" && git push</code></pre>

接著回去看 github 網站就會多出一個小圖示了 [<img src="https://i0.wp.com/farm7.static.flickr.com/6166/6171610249_1ca6a15544.jpg?resize=500%2C147&#038;ssl=1" alt="git_submodule" data-recalc-dims="1" />][1] 最後還是需要初始化 init submodule，透過底下指令來達成，否則 git 不知道你有新增 module

<pre><code class="language-bash">git submodule init</code></pre>

## clone project with Git Submodule

我們還是拿上面的例子來測試，首先還是一樣用 git clone 來下載程式碼:

<pre><code class="language-bash">git clone git@github.com:appleboy/test.git test2</code></pre>

可是你有沒有發現 user_guide 這 sub module 是<span style="color:red"><strong>空目錄</strong></span>，這時候就是要透過 git submodule 來下載程式碼

<pre><code class="language-bash">[freebsd][root][ /home/git/test2 ]# git submodule init
Submodule &#039;user_guide&#039; (https://github.com/appleboy/CodeIgniter-TW-Language) registered for path &#039;user_guide&#039;
[freebsd][root][ /home/git/test2 ]# git submodule update
Cloning into user_guide...
remote: Counting objects: 32, done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 32 (delta 12), reused 32 (delta 12)
Unpacking objects: 100% (32/32), done.
Submodule path &#039;user_guide&#039;: checked out &#039;7efead6378993edfaa0c55927d4a4fdf629c4726&#039;</code></pre>

注意上面，有沒有看到 git submodule init 來設定 **<span style="color:green">.git/config</span>**，在接著用 git submodule update 來更新檔案，可以打開 **<span style="color:green">.git/config</span>** 可以發現多了底下資料:

<pre><code class="language-bash">[submodule "user_guide"]
    url = https://github.com/appleboy/CodeIgniter-TW-Language</code></pre>

## 更新已安裝 module

一樣切換到 sub module 目錄，接著做 git pull

<pre><code class="language-bash">cd user_guide/
git pull origin master</code></pre>

這時候我們切回去上層目錄，執行 git status

<pre><code class="language-bash"># On branch master
# Changed but not updated:
#   (use "git add &lt;file&gt;..." to update what will be committed)
#   (use "git checkout -- &lt;file&gt;..." to discard changes in working directory)
#
#       modified:   user_guide (new commits)</code></pre>

我們有了 new commit，有沒有發現與 git submodule add 的時候一樣，這時候我們需要同步 sub module commit ID 到 parent，所以一樣執行 git commit && git push 即可。

<pre><code class="language-bash">git commit -a -m "first commit with submodule codeigniter user guide" && git push</code></pre>

最後可以透過 statu 來看看是否有相同的 commit ID

<pre><code class="language-bash">git submodule status</code></pre>

## 移除 Sub module

移除方式非常容易，上面有提到的檔案都必需要經過修改

  1. 移除目錄 
    <pre><code class="language-bash">git rm --cached [目錄]
git rm [目錄]</code></pre>

  2. 修改 .gitmodules，移除不需要的 module 
    <pre><code class="language-bash">vi .gitmodules</code></pre>

  3. 修改 .git/config，移除 submodule URL 
    <pre><code class="language-bash">vi .git/config</code></pre>

  4. 執行 commit 
    <pre><code class="language-bash">git add . && git commit -m "Remove sub module"</code></pre>

  5. 最後 syn module 資料 
    <pre><code class="language-bash">git submodule sync</code></pre>

## 總結歸納

git submodule 可以用在跟其他團隊一起合作開發時候，我們只需要知道大的 git，一些細部的 sub module 就可以讓其他團隊在繼續往下開，相當方便。另外也避免每當要更新檔案的時候，還需要重複 clone 加上 cp 資料到對應目錄。

## 參考文件

  * <a href="http://josephjiang.com/entry.php?id=342" target="_blank">Git Submodule 的認識與正確使用！</a>
  * <a href="http://progit.org/book/ch6-6.html" target="_blank">Pro git: git submodule</a>

 [1]: https://www.flickr.com/photos/appleboy/6171610249/ "git_submodule by appleboy46, on Flickr"