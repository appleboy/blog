---
title: "OAuth Client ID Metadata Document 簡介"
date: 2026-02-17T09:52:21+08:00
draft: false
slug: oauth-client-id-metadata-document-zh-tw
share_img: /images/2026-02-17/cover_800x447.png
categories:
  - OAuth
  - MCP
---

![cover](/images/2026-02-17/cover_800x447.png)

2025 年在 iThome [臺灣雲端大會](https://cloudsummit.ithome.com.tw/2025/)介紹過 MCP ([Model Context Protocol](https://modelcontextprotocol.io/docs/getting-started/intro))，那時候就有提到在認證協議部分，官方其實一直都在改版解決複雜的認證流程，之前設計的 DCR ([Dynamic Client Registration](https://datatracker.ietf.org/doc/html/rfc7591))，所以沒意外去年 2025/11/25 又推出一版 [Authorization 機制](https://modelcontextprotocol.io/specification/2025-11-25/basic/authorization)，此認證機制取名叫『[Client ID Metadata Documents 簡稱 CIMD](https://datatracker.ietf.org/doc/draft-ietf-oauth-client-id-metadata-document/)』。

安裝 Model Context Protocol（MCP）伺服器時，最棘手的部分往往不是協議本身，而是如何讓客戶端與伺服器彼此建立信任。如果你曾嘗試讓一個 MCP 客戶端連線到一個從未接觸過的 MCP 伺服器，你大概遇過所謂的「註冊高牆（registration wall）」。

要預先在每一個可能的授權伺服器完成註冊根本無法擴展，而 Dynamic Client Registration（DCR）雖然有所幫助，但因為缺乏可靠的機制來驗證客戶端身份，所以容易遭受網路釣魚攻擊。除了安全性問題之外，DCR 還會造成營運負擔，因為它會產生越來越多需要管理的重複客戶端身份。

<!--more-->

MCP 社群正逐漸收斂到一個更簡單、安全的預設做法：[OAuth Client ID Metadata Document][1]。在這種方式下，`client_id` 是一個 指向小型 JSON 檔案的 HTTPS URL，檔案裡描述了客戶端的資訊。授權伺服器會在需要時抓取這個文件、驗證內容並依據自身策略處理，整個過程不需要事先協調。所以大家請記住這個新的 Protocol 主要來解決 MCP Client 註冊問題。

如果對於 MCP 第一次聽到的朋友們，可以先參考我之前寫的一份教學『[一步步學會用 Golang 開發 MCP 伺服器與客戶端 (Model Context Protocol)](https://blog.wu-boy.com/2025/07/step-by-step-golang-mcp-server-client-zh-tw/)』

[1]: https://datatracker.ietf.org/doc/draft-ietf-oauth-client-id-metadata-document/

## Client Registration 痛點

可以在 GitHub Issue #991（[SEP‑991](https://github.com/modelcontextprotocol/modelcontextprotocol/issues/991)）裡面有提到三個痛點

### 痛點 1：Pre‑registration（預先註冊）不切實際

1. 開發者預先註冊: MCP client 常常出廠時根本不知道之後會遇到哪些 server
2. 使用者手動註冊: 要求使用者自己到 server 端輸入 client 資料、管理憑證

### 痛點 2：Dynamic Client Registration（DCR）有重大限制

DCR（Dynamic Client Registration）雖然是「動態」註冊，但在 MCP 環境中會造成以下問題：

1. 伺服器必須維護無界限的 client database: 因為任何 client 都可能來註冊，server 要維護大量資料庫紀錄與過期管理。
2. 伺服器只能信任「client 自己宣稱」的 metadata: 自我宣告（self‑asserted）metadata 具有安全風險。

### 痛點 3：MCP 的典型場景是「完全沒有前置關係」

MCP 核心價值在於：

> client 與 server 彼此完全沒聽過對方，卻需要能立即建立安全可靠的連線。

例如：

1. user 想連到一個剛發現的 MCP server
2. 該 server 的作者從未聽過這個 client
3. client 開發者也不知道這個 server

這是開放式協定環境常見且必須要解決的場景。

## 解決方式 OAuth Client ID Metadata Documents

SEP-991 提出的方案是一種 以 HTTPS URL 作為 Client ID 的模式：

> Client ID 是一個 URL → 指向一份 JSON client metadata document。

### ✔ 解法 1：不用預先註冊

Server 只需要：

- 接收到一個 client ID（其實就是一個 HTTPS URL）
- 抓取該 URL 上的 metadata document
- 驗證該 domain 來作為信任根（trust anchor）

不必事先認識該 client。

> 完美解決 pre-registration 的不可能性與使用者手動設定的問題。

### ✔ 解法 2：不用 DCR，也不用維護 database

Server 不用存 client metadata，因為 metadata 由 client 自己提供在公開 URL，上線後隨時可抓。

> server 不需儲存 / 過期 / 清除 metadata。

### ✔ 解法 3：不再依賴「自我宣告」的資料

因為 metadata 是放在 client 擁有的 HTTPS 網域上：

Server 依據 HTTPS domain 建立信任（像 OAuth 機制），不再只是相信 `client metadata`

> 提升安全性

### ✔ 解法 4：完美符合 MCP「沒有前置關係」的運作模式

Server 和 client 都能：

1. 無需提前知道對方
2. 又能在第一次互相遇見時建立可驗證的信任鏈（以 URL domain 作為 Trust Anchor）

這正是 MCP Ecosystem 最需要的。

## 📌 總結：Pain Points vs. Solutions

| 痛點                                                   | 對應解法 (SEP-991)                                 |
| ------------------------------------------------------ | -------------------------------------------------- |
| Developer 無法預先註冊所有 Server                      | Client 用 URL‑based metadata，自我託管、隨時可讀取 |
| User 手動註冊 UX 差                                    | Server 不需要人工註冊，只要 fetch metadata         |
| DCR 造成 Server 維護無限 DB                            | URL‑based metadata → 不需要 server 儲存資料        |
| DCR 信任 self‑asserted metadata                        | 透過 HTTPS domain 建立真正可驗證的信任             |
| MCP 的 “no pre-existing relationship” 場景無法被支援好 | URL‑based registration 正是為這種場景設計          |

## CIMD 流程

![CIMD](/images/2026-02-17/cimd-zh-tw.png)

流程很簡單，有四個步驟讓大家了解

### Client 自主 Host Metadata 網址

客戶端建立一個包含其元資料的 JSON 文件，並將其存放在一個 HTTPS 網址上，可以參考 VSCode 實際案例

```json
{
  "application_type": "native",
  "client_id": "https://vscode.dev/oauth/client-metadata.json",
  "client_name": "Visual Studio Code",
  "client_uri": "https://vscode.dev/product",
  "grant_types": [
    "authorization_code",
    "refresh_token",
    "urn:ietf:params:oauth:grant-type:device_code"
  ],
  "response_types": [
    "code"
  ],
  "redirect_uris": [
    "https://vscode.dev/redirect",
    "http://127.0.0.1:33418/"
  ],
  "token_endpoint_auth_method": "none"
}
```

### 用戶端將 URL 作為 `client_id`

客戶端不再使用預先註冊的 client ID，而是直接傳遞 Metadata 的 URL

> GET /authorize?client_id=https://vscode.dev/oauth/client-metadata.json&...

### 伺服器取得並驗證 Metadata

授權伺服器會從 client_id 的網址取得該 JSON 文件並進行驗證。

- 驗證 JSON 結構及必要欄位
- 確認 client_id 與來源網址一致
- 檢查重定向 URI 及其他參數

### 伺服器在同意畫面顯示用戶端資訊

伺服器會顯示 `client_name` 和 `client_uri`，協助使用者做出知情的同意決策。

## 為什麼這種方式非常契合 MCP

MCP 的核心價值在於：只要是「具備能力的客戶端」，都應該能與「符合規範的伺服器」自由通訊。這正是在一個開放、動態、跨平台的環境中，以 URL 為基礎的 Client ID Metadata 特別合理的原因。它讓任何客戶端都能以標準化、可擴展、可驗證的方式向任意 MCP 伺服器自我介紹，而無需事先建立雙方關係、註冊或協調。

### 無需事先協調的信任機制

伺服器不需要長期維護註冊資料庫，也不需與客戶端預先建立任何協議。它們可以選擇接受所有客戶端、限制在特定信任的網域、或只允許少數特定的 URL —— 完全取決於自身的風險承受度。這份 SEP 將其定位為**由伺服器主導的信任模型，而非由客戶端主導的註冊流程**。

### 穩定且一致的識別方式

由於 `client_id` 是一個 URL，它代表的是應用程式本身，而不是某個特定的安裝實例。這可減少因「每次安裝就產生新 ID」所帶來的混亂，也讓營運方能以更清晰、持久的方式識別客戶端。

### Redirect URI 可信宣告（Attestation）

`redirect_uris` 會在客戶端的 Metadata Document 中明確綁定。這讓攻擊者幾乎不可能偷偷加入惡意的 callback，因為伺服器只會接受 JSON 文件裡列出的網址並強制比對。

### 極低的實作成本

對大多數應用程式而言，提供一個靜態 JSON 檔幾乎不需要額外成本。即便是桌面應用程式，通常也都有官方網站提供下載，而同一個網站就能毫不費力地提供 metadata 文件。

## 總結

CIMD 這份規範提出了一種全新的方式，允許 OAuth 客戶端直接以 URL 作為 client_id。在這個模式下，授權伺服器能透過該 URL 即時取得客戶端所公開的 JSON Metadata，而不再需要先在人為後台建立「OAuth Application」才能取得固定的 Client ID。換句話說，以往「必須在每個授權伺服器預先註冊客戶端」的流程，現在改由各個客戶端自行託管其身分資訊；授權伺服器在授權流程中動態擷取與驗證即可。這不僅移除了繁瑣的預註冊需求，也讓大量、動態、多來源的客戶端能以更簡潔、安全的方式完成身分識別與互信建立。

簡而言之，Client ID Metadata 不僅大幅減少了傳統註冊流程中的負擔，也讓伺服器能取得更清晰、更可信的客戶端身分訊號，真正知道連線的客戶端是誰。

## 參考文章

- [Client ID Metadata Document Adopted by the OAuth Working Group](https://aaronparecki.com/2025/10/08/4/cimd)
- [Client ID Metadata Documents](https://client.dev/)
- [Building MCP with OAuth Client ID Metadata (CIMD)](https://stytch.com/blog/oauth-client-id-metadata-mcp/)
- [Evolving OAuth Client Registration in the Model Context Protocol](https://blog.modelcontextprotocol.io/posts/client_registration/)
- [MCP authentication and authorization implementation guide](https://stytch.com/blog/MCP-authentication-and-authorization-guide/)
