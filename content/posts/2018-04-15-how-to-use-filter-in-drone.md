---
title: '[影片教學] 使用 Filter 將專案跑在特定 Drone Agent 服務'
author: appleboy
type: post
date: 2018-04-15T15:26:37+00:00
url: /2018/04/how-to-use-filter-in-drone/
dsq_thread_id:
  - 6615064511
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - devops
  - drone

---
![cover](https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg)

[Drone][2] 是一套用 [Go 語言][3]撰寫的 CI/CD [開源專案][4]，是由一個 Server 跟多個 Agent 所組成，Agent 上面必須安裝好 [Dokcer][5] 才可以順利測試及部署，但是團隊內會出現一個狀況，每個專案的測試及部署方式不同，有的測試需要 Agent 很多 CPU 或記憶體資源，有的小專案則不需要那麼多，但是當大專案把 agent 系統資源吃光，其他專案都跑不動了，這邊的解決方式就是再建立一台新的 Agent 服務，將需要大量資源的專案跑在該台新的 Agent，Drone 這邊有支援 `filter` 功能，讓開發者可以指定專案要跑在哪一台 Agent 上。底下來教大家如何設定 drone filter。 <!--more-->

## 新增 DRONE_FILTER 設定

打開 `docker-compose.yml`，找到 Drone agent 的設定，加入底下變數:

```bash
DRONE_FILTER="ram <= 16 AND cpu <= 8"
```

這邊的意思是，專案需要的記憶體`小於或等於 16`，CPU `小於或等於 8`。

## 新增 Labels

在 .drone.yml 這邊要介紹 `Labels`，可以用來指定該專案要標記上哪些 Label，讓 drone server 可以根據這些 Label 來將 Job 丟到指定的 Agent 服務內。請打開 `.drone.yml`，加入底下設定

```yml
labels:
  - ram=14
  - cpu=8
```

可以看到上面設定 ram = 14 及 cpu = 8 可以看到符合上面 drone agent 的 filter 條件設定，所以 server 會將此 project 的工作都指定到特定的 agent 服務上，這樣就可以避免大專案跟小專案同時跑在同一台機器上。

## 教學影片

如果上述步驟不知道該如何操作，可以參考底下教學影片

{{< youtube OM_L_qE1Pus >}}

## 結論

為了能讓團隊繼續成長，就必須要一直擴展 Agent。原先在公司內部建立一台 server 加上多台 Agent，而各團隊維護各自的 Agent 服務，團隊間不共享 Angent 資源，這樣避免各專案互相卡住。透過 drone filter 可以讓團隊管理各自的專案在自己的 agent 服務上。如果您對 Drone 有興趣，也可以參考 Udemy 上面的『[一天學會 DevOps 自動化測試及部署][6]』線上課程。

[2]: https://drone.io
[3]: https://golang.org
[4]: https://github.com/drone/drone
[5]: https://www.docker.com
[6]: https://www.udemy.com/devops-oneday/?couponCode=DRONE-DEVOPS
