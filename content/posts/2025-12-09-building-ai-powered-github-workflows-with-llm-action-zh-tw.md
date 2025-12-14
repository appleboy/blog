---
title: "打造 AI 驅動的 GitHub 工作流程：LLM Action 完整指南"
date: 2025-12-09T14:51:47+08:00
draft: false
slug: building-ai-powered-github-workflows-with-llm-action-zh-tw
share_img: /images/2025-12-09/blog_cover_1024x572_tw.png
categories:
  - GitHub Actions
  - AI
  - CI/CD
  - DevOps
---

![blog cover](/images/2025-12-09/blog_cover_1024x572_tw.png)

在 AI 時代，將大型語言模型整合進 CI/CD 流程已成為提升開發效率的關鍵。然而，現有的解決方案往往綁定特定服務商，且 LLM 的輸出通常是非結構化的自由文字，難以在自動化流程中可靠地解析與使用。[LLM Action][1] 的誕生正是為了解決這些痛點。

最核心的特色是支援 [Tool Schema][2] 結構化輸出——你可以預先定義 JSON Schema，讓 LLM 的回應強制符合指定格式。這意味著 AI
不再只是回傳一段文字，而是產出可預測、可解析的結構化資料，每個欄位都會自動轉換為 GitHub Actions
的輸出變數，讓後續步驟能直接取用，無需額外的字串解析或正則表達式處理。這徹底解決了 LLM 輸出不穩定、難以整合進自動化流程的問題。

此外，LLM Action 提供統一介面串接任何 OpenAI 相容的服務，無論是雲端的 OpenAI、Azure OpenAI，還是本地部署的 Ollama、LocalAI、LM Studio、vLLM
等自託管方案，都能無縫切換。

實際應用場景包括：

- 自動化 Code Review：定義 Schema 輸出 `score`、`issues`、`suggestions` 等欄位，直接用於判斷是否通過審查
- PR 摘要生成：結構化輸出 `title`、`summary`、`breaking_changes` 供後續自動更新 PR 描述
- Issue 分類：輸出 `category`、`priority`、`labels` 自動為 Issue 加上標籤
- Release Notes：產出 `features`、`bugfixes`、`breaking` 陣列，自動組成格式化的發布說明
- 多語言翻譯：批次輸出多個語言欄位，一次 API 呼叫完成多語系翻譯

透過 Schema 定義，LLM Action 讓 AI 輸出從「不可預測的文字」變成「可程式化的資料」，真正實現端到端的 AI 自動化工作流程。

[1]: https://github.com/appleboy/LLM-action
[2]: https://platform.openai.com/docs/guides/function-calling

<!--more-->

## 基本使用方式

最簡單的使用方式，只需要提供 API Key、模型名稱和 Prompt：

```yaml
- name: Simple LLM Call
  uses: appleboy/llm-action@v1
  with:
    api_key: ${{ secrets.OPENAI_API_KEY }}
    model: gpt-4o
    input_prompt: "請用一句話總結這段程式碼的功能"
```

### 支援多種 LLM Provider

LLM Action 支援任何 OpenAI 相容的服務，只需調整 `base_url` 參數：

```yaml
# OpenAI (預設)
- uses: appleboy/llm-action@v1
  with:
    api_key: ${{ secrets.OPENAI_API_KEY }}
    model: gpt-4o
    input_prompt: "你的 prompt"

# Ollama (本地部署)
- uses: appleboy/llm-action@v1
  with:
    base_url: http://localhost:11434/v1
    model: llama3
    input_prompt: "你的 prompt"

# Azure OpenAI
- uses: appleboy/llm-action@v1
  with:
    base_url: https://your-resource.openai.azure.com
    api_key: ${{ secrets.AZURE_OPENAI_KEY }}
    model: gpt-4o
    input_prompt: "你的 prompt"

# Groq
- uses: appleboy/llm-action@v1
  with:
    base_url: https://api.groq.com/openai/v1
    api_key: ${{ secrets.GROQ_API_KEY }}
    model: llama-3.1-70b-versatile
    input_prompt: "你的 prompt"
```

## 應用場景

### Code Review 結果 Schema

```json
{
  "type": "object",
  "properties": {
    "score": { "type": "number" },
    "issues": { "type": "array", "items": { "type": "string" } },
    "suggestions": { "type": "array", "items": { "type": "string" } }
  },
  "required": ["score", "issues", "suggestions"]
}
```

### PR 摘要生成 Schema

```json
{
  "type": "object",
  "properties": {
    "title": { "type": "string" },
    "summary": { "type": "string" },
    "breaking_changes": { "type": "array", "items": { "type": "string" } }
  }
}
```

### Issue 分類 Schema

```json
{
  "type": "object",
  "properties": {
    "category": { "type": "string" },
    "priority": { "type": "string", "enum": ["high", "medium", "low"] },
    "labels": { "type": "array", "items": { "type": "string" } }
  }
}
```

## 實際 GitHub Actions 範例

以下是一個完整的自動化 Code Review 範例，展示如何透過 Tool Schema 讓 LLM 輸出結構化的審查結果：

