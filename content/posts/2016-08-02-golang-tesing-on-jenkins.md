---
title: 在 Jenkins 跑 Golang 測試
author: appleboy
type: post
date: 2016-08-02T03:24:21+00:00
url: /2016/08/golang-tesing-on-jenkins/
dsq_thread_id:
  - 5032854650
categories:
  - DevOps
  - Golang
  - Testing
tags:
  - devops
  - golang
  - Jenkins

---
[![][1]][1]

本篇會紀錄如何在 [Jenkins][2] 測試 [Golang][3] 專案，直接拿 [go-hello][4] 當作本篇範例。

<!--more-->

## 安裝 Jenkins

請直接參考[官網 Wiki 安裝方式][5]，完成後可以發現預設跑在 `8080` port，搭配 Nginx 設定就可以跑在 `80` port。

<pre><code class="language-bash">server {

  listen 80;
  server_name your_host_name;

  location / {

    proxy_set_header        Host $host;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;

    # Fix the "It appears that your reverse proxy set up is broken" error.
    proxy_pass          http://127.0.0.1:8081;
    proxy_read_timeout  90;
  }
}</code></pre>

## 安裝 Golang Plugin

請先到 Manage Jenkins > Manage Plugins > Available 找到 [Go Plugin][6]，安裝後，請到 `Global Tool Configuration` 內把要測試的版本安裝到 Jenkins 內

<img src="https://i0.wp.com/c8.staticflickr.com/9/8768/28095772703_81a4ae9f6e_z.jpg?w=840&#038;ssl=1" alt="golang" data-recalc-dims="1" /> 

## 設定 Jenkins 專案

要跑 golang 測試非常簡單，只需要兩個指令就可以測試

<pre><code class="language-bash">$ go get -t -d -v ./...
$ go test -v -cover ./...</code></pre>

設定完成後，跑測試，會出現底下錯誤訊息

> package github.com/gin-gonic/gin: cannot download, $GOPATH not set. For more details see: go help gopath

可以發現 jenkins 預設不會將 `$GOPATH` 設定好，所以必須手動將 `$GOPATH` 相關目錄設定完成，請不要將 `$WORKSPACE` 設定成 `$GOPATH`，因為 `$WORKSPACE` 目錄底下包含 `src`, `pkg`, `bin` 三大目錄，請將底下 Script 設定到專案內

<pre><code class="language-bash">export GOPATH=$WORKSPACE/gopath
export PATH=$GOPATH/bin:$PATH
mkdir -p $GOPATH/bin
mkdir -p $GOPATH/src/github.com/appleboy/go-hello
rsync -az --exclude="gopath" ${WORKSPACE}/ $GOPATH/src/github.com/appleboy/go-hello
cd $GOPATH/src/github.com/appleboy/go-hello</code></pre>

附上設定圖檔

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/28705269116/in/dateposted-public/" title="Screen Shot 2016-08-03 at 3.27.50 PM"><img src="https://i2.wp.com/c5.staticflickr.com/9/8857/28705269116_fb5357d85f_z.jpg?resize=640%2C258&#038;ssl=1" alt="Screen Shot 2016-08-03 at 3.27.50 PM" data-recalc-dims="1" /></a>

從上面可以發現，我們手動建立了 `gopath` 目錄來指定為 `$GOPATH`，並且將專案的目錄都設定好後，把 `$WORKSPACE` 內所有檔案透過 `rsync` 方式丟到 `$GOPATH` 內，這樣就可以進行測試了。`export` 可以用 [EnvInject Plugin][7] 取代。

## 結論

很多人會問為什麼 `$GOPATH` 是指定在 `$WORKSPACE/gopath` 而不是 `$GOROOT/gopath`，如果採用後者的話，這樣多個專案使用不同版本的第三方套件就會出問題，而且共用目錄會造成蠻多額外問題，也無法在測試後完整刪除相關目錄。將 `$GOPATH` 設定在專案內就可以透過 [Workspace Cleanup Plugin][8] 直接清除，讓每次測試環境都是非常乾淨。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://jenkins.io/
 [3]: https://golang.org/
 [4]: https://github.com/appleboy/go-hello
 [5]: https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins
 [6]: https://wiki.jenkins-ci.org/display/JENKINS/Go+Plugin
 [7]: https://wiki.jenkins-ci.org/display/JENKINS/EnvInject+Plugin
 [8]: https://wiki.jenkins-ci.org/display/JENKINS/Workspace+Cleanup+Plugin