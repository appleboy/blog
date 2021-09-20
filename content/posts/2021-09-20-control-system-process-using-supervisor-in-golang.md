---
title: "用 Supervisor 管理系統程式"
date: 2021-09-20T18:55:22+08:00
author: appleboy
type: post
url: /2021/09/control-system-process-using-supervisor-in-golang
share_img: https://i.imgur.com/4uBJZAG.png
categories:
  - Golang
  - Linux
tags:
  - supervisor
  - golang
  - python
---

![cover](https://i.imgur.com/4uBJZAG.png)

相信大家都有管理 Linux 主機 Process 的經驗，用的工具也是千奇百種，但是肯定對 [Python][2] 版本的 [Supervisor][1] 並不陌生，這套工具相當好用，可以監控不同的 Process 狀態，也可以自動重啟。而本篇要介紹用 [Go 語言][3]寫出來的開源套件『[Supervisord][4]』，作者提到為什麼要用 Go 語言開發此工具，原因很簡單，就是透過 Go 語言的跨平台優勢，寫一套程式，可以直接在任何平台上跑，管理者就不需要再為了 Python 環境而煩惱。

[1]:http://supervisord.org/
[2]:https://www.python.org/
[3]:http://golang.org/
[4]:https://github.com/ochinchina/supervisord

<!--more-->

## 教學影片

{{< youtube bN0iEd4z_7Q >}}

影片視頻會同步放到底下課程內

* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

## 使用情境

現在已經 2021 年了，很多工具或服務都已經透過 Docker 方式來管理，需要的工具不再是 Supervisor，但是 Supervisor 還是有其必要的存在原因，我們團隊就出現幾個狀況需要用到此工具。

1. 在 Container 內管理多個 Process
2. 沒有 Docker 環境

第一點就是如果在 Container 內管理 Process，想看看先把 Python 環境安裝完成，整個容器會變得非常肥，這就是大家需要考慮的狀況。第二種狀況，像我們團隊有一個環境是完全沒有網路，也禁止用 Docker，因為 Docker 會讓 IT 很難管理其他同仁的使用方式，造成一些權限上的錯誤，故被禁止使用 Docker，這時候開發者要管理多個服務時，有 Go 語言版本的 Supervisor 對 SRE 團隊幫助極大，不需要在考慮 Python 版本的因素。

## 安裝方式

可以到 [Release 頁面][11]下載相對應 OS 版本，或者你是 GO 開發者可以自行編譯

```sh
go generate
GOOS=linux go build -tags release -a -ldflags "-linkmode external -extldflags -static" -o supervisord
```

再將 `supervisord` 放到 `/usr/local/bin` 目錄即可。執行檔預設會讀取 `supervisor.conf` 設定檔案，此檔案可以透過 `-c` 或者是自動讀取底下目錄內的檔案

1. $CWD/supervisord.conf
2. $CWD/etc/supervisord.conf
3. /etc/supervisord.conf
4. /etc/supervisor/supervisord.conf (since Supervisor 3.3.0)
5. ../etc/supervisord.conf (Relative to the executable)
6. ../supervisord.conf (Relative to the executable)

[11]:https://github.com/ochinchina/supervisord/releases

## 使用方式

建立或打開 `supervisor.conf` 檔案

```ini
[supervisord]
logfile=%(here)s/supervisord.log
logfileMaxbytes=50MB
logfileBackups=10
loglevel=debug
pidfile=%(here)s/supervisord.pid

[inet_http_server]
port = :9001
username=
password=
```

其中 inet_http_server 是一個簡易的管理介面，用來看到設定好的 Process 狀態，Web 介面很陽春如下:

![cover](https://i.imgur.com/4uBJZAG.png)

可以透過 Web 介面啟動或暫停 Process，此頁面也可以透過 `username` 及 `password` 保護。接著看 Process 如何設定:

```ini
[program:tip-agent]
directory = /xxxxxxxx/tip/agent
command = ./bin/agent
process_name = tip-agent
stdout_logfile = test.log, /dev/stdout
stderr_logfile = test.log, /dev/stderr
restart_when_binary_changed = true
autostart=true
startsecs=3
startretries=3
autorestart=true
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
stopasgroup=true
killasgroup=true
```

字面上的意思就不用再多說明了，這邊要注意的是 `stopsignal` 設定，如果沒有設定此項目，Process 有處理 Graceful Shutdown 的話，那這樣程式不會如你預期的結束，故這項目一定要加上去。除了 Web 介面外，還可以用 CLI 看到所有 Process 狀態

```sh
supervisord ctl status
```

![cover](https://i.imgur.com/nNsaeR0.jpg)

Supervisord 還有整合了 Prometheus 監控，SRE 可以透過 `http://localhost:9001/metrics` 來取得底下相關監控數據。

```sh
# HELP node_supervisord_exit_status Process Exit Status
# TYPE node_supervisord_exit_status gauge
node_supervisord_exit_status{group="tip-agent",name="tip-agent"} 0
node_supervisord_exit_status{group="tip-backend",name="tip-backend"} 0
# HELP node_supervisord_start_time_seconds Process start time
# TYPE node_supervisord_start_time_seconds counter
node_supervisord_start_time_seconds{group="tip-agent",name="tip-agent"} 1.632135574e+09
node_supervisord_start_time_seconds{group="tip-backend",name="tip-backend"} 1.632135593e+09
# HELP node_supervisord_state Process State
# TYPE node_supervisord_state gauge
node_supervisord_state{group="tip-agent",name="tip-agent"} 20
node_supervisord_state{group="tip-backend",name="tip-backend"} 20
# HELP node_supervisord_up Process Up
# TYPE node_supervisord_up gauge
node_supervisord_up{group="tip-agent",name="tip-agent"} 1
node_supervisord_up{group="tip-backend",name="tip-backend"} 1
```

最後要在 Docker 內也使用 `Supervisord` 工具的話，可以透過 `COPY` 直接從官方 Image 把 binary 複製過去即可。

```sh
FROM debian:latest
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord
CMD ["/usr/local/bin/supervisord"]
```

## 心得感想

目前整個生態都趨向於容器化，但是這種舊有的管理方式，還是存在各種不同的情境，有了 Go 語言版本，大大降低團隊處理環境的時間，蠻推薦大家使用 Go 版本來整合 Container 內部，或是在非 Docker 環境下的管理。
