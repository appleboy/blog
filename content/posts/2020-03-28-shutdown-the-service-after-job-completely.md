---
title: 停止 Go 服務前先處理完 Worker 內的 Job
author: appleboy
type: post
date: 2020-03-28T05:40:25+00:00
url: /2020/03/shutdown-the-service-after-job-completely/
dsq_thread_id:
  - 7938276455
categories:
  - Golang
tags:
  - golang
  - golang channel

---
[![golang logo][1]][1]

在閱讀本文章之前，作者有寫過一篇『[graceful shutdown with multiple workers][2]』介紹了在服務停止前做一些正確的 Shutdown 流程，像是處理 Http Handler 或關閉資料庫連線等等，假設有服務內有實作 Worker 處裡多個 Job，那該如何等到全部的 Job 都執行完畢才正確關閉且刪除服務 (使用 [Docker][3]) 呢？底下是整個運作流程:

![][4] 

<!--more-->

## 遇到問題

當服務被關閉或者強制使用 ctrl + c 停止，則應該等到所有的 worker 都完成全部 Job 才停止服務。先來看看之前第一版的寫法有什麼問題，當開發者按下 ctrl + c 就會送出 cancel() 訊號，接著看看 worker 原先是怎麼寫的？完整程式碼請[參考這邊][5]。

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

假設現在有 10 個 job 同時進來，有四個 worker 同時處理，接著按下 ctrl + c 後，就會觸發 ctx.Done() channel，因為 Select 接受兩個 channel，開發者不能預期哪一個先觸發，但是假設 jobsChan 還有其他 job 需要處理，就會被程式終止。該如何解決此問題呢？繼續往下看

## 改寫 worker

其實很簡單只要將 worker 部分重新改寫即可，不要使用 select 方式 (程式碼請[參考這邊][6])

```go
func (c *Consumer) worker(num int, wg *sync.WaitGroup) {
    defer wg.Done()
    log.Println("start the worker", num)

    for job := range c.jobsChan {
        c.process(num, job)
    }
}
```

使用 for 方式來讀取 jobsChan，這邊就會等到 channle 完全為空的時候才會結束 for 迴圈，所以有多個 worker 同時讀取 jobsChan。for 結束後，才會觸發 wg.Done() 告訴主程式此 worker 已經完成，主程式可以進行關閉動作了。這邊要注意的是在 Consumer 會先收到 cancel() 觸發，接著關閉 jobsChan 通道，但是關閉通道還是可以透過 for 方式將剩下的 job 從 channel 內讀取出來。可以看看 consumer 寫法 (完整程式碼請[參考這邊][7]):

```go
func (c Consumer) startConsumer(ctx context.Context) {
    for {
        select {
        case job := <-c.inputChan:
            select {
            case c.jobsChan <- job:
            default:
                log.Println("job channel has been closed. num:", job)
            }
            if ctx.Err() != nil {
                close(c.jobsChan)
                return
            }
        case <-ctx.Done():
            close(c.jobsChan)
            return
        }
    }
}
```

## 心得

看專案的需求來決定是要立即停止 worker 還是要等到所有的 Job 都處理完畢才結束。兩種方式寫法不同，差異點就在前者需要再 worker 裡面處理兩個 channel，後者只需要透過 for 迴圈方式來將 job channel 全部讀出後才結束。

## 影片分享

如果對於課程內容有興趣，可以參考底下課程。要合購多個課程，請直接[私訊 FB][8]。直接匯款可以享受 100 元折扣。

  * [Go 語言基礎實戰 (開發, 測試及部署)][9]
  * [一天學會 DevOps 自動化測試及部署][10]
  * [DOCKER 容器開發部署實戰][11]

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://blog.wu-boy.com/2020/02/graceful-shutdown-with-multiple-workers/
 [3]: https://docker.com
 [4]: https://lh3.googleusercontent.com/bsmMhN5bVzpyDy-741CsS8s_wTyPfRpbLeZvJ0u7hOmCkXhBmS0qmVwkky4zveLxtNqQgGTUufWeNi2OVvOyXwx6QrADvt5n_6tAJlSzmRJK27U9C1EgOhzziZmLqNp_FTyqf4NAits=w1920-h1080
 [5]: https://github.com/go-training/training/blob/080ba925d85ff527598ddda9a8eec0b808f6f847/example34-graceful-shutdown-with-worker/graceful-shutdown/answer-shutdown-worker-immediately/main.go#L76-L92
 [6]: https://github.com/go-training/training/blob/080ba925d85ff527598ddda9a8eec0b808f6f847/example34-graceful-shutdown-with-worker/graceful-shutdown/answer-shutdown-after-job-completely/main.go#L80-L89
 [7]: https://github.com/go-training/training/blob/080ba925d85ff527598ddda9a8eec0b808f6f847/example34-graceful-shutdown-with-worker/graceful-shutdown/answer-shutdown-after-job-completely/main.go#L53-L71
 [8]: http://facebook.com/appleboy46
 [9]: https://www.udemy.com/course/golang-fight/?couponCode=202003
 [10]: https://www.udemy.com/devops-oneday/?couponCode=202003
 [11]: https://www.udemy.com/course/docker-practice/?couponCode=202003
