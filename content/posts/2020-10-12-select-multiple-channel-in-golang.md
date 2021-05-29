---
title: Go 語言 Select Multiple Channel 注意事項
author: appleboy
type: post
date: 2020-10-12T07:44:32+00:00
url: /2020/10/select-multiple-channel-in-golang/
dsq_thread_id:
  - 8235708275
categories:
  - Golang
tags:
  - channel
  - golang
  - golang channel

---
[![golang logo][1]][1]

相信大家都知道 Select 可以用來處理多個 Channel，但是大家有沒有想過一個情境，如果是 for 搭配 select 時，肯定會用一個 Timer 或 context 來處理 Timeout 或手動 Cancel，假設如果跟其他 Channel 同時到達時，官方說法是 Select 會隨機選擇一個狀況來執行，如果並非選到我們所要的 case 那就會造成情境或流程上的錯誤，而本影片就是講解該如何解決此問題，請大家務必詳細了解業務的需求，來決定程式碼架構該如何寫。

<!--more-->

## 影片介紹

{{< youtube Zh34igf1TjU >}}

* 00:00 簡介程式碼
* 01:03 NewTicker 跟 Channel 同時執行狀況
* 03:29 解決方案一以及限制 (多個 Channel 就不適用了)
* 05:06 多個一樣的 case 提供優先權
* 07:28 用 Kubernetes Client 案例來講解

其中 Kubernetes Client 範例來自[這邊][2]

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][3]
  * [一天學會 DevOps 自動化測試及部署][4]
  * [DOCKER 容器開發部署實戰][5]

如果需要搭配購買請直接透過 [FB 聯絡我][6]，直接匯款（價格再減 **100**）

## 多個 Channle 同時讀寫

底下直接用範例解釋 (此範例來源自『[go里面select-case和time.Ticker的使用注意事项][7]』)，也可以參考[整個 FB 討論串][8]

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    ch := make(chan int, 1024)
    go func(ch chan int) {
        for {
            if v, ok := <-ch; ok {
                fmt.Printf("val:%d\n", v)
            }
        }
    }(ch)

    tick := time.NewTicker(1 * time.Second)
    for i := 0; i < 30; i++ {
        select {
        // how to make sure all number in ch channel?
        case ch <- i:
        case <-tick.C:
            fmt.Printf("%d: case <-tick.C\n", i)
        }

        time.Sleep(200 * time.Millisecond)
    }
    close(ch)
    tick.Stop()
}
```

大家可以看到上面開始有個 goroutine 用來接收 ch channel 的內容，接著看看下面的 for 迴圈內有個 select 用來接受或寫入 Channel，但是這時候會發生一個問題，當 i = 5 時，是有機率會兩個 case 同時發生，這時候按照 [Go 語言官方範例][9]提到內容

> A select blocks until one of its cases can run, then it executes that case. It chooses one at random if multiple are ready.

是會隨機的方式選取一個，所以會發現有機率會少接收到 ch 值，所以底下有幾種方式可以解決此問題。也就是要確保 ch 可以接收到 0 ~ 29 數字。其中第一個做法就是將 ch <- i 加入到 tick.C 內

```go
    for i := 0; i < 30; i++ {
        select {
        case ch <- i:
        case <-tick.C:
            fmt.Printf("%d: case <-tick.C\n", i)
            ch <- i
        }

        time.Sleep(200 * time.Millisecond)
    }
```

第二種作法就是透過 select default 方式不要讓程式 blocking

```go
    for i := 0; i < 30; i++ {
        ch <- i
        select {
        case <-tick.C:
            fmt.Printf("%d: case <-tick.C\n", i)
        default:
        }

        time.Sleep(200 * time.Millisecond)
    }
```

上述這兩種方式都可以，只是真的要依照團隊業務邏輯來決定怎樣修改才是正確的。這概念已經有在去年 (2019) 的 Blog 講過，如果要再多了解 Select 語法，可以參考之前寫的文章『[Go 語言使用 Select 四大用法][10]』

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://www.facebook.com/groups/616369245163622/permalink/2109443995856132/?comment_id=2109476765852855&reply_comment_id=2110581019075763&__cft__[0]=AZXtO09hHRV6wxtrFSg0C2D1Sx4NY4pysZny7VnnWX3QdECd04_zTBUoFzPmIP8Wo48nKRHbWjy2qh8lbIH5Py6IiMLeS31WMfcxMmGPI0IlYoXXCWf6IzIMbBXoULye766kbpctAUvSdmGzqascYD-qfCh06bIZ51zxwocGcv3KLg&__tn__=R]-R
 [3]: https://www.udemy.com/course/golang-fight/?couponCode=202010
 [4]: https://www.udemy.com/course/devops-oneday/?couponCode=202010
 [5]: https://www.udemy.com/course/docker-practice/?couponCode=202010
 [6]: http://facebook.com/appleboy46
 [7]: https://blog.csdn.net/wk3368/article/details/42678497
 [8]: https://www.facebook.com/groups/616369245163622/permalink/2109443995856132/
 [9]: https://tour.golang.org/concurrency/5
 [10]: https://blog.wu-boy.com/2019/11/four-tips-with-select-in-golang/
