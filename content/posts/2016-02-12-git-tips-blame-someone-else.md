---
title: 'Git tips: 更改 commit log 作者'
author: appleboy
type: post
date: 2016-02-11T16:11:43+00:00
url: /2016/02/git-tips-blame-someone-else/
dsq_thread_id:
  - 4570789438
categories:
  - Git
  - 版本控制
tags:
  - git
  - git branch
  - git rebase
  - Github

---
[<img src="https://i0.wp.com/farm2.staticflickr.com/1482/24588096069_111b2dcb46_o.png?w=840&#038;ssl=1" alt="github" data-recalc-dims="1" />][1]

在 [Github][2] 上面看到這 [git-blame-someone-else][3] 專案，用來隨時修改 commit log 作者，也就是可以任意改 commit id 內的 \`Author\` 欄位資訊，作者也相當幽默，直接拿此 [commit id][4] 改成 [Linux][5] 作者 [Linus Torvalds][6]。

## 使用時機

大家會問到什麼時候才會用到需要修改 commit 作者，以我自己的狀況為例，在團隊內開發新功能會直接開新的 Branch 來開發，完成後會進行 code review，此時原開發者目前正在忙其他專案，其他團隊成員就必須幫忙修改原先 commit 內容，通常我是直接建議透過 \`git reset --soft HEAD^\` 來更動原本 commit，而不是產生新的 commit，修改後作者就會變成自己，此時後這功能就派上用場了。

## 安裝方式

根據源專案是透過 root 權限，將執行檔丟到 \`/usr/loca/bin\` 目錄底下，但是我個人不建議用這方式，因為還需要 root 權限，要打密碼有點麻煩，我建議透過在家目錄建立 \`bin\` 目錄，並將此目錄加到 \`$PATH\` 變數內即可。

<pre><code class="language-bash">$ mkdir ~/bin
$ wget https://raw.githubusercontent.com/jayphelps/git-blame-someone-else/master/git-blame-someone-else -O ~/bin/git-blame-someone-else
$ chmod 755 ~/bin/git-blame-someone-else</code></pre>

修改 `.bashrc`，加入底下程式碼

<pre><code class="language-bash"># add bin folder to $PATH.
if [ -d "${HOME}/bin" ]; then
    export PATH=$PATH:${HOME}/bin
fi</code></pre>

## 使用方式

<pre><code class="language-bash">$ git blame-someone-else <author> <commit></code></pre>

其中 author 格式為 `Name <Email>` 就可以了，附上執行前後的結果

執行前:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24329093614/in/dateposted-public/" title="Screen Shot 2016-02-11 at 7.54.47 PM"><img src="https://i0.wp.com/farm2.staticflickr.com/1552/24329093614_158d7d5f7c_o.png?resize=524%2C492&#038;ssl=1" alt="Screen Shot 2016-02-11 at 7.54.47 PM" data-recalc-dims="1" /></a>

<pre><code class="language-bash">$ git blame-someone-else "appleboy <appleboy@wu-boy.com>" 3adf61fc1605922fd880d98fb94d1f4f5a0a6289</code></pre>

執行後:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/24329093384/in/dateposted-public/" title="Screen Shot 2016-02-11 at 7.57.21 PM"><img src="https://i2.wp.com/farm2.staticflickr.com/1635/24329093384_b3546c7463_o.png?resize=526%2C489&#038;ssl=1" alt="Screen Shot 2016-02-11 at 7.57.21 PM" data-recalc-dims="1" /></a>

**最後要強調的是，由於修改 commit Author 會影響整個 Git Source Tree，所以要更新到遠端 Server 像是 Github 的話，就必須<span style="color:red;font-weight: bold">強制覆蓋</span>**

<pre><code class="language-bash">$ git push origin master -f</code></pre>

使用前請三思。

 [1]: https://www.flickr.com/photos/appleboy/24588096069/in/dateposted-public/ "github"
 [2]: https://github.com
 [3]: https://github.com/jayphelps/git-blame-someone-else
 [4]: https://github.com/jayphelps/git-blame-someone-else/commit/e5cfe4bb2190a2ae406d5f0b8f49c32ac0f01cd7
 [5]: https://en.wikipedia.org/wiki/Linux
 [6]: https://github.com/torvalds