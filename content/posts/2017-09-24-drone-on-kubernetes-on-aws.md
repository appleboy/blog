---
title: 用 Kubernetes 將 Drone CI/CD 架設在 AWS
author: appleboy
type: post
date: 2017-09-23T16:55:33+00:00
url: /2017/09/drone-on-kubernetes-on-aws/
dsq_thread_id:
  - 6165312082
categories:
  - DevOps
  - Docker
  - Kubernetes
tags:
  - drone
  - kubernetes

---
[<img src="https://i0.wp.com/farm5.staticflickr.com/4497/37237823752_68a508e4bb_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-09-24 at 12.53.39 AM" data-recalc-dims="1" />][1]

[Drone][2] 是我今年主推的 CI/CD 自架服務，詳細可以參考[這篇文章][3]，目前在公司內部團隊使用了一年以上，服務相當穩定。Drone 本身可以透過 [docker-compose 方式][4]快速在機器上架設完成，但是由於 [Kubernetes][5] 的盛行，大家也希望能透過 Kubernetes 來安裝 Drone 服務。本篇會教大家如何在 AWS 上透過 Kubernetes 安裝完成。Drone 預設使用 [SQLite][6] 當作資料庫，檔案會直接存放在 `/var/lib/drone` 路徑底下，但是容器內不支援寫入，所以必須要要額外掛上空間讓 Drone 可以寫入資料。此篇會以 [GitHub][7] 認證 + SQLite 來教學。

<!--more-->

## 事前準備

  1. 在 AWS 上面 建立 kubernets
  2. 在 AWS 上面建立 EBS 空間存放 SQLite
  3. 申請 GitHub OAut

在安裝 Drone 之前，有三件事情務必先完成，第一是要先有 K8S 環境，本篇不會教大家如何架設出 K8S 環境。但是你可以透過官方提供的方式來測試:

  1. 使用 [Minikube][8] (快速在本機端架設出 K8S Cluster)
  2. [Katacoda][9]
  3. [Play with Kubernetes][10] (單次免費四小時)

第二，你需要先在 AWS 上面建立一個 1G 的 EBS 空間，空間大小由你決定，你可以透過 AWS CLI 或直接到 AWS Console 頁面建立，底下是建立 EBS 的指令

<pre><code class="language-bash">$ aws ec2 create-volume \
  --availability-zone=ap-southeast-1a \
  --size=1 --volume-type=gp2</code></pre>

注意 `availability-zone` 區域要跟 K8S 同樣，大小先設定 1G。完成後會看到底下訊息:

<pre><code class="language-json">{
    "AvailabilityZone": "ap-southeast-1a",
    "Encrypted": false,
    "VolumeType": "gp2",
    "VolumeId": "vol-04741f74eb0f6b891",
    "State": "creating",
    "Iops": 100,
    "SnapshotId": "",
    "CreateTime": "2017-09-23T15:42:24.319Z",
    "Size": 1
}</code></pre>

之後會用到 `VolumeId`。假如沒有做此步驟，您會發現 Drone 伺服器是無法啟動成功。最後是請到 GitHub 帳號內建立一個全新 OAuth App，並取得 `CLient` 跟 `Secret` 代碼。

## 安裝 Drone

所有的 Yaml 檔案都可以直接在 [appleoy/drone-on-kubernetes][11]，找到。首先打開 `drone-server-deployment.yaml`，找到 `volumeID` 取代成上述建立好的結果。

<pre><code class="language-diff">  awsElasticBlockStore:
    fsType: ext4
    # NOTE: This needs to be pointed at a volume in the same AZ.
    # You need not format it beforehand, but it must already exist.
    # CHANGEME: Substitute your own EBS volume ID here.
-   volumeID: vol-xxxxxxxxxxxxxxxxx
+   volumeID: vol-01f13b969e9dabff7</code></pre>

再來設定 server 跟 agent 溝通用的 Secret，打開 `drone-secret.yaml`

<pre><code class="language-diff">data:
-  server.secret: ZHJvbmUtdGVzdC1kZW1v
+  server.secret: ZHJvbmUtdGVzdC1zZWNyZXQ=</code></pre>

透過 base64 指令換掉上面的代碼。假設密碼設定 `drone-test-secret`，請執行底下指令

<pre><code class="language-bash">$ echo -n "drone-test-secret" | base64
ZHJvbmUtdGVzdC1zZWNyZXQ=</code></pre>

