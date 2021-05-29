---
title: Drone 搭配 Kubernetes 升級應用程式版本
author: appleboy
type: post
date: 2017-10-10T16:02:23+00:00
url: /2017/10/upgrade-kubernetes-container-using-drone/
dsq_thread_id:
  - 6204727104
categories:
  - DevOps
  - Drone CI
  - Kubernetes
tags:
  - drone
  - k8s
  - kubernetes

---
[<img src="https://i0.wp.com/farm5.staticflickr.com/4481/36944908123_68ecdb8139_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-10-10 at 9.22.48 PM" data-recalc-dims="1" />][1]

本篇要教大家如何透過 [Drone][2] 搭配 [Kubernetes][3] 自動化升級 App container 版本。為什麼我只說升級 App 版本，而不是升級或調整 K8S Deployment 架構呢 (`kubectl apply`)？原因是本篇會圍繞在 [honestbee][4] 撰寫的 drone 外掛: [drone-kubernetes][5]，此外掛是透過 Shell Script 方式搭配 [kubectl][6] 指令來完成升級 App 版本，可以看到程式原始碼並無用到 `kubectl apply` 方式來升級，也並非用 [Go 語言][7]搭配 k8s API 所撰寫，所以無法使用 [YAML][8] 方式來進行 Deployment 的升級。本篇講解的範例都可以在 [drone-nodejs-example][9] 內找到。底下指令就是外掛用來搭配 Drone 參數所使用。

<pre><code class="language-bash">$ kubectl set image \
  deployment/nginx-deployment \
  nginx=nginx:1.9.1</code></pre>

<!--more-->

## 事前準備

由於此外掛只有提供升級 App 版本，而不會自動幫忙建立 K8S 環境，所以在設定 Drone 之前，我們必須完成兩件事情。

  1. 建立 K8S Service 帳號
  2. 建立 K8S Deployment 環境

### 建立 K8S Service Account

首先要先建立一個 Service 帳號給 Drone 服務使用，也方便設定權限。

<pre><code class="language-yml">apiVersion: v1
kind: Namespace
metadata:
  name: demo

---

apiVersion: v1
kind: ServiceAccount
metadata:
  name: drone-deploy
  namespace: demo

---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: drone-deploy
  namespace: demo
rules:
  - apiGroups: ["extensions"]
    resources: ["deployments"]
    verbs: ["get","list","patch","update"]

---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: drone-deploy
  namespace: demo
subjects:
  - kind: ServiceAccount
    name: drone-deploy
    namespace: demo
roleRef:
  kind: Role
  name: drone-deploy
  apiGroup: rbac.authorization.k8s.io</code></pre>

先建立 `demo` namespace，再建立 drone-deploy 帳號，完成後就可以拿到此帳號 Token 跟 CA，可以透過底下指令來確認是否有 drone-deploy 帳號

<pre><code class="language-bash">$ kubectl -n demo get serviceAccounts
NAME           SECRETS   AGE
default        1         1h
drone-deploy   1         1h</code></pre>

接著顯示 `drone-deploy` 帳戶的詳細資訊

<pre><code class="language-bash">$ kubectl -n demo get serviceAccounts/drone-deploy -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: 2017-10-10T13:09:55Z
  name: drone-deploy
  namespace: demo
  resourceVersion: "917006"
  selfLink: /api/v1/namespaces/demo/serviceaccounts/drone-deploy
  uid: 4f445728-adbc-11e7-b130-06d06b7f944c
secrets:
- name: drone-deploy-token-2xzqw</code></pre>

可以看到 `drone-deploy-token-2xzqw` 此 secret name，接著從這名稱取得 `ca.cert` 跟 `token`:

<pre><code class="language-bash">$ kubectl -n demo get \
  secret/drone-deploy-token-2xzqw \
  -o yaml | egrep 'ca.crt:|token:'</code></pre>

由於 token 是透過 `base64` encode 輸出的。那也是要用 base64 decode 解出

<pre><code class="language-bash"># linux:
$ echo token | base64 -d && echo''
# macOS:
$ echo token | base64 -D && echo''</code></pre>

### 建立 K8S Deployment

在這邊我們需要先建立第一次 K8S 環境。

