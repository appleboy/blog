---
title: "如何設計一套具備 Container 容器化技術的 CI/CD 平台 - Drone 開源專案"
date: 2024-07-09T11:01:51+08:00
author: appleboy
type: post
slug: how-to-design-a-ci-cd-platform-with-containerization-technology
share_img: https://lh3.googleusercontent.com/pw/AP1GczNeLCXNNS9NuOpeSI5CRTWe_SdtDwueVjvBQU_Wv08mVz8FoWqQ1WYfq1MHWRSXOtFbbK5gwai6D530X3qvL-tmaoR5D717ghr_q5u42lWojcF3Q3tuG0PR2IIWieoJBqg7aZMnmKwoy7dzQnL6VAwu0w=w2212-h1132-s-no-gm?authuser=0
categories:
- golang
- drone
---

![logo](https://lh3.googleusercontent.com/pw/AP1GczNeLCXNNS9NuOpeSI5CRTWe_SdtDwueVjvBQU_Wv08mVz8FoWqQ1WYfq1MHWRSXOtFbbK5gwai6D530X3qvL-tmaoR5D717ghr_q5u42lWojcF3Q3tuG0PR2IIWieoJBqg7aZMnmKwoy7dzQnL6VAwu0w=w2212-h1132-s-no-gm?authuser=0)

今年一樣報名了 2024 年台北 [Cloud Summit][1] 活動，講的主題是『[如何設計一套具備 Container 容器化技術的 CI/CD 平台?][2]』，我相信大家在團隊內一定都有使用 CI/CD 工具，像是 Jenkins、GitLab CI、Travis CI、Circle CI 等等，這些工具都是非常好用的，但是想要在自己的環境中建置一套 CI/CD 平台，你會怎麼做呢？這次會帶您深入了解 Drone CI/CD 開源工具，並且透過實際的 Demo 來說明如何設計一套具備 Container 容器化技術的 CI/CD 平台。藉由 Drone 原始碼的解析，讓您了解 Drone 的運作原理，並且透過 Drone 的 Plugin 機制，讓您可以自行開發 Drone 的 Plugin，讓 Drone 可以更加符合您的需求。

[1]:https://cloudsummit.ithome.com.tw/2024/
[2]:https://cloudsummit.ithome.com.tw/2024/session-page/2653

<!--more-->

## 演講大綱

1. Drone CI/CD 簡介
2. Drone Runner 原始碼解析
3. Drone Server 原始碼解析

{{< speakerdeck id="660c68d54a494cc393b6530a894d9456" >}}

這場會議主要講述 Drone Server 跟 Runner 中間如何實現溝通機制，避免大量無意義的連線，其實就是簡單基礎版的 Task Schedule 機制，透過這個機制，可以讓 Drone Server 跟 Runner 之間的溝通更加有效率。

而 Drone 早在幾年前已經被 [Harness][12] 公司買下，但是至今還是維持 Drone 開源，請到 [drone branch][11] 才可以看到最新的 Drone 開源原始碼。

[11]:https://github.com/harness/gitness/tree/drone
[12]:https://www.harness.io/

## 現場照片

![photo01](https://lh3.googleusercontent.com/pw/AP1GczOpMbOjWsMdeiL29gmRaimy4N-bS5YKj8sF6E12Y34W9zfGtTb3LhwdayXXZhbAYKB-t1xHH4AeYyudYdreUGnO9ul2Y0WW3hMIOOu41_Ws-MHkYoJjoS5JrystNFTZ3Y13lXtePvlo3QrooAHer-Em_w=w2268-h1514-s-no-gm?authuser=0)

![photo02](https://lh3.googleusercontent.com/pw/AP1GczMmWTgQxBFl_FXBQH-JD1tjZ8onzJUSGvykJaZW6Ex_FeWT7C_q9bjr88QEESiVCoQJ5eWpuB5e6FxsgKAb_42XUBY-B-0Y0dg3xXnOssIJ3ZdPnluho_CJO0WDvxp2knMV-u8zm84xe1kv8t-8T5h1vQ=w2246-h1500-s-no-gm?authuser=0)

![photo03](https://lh3.googleusercontent.com/pw/AP1GczNfiVR3bu0DHQV06Wm8ontReu14g4wu_l-Jnl9GTmmEdBAwBcYLNsU5nXwEZd7pW8MQl5jdn9WPSwwzlDTGD8IkIh2iszeN14n0QakNscvywCHVNTr-oW6qIPr-mg7WTAgsQewvEkGWSBE2hmQXrqfPNQ=w2212-h1476-s-no-gm?authuser=0)
