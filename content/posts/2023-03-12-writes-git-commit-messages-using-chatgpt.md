---
title: "用 ChatGPT 自動幫開發者產生 Commit Message"
date: 2023-03-12T15:53:55+08:00
author: appleboy
type: post
slug: writes-git-commit-messages-using-chatgpt
share_img: https://i.imgur.com/LPYqF26.png
categories:
  - Golang
  - ChatGPT
---

![Cover](https://i.imgur.com/LPYqF26.png)

相信大家對 [ChatGPT][1] 不會很陌生，這是目前在生成式人工智慧 (AIGC: AI Generated Content) 內的當紅炸子雞，然而 ChatGPT 對於軟體工程師有什麼影響呢？能否透過 ChatGPT 改善團隊流程或協助開發？而我現在想到最直接的就是用 ChatGTP 幫忙寫 Git Commit Message，然而怎麼把 Commit Message 寫好可以參考[這篇文章][2]，為了能達成這目的，我用 [Go 語言][4]寫了一個 CLI 工具 [CodeGPT][3] (請大家幫忙分享)，來解決軟體開發工程師不知道怎麼把 Message 寫好。底下先看看使用 CodeGPT 來產生 Commit Message 的成果

<!--more-->

![CI](https://i.imgur.com/AG6MWQe.png)

上面圖示內容可以從 CodeGPT 的 [Commit Log][5] 找到

[1]:https://zh.wikipedia.org/zh-tw/ChatGPT
[2]:https://wadehuanglearning.blogspot.com/2019/05/commit-commit-commit-why-what-commit.html
[3]:https://github.com/appleboy/CodeGPT
[4]:https://go.dev
[5]:https://github.com/appleboy/CodeGPT/commits/main

## 為什麼要寫 CodeGPT

其實在 GitHub 平台上面已經有超多這樣[類似的工具][11]可以使用了，而我為什麼要再重新開發一次呢？第一個原因是跨平台，透過 Go 語言可以快速產生執行檔，避免不同平台還要安裝不同的環境，這樣對於不熟環境的開發者可以更容易安裝。

第二個原因是未來規劃朝向整合 GitHub, Gitea 或 Bitbucket 等 Git 平台，發 PR 後，可以透過 ChatGPT 自動幫忙整裡 Commit 內容且自動留言。所以這工具不只是單純讓開發者可以自行產生 Commit Message 而已，未來也會整合成容器化服務，協助進行 Code Review。

第三個原因是未來不只是接 OpenAI 的 API 而已，ChatGPT API 目前也已經在 [Azure OpenAI Service 支援][12]了，所以之後除了原本的 OpenAI 外，還會整合微軟 Azure 服務。

[11]:https://github.com/search?q=commit%20message%20chatgpt&type=repositories
[12]:https://azure.microsoft.com/en-us/blog/chatgpt-is-now-available-in-azure-openai-service/

## 使用方式

目前每次釋出都會產生 Linux, MacOS 及 Windows 相對應的執行檔案，只要下載放在 `bin` 目錄底下即可，接著到 OpenAI 網站申請 API Key，第一個月免費 18 美金，其實每天用量都不到一美金，相當便宜，信用卡放上去就對了。將 API Key 寫到環境變數

```sh
export OPENAI_API_KEY=sk-xxxxxxx
```

接著將需要 commit 的檔案透過 git add 方式加入，再執行底下指令

```sh
codegpt commit --preview
```

* `--preview`: 代表預覽。
* `--lang`: 翻譯成不同語言，目前支援 `zh-tw`, `zh-tw`, `ja` 三種語言
* `--model`: 選擇模型 (預設是 `gpt-3.5-turbo`)
* `--diff_unified`: git diff 指令上下文可以看到的範圍，預設是 3 行
* `--exclude_list`: 略過指定的檔案 (有些檔案不想讓 AI 去讀)

`--diff_unified` 的使用時機在於特定場景 (在 GitHub 上面[有人提到][31])，看看底下 diff 測試資料

```diff
@ cmd/config.go:19 @ func init() {
    configCmd.PersistentFlags().StringP("api_key", "k", "", "openai api key")
    configCmd.PersistentFlags().StringP("model", "m", "gpt-3.5-turbo", "openai model")
    configCmd.PersistentFlags().StringP("lang", "l", "en", "summarizing language uses English by default")
+
    configCmd.PersistentFlags().StringP("org_id", "o", "", "openai requesting organization")
    configCmd.PersistentFlags().StringP("proxy", "", "", "http proxy")
    configCmd.PersistentFlags().IntP("diff_unified", "", 3, "generate diffs with <n> lines of context, default is 3")
```

如果用預設值，將內容丟給 ChatGPT 產生總結

```sh
$ codegpt commit --preview
Summarize the commit message use gpt-3.5-turbo model
We are trying to summarize a git diff
We are trying to summarize a title for pull request
================Commit Summary====================

feat: update config command with new flags and default value change

- Add a new flag `org_id` to the config command
- Add a new flag `proxy` to the config command
- Change the default value of `diff_unified` flag to `3` in the config command.

==================================================
Write the commit message to .git/COMMIT_EDITMSG file
```

加上 `--diff_unified` 參數設定為 0，會更精準 請看底下結果

```sh
$ codegpt commit --preview --diff_unified=0
Summarize the commit message use gpt-3.5-turbo model
We are trying to summarize a git diff
We are trying to summarize a title for pull request
================Commit Summary====================

style: refactor initialization function in cmd/config.go

- Add an empty line in `cmd/config.go` init function

==================================================
Write the commit message to .git/COMMIT_EDITMSG file
```

[31]:https://github.com/appleboy/CodeGPT/issues/21

## 心得

由於中國跟香港或者是部分公司對於 ChatGPT 有嚴格的封鎖政策，故在此工具多了設定 Proxy 功能，可以讓大家透過 Proxy 方式出去訪問 OpenAI API，公司希望特定的機器才可以出去。下一階段預計整合 Azure OpenAI 服務進來。用了此工具後，省下開發者不少時間，尤其是需要常常 Commit，又不知道該如何整裡內容。如果喜歡的話可以按個 Star [CodeGPT](https://github.com/appleboy/CodeGPT).
