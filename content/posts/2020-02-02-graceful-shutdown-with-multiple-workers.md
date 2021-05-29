---
title: '[Go 教學] graceful shutdown with multiple workers'
author: appleboy
type: post
date: 2020-02-02T14:53:48+00:00
url: /2020/02/graceful-shutdown-with-multiple-workers/
dsq_thread_id:
  - 7849159603
categories:
  - Golang
tags:
  - channel
  - golang

---
[![golang logo][1]][1]

在閱讀本文章之前請先預習『[用 Go 語言 buffered channel 實作 Job Queue][2]』，本篇會針對[投影片][3] p.26 到 p.56 做詳細的介紹，教大家如何從無到有寫一個簡單的 multiple worker，以及如何處理 graceful shutdown with workers，為什麼要處理 graceful shutdown? 原因是中途手動執行 ctrl + c 或者是部署新版程式都會遇到該如何確保 job 執行完成後才結束 main 函式。

<!--more-->

## 教學影片

https://www.youtube.com/watch?v=SWfaH1HDBqQ

教學影片會之後放上，如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][4]
  * [一天學會 DevOps 自動化測試及部署][5]

## 關閉 Channel

通常會開一個 Channel 搭配多個 worker 才能達到平行處理，那該如何正確關閉 Channel? 底下看個例子:

```go
func main() {
    ch := make(chan int, 2)
    go func() {
        ch <- 1
        ch <- 2
    }()

    for n := range ch {
        fmt.Println(n)
    }
}
```

執行上述程式你會發現出現了

> fatal error: all goroutines are asleep - deadlock!

原因在於沒有關閉 channel，造成 main 函式一直讀取 channel，但是 channle 裡面已經不會再有值了，就造成主程式 deadlock，避免此問題很簡單

```go
func main() {
    ch := make(chan int, 2)
    go func() {
        ch <- 1
        ch <- 2
        close(ch)
    }()

    for n := range ch {
        fmt.Println(n)
    }
}
```

除了 `close(ch)` 之外，另一個方式就將讀取 channel 也丟到 goroutine 內

```go
func main() {
    ch := make(chan int, 2)
    go func() {
        ch <- 1
        ch <- 2
    }()

    go func() {
        for n := range ch {
            fmt.Println(n)
        }
    }()

    time.Sleep(1 * time.Second)
}
```

了解上述 channel 觀念後，可以來實作底下 consumer 流程

![][6] 

## 實作 consumer

底下會創建兩個 channel 來實作 consumer，其中 jobsChan 後面會有多個 worker 串接。

![][7] 

```go
// Consumer struct
type Consumer struct {
    inputChan chan int
    jobsChan  chan int
}

func main() {
    // create the consumer
    consumer := Consumer{
        inputChan: make(chan int, 10),
        jobsChan:  make(chan int, poolSize),
    }
}
```

接著實現 worker 模組

![][8] 

```go
func (c *Consumer) queue(input int) {
    select {
    case c.inputChan <- input:
        log.Println("already send input value:", input)
        return true
    default:
        return false
    }
}

func (c *Consumer) process(num, job int) {
    n := getRandomTime()
    log.Printf("Sleeping %d seconds...\n", n)
    time.Sleep(time.Duration(n) * time.Second)
    log.Println("worker:", num, " job value:", job)
}

func (c *Consumer) worker(num int) {
    log.Println("start the worker", num)
    for {
        select {
        case job := <-c.jobsChan:
            c.process(num, job)
        }
    }
}

func (c Consumer) startConsumer(ctx context.Context) {
    for {
        select {
        case job := <-c.inputChan:
            c.jobsChan <- job
        }
    }
}

const poolSize = 2

func main() {
    // create the consumer
    consumer := Consumer{
        inputChan: make(chan int, 10),
        jobsChan:  make(chan int, poolSize),
    }

    for i := 0; i < poolSize; i++ {
        go consumer.worker(i)
    }

    go consumer.startConsumer(ctx)

    consumer.queue(1)
    consumer.queue(2)
    consumer.queue(3)
    consumer.queue(4)
    consumer.queue(5)
}
```

由上述程式碼可以看到，都會透過 for select 方式來對 channel 進行讀寫動作。其中 `queue` 用來將資料丟入 input channel。

## Shutdown with Sigterm Handling

接著處理當使用者按下 ctrl + c 或者是容器被移除時 (restart) 該如何接到此訊號?

![][9] 

這時候就需要用到 context

```go
func withContextFunc(ctx context.Context, f func()) context.Context {
    ctx, cancel := context.WithCancel(ctx)
    go func() {
        c := make(chan os.Signal)
        signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
        defer signal.Stop(c)

        select {
        case <-ctx.Done():
        case <-c:
            cancel()
            f()
        }
    }()

    return ctx
}
```

