---
title: GitHub 推出 CI/CD 服務 Actions 之踩雷經驗
author: appleboy
type: post
date: 2019-05-21T09:12:40+00:00
url: /2019/05/introduction-to-github-actions/
dsq_thread_id:
  - 7430386384
categories:
  - DevOps
  - Docker
tags:
  - Docker
  - Github
  - GitHub Actions

---
[![GitHub Actions 簡介][1]][1]

今年很高興又去 [Cloud Summit 研討會][2]給一場議程『初探 GitHub 自動化流程工具 Actions』，這場議程沒有講很多如何使用 [GitHub Actions][3]，反倒是講了很多設計上的缺陷，以及為什麼我現在不推薦使用。GitHub Actions 在去年推出來，在這麼多 CI/CD 的免費服務，GitHub 自家出來做很正常，我還在想到底什麼時候才會推出，beta 版出來馬上就申請來試用，但是使用下來體驗非常的不好，有蠻多不方便的地方，底下我們就來聊聊 GitHub Acitons 有哪些缺陷以及該改進的地方。

<!--more-->

## 簡報檔案

## 無法及時看到 Log 輸出

如果一個 Job 需要跑 30 分鐘，甚至更久，開發者一定會希望可以即時看到目前輸出了哪些 Log，看到 Log 的檔案，就可以知道下一步該怎麼修改，而不是等到 Job 結束後才可以看到 Log，然而 GitHub Actions 就是這樣神奇，需要等到 Job 跑完，才可以看到完整的 Log，你無法在執行過程看到任何一行 Log。光是這一點，直接打槍了 Firmware 開發者。

## 無法直接重新啟動 Job

通常有時候我們會需要重新跑已經失敗或者是取消的 Job，但是不好意思，GitHub Actions 沒有任何按鈕可以讓你重新跑單一 Commit 的 Job，你必須要重新 push 後，才可以重新啟動 Job，我覺得非常不合理，在 UI 上面有支持 Stop Job，但是不支援 Restart Job，我只能 .... 了。透過底下可以重新啟動 Job，但是太笨了

<pre><code class="language-shell">$ git reset —soft HEAD^
$ git commit -a -m "foo"
$ git push origin master -f</code></pre>

## 不支援 Global Secrets

假設在一個 organization 底下有 100 個 repository，每個 repository 都需要部署程式到遠端機器，這時候就必須要在每個 repo 設定 SSH Key 在 Secrets 選單內，但是必須要設定 100 次，假設支持在 organization 設定該有多好。

## 不支援第三方 Secrets 管理

除了用 Git 來管理 Secrets 之外，現在很流行透過第三方，像是 [Vault][4], [AWS Secrets][5] 或 [kubernetes secret][6]，很抱歉，目前還沒支援第三方服務，現在還只能使用 GitHub 後台給的 Secrets 設定。

## 強制寫 CLI Flag

舉個實際例子比較快，現在有個 repo 必須同時部署到兩台密碼不同的 Linux Server，假設 Image 只支援 Password 這 global variable

<pre><code class="language-shell">  secrets = [
    "PASSWORD",
  ]
  args = [
    "--user", "actions",
    "--script", "whoami",
  ] </code></pre>

我該怎麼在後台設定兩個不同變數讓 Docker 去讀取，這邊就不能這樣解決，所以開發者必須在程式裡面支援 指定 CLI 變數

<pre><code class="language-shell">  secrets = [
    "PASSWORD01",
  ]
  args = [
    "-p", "$PASSWORD01",
    "--script", "whoami",
  ] </code></pre>

如果 Actions 沒有支援 `-p` 來設定參數，我相信這個套件肯定不能用。這就是 GitHub Actions 的缺點。我們看看 Drone 怎麼實作:

<pre><code class="language-yaml">kind: pipeline
name: default

steps:
- name: build
  image: appleboy/drone-ssh
  environment:
    USERNAME:
      from_secret: username
    PASSWORD:
      from_secret: password </code></pre>

有沒有注意到 `from_secret` 用來接受多個不同的 variable 變數。

## 環境變數太少

<pre><code class="language-shell">action "Hello World" {
  uses = "./my-action"
  env = {
    FIRST_NAME  = "Mona"
    MIDDLE_NAME = "Lisa"
    LAST_NAME   = "Octocat"
  }
} </code></pre>

在 Actions 內開發者可以拿到底下變數內容

  * GITHUB_WORKFLOW
  * GITHUB_ACTION
  * GITHUB_EVNETNAME
  * GITHUB_SHA
  * GITHUB_REF

大家有沒有發現，那這個 commit 的作者或者是 commit message 該去哪邊拿？沒有這些資訊我怎麼寫 chat bot 發通知呢？該不會要開發者自己在打 RESTful API 吧？

## 心得

上面這些缺陷，真的讓大家用不下去，如果你再評估 GitHub Actions 的時候，可以參考看看這邊是否已經改善了？可以參考[我開發的 GitHub Actions][7]。

 [1]: https://lh3.googleusercontent.com/vs6XKU4keYmwiBUeWrTVbYl4WKH7cTcmu6Lcggv0QWEBK81D06mbPg7skrmlnYrUf0JlEzhwjJwtmjVJ4p9wLXmbTs4mmzviiCK1RRwBhRXGom5w_3JSQwnV6UUbfH5Pd9uNNU5SCQE=w1920-h1080 "GitHub Actions 簡介"
 [2]: https://cloudsummit.ithome.com.tw/
 [3]: https://github.com/features/actions
 [4]: https://www.vaultproject.io/
 [5]: https://aws.amazon.com/tw/secrets-manager/
 [6]: https://kubernetes.io/docs/concepts/configuration/secret/
 [7]: https://github.com/appleboy?utf8=%E2%9C%93&tab=repositories&q=actions&type=&language=