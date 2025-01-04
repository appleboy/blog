---
title: "Git 軟體開發指南：提高團隊協作的關鍵"
date: 2025-01-04T09:04:38+08:00
author: appleboy
type: post
slug: git-software-development-guide-key-to-improving-team-collaboration
share_img: /images/2025-01-04/git-flow.png
categories:
  - git
  - gitea
---

## 前言

[Git][1] 是一個分散式版本控制系統，由 [Linus Torvalds][2] 開發，用於管理 Linux 核心的原始碼。Git 的設計目標是速度、資料完整性、支援非線性開發（多分支）、強大的分支管理等，因此廣泛地應用於軟體開發領域。而要有效地使用 Git，除了熟悉 Git 的基本操作外，更重要的是要掌握 Git 的工作流程，這樣才能更好地協作開發。本文將介紹一些 Git 軟體開發指南，幫助團隊提高協作效率。

由於團隊開發的複雜性，Git 的使用也變得更加困難。為了提高團隊協作的效率，我們需要制定一套 Git 軟體開發指南，以規範團隊成員的操作行為，確保代碼庫的穩定性和可維護性。大家遵守一定的原則，可以加速開發進程，減少錯誤，提高代碼品質。

[1]: https://en.wikipedia.org/wiki/Git
[2]: https://en.wikipedia.org/wiki/Linus_Torvalds

## Git 軟體開發流程圖

以下是一個簡單的 Git 軟體開發流程圖，用於說明團隊成員之間如何協作開發：

![logo](/images/2025-01-04/git-flow.png)

上面流程不一定適用於所有的團隊，但是可以作為參考，根據實際情況進行調整。接下來，我們將介紹一些 Git 軟體開發指南，幫助團隊提高協作效率。

<!--more-->

## 01. Git 前置作業

在開始使用 Git 進行軟體開發之前，我們需要做一些前置作業，確保團隊成員都能夠正確地使用 Git，這些前置作業包括：

- 請先設定好自己的 git user name 及 email

```bash
git config --global user.name "Bo-Yi Wu"
git config --global user.email "bo-yi.wu@example.com"
```

- 設定 Git Commit Signature Verification 請參考此文章操作『[快速設定 Git Commit Signature Verification][3]』
- 檢查上述兩項是否已經設定完成

```bash
git config --global --list
```

可以看到以下設定：

```bash
user.name=Bo-Yi Wu
user.email=bo-yi.wu@example.com
user.signingkey=/Users/xxxxxxx/.ssh/id_rsa.pub
```

[3]: https://blog.wu-boy.com/2023/10/git-commit-signature-verification/

由於我們團隊使用的是 [Gitea][4] 作為 Git 服務器，可以到個人設定頁面看到綠色標誌

![logo](/images/2025-01-04/gitea-signature-verification.png)

接下來可以測試是否可以正確的簽署 commit，正常需要看到底下畫面 (有看到自己的 Commit 顯示綠色框框)，這樣就是證明此 Commit 是由你本人所發布的。

![logo](/images/2025-01-04/gitea-commit-signature.png)

[4]: https://gitea.com/

## 02. 創建新 Repository 準則

大家在創建新的 Repository 時，應該遵守一定的準則，以確保 Repository 的統一性和可維護性。以下是一些創建新 Repository 的準則：

- Repository 名稱應該具有描述性，能夠清楚地表達 Repository 的用途。
- Repository 的 `README.md` 文件應該包含專案的描述、安裝說明、使用說明等內容。
- Repository 的 `LICENSE` 文件應該包含專案的授權信息，確保代碼的合法性。
- Repository 的 `.gitignore` 文件應該包含忽略的文件和目錄，避免將不必要的文件提交到版本庫中。

除了上面的準則外，還可以根據實際情況進行調整，確保 Repository 的統一性和可維護性。底下兩點是不熟悉軟體版本控制會犯的錯誤，請務必避免：

- 不要將大型二進制文件提交到版本庫中，這樣會導致版本庫過大，影響性能。
- 不要將機密信息提交到版本庫中，這樣會導致信息泄露，造成安全風險。

另外公司內部的 Git 服務器存放的 Repository 不只有一個團隊，公司總共 1 萬人，為了避免不必要的爭議，請遵守以下規則：

- 請勿在**個人帳戶**下建立 Repository 來與其他團隊合作。
- 所有 Repository 請以 **Private** 方式建立，勿公開代碼。如果需要公開，請先與各部門主管討論。論

## 03. 軟體開發流程準則

### 3.1. 分支管理

請採用 GitHub Flow 為準則，減少團隊溝通成本，詳細原因可以參考『[GitHub Flow 及 Git Flow 流程使用時機][33]』，開 branch 時，請跟 Jira Issue 連結，例如要解決 Issue GAIS-3210，可以透過底下指令開 branch

```bash
git checkout -b GAIS-3210
git push origin GAIS-3210
```