```yaml
name: AI Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  code-review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get PR diff
        id: diff
        run: |
          DIFF=$(git diff origin/${{ github.base_ref }}...HEAD)
          echo "diff<<EOF" >> $GITHUB_OUTPUT
          echo "$DIFF" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: AI Code Review
        id: review
        uses: appleboy/llm-action@v1
        with:
          api_key: ${{ secrets.OPENAI_API_KEY }}
          model: gpt-4o
          system_prompt: |
            你是一位資深的程式碼審查專家。請根據以下標準審查程式碼：
            1. 程式碼品質與可讀性
            2. 潛在的 Bug 或安全漏洞
            3. 效能問題
            4. 最佳實踐建議
          input_prompt: |
            請審查以下 Pull Request 的程式碼變更：

            ${{ steps.diff.outputs.diff }}
          tool_schema: |
            {
              "name": "code_review",
              "description": "程式碼審查結果",
              "parameters": {
                "type": "object",
                "properties": {
                  "score": {
                    "type": "string",
                    "description": "評分 1-10，10 為最佳"
                  },
                  "summary": {
                    "type": "string",
                    "description": "審查摘要，50 字以內"
                  },
                  "issues": {
                    "type": "string",
                    "description": "發現的問題，以 markdown 列表格式"
                  },
                  "suggestions": {
                    "type": "string",
                    "description": "改善建議，以 markdown 列表格式"
                  },
                  "approved": {
                    "type": "string",
                    "description": "是否建議合併：yes 或 no"
                  }
                },
                "required": ["score", "summary", "issues", "suggestions", "approved"]
              }
            }

      - name: Comment on PR
        uses: actions/github-script@v7
        with:
          script: |
            const score = '${{ steps.review.outputs.score }}';
            const summary = '${{ steps.review.outputs.summary }}';
            const issues = '${{ steps.review.outputs.issues }}';
            const suggestions = '${{ steps.review.outputs.suggestions }}';
            const approved = '${{ steps.review.outputs.approved }}';

            const emoji = approved === 'yes' ? '✅' : '⚠️';

            const body = `## ${emoji} AI Code Review 結果

            **評分：** ${score}/10

            **摘要：** ${summary}

            ### 🔍 發現的問題
            ${issues || '無'}

            ### 💡 改善建議
            ${suggestions || '無'}

            ---
            *此審查由 AI 自動產生，僅供參考*`;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: body
            });

      - name: Set review status
        if: steps.review.outputs.approved == 'no'
        run: |
          echo "::warning::AI 審查建議：此 PR 需要進一步修改"
          exit 1
```

## 關鍵說明

### Tool Schema 的威力

```json
{
  "score": "8",
  "summary": "整體程式碼品質良好，但有幾處可以優化",
  "issues": "- 第 42 行存在潛在的 SQL injection 風險\n- 缺少錯誤處理",
  "suggestions": "- 使用參數化查詢\n- 加入 try-catch 區塊",
  "approved": "no"
}
```

每個欄位都會自動成為 GitHub Actions 的輸出變數：

- `${{ steps.review.outputs.score }}` → `8`
- `${{ steps.review.outputs.approved }}` → `no`

此外，完整的 JSON 結果也會存放在 `steps.review.outputs.response` 中，你可以透過 `${{ fromJSON(steps.review.outputs.response) }}` 取得整個物件，方便在需要一次處理多個欄位時使用：

```yaml
- name: Process full response
  run: |
    echo "完整回應: ${{ steps.review.outputs.response }}"
    # 或透過 fromJSON 取得特定欄位
    echo "評分: ${{ fromJSON(steps.review.outputs.response).score }}"
```

這解決了傳統做法的痛點：

| 傳統做法             | 使用 Tool Schema                      |
| -------------------- | ------------------------------------- |
| LLM 回傳自由格式文字 | 強制輸出指定 JSON 結構                |
| 需用正則表達式解析   | 欄位自動轉為輸出變數                  |
| 格式不穩定，容易出錯 | 100% 可預測的結構化資料               |
| 難以做條件判斷       | 直接用 `if: outputs.approved == 'no'` |

透過這個模式，你可以輕鬆建立可靠的 AI 自動化流程，讓 Code Review 結果直接驅動後續動作——無論是留言、加標籤、阻擋合併，都能精準控制。

## 總結

LLM Action 解決了將 AI 整合進 CI/CD 流程的兩大痛點：**服務商綁定**與**輸出不可預測**。透過統一的 OpenAI 相容介面，你可以自由切換各種雲端或本地 LLM 服務；透過 Tool Schema 結構化輸出，AI 的回應不再是難以解析的自由文字，而是可程式化、可預測的結構化資料。

無論你想要自動化 Code Review、生成 PR 摘要、分類 Issue，還是產出 Release Notes，LLM Action 都能讓 AI 輸出直接驅動後續的自動化流程，真正實現端到端的 AI 工作流程整合。

歡迎前往 [GitHub 專案頁面][1] 查看更多範例與完整文件，開始打造屬於你的 AI 驅動開發流程！
