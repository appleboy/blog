---
title: 如何將前端網站打包成 Docker Image
author: appleboy
type: post
date: 2020-07-26T14:09:09+00:00
url: /2020/07/how-to-create-docker-image-in-reactjs-or-vuejs/
dsq_thread_id:
  - 8141645483
categories:
  - DevOps
  - Docker
tags:
  - Docker

---
[![cover][1]][1]

以現在開發網站流程，前後端分離已經不稀奇了。前端使用 [React.js][2] 或 [Vue.js][3]，後端使用 [Golang][4]，是我現在擅長的合作模式。其實後端在開發上面不太需要將前端的開發流程放在自己的電腦上，也就是後端只需要專注開發後端，跟前端的溝通都會是透過 [GraphQL][5] 的 [Schema][6] 當作討論。目前團隊各自維護專案的部署流程會是最好的方式，前端有兩種方式部署，一種是透過打包靜態檔案方式丟到遠端伺服器，另一種就是打包成 [Docker][7] Image，再連線到遠端伺服器更新，兩者都有人使用，本篇會教大家如何將前端網站打包成 Docker Image，用 Image 來部署會是最方便的。

<!--more-->

## 教學影片

{{< youtube QdTmWAaB38A >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][8]
  * [一天學會 DevOps 自動化測試及部署][9]
  * [DOCKER 容器開發部署實戰][10]

如果需要搭配購買請直接透過 [FB 聯絡我][11]，直接匯款（價格再減 **100**）

## 前端打包

直接看 Reactjs 的 [Deployment 章節][12]，文件寫的非常清楚，透過簡單的指令就可以將前端網站編譯在 `build` 目錄內，開發者只要將 `build` 目錄打包丟上遠端伺服器即可。

<pre><code class="language-bash">npm ci
npm run build:staging</code></pre>

簡單兩個步驟就搞定了，接下來要將 `build` 目錄放進 Docker Image。

## 打包 Docker

首先前端的 Dockerfile 相當簡單，只要選 nginx 當做基底，再把相關的 html 檔案複製進去即可

<pre><code class="language-dockerfile=">FROM nginx:1.19

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="web" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

EXPOSE 8080

COPY ./config/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]</code></pre>

可以在前端專案建立 docker 目錄，將上述內容存放成 `Dockerfile`。大家有無發現多了一行 nginx config 設定

<pre><code class="language-bash">COPY ./config/nginx/nginx.conf /etc/nginx/conf.d/default.conf</code></pre>

這目的是要將所有的 URL Routing 都直接轉給 React 或 Vue 去控管，不然只要重新整理網頁就會看到 `404 not found`

<pre><code class="language-bash">server {
  listen       80;
  location / {
    root   /usr/share/nginx/html;
    index  index.html index.htm;
    try_files $uri $uri/ /index.html =404;
  }
}</code></pre>

透過 `try_files` 可以解決掉 404 的問題。完成上述步驟後，就可以直接在電腦測試

<pre><code class="language-bash">docker build -t appleboy/app -f docker/Dockerfile.linux.amd64 .</code></pre>

## 串接部署

這邊就看團隊是用什麼工具部署，底下是 [GitHub Action][13] 部署方式，流程都是一樣的，只是用的工具不同，相信會一套，理論上另一種工具也要會

<pre><code class="language-yml">name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: build web
      uses: actions/setup-node@v1
      with:
        node-version: 12.x
    - run: npm ci
    - run: npm run build:staging

    - name: upload image to ECR
      uses: appleboy/docker-ecr-action@v0.0.2
      with:
        access_key: ${{ secrets.aws_access_key_id }}
        secret_key: ${{ secrets.aws_secret_access_key }}
        registry: ecr.ap-northeast-1.amazonaws.com
        cache_from: ecr.ap-northeast-1.amazonaws.com/frontend
        repo: frontend
        region: ap-northeast-1
        dockerfile: docker/Dockerfile.linux.amd64

    - name: pull and restart service
      uses: appleboy/ssh-action@master
      with:
        host: xxx.xxx.xxx.xxx
        username: deploy
        key: ${{ secrets.ssh_key }}
        port: 22
        proxy_host: xxx.xxx.xxx.xxx
        proxy_username: ubuntu
        proxy_port: 443
        proxy_key: ${{ secrets.proxy_ssh_key }}
        script: |
          cd /home/deploy/api/io && aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ecr.ap-northeast-1.amazonaws.com/frontend
          docker-compose pull
          docker-compose up -d web
</code></pre>

步驟就是

  1. 編譯 build 目錄
  2. 打包 Docker Image 丟到 [ECR][14]
  3. 連線到遠端機器更新服務

## 心得

為了能夠讓網站可以跨不同的雲系統，統一使用 Docker 是最正確的方式，之後想要用 Kubernetes 或是用 docker-compose 都可以無痛轉移，這是趨勢，大家試著將服務都打包成 Docker 吧，方便自己也方便其他開發者。

 [1]: https://lh3.googleusercontent.com/2oJnx10msYCEJymUjCFZy3VspTSETeOGLcH8M5tHP2l2SP1yVtR7cUCZSO-3nc1Z6qQuc0FZMUFHViyfkhIFOz60ZocVZ8TxsneH2qZW7Hkio-TvCSxQ1GUM1sEpUSxRH284tP_VsSk=w1920-h1080 "cover"
 [2]: https://reactjs.org/
 [3]: https://vuejs.org/
 [4]: https://golang.org
 [5]: https://graphql.org/
 [6]: https://graphql.org/learn/schema/
 [7]: https://www.docker.com/
 [8]: https://www.udemy.com/course/golang-fight/?couponCode=202007
 [9]: https://www.udemy.com/course/devops-oneday/?couponCode=202007
 [10]: https://www.udemy.com/course/docker-practice/?couponCode=202007
 [11]: http://facebook.com/appleboy46
 [12]: https://create-react-app.dev/docs/deployment/
 [13]: https://github.com/features/actions
 [14]: https://aws.amazon.com/tw/ecr/
