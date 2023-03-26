---
title: "用 ChatGPT 幫忙進行 Code Review 給建議"
date: 2023-03-26T17:05:10+08:00
author: appleboy
type: post
slug: code-review-brief-using-chatgpt-gpt4
share_img: https://i.imgur.com/LPYqF26.png
categories:
  - Golang
  - ChatGPT
---

![Cover](https://i.imgur.com/LPYqF26.png)

上一篇文章我們介紹了如何[使用 ChatGPT 來自動生成 Commit Message][1]，這篇文章來介紹如何使用 ChatGPT 來進行 Code Review。在月初開發的 [CodeGPT][2] 已經讓開發者可以使用 [GPT-3.5-Turbo][3] 來進行生成 Commit 總結，這個功能省下開發者不少整理開發內容時間，但是我覺得還是不夠，大家除了開發外，還花了很多時間在進行 Code Review，所以如果有工具，可以讓開發者可以提前知道優化的項目，這可以省下不少 Review 的時間。

[1]:https://blog.wu-boy.com/2023/03/writes-git-commit-messages-using-chatgpt/
[2]:https://github.com/appleboy/CodeGPT
[3]:https://platform.openai.com/docs/models/gpt-3-5

<!--more-->

## 使用 ChatGPT 來進行 Code Review

在 [CodeGPT][2] 中，我們已經將 [GPT-3.5-Turbo][3] 的 API 包裝成了一個 CLI 工具，所以使用起來非常的簡單，只要執行以下指令即可：

```bash
git add your-code-file-path
codegpt review
```

有些檔案你想直接略過，可以使用 `--exclude_list` 參數來忽略：

```bash
codegpt review --exclude_list=vendor,third_party
```

如果想要針對上一個 Commit 重新進行 Code Review，可以使用 `--amend` 參數：

```bash
codegpt review --amend
```

預設的 Code Review 會使用 [GPT-3.5-Turbo][3] 來進行生成，如果你想要使用 [GPT-4][4]，可以使用 `--model` 參數來指定：

```bash
codegpt review --model=gpt4
```

[4]:https://platform.openai.com/docs/models/gpt-4

預設輸出會以英文的方式進行輸出，如果你想要使用中文的方式，可以使用 `--lang` 參數來指定 (目前支援 `zh-tw`, `zh-cn` 跟 `jp`)：

```bash
codegpt review --lang=zh-tw
```

預設輸出的長度為 300 個 tokens，如果你想要調整長度，可以使用 `--max_tokens` 參數來指定：

```bash
codegpt review --max_tokens=500
```

如果輸出為英文基本上 `300` tokens 都是足夠的，但是如果輸出為中文，建議可以調整到 `500` tokens。

## 實際範例

可以先以下面 PHP 案例來進行測試：

```php
<?php
if( isset( $_POST[ 'Submit' ]  ) ) {
  // Get input
  $target = $_REQUEST[ 'ip' ];
  // Determine OS and execute the ping command.
  if( stristr( php_uname( 's' ), 'Windows NT' ) ) {
    // Windows
    $cmd = shell_exec( 'ping  ' . $target );
  }
  else {
    // *nix
    $cmd = shell_exec( 'ping  -c 4 ' . $target );
  }
  // Feedback for the end user
  $html .= "<pre>{$cmd}</pre>";
}
```

執行以下指令來進行 Code Review：

```bash
git add test.php
codegpt review
```

輸出結果如下：

Code review:

1. Security: The code is vulnerable to command injection attacks as the user input is directly used in the shell_exec() function. An attacker can potentially execute malicious commands on the server by injecting them into the 'ip' parameter.
2. Error handling: There is no error handling in the code. If the ping command fails, the error message is not displayed to the user.
3. Input validation: There is no input validation for the 'ip' parameter. It should be validated to ensure that it is a valid IP address or domain name.
4. Cross-platform issues: The code assumes that the server is either running Windows or *nix operating systems. It may not work correctly on other platforms.

Suggestions for improvement:

1. Use escapeshellarg() function to sanitize the user input before passing it to shell_exec() function to prevent command injection.
2. Implement error handling to display error messages to the user if the ping command fails.
3. Use a regular expression to validate the 'ip' parameter to ensure that it is a valid IP address or domain name.
4. Use a more robust method to determine the operating system, such as the PHP_OS constant, which can detect a wider range of operating systems.

大家可以看到上面給的建議非常的好，內容可以提到解決方案使用 `escapeshellarg()` 來避免 Command Injection，以及使用 `PHP_OS` 來判斷作業系統，這些都是非常實用的建議。或者是透過 regular expression 來驗證 IP 位址或是 Domain Name。

## 心得感想

透過 [CodeGPT][2] 可以讓開發者可以提前知道優化的項目，這可以省下不少 Review 的時間，但是目前 [CodeGPT][2] 還有很多的功能需要開發，。未來會整合 [GitHub Action][5] 來讓大家可以在 Pull Request 中進行 Code Review，也會整合 Slack 來讓大家可以在 Slack 中進行 Code Review，如果大家有什麼建議或是想要的功能，可以在 [CodeGPT][2] 的 Issue 中提出來，我們會盡快開發出來。

[5]:https://github.com/features/actions
