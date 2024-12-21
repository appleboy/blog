---
title: Learning Go Language with GitLab API
date: 2024-11-16T15:15:56+08:00
draft: false
author: appleboy
type: post
slug: learning-go-language-with-gitlab-api-en
share_img: /images/2024-11-16/gitlab-flow.png
categories:
  - golang
  - gitlab-ci
  - gitea
---

![logo](/images/2024-11-16/gitlab-flow.png)

## Introduction

People often ask me how to learn [Go language][1], and I usually suggest they start with a real project to quickly learn the language's features. Personally, I started with small projects and gradually expanded their scope, from contributing to documentation to open-source projects, then learning how to modify the source code, and finally writing my own project. This learning method allows you to become familiar with the features of the Go language more quickly.

[1]: https://go.dev/

<!--more-->

## GitLab API

This article will introduce how to use the [GitLab API][2] to learn the Go language. Why choose this topic? As you may know, GitLab is a free and open-source Git version control system that provides a [RESTful API][3] for developers. Through the GitLab API, we can obtain project information, create projects, delete projects, get project file content, etc., or automate some tasks, such as automatically creating CI/CD processes after creating a project or automatically deploying projects to servers. But today, we encounter a problem: if the team's source code is hosted on [GitHub][4] or [Gitea][5], how can we trigger GitLab CI/CD processes through GitHub or [Gitea Action][6]? This way, teams can trigger each other's CI processes across platforms.

[2]: https://docs.gitlab.com/ee/api/
[3]: https://docs.gitlab.com/ee/api/rest/index.html
[4]: https://github.com
[5]: https://gitea.com/
[6]: https://docs.gitea.com/usage/actions/overview

## Implementation Process

The complete code can be found on [GitHub][11].

[11]: https://github.com/appleboy/drone-gitlab-ci/blob/master/go.mod

Here we will use the [Go language][12] to implement a simple program to obtain project information through the GitLab API. We use the [go-gitlab][13] package, a Go language package for the GitLab API, which makes it easier to use the GitLab API.

[12]: https://go.dev/
[13]: https://pkg.go.dev/github.com/xanzy/go-gitlab

To trigger a GitLab CI Pipeline, only one API is needed. Here we use the `CreatePipeline` method, which can trigger a CI Pipeline through the project ID.

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

However, after this execution, we need to wait for the CI Pipeline to complete. Here we can use the `GetPipelineStatus` method to get the status of the Pipeline. Since we need to wait for the CI Pipeline to complete, we need a timer `Ticker` loop to wait for the CI Pipeline to complete. And set a Timeout time, if it exceeds the Timeout time, an error message will be returned.

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

Take a look at the code above. Are there any areas that can be optimized? The main issue is that when using `time.After` with a for loop, the overall execution time is recalculated each time `ticker.C` triggers, which is not our intention.

We can optimize the code by using `context`, which makes it easier to control the execution time of the program.。

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

## Screenshot

The result of executing through GitHub Action can be found in the [GitHub Repo][44]

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

## Simple Example

How can you reproduce the issue described above? Refer to the code below::

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

This way you can replicate the issue above. By using `time.After` to set the timeout duration, you can simulate the issue above.

## Conclusion

Using the GitLab API to automate CI/CD processes is a great way to learn, as it helps you understand how CI/CD processes work and allows you to trigger CI/CD processes through code, making it easier to integrate into your projects. The Go language is an excellent language to learn, and implementing a small project in Go helps you become familiar with its features more quickly. This article aims to help those who want to learn the Go language understand the integration of [select][21] and [context][22], and how to use context to optimize code.

[21]: https://go.dev/ref/spec#Select_statements
[22]: https://pkg.go.dev/context
