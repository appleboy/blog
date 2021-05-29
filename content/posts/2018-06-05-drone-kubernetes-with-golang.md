---
title: Drone 搭配 Kubernetes 部署 Go 語言項目
author: appleboy
type: post
date: 2018-06-05T02:36:11+00:00
url: /2018/06/drone-kubernetes-with-golang/
dsq_thread_id:
  - 6712239545
categories:
  - DevOps
  - Docker
  - Drone CI
  - Golang
  - Kubernetes
tags:
  - drone
  - golang
  - kubernetes

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1738/27678088297_1c6fe64e86_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-06-04 at 9.19.46 AM" data-recalc-dims="1" />][1]

在之前寫過一篇『[Drone 搭配 Kubernetes 升級應用程式版本][2]』，裡面內容最主要介紹 [honestbee][3] 撰寫的 [drone][4] 外掛: [drone-kubernetes][5]，但是此外掛並非用 [Go 語言][6]所撰寫，而是用 Shell Script 透過 `kubectl set image` 方式來更新專案項目，但是這邊會有幾個缺點，第一點就是假設在 Develop 環境永遠都是吃 master 分支，也就是讀取 Image 的 `latest` 標籤，這時候此外掛就無法作用，第二點此外掛無法讀取 kubernetes YAML 檔案，假設專案要修正一個 ENV 值，此外掛也無法及時更新。綜合這兩點因素，只好捨棄此外掛，而本篇會帶給大家另一個用 Go 語言所撰寫的外掛，是由 [@Sh4d1][7] 所開發的[項目][8]，用法相當容易，底下會一步一步教大家如何部署 Go 語言項目。

<!--more-->

## GitHub 工作流程及部署

[<img src="https://i0.wp.com/farm2.staticflickr.com/1737/42549008141_e035c63057_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-06-04 at 9.44.15 AM" data-recalc-dims="1" />][9]

團隊只會有兩種環境，一種是 Staging 另一種則是 Production，而前者是根據只要 master 分支有變動，則會更新 Staging，而後者則需要下 Tag 才會正式部署到 Production，在 Drone 預設值內，是不開啟 Tag 事件，所以需自行到後台打開 (如下圖)，未來可以透過 drone-cli 用 command 方式打開，目前[此功能][10]正在 Review 中。

[<img src="https://i0.wp.com/farm2.staticflickr.com/1730/41647040945_0b938ab53a_z.jpg?w=840&#038;ssl=1" alt="Snip20180604_6" data-recalc-dims="1" />][11]

底下會來一步一步教大家如何設定 Drone。

## 準備 Go 項目

本篇會用 Go 語言寫個小型 Http 服務，來證明使用 tag 事件及 master 分支都可以正確部署，底下先看看 Go 的程式碼:

```go
package main

import (
    "log"
    "net/http"
    "os"
    "strings"
)

var version = "master"

func showVersion(w http.ResponseWriter, r *http.Request) {
    log.Println(version)
    w.Write([]byte(version))
}

func sayHello(w http.ResponseWriter, r *http.Request) {
    message := r.URL.Path
    message = strings.TrimPrefix(message, "/")
    message = "Hello, drone got the message: " + message
    log.Println(message)
    w.Write([]byte(message))
}

func main() {
    // use PORT environment variable, or default to 8080
    port := "8080"
    if fromEnv := os.Getenv("PORT"); fromEnv != "" {
        port = fromEnv
    }
    http.HandleFunc("/version", showVersion)
    http.HandleFunc("/", sayHello)
    log.Println("Listen server on " + port + " port")
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatal(err)
    }
}
```

從上面程式可以看到，在編譯 Go 語言專案時，可以從外部帶入 version 變數，證明目前的 App 版本。請參考 Makefile 內的

```makefile
build:
ifneq ($(DRONE_TAG),)
    go build -v -ldflags "-X main.version=$(DRONE_TAG)" -a -o release/linux/amd64/hello
else
    go build -v -ldflags "-X main.version=$(DRONE_COMMIT)" -a -o release/linux/amd64/hello
endif
```

只要是 master 分支的 commit，就會執行 `-X main.version=$(DRONE_COMMIT)`，如果是 push tag 到伺服器，則會執行 `-X main.version=$(DRONE_TAG)`。最後看看 Drone 如何編譯

