---
title: 在 MAC OS 快速又簡單安裝 Docker 環境 – dlite
author: appleboy
type: post
date: 2016-02-15T08:40:35+00:00
url: /2016/02/the-simplest-way-to-use-docker-on-os-x-dlite/
dsq_thread_id:
  - 4580528409
categories:
  - Docker
  - Golang
  - Mac
tags:
  - dlite
  - Docker
  - Go
  - golang
  - Mac

---
在 [Mac OS X][1] 底下安裝 [Docker][2] 服務不難，只需要到 [Docker Mac 教學網站][3]下載 [Docker Toolbox][4]，就可以使用 `docker-machine`, `docker`, `docker-compose` 等指令操作 Docker 服務。本篇提供另外一種工具，讓 Mac 開發者可以快速使用 Docker 服務，就是這套用 [Go][5] 語言寫的 [dlite][6] 工具。

## 安裝方式

dlite 提供三種方式安裝

  1. 直接下載執行檔案 (推薦) ([下載連結][7])
  2. 直接透過 brew 指令安裝: `brew install dlite`
  3. 開發者模式: `git clone` 專案，然後下 `make dlite` 產生執行檔案

請大家直接使用第一種方式安裝即可。

## 使用方式

安裝 dlite 需要使用到磁碟空間及記憶體，你可以動態指定 memory 使用量，或者是磁碟空間，詳細指令可以透過 `dlite install -h` 觀看

```bash
$ sudo dlite install -h
Usage:
  dlite [OPTIONS] install [install-OPTIONS]

creates an empty disk image, downloads the os, saves configuration and creates a launchd agent

Help Options:
  -h, --help            Show this help message

[install command options]
      -c, --cpus=       number of CPUs to allocate (default: 1)
      -d, --disk=       size of disk in GiB to create (default: 20)
      -m, --memory=     amount of memory in GiB to allocate (default: 2)
      -s, --ssh-key=    path to public ssh key (default: $HOME/.ssh/id_rsa.pub)
      -v, --os-version= version of DhyveOS to install
      -n, --hostname=   hostname to use for vm (default: local.docker)
      -S, --share=      directory to export from NFS (default: /Users)
```

可以看到指令預設會佔用 20GB 的磁碟使用量及 2GB 的記憶體，所以安裝時可以調整成個人需求大小，安裝請用 `root` 使用者

```bash
$ sudo dlite install -d 10
Building disk image: done
Downloading OS: done
Writing configuration: done
Creating launchd agent: done
```

完成後請啟動 dlite 服務

```bash
$ dlite start
```

這邊要提醒執行上述指令後，請大約等 10 ~ 20 秒，再用 `docker ps` 來確認是否有成功，啟動後可以透過 `ssh docker@local.docker` 連到 Docker VM。可以在 `/etc/hosts` 看到

```bash
192.168.64.8 local.docker # added by dlite
```

關閉 VM 服務可以使用 `stop` 指令

```bash
$ dlite stop
```

如果沒有要用 Docker 了，請切換到 root 直接 `uninstall` 即可

```bash
$ sudo dlite uninstall
```

移除後會清空 `/etc/hosts` 內新增的 row，但是沒有清除 `/etc/exports` 內的資料，於是發了 PR 給作者 [remove export command][8]。

## 評語

dlite 安裝起來真的很方便，但是我實際拿了 [go-hello][9] 專案來跑測試，結果 go server 竟然跑不起來，真是蠻神奇的，只是個簡單的 [Hello world server][10]。本來我還以為是不是 Docker 版本有問題，所以又用 [Travis CI][11] 跑了一次結果也沒問題。結論還是要裝官方提供的 Tool Box 比較穩定。

 [1]: http://www.apple.com/tw/osx/
 [2]: https://www.docker.com/
 [3]: https://docs.docker.com/engine/installation/mac/
 [4]: https://www.docker.com/toolbox
 [5]: https://golang.org/
 [6]: https://github.com/nlf/dlite
 [7]: https://github.com/nlf/dlite/releases
 [8]: https://github.com/nlf/dlite/pull/100
 [9]: https://github.com/appleboy/go-hello
 [10]: https://github.com/appleboy/go-hello/blob/master/hello-world.go
 [11]: https://travis-ci.org/