---
title: '有效率的用 jsonnet 撰寫  Drone CI/CD 設定檔'
author: appleboy
type: post
date: 2019-01-25T07:40:34+00:00
url: /2019/01/converts-a-jsonnet-configuration-file-to-a-yaml-in-drone/
dsq_thread_id:
  - 7187689661
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - golang
  - jsonnet

---
[![Jsonnet + Drone][1]][1]

[Drone][2] 在 1.0 版本推出了用 [jsonnet][3] 來撰寫 [YAML][4] 設定檔，方便開發者可以維護多個專案設定。不知道大家有無遇過在啟動新的專案後，需要從舊的專案複製設定到新專案，或者是在 `.drone.yml` 內有非常多重複性的設定，假設 [Go 語言][5]的開源專案需要將執行檔包成 ARM64 及 AMD64 的映像檔，並且上傳到 [Docker Hub][6]，底下是 AMD64 的設定檔範例。剛好在 [Udemy 課程][7]內有學員詢問到[相關問題][8]。

```yaml
---
kind: pipeline
name: linux-arm64

platform:
  os: linux
  arch: arm64

steps:
- name: build-push
  pull: always
  image: golang:1.11
  commands:
  - "go build -v -ldflags \"-X main.build=${DRONE_BUILD_NUMBER}\" -a -o release/linux/arm64/drone-discord"
  environment:
    CGO_ENABLED: 0
    GO111MODULE: on
  when:
    event:
    - push
    - pull_request

- name: build-tag
  pull: always
  image: golang:1.11
  commands:
  - "go build -v -ldflags \"-X main.version=${DRONE_TAG##v} -X main.build=${DRONE_BUILD_NUMBER}\" -a -o release/linux/arm64/drone-discord"
  environment:
    CGO_ENABLED: 0
    GO111MODULE: on
  when:
    event:
    - tag

- name: executable
  pull: always
  image: golang:1.11
  commands:
  - ./release/linux/arm64/drone-discord --help

- name: dryrun
  pull: always
  image: plugins/docker:linux-arm64
  settings:
    dockerfile: docker/Dockerfile.linux.arm64
    dry_run: true
    password:
      from_secret: docker_password
    repo: appleboy/drone-discord
    tags: linux-arm64
    username:
      from_secret: docker_username
  when:
    event:
    - pull_request

- name: publish
  pull: always
  image: plugins/docker:linux-arm64
  settings:
    auto_tag: true
    auto_tag_suffix: linux-arm64
    dockerfile: docker/Dockerfile.linux.arm64
    password:
      from_secret: docker_password
    repo: appleboy/drone-discord
    username:
      from_secret: docker_username
  when:
    event:
    - push
    - tag

trigger:
  branch:
  - master
```

<!--more-->

大家可以看到上面總共快 80 行，如果要再支援 ARM 64，這時候就需要重新複製再貼上，並且把相關設定改掉，有沒有覺得這樣非常難維護 `.drone.yml`。Drone 的作者聽到大家的聲音了，在 1.0 版本整合了 [jsonnet][9] 這套 Data Templating Language，讓您可以寫一次代碼並產生出好幾種環境。底下簡單看一個例子:

```json
// A function that returns an object.
local Person(name='Alice') = {
  name: name,
  welcome: 'Hello ' + name + '!',
};
{
  person1: Person(),
  person2: Person('Bob'),
}
```

透過 jsonnet 指令可以轉換如下:

```json
{
  "person1": {
    "name": "Alice",
    "welcome": "Hello Alice!"
  },
  "person2": {
    "name": "Bob",
    "welcome": "Hello Bob!"
  }
}
```

那該如何改 drone 設定檔方便未來多個專案一起維護呢？

## 影片教學

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone 自動化課程: <http://bit.ly/drone-2019>

## 安裝 drone CLI 執行檔

請直接參考[官方文件][10]就可以了，這邊不再詳細介紹，底下是 Mac 範例 (安裝的是 [Drone v1.0.5][11]):

