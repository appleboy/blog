---
title: Drone 自動觸發 GitLab CI 或 Jenkins 任務
author: appleboy
type: post
date: 2017-06-28T04:24:31+00:00
url: /2017/06/trigger-gitlab-ci-or-jenkins-using-drone/
dsq_thread_id:
  - 5947540750
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - Docker
  - drone
  - GitLab
  - Jenkins

---
[<img src="https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg?w=840&#038;ssl=1" alt="drone-logo_512" data-recalc-dims="1" />][1]

[Drone][2] 是一套由 [Go 語言][3]所開發的開源碼專案，讓開發者可以使用 [Docker][4] Container 快速設定自動化測試及部署，上篇有提到『[Cronjob 搭配 Drone 服務][5]』，讓 [Jenkins][6] 或 [GitLab CI][7] 用戶可以轉換 Cron Job 任務到 Drone 上面。本篇則是會介紹如何透過 Drone 去觸發 Jenkins 或 GitLab CI 上的工作，當然這是過渡時期，希望大家最後能將工作完整移轉到 Drone 上面，不要再依靠 Jenkins 或 GitLab CI 了。本篇會教大家用三種方式來觸發 GitLab CI 或 Jenkins 任務。

* * *

  * 使用 Drone CI/CD
  * 使用 Docker 指令
  * 使用 Command Line (命令列)

<!--more-->

## 觸發 GitLab CI

不管是 GitLab CI 或是 Jenkins 都可以透過該服務提供的 HTTP API 來遠端觸發，而我用 Go 語言將觸發這動作寫成 Drone Plugin，讓 Drone 用戶可以不用自己寫 curl 去觸發。

### 申請專案 Token

要透過 HTTP API 去觸發任務，首先就是要申請專案 Token，請大家參考 [Triggering pipelines through the API][8] 頁面。申請完成後，請把專案 ID 跟 Token 帶入底下使用。

### 使用 Drone 觸發

```yml
pipeline:
  gitlab:
    image: appleboy/drone-gitlab-ci
    host: https://gitlab.com
    token: xxxxxxxxxx
    ref: master
    id: gitlab-project-id
```

其中 `host` 請改成公司內部的 Git 伺服器網址，`id` 是專案獨立 ID，最後 `Token` 則是上面步驟所拿到的 Token。詳細設定可以參考 [README][9]，如果不是用 Drone 也沒關係，可以用 [Docker][4] 或透過 Go 語言可以包成各作業系統執行檔 (包含 Windows)

### 使用 Docker 觸發

請使用 [appleboy/drone-gitlab-ci][10] 映像檔，檔案大小為 **2MB**

```bash
docker run --rm \
  -e GITLAB_HOST=https://gitlab.com/
  -e GITLAB_TOKEN=xxxxx
  -e GITLAB_REF=master
  -e GITLAB_ID=gitlab-ci-project-id
  appleboy/drone-gitlab-ci
```

### 使用 CLI 觸發

請先從 [Release 頁面][11]下載相關執行檔，重點是你也可以在 Windows 做到此事情喔 (這就是 Go 語言跨平台的好處)。在命令列使用底下指令。

```bash
drone-gitlab-ci \
  --host https://gitlab.com/ \
  --token XXXXXXXX \
  --ref master \
  --id gitlab-ci-project-id
```

### 測試看看

這邊提供 [GitLab 專案][12]的資料給大家直接測試看看

```bash
drone-gitlab-ci \
  --host https://gitlab.com \
  --token 9184302d980918efad05bce8b97774 \
  --ref master \
  --id 3573921
```

上面指令沒意外的話，會看到底下結果:

```bash
2017/06/27 15:01:59 build id: 9360879
2017/06/27 15:01:59 build sha: 169e7c1d798c9593c06fbd9d474da9c07f699634
2017/06/27 15:01:59 build ref: master
2017/06/27 15:01:59 build status: pending
```

直接到 [pipeline 頁面][13]看結果

[<img src="https://i0.wp.com/c1.staticflickr.com/5/4215/34754106413_76245957df_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-06-27 at 3.02.05 PM" data-recalc-dims="1" />][14]

## 歡迎大家關注此專案 [drone-gitlab-ci][15]

接著來講 Jenkins 部分，其實原理都跟 Gitlab CI 是一樣的。

