---
title: 如何取得上傳進度條 progress bar 相關數據及實作 Graceful Shutdown
author: appleboy
type: post
date: 2021-05-21T04:52:17+00:00
url: /2021/05/graceful-shutdown-with-progress-bar-in-golang/
share_img: https://lh3.googleusercontent.com/ASkclquxfpPTlJ_QWnhZjB5katrz18NyK4zt2w47UM8gS71MCjWodDoGp50nHRyeQx8MfbJJbwWjfIWCoKbZYLkec7a-FqMEw-r9Lh3U8XGAuwEqWa3DVMB2lkhdgMQUI1IMiKWL5Ss=w1920-h1080
dsq_thread_id:
  - 8537964148
categories:
  - Golang
tags:
  - channel
  - golang
  - graceful shutdown
  - reader

---
![](https://lh3.googleusercontent.com/ASkclquxfpPTlJ_QWnhZjB5katrz18NyK4zt2w47UM8gS71MCjWodDoGp50nHRyeQx8MfbJJbwWjfIWCoKbZYLkec7a-FqMEw-r9Lh3U8XGAuwEqWa3DVMB2lkhdgMQUI1IMiKWL5Ss=w1920-h1080)

由於專案需求，需要開發一套 CLI 工具，讓 User 可以透過 CLI 上傳大檔案來進行 Model Training，請參考上面的流程圖。首先第一步驟會先跟 API Server 驗證使用者，驗證完畢就開始上傳資料到 [AWS S3][3] 或其他 Storage 空間，除了上傳過程需要在 CLI 顯示目前進度，另外也需要將目前上傳的進度 (速度, 進度及剩餘時間) 都上傳到 API Server，最後在 Web UI 介面透過 [GraphQL Subscription][4] 讓使用者可以即時看到上傳進度數據。

而 CLI 上傳進度部分，我們選用了一套開源套件 [cheggaaa/pb][1]，相信有在寫 [Go 語言][2]都並不會陌生。而此套件雖然可以幫助在 Terminal 顯示進度條，但是有些接口是沒有提供的，像是即時速度，上傳進度及剩餘時間。本篇教大家如何實作這些數據，及分享過程會遇到相關問題。

[1]: https://github.com/cheggaaa/pb
[2]: https://golang.org
[3]: https://aws.amazon.com/tw/s3/
[4]: https://www.apollographql.com/docs/react/data/subscriptions/


<!--more-->


## 讀取上傳進度顯示

透過 [cheggaaa/pb][1] 提供的範例如下:

```go
package main

import (
	"crypto/rand"
	"io"
	"io/ioutil"
	"log"

	"github.com/cheggaaa/pb/v3"
)

func main() {

	var limit int64 = 1024 * 1024 * 10000
	// we will copy 10 Gb from /dev/rand to /dev/null
	reader := io.LimitReader(rand.Reader, limit)
	writer := ioutil.Discard

	// start new bar
	bar := pb.Full.Start64(limit)
	// create proxy reader
	barReader := bar.NewProxyReader(reader)
	// copy from proxy reader
	if _, err := io.Copy(writer, barReader); err != nil {
		log.Fatal(err)
	}
	// finish bar
	bar.Finish()
}
```

很清楚可以看到透過 `io.Copy` 方式開始上傳模擬進度。接著需要透過 `goroutine` 方式讀取目前進度並上傳到 API Server。

## 計算上傳進度及剩餘時間

使用 pb v3 版本只有開放幾個 public 資訊，像是起始進度時間，及目前上傳了多少 bits 資料，透過這兩個資料，可以即時算出剩餘時間，目前速度及進度。

```go
package main

import (
	"crypto/rand"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"time"

	"github.com/cheggaaa/pb/v3"
)

func main() {
	var limit int64 = 1024 * 1024 * 10000
	// we will copy 10 Gb from /dev/rand to /dev/null
	reader := io.LimitReader(rand.Reader, limit)
	writer := ioutil.Discard

	// start new bar
	bar := pb.Full.Start64(limit)
	go func(bar *pb.ProgressBar) {
		d := time.NewTicker(2 * time.Second)
		startTime := bar.StartTime()
		// Using for loop
		for {
			// Select statement
			select {
			// Case to print current time
			case <-d.C:
				if !bar.IsStarted() {
					continue
				}
				currentTime := time.Now()
				dur := currentTime.Sub(startTime)
				lastSpeed := float64(bar.Current()) / dur.Seconds()
				remain := float64(bar.Total() - bar.Current())
				remainDur := time.Duration(remain/lastSpeed) * time.Second
				fmt.Println("Progress:", float32(bar.Current())/float32(bar.Total())*100)
				fmt.Println("last speed:", lastSpeed/1024/1024)
				fmt.Println("remain duration:", remainDur)

				// TODO: upload progress and remain duration to api server
			}
		}
	}(bar)
	// create proxy reader
	barReader := bar.NewProxyReader(reader)
	// copy from proxy reader
	if _, err := io.Copy(writer, barReader); err != nil {
		log.Fatal(err)
	}
	// finish bar
	bar.Finish()
}
```

使用 `time.NewTicker` 固定每兩秒計算目前進度資料，並且上傳到 API Server，從上傳資料及使用的時間，可以算出目前 Speed 大概多少，當然這不是很準，原因是從上傳開始到現在時間計算 (總已上傳資料/目前花費時間)。

## 使用 Channel 結束上傳

做完上述這些功能，不難的發現有個問題，這個 goroutine 不會停止，還是會每兩秒去計算進度，這時候需要透過一個 Channel 通知 goroutine 結束。

```go
package main

import (
	"crypto/rand"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"time"

	"github.com/cheggaaa/pb/v3"
)

func main() {
	var limit int64 = 1024 * 1024 * 10000
	// we will copy 10 Gb from /dev/rand to /dev/null
	reader := io.LimitReader(rand.Reader, limit)
	writer := ioutil.Discard

	// start new bar
	bar := pb.Full.Start64(limit)
	finishCh := make(chan struct{})
	go func(bar *pb.ProgressBar) {
		d := time.NewTicker(2 * time.Second)
		startTime := bar.StartTime()
		// Using for loop
		for {
			// Select statement
			select {
			case <-finishCh:
				d.Stop()
				log.Println("finished")
				return
			// Case to print current time
			case <-d.C:
				if !bar.IsStarted() {
					continue
				}
				currentTime := time.Now()
				dur := currentTime.Sub(startTime)
				lastSpeed := float64(bar.Current()) / dur.Seconds()
				remain := float64(bar.Total() - bar.Current())
				remainDur := time.Duration(remain/lastSpeed) * time.Second
				fmt.Println("Progress:", float32(bar.Current())/float32(bar.Total())*100)
				fmt.Println("last speed:", lastSpeed/1024/1024)
				fmt.Println("remain suration:", remainDur)
			}
		}
	}(bar)
	// create proxy reader
	barReader := bar.NewProxyReader(reader)
	// copy from proxy reader
	if _, err := io.Copy(writer, barReader); err != nil {
		log.Fatal(err)
	}
	// finish bar
	bar.Finish()
	close(finishCh)
}
```

先宣告一個 `finishCh := make(chan struct{})`，用來通知 goroutine 跳出迴圈，大家注意看一下，最後是用的是關閉 Channel，如果是用底下方法:

```go
finishCh <- strunct{}{}
```

這時候看看 switch case 有機率是同時到達，造成無法跳脫迴圈，而直接關閉 channel，可以確保 `case <-finishCh` 一直拿到空的資料，進而達成跳出迴圈的需求。

## 整合  Graceful Shutdown

最後來看看如何整合 [Graceful Shutdown][11]。當使用者按下 `ctrl + c` 需要停止上傳，並將狀態改成 `stopped`。底下來看看加上 Graceful Shutdown 的方式:

[11]: https://blog.wu-boy.com/2020/02/what-is-graceful-shutdown-in-golang/

```go
package main

import (
	"context"
	"crypto/rand"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/cheggaaa/pb/v3"
)

func withContextFunc(ctx context.Context, f func()) context.Context {
	ctx, cancel := context.WithCancel(ctx)
	go func() {
		c := make(chan os.Signal, 1)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
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

	ctx := withContextFunc(
		context.Background(),
		func() {
			// clear machine field
			log.Println("interrupt received, terminating process")
		},
	)

	var limit int64 = 1024 * 1024 * 10000
	// we will copy 10 Gb from /dev/rand to /dev/null
	reader := io.LimitReader(rand.Reader, limit)
	writer := ioutil.Discard

	// start new bar
	bar := pb.Full.Start64(limit)
	finishCh := make(chan struct{})
	go func(ctx context.Context, bar *pb.ProgressBar) {
		d := time.NewTicker(2 * time.Second)
		startTime := bar.StartTime()
		// Using for loop
		for {
			// Select statement
			select {
			case <-ctx.Done():
				d.Stop()
				log.Println("interrupt received")
				return
			case <-finishCh:
				d.Stop()
				log.Println("finished")
				return
			// Case to print current time
			case <-d.C:
				if ctx.Err() != nil {
					return
				}
				if !bar.IsStarted() {
					continue
				}
				currentTime := time.Now()
				dur := currentTime.Sub(startTime)
				lastSpeed := float64(bar.Current()) / dur.Seconds()
				remain := float64(bar.Total() - bar.Current())
				remainDur := time.Duration(remain/lastSpeed) * time.Second
				fmt.Println("Progress:", float32(bar.Current())/float32(bar.Total())*100)
				fmt.Println("last speed:", lastSpeed/1024/1024)
				fmt.Println("remain suration:", remainDur)
			}
		}
	}(ctx, bar)
	// create proxy reader
	barReader := bar.NewProxyReader(reader)
	// copy from proxy reader
	if _, err := io.Copy(writer, barReader); err != nil {
		log.Fatal(err)
	}
	// finish bar
	bar.Finish()
	close(finishCh)
}
```

透過 Go 語言的 context 跟 signal.Notify 可以偵測是否有系統訊號關閉 CLI 程式，這時候就可以做後續相對應的事情，在程式碼就需要多接受 `ctx.Done()` Channel，由於在 Select 多個 Channel 通道，故也是有可能同時發生，所以需要在另外的 switch case 內判斷 conetxt 的 Err 錯誤訊息，如果不等於 nil 那就是收到訊號，進而 return，必免 goroutine 在背景持續進行。大家執行上述程式後，按下 ctrl + c 可以正常看到底下訊息:

```bash
^C
2021/05/21 12:29:25 interrupt received, terminating process
2021/05/21 12:29:25 interrupt received
^C
signal: interrupt
```

可以看到要在按下一次 ctrl + c 才能結束程式，這邊的原因就是 io.Reader 還是正在上傳，並沒有停止，而系統第一次中斷訊號已經被程式用掉了，這時候解決方式就是要修改底下程式

```go
	barReader := bar.NewProxyReader(reader)
	// copy from proxy reader
	if _, err := io.Copy(writer, barReader); err != nil {
		log.Fatal(err)
	}
```

## io.Copy 支援 context 中斷

`io.Copy` 需要支援 context 中斷程式，但是我們只能從 reader 下手，，先看看原本 Reader 的 interface:

```go
type Reader interface {
	Read(p []byte) (n int, err error)
}
```

現在來自己寫一份 func 來支援 context 功能:

```go
type readerFunc func(p []byte) (n int, err error)

func (r readerFunc) Read(p []byte) (n int, err error) { return rf(p) }
func copy(ctx context.Context, dst io.Writer, src io.Reader) error {
	_, err := io.Copy(dst, readerFunc(func(p []byte) (int, error) {
		select {
		case <-ctx.Done():
			return 0, ctx.Err()
		default:
			return src.Read(p)
		}
	}))
	return err
}
```

由於 io.Reader 會把整個檔案分成多個 chunk 分別上傳，避免 Memory 直接讀取太大的檔案而爆掉，那在每個 chunk 上傳前確保沒有收到 context 中斷的訊息，這樣就可以解決無法停止上傳的行為。整體程式碼如下:

```go
package main

import (
	"context"
	"crypto/rand"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/cheggaaa/pb/v3"
)

type readerFunc func(p []byte) (n int, err error)

func (rf readerFunc) Read(p []byte) (n int, err error) { return rf(p) }

func copy(ctx context.Context, dst io.Writer, src io.Reader) error {
	_, err := io.Copy(dst, readerFunc(func(p []byte) (int, error) {
		select {
		case <-ctx.Done():
			return 0, ctx.Err()
		default:
			return src.Read(p)
		}
	}))
	return err
}

func withContextFunc(ctx context.Context, f func()) context.Context {
	ctx, cancel := context.WithCancel(ctx)
	go func() {
		c := make(chan os.Signal, 1)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
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

	ctx := withContextFunc(
		context.Background(),
		func() {
			// clear machine field
			log.Println("interrupt received, terminating process")
		},
	)

	var limit int64 = 1024 * 1024 * 10000
	// we will copy 10 Gb from /dev/rand to /dev/null
	reader := io.LimitReader(rand.Reader, limit)
	writer := ioutil.Discard

	// start new bar
	bar := pb.Full.Start64(limit)
	finishCh := make(chan struct{})
	go func(bar *pb.ProgressBar) {
		d := time.NewTicker(2 * time.Second)
		startTime := bar.StartTime()
		// Using for loop
		for {
			// Select statement
			select {
			case <-ctx.Done():
				log.Println("stop to get current process")
				return
			case <-finishCh:
				d.Stop()
				log.Println("finished")
				return
			// Case to print current time
			case <-d.C:
				if !bar.IsStarted() {
					continue
				}
				currentTime := time.Now()
				dur := currentTime.Sub(startTime)
				lastSpeed := float64(bar.Current()) / dur.Seconds()
				remain := float64(bar.Total() - bar.Current())
				remainDur := time.Duration(remain/lastSpeed) * time.Second
				fmt.Println("Progress:", float32(bar.Current())/float32(bar.Total())*100)
				fmt.Println("last speed:", lastSpeed/1024/1024)
				fmt.Println("remain suration:", remainDur)
			}
		}
	}(bar)
	// create proxy reader
	barReader := bar.NewProxyReader(reader)
	// copy from proxy reader
	if err := copy(ctx, writer, barReader); err != nil {
		log.Println("cancel upload data:", err.Error())
	}
	// finish bar
	bar.Finish()
	close(finishCh)
	time.Sleep(1 * time.Second)
}
```



