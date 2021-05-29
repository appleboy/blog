---
title: 用 GitHub Actions 上傳 Docker Image 到 AWS ECR
author: appleboy
type: post
date: 2020-04-06T05:39:21+00:00
url: /2020/04/upload-docker-image-to-aws-ecr-using-github-actions/
dsq_thread_id:
  - 7953457800
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - AWS
  - AWS ECR
  - Docker
  - ECR
  - GitHub Actions

---
![][1]

最近正打算使用 [GitHub Actions][2] 來串接 [AWS][3] 服務 ([ECR][4] + [ECS][5])，上網找了一堆 [ECR 套件][6]，發現就連 [AWS 官方][7]都只有實作 Login 進 ECR，後面編譯跟上傳動作就需要自己寫，可以看看底下是 AWS 官方套件的範例:

<!--more-->

```yml
    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build, tag, and push image to Amazon ECR
      env:
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        ECR_REPOSITORY: my-ecr-repo
        IMAGE_TAG: ${{ github.sha }}
      run: |
        docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
        docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

    - name: Logout of Amazon ECR
      if: always()
      run: docker logout ${{ steps.login-ecr.outputs.registry }}
```

覺得蠻神奇的是為什麼不把 Plugin 寫更完整些，讓使用者不用再執行 docker 指令，所以我直接把 [Drone 官方套件][8]直接改寫支援 GitHub Actions 服務，詳細的操作文件可以[參考這邊][9]

## 教學影片

{{< youtube DtxREakn1XI >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][10]
  * [一天學會 DevOps 自動化測試及部署][11]
  * [DOCKER 容器開發部署實戰][12] (課程剛啟動，限時特價 $900 TWD)

如果需要搭配購買請直接透過 [FB 聯絡我][13]，直接匯款（價格再減 **100**）

## 使用方式

本篇會使用兩種 CI/CD 工具，分別是 [Drone][14] 及 [GitHub Actions][2]，詳細檔案內容可以[參考這邊][15]。底下是使用 Drone CI/CD:

```yaml
- name: publish
  pull: always
  image: plugins/ecr
  settings:
    access_key:
      from_secret: aws_access_key_id
    secret_key:
      from_secret: aws_secret_access_key
    repo: api-sample
    region: ap-northeast-1
    registry:
      from_secret: registry
    auto_tag: true
    daemon_off: false
    dockerfile: Dockerfile
  when:
    event:
      exclude:
      - pull_request
```

底下是使用 GitHub Actions

```yaml
build:
  name: upload image
  runs-on: ubuntu-latest
  steps:
  - uses: actions/checkout@master
  - name: upload image to ECR
    uses: appleboy/docker-ecr-action@v0.0.2
    with:
      access_key: ${{ secrets.aws_access_key_id }}
      secret_key: ${{ secrets.aws_secret_access_key }}
      registry: ${{ secrets.registry }}
      cache_from: ${{ secrets.cache }}
      repo: api-sample
      region: ap-northeast-1
```

兩種使用方式都是一樣的，會用 Drone CI/CD，那使用 GitHub Actions 也不會有問題，另外還支援了 `cache_from`，省下了一點部署的時間，時間取決於跑的專案 Image 大小了。

 [1]: https://lh3.googleusercontent.com/t5MID_dNklCmkU2VFrKkhHV89tta8i-9GMebbSyfd_uvvdyQlo6Q4JbhRkA0jCO84vcSLW8zbn4Nqvzm1PYmAgrBQ4e2J1aZiUOZ7p_NGNinNF7Svsld_JRBv5rwCouNEJ_oBxk-Vqs=w1920-h1080
 [2]: https://github.com/features/actions
 [3]: https://aws.amazon.com
 [4]: https://aws.amazon.com/tw/ecr/
 [5]: https://aws.amazon.com/tw/ecs/
 [6]: https://github.com/marketplace?type=actions&query=ECR
 [7]: https://github.com/aws-actions/amazon-ecr-login
 [8]: http://plugins.drone.io/drone-plugins/drone-ecr/
 [9]: https://github.com/appleboy/docker-ecr-action
 [10]: https://www.udemy.com/course/golang-fight/?couponCode=202004
 [11]: https://www.udemy.com/course/devops-oneday/?couponCode=202004
 [12]: https://www.udemy.com/course/docker-practice/?couponCode=202004
 [13]: http://facebook.com/appleboy46
 [14]: https://drone.io
 [15]: https://github.com/go-training/golang-in-ecr-ecs
