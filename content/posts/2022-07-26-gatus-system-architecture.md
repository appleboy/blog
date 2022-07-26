---
title: "監控服務 Gatus 系統架構"
date: 2022-07-26T17:29:31+08:00
author: appleboy
type: post
slug: gatus-system-architecture
share_img: https://i.imgur.com/mvEGMva.png
categories:
  - Golang
tags:
  - golang
  - gatus
  - monitor
  - devops
---

![gatus proposal](https://i.imgur.com/mvEGMva.png)

今年第一場公開的演講 [2022 台灣雲端大會][1]，台灣五月開始疫情變嚴重，故延遲了一次到七月才舉辦，這次帶給大家的是『[自動化監控網站運行服務 – Gatus][2]』，內容可以拆為兩個部分，第一部分是介紹為什麼要使用 [Gatus][3]，用來解決開發團隊哪些問題，我也整理了三大點為什麼我選擇 Gatus，另一部分就是本篇的主軸，Gatus 系統架構跟流程。

1. 監控條件 (客製化回應)
2. 開源專案 (Go 語言)
3. 開源專案 (Go 語言)

對於使用 Gatus 有興趣的朋友可以參考我之前寫的文章：『[自動化監控網站運行服務 - Gatus][4]』，本篇就不介紹怎麼使用 Gatus 了。

[1]:https://cloudsummit.ithome.com.tw/
[2]:https://cloudsummit.ithome.com.tw/2022/speaker-page/69
[3]:https://github.com/TwiN/gatus
[4]:https://blog.wu-boy.com/2022/03/automated-service-health-dashboard-gatus/

## 投影片

{{< speakerdeck id="eeaa918eda4342118d7bb3c56d6d5b0d" >}}

## Gatus 系統流程

其實整體流程沒有很複雜，底下這張圖就是整體全貌了

![gatus flow](https://i.imgur.com/bG24JxH.png)

1. 讀取 YAML 設定檔案
2. 初始化儲存空間 (Postgres 或 SQLite, Memory)
3. 啟動服務 (監控設定檔變化，啟動後台服務，啟動監控)

每隔 30 秒會偵測設定檔案是否有變化，如果有的話，就重新走上面三大步驟，當然執行前要先將後台及監控正常關閉

```go
for {
 time.Sleep(30 * time.Second)
 if cfg.HasLoadedConfigurationFileBeenModified() {
   stop()
   time.Sleep(time.Second)
   save()
   updatedConfig, err := loadConfiguration()
   if err != nil {
     if cfg.SkipInvalidConfigUpdate {
       cfg.UpdateLastFileModTime()
       continue
     } else {
       panic(err)
     }
   }
   initializeStorage(updatedConfig)
   start(updatedConfig)
   return
 }
}
```

## 擴充性 (Scalability)

看完系統流程後，你一定會問，怎麼確保系統穩定性，可否一次跑兩個或多個 Instance 呢？如果 Endpoint 很多個，會不會有系統不穩定呢？大家可以看看[這裡的討論串][11]，由於架構變動太大，大家只提出自己的想法，最後要實作可能要靠作者，那底下我自己提供一個解法:

![gatus proposal](https://i.imgur.com/mvEGMva.png)

上面架構其實要考慮的層面很多，包含怎麼設計設定檔 (YAML) 等，底下列出 3 大點讓大家想看看怎麼實作

1. 確保每台 Agent 不會拿到重複 Endpoint
2. 當 Endpoint 有變化時，如何通知 Agent 關閉
3. 處理 Server 及 Agent graceful shutdown 機制

[11]:https://github.com/TwiN/gatus/issues/64
