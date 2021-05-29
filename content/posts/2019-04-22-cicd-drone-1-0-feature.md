---
title: 'CI/CD 大亂鬥: Drone 1.0 功能介紹'
author: appleboy
type: post
date: 2019-04-22T03:34:16+00:00
url: /2019/04/cicd-drone-1-0-feature/
dsq_thread_id:
  - 7372674086
categories:
  - DevOps
  - Docker
  - Drone CI

---
[![drone ci/cd][1]][1]

很高興受到 [Devops Taiwan][2] 邀請到台北講『[Drone][3] CI/CD 1.0 新功能』，現場太多 CI/CD 工具一起 PK，有興趣可以看[活動網頁][4]。其實我在其他場合講過很多次 [Drone 的基礎][5]，所以這次上台北最主要探討 Drone 在今年 2019 Release 1.0 的一些重大功能，我相信大家在用舊的版本已經很順了，其實如果不升級到新的版本也是沒差。底下我會一一介紹 1.0 的新功能。有[共筆紀錄][6]，大家可以先參考看看。

<!--more-->

## 影片介紹

我自己在台北分享後，又自己錄製了一段，歡迎大家參考

如果喜歡 Drone 也可以參考 Udemy 影片: <http://bit.ly/drone-2019>

## 投影片

## 支援 Cloud 服務

Drone 也推出了 [Cloud 服務][7]讓開源專案可以免費使用，在去年以前，Drone 其實沒有 Cloud 服務，都是作者一個人買機器讓大家使用，現在 Drone 背後有[雲端服務 Packet][12][8] 提供硬體服務，所以現在 Drone 也可以推 Cloud 服務，但是太少人知道了，目前我將所有的開源專案也都轉到 Cloud 上面。

[![][9]][9]

Build Detail 頁面

[![][10]][10]

## 支援 ARM 及 Windows Platform

你沒看錯，Drone 開始支援原生 Windows Platform，也就是今天你想要在 Windows 上測試 .Net 程式碼，現在可以透過 Drone 來部署及測試了，這對於 Windows 用戶是一大福音，開發者現在可以包 Windows 容器運行在 Drone 平台。現在 Drone 團隊也陸陸續續將 Plugin 移植一份到 Windows Platform。

## 支援多主機架構 (Multi-Machine)

Drone 現在可以指定專案跑在哪一種架構上面，像是 ARM, Windows 或 AMD64，只要透過底下簡單的設定

<pre><code class="language-yaml">---
kind: pipeline

platform:
  arch: arm
  os: linux

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test</code></pre>

也可以在 YAML 設定將兩個 pipeline 丟給不同的主機去跑

<pre><code class="language-yaml">---
kind: pipeline
name: backend

platform:
  arch: arm
  os: linux

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

---
kind: pipeline
name: frontend

platform:
  arch: amd64
  os: linux

steps:
- name: build
  image: node
  commands:
  - npm install
  - npm test

depends_on:
- backend</code></pre>

## 平行處理

除了可以透過兩個 pipeline 丟給不同的主機跑之外，單一主機也是可以跑平行處理的

<pre><code class="language-yaml">---
kind: pipeline
name: default

steps:
- name: backend
  image: golang
  commands:
  - go build
  - go test

- name: frontend
  image: golang
  commands:
  - npm install
  - npm test

- name: build
  image: plugins/slack
  settings:
    channel: general
  depends_on:
  - backend
  - frontend</code></pre>

## 用程式寫 yaml 設定

之前寫過一篇『[有效率的用 jsonnet 撰寫 Drone CI/CD 設定檔][11]』，現在遇到相同的 YAML 設定都可以透過寫程式的方式來自動產生 YAML 設定了

<pre><code class="language-shell">local pipeline = import &#039;pipeline.libsonnet&#039;;
local name = &#039;drone-ssh&#039;;

