---
title: Traefik 搭配 Docker 自動更新 Let’s Encrypt 憑證
author: appleboy
type: post
date: 2019-01-20T10:54:20+00:00
url: /2019/01/traefik-docker-and-lets-encrypt/
dsq_thread_id:
  - 7177819679
categories:
  - DevOps
  - Docker
  - Golang
tags:
  - Docker
  - Letsencrypt
  - traefik

---
**2019.10.23 本篇教學以 Traefik 1.7 版本為主**

[![][1]][1]

之前寫過蠻多篇 [Let's Encrypt 的使用教學][2]，但是這次要跟大家介紹一套非常好用的工具 [Traefik][3] 搭配自動化更新 Let's Encrypt 憑證，為什麼會推薦 Traefik 呢，原因在於 Traefik 可以自動偵測 Docker 容器內的 Label 設定，並且套用設定在 Traefik 服務內，也就是只要修改服務的 docker-compose 內容，重新啟動，Traefik 就可以抓到新的設定。這點在其它工具像是 [Nginx][4] 或 [Caddy][5] 是無法做到的。底下我們來一步一步教大家如何設定啟用前後端服務。全部程式碼都放在 [GitHub 上面][6]了。

<!--more-->

## 教學影片

{{< youtube ddJxBXShkZg >}}

## 啟動 Traefik 服務

在啟動 Traefik 服務前，需要建立一個獨立的 Docker 網路，請在 Host 內下

```bash
$ docker network create web
```

接著建立 Traefik 設定檔存放目錄 `/opt/traefik` 此目錄自由命名。

```bash
$ mkdir -p /opt/traefik
```

接著在此目錄底下建立三個檔案

```bash
$ touch /opt/traefik/docker-compose.yml
$ touch /opt/traefik/acme.json && chmod 600 /opt/traefik/acme.json
$ touch /opt/traefik/traefik.toml
```

其中 `docker-compose.yml` 用來啟動 Traefik 服務，`acme.json` 則是存放 Let's Encrypt 的憑證，此檔案權限必須為 `600`，最後則是 traefik 設定檔 `traefik.toml`。一一介紹這些檔案的內容，底下是 `docker-compose.yml`

```yaml
version: '2'

services:
  traefik:
    image: traefik
    restart: always
    ports:
      - 80:80
      - 443:443
    networks:
      - web
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/traefik/traefik.toml:/traefik.toml
      - /opt/traefik/acme.json:/acme.json
    container_name: traefik

networks:
  web:
    external: true
```

此檔案必須要由 `root` 使用者來執行，原因是要 Listen 80 及 443 連接埠，其中 acme.json 及 traefik.toml 則由 host 檔案直接掛載進容器內。接著看 `traefik.toml`

```toml
debug = false

logLevel = "INFO"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  [entryPoints.https.tls]

[acme]
email = "xxxxx@gmail.com"
storage = "acme.json"
entryPoint = "https"
onHostRule = true

[acme.httpChallenge]
entryPoint = "http"

[docker]
endpoint = "unix:///var/run/docker.sock"
watch = true
```

其中 `onHostRule` 用於讀取 docker container 內的 `frontend.rule` 的 `Host` 設定，這樣才可以跟 Let's Encrypt 申請到憑證。最後啟動步驟

```bash
$ cd /opt/traefik
$ docker-compose up -d
```

## 啟動 App 服務

請打開 docker-compose.yml 檔案

```yaml
version: '3'

services:
  app_1:
    image: appleboy/test:alpine
    restart: always
    networks:
      - web
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    labels:
      - "traefik.docker.network=web"
      - "traefik.enable=true"
      - "traefik.basic.frontend.rule=Host:demo1.ggz.tw"
      - "traefik.basic.port=8080"
      - "traefik.basic.protocol=http"

  app_2:
    image: appleboy/test:alpine
    restart: always
    networks:
      - web
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    labels:
      - "traefik.docker.network=web"
      - "traefik.enable=true"
      - "traefik.basic.frontend.rule=Host:demo2.ggz.tw"
      - "traefik.basic.port=8080"
      - "traefik.basic.protocol=http"

networks:
  web:
    external: true
```

可以看到透過 [docker labels][7] 設定讓 traefik 直接讀取並且套用設定。啟動服務後可以看到 `acme.json` 已經存放了各個 host 的憑證資訊，未來只要將此檔案備份，就可以不用一直申請了。最後用 curl 來測試看看

[![][8]][8]

## 心得

由於 Traefik 可以自動讀取 docker label 內容，未來只需要維護 App 的 docker-compose 檔案，對於部署上面相當方便啊，透過底下指令就可以重新啟動容器設定

```bash
$ docker-compose up -d --force-recreate --no-deps app
```

如果對於自動化部署有興趣，可以參考我在 Udemy 上的線上課程

  * [Go 語言實戰][9]
  * [Drone CI/CD 實戰][10]

 [1]: https://lh3.googleusercontent.com/sggr23jjw2BJb3HMIpM9RtSTetm8TeEuk1CCbV6658ZZO5CCwEPK2YdGpOYPFrw4fansfS-aMNE5h-uv-8s7quNiuj4EU-UF0DBaNbKZt3YyNruAICq6JxUss9S5IPAC7TQfQlHbL2M=w1920-h1080
 [2]: https://blog.wu-boy.com/?s=+Let%27s+Encrypt "Let's Encrypt 的使用教學"
 [3]: https://traefik.io/ "Traefik"
 [4]: https://www.nginx.com/ "Nginx"
 [5]: https://caddyserver.com "Caddy"
 [6]: https://github.com/go-training/training/tree/master/example25-traefik-golang-app-lets-encrypt "GitHub 上面"
 [7]: https://docs.docker.com/config/labels-custom-metadata/
 [8]: https://lh3.googleusercontent.com/IbO8svvvbHVwnBmBqt6hqNUs7uSwI9wbf8-lKw2VkVQr_xx41yXg1FmouE91EsuqtYHpJJYQcEHE8vrUptB-Nt1aomG8LYOi-Po1lzu65IFY3tFuBlE_ULpByxbqzQXHe7Kqk6PQx1E=w1920-h1080
 [9]: https://www.udemy.com/golang-fight/?couponCode=GOLANG2019 "Go 語言實戰"
 [10]: https://www.udemy.com/devops-oneday/?couponCode=DRONE "Drone CI/CD 實戰"