```sh
$ curl -L https://github.com/drone/drone-cli/releases/download/v1.0.5/drone_darwin_amd64.tar.gz | tar zx
$ sudo cp drone /usr/local/bin
```

安裝完成後，還需要設定[環境變數][12]，才可以跟您的 Drone 伺服器溝通。

```sh
$ drone
NAME:
   drone - command line utility

USAGE:
   drone [global options] command [command options] [arguments...]

VERSION:
   1.0.5

COMMANDS:
     build      manage builds
     cron       manage cron jobs
     log        manage logs
     encrypt    encrypt a secret
     exec       execute a local build
     info       show information about the current user
     repo       manage repositories
     user       manage users
     secret     manage secrets
     server     manage servers
     queue      queue operations
     autoscale  manage autoscaling
     fmt        format the yaml file
     convert    convert legacy format
     lint       lint the yaml file
     sign       sign the yaml file
     jsonnet    generate .drone.yml from jsonnet
     plugins    plugin helper functions
```

## 撰寫 .drone.jsonnet 檔案

在專案目錄內放置 `.drone.jsonnet` 檔案，拿 Go 專案當範例：

  1. 驗證程式碼品質
  2. 編譯執行檔 
  3. 包成 Docker 容器 
  4. 上傳到 Docker Hub 
  5. 消息通知

```json
local PipelineTesting = {
  kind: "pipeline",
  name: "testing",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      name: "vet",
      image: "golang:1.11",
      pull: "always",
      environment: {
        GO111MODULE: "on",
      },
      commands: [
        "make vet",
      ],
    },
    {
      name: "lint",
      image: "golang:1.11",
      pull: "always",
      environment: {
        GO111MODULE: "on",
      },
      commands: [
        "make lint",
      ],
    },
    {
      name: "misspell",
      image: "golang:1.11",
      pull: "always",
      environment: {
        GO111MODULE: "on",
      },
      commands: [
        "make misspell-check",
      ],
    },
    {
      name: "test",
      image: "golang:1.11",
      pull: "always",
      environment: {
        GO111MODULE: "on",
        WEBHOOK_ID: { "from_secret": "webhook_id" },
        WEBHOOK_TOKEN: { "from_secret": "webhook_token" },
      },
      commands: [
        "make test",
        "make coverage",
      ],
    },
    {
      name: "codecov",
      image: "robertstettner/drone-codecov",
      pull: "always",
      settings: {
        token: { "from_secret": "codecov_token" },
      },
    },
  ],
  trigger: {
    branch: [ "master" ],
  },
};

local PipelineBuild(os="linux", arch="amd64") = {
  kind: "pipeline",
  name: os + "-" + arch,
  platform: {
    os: os,
    arch: arch,
  },
  steps: [
    {
      name: "build-push",
      image: "golang:1.11",
      pull: "always",
      environment: {
        CGO_ENABLED: "0",
        GO111MODULE: "on",
      },
      commands: [
        "go build -v -ldflags \"-X main.build=${DRONE_BUILD_NUMBER}\" -a -o release/" + os + "/" + arch + "/drone-discord",
      ],
      when: {
        event: [ "push", "pull_request" ],
      },
    },
    {
      name: "build-tag",
      image: "golang:1.11",
      pull: "always",
      environment: {
        CGO_ENABLED: "0",
        GO111MODULE: "on",
      },
      commands: [
        "go build -v -ldflags \"-X main.version=${DRONE_TAG##v} -X main.build=${DRONE_BUILD_NUMBER}\" -a -o release/" + os + "/" + arch + "/drone-discord",
      ],
      when: {
        event: [ "tag" ],
      },
    },
    {
      name: "executable",
      image: "golang:1.11",
      pull: "always",
      commands: [
        "./release/" + os + "/" + arch + "/drone-discord --help",
      ],
    },
    {
      name: "dryrun",
      image: "plugins/docker:" + os + "-" + arch,
      pull: "always",
      settings: {
        dry_run: true,
        tags: os + "-" + arch,
        dockerfile: "docker/Dockerfile." + os + "." + arch,
        repo: "appleboy/drone-discord",
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
      },
      when: {
        event: [ "pull_request" ],
      },
    },
    {
      name: "publish",
      image: "plugins/docker:" + os + "-" + arch,
      pull: "always",
      settings: {
        auto_tag: true,
        auto_tag_suffix: os + "-" + arch,
        dockerfile: "docker/Dockerfile." + os + "." + arch,
        repo: "appleboy/drone-discord",
        username: { "from_secret": "docker_username" },
        password: { "from_secret": "docker_password" },
      },
      when: {
        event: [ "push", "tag" ],
      },
    },
  ],
  depends_on: [
    "testing",
  ],
  trigger: {
    branch: [ "master" ],
  },
};

local PipelineNotifications = {
  kind: "pipeline",
  name: "notifications",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  clone: {
    disable: true,
  },
  steps: [
    {
      name: "microbadger",
      image: "plugins/webhook:1",
      pull: "always",
      settings: {
        url: { "from_secret": "microbadger_url" },
      },
    },
  ],
  depends_on: [
    "linux-amd64",
    "linux-arm64",
    "linux-arm",
  ],
  trigger: {
    branch: [ "master" ],
    event: [ "push", "tag" ],
  },
};

[
  PipelineTesting,
  PipelineBuild("linux", "amd64"),
  PipelineBuild("linux", "arm64"),
  PipelineBuild("linux", "arm"),
  PipelineNotifications,
]
```

