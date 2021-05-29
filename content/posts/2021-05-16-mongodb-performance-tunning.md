---
title: MongoDB 效能調校紀錄
author: appleboy
type: post
date: 2021-05-16T00:57:45+00:00
url: /2021/05/mongodb-performance-tunning/
dsq_thread_id:
  - 8522418367
categories:
  - sql
tags:
  - database
  - grafana
  - mongodb
  - prometheus

---
[![mongodb][1]][1]

最近剛好在實作 [Prometheus][2] + [Grafana][3] 的時候，對 MongoDB 做了容器 CPU 使用率 (`container_cpu_usage_seconds_total`) 的監控，Metrics 寫法如下:

```bash
sum(
    rate(container_cpu_usage_seconds_total{name!~"(^$|^0_.*)"}[1m]))
by (name)
```

從上面的 Metrics 可以拉長時間來看，會發現專案的 MongoDB 非常不穩定，起起伏伏，這時候就需要來看看資料庫到底哪邊慢，以及看看哪個語法造成 CPU 飆高？

![][4] 

接著為了看 MongoDB 的 Log 紀錄，把 Grafana 推出的 [Loki][5]，也導入專案系統，將容器所有的 Log 都導向 Loki，底下可以看看 docker-compose 將 Log 輸出到 loki

```yaml=
    logging:
      driver: loki
      options:
        loki-url: "http://xxxxxxx/loki/api/v1/push"
        loki-retries: "5"
        loki-batch-size: "400"
        loki-external-labels: "environment=production,project=mongo"
```

![][6] 

先看看結論，做法其實很簡單，找出相對應 Slow Query，把相關的欄位加上 Index，就可以解決了

![][7] 

![][8] 

<!--more-->

## 啟動資料庫 Profiler

MongoDB 預設 Profiler 是關閉的，遇到效能問題，就需要打開，來收集所有的操作記錄 (CRUD)，透過底下指令可以知道目前 MongoDB 的 [Profiler 狀態][9]

```bash=
> db.getProfilingStatus()
{ "was" : 0, "slowms" : 100, "sampleRate" : 1 }
```

可以看到 `was` 為 0 代表沒有啟動

| Level | Description                                                                            |
| ----- | -------------------------------------------------------------------------------------- |
|       | The profiler is off and does not collect any data. This is the default profiler level. |
| 1     | The profiler collects data for operations that take longer than the value of slowms.   |
| 2     | The profiler collects data for all operations.                                         |

這邊先將 Level 設定為 2，或者是只需要看 slow query，那就設定為 1

```bash=
> db.setProfilingLevel(2)
{ "was" : 0, "slowms" : 100, "sampleRate" : 1, "ok" : 1 }
```

如果使用完畢，請將 Profiler 關閉。

## 用 Profiler 分析效能

上一個步驟，Profile 打開後，就可以看到 Mongo 收集一堆 Slow Query Log 了

![][6] 

最後驗證結果就很簡單，只要 Log 量減少及 CPU 使用率下降，就代表成功了，底下介紹幾個好用的分析效能語法。第一直接找目前系統 command 類別內執行時間最久的狀況 (millis: -1 反向排序) 

```bash
db.system.profile.
  find({ op: { $eq: "command" }}).
  sort({ millis: -1 }).
  limit(2).
  pretty();
```

第二可以找執行時間超過 100 ms 的指令。

```bash
db.system.profile.
  find({ millis: { $gt: 100 }}).
  pretty();
```

最後透過 `planSummary` 語法可以找出 query command 掃描 (`COLSCAN`) 整個資料表，代表語法沒有被優化，資料表越大，查詢速度越慢

```bash=
db.system.profile.
  find({ "planSummary": { $eq: "COLLSCAN" }, "op": { $eq: "query" }}).
  sort({ millis: -1 }).
  pretty();
```

或者可以透過 [db.currentOp][10] 觀察現在正在執行中的 Command，底下語法可以針對 `db1` 資料庫查詢執行超過 3 秒鐘的指令

```bash=
db.currentOp(
   {
     "active" : true,
     "secs_running" : { "$gt" : 3 },
     "ns" : /^db1\./
   }
)
```

## 了解 Slow Query

從上面的 Profiler 效能分析指令，可以查詢到哪些 SQL 指令造成系統效能不穩定，這些 SQL 可以透過 `EXPLAIN` 方式找尋到執行效能瓶頸。底下直接透過 explain 方式會產生出 JSON 格式輸出：

```shell=
db.orders.explain("executionStats").find({maID:"bfce30cab12311eba55d09972",maOrderID:"2222318209",deleted:false})
```

