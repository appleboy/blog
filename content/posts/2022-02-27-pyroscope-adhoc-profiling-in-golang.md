---
title: "使用 pyroscope adhoc 加速找到效能瓶頸"
date: 2022-02-27T09:07:55+08:00
author: appleboy
type: post
slug: pyroscope-adhoc-profiling-in-golang
share_img: https://i.imgur.com/KMl96Ks.png
categories:
  - Golang
tags:
  - golang
  - pyroscope
  - pyroscope adhoc
  - profiling
---

![pyroscope profiling](https://i.imgur.com/KMl96Ks.png)

大家在開發軟體時，會快速迭代專案時程跟需求，功能越多，系統就會開始出現效能上的瓶頸，而最快的解決方式就是先垂直擴展，把 CPU 跟記憶體先往上加，但是這是治標不治本，所以之前有推薦大家一套如何在服務執行時，快速找到哪個地方執行較慢，請參考之前的文章『[即時效能分析工具 Pyroscope][1]』，[Pyroscope][2] 目前支援了很多語言，像是 Go, Python, Java, Ruby, Rust, PHP 及 .Net，如果你想要快速在本地端找到效能瓶頸，請繼續將本篇看完。底下會用 [Go 語言][3]實際範例教大家。

[1]:https://blog.wu-boy.com/2021/03/debug-performance-issues-using-pyroscope/
[2]:https://pyroscope.io
[3]:https://go.dev

<!--more-->

## 為什麼要用 adhoc profiling

[Pyroscope][2] 近期內推出 [adhoc profiling 功能][11]，大家想看看為什麼官方要推出此功能。原本 Pyroscope 推出此開源平台可以讓開發者在平台上線時，快速從時間點找到效能瓶頸的地方，但是移動到該時間點時，你會看到很多雜訊，而要持續檢測，開發者需要一直進行測試，而這方式無法在本地端快速驗證出來。

所以 Pyroscope 目標是推出 adhoc profiling 功能，讓開發者可以在本地透過 Pyroscope 快速驗證及找到效能瓶頸，而不用運行一整個服務，只要將特定的流程抓出來透過 Script 方式將效能數據產生出來，並且透過 Pyroscope CLI 直接讀取看數據。

## adhoc profiling 使用方式

使用 adhoc mode 可以讓開發者在執行 Script 時，監控所有效能瓶頸，並且透過 Pyroscope UI 介面快速看到結果，底下來看看如何使用 `adhoc` mode，開發者可以使用 pyroscope CLI 來完成此功能。先看看 Go 範例

```go
package main

import (
  "math"
  "math/rand"

  "github.com/pyroscope-io/pyroscope/pkg/agent/profiler"
)

func isPrime(n int64) bool {
  for i := int64(2); i <= n; i++ {
    if i*i > n {
      return true
    }
    if n%i == 0 {
      return false
    }
  }
  return false
}

func slow(n int64) int64 {
  sum := int64(0)
  for i := int64(1); i <= n; i++ {
    sum += i
  }
  return sum
}

func fast(n int64) int64 {
  sum := int64(0)
  root := int64(math.Sqrt(float64(n)))
  for a := int64(1); a <= n; a += root {
    b := a + root - 1
    if n < b {
      b = n
    }
    sum += (b - a + 1) * (a + b) / 2
  }
  return sum
}

func run() {
  base := rand.Int63n(1000000) + 1
  for i := int64(0); i < 40000000; i++ {
    n := rand.Int63n(10000) + 1
    if isPrime(base + i) {
      slow(n)
    } else {
      fast(n)
    }
  }
}

func main() {
  // No need to modify existing settings,
  // pyroscope will override the server address
  profiler.Start(profiler.Config{
    ApplicationName: "adhoc.example.go",
    ServerAddress:   "http://pyroscope:4040",
  })
  run()
}
```

接著執行底下指令

```sh
pyroscope adhoc go run main.go
```

執行完畢後，你可以看到在同一層目錄多了很多 HTML 檔案，而這些檔案就可以分享給其他同事參考，相當方便來當作團隊溝通的工具，讓其他同事也可以對照此數據，才不會沒有對焦到正確的地方。

![file](https://i.imgur.com/ah76hIq.png)

點開 CPU Profiling 可以看到如下:

![CPU](https://i.imgur.com/ppsfwFL.png)

除了點開 HTML 檔案之外，大家也可以用 pyroscope CLI 在本機端打開 Server 服務，此時 Server 服務會去讀取家目錄內 `~/.pyroscope/pyroscope/` 位置，裡面存放開發者每次的 Profiling JSON 格式數據。請打開 `http://localhost:4040`

![UI](https://i.imgur.com/xW08yIt.png)

從上圖可以看到點選左邊 Single View，就可以看到上面出現 pyroscope data 的 Tab，裡面就是該目錄內所有數據，可以即時呈現及比較數據。

[11]:https://pyroscope.io/blog/pyroscope-adhoc-profiling/

## 線上 Profiling 服務

如果連本地端都不想安裝任何環境，可以透過底下兩個線上服務來完成。

* [Upload and Share Interactive Flamegraphs](https://flamegraph.com/)
* [Playground](https://playground.flamegraph.com/playground)

可以將有效能問題的程式碼放到 Playground 上，並分享給團隊其他同仁，直接線上修改測試即可，其實跟 Go 提供的 [Playground](https://go.dev/play) 差不多意思。

## 心得

有了這個功能幫助挺大的，尤其時想在本機端做一些效能上分析，雖然有 pprof 可以使用，但是沒有好的 UI 介面，還是很難縮短除錯時間，而有了 adhoc 功能，還可以將數據分享給其他同事一起來幫忙。畢竟服務正式上線後，不會將 pyroscope 功能啟動，免得服務受到效能上的影響，而在測試站就會隨時監控，搭配 Prometheus + Grafana 找出特定時間點效能變化。

上面第一段有提到，目前支援多種不同語言，大家在本地端就可以快速測試不同寫法帶來不同的效能，而不是要將代碼推上機器後才可以驗證，真的縮短蠻多時間的。也可以在找到問題同時，先將 HTML 檔案附件在 Issue Tracking 系統上。
