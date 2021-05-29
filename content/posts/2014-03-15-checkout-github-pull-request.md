---
title: 在 Local 端處理 Github 專案 Pull Request
author: appleboy
type: post
date: 2014-03-15T03:00:27+00:00
url: /2014/03/checkout-github-pull-request/
dsq_thread_id:
  - 2433505069
categories:
  - Git
  - 版本控制
tags:
  - git
  - Github

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/13158675193/" title="github-logo"><img src="https://i2.wp.com/farm3.staticflickr.com/2238/13158675193_2892abac95.jpg?resize=500%2C198&#038;ssl=1" alt="github-logo" data-recalc-dims="1" /></a>

這篇會筆記如何將 [Github][1] 上專案內的 [Pull Request][2] 拉到 Local 端電腦，雖然現在大部分的 Open Source 都會寫 Unit Test 並且搭配免費的 [Travis CI][3] 自動化測試，但是有時候也是需要把別人的 Pull Request 拉下來測試後再進行 Merge，而 Github 官方有提供一篇說明文件 [Checking out pull requests locally][4]，底下紀錄操作步驟。

<!--more-->

### clone 新專案，修改設定檔

拿 [gulp-compass][5] 專案來測試

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git clone https://github.com/appleboy/gulp-compass.git</pre>
</div>

接著打開 `.git/config` 可以看到底下設定檔

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[remote "origin"]
        fetch = +refs/heads/*:refs/remotes/origin/*
        url = https://github.com/appleboy/gulp-compass.git
[branch "master"]
        remote = origin
        merge = refs/heads/master</pre>
</div>

請增加一行 refspec 紀錄，修改狀態後為底下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">[remote "origin"]
        fetch = +refs/heads/*:refs/remotes/origin/*
        url = https://github.com/appleboy/gulp-compass.git
        fetch = +refs/pull/*/head:refs/pull/origin/*</pre>
</div>

### 抓取遠端 Pull request

接著請執行 `git fetch origin`，可以看到底下結果

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git fetch origin
remote: Counting objects: 79, done.
remote: Compressing objects: 100% (46/46), done.
remote: Total 79 (delta 38), reused 59 (delta 28)
Unpacking objects: 100% (79/79), done.
From https://github.com/appleboy/gulp-compass
 * [new branch]      refs/pull/1/head -&gt; refs/pull/origin/1
 * [new branch]      refs/pull/10/head -&gt; refs/pull/origin/10
 * [new branch]      refs/pull/12/head -&gt; refs/pull/origin/12
 * [new branch]      refs/pull/16/head -&gt; refs/pull/origin/16
 * [new branch]      refs/pull/21/head -&gt; refs/pull/origin/21
 * [new branch]      refs/pull/23/head -&gt; refs/pull/origin/23
 * [new branch]      refs/pull/26/head -&gt; refs/pull/origin/26
 * [new branch]      refs/pull/28/head -&gt; refs/pull/origin/28
 * [new branch]      refs/pull/5/head -&gt; refs/pull/origin/5
 * [new branch]      refs/pull/6/head -&gt; refs/pull/origin/6
 * [new branch]      refs/pull/7/head -&gt; refs/pull/origin/7
 * [new branch]      refs/pull/8/head -&gt; refs/pull/origin/8
 * [new branch]      refs/pull/9/head -&gt; refs/pull/origin/9</pre>
</div>

請注意 `refs/pull/` 是唯讀狀態，你無法 commit 任何程式碼上去

### 讀取特定 pull request

上述步驟完成後，可以直接執行底下指令，來讀取特定的 Pull request

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git checkout -b 28 pull/origin/28
Switched to a new branch '28'</pre>
</div>

最後我們來看看線圖

<div>
  <pre class="brush: bash; title: ; notranslate" title="">*  d0b3fc1 clear css folder before testing. (origin/master, origin/HEAD, master)
|  
*  22b6362 update readme.
|  
*  eaf0cdb add test import_path array option.
|  
*  9bc303c bump version. (1.1.6)
|  
*  7e94db6 fixed coding style.
|    
*    f9f0350 Merge branch '28'
|\  
| |   
| *  3fa510d Fix garbled output. (HEAD, refs/pull/origin/28, 28)
| |   
* |  c3d8c18 update jshin to 1.5.0 and remove default parameter ".jshintrc".
|/  
|    
*    0e87ccf Merge pull request #26 from theblacksmith/multiple-import-paths</pre>
</div>

我們可以看到現在專案內的 HEAD 已經指向 #28 的 Pull request，請注意 `(HEAD, refs/pull/origin/28, 28)`，如果測試沒問題，就可以透過 git merge 回 master 分支

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git checkout master
$ git merge pull/origin/28
$ git push origin master</pre>
</div>

Github 上面預設是使用 git merge，當然你自己也可以用 [git rebase][6] 方式讓分支不要這麼亂。完成後上傳回 Github，你會發現該 pull request 就會被關閉並且 merge 完成。

 [1]: https://github.com/
 [2]: https://help.github.com/articles/using-pull-requests
 [3]: https://travis-ci.org/
 [4]: https://help.github.com/articles/checking-out-pull-requests-locally
 [5]: https://github.com/appleboy/gulp-compass
 [6]: http://git-scm.com/book/en/Git-Branching-Rebasing