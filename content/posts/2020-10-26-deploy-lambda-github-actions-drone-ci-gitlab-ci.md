---
title: 用 GitHub Actions, Drone CI 或 GitLab CI 部署 AWS Lambda
author: appleboy
type: post
date: 2020-10-26T03:39:02+00:00
url: /2020/10/deploy-lambda-github-actions-drone-ci-gitlab-ci/
dsq_thread_id:
  - 8252872350
categories:
  - DevOps
  - Drone CI
tags:
  - AWS Lambda
  - drone ci
  - GitHub Actions
  - GitLab CI

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1956/43711539730_7bd9f610c3_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-10-24 at 9.37.49 AM" data-recalc-dims="1" />][1]

最近剛好把 [drone-lambda][2] 新增了一些新的功能，也就是可以透過 CI/CD 的方式來更新 [AWS Lambda][3] 基本設定，像是 Memory Size, Handler, Timeout, Runtime 或 Role 等 ...，趁這機會寫篇教學紀錄如何透過 [GitHub Actions][4], [Drone CI][5] 或 [GitLab CI][6] 部署 AWS Lambda。這三套部署方式都是透過 [drone-lambda][2] 包好的 Image 來進行。底下的程式碼都可以在[這邊找到][7]。

<!--more-->

## 線上教學

{{< youtube ePshDE_qHzc >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][8]
  * [一天學會 DevOps 自動化測試及部署][9]
  * [DOCKER 容器開發部署實戰][10]

如果需要搭配購買請直接透過 [FB 聯絡我][11]，直接匯款（價格再減 **100**）

## GitHub Actions

此篇直接用 [Go 語言][12]的範例來進行線上部署，GitHub Actions 直接使用 [lambda-action][13]。

```yaml
name: deploy to lambda
on: [push]
jobs:

  deploy_zip:
    name: deploy lambda function from zip
    runs-on: ubuntu-latest
    strategy:
      matrix:
        go-version: [1.15.x]
    steps:
      - name: checkout source code
        uses: actions/checkout@v1
      - name: Install Go
        uses: actions/setup-go@v1
        with:
          go-version: ${{ matrix.go-version }}
      - name: Build binary
        run: |
          cd example && GOOS=linux go build -v -a -o main main.go && zip deployment.zip main
      - name: deploy zip
        uses: appleboy/lambda-action@v0.0.8
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: ${{ secrets.AWS_REGION }}
          function_name: gorush
          zip_file: example/deployment.zip
          debug: true
```

首先第一個步驟就是編譯 Binary 接著打包成 zip 檔案後，才可以進行部署，接著在 Plugin 寫上 function name 跟 zip 檔案路徑就可以直接更新到 AWS Lambda 了。

## Drone CI

```yaml
---
kind: pipeline
name: testing

platform:
  os: linux
  arch: amd64

steps:
- name: build
  image: golang:1.15
  commands:
  - apt-get update && apt-get -y install zip
  - cd example && GOOS=linux go build -v -a -o main main.go && zip deployment.zip main

- name: deploy-lambda
  image: appleboy/drone-lambda
  settings:
    pull: true
    aws_access_key_id:
      from_secret: AWS_ACCESS_KEY_ID
    aws_secret_access_key:
      from_secret: AWS_SECRET_ACCESS_KEY
    aws_region:
      from_secret: AWS_REGION
    function_name: gorush
    zip_file: example/deployment.zip
    debug: true
```

寫法跟 GitHub Actions 非常類似，因為在同一個 Piepline，所以可以在第一個步驟產生出來的 zip 檔案，也可以在第二個步驟部署。

## GitLab CI

其實 GitLab CI 已經有寫一篇[完整的教學][14]，裡面用的是 [Server less 框架][15]來部署程式碼，所以開發者還需要看一下怎麼使用此框架，相對來說比較難上手，那底下來介紹用 drone-lambda 方式來進行部署。

```yaml
variables:
  ARTIFACTS_DIR: artifacts
  GIT_DEPTH: 1

before_script:
  - mkdir -p ${CI_PROJECT_DIR}/${ARTIFACTS_DIR}

stages:
  - build
  - deploy

build:
  image: golang:1.15
  stage: build
  script:
    - apt-get update && apt-get -y install zip
    - cd example && GOOS=linux go build -v -a -o main main.go && zip deployment.zip main
    - mv deployment.zip ${CI_PROJECT_DIR}/${ARTIFACTS_DIR}/
  artifacts:
    paths:
      - ${ARTIFACTS_DIR}

deploy:
  image: appleboy/drone-lambda
  variables:
    FUNCTION_NAME: 'gorush'
    DEBUG: 'true'
    ZIP_FILE: '${CI_PROJECT_DIR}/${ARTIFACTS_DIR}/deployment.zip'
    GIT_STRATEGY: none
  stage: deploy
  artifacts:
    paths:
      - ${ARTIFACTS_DIR}
  script:
    - /bin/drone-lambda
```

在 GitLab CI 比較不同的是，每個步驟都是需要重新 git clone 整個專案，步驟結束，就會把整個容器砍掉，包含整個 Project Data，這邊就需要透過 artifacts 來共享資料。詳細資料可以參考艦長寫的這篇『[CI/CD Pipeline 之 stage: build][16]』

## 心得

目前使用起來 GitHub Action 跟 Drone CI 行為是一致的，反倒是使用 GitLab CI 之後，需要多了解 artifacts 這塊，才可以完成整個串接。

 [1]: https://www.flickr.com/photos/appleboy/43711539730/in/dateposted-public/ "Screen Shot 2018-10-24 at 9.37.49 AM"
 [2]: https://github.com/appleboy/drone-lambda
 [3]: https://aws.amazon.com/tw/lambda/
 [4]: https://github.com/features/actions
 [5]: https://cloud.drone.io
 [6]: https://docs.gitlab.com/ee/ci/
 [7]: https://github.com/go-training/drone-lambda-demo
 [8]: https://www.udemy.com/course/golang-fight/?couponCode=202011
 [9]: https://www.udemy.com/course/devops-oneday/?couponCode=202011
 [10]: https://www.udemy.com/course/docker-practice/?couponCode=202011
 [11]: http://facebook.com/appleboy46
 [12]: https://golang.org
 [13]: https://github.com/appleboy/lambda-action
 [14]: https://docs.gitlab.com/ee/user/project/clusters/serverless/aws.html
 [15]: https://www.serverless.com/framework/docs/providers/aws/
 [16]: https://ithelp.ithome.com.tw/articles/10219944
