---
title: Caddy 搭配 Harbor 自架私有 Docker Registry
author: appleboy
type: post
date: 2018-01-04T07:20:27+00:00
url: /2018/01/caddy-harbor-docker-registry/
dsq_thread_id:
  - 6390387288
categories:
  - DevOps
  - Docker
tags:
  - Docker

---
[<img src="https://i2.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_z.jpg?w=840&#038;ssl=1" alt="docker" data-recalc-dims="1" />][1]

[Harbor][2] 是由 [VMWare][3] 公司用 [Go 語言][4]所開發的開源軟體，它可以讓團隊存放各種不同的私有 [Docker][5] 映像檔，假如團隊內沒考慮 [AWS 的 ECR][6] 或者是 Google 提供的 [GCR 方案][7]，建議您可以參考看看 Harbor，而 Harbor 提供了簡易的 UI 介面，包含權限控管，及跨區域的自動同步功能，比起自己從官網把 [Docker Registry][8] 架起來，功能多上不少。本篇不會教大家如何架設 Harbor，有興趣的可以直接參考[官方文件][9]，此篇會紀錄如何透過 Caddy 將憑證用在 Harbor 內部。

<!--more-->

## 問題?

我本來把 Harbor 架設在 AWS EC2 上面，而剛開始是採用 `http` 並非使用 `https`，這在搭配 [Kubernetes][10] 會有個問題，因為假設使用 `http` 的話，Docker 預設是不吃 http 的，所以必須要在 k8s 每一個 Node 機器內補上下面設定

<pre><code class="language-bash"># open /etc/docker/daemon.json
{
  "debug" : true,
  "insecure-registries" : [
    "harbor.xxxx.com"
  ]
}</code></pre>

如果在個人電腦上面 (Mac) 則是需要到底下 Docker 設定頁面補上 register 資訊

[<img src="https://i0.wp.com/farm5.staticflickr.com/4597/38780973024_0ca7626864_o.png?w=840&#038;ssl=1" alt="Screen Shot 2018-01-02 at 11.20.27 PM" data-recalc-dims="1" />][11]

如果今天在 k8s 內需要自動擴展一台新的 EC2 機器，你會發現在這台 EC2 機器內是抓不到任何 Image 檔案，所以必須要讓 Harbor 支援 https 才能解決掉此問題。

## 解決方式

在 Harbor 內可以參考[此份文件][12]將憑證檔案放到 Docker 內部。假設今天沒有憑證，其實可以透過 Caddy 方式來拿到憑證放到 Dokcer 內部。第一步先找到 Caddy 存放路徑，一般來說是放在 `~/.caddy/` 目錄，接著透過 link 方式放到 `/data` 目錄 (`/data` 是 Harbor 預設放在 Host 的目錄)

<pre><code class="language-bash">ln -sf ~/.caddy/acme/acme-v01.api.letsencrypt.org/sites/your_domain.com/harbor.wu-boy.com.key /data/cert/server.key
ln -sf ~/.caddy/acme/acme-v01.api.letsencrypt.org/sites/your_domain.com/harbor.wu-boy.com.cert /data/cert/server.cert</code></pre>

接著打開 `harbor.cfg` 將 `ui_url_protocol` 設定為 `https`

<pre><code class="language-bash">ui_url_protocol = https</code></pre>

重新啟動 harbor

<pre><code class="language-bash">$ ./prepare
$ docker-compose down
$ docker-compose up -d</code></pre>

## 設定 Caddy

這邊不確定是不是 Harbor 的 bug，理論上如果在 Harbor 內跑 http，只要把 Caddy 設定好 proxy 理論上要可以通，但是實際上就是不行，必須要在 harbor 跑 `https` 然後 Caddy 也跑 `https` 才行

<pre><code class="language-bash">your_domain.com {
  log stdout
  proxy / https://your_domain.com:8089 {
    websocket
    transparent
  }
}</code></pre>

其中 8089 就是對應到 harbor 容器內的 443 port。這樣還不夠，你必須要在 `/etc/hosts` 底下補上

<pre><code class="language-bash">127.0.0.1 your_domain.com</code></pre>

這樣才可以正確讓 Caddy + Harbor 正式跑起來，並且三個月自動更換憑證。

## 心得

沒有時間去研究 Harbor 底層為什麼會出現這問題，有時間的話再來研究看看。可能是在 harbor 包的 Nginx 容器設定有些問題。

 [1]: https://www.flickr.com/photos/appleboy/25660808075/in/dateposted-public/ "docker"
 [2]: http://vmware.github.io/harbor/
 [3]: https://www.vmware.com
 [4]: https://golang.org
 [5]: https://www.docker.com/
 [6]: https://aws.amazon.com/tw/ecr/
 [7]: https://cloud.google.com/container-registry/
 [8]: https://docs.docker.com/registry/#what-it-is
 [9]: https://github.com/vmware/harbor/blob/master/docs/user_guide.md
 [10]: https://kubernetes.io/
 [11]: https://www.flickr.com/photos/appleboy/38780973024/in/dateposted-public/ "Screen Shot 2018-01-02 at 11.20.27 PM"
 [12]: https://github.com/vmware/harbor/blob/master/docs/configure_https.md