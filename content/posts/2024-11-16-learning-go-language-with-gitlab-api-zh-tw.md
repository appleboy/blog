---
title: 使用 GitLab API 學習 Go 語言
date: 2024-11-16T12:32:46+08:00
author: appleboy
type: post
slug: learning-go-language-with-gitlab-api-zh-tw
share_img: /images/2024-11-16/gitlab-flow.png
categories:
- golang
- gitlab-ci
- gitea
---

![logo](/images/2024-11-16/gitlab-flow.png)

## 前言

常常會有人問我如何學習 [Go 語言][1]，我通常會建議他們從實際專案開始，這樣可以更快的學習到語言的特性。個人也是透過先寫小專案，再慢慢擴大專案的範圍，從貢獻文件到開源專案，在進一步學習如何修改原始碼，最後再自己寫一個專案。這樣的學習方式可以讓你更快的熟悉 Go 語言的特性。

[1]: https://go.dev/

<!--more-->

## GitLab API

這篇文章將會介紹如何使用 [GitLab API][2] 來學習 Go 語言。為什麼會選擇這個主題呢？相信大家都知道 GitLab 是一套免費開源的 Git 版本控制系統，而且提供了一個 [RESTful API][3] 供開發者使用。透過 GitLab API，我們可以取得專案的資訊、建立專案、刪除專案、取得專案的檔案內容等等，或者是可以透過 GitLab API 來自動化一些工作，例如建立專案後自動建立 CI/CD 流程，或者是自動化部署專案到伺服器上。可是今天遇到一個問題，如果團隊 Source Code 放在 [GitHub][4] 或者是 [Gitea][5] 上，讓這樣如何透過 GitHub 或 [Gitea Action][6] 來觸發 GitLab CI/CD 流程呢？這樣就可以跨團隊互相觸發各自的 CI 流程。

[2]: https://docs.gitlab.com/ee/api/
[3]: https://docs.gitlab.com/ee/api/rest/index.html
[4]: https://github.com
[5]: https://gitea.com/
[6]: https://docs.gitea.com/usage/actions/overview

## 實作流程

完整的程式碼可以在 [GitHub][11] 上找到。

[11]: https://github.com/appleboy/drone-gitlab-ci/blob/master/go.mod

這邊我們將會使用 [Go 語言][12] 來實作一個簡單的程式，透過 GitLab API 來取得專案的資訊。這邊我們使用的是 [go-gitlab][13] 套件，這是一個 GitLab API 的 Go 語言套件，可以讓你更容易的使用 GitLab API。

[12]: https://go.dev/
[13]: https://pkg.go.dev/github.com/xanzy/go-gitlab

要觸發 GitLab CI Piepline 只需要一個 API 就可以完成，這邊我們使用的是 `CreatePipeline` 方法，這個方法可以透過專案 ID 來觸發 CI Pipeline。

```go
// Create Gitlab object
g, err := NewGitlab(p.Host, p.Token, p.Insecure, p.Debug)
if err != nil {
  return err
}

// Create pipeline
pipeline, err := g.CreatePipeline(p.ProjectID, p.Ref, p.Variables)
if err != nil {
  return err
}
```

但是這執行完成後，我們需要等待 CI Pipeline 執行完成，這邊我們可以透過 `GetPipelineStatus` 方法來取得 Pipeline 的狀態。由於需要等待 CI Pipeline 執行完成，所以我們需要一個定時器 `Ticker` 迴圈來等待 CI Pipeline 執行完成。並且設定一個 Timeout 時間，如果超過 Timeout 時間，則會回傳錯誤訊息。

```go
// Wait for pipeline to complete
ticker := time.NewTicker(p.Interval)
defer ticker.Stop()

l.Info("waiting for pipeline to complete", "timeout", p.Timeout)
for {
  select {
  case <-time.After(p.Timeout):
    return errors.New("timeout waiting for pipeline to complete after " + p.Timeout.String())
  case <-ticker.C:
    // Check pipeline status
    status, err := g.GetPipelineStatus(p.ProjectID, pipeline.ID)
    if err != nil {
      return err
    }

    l.Info("pipeline status",
      "status", status,
      "triggered_by", pipeline.User.Name,
    )

    // https://docs.gitlab.com/ee/api/pipelines.html
    // created, waiting_for_resource, preparing, pending,
    // running, success, failed, canceled, skipped, manual, scheduled
    if status == "success" ||
      status == "failed" ||
      status == "canceled" ||
      status == "skipped" {
      l.Info("pipeline completed", "status", status)
      if p.IsGitHub {
        // update status
        if err := gh.SetOutput(map[string]string{"status": status}); err != nil {
          return err
        }
      }
      return nil
    }
  }
}
```

大家看一下上面的程式碼，是不是有哪邊可以優化的地方呢？主要問題點是 Go 語言內，使用 select 時，如果有多個 case 條件同時間觸發，Go 語言會隨機選擇一個 case 來執行，這樣就會造成程式的執行時間不穩定。

這邊我們可以透過 `context` 來優化程式碼，這樣就可以更容易的控制程式的執行時間。

```go
// Create a new context with a timeout
ctx, cancel := context.WithTimeout(context.Background(), p.Timeout)
defer cancel()
for {
  select {
  case <-ctxTimeout.Done():
    return errors.New("timeout waiting for pipeline to complete after " + p.Timeout.String())
  case <-ticker.C:
    if ctxTimeout.Err() != nil {
      if p.IsGitHub {
        // update status
        if err := gh.SetOutput(map[string]string{"status": status}); err != nil {
          return err
        }
      }
      return ctxTimeout.Err()
    }
  }
}
```

## 結論

透過 GitLab API 來自動化 CI/CD 流程是一個很好的學習方式，這樣可以讓你更了解 CI/CD 流程的運作方式，並且可以透過程式碼來觸發 CI/CD 流程，這樣就可以更容易的整合到你的專案中。而 Go 語言是一個很好的學習語言，透過 Go 語言來實作一個小專案，這樣可以讓你更快的熟悉 Go 語言的特性。本篇重點是讓想學習 Go 語言的朋友了解 [select][21] 及 [context][22] 的整合，並且如何使用 context 來優化程式碼。

[21]: https://go.dev/ref/spec#Select_statements
[22]: https://pkg.go.dev/context