[
  pipeline.test,
  pipeline.build(name, &#039;linux&#039;, &#039;amd64&#039;),
  pipeline.build(name, &#039;linux&#039;, &#039;arm64&#039;),
  pipeline.build(name, &#039;linux&#039;, &#039;arm&#039;),
  pipeline.release,
  pipeline.notifications(depends_on=[
    &#039;linux-amd64&#039;,
    &#039;linux-arm64&#039;,
    &#039;linux-arm&#039;,
    &#039;release-binary&#039;,
  ]),
]</code></pre>

## 支援外部 Secret 管理

Drone 正式支援 [Vault][12], [Kubernetes Secret][13] 或 [AWS Secret][14]，團隊可以將 Drone 安裝在 k8s 或 AWS 容器內，並且使用期 Secret 管理工具，當然也可以整合大家喜歡的 Vault。

<pre><code class="language-yaml">---
kind: secret
name: slack_webhook
get:
  path: secret/data/slack
  name: webhook

---
kind: pipeline
name: default

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

- name: notify
  image: plugins/slack
  settings:
    channel: general
    webhook:
      from_secret: slack_webhook</code></pre>

## 支援 Global Secret

除了上述支援 Secret Manager 以外，現在作者也支援了 Global Secret，這個功能相當重要，在 0.5 有此版本，但是 0.8 被拔掉，現在 1.0 又被加回來了，詳細 commit 可以[參考這邊][15]，未來可以在 UI 或者是 CLI 設定 Organization Secret，套用到底下全部 repository 了。

## 支援 Cron Job

1.0 也正是透過 UI 可以設定 Cron Job，這對於寫 Firmware 的開發者非常有幫助，半夜都需要跑 Daily build 產出相對應的 binary，現在可以透過後台直接設定了，在 Yaml 內也可以指定 pipeline 跑 cron job。

<pre><code class="language-yaml"># example when configuration
when:
  cron: [ nightly ]

# example trigger configuration
trigger:
  cron: [ nightly ]</code></pre>

## 支援 Gitlab 或 bitbucket YAML 設定轉換

如果有在用 Gitlab CI 的團隊，現在可以透過 Drone CLI 直接將 YAML 設定檔轉換到 Drone 了，以 Gitlab CI 為例:

<pre><code class="language-shell">$ drone convert .gitlab-ci.yml</code></pre>

底下是 `.gitlab-ci.yml`

<pre><code class="language-yaml">image: ruby:2.2

services:
  - postgres:9.3

before_script:
  - bundle install

test:
  script:
  - bundle exec rake spec</code></pre>

轉換後

<pre><code class="language-yaml">---
kind: pipeline
name: test

platform:
  os: linux
  arch: amd64

steps:
- name: test
  image: ruby:2.2
  commands:
  - bundle install
  - bundle exec rake spec

services:
- name: postgres-9-3
  image: postgres:9.3

...</code></pre>

也可以直接從後台設定讀取 gitlab ci 設定

[![][16]][16]

## 指定 Agent 機器

現在 drone 可以讓 JOB 指定機器執行，也就是假設有一個 job 需要 CPU 或記憶體非常高的機器來 跑，可以透過 YAML 來指定

<pre><code class="language-yaml">kind: pipeline
name: default

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

node:
  instance: highmem</code></pre>

## 心得

drone 1.0 真的很多新功 能都很吸引開發者，大家可以先到 cloud 服務測試，再決定是不是要在公司內自己架設一台。如果大家對於 drone 有興趣，也可以參考我在 [Udemy 上面的教學][17]。

 [1]: https://lh3.googleusercontent.com/8kk2MLpEg38HGO6sYA2r1EOaJ6mNjhsS65H1tRwKSbmSgdhr-mRh6UH2tQwVucMNtMAbbIoa5DHn1mu-lcX-P6fKbRrs-sRJ3N9DjdaHwE-RS4RqxqYdwE6GO1mtyTtdvgdAFTAJ7ws=w1920-h1080 "drone ci/cd"
 [2]: https://www.facebook.com/groups/DevOpsTaiwan/
 [3]: https://github.com/drone/drone
 [4]: https://devopstw.club/
 [5]: https://www.slideshare.net/appleboy/drone-cicd-platform
 [6]: https://hackmd.io/ijAIcc3KRZmBHwrrB96epg
 [7]: https://cloud.drone.io/
 [8]: https://www.packet.com/
 [9]: https://lh3.googleusercontent.com/CoodGpWeSuPjA3Ke3aULRZzj-WcQ2H5bQebO1dGEv8DlyFfN4LZYfhl-RQEcwl--nKdPlN6Vn-79m3j4P5Up5SYgen2rX25evsyBn7FWDN1Nnv6_65Z9WmckJUWtwnBpFvbHkdwqrXw=w1920-h1080
 [10]: https://lh3.googleusercontent.com/QYYs_hUw1JyH5r4j04IfmXW1DrL6Vw7YuoopZZQhscRnQaA3VBkJcY4Ttw502HQtdhlSMOLtZ8bXjIDcuAj3_e-aK3E9Epupc7qN17B1S7wjzFlIzyqJ-lvu5CPBWi-8T8m0wKHRD_I=w1920-h1080
 [11]: https://blog.wu-boy.com/2019/01/converts-a-jsonnet-configuration-file-to-a-yaml-in-drone/
 [12]: https://www.vaultproject.io/
 [13]: https://kubernetes.io/docs/concepts/configuration/secret/
 [14]: https://aws.amazon.com/secrets-manager
 [15]: http://bit.ly/drone-org-secrets
 [16]: https://lh3.googleusercontent.com/w0D7rQcRvjnO2XPZSlpyRPDwSEJPlg7h3OOsIg9n7f32B_ceuOMxyAnrzvsR99NCcIlTooKn2XyjgSITATldw_2KB_JS3ucVhAO0JOpva8gWLlg_9FuV4l8x_vUlL_9I4qiOAh9FOcE=w1920-h1080
 [17]: http://bit.ly/drone-2019