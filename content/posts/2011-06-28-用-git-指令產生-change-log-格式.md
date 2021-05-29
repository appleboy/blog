---
title: 用 git 指令產生 Change log 格式
author: appleboy
type: post
date: 2011-06-27T16:04:37+00:00
url: /2011/06/用-git-指令產生-change-log-格式/
views:
  - 166
bot_views:
  - 91
dsq_thread_id:
  - 343507396
categories:
  - Git
tags:
  - git
  - 版本控制

---
Git 真的是一套非常好用的版本控制工具，在網路上看到一篇 [Making a Changelog from Git commit messages][1] 裡面提到一篇新手必看的 [git branch model][2]，剛好這篇我也寫了中文解說的部份『[Git 版本控制 branch model 分支模組基本介紹][3]』，回歸正題，此篇是介紹如何用 git 指令產生 Change log 檔案，平常 Change log 都會寫成類似底下的 format: 

<pre class="brush: bash; title: ; notranslate" title="">- Add Chinese Traditional language file
 - Changed to use count_all_results.
 - Added permissions checking to activation in example controller. 
 - Fixed an example in the userguide
 - changed phrases to more typical ones</pre> 在 git log 裡面寫了很多 commit message 該如何 format 成上面的格式呢，其實很簡單，只要打入下面指令 

<pre class="brush: bash; title: ; notranslate" title="">#
#--no-merges: 不要秀出 merge message
#--pretty=format:' - %s' : 關鍵 format
git log --no-merges --pretty=format:' - %s'
</pre> 另外我們還可以透過 --graph 顯示圖形式的 log 顯示，指令如下: 

<pre class="brush: bash; title: ; notranslate" title="">git log --graph --pretty=format:'%s - %Cred%h%Creset  %Cgreen(%cr)%Creset %an' --abbrev-commit --date=relative
</pre> 顯示結果如下 

<pre class="brush: bash; title: ; notranslate" title="">* Add Chinese Traditional language file - 1767c60  (4 months ago) Bo-Yi Wu
* Changed to use count_all_results. - 906d101  (4 months ago) Ben Edmunds
*   Merge branch 'master' of https://github.com/Kohtason/CodeIgniter-Ion-Auth into Kohtason-master - 599188d  (4 months ago) B
en Edmunds
|\
| * Fixed an example in the userguide - 65b0e05  (4 months ago) Sven Lueckenbach
| * changed phrases to more typical ones - 1941831  (4 months ago) Sven Lueckenbach
| * added ability to get usercount - b404fc3  (4 months ago) Kohtason
| * added ability to get usercount - b51e801  (4 months ago) Kohtason
| * added ability to get user-count - 11a85da  (4 months ago) Kohtason
* | Added permissions checking to activation in example controller.  Fixed bug in activation method in model. (via Phil Gyford) - c9ff
467  (4 months ago) Ben Edmunds</pre> 不多說，補一張圖，讓大家看看 

[<img src="https://i0.wp.com/farm6.static.flickr.com/5267/5877607646_a512efa889.jpg?resize=500%2C283&#038;ssl=1" alt="git_log" data-recalc-dims="1" />][4]

 [1]: http://blog.rybas.org/2011/01/15/making-a-changelog-from-git-commit-messages
 [2]: http://nvie.com/posts/a-successful-git-branching-model/
 [3]: http://blog.wu-boy.com/2011/03/git-%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6-branch-model-%E5%88%86%E6%94%AF%E6%A8%A1%E7%B5%84%E5%9F%BA%E6%9C%AC%E4%BB%8B%E7%B4%B9/
 [4]: https://www.flickr.com/photos/appleboy/5877607646/ "git_log by appleboy46, on Flickr"