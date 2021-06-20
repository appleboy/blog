---
title: "用 docker-compose 優雅關閉服務"
date: 2021-06-20T10:28:17+08:00
author: appleboy
type: post
url: /2021/06/graceful-stop-service-using-docker-compose-in-golang/
share_img: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
categories:
  - Golang
  - Docker
tags:
  - golang
  - graceful shutdown
  - graceful stop
  - docker
  - docker-compose
---

![logo](https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080)

之前已經有寫過幾篇關於 Graceful Shutdown 教學文章，大家有興趣可以先閱讀底下教學連結資訊，而本篇最主要是紀錄在如何用 docker 指令優雅關閉容器服務，尤其是關閉服務後，可以讓原本服務內的工作可以正常做完，才正式關閉。在本文開始前，先將 [docker][4] 及 [docker-compose][3] 版本資訊貼出來，避免有資訊的落差，畢竟 docker-compose 在不同版本之間有不同的設定方式。

* [[Go 教學] graceful shutdown 搭配 docker-compose 實現 rolling update][2]
* [[Go 教學] graceful shutdown with multiple workers][1]

[1]:https://blog.wu-boy.com/2020/02/graceful-shutdown-with-multiple-workers/
[2]:https://blog.wu-boy.com/2020/02/graceful-shutdown-using-docker-compose-with-rolling-update/
[3]:https://docs.docker.com/compose/compose-file/
[4]:https://www.docker.com/

<!--more-->

## 影片視頻

之後會把影片視頻放到底下 Udemy 課程內

* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)
* [Docker 容器實戰](https://blog.wu-boy.com/docker-course/)

## 環境資訊

目前跑在 [Mac M1 晶片][11]系統，底下是 docker 版本:

```bash
$ docker version
Client:
 Cloud integration: 1.0.17
 Version:           20.10.7
 API version:       1.41
 Go version:        go1.16.4
 Git commit:        f0df350
 Built:             Wed Jun  2 11:56:23 2021
 OS/Arch:           darwin/arm64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.7
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       b0f5bc3
  Built:            Wed Jun  2 11:55:36 2021
  OS/Arch:          linux/arm64
  Experimental:     false
 containerd:
  Version:          1.4.6
  GitCommit:        d71fcd7d8303cbf684402823e425e9dd2e99285d
 runc:
  Version:          1.0.0-rc95
  GitCommit:        b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

接著是 docker-compose 版本資訊

```bash
$ docker-compose version
docker-compose version 1.29.2, build 5becea4c
docker-py version: 5.0.0
CPython version: 3.9.0
OpenSSL version: OpenSSL 1.1.1h  22 Sep 2020
```

[11]:https://zh.wikipedia.org/zh-tw/Apple_M1

## 程式碼範例

先準備好實際應用範例，我們可以跑一個服務專門執行一些需要時間很久的工作，當我們需要更新服務時，就需要讓服務不再接受任何工作，等待的是把原本還在跑的工作做完，才停止服務。底下是 Go 語言的範例。

```go
package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

func withContextFunc(ctx context.Context, f func()) context.Context {
	ctx, cancel := context.WithCancel(ctx)
	go func() {
		c := make(chan os.Signal)
		// register for interupt (Ctrl+C) and SIGTERM (docker)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)
		defer signal.Stop(c)

		select {
		case <-ctx.Done():
		case <-c:
			f()
			cancel()
		}
	}()

	return ctx
}

func main() {
	jobChan := make(chan int, 100)
	stopped := make(chan struct{})
	finished := make(chan struct{})
	wg := &sync.WaitGroup{}
	ctx := withContextFunc(
		context.Background(),
		func() {
			log.Println("stop the server")
			close(stopped)
			wg.Wait()
			close(finished)
		},
	)

	// create 4 workers to process job
	for i := 0; i < 4; i++ {
		go func(i int) {
			log.Printf("start worker: %02d", i)
			for {
				select {
				case <-finished:
					log.Printf("stop worker: %02d", i)
					return
				default:
					select {
					case job := <-jobChan:
						time.Sleep(time.Duration(job*100) * time.Millisecond)
						log.Printf("worker: %02d, process job: %02d", i, job)
						wg.Done()
					default:
						log.Printf("worker: %02d, no job", i)
						time.Sleep(1 * time.Second)
					}
				}
			}
		}(i + 1)
	}

	// send job
	go func() {
		for i := 0; i < 50; i++ {
			wg.Add(1)
			select {
			case jobChan <- i:
				time.Sleep(100 * time.Millisecond)
				log.Printf("send the job: %02d\n", i)
			case <-stopped:
				wg.Done()
				log.Println("stoped send the job")
				return
			}
		}
		return
	}()

	select {
	case <-ctx.Done():
		time.Sleep(1 * time.Second)
		log.Println("server down")
	}
}
```

上面例子可以看到，先建立四個 worker 用來接受工作執行內容，另外最後的 Goroutine 用來產生工作。另外給兩個 channel 用來停止 worker 及停止產生 Job。當程式正在進行時，直接按下 `ctrl + c` 會觸發關閉 `stopped`，這時候就會停止送 Job 進去 `jobChan` 內，而等到四個 worker 把剩下的工作都執行結束後，就會關閉 `finished`，這時會把四個 worker 正式停止。接著來看看，用 docker-compose 指令來停止服務。

## 使用 docker-compose 指令

要將服務重啟，可以先透過 `docker-compose stop` 來關閉服務，如果服務內沒有去處理 Signal 的話，此服務就會被直接停止，那正在跑的 Job 就會直接被砍掉，這行為顯然不是大家想要的，所以在寫程式務必處理 Signal 信號，而當執行 docker-compose stop 後，docker 會發送 `SIGTERM` 信號到容器內 (容器內 root process `PID 為 1`)，服務接到此信號後，可以做後續的處理，但是你會發現 `10 秒`後，docker 又會送出另一個訊號 `SIGKILL` 去強制關閉服務，要解決這問題其實很簡單，通常會大概知道每個工作需要花費多少時間，而四個 worker 跑全部跑滿工作，最後會花費多少時間，這時候可以加上 `-t` 來決定幾秒後發送 `SIGKILL` 信號。

```bash
$ docker-compose stop -h
Stop running containers without removing them.

They can be started again with `docker-compose start`.

Usage: stop [options] [--] [SERVICE...]

Options:
  -t, --timeout TIMEOUT      Specify a shutdown timeout in seconds.
                             (default: 10)
```

像是執行底下

```bash
docker-stop -t 600 app
```

## docker-compose 設定

由於 `docker-compose stop` 預設會優先發送 `SIGTERM` 信號，如果想用其他信號來取代的話，可以直接在 docker-compose.yml 增加 `stop_signal` 來決定新的信號，除了此之外，也可以設定 `stop_grace_period` 來決定多少時間後 docker 才發送 `SIGKILL`，預設會是 10 秒，都可以透過上述方式調整

```yml
version: "3.9"

services:
  app:
    image: app:0.0.1
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    stop_signal: SIGINT
    stop_grace_period: 30s
    logging:
      options:
        max-size: "100k"
        max-file: "3"
```

詳細說明可以參考 [stop_signal][21] 及 [stop_grace_period][22]。完成這兩項設定後，也可以正常使用 docker-compose up -d 來重新啟動容器服務。

[21]:https://docs.docker.com/compose/compose-file/compose-file-v3/#stop_signal
[22]:https://docs.docker.com/compose/compose-file/compose-file-v3/#stop_grace_period

## docker 信號處理

從上面可以知道，每個服務都需要處理 docker 傳來的信號，而在寫 dockerfile 該注意哪些事情？底下拿 Go 語言搭配 Dockerfile 來當例子:

```dockerfile
FROM golang:1.16-alpine

COPY main.go /app/
COPY go.mod /app/

WORKDIR "/app"

CMD ["go", "run", "main.go"]
```

接著編譯在執行

```bash
docker-compose build
docker-compose up app
```

啟動完成後，你會發現當下 stop 指令後，容器內完全收不到此信號，這時候直接進到容器裡面查看，透過 `ps` 指令

```bash
/app # ps
PID   USER     TIME  COMMAND
    1 root      0:00 go run main.go
   68 root      0:03 /tmp/go-build4218998070/b001/exe/main
   78 root      0:00 /bin/sh
   84 root      0:00 ps
```

會發現送 `SIGTERM` 信號到 PID 1，而真正執行的 Process ID 為 68，所以一直會收不到信號的原因就在這邊。這裡解決方式也很簡單，就是不要透過 `go run` 方式來執行，而是要先 build 成執行檔後在使用。

```dockerfile
FROM golang:1.16-alpine

COPY main.go /app/
COPY go.mod /app/
RUN go build -o /app/main /app/main.go

WORKDIR "/app"

CMD ["/app/main"]
```

另外如果在 `CMD` 或 `ENTRYPOINT` 請用 `["program", "arg1", "arg2"]` 方式，而不是 `program arg1 arg2`，後者對於 docker 來說會再包一層 bash 在前面，但是 bash 基本上沒有處理 Signal 訊號，這樣也會造成無法正常關閉服務。

如果想要從 bash 處理 Signal 訊號，可以參考此篇文章『[Trapping signals in Docker containers](https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86)』。

## 後記心得

除了 Docker 信號處理之外，還需要透過 `docker-compose up --scale` 方式來完成服務擴展。如果服務是需要處理大量工作，工作時間長久，就需要透過此方式來更新服務，不然工作突然被中斷，要怎麼恢復工作又是另一個議題需要解決。

## 參考文章

* [Trapping signals in Docker containers][31]
* [Docker Frequently asked questions][32]
* [Compose file version 3 reference][33]
* [Gracefully Stopping Docker Containers][34]
* [Can't trap SIGINT in Docker container][35]

[31]:https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86
[32]:https://docs.docker.com/compose/faq/
[33]:https://docs.docker.com/compose/compose-file/compose-file-v3/
[34]:https://www.ctl.io/developers/blog/post/gracefully-stopping-docker-containers/
[35]:https://stackoverflow.com/questions/45407283/cant-trap-sigint-in-docker-container