其中 `syscall.SIGINT`, `syscall.SIGTERM` 用來偵測使用者是否按下 `ctrl+c` 或者是容器被移除時就會執行。所以當開發者按下 `ctrl+c` 就會直接觸發 cancel()，所以在最前面會使用 `context.WithCancel`，之後有機會再詳細介紹 context 的使用方式。

![][10] 

由於使用了 context，這樣就可以在每個 func 帶入客製化的 context。需要變動的有 `startConsumer` 及 `worker`

```go
func (c Consumer) startConsumer(ctx context.Context) {
    for {
        select {
        case job := <-c.inputChan:
            if ctx.Err() != nil {
                close(c.jobsChan)
                return
            }
            c.jobsChan <- job
        case <-ctx.Done():
            close(c.jobsChan)
            return
        }
    }
}

func (c *Consumer) worker(ctx context.Context, num int) {
    log.Println("start the worker", num)
    for {
        select {
        case job := <-c.jobsChan:
            if ctx.Err() != nil {
                log.Println("get next job", job, "and close the worker", num)
                return
            }
            c.process(num, job)
        case <-ctx.Done():
            log.Println("close the worker", num)
            return
        }
    }
}
```

這邊要注意的是，當我們按下 ctrl+c 終止 worker 時，理論上會直接到 `case <-ctx.Done()` 但是實際狀況是有時候會直接在繼續讀取 channel 下一個值。這時候就需要在讀取 channel 後判斷 context 是否已經取消。在 main 最後通常會放一個 channel 來判斷是否需要中斷 main 函式。

```go
func main() {
    finished := make(chan bool)

    ctx := withContextFunc(context.Background(), func() {
        log.Println("cancel from ctrl+c event")
        close(finished)
    })

    <-finished
}
```

上述完成後，按下 ctrl + c 後，就可以直接執行 close channel，整個主程式都停止，但是這不是我們預期得結果，預期的是需要等到全部的 worker 把正在處理的 Job 完成後，才進行停止才是。

## Graceful shutdown with worker

要用什麼方式才可以等到 worker 處理完畢後才結束 main 函式呢？這時候需要用到 `sync.WaitGroup` 了

![][11] 

```go
const poolSize = 2

func main() {
    finished := make(chan bool)
    wg := &sync.WaitGroup{}
    wg.Add(poolSize)
}
```

其中 poolSize 代表的是 worker 數量，接著調整 worker 函式

![][12] 

```go
func (c *Consumer) worker(ctx context.Context, num int, wg *sync.WaitGroup) {
    defer wg.Done()
    log.Println("start the worker", num)
    for {
        select {
        case job := <-c.jobsChan:
            if ctx.Err() != nil {
                log.Println("get next job", job, "and close the worker", num)
                return
            }
            c.process(num, job)
        case <-ctx.Done():
            log.Println("close the worker", num)
            return
        }
    }
}
```

只有在最前面加上 `defer wg.Done()`，接著修正 context 的 callback 函式，增加 `wg.Wait()` 讓 main 函式等到所有的 worker 處理完畢後才關閉 `finished` channel。

```go
    ctx := withContextFunc(context.Background(), func() {
        log.Println("cancel from ctrl+c event")
        wg.Wait()
        close(finished)
    })
```

最後在主程式後面加上 `<-finished` 即可。

```go
const poolSize = 2

func main() {
    finished := make(chan bool)
    wg := &sync.WaitGroup{}
    wg.Add(poolSize)
    // create the consumer
    consumer := Consumer{
        inputChan: make(chan int, 10),
        jobsChan:  make(chan int, poolSize),
    }

    ctx := withContextFunc(context.Background(), func() {
        log.Println("cancel from ctrl+c event")
        wg.Wait()
        close(finished)
    })

    for i := 0; i < poolSize; i++ {
        go consumer.worker(ctx, i, wg)
    }

    <-finished
    log.Println("Game over")
}
```

最後附上[完整的程式碼][13]讓大家測試:

