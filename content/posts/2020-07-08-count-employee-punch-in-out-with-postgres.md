---
title: 用 Postgres 計算員工上下班紀錄
author: appleboy
type: post
date: 2020-07-08T05:51:39+00:00
url: /2020/07/count-employee-punch-in-out-with-postgres/
dsq_thread_id:
  - 8115302088
categories:
  - Postgres
tags:
  - Postgres

---
[![postgres][1]][2]

這應該算是一個蠻簡單的情境，公司都需要去紀錄每位員工上下班紀錄，或者是紀錄每天刷卡補助餐點，在一定的時間內刷卡才會進行公司補助，非在約定的時間點刷卡則不補助，底下看看公司可能會想要的表格紀錄。在後台頁面會進行時間區域的選擇。

> 起始日期: 2020-06-01 結束日期: 2020-06-30 早上時間: 08:00 ~ 09:00 晚上時間: 18:00 ~ 19:00

<!--more-->

建立表格來紀錄，其中 `test` 為 [Postgres][3] 的 [Schema][4]

```sql
CREATE TABLE "test"."workshift" (
    "id" int8 NOT NULL DEFAULT nextval('workshift_id_seq'::regclass),
    "company_id" int8,
    "employee_id" int8,
    "recorded_at" timestamp NOT NULL,
    "created_at" timestamp,
    "updated_at" timestamp,
    PRIMARY KEY ("id")
);
```

其中 `recorded_at` 是員工刷卡傳送上來的時間，本篇會介紹兩種情境的寫法，用來分別紀錄每個月各別員工刷卡次數，以及單月每天員工刷卡總次數。

## 員工刷卡次數

輸出的表格如下

| Employee ID | Name     | Breakfast | Dinner |
| ----------- | -------- | --------- | ------ |
| 1234        | Mr. Wang | 1         |        |
| 4567        | Mr. Lee  |           | 1      |

底下會用 postgres 內的 `CASE WHEN` 語法

```sql
SELECT
    employee_id,
    sum(
        CASE WHEN to_char(recorded_at, 'hh24:mi') >= '07:00'
            AND to_char(recorded_at, 'hh24:mi') < '09:00' THEN
            1
        ELSE
            0
        END) AS breakfast_count,
    sum(
        CASE WHEN to_char(recorded_at, 'hh24:mi') >= '18:00'
            AND to_char(recorded_at, 'hh24:mi') < '19:00' THEN
            1
        ELSE
            0
        END) AS dinner_count
FROM
    "public"."workshift"
WHERE
    workshift.company_id = 1
    AND recorded_at BETWEEN '2020-07-01T00:00:00Z'
    AND '2020-07-30T00:00:00Z'
GROUP BY
    employee_id
ORDER BY
    employee_id DESC
LIMIT 50
```

## 單月統計每天資料

另一種情境會是紀錄每天有多少刷卡紀錄，來計算補助金額。輸出的結果如下:

| Day        | Breakfast | Dinner |
| ---------- | --------- | ------ |
| 2020-07-01 | 1         | 4      |
| 2020-07-02 | 3         | 1      |

SQL 語法如下

```sql
SELECT
    to_char(recorded_at, 'YYYY-MM-DD') AS day_of_month,
    sum(
        CASE WHEN to_char(recorded_at, 'hh24:mi') >= '07:00'
            AND to_char(recorded_at, 'hh24:mi') < '09:00' THEN
            1
        ELSE
            0
        END) AS breakfast_count,
    sum(
        CASE WHEN to_char(recorded_at, 'hh24:mi') >= '18:00'
            AND to_char(recorded_at, 'hh24:mi') < '19:00' THEN
            1
        ELSE
            0
        END) AS dinner_count
FROM
    "public"."workshift"
WHERE
    workshift.company_id = 1
    AND recorded_at BETWEEN '2020-07-01T00:00:00Z'
    AND '2020-07-31T00:00:00Z'
GROUP BY
    day_of_month
ORDER BY
    day_of_month DESC
LIMIT 50
```

比較不一樣的地方是，透過 `to_char` 函式來取的每一天時間來計算所有員工刷卡次數來結算金額。搭配 GraphQL 語法搜尋會是

```graphql
query {
  reports(
    category: Day
    timeRange: {
      startTime: "2020-07-01T00:00:00Z"
      endTime: "2020-07-10T00:00:00Z"
    }
    breakfastTime: {
      startTime: "07:00"
      endTime: "09:00"
    }
    lunchTime: {
      startTime: "12:00"
      endTime: "13:00"
    }
    dinnerTime: {
      startTime: "18:00"
      endTime: "19:00"
    }
  ) {
    totalCount
    nodes {
      date
      employee {
        uid
        name
      }
      breakfastCount
      lunchCount
      dinnerCount
    }
  }
}
```

由於是寫 RAW SQL，如果有使用 [ORM][5] 套件，要注意 [SQL Injection][6] 部分。歡迎大家提供更好的寫法或 DB 結構。

 [1]: https://lh3.googleusercontent.com/vbqq3rLa3xH1e2c1snKm4u0hhkm4mYaT7IRpVBQC22AYa_9xbzuCois2EXQT7-RvZNofhz2TJpz0-Wlfrs870jAn3fyfove-6uF_I8cSe89jI-zmq8BQ2XQS1_hRZJN5587iNVG6pvY=w400 "postgres"
 [2]: https://lh3.googleusercontent.com/vbqq3rLa3xH1e2c1snKm4u0hhkm4mYaT7IRpVBQC22AYa_9xbzuCois2EXQT7-RvZNofhz2TJpz0-Wlfrs870jAn3fyfove-6uF_I8cSe89jI-zmq8BQ2XQS1_hRZJN5587iNVG6pvY=w1920-h1080 "postgres"
 [3]: https://www.postgresql.org/
 [4]: https://www.postgresql.org/docs/current/ddl-schemas.html
 [5]: https://en.wikipedia.org/wiki/Object-relational_mapping
 [6]: https://en.wikipedia.org/wiki/SQL_injection