---
title: "從觀望到全公司落地：兩年 AI Agentic Coding 導入實戰"
date: 2026-07-02T10:00:00+08:00
draft: false
slug: ai-agentic-coding-adoption-zh-tw
share_img: /images/2026-07-02/cover.png
categories:
  - AI
  - Claude Code
  - MCP
  - Security
  - DevOps
---

![cover](/images/2026-07-02/cover.png)

去年這個時候，我們在想的是「AI 怎麼協助我們改善工作效率」；今年，問題反過來了——「我們該怎麼協助 AI，讓它加速我們的工作」。主詞和受詞對調，聽起來像文字遊戲，但這正是這兩年公司內部 AI Agentic Coding 導入路上，最核心的一次心態轉變。

這篇文章記錄的是一段真實走過的路：從少數人偷偷試用 [Claude Code][claude-code]，到全公司日常使用；從 AI 產出佔比 66%，一路衝到 97%；從工程師「不信任、怕被取代、擔心資安」的三種觀望心態，到用成果說話、把個人技巧封裝成標準化的 Agent Skill；從每個團隊各自寫 MCP Server 導致的專案爆炸，到用統一認證閘道與 Marketplace 審查機制把整個生態圈的資安治理收攏起來。

三個部分，跟著我們真實走過的順序：**這一年的全貌與成果 → 從觀望到全員 → 流程整合與安全治理**。

[claude-code]: https://www.anthropic.com/claude-code

<!--more-->

{{< speakerdeck id="c106a6c7b10c499e81e0cfdfab1955ed" >}}

## Part 1：這一年的全貌與成果

### 心態轉換：從「AI 幫我們」到「我們幫 AI」

這個對調不是修辭，它決定了後面所有決策的方向。

- **2025 年**：我們在想 AI 怎麼「協助我們」改善工作效率——AI 是工具，我們是主角。
- **2026 年**：我們在想如何「協助 AI」加速工作效率——我們幫 AI 鋪好基礎，讓它替我們加速。

換個更貼近日常管理的說法：**主管不是自己埋頭做，而是幫團隊鋪好路、讓他們跑得更快**——對 AI，是同一個道理。這篇文章後面談的認證閘道、Token 治理、Marketplace 審查，說到底都是在幫 AI 建基礎設施，而不是在教 AI 寫程式。

### 導入時間軸：從工具問世到全公司落地

把時間拉直來看，這條路走了大約一年：

```mermaid
timeline
    title 從工具問世，到全公司落地的這一年
    2025-02 : Claude Code 橫空出世：AI coding agent 正式登場，外部生態的起點
    2025-03 : 整合 AI Gateway：IT 協助把 Claude Code 串進內部 AI Gateway
    2025-05 : 串接 Observability：IT 接上可觀測性，開始量化導入效益
    2025-09 : 導入 SWRD 部門：落地軟體研發相關部門
    2025-10 : Anthropic 推出 Skill：改變了整個 Workflow 生態
    2026-04 : 落地 HWRD 部門：擴展到硬體研發相關部門
```

三個階段很清楚：**外部生態起點**（工具問世）→ **內部整合**（Gateway、Observability）→ **規模落地**（部門一個接一個導入）。工具問世只是起點，真正決定能不能「落地」的，是中間那段看不見的內部基礎設施工作。

### GAISF Gateway：所有 AI 呼叫的單一進出口

不管是 CLI 工具、Web Service 還是 Browser，開發者端每一次 AI 呼叫都先統一從一道閘門進出，再由 Gateway 分流到公有雲與自建模型：

```mermaid
graph LR
    subgraph client["C-DOMAIN · 開發者端"]
        cli["CLI 工具"]
        web["Web Service"]
        browser["Browser"]
    end

    subgraph gw["RD-DMZ · 單一進出口"]
        gateway["GAISF Gateway<br/>所有請求集中進出，統一治理與分流"]
        obs["Grafana & Loki"]
        log["Log Service"]
        usage["Usage Log"]
    end

    subgraph cloud["CLOUD PROVIDER · 公有雲"]
        bedrock["AWS Bedrock（Claude）"]
        aoai["Azure AOAI（GPT）"]
        gcp["GCP（Gemini）"]
    end

    subgraph internal["INTERNAL DOMAIN · 自建 GPU"]
        qwen["Qwen3 GPU"]
        glm["GLM-5.2 GPU"]
        e5["E5-Embedding GPU"]
    end

    client --> gateway
    gateway --> obs
    gateway --> log
    gateway --> usage
    gateway --> cloud
    gateway --> internal
```