在 GitHub 上面建立新的 Application，並且拿到 Client ID 跟 Secret Key，修改 `drone-configmap.yaml` 檔案

<pre><code class="language-bash">server.host: drone.example.com
server.remote.github.client: xxxxx
server.remote.github.secret: xxxxx</code></pre>

接著陸續執行底下指令，新增 Drone NameSpace 並且將 server 及 agent 服務啟動

<pre><code class="language-bash">$ kubectl create -f drone-namespace.yaml
$ kubectl create -f drone-secret.yaml
$ kubectl create -f drone-configmap.yaml
$ kubectl create -f drone-server-deployment.yaml
$ kubectl create -f drone-server-service.yaml
$ kubectl create -f drone-agent-deployment.yaml</code></pre>

完成後，k8s 會自動建立 ELB，透過 kubectl 可以看到 ELB 名稱

<pre><code class="language-bash">$ kubectl --namespace=drone get service -o wide</code></pre>

執行後看到底下結果:

<pre><code class="language-bash">NAME            CLUSTER-IP      EXTERNAL-IP
drone-service   100.68.89.117   xxxxxxxxx.ap-southeast-1.elb.amazonaws.com</code></pre>

拿到 ELB 網域後，可以直接更新 GitHub 的 application 資料

[<img src="https://i0.wp.com/farm5.staticflickr.com/4496/37219005806_947da585f0_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-09-23 at 3.40.28 PM" data-recalc-dims="1" />][12]

最後打開瀏覽器，填入上述的網址，會發現直接轉到 GitHub OAuth 認證，點選確認後，Drone 會開始讀取您的個人資料，這樣就代表成功了。

## 懶人包安裝

上述步驟是不是有點複雜，要執行的 kubectl 指令非常多，所以我提供了另一種安裝方式，就是透過 [install-drone.sh]，執行這 Shell Script 檔案前，你必須先做兩件事情。1. 申請 EBS 空間，完成後請修改 `drone-server-deployment.yaml` 內的 `volumeID`。2. 申請 [GitHub OAuth Application][13]，完成後請修改 `drone-configmap.yaml` 內的 GitHub 設定。最後執行底下指令

<pre><code class="language-bash">$ ./install-drone.sh</code></pre>

## 擴展 agent 服務

假設一個 agent 已經不符合團隊需求，在 k8s 內只要一個指令就可以自動水平擴展 agent:

<pre><code class="language-bash">$ kubectl scale deploy/drone-agent \
  --replicas=2 --namespace=drone</code></pre>

其中 `replicas` 可以改成你要的數字。

## 如何清除 Drone 服務

我們已經將 Drone 資料庫備份在 EBS，所以隨時都可以移除 Drone 服務，透過簡單的指令就可以清除掉 Drone 所有容器，只要下清除 Namespace 即可

<pre><code class="language-bash">$ kubectl delete -f drone-namespace.yaml</code></pre>

# 歡迎追蹤 [drone-on-kubernetes][11]

## 後記

這算是我的第一篇 Kubernetes 心得文，就先拿 Drone 服務來測試看看。Drone 作者也很用心寫了一個接口讓 K8S 可以監控 agent 容器，假如您不是使用 SQLite 而是用 MySQL 資料庫，就需要修改 YAML 設定檔。對於本篇文章有不懂的地方，歡迎大家留言。我也錄製了 15 分鐘影片放在 [Udemy Drone 課程][14]，課程特價 1600 元。優惠代碼: **KUBERNETES**

 [1]: https://www.flickr.com/photos/appleboy/37237823752/in/dateposted-public/ "Screen Shot 2017-09-24 at 12.53.39 AM"
 [2]: https://github.com/drone/drone
 [3]: https://blog.wu-boy.com/2017/09/why-i-choose-drone-as-ci-cd-tool/
 [4]: https://github.com/go-training/drone-tutorial
 [5]: https://kubernetes.io/
 [6]: https://www.sqlite.org/
 [7]: https://github.com
 [8]: https://kubernetes.io/docs/getting-started-guides/minikube
 [9]: https://www.katacoda.com/courses/kubernetes/playground
 [10]: http://labs.play-with-k8s.com/
 [11]: https://github.com/appleboy/drone-on-kubernetes
 [12]: https://www.flickr.com/photos/appleboy/37219005806/in/dateposted-public/ "Screen Shot 2017-09-23 at 3.40.28 PM"
 [13]: https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/
 [14]: https://www.udemy.com/devops-oneday/?couponCode=KUBERNETES