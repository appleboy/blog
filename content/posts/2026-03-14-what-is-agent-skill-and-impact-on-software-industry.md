---
title: "Agent Skill 是什麼？對軟體產業帶來的變化"
date: 2026-03-14T10:00:00+08:00
draft: true
slug: what-is-agent-skill-and-impact-on-software-industry-zh-tw
share_img: /images/2026-03-14/cover.png
categories:
  - AI
  - Agent
---

![cover](/images/2026-03-14/cover.png)

隨著 AI Agent 技術的快速發展，一個全新的概念正在改變軟體開發的工作方式：**Agent Skill（代理技能）**。如果你有使用過 [Claude Code][1]、[Cursor][2] 或其他 AI 輔助開發工具，可能已經接觸過類似的概念。本篇文章將深入介紹什麼是 Agent Skill，以及它如何對軟體產業帶來根本性的變化。

[1]: https://docs.anthropic.com/en/docs/claude-code
[2]: https://www.cursor.com/

<!--more-->

## 什麼是 Agent Skill？

Agent Skill 是賦予 AI Agent **特定領域能力**的模組化單元。你可以把它想像成：AI Agent 是一位通才，而 Skill 則是它所學會的「專業技能」。每個 Skill 定義了一組明確的觸發條件、執行流程和輸出格式，讓 Agent 在遇到對應的任務時，能夠以專業且一致的方式處理。

### 用一個故事來理解 Skill

想像你是一間新創公司的 CEO，剛聘請了一位超級員工小明。小明的大腦異常強大，不管你交代什麼任務，他都能完美地執行完成。你跟他說：「幫我整理這份報表，格式要用表格、數字靠右對齊、標題要加粗，最後寄給財務部的王經理。」小明立刻做得漂漂亮亮。

但問題來了——**小明每天早上醒來，都會把前一天的記憶完全忘光**。

隔天你又要他整理報表，你必須重新把所有細節再講一遍：格式要表格、數字靠右、標題加粗、寄給王經理。後天也是，大後天也是。每一天你都在重複同樣的話，浪費大量時間在「教他怎麼做」而不是「決定做什麼」。

這就是沒有 Skill 的 AI Agent 的現狀——**每次對話都是全新的開始**，你必須反覆描述需求和步驟。

某天你受不了了，決定寫一份**「員工作業手冊」**。手冊裡面一項一項列清楚：

- **「整理月報」**：打開報表 → 轉成表格格式 → 數字靠右對齊 → 標題加粗 → 寄給財務部王經理
- **「客戶回信」**：查看客戶問題 → 到知識庫找答案 → 用正式語氣回覆 → 副本寄給業務部
- **「每週週報」**：彙整本週完成事項 → 列出下週計畫 → 套用公司模板 → 發送給全體主管

從此以後，小明每天早上雖然還是忘記昨天的事，但他會先翻開作業手冊。你只需要說一句：「小明，幫我整理月報。」他就會按照手冊上的步驟，完美地完成工作。你不用再重複叮嚀任何細節。

**這份員工作業手冊，就是 Agent Skill。**

更進一步，當公司有新人加入時，你不需要親自帶領他熟悉每一項工作流程，只要把這份手冊交給他就好。這就是 Skill 的核心價值：**把「腦中的專業知識」變成「紙上的標準流程」，讓任何人（或任何 Agent）都能按照同樣的高標準執行任務。**

### Skill 的核心組成

一個典型的 Agent Skill 包含以下要素：

| 組成要素                | 說明                                                           |
| ----------------------- | -------------------------------------------------------------- |
| **Name（名稱）**        | Skill 的識別名稱，例如 `commit-message`、`code-review`         |
| **Description（描述）** | 何時應該觸發此 Skill 的條件說明                                |
| **Prompt（提示詞）**    | Skill 被觸發後，Agent 應遵循的完整指令                         |
| **Tools（工具）**       | Skill 執行時可使用的工具集合，例如檔案讀寫、Git 操作、API 呼叫 |

### 具體範例

以「生成 Commit Message」這個 Skill 為例：

- **觸發條件**：使用者輸入 `/commit` 或要求產生 commit message
- **執行流程**：分析 `git diff` 的變更內容 → 判斷變更類型（feat、fix、refactor 等）→ 依據 Conventional Commits 規範產生訊息
- **輸出**：一段符合團隊規範的 commit message

這就是 Skill 的威力：**將專業知識封裝成可重複使用的模組**，讓 AI Agent 在特定情境下表現得像一位經驗豐富的專家。

## Agent Skill 的運作機制

Agent Skill 的運作方式可以拆解為三個階段：

### 1. 意圖辨識（Intent Detection）

當使用者發出請求時，Agent 會根據每個 Skill 的描述（Description）來判斷是否有匹配的 Skill。這個過程類似於路由（Routing）：請求進來 → 比對規則 → 分發到對應的處理器。

### 2. 上下文準備（Context Preparation）

一旦 Skill 被觸發，Agent 會收集執行所需的上下文資訊。例如 Code Review 的 Skill 會自動讀取 PR 的 diff、相關檔案，以及專案的程式碼風格規範。

