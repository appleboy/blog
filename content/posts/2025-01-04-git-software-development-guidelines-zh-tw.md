---
title: "Git 軟體開發指南：提高團隊協作的關鍵"
date: 2025-01-04T09:04:38+08:00
author: appleboy
type: post
slug: git-software-development-guide-key-to-improving-team-collaboration-zh-tw
share_img: /images/2025-01-04/git-flow.png
categories:
  - git
  - gitea
---

## 前言

[Git][1] 是一套分散式版本控制系統，由 [Linus Torvalds][2] 所開發，主要用於管理 Linux 核心的原始碼。Git 的主要特色包含了快速的處理速度、完整的資料保護、支援多分支的非線性開發，以及強大的分支管理功能，這些特色使其成為軟體開發領域中不可或缺的工具。要有效地運用 Git，除了要熟悉基本操作外，更重要的是要掌握其工作流程，才能達到最佳的團隊協作效果。本文將為您介紹一套實用的 Git 軟體開發指南，協助團隊提升協作效率。

隨著團隊規模的擴大，Git 的使用也變得更加複雜。為了確保團隊協作的順暢，我們必須建立一套完整的 Git 軟體開發指南，規範團隊成員的操作行為，以維持程式碼庫的穩定性與可維護性。遵循這些規範不僅能加快開發進度，更能減少錯誤發生的機會，進而提升程式碼品質。

[1]: https://en.wikipedia.org/wiki/Git
[2]: https://en.wikipedia.org/wiki/Linus_Torvalds

## Git 軟體開發流程圖

以下是一個簡單的 Git 軟體開發流程圖，用於說明團隊成員之間如何協作開發：

![logo](/images/2025-01-04/git-flow.png)

上述流程不一定適用於所有團隊，但可作為參考，並根據實際情況進行調整。接下來，我們將介紹一些 Git 軟體開發指南，幫助團隊提高協作效率。

<!--more-->

## 01. Git 前置作業

在開始使用 Git 進行軟體開發之前，我們需要做一些前置作業，確保團隊成員都能夠正確地使用 Git。這些前置作業包括：

- 請先設定好自己的 Git 使用者名稱及電子郵件

```bash
git config --global user.name "Bo-Yi Wu"
git config --global user.email "bo-yi.wu@example.com"
```

- 設定 Git 提交簽名驗證，請參考此文章操作『[快速設定 Git 提交簽名驗證][3]』
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

接下來可以測試是否可以正確地簽署 commit，正常情況下應該會看到如下畫面（顯示自己的 Commit 並有綠色框框），這樣就證明此 Commit 是由你本人所發布的。

![logo](/images/2025-01-04/gitea-commit-signature.png)

[4]: https://gitea.com/

## 02. 創建新 Repository 準則

大家在創建新的 Repository 時，應該遵守一定的準則，以確保 Repository 的統一性和可維護性。以下是一些創建新 Repository 的準則：

- Repository 名稱應該具有描述性，能夠清楚地表達 Repository 的用途。
- Repository 的 `README.md` 文件應該包含專案的描述、安裝說明、使用說明等內容。
- Repository 的 `LICENSE` 文件應該包含專案的授權信息，確保代碼的合法性。
- Repository 的 `.gitignore` 文件應該包含忽略的文件和目錄，避免將不必要的文件提交到版本庫中。

除了上面的準則外，還可以根據實際情況進行調整，確保 Repository 的統一性和可維護性。以下是一些常見錯誤，請務必避免：

- 不要將大型二進制文件提交到版本庫中，這樣會導致版本庫過大，影響性能。
- 不要將機密信息提交到版本庫中，這樣會導致信息泄露，造成安全風險。

另外，公司內部的 Git 服務器存放的 Repository 不只有一個團隊，公司總共 1 萬人，為了避免不必要的爭議，請遵守以下規則：

- 請勿在**個人帳戶**下建立 Repository 來與其他團隊合作。
- 所有 Repository 請以 **Private** 方式建立，勿公開代碼。如果需要公開，請先與各部門主管討論。

