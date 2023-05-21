---
title: "在 Kubernetes 中列出 Service 下的所有 Pod"
date: 2023-05-21T20:19:45+08:00
author: appleboy
type: post
slug: list-pods-from-k8s-service
share_img: https://lh3.googleusercontent.com/pw/AJFCJaXtuCuA5R-Xw8ea3rKHuIHwWY5JinU7EXhBsvq6HS1J0vva-4TYFsJY9fT7_gW69Dvf_khWJ1npoFO_yhxnY51WbWIW-OTQQfgxjLHxeEcQuO5JwT8l3Anp9Hku-ij7VU-bgUtygX-l-AwLgvPBZvYljQ=w860-h821-s-no?authuser=0
categories:
  - kubernetes
---

![cover](https://lh3.googleusercontent.com/pw/AJFCJaXtuCuA5R-Xw8ea3rKHuIHwWY5JinU7EXhBsvq6HS1J0vva-4TYFsJY9fT7_gW69Dvf_khWJ1npoFO_yhxnY51WbWIW-OTQQfgxjLHxeEcQuO5JwT8l3Anp9Hku-ij7VU-bgUtygX-l-AwLgvPBZvYljQ=w860-h821-s-no?authuser=0)

在 [Kubernetes][1] (簡稱 k8s) 中，Service Endpoint（服務終端點）是一個抽象的概念，代表著一個服務的網絡位置。它是一個內部或外部的 IP 地址，可以用來訪問運行在 Kubernetes 集群中的應用程序服務。而如何在 Kubernetes 中列出 Service 下的所有 Pod 呢？這篇文章將會介紹如何使用 kubectl 來列出 Service 下的所有 Pod。

[1]:https://kubernetes.io/

<!--more-->

## 準備環境

在開始之前，我們需要先準備好 k8s 的環境，這邊我們使用 [minikube][2] 來建立一個 k8s 的環境，並且使用 [kubectl][3] 來管理 k8s 的資源。底下我們先來建立 Nginx Pods。

[2]:https://minikube.sigs.k8s.io/docs/
[3]:https://kubernetes.io/docs/tasks/tools/

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: default
  labels:
    app: nginx
spec:
  containers:
  - image: nginx:latest
    name: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

除了建立 Pods 之外，我們也用 Deployment 來管理 Pods。

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
```

建立完成之後，我們可以使用 `kubectl get pods --show-labels` 來查看目前的 Pods 狀態。

```bash
NAME                     READY   STATUS    RESTARTS   AGE     LABELS
nginx                    1/1     Running   0          5h40m   app=nginx
nginx-6d7c8c89f7-rrszr   1/1     Running   0          5h7m    app=nginx,pod-template-hash=6d7c8c89f7
nginx-6d7c8c89f7-n2n6c   1/1     Running   0          5h7m    app=nginx,pod-template-hash=6d7c8c89f7
```

最後建立兩個 Service (NodePort + Cluster) 來對應到 Nginx Pods。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
  - name: http
    protocol: TCP
    port: 3000
    targetPort: 80

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

建立完成之後，我們可以使用 `kubectl get svc -o wide` 來查看目前的 Service 狀態。

```bash
NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE     SELECTOR
kubernetes       ClusterIP   10.43.0.1      <none>        443/TCP          5h49m   <none>
nginx            ClusterIP   10.43.61.137   <none>        3000/TCP         5h41m   app=nginx
nginx-nodeport   NodePort    10.43.51.4     <none>        8080:30140/TCP   5h41m   app=nginx
```

## 列出 Service 下的所有 Pod

先列出目前所有 Service 的 Endpoint。(`kubectl get endpoints`)

```bash
NAME             ENDPOINTS                                   AGE
kubernetes       192.168.5.15:6443                           5h51m
nginx-nodeport   172.17.0.6:80,172.17.0.7:80,172.17.0.9:80   5h44m
nginx            172.17.0.6:80,172.17.0.7:80,172.17.0.9:80   5h44m
```

從上面結果看到 nginx 對應到三個 Pod，而 nginx-nodeport 也對應到三個 Pod，這邊我們可以使用 `kubectl get endpoints nginx -o yaml` 來查看詳細的資訊。

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  creationTimestamp: "2023-05-21T07:15:41Z"
  name: nginx
  namespace: default
  resourceVersion: "1164"
  uid: 686d68e6-a58b-4a12-a2d4-0f4ea88b9b56
subsets:
- addresses:
  - ip: 172.17.0.6
    nodeName: colima
    targetRef:
      kind: Pod
      name: nginx
      namespace: default
      uid: e717d901-4319-4ea6-b33d-31dff7c79549
  - ip: 172.17.0.7
    nodeName: colima
    targetRef:
      kind: Pod
      name: nginx-6d7c8c89f7-n2n6c
      namespace: default
      uid: b6e7c74c-3d1f-494e-b05d-9242e367cfe3
  - ip: 172.17.0.9
    nodeName: colima
    targetRef:
      kind: Pod
      name: nginx-6d7c8c89f7-rrszr
      namespace: default
      uid: 7528bfd6-d6dd-4557-873f-6f8ed9b9ebd4
  ports:
  - name: http
    port: 80
    protocol: TCP
```

我們該如何從上面的資訊找到所有 Pod 的 Name 呢？這邊我們可以使用 `kubectl get endpoints nginx -o jsonpath='{.subsets[*].addresses[*].targetRef.name}'` 來取得所有 Pod 的 Name。

```bash
$ kubectl get endpoints nginx -o jsonpath='{.subsets[*].addresses[*].targetRef.name}'
nginx nginx-6d7c8c89f7-n2n6c nginx-6d7c8c89f7-rrszr
```

最後我們把上述輸出的結果放到 `kubectl get pods` 來查看詳細的 Pod 資訊。

```bash
kubectl get pods nginx nginx-6d7c8c89f7-n2n6c nginx-6d7c8c89f7-rrszr
```

用一個指令完成上述步驟。

```bash
kubectl get pods $(kubectl get endpoints nginx -o jsonpath='{.subsets[*].addresses[*].targetRef.name}')
# or
kubectl get endpoints nginx -o jsonpath='{.subsets[*].addresses[*].targetRef.name}' \
  | xargs kubectl get pods -o wide
```