單一進出口這個決定，讓我們一次到位解決了四件事：

| 項目             | 說明                                           |
| ---------------- | ---------------------------------------------- |
| **使用量分析**   | 誰用了多少、用在哪，靠 Grafana & Loki 全看得見 |
| **內部稽核**     | 每次呼叫都進 Log Service 留痕，事後可追溯      |
| **控管流量花費** | 集中計量與設限，雲端與 GPU 成本不再失控        |
| **權限控管**     | 依部門與角色，決定可用的模型與範圍             |

值得一提的是，Gateway 只保留稽核所需的資訊，Request / Response Body 都已過濾——這是為了在「看得到誰用了什麼」與「不窺探開發者實際內容」之間找到平衡。

### 用數據說話：AI 佔比從 66% 衝到 97%

比起心態轉換這種軟性論述，數字更有說服力。這是我們月產出量的 AI 佔比走勢：

| 月份     | 2025-08 | 09    | 10    | 11    | 12    | 2026-01 | 02    | 03    | 04    | 05    | 06      |
| -------- | ------- | ----- | ----- | ----- | ----- | ------- | ----- | ----- | ----- | ----- | ------- |
| AI 佔比  | 66%     | 80%   | 80%   | 81%   | 88%   | 92%     | 94%   | 91%   | 95%   | 96%   | **97%** |
| 月產出量 | 0.22M   | 0.57M | 0.46M | 0.76M | 1.18M | 1.56M   | 1.40M | 1.31M | 1.89M | 2.08M | 2.26M   |

十個月內，AI 佔比從 66% 爬升到 97%；同時月產出量成長將近 10 倍。工程師親自寫的量幾乎是一條平盤——不是工程師變少了，而是他們把時間換到別的地方去了：規劃、審查、把關，而不是逐行敲程式碼。

## Part 2：從觀望到全員

### 工程師為什麼不用？三種真實心態

全公司落地聽起來很順利，但走到這一步之前，我們先撞上了工程師的三種真實抗拒心態：

1. **不信任品質**——「AI 寫的還要全部重看，不如自己寫。」
2. **怕被取代**——「學這個是不是在淘汰自己？」
3. **資安疑慮**——「code / 公司資料會不會被送出去？接內部系統怎麼授權？」

前兩種是心態問題，可以靠時間和成果慢慢磨；**第三點才是真正卡住規模化的那一個**。因為它不是心理障礙，而是一個**沒有答案的技術問題**——在有答案之前，任何鼓勵都是空話。

### 主管的兩難：缺一條「安全的路」

這個資安疑慮往上一層，變成主管的兩難：

- **不推**：眼看著別的團隊用 AI 把效率拉開，自己團隊原地踏步。
- **硬推**：一旦有人把金鑰寫進 Git、機敏資料丟到外部，鍋是主管自己背。

缺的不是決心，是一條技術上「安全可控」的路。一年前的現實是「少數人偷偷試、沒人敢接內部系統、金鑰寫死在 config」；今天的現實是「全員日常使用、CLI / MCP 安全接內部資源、零金鑰外洩」。中間那條路怎麼鋪，就是這整篇文章 Part 3 要講的內容。但在鋪路之前，還有一件同樣重要的事：怎麼讓「全員日常使用」這件事真的發生，而不是變成一份沒人理的公告。

### 用成果說話，不要用命令

由上而下「規定大家都要用」的做法，我們試過，結果是開個帳號放著、應付了事。真正有效的路徑是三步走：

1. **個人試用**——找愛玩、有影響力的 2–3 人，做出同事會羨慕的成果。
2. **團隊標準化**——把個人技巧封裝成共用資產，全團隊複用。
3. **全公司落地**——靠 AI Skill Marketplace 平台統一分發，後端介接公司內部 Git 服務。

第二步「把個人技巧封裝成共用資產」，具體做法就是 [Anthropic Agent Skill][skill] 標準。我們把整套從 plan 到 merge 的開發流程，拆成一張指令地圖：