### 3. 結構化執行（Structured Execution）

Skill 的 Prompt 定義了完整的執行步驟，Agent 會嚴格按照這些步驟操作。這確保了輸出品質的一致性，不會因為每次對話的差異而產生截然不同的結果。

## 為什麼 Agent Skill 對軟體產業意義重大？

### 1. 從「對話式 AI」到「技能式 AI」

傳統的 AI 助手是「你問什麼，它答什麼」的對話模式。但 Agent Skill 讓 AI 從被動的問答工具，升級為**主動且專業的協作者**。

以前你可能需要這樣跟 AI 對話：

> 「請幫我看一下這段 code 有沒有問題，注意安全性、效能、可讀性，並給出具體修改建議...」

現在只需要：

> `/code-review`

Skill 已經內建了所有專業知識和檢查步驟，不需要每次都重新描述需求。

### 2. 知識的標準化與可攜帶性

Agent Skill 最大的價值之一，是將團隊的**隱性知識（Tacit Knowledge）轉化為顯性、可執行的規範**。

- 資深工程師的 Code Review 經驗 → 封裝成 `code-review` Skill
- 團隊的 Commit 規範 → 封裝成 `commit-message` Skill
- 部署流程的檢查清單 → 封裝成 `deploy-checklist` Skill

這些知識不再只存在於某些人的腦中，而是成為整個團隊都能使用的標準化工具。新人加入團隊時，透過這些 Skill 就能立即按照團隊規範工作。

### 3. 開發流程的自動化升級

Agent Skill 讓許多原本需要人工介入的流程實現自動化：

| 傳統方式                  | Agent Skill 方式                   |
| ------------------------- | ---------------------------------- |
| 手動撰寫 commit message   | Agent 分析 diff 自動生成           |
| 人工 code review 逐行檢查 | Agent 自動掃描並標記問題           |
| 查文件、找範例程式碼      | Agent 自動查詢最新文件並產生範例   |
| 手動建立 PR 描述          | Agent 分析所有 commit 自動產生摘要 |

這不是要取代工程師，而是**把重複性高、規則明確的工作交給 Agent**，讓工程師專注在真正需要創造力和判斷力的任務上。

### 4. 生態系統與社群效應

當 Skill 成為一種標準化的格式，社群可以開始**共享和組合不同的 Skill**，這將帶來幾個效應：

- **Skill Marketplace**：類似 VS Code Extension 的生態系統，開發者可以發布、安裝和評價各種 Skill
- **領域專業化**：不同領域（前端、後端、DevOps、資安）都會發展出自己的 Skill 集合
- **組合式工作流**：多個 Skill 可以串聯成完整的工作流程，例如「寫完 code → 自動 review → 生成 commit → 建立 PR」

### 5. 軟體工程師角色的轉變

Agent Skill 的普及將推動軟體工程師的角色產生質變：

- **從「寫 code」到「設計 Skill」**：工程師需要思考如何將專業知識轉化為可重複使用的 Skill
- **從「個人技能」到「團隊知識資產」**：透過 Skill，個人的專業能力可以被放大到整個團隊
- **從「執行者」到「策略者」**：當日常任務被自動化後，工程師可以投入更多時間在架構設計、系統規劃等高層次的思考

## 實際案例：從 CLI 工具到一份 Markdown 檔案

在 Agent Skill 出現之前，如果你想讓 AI 幫你自動產生 commit message，你需要開發一整套 CLI 工具。筆者自己就開發了 [CodeGPT][3] 這個開源專案，它是一個 command line 工具，能夠分析 `git diff` 並自動產生符合 [Conventional Commits][4] 規範的 commit message。

[3]: https://github.com/appleboy/CodeGPT
[4]: https://www.conventionalcommits.org/

產生出來的 commit message 大概長這樣：

```text
feat(cache): migrate API key caching to OS credential store

- Replace file-based API key caching with OS credential store backed storage
- Remove cache directory and file path handling in favor of hashed credstore keys
- Introduce a namespaced credstore key format for helper command caches
- Simplify cache serialization and adjust error handling for credstore operations
- Update documentation comments to reflect keyring-based caching behavior
- Adapt tests to use credstore cleanup and validation instead of filesystem checks
- Replace file permission tests with verification of stored credstore contents
```

為了做到這件事，CodeGPT 背後有著完整的軟體工程：CLI 參數解析、Git 操作整合、多個 LLM Provider 串接（OpenAI、Gemini、Claude 等）、Prompt 設計、輸出格式化... 這是一個完整的 Go 專案，需要持續維護、更新相依套件、處理不同平台的相容性問題。

### 轉變：用一份 Markdown 就能做到

有了 Agent Skill 之後，同樣的功能可以用**一份 Markdown 檔案**來實現。筆者已經將 CodeGPT 的 commit message 功能轉換為 [Claude Code Skill][5]，整個 Skill 的內容就是一份 `SKILL.md`：

[5]: https://github.com/appleboy/CodeGPT/blob/main/skills/commit-message/SKILL.md

