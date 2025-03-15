---
title: "Gitea 與 Jira 軟體開發流程整合"
date: 2025-03-15T08:42:24+08:00
author: appleboy
type: post
slug: gitea-jira-integration-zh-tw
share_img: /images/2025-03-15/blog-logo.png
categories:
  - git
  - gitea
  - jira
---

![blog logo](/images/2025-03-15/blog-logo.png)

在本文開始前，先介紹什麼是 [Gitea][2] 和 [Jira][1]。以及提前看完『[Git 軟體開發指南：提高團隊協作的關鍵][0]』

[0]: https://blog.wu-boy.com/2025/01/git-software-development-guide-key-to-improving-team-collaboration-zh-tw/

[Gitea][2] 是一款由 Go 語言開發的自助式 Git 服務器，提供了一個輕量級、易於安裝和使用的 Git 服務器解決方案。Gitea 支援多種操作系統，包括 Linux、Windows 和 macOS，並提供了豐富的功能，如代碼審查、問題追蹤、Wiki 等，幫助團隊更好地協作開發。

[Jira][1] 是一款由 Atlassian 開發的專案管理和議題追蹤軟體。它廣泛應用於軟體開發團隊，用於計劃、追蹤和管理軟體專案。Jira 提供了豐富的功能，包括議題管理、敏捷開發支援（如 Scrum 和 Kanban）、報告和分析工具等，幫助團隊提高工作效率和協作能力。

[1]: https://www.atlassian.com/software/jira
[2]: https://about.gitea.com/

<!--more-->

## 問題描述

部門團隊在開發軟體時，通常會使用 Git 作為版本控制系統，並使用 Gitea 作為 Git 服務器。開發人員在進行代碼開發時，會搭配 Jira 進行議題管理，以追蹤和解決問題。然而，由於 Gitea 和 Jira 是兩個獨立的系統，我們需要將開發紀錄的 Commit 與 Jira 的議題進行關聯，以便更好地追蹤和管理代碼開發過程。

可是 Jira 系統在市面上整合 Git 服務器的方案有很多，例如 Bitbucket、GitHub、Gitlab 等，但是對於 Gitea 這類自建 Git 服務器的整合方案就比較少見，所以其實在 Gitea 社群就有人[提出這問題][11]，希望能夠找到一個解決方案。

[11]: https://github.com/go-gitea/gitea/issues/25852

團隊找到一個整合 Git 的 Jira 插件，但是這個插件如果要實現 Gitea 與 Jira 的整合，底層實作方式就是 Jira 會定期掃描 Git 服務器的 Commit 紀錄，並將 Commit 與 Jira 的議題進行關聯。這樣的方式雖然能夠實現 Gitea 與 Jira 的整合，但是效率並不高，且需要 Jira 服務器能夠連線到 Git 服務器，並且下載原始碼才能拿到歷史紀錄，這樣的設定在一些環境下可能會有安全性的疑慮。至少像是我們公司團隊太多，每個部門對於資料的存取權限都有所限制，所以這樣的設定在我們公司是不被允許的。

為了解決這個問題，我們團隊決定自行開發一個整合 Gitea 與 Jira 的解決方案，以提高整合效率和安全性。也就是 Jira 服務不需要去跟 Gitea 服務器溝通，而是由 Gitea 服務器主動將 Commit 與 Jira 的議題進行關聯，這樣的設計不僅能夠提高效率，也能夠保護資料的安全性。使用的方式也很簡單，就是透過 [Gitea Action][22] 搭配 [Jira API][23] 進行整合。底下是整和後的示意圖

[22]: https://docs.gitea.com/usage/actions/overview
[23]: https://developer.atlassian.com/server/jira/platform/rest/v10004/

![comment](/images/2025-03-15/jira-git-comment.png)

可以清楚看到只要在 Commit Log 裡面記錄 Jira 的議題編號，就可以在 Jira 的議題裡面看到 Commit 的內容，這樣就能夠更好地追蹤和管理代碼開發過程。

## 設計流程

團隊可以在執行專案前，把軟體開發流程跟 Jira 狀態進行對應，這樣就能夠更好地追蹤專案的進度。例如，我們可以設計一個簡單的軟體開發流程，包括以下幾個狀態：

1. Backlog：待處理的議題
2. Open: 開發中的議題
3. In Progress: 正在進行的議題
4. Code Review: 代碼審查中的議題
5. Under Test: 測試中的議題
6. Resolved: 已解決的議題
7. Closed: 已關閉的議題

