---
title: 即時效能分析工具 Pyroscope
author: appleboy
type: post
date: 2021-03-01T13:20:59+00:00
url: /2021/03/debug-performance-issues-using-pyroscope/
dsq_thread_id:
  - 8418623452
categories:
  - Golang
tags:
  - golang
  - pprof
  - Pyroscope

---
![][1]

當網站上線後，流量增加或短暫功能故障，都會造成使用者體驗相當不好，而這時該怎麼快速找到效能的瓶頸呢？通常 CPU 衝到 100% 時，有時候也蠻難複製及找出關鍵問題點。本篇會介紹一套工具叫 [pyroscope][2]，讓開發者可以快速找到效能瓶頸的程式碼。之前也寫了相關的效能瓶頸文章，可以參考看看『[Go 語言用 pprof 找出程式碼效能瓶頸][3]』或『[善用 Go 語言效能測試工具來提升執行效率][4]』，上述兩篇都是針對 [Go 語言][5]的效能分析文章，而 pyroscope 目前可以支援在 [Python][6], [Ruby][7] 或 [Go][5] 的環境。底下筆者會針對 Go 環境做介紹。

<!--more-->

## 影片分享

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][8]
  * [一天學會 DevOps 自動化測試及部署][9]
  * [DOCKER 容器開發部署實戰][10]

如果需要搭配購買請直接透過 [FB 聯絡我][11]，直接匯款（價格再減 **100**）

## 什麼是 Pyroscope？

Pyroscope 是一套開源的效能即時監控平台，簡單的 Server 及 Agent 架構，讓開發者可以輕鬆監控代碼效能，不管你要找 10 秒或幾分鐘內的效能數據，都可以快速的即時呈現，開發者也不用在意裝了此監控會造成任何效能上的負擔。Pyroscope 背後的儲存採用 [Badger][12] 這套 Key-Value 資料庫，效能上是非常好的。目前只有支援 3 種語言 (Python, Ruby 及 Go) 未來會[預計支援 NodeJS][13]。假設您還沒導入任何效能分析工具或平台，那 Pyroscope 會是您最好的選擇。

## Pyroscope 架構

如果你有打算找效能分析工具平台，Pyroscope 提供了三大優勢，讓開發者可以放心使用

  1. 低 CPU 使用率，不會影響既有平台
  2. 可儲存好幾年的資料，並且用 10 秒這麼細的顆粒度看資料
  3. 壓縮儲存資料，減少浪費硬碟空間

架構只有分 Server 跟 Agent 而已，可以參考底下架構圖，除了 Go 語言之外，Python 跟 Ruby App 都是透過 pyroscope 指令啟動相關 app 來監控系統效能。底下架構圖[來自官方網站][14]

![][1] 

## 啟動 Pyroscope 服務

啟動方式有兩種，第一是直接用 docker 指令啟動

```sh
docker run -it -p 4040:4040 pyroscope/pyroscope:latest server
```

另一種可以用 docker-compose 啟動

```yaml
---
services:
  pyroscope:
    image: "pyroscope/pyroscope:latest"
    ports:
      - "4040:4040"
    command:
      - "server"
```

## 在 Go 裡面安裝 agent

本篇用 Go 語言當作範例，先 import package

```go
import "github.com/pyroscope-io/pyroscope/pkg/agent/profiler"
```

接著在 `main.go` 寫入底下程式碼即可:

```go
profiler.Start(profiler.Config{
    ApplicationName: "simple.golang.app",
    ServerAddress:   "http://pyroscope:4040",
})
```

其中 `http://pyroscope` 可以換成自訂的 hostname 即可，接著打開上述網址就可以看到效能監控的畫面了

![][15] 

透過畫面可以快速找到是 SQL 或哪個函式執行很久

![][16] 

## 心得

這套工具相當方便，在 Go 語言雖然可以用 pprof 快速找到問題，但是難免還是需要手動的一些地方才可以查出效能瓶頸，有了這套平台，就可以將全部 App 都進行監控，當使用者有任何問題，就可以快速透過 Pyroscope 查看看哪邊程式碼出了問題。

 [1]: https://lh3.googleusercontent.com/PIRK3Qj4WiToHgB0QDDf6fMHZxDmEswjWJdTIfVJ8xY7UtSau5C0mosjALev5qbJMflIfrIWsC3bPjjxHRRWQNAiFZSCLbVlin-r1-ICV-lOnopbnpRj4BiMKJnTbslpdo-n3CS2zbQ=w1920-h1080
 [2]: https://pyroscope.io/
 [3]: https://blog.wu-boy.com/2020/06/golang-benchmark-pprof/
 [4]: https://blog.wu-boy.com/2020/11/improve-parser-performance-using-go-benchmark-tool/
 [5]: https://golang.org
 [6]: https://www.python.org/
 [7]: https://www.ruby-lang.org/en/
 [8]: https://www.udemy.com/course/golang-fight/?couponCode=202102
 [9]: https://www.udemy.com/course/devops-oneday/?couponCode=202103
 [10]: https://www.udemy.com/course/docker-practice/?couponCode=202103
 [11]: http://facebook.com/appleboy46
 [12]: https://github.com/dgraph-io/badger
 [13]: https://github.com/pyroscope-io/pyroscope/issues/8
 [14]: https://pyroscope.io/docs/how-pyroscope-works
 [15]: https://lh3.googleusercontent.com/8B47gH8UdtdkP-d2nFv-kYx113Bc0r0hQ3YkPL1WJSSmqBv10J7oOXznVXOUSpj-Bd0MWCFvzw8XXhX3mEUMr8sc7ZkPQKC740ASwYAxotFDt5siStTCJXpPEcswIxTTHPA_M6uj4y4=w1920-h1080
 [16]: https://lh3.googleusercontent.com/E117n5ulSa3Iuxp_I1b-1hMjiFWx-r83xHIZ0cUHw4SDCd7MR8-VgU8FSVmXnWsetL8LZroMv016c_Llr9H3GD3gDdBtxUhKTaOD2_nqsgZD3iScy671dtDsF8Y5tmznBdYn_9sf_xU=w1920-h1080