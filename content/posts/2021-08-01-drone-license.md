---
title: "開源專案 Drone CI/CD 平台真的免費嗎？"
date: 2021-08-01T09:57:19+08:00
author: appleboy
type: post
url: /2021/08/drone-license/
share_img: https://i.imgur.com/2P2MVNK.png
categories:
  - Drone
  - Golang
tags:
  - drone
  - golang
  - git
  - gitea
---

![cover](https://i.imgur.com/2P2MVNK.png)

自己推行 [Drone][2] CI/CD 開源平台已經多年，很多人都會問我說，Drone 真的可以免費使用嗎？用在開源上面，或者是導入進公司內部團隊，這費用該怎麼計算呢？好的，本篇就帶大家了解 Drone 用在開源上或是公司內部團隊上需要注意的地方，官方其實有寫了一整頁 [FAQ 非常詳細][1]，底下是我整理幾點給大家知道。

[1]:https://docs.drone.io/enterprise/
[2]:https://www.drone.io/

<!--more-->

## 影片介紹

{{< youtube RZoVReQYGog >}}

影片視頻會同步放到底下課程內

* [Drone CI/CD DevOps 課程](https://blog.wu-boy.com/drone-devops/)

## 常見問題

底下整理幾點大家可能會比較想知道即該注意的地方，詳細的細節可以直接在官方 [FAQ 查看][1]

### Drone 共分幾種版本？

Drone 是一套完全開源的程式碼，詳細代碼可以在 [GitHub 上面找到][21]，而在這開源專案上面，總共可以區分為兩個版本，一個是 Open Source Edition 也就是俗稱開源專案，此專案的 License 為 [Apache License][22]，而另一個版本則是 Enterprise Edition 俗稱企業版本，但是這個企業版本也是[完全開源]的，而企業版本的 Licnese 為 [Polyform Small Business License][24]，所以各位在選用版本之前，請先看完 License 資訊，這兩個版本的代碼基本上就在同一個 repository 內。

[21]:https://github.com/drone/drone
[22]:https://www.apache.org/licenses/LICENSE-2.0
[23]:https://en.wikipedia.org/wiki/Source-available_software
[24]:https://polyformproject.org/licenses/small-business/1.0.0/

### 如何選擇開源或企業版本？

這邊其實很簡單可以區分，只要公司或組織的營業額小於 $1 million US dollars (台幣算 3000 萬)，都可以免費使用，裝企業或是開源版本都是可以的，所以不管你的身份是如何，只要營業額超過這數字，你就要開始付費的意思。那該如何試用企業版本呢？很簡單只需要按照[官方教學][31]即可，不過這邊有個限制，免費使用只能有 **5000** builds，這個限制一到，整個系統就不給試用了。

### 免費使用開源或企業版本

上一點有提到官方安裝步驟預設是安裝試用企業版本的，所以都有 **5000** builds 次數限制，要預設免除這個限制有兩種做法，第一種就是請使用 [Gitea][32] 或 [Gogs][33] 這兩套其中一套來當作 Git 服務，就不會有這限制，算是 Drone 給開源的福利，也算是幫忙推廣同樣是用 [Go 語言][41]開發的開源專案。第二種就是透過 Go 語言 go build 方式，而開源跟企業版本請用底下方式來 build 出新的 binary (底下是解除開源版本限制)

[41]: https://golang.org

```sh
go build -tags "oss nolimit" github.com/drone/drone/cmd/drone-server
```

要解除商業版本限制:

```sh
go build -tags "nolimit" github.com/drone/drone/cmd/drone-server
```

這邊要注意，在解除限制前，先找公司法務商量，公司營業額已經大於 100 萬美金的話，請不要用上述方式繞過限制，乖乖付錢比較實在。很多人問到為什麼 [Gitea][32] 或 [Gogs][33] 為什麼沒這限制，請參考底下代碼，[程式碼會說話](https://github.com/drone/drone/blob/4b7f52ad8a96e8e447f813d4b3de19ca30ff4b0d/service/license/load.go#L37-L56):

```go
// Trial returns a default license with trial terms based
// on the source code management system.
func Trial(provider string) *core.License {
  switch provider {
  case "gitea", "gogs":
    return &core.License{
      Kind:   core.LicenseTrial,
      Repos:  0,
      Users:  0,
      Builds: 0,
      Nodes:  0,
    }
  default:
    return &core.License{
      Kind:   core.LicenseTrial,
      Repos:  0,
      Users:  0,
      Builds: 5000,
      Nodes:  0,
    }
  }
}
```

[31]:https://docs.drone.io/server/overview/
[32]:https://gitea.io/en-us/
[33]:https://gogs.io/

### 開源 vs 企業版本差異

底下是官方列出來的企業版本功能

* Supports distributed runners
* Supports kubernetes runners
* Supports organization secrets, vault secrets, etc
* Supports cron scheduling
* Supports scalable storage (postgres, mysql, s3)
* Supports autoscaling
* Supports [extensions](https://docs.drone.io/extensions/overview/)

對比開源版本，多了底下限制

* Limited to a single machine
* Limited to an embedded sqlite database

不支援 Postgres 或 MySQL 資料庫，只能架設在單台機器上面。其他重要功能全都一樣，如果不是很介意這兩點，其實開源版本已經很夠用了。