## 觸發 Jenkins

這邊其實跟 GitLab CI 設定相同，只是參數不一樣而已，首先必須要去哪裡找個人 API Token，請到 Jenkins 個人頁面找到 API Token。

[<img src="https://i1.wp.com/c1.staticflickr.com/5/4285/35395239122_946b2404e0_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-06-27 at 3.11.29 PM" data-recalc-dims="1" />][16]

### 使用 Drone 觸發

```yml
pipeline:
  jenkins:
    image: appleboy/drone-jenkins
    url: http://example.com
    user: appleboy
    token: xxxxxxxxxx
    job: drone-jenkins-plugin-job
```

其中 `url` 請改成公司內部的 Jenkins 伺服器網址，`job` 是 Jenkins 任務名稱，最後 `Token` 則是上面個人帳號所拿到的 Token。詳細設定可以參考 [README][17]，如果不是用 Drone 也沒關係，可以用 [Docker][4] 或透過 Go 語言可以包成各作業系統執行檔 (包含 Windows)

### 使用 Docker 觸發

請使用 [appleboy/drone-jenkins][18] 映像檔，檔案大小為 **2MB**

```bash
docker run --rm \
  -e JENKINS_BASE_URL=http://jenkins.example.com/
  -e JENKINS_USER=appleboy
  -e JENKINS_TOKEN=xxxxxxx
  -e JENKINS_JOB=drone-jenkins-plugin
  appleboy/drone-jenkins
```

### 使用 CLI 觸發

請先從 [Release 頁面][19]下載相關執行檔，重點是你也可以在 Windows 做到此事情喔 (這就是 Go 語言跨平台的好處)。在命令列使用底下指令。

```bash
drone-jenkins \
  --host http://jenkins.example.com/ \
  --user appleboy \
  --token XXXXXXXX \
  --job drone-jenkins-plugin
```

## 歡迎大家關注此專案 [drone-jenkins][20]

# 總結

寫這兩個 Plugin 的目的就是希望能有多點開發者從 Jenkins 或 GitLab CI 轉到 Drone，這是過渡時期，等熟悉了 Drone 的設定，你會發現 Drone 已經可以做到 Jenkins 或 GitLab CI 所有事情，甚至更強大。如果對 Drone 有興趣，可以來上七月底的『[用一天打造團隊自動化測試及部署][21]』

* * *

  * 時間: 2017/07/29 09:30 ~ 17:30
  * 地點: CLBC 大安館 (台北市大安區區復興南路一段283號4樓)
  * 價格: 3990 元

# [報名連結][21]

 [1]: https://www.flickr.com/photos/appleboy/34957940160/in/dateposted-public/ "drone-logo_512"
 [2]: https://github.com/drone/drone
 [3]: https://golang.org/
 [4]: http://docker.com/
 [5]: https://blog.wu-boy.com/2017/06/how-to-schedule-builds-in-drone/
 [6]: https://jenkins.io/
 [7]: https://about.gitlab.com/features/gitlab-ci-cd/
 [8]: https://docs.gitlab.com/ee/ci/triggers/
 [9]: https://github.com/appleboy/drone-gitlab-ci/blob/master/DOCS.md
 [10]: https://hub.docker.com/r/appleboy/drone-gitlab-ci/
 [11]: https://github.com/appleboy/drone-gitlab-ci/releases
 [12]: https://gitlab.com/appleboy/go-hello
 [13]: https://gitlab.com/appleboy/go-hello/pipelines
 [14]: https://www.flickr.com/photos/appleboy/34754106413/in/dateposted-public/ "Screen Shot 2017-06-27 at 3.02.05 PM"
 [15]: https://github.com/appleboy/drone-gitlab-ci
 [16]: https://www.flickr.com/photos/appleboy/35395239122/in/dateposted-public/ "Screen Shot 2017-06-27 at 3.11.29 PM"
 [17]: https://github.com/appleboy/drone-jenkins/blob/master/DOCS.md
 [18]: https://hub.docker.com/r/appleboy/drone-jenkins/
 [19]: https://github.com/appleboy/drone-jenkins/releases
 [20]: https://github.com/appleboy/drone-jenkins
 [21]: http://learning.ithome.com.tw/course/9cT5RF2vOMMrCfx