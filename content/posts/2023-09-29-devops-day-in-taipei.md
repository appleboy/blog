---
title: "初探輕量級 DevOps 平台: Gitea - 台北 DevOpsDay"
date: 2023-09-29T12:02:40+08:00
author: appleboy
type: post
slug: introduction-to-gitea-devops-platform
share_img: https://lh3.googleusercontent.com/SrQvhDJm5NMkrxrut0lACspnz6iQSFCX3vlbtGCuAcwO-i_4iJCJ6trK3V2F6Q6s6fQ_EcSglwAL0qO0aLaTRtk4Ca32EI7Ks1H7u_nI9jC6xn3PF9hhgccjkbN3irX5pGi9kV-vIxk=w1920-h1080
categories:
- devopsday
- mlops
- devops
---

![logo](https://lh3.googleusercontent.com/SrQvhDJm5NMkrxrut0lACspnz6iQSFCX3vlbtGCuAcwO-i_4iJCJ6trK3V2F6Q6s6fQ_EcSglwAL0qO0aLaTRtk4Ca32EI7Ks1H7u_nI9jC6xn3PF9hhgccjkbN3irX5pGi9kV-vIxk=w1920-h1080)

今年非常幸運可以在台北 [DevOpsDay][3] 給一場『[輕量級 DevOps 平台: Gitea Platform][1]』，這次分享主要是介紹輕量級 DevOps 平台，並且改善開發流程，讓開發者可以更快速的部署到生產環境。如果你使用過 [GitHub Actions][5]，那 Gitea DevOps 平台你一定不要錯過。Gitea 團隊在 2022 年底開始打造讓 [Gitea][4] 可以像是 GitHub 一樣使用 GitHub Actions，詳細的內容可以參考[這篇文章][2]。底下讓我們來看看怎麼使用 Gitea DevOps 平台。

[1]:https://devopsdays.tw/2023/session-page/2366
[2]:https://blog.gitea.com/hacking-on-gitea-actions/
[3]:https://devopsdays.tw/
[4]:https://gitea.com/
[5]:https://github.com/features/actions

<!--more-->

## 安裝 Gitea 平台

這邊我們使用 Docker 安裝，如果你沒有安裝 Docker，可以參考[這篇文章][6]。底下是安裝 Gitea 的 Docker Compose 檔案。另外也可以參考[官方安裝文件][7]。首先建立目錄結構如下

```bash
mkdir -p gitea/{data,config}
cd gitea
touch docker-compose.yml
chown 1000:1000 config/ data/
# or chmod 777 config/ data/
```

打開 `docker-compose.yml` 檔案，輸入以下內容

```yaml
version: "2"

services:
  server:
    image: gitea/gitea:1.20-rootless
    restart: always
    volumes:
      - ./data:/var/lib/gitea
      - ./config:/etc/gitea
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"
      - "2222:2222"
```

接著執行 `docker-compose up -d` 指令，等待 Gitea 安裝完成後，打開瀏覽器輸入 `http://localhost:3000`，會看到安裝畫面。

![installation](/images/2023-09-29/installation.png)

接著輸入資料庫資訊，這邊我們使用 SQLite 資料庫，所以不需要輸入任何資料。只需要設定 Administator 帳號密碼即可。

![optional setting](/images/2023-09-29/optional-setting.png)

[6]:https://docs.docker.com/engine/install/ubuntu/
[7]:https://docs.gitea.com/next/installation/install-with-docker-rootless

## 啟用 Gitea Actions

從 Gitea 1.19 版本開始，Gitea Actions 就已經內建在 Gitea 服務中。請打開 `config/app.ini` 檔案，並增加底下設定

```ini
[actions]
ENABLED = true
```

接著重新啟動 Gitea 服務

```bash
docker compose restart
```

請點選右上角個人照片，並點選 `Site Administration`，接著點選 Runner Tab 選單

![site setting](/images/2023-09-29/site-setting.png)

看到上述畫面後，就可以開始進行 Gitea Action Runner 安裝。

## 安裝 Gitea Action Runner

透過 docker compose 來啟動 runner 服務，先建立 gitea 資料夾，並建立 docker-compose.yml 檔案

```bash
mkdir -p runner/data
cd runner
touch docker-compose.yml
sudo chown 1000:1000 data/
```

打開 `docker-compose.yml` 檔案，輸入以下內容

```yaml
version: "2"

services:
  runner:
    image: gitea/act_runner:0.2.6
    restart: always
    volumes:
      - ./data/act_runner:/data
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - GITEA_INSTANCE_URL=<instance url>
      - GITEA_RUNNER_REGISTRATION_TOKEN=<registration token>
```

其中 `<instance url>` 請填入 Gitea 服務的網址，例如 `http://your_host:3000`，`<registration token>` 請點選右上角個人照片，並點選 `Site Administration`，接著點選 Runner Tab 選單，複製 `Registration Token`。

![runner list](/images/2023-09-29/runner-list.png)

## 建立 Gitea Action

由於目前 Repository 預設設定都是關閉的，故需要手動開啟。請打開 Repository，點選 `Settings`，看到左邊選單 Repository，看到右邊設定內找到 `Enable Repository Action` 點選打勾，最後按下儲存即可。

![enable-action](/images/2023-09-29/enable-action.png)

請在專案底下建立 `.github/workflows` 資料夾，並打開 `main.yml` 檔案

```yaml
name: CI
on: [push]
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: echo hello world
        run: |
          echo "hello world"
```

接著 Commit 檔案，並 Push 到 Gitea 服務，可以看到 Actions 已經啟動。
