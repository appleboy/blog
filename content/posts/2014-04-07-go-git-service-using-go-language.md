---
title: 用 Go 語言寫的 Github Git 服務
author: appleboy
type: post
date: 2014-04-07T07:22:36+00:00
url: /2014/04/go-git-service-using-go-language/
dsq_thread_id:
  - 2592564167
categories:
  - Git
  - Golang
tags:
  - git
  - Github
  - GitLab
  - Go

---
<img src="https://i1.wp.com/farm4.staticflickr.com/3762/13686798143_dd15f54076_o.png?w=840&#038;ssl=1" alt="null" data-recalc-dims="1" /> 

最近看到大陸那邊用 [Go][1] 語言寫了一套類似 [Github][2] 服務叫做 [Gogs][3](Go Git Service)，目前個人裝起來速度方面相當快，跟 [GitLab][4] 用 [Ruby][5] 寫的 Git Service 速度有差，以功能完整性來說，GitLab 還是大勝 Gogs，安裝方式則是 Gogs 勝於 GitLab，如果最後要推薦用 Gogs 還是 GitLab，我個人還是會選 GitLab 因為畢竟還是要搭配 [Jenkins][6] 等 CI 服務才能發揮作用，這次來筆記如何在 Ubuntu 上安裝 Gogs。

<!--more-->

### 安裝 Go 環境

如果用 [Ubuntu][7] / [Debian][8] 系列，請不要透過 apt 方式安裝，因為安裝完成的 Go 版本會非常舊，請使用 tarball 方式安裝，首先到[官方網站][9]下載最新檔案

```bash
$ wget https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz
$ export PATH=$PATH:/usr/local/go/bin
```

也可以把 `$PATH` 寫到 `.bashrc` 檔案內，這樣下次開 Shell 就不用重新打一次，接著下 `go version` 看到底下結果表示安裝成功

```bash
$ go version
go version go1.2.1 linux/amd64
```

最後將 `$GOROOT` 及 `$GOPATH` 設定上去

```bash
$ export GOROOT=/usr/local/go
$ export PATH=$PATH:$GOROOT/bin
$ export GOPATH=/home/git/gocode
```

### 安裝 Gogs service

安裝非常容易，只要透過底下兩個指令就安裝完成了

```bash
# Download and install dependencies
$ go get -u github.com/gogits/gogs

# Build main program
$ cd $GOPATH/src/github.com/gogits/gogs
$ go build
```

原始目錄會在 `/home/git/gocode/src/github.com/gogits/gogs` 接著可以看到 `conf/app.ini` 原始設定檔，官方建議不要修改此檔案，使用者可以自行建立 `custom/conf/app.ini` 來取代原始設定內容。最後執行 `./gogs web`

```bash
$ ./gogs web
Server is running...
2014/04/07 15:19:07 [conf.go:309] <em></em> Log Mode: Console(Trace)
2014/04/07 15:19:07 [conf.go:310] <em></em> Cache Service Enabled
2014/04/07 15:19:07 [conf.go:311] <em></em> Session Service Enabled
2014/04/07 15:19:07 [install.go:53] <em></em> Run Mode: Development
2014/04/07 15:19:07 [command.go:73] <em></em> Gogs: Go Git Service 0.2.0.0403 Alpha
2014/04/07 15:19:07 [command.go:73] <em></em> Listen: :3001
```

打開 http://localhost:3001 就可以看到下面畫面，代表安裝成功

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/13687422635" title="Install - Gogs  Go Git Service by Bo-Yi Wu, on Flickr"><img src="https://i2.wp.com/farm6.staticflickr.com/5220/13687422635_2929b43faf_z.jpg?resize=640%2C579&#038;ssl=1" alt="Install - Gogs  Go Git Service" data-recalc-dims="1" /></a>

 [1]: http://golang.org/
 [2]: https://github.com/
 [3]: https://github.com/gogits/gogs
 [4]: http://gitlab.org
 [5]: https://www.ruby-lang.org/en/
 [6]: http://jenkins-ci.org/
 [7]: http://www.ubuntu.com/
 [8]: http://www.debian.org/
 [9]: https://code.google.com/p/go/downloads/list?q=OpSys-FreeBSD+OR+OpSys-Linux+OR+OpSys-OSX+Type-Archive