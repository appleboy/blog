---
title: "如何產生開發者 kubeconfig 設定檔"
date: 2023-05-31T07:56:20+08:00
author: appleboy
type: post
slug: how-to-create-user-kubeconfig-file
share_img: https://lh3.googleusercontent.com/pw/AJFCJaWyFC1UXBwtZxoLTamoUztI0cikLLTKKf_wugXxkeQxOsXODnMs8fMiO_BcJuC6sF5f9vzfM5s0Q-wMMjuCzvx3OwmEVnnxENYALUhOXaoBxtsu3v5_DomatQM70DpkNqSv5hYdX7NKHqLzK9-E0QLmrA=w678-h677-s-no?authuser=0
categories:
  - kubernetes
---

![logo](https://lh3.googleusercontent.com/pw/AJFCJaWyFC1UXBwtZxoLTamoUztI0cikLLTKKf_wugXxkeQxOsXODnMs8fMiO_BcJuC6sF5f9vzfM5s0Q-wMMjuCzvx3OwmEVnnxENYALUhOXaoBxtsu3v5_DomatQM70DpkNqSv5hYdX7NKHqLzK9-E0QLmrA=w678-h677-s-no?authuser=0)

<!--more-->

## 如何產生 Service Account Token

要產生一個新的 Token，你可以使用 `kubectl` 命令的 `create serviceaccount` 子命令來完成。請按照以下步驟進行操作：打開終端機（命令提示字元或終端）。運行以下命令：

```bash
kubectl create serviceaccount <SERVICE_ACCOUNT_NAME>
```

替換 `<SERVICE_ACCOUNT_NAME>` 為你想要設置的服務帳戶名稱。執行上述命令後，它會在 Kubernetes 集群中創建一個新的服務帳戶。接下來，你需要為該服務帳戶創建一個角色綁定（Role Binding），以便為該服務帳戶授予足夠的權限。你可以使用 `kubectl` 命令的 `create rolebinding` 子命令來完成。請按照以下步驟進行操作：打開終端機（命令提示字元或終端）。運行以下命令：

```bash
kubectl create rolebinding <ROLE_BINDING_NAME> \
  --clusterrole=<CLUSTER_ROLE> \
  --serviceaccount=<NAMESPACE>:<SERVICE_ACCOUNT_NAME>
```

你也可以透過底下 YAML 檔案直接建立 RoleBinding 及 ServiceAccount。

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: update-deployments
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: drone-ci
  namespace: default

---
apiVersion: v1
kind: Secret
metadata:
  name: drone-ci
  namespace: default
  annotations:
    kubernetes.io/service-account.name: drone-ci
type: kubernetes.io/service-account-token

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: drone-ci
subjects:
- kind: ServiceAccount
  name: drone-ci
  namespace: default
roleRef:
  kind: Role
  name: update-deployments
  apiGroup: rbac.authorization.k8s.io
```

完成上述動作後，接下來就是找到該 Service Account 綁定的 Secret，並且取得該 Secret 的 Token。

```bash
kubectl get secret drone-ci -o jsonpath="{.data.token}" | base64 --decode
```

## 登入 Kubernetes 集群設定

要生成開發者的 kubeconfig 檔案，你可以按照以下步驟進行操作：確定你已經安裝了 Kubernetes 命令行工具（kubectl）。如果你尚未安裝，請參考 Kubernetes 官方文檔進行安裝。請求 Kubernetes 集群的管理員（一般為系統管理員或擁有相應權限的使用者）提供你的開發者帳戶的訪問權限。登入到你的開發者帳戶，確保你有足夠的權限進行 kubeconfig 的生成和配置。

打開終端機（命令提示字元或終端），運行以下命令：

```bash
kubectl config set-credentials <USERNAME> --token=<ACCESS_TOKEN> --certificate-authority=<CA_PATH>
```

將 `<USERNAME>` 替換為你的使用者名稱，`<ACCESS_TOKEN>` 替換為你的身份驗證令牌（Access Token），`<CA_PATH>` 是 CA 憑證的路徑。繼續運行以下命令：

```bash
kubectl config set-cluster <CLUSTER_NAME> --server=<CLUSTER_API_SERVER>
```

替換 `<CLUSTER_NAME>` 為你的集群名稱，`<CLUSTER_API_SERVER>` 為集群的 API 伺服器位址。最後，運行以下命令：

```bash
kubectl config set-context <CONTEXT_NAME> --cluster=<CLUSTER_NAME> --user=<USERNAME>
```

替換 `<CONTEXT_NAME>` 為你想要設置的上下文名稱（例如 development 或 production），`<CLUSTER_NAME>` 為你的集群名稱，`<USERNAME>` 為你的使用者名稱。確認 kubeconfig 檔案的位置。通常，kubeconfig 檔案位於 `~/.kube/config`（Unix/Linux）或 `%USERPROFILE%\.kube\config`（Windows）。

完成上述步驟後，你的 kubeconfig 檔案就已經生成並配置完成了。你可以使用 kubectl 命令來進行 Kubernetes 集群操作，它會使用該 kubeconfig 檔案作為身份驗證和設定。

## 產生 kubeconfig 檔案

要將上述設定輸出為檔案，你可以使用 `kubectl` 命令的 `config view` 子命令來完成。請按照以下步驟進行操作：打開終端機（命令提示字元或終端）。運行以下命令：

```bash
kubectl config view --minify --flatten > kubeconfig.yaml
```

這個命令將會將 kubeconfig 設定的內容以 YAML 格式輸出。執行上述命令後，它會將 kubeconfig 的內容輸出到一個名為 kubeconfig.yaml 的檔案中。你可以根據需要自行指定輸出檔案的名稱和路徑。

現在，你已經將 kubeconfig 設定成功輸出成一個檔案，你可以將該檔案共享給其他開發者或在其他機器上使用。下面是一個示例的 kubeconfig.yaml 內容：

```yaml
apiVersion: v1
clusters:
- cluster:
    server: <CLUSTER_API_SERVER>
  name: <CLUSTER_NAME>
contexts:
- context:
    cluster: <CLUSTER_NAME>
    user: <USERNAME>
  name: <CONTEXT_NAME>
current-context: <CONTEXT_NAME>
kind: Config
preferences: {}
users:
- name: <USERNAME>
  user:
    token: <ACCESS_TOKEN>
```

請將 `<CLUSTER_API_SERVER>` 替換為你的集群的 API 伺服器位址，`<CLUSTER_NAME>` 替換為你的集群名稱，`<CONTEXT_NAME>` 替換為你想要設置的上下文名稱，`<USERNAME>` 替換為你的使用者名稱，`<ACCESS_TOKEN>` 替換為你的身份驗證令牌（Access Token）。

在你的 `kubeconfig.yaml` 檔案中，你可以找到 clusters、contexts 和 users 部分，它們分別包含了集群、上下文和使用者的設定。同時，`current-context` 部分指定了當前使用的上下文。