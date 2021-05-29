---
title: 用 Docker 整合測試 Flutter 框架
author: appleboy
type: post
date: 2018-12-26T03:56:47+00:00
url: /2018/12/docker-testing-with-flutter-sdk/
dsq_thread_id:
  - 7129137149
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - Docker
  - flutter

---
[![][1]][2] [Flutter][3] 是一套以 [Dart][4] 語言為主體的手機 App 開發框架，讓開發者可以寫一種語言產生 iOS 及 Android，只要裝好 Flutter 框架，就可以在個人電腦上面同時測試 iOS 及 Android 流程，如果您需要 Docker 環境，可以直接參考[此開源專案][5]，裡面已經將 Flutter 1.0 SDK 包在容器，只要將專案目錄掛載到 Docker 內，就可以透過 `flutter test` 指令來完成測試，對於 CI/CD 流程使用 Docker 技術非常方便。 

<!--more-->

## 線上影片教學

{{< youtube niYHNT73wk0 >}}

## Docker 使用方式 

下載 Docker Image，檔案有點大，先下載好比較方便 

```bash
$ docker pull appleboy/flutter-docker:1.0.0
```

下載[測試範例][6]，並執行測試

```bash
$ git clone https://github.com/appleboy/flutter-demo.git
$ docker run -ti -v ${PWD}/flutter-demo:/flutter-demo -w /flutter-demo \
  appleboy/flutter-docker:1.0.0 \
  /bin/sh -c "flutter test"
```

## 使用 Drone 自動化測試

搭配 [Drone Cloud][7] 服務，在專案底下新增 [.drone.yml][8]，內容如下: 

```bash
kind: pipeline
name: testing

steps:
  - name: flutter
    image: appleboy/flutter-docker:1.0.0
    commands:
      - flutter test
```

 [1]: https://lh3.googleusercontent.com/REguGdEy6qgmZyU7hNscYxXV1lGzSTioUb_cBe4uVLdBNUxL2Y9oNwx2J8w6VU8BMcZhBOJoAI091l9lCJuueumNEef7ub75Dvrbl2ZC1Ri9QholsnccGd6txg9rbXP5oZoNIQVl_Fk=w700
 [2]: https://photos.google.com/share/AF1QipPVsiQNMhQf-l7rJBe-Ki9RMxMVz0x-xSDpayq967sskqwi2bzqgHBQyc9xaby8eA?key=b0xKVW5oSlEwZEl2b0FESUNDVFRGV2dYbkVPRVVB&source=ctrlq.org
 [3]: https://flutter.io
 [4]: https://www.dartlang.org/
 [5]: https://github.com/appleboy/flutter-docker
 [6]: https://github.com/appleboy/flutter-demo
 [7]: https://cloud.drone.io/
 [8]: https://github.com/appleboy/flutter-demo/blob/4b68b964c5eebde8daf393495e3cc705777aeca3/.drone.yml#L1
