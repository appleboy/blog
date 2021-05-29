---
title: 透過 Drone CLI 手動觸發 CI/CD 流程
author: appleboy
type: post
date: 2019-07-30T15:12:31+00:00
url: /2019/07/trigger-the-drone-job-via-promotion/
dsq_thread_id:
  - 7561552143
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - drone ci

---
[![drone promotion][1]][1]

相信大家對於 [Drone][2] 並不陌生，這次來介紹 Drone 1.0 的新功能 (更多的 1.0 功能會陸續介紹，也可以參考[之前的文章][3])，叫做 promotion，為什麼作者會推出這功能呢？大家在團隊工作時，有些步驟真的無法導入 CI/CD 自動化流程，而是需要人工介入後，再做後續處理？相信一定會遇到此狀況，PM 或老闆看過沒問題後，才需要手動觸發流程，在此功能以前，都會麻煩工程師幫忙做後續自動化流程，但是有了 [promotion][4]，現在連 PM 都可以透過 Drone CLI 來自己做部署啦，這邊就是介紹給大家，如何透過 [Drone CLI][5] 指令來觸發已存在的工作項目。

<!--more-->

# 影片教學

## 如何使用

首先你必須要先安裝好 Drone CLI，安裝方式可以直接參考[官方教學][6]即可，透過底下例子來了解怎麼使用 promotion

```yaml
kind: pipeline
name: testing

steps:
- name: stage
  image: golang
  commands:
  - echo "stage"
  when:
    event: [ promote ]
    target: [ staging ]

- name: production
  image: golang
  commands:
  - echo "production"
  when:
    event: [ promote ]
    target: [ production ]

- name: testing
  image: golang
  commands:
  - echo "testing"
  when:
    event: [ promote ]
    target: [ testing ]
```

上面可以看到，在 when 的條件子句內，可以設定 event 為 `promote`，接著 target 可以設定為任意名稱，只要是 `promote` 的 event type，在透過 git commit 預設都不會啟動的，只能透過 drone CLI 方式才可以觸發，那該如何執行命令呢？請看底下

```sh
drone build promote <repo> <build> <environment>
```

其中 `build` 就是直接在後台列表上找一個已經執行過的 job ID

```sh
drone build promote appleboy/golang-example 6 production
```

## 心得

Drone 提供手動觸發的方式相當方便，畢竟有些情境真的是需要人工審核確認過後，才可以進行後續的流程，透過此方式，也可以寫一些 routine 的 job 讓其他開發者，甚至 PM 可以透過自己的電腦觸發流程。

 [1]: https://lh3.googleusercontent.com/72xMoCcL6pClsS5eH08zTP2ksHlV2XaRVhtSDuyYnZ-nDBtXR5dxVyGp6WIE-RJ48WL4ZEwTyAijcmua7ade_GGzJ6yDfcolY2h4ejUGASUjWoDXHQ1okvElcJY7tpf7bxnVc3rrZ7Y=w1920-h1080 "drone promotion"
 [2]: https://cloud.drone.io/
 [3]: https://blog.wu-boy.com/2019/04/cicd-drone-1-0-feature/
 [4]: https://docs.drone.io/user-guide/pipeline/promotion/
 [5]: https://github.com/drone/drone-cli
 [6]: https://docs.drone.io/cli/install/