---
title: "使用 Colima 快速打造 Kubernetes 開發環境"
date: 2023-06-10T10:13:50+08:00
author: appleboy
type: post
slug: how-to-create-kubernetes-cluster-in-local
share_img: https://lh3.googleusercontent.com/pw/AJFCJaXtuCuA5R-Xw8ea3rKHuIHwWY5JinU7EXhBsvq6HS1J0vva-4TYFsJY9fT7_gW69Dvf_khWJ1npoFO_yhxnY51WbWIW-OTQQfgxjLHxeEcQuO5JwT8l3Anp9Hku-ij7VU-bgUtygX-l-AwLgvPBZvYljQ=w860-h821-s-no?authuser=0
categories:
  - kubernetes
---

![logo](https://lh3.googleusercontent.com/pw/AJFCJaXtuCuA5R-Xw8ea3rKHuIHwWY5JinU7EXhBsvq6HS1J0vva-4TYFsJY9fT7_gW69Dvf_khWJ1npoFO_yhxnY51WbWIW-OTQQfgxjLHxeEcQuO5JwT8l3Anp9Hku-ij7VU-bgUtygX-l-AwLgvPBZvYljQ=w860-h821-s-no?authuser=0)

在學習新的技術項目，最麻煩的就是如何快速安裝相關環境，讓團隊同仁可以快速上手的最關鍵的原因之一。而學習 Kubernetes 也不例外，如果要在本地環境中搭建 Kubernetes 開發環境，需要安裝 [Docker][12]、[Kubernetes][1]、[Minikube][2]、[Kubectl][3] 等相關工具，這些工具的安裝和配置過程都比較繁瑣，而且容易出錯。能不能有快速地繞過這些方式，快速在自己的電腦打造 Kubernetes 開發環境呢？除了 Minikube，你可能也聽過 [k3s][4]、[kind][5] 等工具，不過這些工具對於新人來說，還是相當困難。今天要介紹的是一個新的工具 [Colima][11]，它可以讓您在本地環境中運行輕量級的虛擬機器，並在虛擬機器中運行 Kubernetes 叢集。

[1]:https://kubernetes.io/
[2]:https://minikube.sigs.k8s.io/docs/
[3]:https://kubernetes.io/docs/reference/kubectl/
[4]:https://k3s.io/
[5]:https://kind.sigs.k8s.io/

<!--more-->

## 什麼是 Colima

[Colima][11] 是一個基於 [Docker][12] 的輕量級虛擬化工具，它可以讓您在本地環境中運行輕量級的虛擬機器。您可以使用 Colima 在本地環境中搭建和運行 Kubernetes 叢集。

Colima 提供了一個命令行界面，可以通過簡單的命令來管理虛擬機器和容器。它允許您在本地運行一個或多個輕量級虛擬機器，並在虛擬機器中運行 Kubernetes 叢集。

使用 Colima 搭建 Kubernetes 環境的過程相對簡單，它會自動處理虛擬機器和 Kubernetes 的安裝和配置。您只需要運行相應的命令，Colima 就會在虛擬機器中部署 Kubernetes，並為您提供 Kubernetes 的管理命令和用戶界面。

Colima 提供了一種快速且輕量級的方式來在本地機器上運行 Kubernetes，特別適合開發和測試的需求。請注意，Colima 目前處於開發者預覽階段，可能還不適用於生產環境。如果您打算在生產環境中運行 Kubernetes，建議考慮使用正式支持的工具或托管服務，像是可以選擇使用托管 Kubernetes 叢集的服務提供商，如 [Google Kubernetes Engine][13] (GKE)、[Amazon Elastic Kubernetes Service][14] (EKS)、[Microsoft Azure Kubernetes Service][15] (AKS)

Colima 專案目標就是在 MacOS 用最小力氣安裝好 Container Runtime 環境。名稱 Colima 也就是 Container in [Lima][16]。

[11]:https://github.com/abiosoft/colima
[12]:https://www.docker.com/
[13]:https://cloud.google.com/kubernetes-engine
[14]:https://aws.amazon.com/tw/eks/
[15]:https://azure.microsoft.com/zh-tw/services/kubernetes-service/
[16]:https://github.com/lima-vm/lima

## 安裝 Colima

Colima 可以在 Linux、macOS 上運行。您可以在 [GitHub][21] 上找到 Colima 的安裝指南。

```sh
# Stable Version
brew install colima
# Development Version
brew install --HEAD colima
```

除了安裝 colima 外，要使用 docker runtime 還需要安裝 `brew install docker`。

[21]:https://github.com/abiosoft/colima/blob/main/docs/INSTALL.md

## 使用 Colima

Colima 提供了一個命令行界面，可以通過簡單的命令來管理虛擬機器和容器。它允許您在本地運行一個或多個輕量級虛擬機器，並在虛擬機器中運行 Kubernetes 叢集。

### 啟動 Colima

您可以使用 `colima start` 命令來啟動 Colima。如果您第一次運行此命令，它會自動下載並安裝 Colima 的 Docker 映像。如果您已經安裝了 Colima，它會啟動 Colima。

```sh
# Start Colima
colima start
# 編輯設定檔案，並重新啟動
colima start --edit
# 使用 containerd 作為 runtime
colima start --runtime containerd
# 啟動 Kubernetes
colima start --kubernetes
# 啟動 Kubernetes 並使用 containerd 作為 runtime
colima start --runtime containerd --kubernetes
# 指定 CPU、記憶體、磁碟大小
colima start --cpu 4 --memory 8 --disk 100
# 指定 DNS
colima start --dns 1.1.1.1 --dns 8.8.8.8
```

預設啟動的是 `default` profile，如果要起動更多的 profile，可以透過 `--profile` 參數指定。

```sh
# Start Colima
colima start --profile myprofile
```

### 編輯 Colima 設定檔案

您可以使用 `colima edit` 命令來編輯 Colima 的設定檔案。如果您第一次運行此命令，它會自動創建一個新的設定檔案。如果您已經有一個設定檔案，它會打開現有的設定檔案。

```sh
# 路徑 $HOME/.colima/default/colima.yaml
vi $HOME/.colima/default/colima.yaml
```

其中要注意的是 `runtime` 預設是 `docker`，如果要使用 `containerd`，需要修改 `runtime` 的值。

```yaml
# Container runtime to be used (docker, containerd).
# Default: docker
runtime: docker
```

或者是要增加公司內部 Private Registry，可以透過 `docker` 設定。

```yaml
# EXAMPLE - add insecure registries
docker:
  insecure-registries:
    - myregistry.com:5000
    - host.docker.internal:5000
```

### 停止/刪除 Colima

要停止 Colima，您可以使用 `colima stop` 命令。要刪除 Colima，您可以使用 `colima delete` 命令。

```sh
# Stop Colima
colima stop
# Delete Colima
colima delete
```

預設的 Profile 是 `default`，如果要刪除特定的 Profile，可以透過 `--profile` 參數指定。

```sh
# Delete Colima
colima delete --profile myprofile
```

### 查看 Colima 狀態

您可以使用 `colima status` 命令來查看 Colima 的狀態。

```sh
# Status Colima
colima status <profile>
```

其中 `profile` 可以省略，預設是 `default`。

## 起動 Kubernetes 環境

透過上面教學，可以用底下指令快速啟動 Kubernetes 環境。

```sh
# Start Colima
colima start --kubernetes <profile>
```

底下是啟動後的結果。

```sh
$ colima start --runtime docker --kubernetes foobar
INFO[0000] starting colima [profile=foobar]
INFO[0000] runtime: docker+k3s
INFO[0000] preparing network ...                         context=vm
INFO[0000] creating and starting ...                     context=vm
INFO[0108] provisioning ...                              context=docker
INFO[0108] starting ...                                  context=docker
INFO[0113] provisioning ...                              context=kubernetes
INFO[0114] downloading and installing ...                context=kubernetes
INFO[0379] loading oci images ...                        context=kubernetes
INFO[0385] starting ...                                  context=kubernetes
INFO[0389] updating config ...                           context=kubernetes
INFO[0390] Switched to context "colima-foobar".          context=kubernetes
INFO[0390] done
```

可以透過 kubeconfig 檔案來查看 Kubernetes 環境。

```sh
CURRENT   NAME                                   CLUSTER                                AUTHINFO                               NAMESPACE
          colima                                 colima                                 colima
*         colima-foobar                          colima-foobar                          colima-foobar
```

可以看到如果是 `default` profile 名稱就是 `colima`，如果是 `foobar` profile 名稱就是 `colima-foobar`。可以透過 `kubectl config use-context` 切換不同的 profile。我們先建立一個 Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - name: http
    protocol: TCP
    port: 8080
    targetPort: 80
```

使用 `kubectl apply` 指令來建立 Deployment。

```sh
kubectl apply -f nginx.yaml
```

查看狀態

```sh
$ kubectl get deployments.apps
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   2/2     2            2           104s
```

大家可以就自己的情境來建立 Service 環境。

## 心得

Colima 提供了一個快速且輕量級的方式來在本地機器上運行 Kubernetes，特別適合開發和測試的需求。如果你想要在本地環境中搭建 Kubernetes 開發環境，可以試試看 Colima，它可以讓您在本地環境中運行輕量級的虛擬機器，並在虛擬機器中運行 Kubernetes 叢集。開發者專心在寫 Yaml 即可。有時候團隊成員想要試試看 Kubernetes，但是又不想要花太多時間在安裝和配置 Kubernetes，這時候 Colima 就是一個不錯的選擇。當然也可以選擇 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 或者是 Minikube 或 [Rancher Desktop](https://rancherdesktop.io/)，但是 Colima 的優勢在於它的輕量級，而且它的安裝和配置過程也比較簡單。
