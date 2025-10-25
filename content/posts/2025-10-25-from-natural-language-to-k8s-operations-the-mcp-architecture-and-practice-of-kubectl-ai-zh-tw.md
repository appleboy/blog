---
title: "從自然語言到 K8s 操作：kubectl-ai 的 MCP 架構與實踐"
date: 2025-10-25T09:53:53+08:00
slug: from-natural-language-to-k8s-operations-the-mcp-architecture-and-practice-of-kubectl-ai-zh-tw
share_img: /images/2025-10-25/blog-cover.png
categories:
  - kubernetes
  - AI
  - kubectl-ai
  - mcp-server
  - mcp-client
---

![blog cover](/images/2025-10-25/blog-cover.png)

[kubectl-ai][1] 是一個革命性的開源專案，將大型語言模型與 [Kubernetes][2] 運維完美結合，讓用戶能夠通過自然語言與 K8s 集群進行智能交互。本演講將深入探討這項創新技術如何解決傳統 [kubectl][3] 命令複雜性的痛點，大幅降低 Kubernetes 的使用門檻。

<!--more-->

我們將詳細介紹 kubectl-ai 的核心架構，包括 Agent 對話管理系統、可擴展的工具框架，以及創新的 MCP（[Model Context Protocol][4]）協議應用。該工具支援多種 LLM 提供商，從 Google Gemini, Anthropic Sonnet, Azure OpenAI 到本地部署模型，並具備雙重 MCP 模式設計 (MCP-Server + MCP-Client)。

[1]:https://github.com/GoogleCloudPlatform/kubectl-ai
[2]:https://kubernetes.io/
[3]:https://kubernetes.io/docs/reference/kubectl/
[4]:https://modelcontextprotocol.io/docs/getting-started/intro

## KubeSummit 投影片

{{< speakerdeck id="9861a365e82e4eccb9f0f4db6548bfe8" >}}

這是我第一次參加 [2025 台灣 KubeSummit 研討會][12]，演講的投影片已經上傳到 Speaker Deck，您可以在[這裡查看][11]。在 40 分鐘的演講中，涵蓋了底下內容

1. 為什麼需要 kubectl-ai？
2. 三種 kubectl-ai 使用場景
3. kubectl-ai 的 Agent 架構解析

[11]:https://speakerdeck.com/appleboy/from-natural-language-to-k8s-operations-the-mcp-architecture-and-practice-of-kubectl-ai
[12]:https://k8s.ithome.com.tw/2025/session-page/4096

底下我們就從三種使用場景開始介紹 kubectl-ai 的強大功能。

## kubectl-ai 三大使用場景

### 1. k8s 問題診斷助手

在日常的 Kubernetes 運維中，遇到各種錯誤和異常是常態。kubectl-ai 可以作為智能診斷助手，通過自然語言描述問題，快速定位並提供解決方案。例如，用戶可以詢問「為什麼 Nginx 不能啟動？」kubectl-ai 會分析集群狀態，並給出具體的排查步驟和建議。

我們先用底下 YAML 範例來建立一個 Nginx Deployment。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:wrong-tag  # wrong tag
        resources:
          requests:
            memory: "10Gi"      # wrong value
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx
  ports:
  - port: 80
```

可以看到上面的 Deployment 有兩個錯誤：一是 Nginx 映像檔標籤錯誤，二是記憶體請求值過高。當我們使用 kubectl-ai 詢問「為什麼 Nginx 不能啟動？」時，它會分析這些配置錯誤並提供具體的解決方案。

![demo01](/images/2025-10-25/demo01.png)

總結來說，kubectl-ai 作為 k8s 問題診斷助手，大大提升了運維效率，減少了排查時間，讓運維人員能夠更專注於核心業務。當然我知道大家會說，透過 [Claude Code][15] 也可以做到類似的功能，不過 kubectl-ai 是專門針對 Kubernetes 設計，能夠更深入地理解 k8s 的運作機制，提供更精準的診斷建議。除此之外，kubectl-ai 還提供兩大功能: MCP Server + MCP Client 模式，讓我們繼續看下去。

[15]:https://docs.claude.com/en/docs/claude-code/overview

### 2. MCP-Server 模式：擴展 LLM 功能

![mcp-server](/images/2025-10-25/mcp-server.png)

MCP-Server 模式允許 kubectl-ai 作為一個中介，將多種 LLM 功能整合到 Kubernetes 運維中。這種模式下，kubectl-ai 可以調用外部的 LLM 服務，如 Google Gemini、Anthropic Sonnet 或 Azure OpenAI，來處理複雜的自然語言請求。只用一行指令就能啟動 MCP-Server：

```bash
kubectl-ai --mcp-server \
  --mcp-server-mode \
  streamable-http \
  --http-port 9080
