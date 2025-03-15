---
title: "Gitea 與 Jira 軟體開發流程整合"
date: 2025-03-15T08:42:24+08:00
author: appleboy
type: post
slug: gitea-integrate-with-jira-issue-tracking-flow-zh-tw
share_img: /images/2025-03-15/blog-logo.png
categories:
  - git
  - gitea
  - jira
---

![blog logo](/images/2025-03-15/blog-logo.png)

在開始本文前，讓我們先來了解 [Gitea][2] 和 [Jira][1] 這兩個工具。建議您可以先閱讀『[Git 軟體開發指南：提高團隊協作的關鍵][0]』，以更好地理解後續內容。

[0]: https://blog.wu-boy.com/2025/01/git-software-development-guide-key-to-improving-team-collaboration-zh-tw/

[Gitea][2] 是一套以 Go 語言開發的輕量級自架式 Git 伺服器，為團隊提供了便於部署的程式碼管理方案。系統除了支援 Linux、Windows 和 macOS 等多種作業系統外，還具備完善的程式碼審查、問題追蹤和 Wiki 等功能，能大幅提升團隊的協作開發效率。

[Jira][1] 是 Atlassian 公司開發的專業級專案管理與問題追蹤系統。作為軟體開發團隊廣泛採用的工具，Jira 不僅提供完整的問題追蹤功能，還支援敏捷開發流程（如 Scrum 和 Kanban）以及豐富的數據分析功能，有效協助團隊管理專案進度並提升協作品質。

[1]: https://www.atlassian.com/software/jira
[2]: https://about.gitea.com/

<!--more-->

## 問題描述

在我們部門的軟體開發過程中，Git 是主要的版本控制系統，而 Gitea 則作為 Git 伺服器使用。開發團隊在進行程式開發時，會搭配 Jira 進行議題追蹤與管理。然而，由於 Gitea 和 Jira 是兩個獨立的系統，如何有效地建立程式碼提交（Commit）與 Jira 議題之間的關聯，成為我們需要解決的重要課題。

目前市面上雖然有許多 Jira 整合 Git 服務的方案，例如整合 Bitbucket、GitHub、GitLab 等，但對於像 Gitea 這類自建的 Git 伺服器，整合方案相對較少。這個問題在 Gitea 社群中也有人[提出討論][11]，希望能找到合適的解決方案。

[11]: https://github.com/go-gitea/gitea/issues/25852

團隊找到了一個整合 Git 的 Jira 插件，但這個插件在實現 Gitea 與 Jira 整合時，其底層實作方式是由 Jira 定期掃描 Git 服務器的 Commit 紀錄，並將 Commit 與 Jira 議題建立關聯。雖然這種方式能夠達到 Gitea 與 Jira 的整合目的，但效率並不理想，而且需要 Jira 服務器能夠直接連線到 Git 服務器並下載原始碼才能取得歷史紀錄。這樣的設定在某些環境下可能會產生安全性疑慮，尤其是在我們這樣的大型企業中，由於各部門對資料存取權限都有嚴格限制，因此這種整合方式是不被允許的。

為了解決這個問題，我們團隊決定自行開發一套 Gitea 與 Jira 的整合方案，以提升效率並確保資料安全。我們採用了讓 Gitea 服務主動將 Commit 與 Jira 議題建立關聯的設計，而不是由 Jira 服務去存取 Gitea 伺服器。這樣的架構不僅能大幅提升效率，更能確保資料存取的安全性。實作方式相當簡單，主要是透過 [Gitea Action][22] 搭配 [Jira API][23] 來完成整合。以下是整合後的示意圖：

[22]: https://docs.gitea.com/usage/actions/overview
[23]: https://developer.atlassian.com/server/jira/platform/rest/v10004/

![comment](/images/2025-03-15/jira-git-comment.png)

透過在 Commit Log 中記錄 Jira 議題編號，開發者可以直接在 Jira 議題中查看相關的 Commit 內容，有效提升程式碼開發過程的追蹤與管理效率。

## 設計流程

在專案執行前，團隊需要先將軟體開發流程與 Jira 狀態進行對應，以便更有效地追蹤專案進度。以下是我們設計的基本軟體開發流程狀態：

1. **Backlog**：待處理的議題
2. **Open**：開發中的議題
3. **In Progress**：進行中的議題
4. **Code Review**：程式碼審查中
5. **Under Test**：測試階段
6. **Resolved**：已解決
7. **Closed**：已結案

![flow](/images/2025-03-15/jira-software-flow.png)

這是一個基礎的軟體開發流程框架，團隊可以根據實際需求進行調整。在這個流程中，每個議題都具備特定狀態，開發人員可以依據議題狀態執行相對應的操作，確保開發過程能被有效追蹤和管理。我們將以下幾個關鍵狀態轉換與 Git 流程做了對應：

1. **Backlog** → **In Progress**：開啟新分支進行開發
2. **In Progress** → **Code Review**：提交程式碼進行審查
3. **Code Review** → **Resolved**：程式碼審查完成

我們期望開發團隊能確實遵循上述流程，並透過 Git Commit 自動更新 Jira 議題狀態，讓整個開發過程更加流暢且自動化。

## 用 Gitea Action 整合 Jira

Gitea Action 是 Gitea 平台所提供的核心功能之一，它能在 Git 操作發生時（如 Commit、Push 等）自動觸發預設的任務，例如發送電子郵件通知、傳送 Slack 訊息或執行自訂腳本等。我們可以善用這項功能來實現 Gitea 與 Jira 的自動化整合，讓 Commit 與 Jira 議題之間建立即時關聯。

