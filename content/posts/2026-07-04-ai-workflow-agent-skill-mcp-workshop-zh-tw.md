---
title: "當 AI 已經能寫 Code——打造你的 AI 工作流：Agent Skill + MCP 實戰工作坊回顧"
date: 2026-07-04T10:00:00+08:00
draft: false
slug: ai-workflow-agent-skill-mcp-workshop-zh-tw
share_img: /images/2026-07-04/cover.png
categories:
  - AI
  - Claude Code
  - MCP
  - DevOps
---

![cover](/images/2026-07-04/cover.png)

2026 年 7 月 1 日，我在 [iThome 臺灣雲端大會（Cloud Summit Taiwan）][lab]帶了一場 90 分鐘的 LAB 實戰工作坊：「當 AI 已經能寫 code——打造你的 AI 工作流」。這篇文章整理當天的核心內容與動手練習，讓沒能到場的朋友也能照著跑一次，也給參加過的朋友一份可以回頭查的筆記。

同一天我還有一場議程演講，聊的是兩年 AI Agentic Coding 導入的完整歷程，回顧文在這裡：[從觀望到全公司落地：兩年 AI Agentic Coding 導入實戰][adoption-post]。那場講「為什麼與怎麼推」，這場 LAB 則是捲起袖子「實際動手做」。

[lab]: https://cloudsummit.ithome.com.tw/2026/lab/4794
[adoption-post]: /2026/07/ai-agentic-coding-adoption-zh-tw/

<!--more-->

{{< speakerdeck id="fdf92ad2a2424d4eb0ec23ec6f44dc4d" >}}

## 活動資訊

| 項目 | 說明                                  |
| ---- | ------------------------------------- |
| 活動 | [2026 iThome 臺灣雲端大會 · LAB][lab] |
| 日期 | 2026 年 7 月 1 日                     |
| 時長 | 90 分鐘                               |
| 形式 | 實作工作坊（Hands-on Workshop）       |
| 講者 | Bo-Yi Wu (@appleboy)                  |

![LAB 工作坊現場，座位坐滿、後排站滿了人](/images/2026-07-04/venue-fullroom.jpg)

## 這場工作坊在做什麼

我們不空談理論。整場工作坊你會以一個真實的專案為練習場——可以是 [AuthGate][authgate]（OAuth 2.0 開源專案），也可以是你手上公司內部的專案——用 Claude Code 搭配 Agent Skill 與 MCP，完整跑過一輪軟體開發生命週期（SDLC）：從規劃、開發，到自動化 Review 與提交。

[authgate]: https://github.com/go-authgate/authgate

過程中有兩個你會親身撞見的轉變：

1. **「寫規格」取代「寫程式」成為新的核心競爭力**——透過模糊指令與精準規格的對照實驗，你會看見給足 context 的規格如何直接決定 AI 產出的成敗。
2. **從「執行者」升級為「策略者」**——當你親手修改一個 Skill、把團隊的最佳實踐封裝成可複用的資產，影響力就不再是一次性的執行，而是可規模化的流程設計。

會寫 code 的人很多，但能把問題拆清楚、把團隊智慧封裝成 Skill 的人很稀缺。這堂課的目標，就是帶你成為後者。

## 核心命題：工程師的價值，往上移了一層

當 AI 已經能寫 code，工程師的價值在哪裡？

我的答案是：**價值不會消失，而是往上移了一層**。從「親手把 code 寫出來」，轉移到「定義問題、設計流程、指揮 AI」。

這不是口號，而是我們團隊實際數據反映出的現實。以新增程式碼行數來看，AI 已經是程式碼的主要作者：

| 類別        | AI 產出       | 人類產出     | AI 佔比             |
| ----------- | ------------- | ------------ | ------------------- |
| 程式碼 Code | 6.86M 行      | 1.06M 行     | 86.6%（約 6.5 倍）  |
| 文件 Docs   | 4.97M 行      | 0.22M 行     | 95.7%（約 22.5 倍） |
| 測試 Tests  | 0.92M 行      | 0.03M 行     | 96.4%（約 27 倍）   |
| **總計**    | **12.74M 行** | **1.31M 行** | **90.7%**           |