透過 [db.collection.explain][10] 可以知道此 Query 在 Mongodb 內是怎麼有效率的執行，底下來看看 [explain][11] 回傳的結果:

```json=
{
  "queryPlanner" : {
    "plannerVersion" : 1,
    "namespace" : "fullinn.orders",
    "indexFilterSet" : false,
    "parsedQuery" : {
      "$and" : [
        {
          "deleted" : {
            "$eq" : false
          }
        },
        {
          "maID" : {
            "$eq" : "bfce30cab12311eba55d09972"
          }
        },
        {
          "maOrderID" : {
            "$eq" : "2222318209"
          }
        }
      ]
    },
    "winningPlan" : {
      "stage" : "COLLSCAN",
      "filter" : {
        "$and" : [
          {
            "deleted" : {
              "$eq" : false
            }
          },
          {
            "maID" : {
              "$eq" : "bfce30cab12311eba55d09972"
            }
          },
          {
            "maOrderID" : {
              "$eq" : "2222318209"
            }
          }
        ]
      },
      "direction" : "forward"
    },
    "rejectedPlans" : [ ]
  },
  "executionStats" : {
    "executionSuccess" : true,
    "nReturned" : 0,
    "executionTimeMillis" : 237,
    "totalKeysExamined" : 0,
    "totalDocsExamined" : 192421,
    "executionStages" : {
      "stage" : "COLLSCAN",
      "filter" : {
        "$and" : [
          {
            "deleted" : {
              "$eq" : false
            }
          },
          {
            "maID" : {
              "$eq" : "bfce30cab12311eba55d09972"
            }
          },
          {
            "maOrderID" : {
              "$eq" : "2222318209"
            }
          }
        ]
      },
      "nReturned" : 0,
      "executionTimeMillisEstimate" : 30,
      "works" : 192423,
      "advanced" : 0,
      "needTime" : 192422,
      "needYield" : 0,
      "saveState" : 192,
      "restoreState" : 192,
      "isEOF" : 1,
      "direction" : "forward",
      "docsExamined" : 192421
    }
  },
  "serverInfo" : {
    "host" : "60b424d18015",
    "port" : 27017,
    "version" : "4.4.4",
    "gitVersion" : "8db30a63db1a9d84bdcad0c83369623f708e0397"
  },
  "ok" : 1
}
```

直接注意到幾個數據，看到 `executionTimeMillis` 執行時間，`totalDocsExamined` 是在執行過程會掃過多少資料 (越低越好)，由上面可以知道此 Query 執行時間是 `237 ms`，並且需要掃過 `192421` 筆資料，另外一個重要指標就是 `executionStages` 內的 `stage`

```json=
    "executionStages" : {
      "stage" : "COLLSCAN",
      "filter" : {
        "$and" : [
          {
            "deleted" : {
              "$eq" : false
            }
          },
          {
            "maID" : {
              "$eq" : "bfce30cab12311eba55d09972"
            }
          },
          {
            "maOrderID" : {
              "$eq" : "2222318209"
            }
          }
        ]
      },
      "nReturned" : 0,
      "executionTimeMillisEstimate" : 30,
      "works" : 192423,
      "advanced" : 0,
      "needTime" : 192422,
      "needYield" : 0,
      "saveState" : 192,
      "restoreState" : 192,
      "isEOF" : 1,
      "direction" : "forward",
      "docsExamined" : 192421
    }
  },
```

Stage 狀態分成底下幾種

  * **COLLSCAN**: for a collection scan
  * **IXSCAN**: for scanning index keys
  * **FETCH**: for retrieving documents
  * **SHARD_MERGE**: for merging results from shards
  * **SHARDING_FILTER**: for filtering out orphan documents from shards

這次我們遇到的就是第一種 `COLLSCAN`，資料表全掃，所以造成效能非常低，這時就要檢查看看是否哪邊增加 Index 可以解決效能問題。底下增加一個 index key 看看結果如何？

```shell=
db.orders.createIndex({maID: 1})
```

接著再執行一次，可以看到底下結果:

