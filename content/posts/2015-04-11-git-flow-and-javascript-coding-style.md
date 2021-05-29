---
title: Git Flow and JavaScript Coding Style
author: appleboy
type: post
date: 2015-04-11T15:05:34+00:00
url: /2015/04/git-flow-and-javascript-coding-style/
dsq_thread_id:
  - 3673079881
categories:
  - Git
  - javascript
  - NodeJS
  - 版本控制
tags:
  - Code Style
  - git
  - git merge
  - git rebase
  - javascript

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/13158675193/" title="github-logo by appleboy46, on Flickr"><img src="https://i0.wp.com/farm3.staticflickr.com/2238/13158675193_2892abac95_n.jpg?resize=320%2C127&#038;ssl=1" alt="github-logo" data-recalc-dims="1" /></a>
</div>

[Git][1] 已經是每日必備使用的指令，在平常工作上常常使用到 [git rebase][2] 或 [git merge][3]，發現很多工程師不知道什麼時候該用 rebase 什麼時候該用 merge，所以做了底下投影片來清楚描述 git rebase 及 merge 的優缺點及使用時機。

<!--more-->

<div style="margin-bottom:5px">
  <strong> <a href="//www.slideshare.net/appleboy/git-flow-and-javascript-coding-style" title="Git Flow and JavaScript Coding Style" target="_blank">Git Flow and JavaScript Coding Style</a> </strong> from <strong><a href="//www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div>

此投影片最主要的目的是要讓工程師善用 git rebase 而不是濫用 git merge，無意義的 merge 會讓整個分支線看起來非常亂，以我在 [github][4] 跟其他 open source project 上面 review 看到的問題，只要是 PR 內有任何衝突，一律會請開發者 rebase 主分支，並進行 squash commit，所以對我而言，開發新功能或解 bug 會用到的都是 git rebase，幾乎很少的情況會使用到 git merge。附上兩個比較的線圖，清爽度看起來就是有所不同。

### git merge

[<img src="https://i1.wp.com/farm8.staticflickr.com/7701/17109153255_923d0aca3d_z.jpg?resize=640%2C536&#038;ssl=1" alt="git_merge" data-recalc-dims="1" />][5]

### git rebase

[<img src="https://i0.wp.com/farm9.staticflickr.com/8795/16921360628_1f8ecea623_z.jpg?resize=640%2C628&#038;ssl=1" alt="git_rebase" data-recalc-dims="1" />][6]

如上圖比較發現如果自行開發的 branch 常用 git merge 方式合併主分支，就會多出很多無意義的分支。投影片最後討論到 JavaScript Coding Style 問題，相信在團隊合作之間，務必要制定 Coding Style 規範，透過 [JSCS][7] 來制定，而常用的 JSCS Rule 可以在 [node-jscs][8] 找到像是 [Google][9] [jQuery][10] [Grunt][11] [Airbnb][12] .. 等規範，而我個人比較推崇 [Airbnb JavaScript Style Guide][13]，因為新進人員可以快速看完整個 Style Guide 文件，非常完整，團隊可以不用再額外寫任何範例，只要針對文件增加或減少條件即可。

 [1]: http://git-scm.com/
 [2]: http://git-scm.com/docs/git-rebase
 [3]: http://git-scm.com/docs/git-merge
 [4]: https://github.com
 [5]: https://www.flickr.com/photos/appleboy/17109153255 "git_merge by Bo-Yi Wu, on Flickr"
 [6]: https://www.flickr.com/photos/appleboy/16921360628 "git_rebase by Bo-Yi Wu, on Flickr"
 [7]: http://jscs.info/
 [8]: https://github.com/jscs-dev/node-jscs/tree/master/presets
 [9]: https://github.com/jscs-dev/node-jscs/blob/master/presets/google.json
 [10]: https://github.com/jscs-dev/node-jscs/blob/master/presets/jquery.json
 [11]: https://github.com/jscs-dev/node-jscs/blob/master/presets/grunt.json
 [12]: https://github.com/jscs-dev/node-jscs/blob/master/presets/airbnb.json
 [13]: https://github.com/airbnb/javascript