---
title: "如何產生開發者 kubeconfig 設定檔"
date: 2023-05-31T07:56:20+08:00
author: appleboy
type: post
slug: how-to-create-user-kubeconfig-file
share_img: https://lh3.googleusercontent.com/pw/AJFCJaXtuCuA5R-Xw8ea3rKHuIHwWY5JinU7EXhBsvq6HS1J0vva-4TYFsJY9fT7_gW69Dvf_khWJ1npoFO_yhxnY51WbWIW-OTQQfgxjLHxeEcQuO5JwT8l3Anp9Hku-ij7VU-bgUtygX-l-AwLgvPBZvYljQ=w860-h821-s-no?authuser=0
categories:
  - kubernetes
---

![logo](https://lh3.googleusercontent.com/pw/AJFCJaXtuCuA5R-Xw8ea3rKHuIHwWY5JinU7EXhBsvq6HS1J0vva-4TYFsJY9fT7_gW69Dvf_khWJ1npoFO_yhxnY51WbWIW-OTQQfgxjLHxeEcQuO5JwT8l3Anp9Hku-ij7VU-bgUtygX-l-AwLgvPBZvYljQ=w860-h821-s-no?authuser=0)

產生 `kubeconfig` 檔案需要準備底下資訊

```sh
export KUBECONFIG=<path-to-kubeconfig-file>
export CLUSTER_NAME=<cluster-name>
export SERVER_URL=<server-url>
export CA_CERT=<path-to-ca-certificate>
export TOKEN=<token>
export USERNAME=<username>
```

將 `<path-to-kubeconfig-file>` 替換為要生成的 kubeconfig 檔案的路徑和名稱，例如 `~/mykubeconfig`。將 `<cluster-name>` 替換為你的叢集名稱， `<server-url>` 替換為你的 Kubernetes API 伺服器的 URL， `<path-to-ca-certificate>` 替換為你的 CA 憑證的路徑和名稱， `<username>` 替換為你的使用者名稱，`<token>` 替換為你的身份驗證令牌（Access Token），透過底下指令就可以完成了

<!--more-->

```sh
kubectl config set-cluster $CLUSTER_NAME --server=$SERVER_URL --certificate-authority=$CA_CERT --embed-certs=true
kubectl config set-credentials $USERNAME --token=$TOKEN
kubectl config set-context $USERNAME-context --cluster=$CLUSTER_NAME --user=$USERNAME
kubectl config use-context $USERNAME-context
kubectl config view --minify --flatten > $KUBECONFIG
```

底下我們來拆解上面的指令，以及如何產生 Service Account Token。

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

```bash
kubectl config use-context <CONTEXT_NAME>
```

替換 `<CONTEXT_NAME>` 為你想要切換的群集名稱（例如 xxxx-development 或 xxxx-production）。

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

如果是在 Windows 系統上，你可以使用以下命令將 kubeconfig 設定輸出為一個環境變數：

```bash
kubectl config view --minify --flatten > $env:USERPROFILE\.kube\config
```

上述的方式，是從自己的電腦上產生 kubeconfig 檔案，如果你想要從遠端的 Kubernetes 集群上產生 kubeconfig 檔案，你可以使用 [deploy-k8s](https://github.com/appleboy/deploy-k8s) 這套工具。如果你是 k8s 管理者，開完 Service Account，可以透過底下方式，就不用先匯入到自己的 kubeconfiug 後，在用上述方式匯出，直接用 deploy-k8s 工具就可以直接匯出。

可以在目前當下目錄，新增 `.env` 檔案，內容如下

```env
INPUT_SERVER=https://hostname:port
INPUT_CA_CERT=base64_encode_data
INPUT_TOKEN=base64_encode_data
INPUT_SKIP_TLS_VERIFY=false
INPUT_OUTPUT=kubeconfig
```

接著執行 `deploy-k8s` 工具

```bash
docker run --rm -it -v $(pwd):/app appleboy/deploy-k8s
```

你也可以針對 Context, AuthInfo, Cluster 進行設定，詳細可以參考 [deploy-k8s](https://github.com/appleboy/deploy-k8s#usage) 內的使用方式。

```diff
INPUT_SERVER=https://hostname:port
INPUT_CA_CERT=base64_encode_data
INPUT_TOKEN=base64_encode_data
INPUT_SKIP_TLS_VERIFY=false
INPUT_OUTPUT=kubeconfig
+INPUT_CLUSTER_NAME=gcp-k8s-project
+INPUT_AUTHINFO_NAME=project-user
+INPUT_CONTEXT_NAME=project-prod
```

最後一樣執行上述 `docker` 指令即可。

## 如何合併多個 kubeconfig

在操作底下步驟前，請先做備份

```bash
cp $HOME/.kube/config $HOME/.kube/config-backup
```

可以在家目錄內的 `.kube` 目錄下，新增新目錄 `others`

```bash
export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/others/cluster1:$HOME/.kube/others/cluster2
```

如果你有多個 kubeconfig 檔案，你可以下命令快速設置 `KUBECONFIG` 環境變數

```bash
export KUBECONFIG=$HOME/.kube/config:$(find $HOME/.kube/others -type f -maxdepth 1 | tr '\n' ':')
```

最後使用 `kubectl` 命令的 `config view` 子命令來合併多個 kubeconfig 檔案。請按照以下步驟進行操作：打開終端機（命令提示字元或終端）。運行以下命令：

```bash
kubectl config view --merge --flatten > kubeconfig.yaml
```

這個命令將會將多個 kubeconfig 檔案的內容合併並輸出到一個名為 kubeconfig.yaml 的檔案中。你可以根據需要自行指定輸出檔案的名稱和路徑。最後請將此檔案複製到你的家目錄下的 .kube 目錄中 (請先備份)。

```bash
cp kubeconfig.yaml $HOME/.kube/config
```

## 參考資料

* [Kubernetes - 使用者帳戶](https://kubernetes.io/zh-cn/docs/reference/access-authn-authz/authentication/)
* [deploy-k8s](https://github.com/appleboy/deploy-k8s#usage) Generate a Kubeconfig or creating & updating K8s Deployments.