```json=
  "executionStats" : {
    "executionSuccess" : true,
    "nReturned" : 0,
    "executionTimeMillis" : 2,
    "totalKeysExamined" : 1,
    "totalDocsExamined" : 1,
    "executionStages" : {
      "stage" : "FETCH",
      "filter" : {
        "$and" : [
          {
            "deleted" : {
              "$eq" : false
            }
          },
          {
            "maOrderID" : {
              "$eq" : "2222318209"
            }
          }
        ]
      },
      "nReturned" : 0,
      "executionTimeMillisEstimate" : 0,
      "works" : 3,
      "advanced" : 0,
      "needTime" : 1,
      "needYield" : 0,
      "saveState" : 0,
      "restoreState" : 0,
      "isEOF" : 1,
      "docsExamined" : 1,
      "alreadyHasObj" : 0,
      "inputStage" : {
        "stage" : "IXSCAN",
        "nReturned" : 1,
        "executionTimeMillisEstimate" : 0,
        "works" : 2,
        "advanced" : 1,
        "needTime" : 0,
        "needYield" : 0,
        "saveState" : 0,
        "restoreState" : 0,
        "isEOF" : 1,
        "keyPattern" : {
          "maID" : 1
        },
        "indexName" : "maID_1",
        "isMultiKey" : false,
        "multiKeyPaths" : {
          "maID" : [ ]
        },
        "isUnique" : false,
        "isSparse" : false,
        "isPartial" : false,
        "indexVersion" : 2,
        "direction" : "forward",
        "indexBounds" : {
          "maID" : [
            "[\"bfce30cab12311eba55d09972\", \"bfce30cab12311eba55d09972\"]"
          ]
        },
        "keysExamined" : 1,
        "seeks" : 1,
        "dupsTested" : 0,
        "dupsDropped" : 0
      }
    }
  },
```

可以看到 `executionTimeMillis` 降低到 2，`totalDocsExamined` 變成 1，用 index 去找就是特別快。inputStage.stage 用的就是 `IXSCAN`。針對上述找尋方式把相對的 index key 補上，並且優化商業邏輯，就可以達到底下結果

![][8] 

相關參考文件:

  * [Single Field Indexes][12]
  * [Database Profiler Output][13]
  * [Database Profiler][14]

 [1]: https://lh3.googleusercontent.com/DZKO3gMs5RhQ0-uGU2Y-uaTsb7HKCJU3lH91uggni5HA-fpDMqgvKPwHRwuo-jlCbAJZYyY9TKKovtCDT7OFgiclb2VYz58HwmDeHUX6FjlwfnuTkaTZxYudTIiuJ6yWsuNu2vs1vTQ=w1920-h1080 "mongodb"
 [2]: https://prometheus.io/
 [3]: https://grafana.com/
 [4]: https://lh3.googleusercontent.com/FbcbJ75SVSEmNb94X6z9JsjkhKmuzjEGUesnTVxwcP2SGYWJpblQaD5ks02brR9kP9HYqP7KpbQAaoa7RUuBWi8EnXdN2eTCzekyGVmKAY4ltnmEnNrWerAzZkHIp9gGKieO71WUhJk=w1920-h1080
 [5]: https://grafana.com/oss/loki/
 [6]: https://lh3.googleusercontent.com/TooE3Q49jzI_FpbjXm4b3A_9aho8J4Qws64XmhVzDVbe6NPMCmgYmuw5bMRwnMgmk_lXxNHDU1n6RXwFGvoZvPxLuM6clRJ_ZGRC9S47rvFbm3k9v6v8qaHhC6vqsFkXENQYlRAqKn0=w1920-h1080
 [7]: https://lh3.googleusercontent.com/WgyOX8OOff6KGKlOvSvoNxzDsPGyiXBwPa_PX3O7L9AYSBfQ9VoNAP5s_HkbmMa7rokTnF--ZLnJ4p6oLqoTCV2Gyq7B696SEbTIrGIi1kDVtijVpZlYTklq3qbLFtpKGAQHeXxHE-Q=w1920-h1080
 [8]: https://lh3.googleusercontent.com/nzKkL7J5x_LmoqTFYav5kKA8Jkp4E4s8OCOekd-fz2HAeU2ySC3DopumqMIevqelMN_bvw7Ug7BB2f6ZJeubCQzz4w1Uby709NqsqTEkQcJK7IwVkcHt_ZkArRjSlKfZvyWBE6ZBLnY=w1920-h1080
 [9]: https://docs.mongodb.com/manual/reference/command/profile/
 [10]: https://docs.mongodb.com/manual/reference/command/profile/#mongodb-dbcommand-dbcmd.profile
 [11]: https://docs.mongodb.com/manual/reference/explain-results/
 [12]: https://docs.mongodb.com/manual/core/index-single/
 [13]: https://docs.mongodb.com/manual/reference/database-profiler/
 [14]: https://docs.mongodb.com/manual/tutorial/manage-the-database-profiler/