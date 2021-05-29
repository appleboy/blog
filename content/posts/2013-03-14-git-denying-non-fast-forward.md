---
title: Git denying non-fast forward 問題
author: appleboy
type: post
date: 2013-03-14T08:21:01+00:00
url: /2013/03/git-denying-non-fast-forward/
dsq_thread_id:
  - 1136386368
categories:
  - Git
  - 版本控制
tags:
  - git
  - Github

---
最近幫別公司處理 denying non-fast forward 的 git server 問題，沒事就別動檔案權限，不管是不是修改內容，只要用 chmod 指令，<a href="http://git-scm.com/" target="_blank">Git</a> 還是會判別檔案變動。處理 git push 直接給我噴 

<pre class="brush: bash; title: ; notranslate" title="">$ git push --force origin master
Total 0 (delta 0), reused 0 (delta 0)  
error: denying non-fast forward refs/heads/master (you should pull first)  
To git@git.example.com:myrepo.git  
! [remote rejected] master -> master (non-fast forward)  
error: failed to push some refs to 'git@git.example.com:myrepo.git'</pre> 會遇到這問題的原因是使用者將不該 commit 的程式碼都 push 到伺服器上面，例如資料庫帳號密碼，個人帳蜜等等，這真的是不應該，解決方式也沒有很難，只要用 git reset --hard 到您需要的 commit hash 值，並且 git push --force 方式蓋掉 Server 上面的程式碼，但是如果遇到 

<span style="color:green">git push --force origin</span> 或 <span style="color:green">git push --force origin master</span> 都無作用，那就請加上底下設定 

<pre class="brush: bash; title: ; notranslate" title="">$ git config --system receive.denyNonFastForwards false</pre> 在 Github 上面怎麼用 force 都可以直接覆蓋，私人自己架設的，請加入此設定，但是這設定基本上蠻危險的，如果用 git reset --hard xxxx，xxx 為很久以前的版本，並且 force 到 Server 上面，那就等於沒救了 XD,所以用 --force push 到 server 上面時，請小心阿，基本上可以搭配 

[git cherry-pick][1] 來撿還需要的 commit 內容。 Ref: <a href="http://blog.wu-boy.com/2011/08/git-cherry-pick-%E8%99%95%E7%90%86%E5%B0%88%E6%A1%88-pull-request/" target="_blank">git cherry-pick 處理專案 pull request</a> <a href="http://stackoverflow.com/questions/1377845/git-reset-hard-and-a-remote-repository" target="_blank">Git reset --hard and a remote repository</a> <a href="http://git-scm.com/book/ch7-1.html" target="_blank">7.1 Customizing Git - Git Configuration</a>

 [1]: http://blog.wu-boy.com/2011/08/git-cherry-pick-%E8%99%95%E7%90%86%E5%B0%88%E6%A1%88-pull-request/