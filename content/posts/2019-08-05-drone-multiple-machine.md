---
title: '[Drone] 將單一 Job 分配到多台機器，降低部署執行時間'
author: appleboy
type: post
date: 2019-08-05T05:40:22+00:00
url: /2019/08/drone-multiple-machine/
dsq_thread_id:
  - 7570999425
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - drone ci

---
[![drone multiple machine][1]][1]

在傳統 CI/CD 流程，都是會在同一台機器上進行，所以當有一個 Job 吃了很大的資源時，其他工作都必須等待該 Job 執行完畢，釋放出資源後，才可以繼續進行。現在 Drone 推出一個新功能，叫做 [Multiple Machine][2] 機制，現在開發者可以將同一個 Job 內，拆成很多步驟，將不同的步驟丟到不同機器上面去執行，降低部署執行時間，假設現在有兩台機器 A 及 B，你可以將前端的測試丟到 A 機器，後端的測試，丟到 B 機器，來達到平行處理，並且享受兩台機器的資源，在沒有這機制之前，只能在單一機器上面跑平行處理，沒有享受到多台機器的好處。

<!--more-->

## 影片介紹

{{< youtube IRf9yyaHQ5I >}}

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 實際範例

底下來看看如何將前端及後端的工作拆成兩台機器去跑:

```yaml
kind: pipeline
name: frontend

steps:
- name: build
  image: node
  commands:
  - npm install
  - npm test

---
kind: pipeline
name: backend

steps:
- name: build
  image: golang
  commands:
  - go build
  - go test

services:
- name: redis
  image: redis
```

簡單設定兩個不同的 pipeline，就可以將兩條 pipeline 流程丟到不同機器上面執行。上述平行執行後，可以透過 `depends_on` 來等到上述兩個流程跑完，再執行。

```yaml
---
kind: pipeline
name: after

steps:
- name: notify
  image: plugins/slack
  settings:
    room: general
    webhook: https://...

depends_on:
- frontend
- backend
```

 [1]: https://lh3.googleusercontent.com/q2Z5tLXdw_GINCveZ4860CTUhfnJtrhdSuWt4VItXWggiPnKqc0sI_0lvxz4lfB4v-MoCPNW50H16QwzQUzOwuIfgug6fvwemQme0Km9c9UeEdCYL2cZzHuK7lhZ4lMClDZ07CBVLiM=w1920-h1080 "drone multiple machine"
 [2]: https://docs.drone.io/user-guide/pipeline/multi-machine/