![flow](/images/2025-03-15/jira-software-flow.png)

上述是一個簡單的軟體開發流程，團隊可以根據實際情況進行調整。在這個流程中，每個議題都有一個狀態，開發人員在進行代碼開發時，可以根據議題的狀態進行相應的操作，以便更好地追蹤和管理代碼開發過程。而我把底下幾個狀態對應到 Git 流程操作。

1. Backlog -> In Progress: 建立新的分支進行開發
2. In Progress -> Code Review: 提交代碼進行審查
3. Code Review -> Resolved: 代碼審查通過

我們希望開發者能夠遵守上述流程，並且透過提交 Git Commit，來自動化更新 Jira 的議題狀態。

## 用 Gitea Action 整合 Jira

Gitea Action 是 Gitea 提供的一個功能，可以在 Git Commit 時觸發指定的操作，例如發送郵件、通知 Slack、執行腳本等。我們可以使用 Gitea Action 來整合 Jira，實現 Commit 與 Jira 的自動關聯。

為什麼會選擇 Gitea Action 呢？因為 Gitea Action 是 Gitea 提供的原生功能，它可以讀取更多 Git 操作 Event，例如 Push、Pull Request、Issue Comment 等，這樣就能夠更靈活地進行整合。可以直接參考 [appleboy/jira-action](https://github.com/appleboy/jira-action) 這個專案。

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

這段 YAML 配置文件的作用是使用 Gitea Action 來整合 Jira，實現當建立新的分支時，自動將對應的 Jira 議題狀態轉換為 "In Progress"，並且將議題指派給當前的開發人員。其中 `ref` 就是帶入現在建立的分支名稱，`transition` 就是 Jira 的狀態名稱，`assignee` 就是指派的人員。

### 提交代碼

開發者提交任何 Commit 時，都需要在 Commit Log 中記錄 Jira 的議題編號，例如 `GAIS-123`。這樣就能夠自動將 Commit 與 Jira 的議題進行關聯。

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

可以看到 Action 接受到 Push Event 後，會去讀取 Commit Log 的內容，並且找到 Jira 的議題編號，然後自動將對應的 Jira 議題狀態轉換為 "In Progress"，並且將議題指派給當前的開發人員。同時，Action 會在 Jira 的議題中留下一條 Comment，記錄 Commit 的詳細信息。

![push event](/images/2025-03-15/gitea-push-event.png)

### 提交代碼進行審查

可以看到偵測 Pull Request 狀態 [`opened`, `closed`]，並且將對應的 Jira 議題狀態轉換為 `Code Review`。

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

### 代碼審查通過

可以看到偵測 Pull Request 狀態 `closed`，並且將對應的 Jira 議題狀態轉換為 `Resolved`。

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

除了上述狀態轉換外，你可以根據實際情況進行調整，例如在代碼審查通過後，自動發送郵件通知相關人員，或者在代碼合併後，自動部署代碼到測試環境。這樣就能夠更好地追蹤和管理代碼開發過程。透過 Gitea Action 好處就是可以處理多種不同的 Event，這樣就能夠更靈活地進行整合。

## 結論

通過上述整合設計流程，我們團隊成功實現了 Gitea 與 Jira 的無縫對接。這個整合不僅提升了工作效率，也確保了系統安全性。開發者只需在 Commit 訊息中標註 Jira 議題編號，系統就會自動建立關聯，大幅簡化了追蹤和管理流程。同時，我們制定了一套清晰的軟體開發流程指南，協助團隊成員遵循標準作業流程，有效提升了團隊協作效率。

目前團隊正在執行一個規模龐大的專案，擁有約 20 位開發人員。從專案啟動至今兩年間，已累積將近 5000 個 Issue，且每天仍以十餘個 Issue 的速度持續增長。若缺乏這類自動化工具的整合，要有效管理如此大量的 Issue 將會是一大挑戰。

透過 Gitea 和 Jira 的整合方案，我們不僅解決了 Issue 管理的困擾，更全面優化了開發流程。相較於過去開發者需要手動在 Jira 上更新狀態的作法，自動化流程不但提高了效率，也顯著降低了人為失誤的風險。這套整合方案為團隊帶來了顯著的效益，證明了自動化工具在大規模軟體開發專案中的重要性。
