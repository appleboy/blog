---
title: 善用 Go 語言效能測試工具來提升執行效率
author: appleboy
type: post
date: 2020-11-02T08:46:30+00:00
url: /2020/11/improve-parser-performance-using-go-benchmark-tool/
dsq_thread_id:
  - 8261444377
categories:
  - Golang
tags:
  - benchmark
  - golang

---
[![golang logo][1]][1]

在 AI 訓練模型前，都需要經過大量的資料處理，而資料處理的速度在整個流程內扮演很重要的角色，寫出高效能的 Parser 能降低整體處理時間，那如何評估程式效能如何，以及如何快速找到效能瓶頸？本議程會帶大家了解 [Go 語言][2]內建的效能測試工具，透過 [Benchmark][3] 來找出程式效能瓶頸的地方，快速改善及優化，讓整個系統流程更順暢。也會順道分享 Go 在字串處理優化的一些小技巧。聽過此議程相信您對 Go 語言會有更深入的了解，如果你想寫出有效率的程式碼，本議程一定不能錯過。

<!--more-->

## 影片分享

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][4]
  * [一天學會 DevOps 自動化測試及部署][5]
  * [DOCKER 容器開發部署實戰][6]

如果需要搭配購買請直接透過 [FB 聯絡我][7]，直接匯款（價格再減 **100**）

## 投影片

這次很高興能到[高雄 mopcon][8] 給一場演講『[善用 Go 語言效能測試工具來提升執行效率][9]』。底下是這場投影片。

底下紀錄會後一些朋友的意見跟問題？

## 為什麼要從 Python 到 Golang?

第一版 Python 由同事進行開發，這個版本也在公司內部運作了很久，也很少改版，而這次遇到效能上的問題，加上要搭配 AI，故我先拿 Golang 進行第一次的改版，方式還是使用 Regex，把整個邏輯換掉，也優化不少 Regex，效能提升不少。而至於為什麼要用 Go 而不是用 Python 原因是當下對於 Go 比較熟悉，也想嘗試看看用 Go 能提升多少效能，並非 Python 不好，考慮到團隊目前的技能樹，加上在自家 IT 環境內，用 Go 可以編譯出單一執行檔給同仁使用，相對 Python 來說是方便許多。在公司內部有些特定的環境是完全沒有網路了的，這時候用 Go 搭配 vendor 就可以無痛在該環境編譯，這點是 Go 非常強大的地方。

## 為什麼會想重寫 Parser?

後來用 Go 改寫的 Regex 版本，從原本的 9xx 秒降到 7 秒多，已經提升了不少，接下來要再往下繼續調整，估計也已經沒多少空間了，加上此版本對於更大的檔案量，1 GB 以上資料量，還是需要用掉不少系統資源，故我花了一週下班時間，重新改寫 Parser，最主要要驗證從 7 秒多可以降到幾秒呢？後來事實證明可以從 7 秒多降到 1 秒左右，整體來說提升了不少，也讓其他同仁在使用 Parser 的時候，從原本需要 400 台機器，降到不到 5 台。省下不少公司的資源，這些資源又可以去處理更多事情了。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org
 [3]: https://blog.wu-boy.com/2018/06/how-to-write-benchmark-in-go/
 [4]: https://www.udemy.com/course/golang-fight/?couponCode=202011
 [5]: https://www.udemy.com/course/devops-oneday/?couponCode=202011
 [6]: https://www.udemy.com/course/docker-practice/?couponCode=202011
 [7]: http://facebook.com/appleboy46
 [8]: https://mopcon.org/2020/
 [9]: https://mopcon.org/2020/speaker/42