## 03. 軟體開發流程準則

### 3.1. 分支管理

我們採用 GitHub Flow 作為主要開發準則，這能有效降低團隊溝通成本。若想了解更多細節，可以參考『[GitHub Flow 及 Git Flow 流程使用時機][33]』一文。在建立分支時，請務必與 Jira Issue 進行關聯。舉例來說，若要處理 Issue GAIS-3210，可以使用以下指令：

```bash
git checkout -b GAIS-3210
git push origin GAIS-3210
```

[33]: https://blog.wu-boy.com/2017/12/github-flow-vs-git-flow/

### 3.2 Commit Message 規範

- 清晰和簡潔: 提交信息應該簡潔明了，描述所做的更改，請參考 [Conventional Commits][35]。
- 格式: 使用標準格式，例如：`refactor(GAIS-2892): improve HTTP response handling and concurrency control`

[35]: https://www.conventionalcommits.org/

類型可以是：

- `feat`: 新功能 (New Feature)
- `fix`: 修復錯誤 (Bug Fix)
- `docs`: 文件更新 (Documentation)
- `style`: 程式碼格式調整 (Code Formatting)
- `refactor`: 重構程式碼 (Code Refactoring)
- `test`: 測試相關 (Testing)
- `chore`: 維護性工作 (Maintenance)

其中 `GAIS-2892` 對應到 Jira Issue ID。Gitea 系統可以與 Jira Issue 進行自動連結整合。

```bash
feat(ui): Add new Button component
^    ^    ^
|    |    |__ Subject (使用現在式描述變更內容)
|    |_______ Scope (變更範圍)
|____________ Type (變更類型)
```

引入 [Gitea Action][36] 的 [semantic-pull-request][34] 做自動化檢查

![logo](/images/2025-01-04/gitea-semantic-pull-request.png)

[34]: https://github.com/marketplace/actions/semantic-pull-request
[36]: https://docs.gitea.com/usage/actions/overview

### 3.3. Code Review 程式碼審查

- Pull Request (PR): 所有程式碼變更都必須透過 PR 進行，且需要**至少一位團隊成員的審查與批准**。
- Automated Testing: 合併前必須確保所有自動化測試都已通過。團隊使用 Gitea Actions 進行自動化測試。
- Squash and Merge: 使用 Squash Commit 合併，以保持版本歷史的整潔，避免多餘的 Merge Commit。

![logo](/images/2025-01-04/gitea-squash-commit.png)

### 3.4. Version Release 版本發布

- Tags: 使用語意化的標籤來標記重要版本，例如 `v1.0.0`
- Semantic Versioning: 遵循 semver 規範，版本號格式為 `MAJOR.MINOR.PATCH`
  - MAJOR: 重大更新，可能包含不相容的 API 變更
  - MINOR: 新增功能，但保持向下相容
  - PATCH: 錯誤修復，保持向下相容
- CI/CD: 透過 Gitea Actions 整合 Push 及 Tag 事件，自動部署至測試環境及正式環境
- Release Notes: 使用 [GoReleaser][55] 工具自動產生發布說明

[55]: https://goreleaser.com/

![logo](/images/2025-01-04/gitea-release-note.png)

### 3.5. 安全性

- 軟體開發過程中，請勿將個人敏感資訊放入 git repo 中
  - 請使用 `.env` 文件來存放敏感資訊
  - 將 `.env` 文件加入 `.gitignore` 列表中
- 部署相關的敏感資訊請直接設定在 Gitea Secret 中

![logo](/images/2025-01-04/gitea-secret.png)

### 3.6 開發文件

許多開發者都曾遇過不知如何在本地環境執行服務的困擾，因此請開發團隊務必在 README.md 文件中詳細說明以下內容，方便未來的團隊成員參考：

- 安裝步驟
- 執行方式
- 測試方法
- 部署流程
- 使用說明

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
