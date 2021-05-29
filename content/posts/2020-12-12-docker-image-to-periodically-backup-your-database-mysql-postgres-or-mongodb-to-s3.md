---
title: 用 Docker 每天自動化備份 MySQL, Postgres 或 MongoDB 並上傳到 AWS S3
author: appleboy
type: post
date: 2020-12-12T12:07:50+00:00
url: /2020/12/docker-image-to-periodically-backup-your-database-mysql-postgres-or-mongodb-to-s3/
dsq_thread_id:
  - 8312323184
categories:
  - DevOps
  - Docker
tags:
  - Backup
  - database
  - Docker

---
[![][1]][1]

由於備份 [PostgreSQL][2] 的指令 [pg_dump][3] 需要限定特定版本才可以備份，故自己製作用 [Docker][4] 容器方式來備份，此工具支援 [MySQL][5], PostgreSQL 跟 [MongoDB][6]，只要一個 docker-compose yaml 檔案就可以進行線上的備份，並且上傳到 [AWS S3][7]，另外也可以設定每天晚上固定時間點進行時間備份，也就是平常所設定的 cron job。沒使用 [AWS RDS][8]，或自行管理機房的朋友們，就可以透過這小工具，進行每天半夜線上備份，避免資料被誤砍。底下教學程式碼都可以[在這邊找到][9]。

<!--more-->

## 影片教學

{{< youtube nsiKKSy5fUA >}}

  * [00:00][10] 備份資料庫工具介紹 
  * [00:40][11] 為什麼要寫這工具? 
  * [01:55][12] 架設 Minio S3 Storage 服務 
  * [02:56][13] Minio UI 介面介紹 (建立 bucket) 
  * [03:32][14] 架設 PostgreSQL 12 服務 
  * [04:00][15] 備份方式參數介紹 
  * [07:06][16] 執行備份程式 
  * [09:18][17] 設定 Minio 內的 bucket life cycle (只保留七天內資料) 
  * [10:25][18] 設定每天自動備份並上傳到 Minio S3

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][19]
  * [一天學會 DevOps 自動化測試及部署][20]
  * [DOCKER 容器開發部署實戰][21]

如果需要搭配購買請直接透過 [FB 聯絡我][22]，直接匯款（價格再減 **100**）

## 使用方式

本教學使用 [Minio][23] 來代替 AWS S3，底下用 docker-compose 來架設 Minio 及 PostgreSQL 12 版本

<pre><code class="language-yaml">services:
  minio:
    image: minio/minio:edge
    restart: always
    volumes:
      - data1-1:/data1
    ports:
      - 9000:9000
    environment:
      MINIO_ACCESS_KEY: 1234567890
      MINIO_SECRET_KEY: 1234567890
    command: server /data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  postgres:
    image: postgres:12
    restart: always
    volumes:
      - pg-data:/var/lib/postgresql/data
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    environment:
      POSTGRES_USER: db
      POSTGRES_DB: db
      POSTGRES_PASSWORD: db</code></pre>

接著挑選特定資料庫版本的 Docker Image

<pre><code class="language-yaml">  backup_postgres:
    image: appleboy/docker-backup-database:postgres-12
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    environment:
      STORAGE_DRIVER: s3
      STORAGE_ENDPOINT: minio:9000
      STORAGE_BUCKET: test
      STORAGE_REGION: ap-northeast-1
      STORAGE_PATH: backup_postgres
      STORAGE_SSL: "false"
      STORAGE_INSECURE_SKIP_VERIFY: "false"
      ACCESS_KEY_ID: 1234567890
      SECRET_ACCESS_KEY: 1234567890

      DATABASE_DRIVER: postgres
      DATABASE_HOST: postgres:5432
      DATABASE_USERNAME: db
      DATABASE_PASSWORD: db
      DATABASE_NAME: db
      DATABASE_OPTS:</code></pre>

其中 `STORAGE_BUCKET` 是 AWS S3 的 bucket 名稱，還有需要設定 `STORAGE_PATH` 這樣待會可以設定 bucket lifecycle，可以設定幾天後刪除舊的資料，接著設定 Minio S3 的 bucket lifecycle:

<pre><code class="language-sh">$ mc ilm import minio/test &lt;&lt;EOF
{
    "Rules": [
        {
            "Expiration": {
                "Days": 7
            },
            "ID": "backup_postgres",
            "Filter": {
                "Prefix": "backup_postgres/"
            },
            "Status": "Enabled"
        }
    ]
}
EOF</code></pre>

上面設定是一次性的備份，也就是手動使用 `docker-compose up backup_postgres` 就可以進行一次備份，當然可以固定每天晚上時間來備份

<pre><code class="language-yaml">  backup_mysql:
    image: appleboy/docker-backup-database:mysql-8
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    environment:
      STORAGE_DRIVER: s3
      STORAGE_ENDPOINT: minio:9000
      STORAGE_BUCKET: test
      STORAGE_REGION: ap-northeast-1
      STORAGE_PATH: backup_mysql
      STORAGE_SSL: "false"
      STORAGE_INSECURE_SKIP_VERIFY: "false"
      ACCESS_KEY_ID: 1234567890
      SECRET_ACCESS_KEY: 1234567890

      DATABASE_DRIVER: mysql
      DATABASE_HOST: mysql:3306
      DATABASE_USERNAME: root
      DATABASE_PASSWORD: db
      DATABASE_NAME: db
      DATABASE_OPTS:

      TIME_SCHEDULE: "@daily"
      TIME_LOCATION: Asia/Taipei</code></pre>

`TIME_LOCATION` 可以設定台灣時區，不然預設會是 UTC+0 時間。更多詳細的設定可以[參考文件][9]。

## 心得

由於本身團隊可能沒有使用 AWS RDS 服務，故自己都需要寫程式自行備份，但是同事用的 DB 都不同，所以乾脆包成 Docker 容器方式讓同事可以方便設定。之後有新專案就可以直接套用，相當容易。

 [1]: https://lh3.googleusercontent.com/2SGJ7LZpgVIVuKfhXSgm8fP90GLk7r1jgc4Sm-vAptUx43d28wjbv3r7x6U5BfDmJmfDfTlkhABWU9q20UA5Neg5-CITdqbN-djIeftrhdy2SZde-J2iHQTVdDNh9Ah7MEAzYiYyjDE=w1920-h1080
 [2]: https://www.postgresql.org/
 [3]: https://docs.postgresql.tw/reference/client-applications/pg_dump
 [4]: https://www.docker.com/
 [5]: https://www.mysql.com/
 [6]: https://www.mongodb.com/
 [7]: https://aws.amazon.com/tw/s3/
 [8]: https://aws.amazon.com/tw/rds/
 [9]: https://github.com/appleboy/docker-backup-database
 [10]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=0s
 [11]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=40s
 [12]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=115s
 [13]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=176s
 [14]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=212s
 [15]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=240s
 [16]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=426s
 [17]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=558s
 [18]: https://www.youtube.com/watch?v=nsiKKSy5fUA&t=625s
 [19]: https://www.udemy.com/course/golang-fight/?couponCode=202012
 [20]: https://www.udemy.com/course/devops-oneday/?couponCode=202012
 [21]: https://www.udemy.com/course/docker-practice/?couponCode=202012
 [22]: http://facebook.com/appleboy46
 [23]: https://min.io/
