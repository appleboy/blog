---
title: 轉移 Github 上的 Private Repository 到 BitBucket …
author: appleboy
type: post
date: 2011-10-17T06:45:49+00:00
url: /2011/10/transfer-github-private-repository-to-bitbucket/
dsq_thread_id:
  - 445582078
categories:
  - Bitbucket
  - Git
  - 版本控制
tags:
  - Bitbucket
  - git
  - Github

---
<div style="margin:auto 0; text-align: center;">
  <a href="https://www.flickr.com/photos/appleboy/6209323485/" title="Bitbucket by appleboy46, on Flickr"><img src="https://i1.wp.com/farm7.static.flickr.com/6161/6209323485_9ffbcb2911_o.png?resize=256%2C256&#038;ssl=1" alt="Bitbucket" data-recalc-dims="1" /></a>
</div> 看到 

<a href="http://blog.gslin.org/" target="_blank">gslin 大神</a>寫了一篇 <a href="http://blog.gslin.org/archives/2011/10/10/2750/%e6%8a%8a-github-%e4%b8%8a%e7%9a%84-private-repository-%e6%90%ac%e5%88%b0-bitbucket-%e4%b8%8a/" target="_blank">把 GitHub 上的 private repository 搬到 BitBucket 上…</a>，最近自己也把一些不能公開的專案轉到 <a href="https://bitbucket.org/" target="_blank">BitBucket</a> 上面，由於在 BitBucket 上面可以無限開 private repository，所以我想也沒有必要付費給 <a href="https://github.com/" target="_blank">Github</a>，雖然論 Web 功能上而言，Github 還是略勝一籌，個人還是比較習慣 github 有 Network 的圖形可以看，不過平常還是都是在打指令，所以也沒差了，在 push 速度上面，感覺 BitBucket 也沒有輸 github 許多，所以決定就轉過去了，人總是為了錢所考量，當然 BitBucket 還是有些缺點的，可以參考之前寫的 <a href="http://blog.wu-boy.com/2011/10/bitbucket-support-git-repository-now/" target="_blank">Bitbucket 開始支援 Git Repository</a> <!--more--> 底下介紹兩種方式來轉移 Github 的 Repo 到 BitBucket: 

### 透過 BitBucket 提供的 tool 只要把 github 上的 Repository 網址複製下來，透過 

<a href="https://bitbucket.org/repo/import" target="_blank">BitBucket import tool</a> 介面來轉換就可以了，這方法比較簡單懶人，如果你熟悉 git 的操作，就可以透過第二種方法來弄。 

### 透過 git push 先在 BitBucket 建立一個空的 private repo，之後把網址複製，打開原本 clone 下來的專案 

**<span style="color:green">.git/config</span>**，將 url 換成剛剛建立的 repo url 即可。接著打入底下指令去 push 即可。 

<pre class="brush: bash; title: ; notranslate" title="">$ git push origin master</pre> 當然如果你有很多 branch 的話，請重複上面步驟即可。