有趣的是，過去最常被犧牲的**文件與測試**，反而被 AI 補得最滿。這件事本身就說明了 AI 在 SDLC 裡的定位。

![現場講到「AI 已經是程式碼的主要作者：90.7%」這一頁，連走道都站滿了人](/images/2026-07-04/venue-metrics.jpg)

## SDLC 全流程分工：哪些交給 AI，哪些更要專注

把軟體開發生命週期攤開來看，分工其實很清楚：

- **AI 主導**：Develop（開發）、Testing（測試）、Docs（文件）——繁重的實作、測試與文件，幾乎全交給 AI 一次補滿，人不再是產線。
- **人為專注**：Plan（規劃）、PR Review（審查）——方向對齊與品質把關，由人主導。
- **補強**：CI/CD（整合與部署）——上線護欄，人主導、AI 加強。

一句話總結：**繁重的交給 AI，方向與品質的把關留給人**。

![現場講解「哪些交給 AI，哪些更要專注」的 SDLC 分工](/images/2026-07-04/venue-sdlc.jpg)

## Part 1：概念對齊——Agent Skill × MCP

工作坊的兩個關鍵字，各司其職、互相補位：

### Agent Skill：決定 AI「怎麼做」

把團隊的最佳實踐、流程與規範，封裝成 AI 可複用的能力——讓 AI 懂你的做事方法。

### MCP：讓 AI「接上服務」

把 AI 接上你的開發環境與外部系統（Jira、Gitea、Confluence……）——讓 AI 在真實環境裡動手。

**懂流程 + 能動手**，兩者結合，AI 才能既懂你的流程，又能在開發環境裡真正動手。

### 企業級 MCP 安全架構：Gateway 把關，IDP 發 Token，Client 不直連 MCP

在企業內部落地 MCP，安全治理是繞不開的題目。我們的做法是：每個請求都先過 MCP Gateway 上的 `mcp-oauth2` plugin 驗 JWT，驗過才帶著身分與 scope 轉發進 MCP 集群。

整條授權流程長這樣：

1. **Challenge**：無 token 請求被擋——回 401 + `WWW-Authenticate` 指向 `resource_metadata`
2. **Discovery**：Client 讀 `/.well-known/oauth-protected-resource` 找到 IDP
3. **Authorize**：走 Authorization Code + PKCE 完成授權，IDP 簽發 RS256 token
4. **Verify**：MCP Gateway 以 JWKS 驗簽章，再驗 `iss` / `aud` / `exp` / `scope`
5. **Forward**：通過才轉發，附上 `X-MCP-Subject` 與 `X-MCP-Scope`

關鍵設計是：**內部 MCP Servers（Gitea MCP、Jira MCP、Confluence MCP）只信 MCP Gateway 轉發進來的身分標頭，自己不碰 token**。開發者工具端（Claude Code、OpenAI Codex、Gemini CLI）則透過標準 OAuth 流程統一接入，單一進入點、集中治理。

## Part 2：AI SDLC 全流程實戰

接下來是這場工作坊的主體：從規劃、開發、Review 到提交，一路用 Skill 串起來。

### 寫程式之前，先把計畫講清楚：`/plan-feature`

多數 AI coding 失敗，**不是因為模型不夠強，而是人沒給足夠的 context**。`/plan-feature` 用約 15 分鐘把你變成 Claude 的產品經理，大幅提升實作成功率。

**什麼情況該 plan？**

- 「新增 / 建立 / 實作 / 開發 / 上線」一個功能、端點、元件、頁面、服務
- 提示很短、說不清楚——「加個 dashboard」「做個登入流程」
- 只講功能、沒給檔案路徑的需求

**什麼情況直接做？**