```yaml
pipeline:
  build_linux_amd64:
    image: golang:1.10
    group: build
    environment:
      - GOOS=linux
      - GOARCH=amd64
      - CGO_ENABLED=0
    commands:
      - cd example19-deploy-with-kubernetes && make build
```

記得將 `GOOS`, `GOARCH` 和 `CGO_ENABLED` 設定好。

## 上傳容器到 DockerHub

上一個步驟可以編譯出 linux 的二進制檔案，這時候就可以直接放到容器內直接執行:

```dockerfile
FROM plugins/base:multiarch

ADD example19-deploy-with-kubernetes/release/linux/amd64/hello /bin/

ENTRYPOINT ["/bin/hello"]
```

其中 `plugins/base:multiarch` 用的是 docker scratch 最小 image 搭配 SSL 憑證檔案，接著把 go 編譯出來的二進制檔案放入，所以整體容器大小已經是最小的了。看看 drone 怎麼上傳到 [DockerHub][12]。

```yaml
docker_golang:
  image: plugins/docker:17.12
  secrets: [ docker_username, docker_password ]
  repo: appleboy/golang-http
  dockerfile: example19-deploy-with-kubernetes/Dockerfile
  default_tags: true
  when:
    event: [ push, tag ]
```

其中 `default_tags` 會自動將 `master` 分支上傳到 `latest` 標籤，而假設上傳 `1.1.1` 版本時，drone 則會幫忙編譯出三個不同的 tag 標籤，分別是 `1`, `1.1`, `1.1.1` 這是完全符合 [Semantic Versioning][13]，如果有在開源專案打滾的朋友們，一定知道版本的重要性。而 Drone 在這地方提供了很簡單的設定讓開發者可以上傳一次 tag 做到三種不同的 image 標籤。

## 部署更新 Kubernetes

這邊推薦大家使用 [Sh4d1/drone-kubernetes][14] 外掛，使用之前請先設定好三個參數:

  1. KUBERNETES_SERVER
  2. KUBERNETES_CERT
  3. KUBERNETES_TOKEN

`KUBERNETES_SERVER` 可以打開家目錄底下的 `~/.kube/config` 檔案直接找到，cert 及 token 請先透過 pod 找到 secret token name:

```shell
$ kubectl describe po/frontend-9f5ccc8d4-8n9xq | grep SecretName | grep token
    SecretName:  default-token-r5xdx
```

拿到 secret name 之後，再透過底下指令找到 `ca.crt` 及 `token`

```shell
$ kubectl get secret default-token-r5xdx -o yaml | egrep 'ca.crt:|token:'
```

其中 token 還需要透過 base64 decode 過，才可以設定到 drone secret。完成上述步驟後，可以來設定 drone 部署:

```yaml
deploy:
  image: sh4d1/drone-kubernetes
  kubernetes_template: example19-deploy-with-kubernetes/deployment.yml
  kubernetes_namespace: default
  secrets: [ kubernetes_server, kubernetes_cert, kubernetes_token ]
```

其中 `deployment.yml` 就是該服務的 deploy 檔案:

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: frontend
  # these labels can be applied automatically
  # from the labels in the pod template if not set
  labels:
    app: gotraining
    tier: frontend
spec:
  # this replicas value is default
  # modify it according to your case
  replicas: 3
  # selector can be applied automatically
  # from the labels in the pod template if not set
  # selector:
  #   app: guestbook
  #   tier: frontend
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: gotraining
        tier: frontend
    spec:
      containers:
      - name: go-hello
        image: appleboy/golang-http:VERSION
        imagePullPolicy: Always
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 8080
        env:
        - name: FOR_GODS_SAKE_PLEASE_REDEPLOY
          value: 'THIS_STRING_IS_REPLACED_DURING_BUILD'
```

大家可以找到 `image: appleboy/golang-http:VERSION`，這邊需要寫個 sed 指令來取代 `VERSION`，部署到 staging 則是 `latest`，如果是 tag 則取代為 `DRONE_TAG`

```makefile
ifneq ($(DRONE_TAG),)
    VERSION ?= $(DRONE_TAG)
else
    VERSION ?= latest
endif