為何我們會特別選擇 Gitea Action 來實現這個整合呢？主要是因為它是 Gitea 的原生功能，不僅能完整支援各種 Git 操作事件（如 Push、Pull Request、Issue Comment 等），還可以更靈活地處理整合需求。若您想了解更多實作細節，可以參考 [appleboy/jira-action](https://github.com/appleboy/jira-action) 這個開源專案。

### 建立新的分支

```yaml
name: jira integration

on:
  create:
    types:
      - branch

jobs:
  jira-branch:
    runs-on: ubuntu-latest
    if: github.event.ref_type == 'branch'
    name: create new branch
    steps:
      - name: transition to in progress on branch event
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.ref_name }}
          transition: "Start Progress"
          assignee: ${{ github.actor }}
```

這段 YAML 配置檔案使用 Gitea Action 來整合 Jira，當開發者建立新分支時，系統會自動將對應的 Jira 議題狀態更新為「In Progress」，同時將該議題指派給目前的開發人員。在配置中，`ref` 參數會自動帶入新建分支的名稱，`transition` 用於指定 Jira 的狀態名稱，而 `assignee` 則用於設定議題負責人。

### 提交程式碼

在開發過程中，每次提交程式碼時（Commit），開發者需要在提交訊息（Commit Log）中加入 Jira 議題編號（如 `GAIS-123`）。透過這個方式，系統就能自動將程式碼提交與對應的 Jira 議題建立關聯。

```yaml
name: jira integration

on:
  push:
    branches:
      - "*"

jobs:
  jira-push-event:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    name: transition to in progress on push event
    steps:
      - name: transition to in progress on push event
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.event.head_commit.message }}
          transition: "Start Progress"
          assignee: ${{ github.event.head_commit.author.username }}
          comment: |
            🧑‍💻 [~${{ github.event.pusher.username }}] push code to repository

            See the detailed information from [commit link|${{ github.event.head_commit.url }}].

            ${{ github.event.head_commit.message }}
```

當 Action 收到 Push Event 後，會自動解析 Commit Log 內容並擷取 Jira 議題編號，接著將對應的 Jira 議題狀態更新為 `In Progress`，同時指派給目前的開發人員。此外，Action 也會在 Jira 議題中新增一則註解，記錄此次 Commit 的詳細資訊。

![push event](/images/2025-03-15/gitea-push-event.png)

### 提交程式碼進行審查

系統會監控 Pull Request 的狀態變更（[`opened`, `closed`]），並自動將對應的 Jira 議題狀態更新為「Code Review」。

```yaml
on:
  pull_request_target:
    types: [opened, closed]

jobs:
  open-pull-request:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request_target' && github.event.action == 'opened'
    name: transition to in review when pull request is created
    steps:
      - name: transition to in review when pull request is created
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.event.pull_request.title }}
          transition: "Finish Coding"
```

![pull request](/images/2025-03-15/gitea-pull-request-event.png)

### 程式碼審查完成

系統會監控 Pull Request 的狀態，當偵測到狀態變更為 `closed` 時，會自動將對應的 Jira 議題狀態更新為「Resolved」。

```yaml
name: jira integration

on:
  pull_request:
    types:
      - closed

jobs:
  jira-merge-request:
    runs-on: ubuntu-latest
    if: ${{ github.event.pull_request.merged }}
    name: transition to Merge and Deploy
    steps:
      - name: transition to in review
        uses: appleboy/jira-action@v0.2.0
        with:
          base_url: https://xxxxx.com
          insecure: true
          token: ${{ secrets.JIRA_TOKEN }}
          ref: ${{ github.event.pull_request.title }}
          transition: "Merge and Deploy"
          resolution: "Fixed"
```

![pull request](/images/2025-03-15/gitea-merged-pr.png)

除了上述狀態轉換外，你還可以根據實際需求進行調整，例如在程式碼審查通過後自動發送電子郵件通知相關人員，或是在程式碼合併後自動部署至測試環境。這些自動化流程能夠更有效地追蹤和管理程式碼開發過程。Gitea Action 最大的優勢在於它能處理多種不同的事件，讓整合方案更具彈性。

## 結論

透過上述整合設計流程，我們團隊成功實現了 Gitea 與 Jira 的無縫串接。這套整合方案不僅提升了工作效率，也確保了系統安全性。開發者只需在 Commit 訊息中標註 Jira 議題編號，系統就會自動建立關聯，大幅簡化了追蹤和管理流程。同時，我們也制定了一套完整的軟體開發流程指南，協助團隊成員遵循標準作業流程，有效提升團隊協作效率。

目前團隊正在執行一個規模龐大的專案，共有約 20 位開發人員參與其中。從專案啟動至今兩年間，已累積將近 5000 個議題，且每天仍以十餘個議題的速度持續成長。若沒有這類自動化工具的輔助，要有效管理如此大量的議題將是一大挑戰。

透過 Gitea 和 Jira 的整合方案，我們不僅解決了議題管理的困擾，更全面優化了開發流程。相較於過去開發者需要手動在 Jira 上更新狀態的做法，自動化流程不但提高了效率，也顯著降低了人為失誤的風險。這套整合方案為團隊帶來了顯著的效益，充分展現了自動化工具在大規模軟體開發專案中的重要性。