大家可以看到 `local PipelineBuild` 就是一個 func 函數，可以用來產生不同的環境代碼

```sh
  PipelineBuild("linux", "amd64"),
  PipelineBuild("linux", "arm64"),
  PipelineBuild("linux", "arm"),
```

完成後，直接在專案目錄下執行

```sh
$ drone jsonnet --stream
```

您會發現專案下的 `.drone.yml` 已經成功修正，未來只要將變動部分抽成變數，就可以產生不同專案的環境，開發者就不需要每次手動修改很多變動的地方。至於要不要把 `.drone.jsonnet` 放入專案內進行版本控制就看情境了。其實可以另外開一個新的 Repo 放置 `.drone.jsonnet`，未來新專案開案，就可以快速 clone 下來，並且產生新專案的 `.drone.yml` 設定檔。底下是 Drone 執行結果:

[![Drone Output][13]][13]

 [1]: https://lh3.googleusercontent.com/z8q-kl8yaWy9LtUDNEluPfDiHouz0Q7GnQZDStid8j4CmOwgP9uZJsTOCXjmSzTTApmL6fukANr6UbEGAaebb5_iJ1j5LoXPFKtrrf_FdLOGFpt9zyYvdPo8OdpzrZ3qJDDx9CkanNM=w1920-h1080 "Jsonnet + Drone"
 [2]: https://github.com/drone/drone
 [3]: https://jsonnet.org
 [4]: https://en.wikipedia.org/wiki/YAML
 [5]: https://golang.org "Go 語言"
 [6]: https://hub.docker.com/ "Docker Hub"
 [7]: https://www.udemy.com/devops-oneday "Udemy 課程"
 [8]: https://www.udemy.com/devops-oneday/learn/v4/questions/6162884
 [9]: https://jsonnet.org/
 [10]: https://docs.drone.io/cli/install/
 [11]: https://github.com/drone/drone-cli/releases/tag/v1.0.5 "Drone v1.0.5"
 [12]: https://docs.drone.io/cli/setup/
 [13]: https://lh3.googleusercontent.com/n--AFC5iMIrQGufEyoiM2dag3ibgEyQACRzx4ZapvNDsJz-WjY1qRzei4a6Ov0URrjsVGX6S9eEa4p9cw3so08AtPpRM1iANCGxtRhh109cnV21ZXC-Bg1a6GzltV0G8QxCfqpMiIsc=w1920-h1080 "Drone Output"