```mermaid
graph LR
    plan["01 規劃 Plan<br/>／plan-feature<br/>人・對齊方向<br/>→ plan.md"]
    dev["02 開發 Develop<br/>依 plan.md 實作<br/>AI"]
    quality["03 品質把關 Quality<br/>／simplify<br/>／security-review<br/>／code-review --fix<br/>AI"]
    commit["04 提交 Commit<br/>／commit-message<br/>→ Conventional Commit<br/>AI"]
    pr["05 開 PR<br/>／pr-prepare<br/>→ PR 描述<br/>AI"]
    review["06 審查迴圈 Review<br/>／loop ／copilot-review<br/>查→修→再審<br/>AI 自動迭代"]
    merge["07 合併 Merge<br/>CI 綠燈 → Merge<br/>人・最終把關<br/>→ main"]

    plan --> dev --> quality --> commit --> pr --> review --> merge
```

規劃階段和最終合併，人為把關；中間從開發到審查迴圈，AI 自動迭代跑完，沒有人逐行介入。這張地圖被整個團隊、整條 CI 共用，並定下明確規範：哪些步驟 AI 自己跑，哪些一定要人把關。

有了統一流程之後，PM / Team Lead 才能做最好的 tracking——每張工單跑同一條 CI：自動測試、自動流轉狀態、自動回報。人只在頭尾把關，中間交給 AI 與 CI。沒有統一的 CI，看板只是手動填的表；有了 CI，每一格都是自動回報的真實進度。

[skill]: https://www.anthropic.com/news/skills

## Part 3：流程整合與安全治理

### 全公司落地的真正門檻：專案爆炸

規模化帶來的第一個副作用不是資安，是數量。每個團隊都用 AI 快速產出服務，專案數量在短時間內從 5x、2xx，爆炸成長到 1xxx 個。這麼多 CLI / MCP / Agent 要接內部系統，認證與授權怎麼管，變成了無法回避的問題。

### 觀念釐清：Agent Skill 出現，MCP 就沒用了嗎？

去年底 Skill 標準一出，很多人以為 [MCP][mcp]（Model Context Protocol）要被取代了——事實上兩者分工不同、彼此互補：

|          | Agent Skill（主導）                | MCP（專責）                         |
| -------- | ---------------------------------- | ----------------------------------- |
| 決定什麼 | 「怎麼做」——整體使用知識 + 流程    | 「接什麼」——整合第三方服務          |
| 具體內容 | 使用知識與規範、整體 Workflow 編排 | 第三方服務整合、Auth 安全連線與驗證 |

Skill 決定「怎麼做」，MCP 決定「接什麼」——一個管流程、一個管連線，缺一不可。這也是為什麼專案爆炸之後，MCP 這一側的資安問題必須單獨面對。

### MCP 推廣的阻力：Token 明碼躺在 Client 端

大家都想從 Skill 一鍵對接公司所有 MCP 服務，但 MCP 推廣一直不動——阻力就一個：**認證 Token 是明文，直接躺在開發者的 Client 端**。

```json
// ~/.claude/settings.json
"headers": {
    "Authorization": "Bearer eyJhbGciOiJSUzI1NiIs..."
}
// 明碼寫死在設定檔裡

// 用 CLI 加？一樣還多留一份：
// $ claude mcp add ... --header \
//   "Authorization: Bearer eyJhbGci..."

// $ history | grep Bearer
// shell history 裡也是明碼
```

寫死在 `settings.json` 會被 commit 進 Git；用 CLI `--header` 加，一樣明碼，還多留一份；連 shell history 裡都撈得到。這正是被 AI 放大的三大資安風險裡最致命的一條。

### 被 AI 放大的三大資安風險

1. **認證各自造輪子**——每個服務自己接 LDAP，帳密邏輯散落、標準不一。
2. **金鑰寫死流入 Git（最致命）**——CLI / MCP 沒有瀏覽器登入流程，帳密 / API Key 寫死隨 code 推上 Git。
3. **Token 發出就失控**——誰持有、何時過期、能否撤銷全不知道，無法追溯、無法止血。

這三條風險不是 AI 帶來的新問題，而是既有的認證管理問題，被 AI 時代「CLI / MCP 大量湧現、每個團隊各自接內部系統」的速度放大了。解法必須從架構層下手，而不是逐個服務去修補。

### 解法一：統一認證閘道——所有工具走同一個門