[33]: https://blog.wu-boy.com/2017/12/github-flow-vs-git-flow/

### 3.2 Commit Message 規範

- 清晰和簡潔: 提交信息應該簡潔明了，描述所做的更改，請參考 [Conventional Commits][35]。
- 格式: 使用標準格式，例如：`refactor(GAIS-2892): improve HTTP response handling and concurrency control`

[35]: https://www.conventionalcommits.org/

類型可以是 feat (新功能), fix (修復), docs (文檔), style (格式), refactor (重構), test (測試), chore (雜務) 等。

其中 `GAIS-2892` 是對應到 Jira 單號。Gitea 系統可以跟 Jira 單號連結整合。

```bash
feat(ui): Add `Button` component
^    ^    ^
|    |    |__ Subject
|    |_______ Scope
|____________ Type
```

引入 [Gitea Action][36] 的 [semantic-pull-request][34] 做自動化檢查

![logo](/images/2025-01-04/gitea-semantic-pull-request.png)

[34]: https://github.com/marketplace/actions/semantic-pull-request
[36]: https://docs.gitea.com/usage/actions/overview

### 3.3. 程式碼審查 (Code Review)

- 拉取請求 (Pull Request): 所有的更改應該通過 PR 進行，且需要<font color="red">至少一個團隊成員的審查和批准</font>。
- 自動化測試: 合併之前，確保所有自動化測試都通過。團隊使用 Gitea Action 自動化測試。
- 合併請使用 <font color="red">Squash Commit</font>: 保持歷史紀錄的乾淨，可以避免不必要的 Merge Commit。

![logo](/images/2025-01-04/gitea-squash-commit.png)

### 3.4. 版本發布

- 標籤 (Tags): 使用標籤來標記重要的版本點，例如 v1.0.0。
- 語義化版本控制 ([Semantic Versioning][42]): 遵循語義化版本控制規則，版本號格式為 MAJOR.MINOR.PATCH。
- Gitea Action 請整合 Push 及 Tag 自動化部署測試站及正式站
- 透過 [goreleaser][41] 工具可以快速產生 Release Note

[41]: https://goreleaser.com/
[42]: https://semver.org/

![logo](/images/2025-01-04/gitea-release-note.png)

### 3.5. 安全性

- 軟體開發過程中，請勿將個人敏感資訊放入 git repo 中
  - 請使用 `.env` 文件來存放敏感資訊
  - 將 `.env` 文件加入 `.gitignore` 列表中
- 部署相關的敏感資訊請直接設定在 Gitea Secret 中

![logo](/images/2025-01-04/gitea-secret.png)

### 3.6 開發文件

相信大家都有遇過不知道該如何將服務跑在自己的環境，請相關開發者務必詳細撰寫 README.md 文件，讓未來的同事可以參照：

- 如何安裝
- 如何執行
- 如何測試
- 如何部署
- 如何使用

### 3.7 代碼規範

一致性: 遵循團隊約定的[代碼風格指南][40]，保持代碼的一致性。底下是開發 Go 語言專案的代碼風格指南：

[40]: https://google.github.io/styleguide/

- 使用 [golangci-lint][43] 工具來檢查代碼規範
- 使用 [gofmt][44] 工具來格式化代碼
- 使用 [go vet][45] 工具來檢查代碼規範

[43]: https://golangci-lint.run/
[44]: https://golang.org/cmd/gofmt/
[45]: https://pkg.go.dev/golang.org/x/tools/cmd/vet

## 總結

本文提供了一些 Git 軟體開發指南，旨在提高團隊協作效率。主要內容包括：

1. **前置作業**：確保團隊成員正確設定 Git 使用者名稱、電子郵件和提交簽名驗證。
2. **創建新 Repository 準則**：
   - 使用描述性名稱
   - 包含 `README.md`、`LICENSE` 和 `.gitignore` 文件
   - 避免提交大型二進制文件和機密信息
   - 在公司內部遵守建立私有 Repository 的規則
3. **軟體開發流程準則**：
   - **分支管理**：採用 GitHub Flow，並與 Jira Issue 連結
   - **Commit Message 規範**：使用 Conventional Commits 格式
   - **程式碼審查**：通過 PR 進行更改，並使用自動化測試
   - **版本發布**：使用標籤和語義化版本控制，並整合自動化部署
   - **安全性**：使用 `.env` 文件和 Gitea Secret 存放敏感信息
   - **開發文件**：詳細撰寫 `README.md` 文件，包含安裝、執行、測試、部署和使用說明
   - **代碼規範**：遵循代碼風格指南，使用工具檢查和格式化代碼

以上是一些 Git 軟體開發指南，幫助團隊提高協作效率。當然，這些指南只是一個參考，具體的實踐還需要根據團隊的實際情況進行調整。希望這些指南能夠幫助你更好地使用 Git，提高團隊的協作效率。
