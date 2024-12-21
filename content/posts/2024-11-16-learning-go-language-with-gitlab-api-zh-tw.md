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

大家看一下上面的程式碼，是不是有哪邊可以優化的地方呢？主要是在使用 `time.After` 時候搭配 for 迴圈，會變成每次 `ticker.C` 時間到後，會重新再計算整體執行時間，這樣就不是我們的初衷。

這邊可以透過 `context` 來優化程式碼，這樣就可以更容易的控制程式的執行時間。

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

## 畫面

透過 GitHub Action 執行成果，大家可以參考 [GitHub Repo][44]

[44]: https://github.com/appleboy/gitlab-ci-action

![gitlab-ci-action](/images/2024-11-16/screenshot.png)

```sh
time=2024-10-21T15:17:42.079Z level=INFO msg="pipeline created" project_id=***
pipeline_id=1505619557 pipeline_sha=a36503d3ba12e7832752e17c213efd09000fac03
pipeline_ref=main pipeline_status=created
pipeline_web_url=https://gitlab.com/appleboy/test/-/pipelines/1505619557
pipeline_created_at=2024-10-21T15:17:41.767Z
time=2024-10-21T15:17:42.079Z level=INFO msg="waiting for pipeline to complete" project_id=*** timeout=1h0m0s
time=2024-10-21T15:17:47.237Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:17:52.212Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:17:57.209Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:02.219Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:07.217Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:12.222Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:17.210Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:22.235Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:27.219Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:32.241Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:37.395Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:42.219Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:47.229Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:52.211Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:18:57.225Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:02.219Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:07.247Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:12.283Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:17.254Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:22.200Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:27.208Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:32.213Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:37.244Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:42.256Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:47.219Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:52.217Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:19:57.234Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:20:02.226Z level=INFO msg="pipeline status" project_id=*** status=running triggered_by="Bo-Yi Wu"
time=2024-10-21T15:20:07.283Z level=INFO msg="pipeline status" project_id=*** status=success triggered_by="Bo-Yi Wu"
time=2024-10-21T15:20:07.283Z level=INFO msg="pipeline completed" project_id=*** status=success
```

## 簡單案例

要如何複製上面的問題呢？可以參考底下代碼：

```go
package main

import (
  "time"
)

func main() {
  output := make(chan int, 10)

  go func() {
    for i := 0; i < 30; i++ {
      output <- i
      time.Sleep(100 * time.Millisecond)
    }
  }()

  // how to fix the timeout issue?
  for {
    select {
    case val := <-output:
      // simulate slow consumer
      time.Sleep(500 * time.Millisecond)
      println("output:", val)
    // how to fix the timeout issue?
    case <-time.After(1 * time.Second):
      println("timeout")
      return
    }
  }
}
```

這樣就可以複製上面的問題，透過 `time.After` 來設定 Timeout 時間，這樣就可以模擬上面的問題。

## 結論

透過 GitLab API 來自動化 CI/CD 流程是一個很好的學習方式，這樣可以讓你更了解 CI/CD 流程的運作方式，並且可以透過程式碼來觸發 CI/CD 流程，這樣就可以更容易的整合到你的專案中。而 Go 語言是一個很好的學習語言，透過 Go 語言來實作一個小專案，這樣可以讓你更快的熟悉 Go 語言的特性。本篇重點是讓想學習 Go 語言的朋友了解 [select][21] 及 [context][22] 的整合，並且如何使用 context 來優化程式碼。

[21]: https://go.dev/ref/spec#Select_statements
[22]: https://pkg.go.dev/context