prepare:
    sed -ie "s/VERSION/$(VERSION)/g" deployment.yml
```

這邊有個問題就是，我們怎麼讓在同一個 image:latest 下，也可以保持更新 App 呢，首先必須設定 `imagePullPolicy` 為 `Always`，以及設定一個 env 讓 drone 可以動態修改 template 檔案

```yaml
env:
- name: FOR_GODS_SAKE_PLEASE_REDEPLOY
  value: 'THIS_STRING_IS_REPLACED_DURING_BUILD'
```

目的是讓每次 kubernetes 都可以讀取不一樣的 template 確保 image 都可以即時更新，假設少了上述步驟，是無法讓 staging 保持更新狀態。畢竟使用 kubectl apply 時，如果 yaml 檔案是沒有更動過的，就不會更新。

```makefile
prepare:
    sed -ie "s/VERSION/$(VERSION)/g" deployment.yml
    sed -ie "s/THIS_STRING_IS_REPLACED_DURING_BUILD/$(shell date)/g" deployment.yml
    cat deployment.yml
```

而 Tag 就不用擔心，原因就是 `VERSION` 就會改變不一樣的值，所以肯定會即時更新，那假設團隊想要上傳相同 tag (這是不好的做法，請盡量不要使用)，這時候動態修改 env 的作法就發揮功效了。從上面的教學，現在我們看安新的透過 GitHub Flow 來完成部署 Staging 及 Production 了。

## 影片簡介

下面影片並無包含實作部分，會介紹我在團隊怎麼使用 [GitHub Flow][15] 部署，更多實作詳細細節，可以參考 Udemy 上面影片

{{< youtube qLla47eJUQc >}}

## 心得

作者我尚未深入玩過 [GitLab CI][16] 或者是 [Jenkins][17] 搭配 Kubernetes 來部署專案，但是我相信以複雜及學習難度來說，用 Drone CI 是比較簡單的，這部分就不多說了，大家實際操作比較過才知道。希望能帶給有在玩 Drone 的開發者有些幫助。另外我在 Udemy 上面開了兩門課程，一門 drone 另一門 golang 教學，如果對這兩門課有興趣的話，都可以購買，目前都是特價 $1800

  * [Go 語言實戰][18] $1800
  * [一天學會 DEVOPS 自動化流程][19] $1800

如果兩們都有興趣想一起合買，請直接匯款到下面帳戶，特價 **$3000**

  * 富邦銀行: 012
  * 富邦帳號: 746168268370
  * 匯款金額: 台幣 $3000 元

匯款後請直接到 [FB 找我][20]，或者直接寫信給我也可以 **appleboy.tw AT gmail.com**。有任何問題都可以直接加我 FB，都是公開資訊。上面程式碼範例請參考[此連結]][21]

 [1]: https://www.flickr.com/photos/appleboy/27678088297/in/dateposted-public/ "Screen Shot 2018-06-04 at 9.19.46 AM"
 [2]: https://blog.wu-boy.com/2017/10/upgrade-kubernetes-container-using-drone/
 [3]: https://github.com/honestbee
 [4]: https://drone.io
 [5]: https://github.com/honestbee/drone-kubernetes
 [6]: https://golang.org
 [7]: https://github.com/Sh4d1
 [8]: https://github.com/Sh4d1/drone-kubernetes/
 [9]: https://www.flickr.com/photos/appleboy/42549008141/in/dateposted-public/ "Screen Shot 2018-06-04 at 9.44.15 AM"
 [10]: https://github.com/drone/drone-cli/pull/90
 [11]: https://www.flickr.com/photos/appleboy/41647040945/in/dateposted-public/ "Snip20180604_6"
 [12]: https://hub.docker.com/
 [13]: https://semver.org/
 [14]: https://github.com/Sh4d1/drone-kubernetes
 [15]: https://guides.github.com/introduction/flow/
 [16]: https://about.gitlab.com/features/gitlab-ci-cd/
 [17]: https://jenkins.io/
 [18]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-TOP
 [19]: https://www.udemy.com/devops-oneday/?couponCode=DRONE-DEVOPS
 [20]: http://facebook.com/appleboy46
 [21]: https://github.com/go-training/training/tree/master/example19-deploy-with-kubernetes