```go
package main

import (
    "context"
    "log"
    "math/rand"
    "os"
    "os/signal"
    "sync"
    "syscall"
    "time"
)

// Consumer struct
type Consumer struct {
    inputChan chan int
    jobsChan  chan int
}

func getRandomTime() int {
    rand.Seed(time.Now().UnixNano())
    return rand.Intn(10)
}

func withContextFunc(ctx context.Context, f func()) context.Context {
    ctx, cancel := context.WithCancel(ctx)
    go func() {
        c := make(chan os.Signal)
        signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
        defer signal.Stop(c)

        select {
        case <-ctx.Done():
        case <-c:
            cancel()
            f()
        }
    }()

    return ctx
}

func (c *Consumer) queue(input int) bool {
    select {
    case c.inputChan <- input:
        log.Println("already send input value:", input)
        return true
    default:
        return false
    }
}

func (c Consumer) startConsumer(ctx context.Context) {
    for {
        select {
        case job := <-c.inputChan:
            if ctx.Err() != nil {
                close(c.jobsChan)
                return
            }
            c.jobsChan <- job
        case <-ctx.Done():
            close(c.jobsChan)
            return
        }
    }
}

func (c *Consumer) process(num, job int) {
    n := getRandomTime()
    log.Printf("Sleeping %d seconds...\n", n)
    time.Sleep(time.Duration(n) * time.Second)
    log.Println("worker:", num, " job value:", job)
}

func (c *Consumer) worker(ctx context.Context, num int, wg *sync.WaitGroup) {
    defer wg.Done()
    log.Println("start the worker", num)
    for {
        select {
        case job := <-c.jobsChan:
            if ctx.Err() != nil {
                log.Println("get next job", job, "and close the worker", num)
                return
            }
            c.process(num, job)
        case <-ctx.Done():
            log.Println("close the worker", num)
            return
        }
    }
}

const poolSize = 2

func main() {
    finished := make(chan bool)
    wg := &sync.WaitGroup{}
    wg.Add(poolSize)
    // create the consumer
    consumer := Consumer{
        inputChan: make(chan int, 10),
        jobsChan:  make(chan int, poolSize),
    }

    ctx := withContextFunc(context.Background(), func() {
        log.Println("cancel from ctrl+c event")
        wg.Wait()
        close(finished)
    })

    for i := 0; i < poolSize; i++ {
        go consumer.worker(ctx, i, wg)
    }

    go consumer.startConsumer(ctx)

    go func() {
        consumer.queue(1)
        consumer.queue(2)
        consumer.queue(3)
        consumer.queue(4)
        consumer.queue(5)
    }()

    <-finished
    log.Println("Game over")
}

```

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://blog.wu-boy.com/2019/11/implement-job-queue-using-buffer-channel-in-golang/
 [3]: https://www.slideshare.net/appleboy/job-queue-in-golang-184064840
 [4]: https://www.udemy.com/course/golang-fight/?couponCode=202001
 [5]: https://www.udemy.com/course/devops-oneday/?couponCode=202001
 [6]: https://lh3.googleusercontent.com/bsmMhN5bVzpyDy-741CsS8s_wTyPfRpbLeZvJ0u7hOmCkXhBmS0qmVwkky4zveLxtNqQgGTUufWeNi2OVvOyXwx6QrADvt5n_6tAJlSzmRJK27U9C1EgOhzziZmLqNp_FTyqf4NAits=w1920-h1080
 [7]: https://lh3.googleusercontent.com/MLHCSmyZXRq-89r0I8b26ZEQ07N28EI2NzeE8KLhpBJCnbUCHXkdQ3KqvzXOObPr6_mqJOt6lW7hoVxEr52HbmVVHmXE-1g5yqmmN2EN9UXtptfgHj5wL6Ff-0G1QO3WFw3ShYzDh10=w1920-h1080
 [8]: https://lh3.googleusercontent.com/gDAxAXt6HucaSmMiWudaBqM8lB7CEuV0u2CYPNdmij5GKwVOHbPqF300DiiupusbGfl3sXqT-mu7EAfaWRCjLS850b7yUpHlwiwJ-z-hBo2ZkKE71oHleH7f36Yifx6Kr3rkQavx7uI=w1920-h1080
 [9]: https://lh3.googleusercontent.com/5LzQ5lKJzfAyqKq608HbQnZJUnE_ktwdscY2rNv6FcT-G00-zo8bzObB1bph-oEdDOxOeL0r3sLQ27TONW4MBJN2FMHH20NdkciFY3xUhAaWto6BM8fbcot_E-be8iQ7uQdjSSmu3cQ=w1920-h1080
 [10]: https://lh3.googleusercontent.com/9sRvEU3seyDRvDLE8Wg2L2Ydc9E1moSwHeTXl2Fy7NbqOgJp9nZv7M9ds0d4GD42CNFXVs3IVeTlbP2khg_btLgRDsvqfefvfQ6ZAaQaWQcgDw2tm0SiHgQcI_Hf1pqIhc6xw4ztroI=w1920-h1080
 [11]: https://lh3.googleusercontent.com/ysxHycsHwxRY9vxlQXzUoOz3Fb1LaaG0V47KqmBp8AB6kD5-kBznMP5oFm-ZVv24M01So92VTgpHtdO36EUKDgu3RzdFMLb3cCRf5sndyBJqPM_gRs_nh43W18gFC9M4KaxL1VYuS0o=w1920-h1080
 [12]: https://lh3.googleusercontent.com/XP11UzmV5sgyCeI9et14wFgXBLHX0UPvozlur_b6PnZgoiOU2VlUbsxmL4e7t_CSaB2Whgzo-_qKhjVf0mV3PL1s9dFFZiYBbAiKqEQYfqKLHua1gt-UEC7txcveRtCSbW6-mHKaMTM=w1920-h1080
 [13]: https://github.com/go-training/training/blob/61662e050886e27aaa9c8f757b9907dc096b7440/example34-graceful-shutdown-with-worker/graceful-shutdown/question/main.go#L1