```markdown
---
name: commit-message
description: >-
  Generate a conventional commit message by analyzing staged
  git changes. Use when the user wants to create, write, or
  generate a git commit message from their current staged diff.
---

# Generate Commit Message

## Steps

### 1. Stage changes and get the diff

If there are modified files from the current session that
haven't been staged yet, run `git add` on those files first.
Then get the staged diff:
git diff --staged

### 2. Analyze the diff

Produce a bullet-point summary of the changes...

### 3. Generate the commit title

From the summary, write a single-line commit title...

### 4. Determine the prefix and scope

Choose exactly one label: feat, fix, refactor, docs...

### 5. Create the commit

Format: <prefix>(<scope>): <title>
Show the message and ask for confirmation before committing.
```

這份檔案清楚地定義了五個步驟：取得 diff → 分析變更 → 產生標題 → 決定 prefix 和 scope → 格式化並提交。Agent 會嚴格按照這些步驟執行，產出的結果與原本的 CLI 工具一樣專業。

### 安裝方式

在 Claude Code 中，Skill 是透過 **Plugin Marketplace** 機制來安裝的。首先需要新增 CodeGPT 的 Marketplace：

```bash
/plugin marketplace add appleboy/CodeGPT
```

接著透過 `/plugin` 指令開啟互動式的 Plugin 管理介面，切換到 **Discover** 分頁就能瀏覽並安裝 `commit-message` Skill。或者直接用指令安裝：

```bash
/plugin install commit-message@appleboy/CodeGPT
```

安裝完成後，只要在 Claude Code 中輸入 `/commit-message` 或請 Agent 幫你產生 commit message，就會自動觸發這個 Skill。

### 這代表什麼？

| 面向         | CLI 工具（CodeGPT）              | Agent Skill（SKILL.md）         |
| ------------ | -------------------------------- | ------------------------------- |
| **開發成本** | 完整的 Go 專案，數千行程式碼     | 一份 Markdown 檔案，不到 100 行 |
| **維護成本** | 需要更新相依套件、處理跨平台問題 | 修改 Markdown 文字即可          |
| **客製化**   | 需要改 code、重新編譯、發布新版  | 直接編輯 Markdown 步驟描述      |
| **團隊適用** | 全團隊需安裝同版本工具           | 放進 repo 即可共享              |
| **擴展性**   | 需要寫程式支援新功能             | 新增或修改步驟文字即可          |

這就是 Agent Skill 帶來最直接的變化：**過去需要花大量時間開發和維護的 CLI 工具，現在用一份結構清楚的 Markdown 檔案就能達到相同效果。** 團隊可以根據自己的規範輕鬆修改 Skill 內容，不需要懂任何程式語言，也不需要經歷「改 code → 編譯 → 測試 → 發布」的軟體開發週期。

## 實際應用場景

### 場景一：新人上手

一位剛加入團隊的工程師，過去可能需要花數周時間熟悉團隊的各種規範和流程。現在透過團隊自定義的 Skill 集合，新人可以：

1. 使用 `/commit` 自動生成符合團隊規範的 commit message
2. 使用 `/code-review` 在提交 PR 前先自我檢查
3. 使用 `/create-pr` 自動產生格式完整的 PR 描述

Agent 會按照團隊的標準來執行，新人不需要記住所有細節。

### 場景二：跨團隊協作

不同團隊可以透過共享 Skill 來統一工作方式。例如：

- 安全團隊提供 `security-review` Skill，所有團隊在部署前都能執行安全掃描
- 平台團隊提供 `infra-check` Skill，確保基礎設施變更符合最佳實踐
- 文件團隊提供 `api-doc` Skill，自動從程式碼生成 API 文件

### 場景三：自定義工作流

開發者可以根據自己的需求，組合或建立新的 Skill。例如：

- 結合 `code-review` + `commit` + `create-pr` 成為一鍵式的提交流程
- 建立專案特定的 Skill，例如針對特定框架的程式碼生成器
- 整合外部服務的 Skill，例如自動查詢 Jira ticket 狀態

## 未來展望

Agent Skill 目前仍在快速發展中，以下是幾個值得關注的趨勢：

1. **Skill 的互通性**：不同 AI 工具之間的 Skill 格式是否能統一？這將決定生態系統的規模
2. **動態 Skill 生成**：Agent 是否能根據使用者的工作模式，自動學習並產生新的 Skill？
3. **企業級 Skill 管理**：大型組織如何管理、版控和部署數百個 Skill？
4. **Skill 的品質保證**：如何確保社群共享的 Skill 品質和安全性？

## 總結

Agent Skill 不只是 AI 工具的一項新功能，而是軟體開發方式的一次典範轉移。它將專業知識模組化、讓團隊經驗可複製、讓重複性工作自動化。對於軟體產業而言，這意味著：

- **開發效率的倍增**：工程師可以專注在高價值的任務上
- **知識傳承的突破**：團隊的寶貴經驗不再隨人員異動而流失
- **協作模式的革新**：人與 AI Agent 的協作將越來越緊密且自然

作為軟體工程師，現在正是開始了解和擁抱 Agent Skill 的最佳時機。無論是使用現有的 Skill、還是為團隊設計專屬的 Skill，這項技能本身就是未來最有價值的投資之一。
