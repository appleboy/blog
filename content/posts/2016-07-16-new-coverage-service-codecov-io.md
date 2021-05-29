---
title: 新的 code coverage 線上服務 codecov.io
author: appleboy
type: post
date: 2016-07-16T07:50:29+00:00
url: /2016/07/new-coverage-service-codecov-io/
dsq_thread_id:
  - 4989702663
categories:
  - DevOps
  - Golang
tags:
  - devops
  - Github
  - golang
  - Travis CI

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/28259851031/in/dateposted-public/" title="Screen Shot 2016-07-16 at 3.04.50 PM"><img src="https://i1.wp.com/c8.staticflickr.com/9/8684/28259851031_de845f4e56_z.jpg?resize=640%2C355&#038;ssl=1" alt="Screen Shot 2016-07-16 at 3.04.50 PM" data-recalc-dims="1" /></a>

代碼覆蓋率 (code coverage) 是開發流程蠻重要的一環，用來評估專案內測試的覆蓋率，也代表了自己寫的程式，至少要測試過一次。在 [Github][1] 上面最常用的一套就是 [Coveralls][2] 相信大家對於此服務並不陌生，一個好的 Open Source 專案一定會在 Readme 上附上 Coveralls badge，證明自己寫的專案都有經過測試，請安心使用。在導入 Coveralls 服務到專案內時，安裝步驟有點小複雜，雖然不難，但是還是需要安裝一些 Tool 才能完成，底下用 [Golang][3] 為例。

<!--more-->

### Coveralls.io

Coveralls 會先給一把 Token，你要將 Token 加密到 [Travis][4] 設定檔，或者是直接將明碼寫到 `.travis.yml` 檔案內，如果我們要的是前者，就必須在個人電腦裝上 `travis` 指令

<pre><code class="language-bash">$ gem install travis</code></pre>

使用 [gem][5] 指令之前，請先把 [Ruby][6] 環境安裝好，看到這裡是不是覺得很麻煩了。完成後，透過底下指令將 Token 加密到 config 內

<pre><code class="language-bash">$ travis encrypt COVERALLS_TOKEN=xxxxx--add env.global</code></pre>

就可以到 `.travis.yml` 看到

<pre><code class="language-bash">env:
  global:
    secure: jeSgPztK8ytfBEBlZiswBIjXd1dafxxxx</code></pre>

還沒結束，你要將 golang coverage report file 送到 Coveralls Server 前，還要安裝 [goveralls][7] 工具來完成此任務

<pre><code class="language-bash">install:
  - export GO15VENDOREXPERIMENT=1
  - glide install
  - go get golang.org/x/tools/cmd/cover
  - go get github.com/mattn/goveralls</code></pre>

上面的最後一行是必須的喔。最後執行測試後才將結果傳到 server

<pre><code class="language-bash">script:
  - make test
  - go test -v -covermode=count -coverprofile=coverage.out
  - $(go env GOPATH | awk 'BEGIN{FS=":"} {print $1}')/bin/goveralls -coverprofile=coverage.out -service=travis-ci -repotoken=$COVERALLS_TOKEN</code></pre>

### Codecov.io

這是最近在 Github 其他專案看到的新的服務，[Codecov][8] 服務優於 Coveralls 的地方在安裝容易，加上 code coverage 介面比較漂亮，所以目前將新的 open source 專案都換到 Codecov 了，底下先來講安裝方式，安裝方式真的太無腦了，只要先透過 Github 登入到 Codecov，並且將自己的專案加入，就可以看到底下畫面

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/28304633406/in/dateposted-public/" title="Screen Shot 2016-07-16 at 3.07.35 PM"><img src="https://i0.wp.com/c7.staticflickr.com/9/8851/28304633406_c480a885a6_z.jpg?resize=640%2C476&#038;ssl=1" alt="Screen Shot 2016-07-16 at 3.07.35 PM" data-recalc-dims="1" /></a>

有看到安裝方式嗎？就只有一行

<pre><code class="language-bash">script:
  - go test -v -covermode=count -coverprofile=coverage.out

after_success:
  - bash <(curl -s https://codecov.io/bash)</code></pre>

只要你是 open source 專案，根本不需要 token，Codecov 會自動分析 golang 編譯出來的 report。在 Dashboard 你會發現這句話

> Not required on Travis-CI, CircleCI or AppVeyor for public repositories.

只要你是用 Travis 就可以無腦安裝啦。當然也可以自訂選擇 CI Provider。另外如果是 Pull Request，可以發現 Codecov 給的 Report 比 Coveralls 好多了，請直接看此 [PR][9]

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/28259968161/in/dateposted-public/" title="Screen Shot 2016-07-16 at 3.15.44 PM"><img src="https://i0.wp.com/c2.staticflickr.com/9/8883/28259968161_0cd8aeff22_z.jpg?resize=640%2C528&#038;ssl=1" alt="Screen Shot 2016-07-16 at 3.15.44 PM" data-recalc-dims="1" /></a>

最後請裝上 Codecov 提供的[瀏覽器外掛][10]，這樣可以直接在 Github 專案原始碼內直接看到 code coverage 數據，請直接看[範例][11]

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/27722680164/in/dateposted-public/" title="Screen Shot 2016-07-16 at 3.43.35 PM"><img src="https://i1.wp.com/c5.staticflickr.com/8/7663/27722680164_7eaab11e62_z.jpg?resize=640%2C451&#038;ssl=1" alt="Screen Shot 2016-07-16 at 3.43.35 PM" data-recalc-dims="1" /></a>

就介紹到這邊，大家快去[註冊][8]使用吧

 [1]: https://github.com
 [2]: https://coveralls.io/
 [3]: https://golang.org/
 [4]: https://travis-ci.org
 [5]: https://rubygems.org/
 [6]: https://www.ruby-lang.org/en/
 [7]: https://github.com/mattn/goveralls
 [8]: https://Codecov.io/
 [9]: https://github.com/appleboy/gin-jwt/pull/38
 [10]: https://github.com/codecov/browser-extension
 [11]: https://github.com/appleboy/go-hello/blob/master/hello-world.go