<pre><code class="language-yml">apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: k8s-node-demo
  namespace: demo
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: k8s-node-demo
    spec:
      containers:
      - image: appleboy/k8s-node-demo
        name: k8s-node-demo
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 3
          periodSeconds: 3

---

apiVersion: v1
kind: Service
metadata:
  name: k8s-node-demo
  namespace: demo
  labels:
    app: k8s-node-demo
spec:
  selector:
    app: k8s-node-demo
  # if your cluster supports it, uncomment the following to automatically create
  # an external load-balanced IP for the frontend service.
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080</code></pre>

先定義好 `replicas` 數量，及建立好 [AWS Load Balancer][10]。完成後，基本上你可以看到第一版本成功上線

<pre><code class="language-bash">$ kubectl get service
NAME            CLUSTER-IP      EXTERNAL-IP        PORT(S)        AGE
k8s-node-demo   100.67.24.253   a4fba848aadbc...   80:30664/TCP   11h</code></pre>

## 設定 Drone + Kubernetes

要完成 k8s 部署，必須要先將專案打包成 Image 並且上 Tag 丟到自家的 Private Registry。

<pre><code class="language-yml">publish:
  image: plugins/docker
  repo: appleboy/k8s-node-demo
  dockerfile: Dockerfile
  secrets:
    - source: demo_username
      target: docker_username
    - source: demo_password
      target: docker_password
  tags: [ '${DRONE_TAG}' ]
  when:
    event: tag</code></pre>

請先到 Drone 專案後台的 Secrets 設定 `demo_username` 及 `demo_password` 內容。並採用 GitHub 流程透過 Git Tag 方式進行。接著設定 K8S Deploy:

<pre><code class="language-yml">deploy:
  image: quay.io/honestbee/drone-kubernetes
  namespace: demo
  deployment: k8s-node-demo
  repo: appleboy/k8s-node-demo
  container: k8s-node-demo
  tag: ${DRONE_TAG}
  secrets:
    - source: k8s_server
      target: plugin_kubernetes_server
    - source: k8s_cert
      target: plugin_kubernetes_cert
    - source: k8s_token
      target: plugin_kubernetes_token
  when:
    event: tag</code></pre>

請注意 `k8s_cert` 跟 `k8s_token`，你需要拿上面的 `ca.cert` 跟 `token` 內容新增到 Drone Secrets 設定頁面。

[<img src="https://i0.wp.com/farm5.staticflickr.com/4463/37359179110_dee4948ef4_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-10-10 at 11.28.09 PM" data-recalc-dims="1" />][11]

完成後，下個 Tag 來試試看是否能部署成功。最後附上專案範例位置:

# [drone-nodejs-example][9]

## 後記

[Honestbee][4] 寫的 [drone-kubernetes][5] 外掛，無法直接讀取 K8S 設定檔，這是缺點之一，這樣就還需要另一個 Repo 存放全部 K8S 環境。雖然不是完全自動化的過程 (含建立 k8s 環境)，但是至少也有 80 分啦。對於本篇文章有不懂的地方，歡迎大家留言。我也錄製了 15 分鐘影片放在 [Udemy Drone 課程][12]，課程特價 1600 元。優惠代碼: **KUBERNETES**

 [1]: https://www.flickr.com/photos/appleboy/36944908123/in/dateposted-public/ "Screen Shot 2017-10-10 at 9.22.48 PM"
 [2]: https://github.com/drone/drone
 [3]: https://kubernetes.io/
 [4]: https://github.com/honestbee
 [5]: https://github.com/honestbee/drone-kubernetes
 [6]: https://kubernetes.io/docs/user-guide/kubectl-overview/
 [7]: https://golang.org
 [8]: https://en.wikipedia.org/wiki/YAML
 [9]: https://github.com/go-training/drone-nodejs-example
 [10]: https://aws.amazon.com/tw/elasticloadbalancing/
 [11]: https://www.flickr.com/photos/appleboy/37359179110/in/dateposted-public/ "Screen Shot 2017-10-10 at 11.28.09 PM"
 [12]: https://www.udemy.com/devops-oneday/?couponCode=KUBERNETES