- 錯字修正、單行設定變更
- 單純的重新命名
- 使用者已經給了完整規格

有疑慮時，就 plan（When in doubt, plan）。

**八步驟工作流程：**

前五步是思考與設計（先別寫程式）：

1. 釐清目標（Clarify goal）
2. 探索程式庫（Explore code）
3. 界定範圍（Identify scope）
4. 驗證策略（Verification）
5. 畫設計圖（Sketch diagram）

後三步是寫成文件、核可、交接：

6. 撰寫 plan.md（Draft the plan）
7. 取得核可 ✋——寫程式前停在這
8. 建議交接（Recommend handoff）

**最終產出是一份 `plan.md`**——一份可以交接給全新 AI 對話的契約文件，結構包含：

```markdown
# Plan: <feature name>

# Goal — 問題陳述

# Architecture / flow — Mermaid

# Scope

# May modify

# Must not modify

# Existing patterns to follow

# Constraints

# Verification — 3 e2e tests

# Done definition — [ ] checklist

# Risks & rollback

# Open questions
```

幾個撰寫重點：

- **Goal 一段就好**：誰用、做完長怎樣、回傳什麼——具體到實作者不必再猜
- **Scope 兩份清單**：明確列出可改與不可改，守住核心程式碼
- **Verification + Done**：3 個測試 + 可勾選的完成定義 checklist

現場的動手練習就是：拿一個自己手上的真實案例（別挑玩具範例），執行 `/plan-feature`，讓它問你、釐清目標，跑到產出 plan.md 為止。

### 三個 Skill 指令，讓 AI 產出的品質穩定

這不是貼程式碼給 chatbot 看——這些 Skill 會在你的 repo 上跑工具、讀整個 codebase、直接動手修：

1. **`/simplify`——收掉過度設計**：把 AI 容易寫出的重複邏輯、過度抽象收乾淨，降低複雜度，讓程式碼更好維護。
2. **`/security-review`——自動安全審查**：掃一遍安全面向，揪出注入、密鑰外洩、權限漏洞，趁上線前補掉。
3. **`/code-review max -fix`——最高強度審查 + 自動修**：用最強等級做一輪 code review，`-fix` 把問題就地修好，不只是列清單。

每一輪 AI 產出後自動掛上一道品質護欄。

### Commit 與 PR，拆成兩個 Skill

commit 是一顆顆原子變更，PR 是一個完整故事——關注點不同，拆開才能各自做到最好。

**`/commit-message`——寫出講得出「為什麼」的 commit**

- 讀 staged diff，理解這次到底改了什麼
- 對照 repo 既有風格與慣例（Conventional Commits……）
- 產出清楚、聚焦的 commit message，不再是「update files」

**`/pr-prepare`——把整條分支收攏成一份 PR**

- 自動生成標題、摘要、變更重點、測試方式
- 攤開 AI 作者身分、變更分類、驗證狀態
- 補上對應 issue 連結與 reviewer 提示

結果就是：審查者一打開就知道在做什麼、該看哪。

⚠️ 一個重要提醒：**下指令之前，先自己看過代碼確認沒問題再執行**。AI 幫你寫訊息、收攏 PR，但不替程式正確性負責；沒看過就執行，等於把沒驗證的東西直接送出去。

完整流程：**讀 diff → 自己 review → `/commit-message` → `/pr-prepare`**。

### 發完 PR，先挑一個 AI 幫你 review 一輪

PR 開出來之後，在人類 reviewer 介入前，先讓 AI 抓一輪明顯問題與風險。三個選項擇一即可：

1. **GitHub Action：Claude Code Review**——Anthropic 的 claude-code-action，在 PR 上跑 Claude，貼出逐行 review 與整體摘要（`@claude review`）
2. **原生整合：GitHub Copilot Review**——原生整合進 GitHub，把 Copilot 指派為 reviewer，直接在 diff 上給 inline 建議
3. **OpenAI Codex Review**——自動或手動觸發，產出審查意見與具體的修正建議（`@codex review`）