不管是 CLI、MCP Server、AI Agent 還是內部服務，全部只走一個門：

```mermaid
graph LR
    subgraph clients["CLIENTS"]
        cli["CLI"]
        mcpserver["MCP Server"]
        agent["AI Agent"]
        internal["內部服務"]
    end

    authgate["AuthGate<br/>統一認證閘道<br/>OAuth 2.0 / OIDC Authorization Server"]

    subgraph idp["身分來源"]
        ldap["LDAP · AD"]
        github["GitHub · Gitea"]
        entra["Microsoft Entra"]
    end

    clients -->|註冊| authgate
    authgate --> idp
```

不同場景對應不同的 OAuth 流程：

- **Web** → Auth Code + PKCE
- **CLI・Agent** → Device Flow
- **服務對服務** → Client Credentials / private_key_jwt

其中 CLI / Agent 場景用的 **Device Flow + PKCE**，正是解決「Token 明碼躺在 Client 端」這個致命問題的關鍵機制：

```mermaid
sequenceDiagram
    participant C as CLI / MCP
    participant U as 使用者・瀏覽器
    participant A as AuthGate 閘道

    C->>A: ① 要 device code + user code
    A-->>C: 顯示 URL + user code
    C->>U: ② 顯示 URL + user code，請開瀏覽器
    U->>A: ③ 瀏覽器登入並授權（帳密只在這步，走公司 SSO）
    C-->>A: ④ 同時在背景 polling，等待授權完成
    A-->>C: ⑤ 發 access token + refresh token
    Note over C: ⑥ token 存進 OS keyring 加密，不落地 config
```

整個流程沒有任何一個寫死的金鑰——帳密只在使用者瀏覽器登入那一步出現，走公司既有 SSO；CLI / MCP 端全程只拿到短效的 access token，且直接存進 OS keyring 加密，不落地明碼設定檔。從源頭杜絕帳密流入 Git。

關於這套機制更完整的落地細節——包括 MCP Gateway 如何用 `mcp-oauth2` plugin 驗 JWT、`401` 到 `200` 的完整握手序列、為什麼選 RS256 + JWKS 而不是 HS256——我在之前的文章[《別再讓 MCP Server 各自收 PAT：用 Kong + AuthGate 做企業統一 OAuth2 入口》][kong-post]裡有詳細拆解，這裡不重複貼程式碼，只講這次投影片裡多補的一塊：**Token 治理**。

[mcp]: https://modelcontextprotocol.io
[kong-post]: /2026/06/kong-authgate-mcp-oauth-zh-tw/

### 解法二：Token 治理——把每個 MCP 當成獨立的 OAuth Resource

光有統一閘道還不夠。如果一顆 token 可以在所有 MCP 服務上通用，一旦外洩，爆炸半徑就是整個公司的 MCP 生態圈。我們用 [RFC 8707 Resource Indicators][rfc8707] 把每個 MCP 都當成獨立的 OAuth Resource：token 綁死在某一個 MCP，`aud` 不符直接被擋。

| Token 的 `aud` | Gitea MCP（`aud=mcp://gitea`） | Jira MCP（`aud=mcp://jira`） |
| -------------- | ------------------------------ | ---------------------------- |
| `mcp://gitea`  | ✅ 接受                         | ✗ 拒絕（aud 不符）           |

- **最小權限，收斂爆炸半徑**：token 只帶該 MCP 的 scope，外洩只波及單一 MCP。
- **驗證在地驗章**：RS256 + JWKS，Resource Server 不用每次回打閘道。
- **每個 token 全程可控**：可查詢、可設到期、即時撤銷，甚至一鍵強制全體重登。

這套設計正是防範 confused deputy 攻擊的標準做法——就算 token 被某個 MCP client 誤用去呼叫另一個 MCP，`aud` 檢查會直接擋下來。

### 解法三：MCP Gateway 把關、IDP 發 Token，Client 不直連 MCP

把統一認證閘道跟 Token 治理接起來，完整架構是這樣：Client 端的開發者工具（Claude Code、OpenAI Codex、Gemini CLI）帶著 Bearer JWT 打向 MCP Gateway；Gateway 上的 `mcp-oauth2` plugin 驗證簽章（JWKS）、`iss`、`aud`、`exp`、`scope` 之後，才帶著 `X-MCP-Subject` / `X-MCP-Scope` 轉發進內部 MCP 集群（Gitea MCP、Jira MCP、Confluence MCP）。內部 MCP Server 只信 Gateway 轉發進來的身分標頭，自己不碰 token。

