---
title: 版本控制 version control git clean 使用時機
author: appleboy
type: post
date: 2011-05-20T04:55:17+00:00
url: /2011/05/版本控制-version-control-git-clean-使用時機/
views:
  - 356
bot_views:
  - 100
dsq_thread_id:
  - 308588243
categories:
  - Git
  - www
tags:
  - git
  - svn

---
在做公司的每一個案子，我都會使用 [git][1] 來做版本控制，雖然公司只有用 svn 控管，但是只要網路掛掉，就不能做任何事情了，更不用說 svn Server 掛點，因為 git 開 branch 免錢，因此每當我拿到新案子就按照 [Git 版本控制 branch model 分支模組基本介紹][2] 開了固定幾個 branch，由於剛開始 git init 沒有把 .gitignore 寫好，所以 commit 了一堆 \*.o 或者是 \*.ko 類似的檔案，我用了 git rm --cached 方式砍了，結果在切換 branch 的時候出現底下錯誤訊息: 

> error: Untracked working tree file 'XXXXXXXX' would be overwritten by merge. 這是因為當你 [git rm --cached][3] 檔案之後，切換 branch 時候會遇到衝突，本來的 master 分支還是存在這些檔案阿，因此這時候就要靠 [git clean][4] 來清掉移除檔案，可以利用 git help clean 來查看使用手冊。 Ref: [Force git to overwrite local files on pull.][5]

 [1]: http://git-scm.com/
 [2]: http://blog.wu-boy.com/2011/03/git-%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6-branch-model-%E5%88%86%E6%94%AF%E6%A8%A1%E7%B5%84%E5%9F%BA%E6%9C%AC%E4%BB%8B%E7%B4%B9/
 [3]: http://www.kernel.org/pub/software/scm/git/docs/git-rm.html
 [4]: http://www.kernel.org/pub/software/scm/git/docs/git-clean.html
 [5]: http://stackoverflow.com/questions/1125968/force-git-to-overwrite-local-files-on-pull