---
title: Git Flow 與團隊合作
author: appleboy
type: post
date: 2016-04-28T02:30:06+00:00
url: /2016/04/git-flow-tips/
dsq_thread_id:
  - 4782748539
categories:
  - Git
  - 版本控制
tags:
  - git
  - git branch
  - git merge
  - git rebase
  - Github

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/26620468361/in/dateposted-public/" title="branching-illustration@2x"><img src="https://i2.wp.com/farm2.staticflickr.com/1584/26620468361_7fe972425a_z.jpg?resize=640%2C413&#038;ssl=1" alt="branching-illustration@2x" data-recalc-dims="1" /></a>

本月最後一篇投影片來介紹 [Git][1] Flow 流程該如何導入團隊，之前寫過一篇 [Git branch model][2] 文章，裡面提到該如何正確使用 branch，但是現在回想起來要導入團隊內真的是有點麻煩，也遇到蠻多問題的，後來最後只採用 [Github Flow][3]，簡單又容易理解，如果開發者很常在 [Github][4] 活動，相信對於此方法並不會很陌生。

<!--more-->

### 投影片大綱

  * Git Flow 介紹
  * Git rebase vs merge
  * [Git diff 工具][5]
  * Git tips

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/appleboy/git-flow-61442567" title="Git flow 與團隊合作" target="_blank">Git flow 與團隊合作</a> </strong> from <strong><a href="//www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div>

 [1]: https://git-scm.com/
 [2]: https://blog.wu-boy.com/2011/03/git-%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6-branch-model-%E5%88%86%E6%94%AF%E6%A8%A1%E7%B5%84%E5%9F%BA%E6%9C%AC%E4%BB%8B%E7%B4%B9/
 [3]: https://guides.github.com/introduction/flow/
 [4]: https://github.com
 [5]: https://github.com/so-fancy/diff-so-fancy