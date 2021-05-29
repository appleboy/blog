---
title: 使用 Docker 五分鐘安裝好 Gitea (自架 Git Hosting 最佳選擇)
author: appleboy
type: post
date: 2020-02-15T02:25:58+00:00
url: /2020/02/install-gitea-using-docker/
dsq_thread_id:
  - 7871353483
categories:
  - Docker
  - Git
tags:
  - Docker
  - gitea

---
> 新課程上架:『[Docker 容器實用實戰][1]』目前特價 **$800 TWD**，優惠代碼『**20200222**』，也可以直接匯款（價格再減 **100**），如果想搭配另外兩門課程合購可以透過 [FB 聯絡我][2]

[![Gitea][3]][3]

[Gitea][4] 在本週發佈了 [1.11.0 版本][5]，本篇就使用 Docker 方式來安裝 Gitea，執行時間不會超過五分鐘。Gitea 是一套開源的 Git Hosting，除了 Gitea 之外，您可以選擇 GitHub 或自行安裝 GitLab，但是我為什麼選擇 Gitea 呢？原因有底下幾點

  1. Gitea 是[開源專案][6]，全世界的開發者都可以進行貢獻
  2. Gitea 是 [Go 語言][7]所開發，啟動速度超快
  3. Gitea 開源社區非常完整，每年固定挑選三位為主要負責人
  4. Gitea 可以使用執行檔或 Docker 方式進行安裝

Gitea 目前發展方向就是自己服務自己，大家可能有發現原本在 GitHub 上面的 Repository 已經全面轉到 [Gitea 自主服務][8]了，這也代表著未來會全面轉過去，只是時間上的問題。Gitea 目前的功能其實相當完整，大家有興趣可以看這張[比較表][9]，新創團隊我都強烈建議使用 Gitea。

<!--more-->

## 教學影片

{{< youtube O3zmiIUKfXQ >}}

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][10]
  * [一天學會 DevOps 自動化測試及部署][11]
  * [DOCKER 容器開發部署實戰][12] (課程剛啟動，限時特價 $800 TWD)

## 安裝方式

透過 docker-compose 方式安裝會是最快的，大家可以參考[此 Repository][13]

```yaml
version: "2"

networks:
  gitea:
    external: false

services:
  server:
    image: gitea/gitea:1.11.0
    environment:
      - USER_UID=${USER_UID}
      - USER_GID=${USER_GID}
      - SSH_PORT=2000
      - DISABLE_SSH=true
      - DB_TYPE=mysql
      - DB_HOST=db:3306
      - DB_NAME=gitea
      - DB_USER=gitea
      - DB_PASSWD=gitea
    restart: always
    networks:
      - gitea
    volumes:
      - gitea:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "4000:3000"
      - "2000:22"

  db:
    image: mysql:5.7
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=gitea
      - MYSQL_USER=gitea
      - MYSQL_PASSWORD=gitea
      - MYSQL_DATABASE=gitea
    networks:
      - gitea
    volumes:
      - mysql:/var/lib/mysql

volumes:
  gitea:
    driver: local
  mysql:
    driver: local
```

由上面可以看到只有啟動 Gitea + MySQL 服務就完成了，啟動時間根本不用 10 秒鐘，打開瀏覽器就可以看到安裝畫面了。

 [1]: https://www.udemy.com/course/docker-practice/?couponCode=20200222 "Docker 容器實用實戰"
 [2]: http://facebook.com/appleboy46
 [3]: https://lh3.googleusercontent.com/SrQvhDJm5NMkrxrut0lACspnz6iQSFCX3vlbtGCuAcwO-i_4iJCJ6trK3V2F6Q6s6fQ_EcSglwAL0qO0aLaTRtk4Ca32EI7Ks1H7u_nI9jC6xn3PF9hhgccjkbN3irX5pGi9kV-vIxk=w1920-h1080 "Gitea"
 [4]: https://gitea.io
 [5]: https://blog.gitea.io/2020/02/gitea-1.11.0-is-released/
 [6]: https://github.com/go-gitea/gitea
 [7]: https://golang.org
 [8]: https://gitea.com/gitea
 [9]: https://docs.gitea.io/en-us/comparison/
 [10]: https://www.udemy.com/course/golang-fight/?couponCode=202002
 [11]: https://www.udemy.com/course/devops-oneday/?couponCode=202002
 [12]: https://www.udemy.com/course/docker-practice/?couponCode=20200219
 [13]: https://github.com/go-training/gitea-docker