一次完整握手可以拆成五步：

| 步驟        | 說明                                                                   |
| ----------- | ---------------------------------------------------------------------- |
| ① Challenge | 無 token 請求被擋：`401` + `WWW-Authenticate` 指向 `resource_metadata` |
| ② Discovery | Client 讀 `/.well-known/oauth-protected-resource` 找到 IDP             |
| ③ Authorize | Auth Code + PKCE 走完授權，IDP 簽發 RS256 token                        |
| ④ Verify    | MCP Gateway 以 JWKS 驗簽章，再驗 `iss` / `aud` / `exp` / `scope`       |
| ⑤ Forward   | 通過才轉發，附上 `X-MCP-Subject` 與 `X-MCP-Scope`                      |

這套流程跟前面 Device Flow 的差別在於：Device Flow 解決的是「CLI / MCP 端怎麼安全拿到 token」，這裡的 MCP Gateway 握手解決的是「拿到 token 之後，怎麼在每一次請求上都驗證乾淨」。兩者疊在一起，才是完整的資安治理鏈。

### 解法四：AI Marketplace 裡，MCP / Skill 怎麼上架與認證？

專案爆炸之後，每個團隊都在寫自己的 MCP Server 與 Skill——誰能上架、誰來把關、誰可以用，需要一套企業內部的管理流程，而不能只靠口頭約定。

我們把資安審查放進 CI 流程裡最關鍵的一關：同一個 PR，觸發三道並行掃描，三道全綠才放行。

```mermaid
graph LR
    pr["每個 PR"]
    coverity["01 Coverity Scan（SAST）<br/>原始碼靜態分析<br/>記憶體錯誤、資源洩漏、Null 解參考<br/>注入漏洞與不安全的 API 使用"]
    trivy["02 Trivy Scan（SCA）<br/>相依套件 / 映像漏洞<br/>已知 CVE 與 OS 套件漏洞<br/>IaC 設定錯誤與外洩金鑰"]
    codereview["03 Code Review（AI Review）<br/>AI 情境語意審查<br/>商業邏輯漏洞與不安全模式<br/>前兩者掃不到的情境問題"]
    pass["三道全綠才放行"]

    pr --> coverity --> pass
    pr --> trivy --> pass
    pr --> codereview --> pass
```

工具掃廣度、AI 補語意——三層互補，沒有一道漏洞能單靠一種方法溜過去。靜態分析工具擅長抓已知模式（記憶體錯誤、已知 CVE），但抓不到「這段商業邏輯本身就是個資安漏洞」這種需要理解情境才看得出來的問題；這一塊交給 AI 語意審查補上。三道掃描全部並行觸發、全部綠燈才能合併，MCP / Skill 才能真正上架進 Marketplace 供全公司使用。

[rfc8707]: https://datatracker.ietf.org/doc/html/rfc8707

## 小結

回頭看這一年多的路，其實可以濃縮成一句話：**用成果說話，把關鍵一次做對**。

- **心態上**：從「AI 幫我們」翻轉成「我們幫 AI」，把主管的管理智慧搬過來——鋪路，而不是命令。
- **推廣上**：不靠上而下規定，靠個人試用 → 團隊標準化 → 全公司落地的三步走，配合 Agent Skill 把個人技巧變成共用資產。
- **治理上**：真正卡住規模化的從來不是心態，是資安。統一認證閘道解決「Token 別再明碼躺在 Client 端」；Token 治理解決「每個 MCP 都是獨立 Resource，外洩不擴散」；CI 三道並行掃描解決「Marketplace 上架前的資安把關」。

AI 產出佔比衝上 97% 這件事本身沒那麼重要；真正重要的是，這 97% 是建立在一條「安全可控」的路上跑出來的，而不是靠工程師閉著眼睛信任 AI、或主管閉著眼睛忽視資安風險換來的。如果你們公司也正卡在「工程師不敢用」或「MCP 推不動」的階段，希望這篇拆解的順序——先解心態、再解流程、最後解資安架構——能幫你們少走一些冤枉路。
