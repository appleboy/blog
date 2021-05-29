---
title: 將 Postgres 資料轉換到 CSV 格式
author: appleboy
type: post
date: 2020-06-29T04:12:50+00:00
url: /2020/06/convert-postgres-data-to-csv-file/
dsq_thread_id:
  - 8100222108
categories:
  - Postgres
  - sql
tags:
  - database
  - Postgres

---
[![postgres][1]][2]

時常用到 [Postgres][3] 轉換資料的功能，來即時協助 PM 了解目前使用者實際狀況，底下紀錄常用的指令。首先安裝 Postgres 環境，這邊其實就是用 Docker 方式來啟動一個全新的 Postgres DB。

```yaml
  db:
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
      POSTGRES_PASSWORD: db
```

上面的 `environment` 參數可以自由調整，接著透過 `docker-compose up -d` 來啟動資料庫進行 App 串接。

<!--more-->

## 登入 Postgres

假設 Docker 容器沒有 expos 5432 port 的話，基本上就是要登入到容器內操作，但是如果 expose 出來，那 Host 機器就是要裝 postgres client 套件，才有辦法登入，底下我們直接登入容器內，才不會有 clinet tool 跟 server 版本不一至問題。

```bash
docker-compose exec db /bin/bash
```

其中 `db` 就是在 docker-compose.yml 內的名稱，請自行更換。進入容器內後，再透過 psql 指令來登入 postgres 資料庫

```bash
psql -h 127.0.0.1 -d db -U db -W
```

## 將資料匯出成 CSV 格式

登入進 Postgres 後，透過簡單的指令就可以將單一資料表匯出成 csv 格式

```bash
\COPY some_table TO '/tmp/data.csv' DELIMITER ',' CSV HEADER;
```

如果只是要 table 內幾個欄位，可以改成底下

```bash
\COPY public.user(id, email) TO '/tmp/data.csv' DELIMITER ',' CSV HEADER;
```

或者是要透過 SQL 方式將資料整理過

```bash
\COPY (select id, email from public.user) TO '/data.csv' DELIMITER ',' CSV HEADER;
```

另外可以針對 UTC 時間轉台灣時間

```sql
select state, email, simulator, a.created_at \
  at time zone 'utc' at time zone 'Asia/Taipei' as created_at \
  from public.simulation a join public.user b on a.user_id = b.id  \
  order by a.created_at desc limit 5
```

時間轉換可以參考之前的一篇教學:『[在 PostgreSQL 時區轉換及計算時間][4]』

## 拿出資料

上述資料會存放在容器內的 `/data.csv`，這時候可以透過 docker cp 指令將資料拿出來。透過 `docker ps` 找到 postgres 容器 ID，在執行下面指令

```bash
docker cp container_id:/tmp/data.csv .
```

之後就可以針對上面全部步驟，做自動化處理。

 [1]: https://lh3.googleusercontent.com/vbqq3rLa3xH1e2c1snKm4u0hhkm4mYaT7IRpVBQC22AYa_9xbzuCois2EXQT7-RvZNofhz2TJpz0-Wlfrs870jAn3fyfove-6uF_I8cSe89jI-zmq8BQ2XQS1_hRZJN5587iNVG6pvY=w400 "postgres"
 [2]: https://lh3.googleusercontent.com/vbqq3rLa3xH1e2c1snKm4u0hhkm4mYaT7IRpVBQC22AYa_9xbzuCois2EXQT7-RvZNofhz2TJpz0-Wlfrs870jAn3fyfove-6uF_I8cSe89jI-zmq8BQ2XQS1_hRZJN5587iNVG6pvY=w1920-h1080 "postgres"
 [3]: https://www.postgresql.org/ "Postgres"
 [4]: https://blog.wu-boy.com/2018/09/converting-timestamp-to-timestamp-in-a-specific-time-zone-in-postgres/ "在 PostgreSQL 時區轉換及計算時間"