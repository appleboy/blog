---
title: "為什麼團隊從 Bitbucket Data Center 版本轉向 Gitea 企業版"
date: 2026-02-16T10:33:55+08:00
draft: false
slug: why-we-migrated-from-bitbucket-dc-to-gitea-zh-tw
share_img: /images/2026-02-16/blog-cover_800x447.png
categories:
  - Gitea Actions
  - Gitea
  - CI/CD
  - DevOps
---

![cover](/images/2026-02-16/blog-cover_800x447.png)

相信在軟體開發領域，大家對 [Git](https://git-scm.com/) 應該都不陌生——這套全球最受歡迎的版本控制系統已成為現代協作開發的基礎工具。而提到 Git，就不得不想到目前全球最大且最知名的開源軟體平台 [GitHub](https://github.com/)。

但在許多私人企業或中小型團隊中，如果因為安全性、成本、部署策略或法規需求等原因，而不能直接採用 GitHub，那麼有哪些工具可以作為企業內部的 Git 版本庫平台呢？最常見的選擇包含 [GitLab](https://about.gitlab.com/) 以及本篇將深入探討的 [Gitea](https://about.gitea.com/)。

對部分團隊而言，Gitea 可能還相對陌生。簡單來說，**Gitea 是一套以 Go 語言打造的極輕量、自架型 Git 平台**，提供與 GitHub 類似的功能，例如程式碼託管、權限管理、Issue 與 Pull Request、CI/CD 等能力。 你也可以在官方文件中看到更完整說明（[Gitea Documentation](https://docs.gitea.com/)）。它跨平台、容易部署，且維護成本低，因此逐漸受到中小型團隊青睞。

本篇文章的主軸，就是要和大家分享： 為什麼我們團隊最終選擇從 [Bitbucket Data Center](https://www.atlassian.com/enterprise/data-center/bitbucket) 遷移到 Gitea？又為什麼沒有選擇 GitLab 這類功能更完整、但相對較為沉重的開源方案？

<!--more-->

## 成本考量 (Cost)

由於公司跨部門協作的需求不斷增加，相關軟體的授權成本也隨之大幅提升。光是 14 天內曾登入的帳號 就接近 500 個，而以 GitHub 為例，其企業授權費用約為 每人每月 20 美金，即使折扣後也仍需 約 17 美金。在如此規模下，僅授權本身就形成一筆相當可觀的開銷。同時，Bitbucket Data Center 的企業級授權費用也不低，使得跨部門想要共同使用平台時，往往因費用考量而受到限制，進而造成合作推動上的阻力。

相較之下，[Gitea 企業版本](https://docs.gitea.com/enterprise) 的授權模式明顯更具彈性。在大量採購帳號的情況下，單一帳號成本可降低至不到 10 美金。在大規模部門或跨團隊部署下，這樣的費用差異相當可觀，也大幅降低了跨部門協作的使用門檻。

## 🚀 CI/CD 才是我們轉換的最大關鍵原因

影響團隊最深、也是促使我們最終決定從 Bitbucket Data Center 轉向 Gitea 的核心理由，就是 **CI/CD 生態系的可用性與便利性**。在現代軟體開發流程中，如果 Git 平台沒有「可自主、易管理、可擴充的 CI/CD 系統」，那幾乎就像 **斷了一隻手一隻腳** 一樣，開發效率會受到極大限制。

Bitbucket 雖然有自家提供的 CI/CD 產品 [Bamboo](https://www.atlassian.com/software/bitbucket)，但實際使用上卻有不少痛點：

- **設定繁瑣、學習成本高**
- **流程不符合 IaC（Infrastructure as Code）精神**
- **在企業內部推廣阻力大**，只要工具設定過於複雜，團隊普遍就不願 adopt

對於已全面走向自動化與 IaC 的團隊來說，這樣的設計反而成為效率瓶頸。

## 🔥 Gitea Actions：承接 GitHub Actions 生態的最佳選擇

在評估替代方案時，我們非常關注 CI/CD 生態圈的發展，而目前最蓬勃的無疑是 **GitHub Actions**。也因此，Gitea 團隊在幾年前打造了相容 GitHub Actions 的 CI/CD 系統：

👉 **[Gitea Actions](https://about.gitea.com/products/runner/)**

這帶來幾項關鍵優勢：

### **1. 完整相容 GitHub Actions 語法**

- 可 **無痛搬移 GitHub Actions YAML**
- 可直接沿用 **GitHub 上大量 Action 範例 / plugin**
- **工程師不需要重新學一套 CI/CD 系統**

對已熟悉 GitHub Flow 的開發者來說，轉換成本極低。

---

### **2. 支援跨團隊部署與自建 Runner**

Gitea 支援讓每個團隊自行架設 Runner，使得：

- 資源分流更彈性
- 各專案可獨立維護自己的 CI/CD pipeline
- 不再被單一中央系統綁住
- 顯著降低跨團隊使用門檻

這一點對大型企業特別重要。

---

### **3. 與 AI 工作流整合，支援自動化 Code Review**

在 AI 越來越普及的今天，我們也將 👉 **[Anthropic Code Review Action](https://github.com/anthropics/claude-code-action)** 包裝成可在 Gitea Actions 上運作的流程。另外我們也開發了 **[LLM-Action](https://github.com/appleboy/LLM-action)**，讓團隊在處理自動化流程內可以加入 AI 元素。

這代表：

- PR 建立後可啟動 **AI 自動 Code Review**
- CI/CD pipeline 與 AI 深度整合
- 各團隊可自行擴充 AI 工具鏈

這讓整體開發流程更智慧、更現代化。

## Gitea 企業版功能

以下內容根據官方頁面整理而成（來源：[Gitea Enterprise 官方網站](https://about.gitea.com/products/gitea-enterprise/)）。整理如下，大家可以參考看看

### 🔐 1. Branch Protection Inheritance（分支保護繼承）

可在組織層級設定分支保護規則，並自動套用到該組織下所有 Repository。讓大型組織的規則一致性更容易管理。

---

### 🛡️ 2. Dependency Scanning（依賴掃描）

可自動掃描專案中的開源依賴，偵測與提醒安全弱點。減少供應鏈安全風險。

---

### 🔒 3. Advanced Security Features（進階安全機制）

企業版提升安全層級，包含：

- **IP Allowlist（IP 白名單）**：限制只能從特定 IP 存取
- **Mandatory 2FA（強制雙因子驗證）**：提升帳號安全性

非常適合高安全性要求的企業環境。

---

### 🧩 4. SAML 2.0 Authentication（SAML 單一登入整合）

支援 SAML 2.0 Service Provider，可與企業 Identity Provider 無縫整合（如 Azure AD、Okta、Keycloak）。

---

### 📜 5. Audit Log（稽核日誌）

提供完整稽核紀錄，可追蹤：

- 用戶操作
- 系統變更
- 敏感操作（權限、設定變動）

非常適合需遵循合規（如 ISO、SOC2、金融法規）的企業。

---

### 🔧 6. Familiar Upgrade / Smooth Transition（平滑升級與相容）

企業版基於 Gitea 開源版開發，兩者配置方式近乎一致，可互相切換，升級體驗平順，且支援長期維護（LTS）版本。如果有用過開源版本的 Gitea 肯定知道，升級方式非常簡單。

---

### 📈 7. Premium Support（企業支援服務）

購入企業版本後，可取得：

- 官方技術支援
- 線上客服
- 客戶中心支援服務

確保企業可快速解決問題。

## Migration 工具

我自行開發了這套轉移工具：[Bitbucket Data Center → Gitea Migration](https://github.com/appleboy/BitbucketServer2Gitea) 的專案、權限與團隊設定完整搬移至 Gitea。如果在使用過程中遇到任何問題，都歡迎直接在專案中提交 Issue，我會協助排查並提供解決方案，包含權限對應、團隊結構轉移等相關需求。

## 總結

上面講了這麼多 Gitea 的企業版功能以及相對應優勢。**Gitea 是一個兼具成本效益、彈性、高度相容性與現代化 DevOps 能力的 Git 平台。**  它不僅解決了我們在 Bitbucket DC 上的各種限制，也讓團隊在 CI/CD、治理、安全性與開發體驗上全面升級。  在多團隊跨部門協作成為常態的今天，Gitea 正是我們最合適的選擇。

如果企業需要長期且穩定的技術支援，選擇 Gitea 企業版會是更合適的方案。Gitea 官方團隊也曾協助我們完成多項關鍵導入工作，包括協助規劃如何將 Gitea 打造成高可用（HA）架構，以及指導我們將 Gitea Runner 以 Kubernetes 方式落地部署。這些成果都仰賴雙方密切合作，使我們能在企業內部更順利推動整體 DevOps 平台演進。
