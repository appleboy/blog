---
title: Gitlab CE + Gitlab CI 打造版本控制及自動測試流程
author: appleboy
type: post
date: 2013-11-01T09:00:33+00:00
url: /2013/11/intergrate-work-flow-with-gitlab/
dsq_thread_id:
  - 1925914450
categories:
  - Bitbucket
  - Git
  - Linux
  - Ubuntu
  - 版本控制
tags:
  - Github
  - GitLab

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/10605193576/" title="gitlab_logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm4.staticflickr.com/3830/10605193576_54b54e4dfc_n.jpg?resize=320%2C206&#038;ssl=1" alt="gitlab_logo" data-recalc-dims="1" /></a>
</div>

Git 版本控制不管在嵌入式或 Web 領域都是很受歡迎的工具，尤其是不會遇到像 svn 搞爛 source tree，然後又要 Google 一堆解法。一般公司入門大概就是買 <a href="https://github.com/" target="_blank">Github</a> 服務，一個月才五美金，可以提供五個 Private Project，當然你也可以不付錢，而去使用 <a href="https://bitbucket.org/" target="_blank">Bitbucket</a>，好處就是無限的 Private Project，唯一的限制就是開發者數量，只能在五個以內，設定超過五個，就不給 push 或 pull 了，完成版本控制後，接著就是專案的自動測試，在 github 上面，推的就是 <a href="https://travis-ci.org/" target="_blank">travis-ci</a>，這也是全部 open source 專案的喜好，你會發現大部分的專案都會放上 <a href="https://github.com/appleboy/backbone-template-engine/blob/master/.travis.yml" target="_blank">.travis.yml</a>，來告訴 travis 需要的測試步驟，測試步驟完成後，就要將 source code deploy 到 Amazone 或其他雲端服務，到這個服務基本上都要收費了，所以<a href="http://blog.wu-boy.com/2013/10/drone-io-with-runy-compass-setup/" target="_blank">上一篇</a>有介紹 <a href="https://drone.io/" target="_blank">Drone.io</a> 服務，可以自動測試加上 Deploy 到遠端機器，不過缺點就是不支援 Private Project，要的話就是要收費。 <!--more--> 所以想要版本控制 -> 自動化測試 -> 發佈程式，這整個流程，其中任何一個流程都有可能收費，加上公司開發的程式，一定不可能是 Public，所以被收費肯定很正常，為了要找到免費的方案，所以自己架設等於是最快的，這邊就推薦 

<a href="http://gitlab.org/" target="_blank">GitLab</a>，這介面跟 Github 還蠻接近的，功能也很完整，大家可以<a href="http://demo.gitlab.com/users/sign_in" target="_blank">試試看</a>，自動化測試部份，就直接用 <a href="http://gitlab.org/gitlab-ci/" target="_blank">GitLab CI</a>，比較不方變得地方就是，自動化測試完成後，不會寄信通知。官方有提到歡迎任何人送 PR Feature。GitLab + CI 架設完成，大概就可以捨棄 Gitlab + travis 或 Drone.io。這是窮人作法，如果有預算的話，還是買線上服務，真的有很棒的 Deploy 及檢測程式碼的服務。