### 把 Review 變成自動迴圈：`/loop 3m /copilot-review`

以選項 2 的 Copilot Review 為例，它還能用 `/loop` 自動跑：

```bash
/loop 3m /copilot-review
```

`/loop` 每 3 分鐘呼叫一次 `/copilot-review`，每次只跑「一輪」check-fix，自己收斂——不用守在電腦前。一輪的骨架是：

**查留言 → 逐條修 → push → resolve → 再審 ↻**

拆成八個步驟：

1. **偵測 PR**：auto-detect 當前分支，或直接指定 number / repo
2. **確認 review 狀態**：用 GraphQL 確認 Copilot 審完、且涵蓋最新 push
3. **取出未解留言**：過濾 `copilot-pull-request-reviewer` 的 unresolved threads
4. **修正程式碼**：逐條讀懂、判斷脈絡再修——不盲從每一條建議
5. **跑測試**：commit 前先綠燈；壞了先修，衝突就 revert 該建議
6. **Commit & Push**：用 `/commit-message` 產生 conventional commit
7. **Resolve threads**：把已處理的 thread 用 GraphQL mutation 標記解決
8. **重新觸發 review**：重新指派 @copilot，並記錄 `lastSeenReviewAt`

**分清楚「結束這一輪」和「整個迴圈停」**——這是很多人第一次用會搞混的地方：

以下三種狀況只是 return 結束這一輪，等下一次，不會停迴圈：

- 還沒有 Copilot review → 先觸發，等下一輪
- review 早於最新 push → 等它審最新 push
- 重新觸發的 review 還沒到 → 用 `lastSeenReviewAt` 判斷，繼續等

唯一能讓迴圈停的條件：review body 出現 **"generated no new comments"** 或 **"generated 0 comment"**。thread 全 resolved、或沒推新 code，都不算停的理由。

幾個實務細節：

- **上限 10 輪**——再多通常是架構分歧，請人工介入
- Copilot review 是 Comment 型——不 approve、不擋 merge
- 開源 repo 免費——不需 Copilot 訂閱

⚠️ 同樣的提醒：下 `/loop` 前，PR 的程式碼你要心裡有底——AI 照建議修，對不對還是你負責。

## 總結：AI 不是取代 CI/CD，而是把它補完

「完整的 CI/CD」是過去我們很少真正做到的事——測試、review、修綠燈、文件、看板，總有環節被犧牲。藉由 AI 的協助，每一格缺口都被補上：

| 以前的缺口                 | AI 補完之後   |
| -------------------------- | ------------- |
| 自動化測試常被犧牲         | ✓ AI 補齊     |
| Code Review 人力不足被省略 | ✓ 自動 review |
| CI 紅燈卡很久沒人修        | ✓ 修到綠燈    |
| 文件 / commit / PR 隨便寫  | ✓ 規格化      |
| 看板 / 狀態靠人手動更新    | ✓ 自動回寫    |

以前做不完、做不好的環節，現在每一格都能補上、跑到綠燈——這條 pipeline 比以前任何時候都更完整。而人類只守頭尾兩關：**開頭對齊方向，結尾最終把關**。

## 回去之後

如果你也想在團隊裡動手，我的建議是：**挑一個最有感的缺口，用今天的某個 Skill 或一段自動化，先讓一格跑到綠燈**。

不用一次翻掉整條 pipeline。先從 `/plan-feature` 開始把 context 給足，或掛上 `/loop 3m /copilot-review` 讓 review 自動收斂——一格一格補，你會發現 SDLC 比想像中更快變得完整。

---

_Bo-Yi Wu（appleboy）／聯發科技後端架構工程師，負責 Technology Platform 開發與維運，帶領 Backend、Kubernetes、DevOps 三個團隊，在公司負責推動 AI 工具導入。GitHub: [@appleboy](https://github.com/appleboy)｜Blog: [blog.wu-boy.com](https://blog.wu-boy.com)_