```

在 Claude Code 使用底下指令來串接 MCP-Server：

```bash
claude mcp add --transport http kubernetes http://localhost:9080/mcp
```

在 kuebctl-ai 提供兩個不同的工具集 (Toolset)：

1. bash: 用於執行基本的 shell 命令，適合處理簡單的任務。
2. kubectl: 專門用於 Kubernetes 操作，能夠生成和執行 kubectl 命令。

接下來你可以透過 Claude Code 或其他支援 MCP 協議的客戶端，來與 kubectl-ai 進行互動。例如，你可以在 Claude Code 中輸入「請幫我檢查所有 Pod 的狀態」，kubectl-ai 會調用後端的 LLM 來生成相應的 kubectl 命令並執行，然後返回結果。

除了上述功能外，MCP-Server 模式還支援自定義工具擴展，允許用戶根據具體需求添加新的操作工具，進一步提升系統的靈活性和可擴展性。也可以串接多個 MCP-Server 實例，實現更複雜的工作流程和協同操作。

```yaml
servers:
  - name: permiflow
    url: http://localhost:8080/mcp
  - name: jira-server
    url: https://localhost:8081/mcp
    skipVerify: true
    auth:
      type: "api-key"
      apiKey: "Token xxxxxxx"
      headerName: "Authorization"
```

可以加上 `--external-tools` 來啟用外部工具支援：

```bash
kubectl-ai --mcp-server \
  --mcp-server-mode \
  streamable-http \
  --http-port 9080 \
  --external-tools
```

### 3. MCP-Client 模式：一行指令使用多個服務

![mcp-client](/images/2025-10-25/mcp-client.png)

傳統我們想將 kubectl 掃描 RABC 安全性報告進行整理，並且發信給主管，或者是透過 Slack 傳送通知，通常需要撰寫複雜的腳本來實現這些功能。而使用 kubectl-ai 的 MCP-Client 模式，只需一行指令即可完成這些任務。

像是底下自然語言指令：

> 掃描 srv-gitea 命名空間中的 RBAC 權限，識別權限過高的 ServiceAccount，並在 GAIA 專案中建立一個 Jira 問題，將發現結果摘要包含在描述中。

```bash
kubectl-ai --mcp-client \
  "xxxxxxxxxxxxxxxxx"
```

在這個例子中，kubectl-ai 會自動生成相應的 kubectl 命令來掃描指定命名空間的 RBAC 權限，識別過度授權的 ServiceAccounts，然後使用 Jira API 創建一個新的問題，並將掃描結果摘要包含在描述中。這樣不僅簡化了操作流程，還大大提高了工作效率。

所以，MCP-Client 模式讓用戶能夠通過簡單的自然語言指令，輕鬆調用多個服務和工具，實現複雜的工作流程，無需編寫繁瑣的腳本，大大降低了技術門檻。

## 總結

[kubectl-ai][1] 通過其創新的 MCP 架構，為 Kubernetes 運維帶來了革命性的變革。無論是作為智能診斷助手，還是通過 MCP-Server 和 MCP-Client 模式擴展 LLM 功能和簡化操作流程，kubectl-ai 都展示了其強大的實用價值。隨著 Kubernetes 生態系統的持續發展，kubectl-ai 有望成為運維人員不可或缺的工具，助力企業實現更高效、更智能的雲原生運維管理。
