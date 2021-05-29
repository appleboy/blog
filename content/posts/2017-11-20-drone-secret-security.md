---
title: Drone Secret 安全性管理
author: appleboy
type: post
date: 2017-11-20T01:34:14+00:00
url: /2017/11/drone-secret-security/
dsq_thread_id:
  - 6296083709
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - Drone.io

---
[<img src="https://i1.wp.com/c1.staticflickr.com/5/4236/34957940160_435d83114f_z.jpg?w=840&#038;ssl=1" alt="drone-logo_512" data-recalc-dims="1" />][1]

[Drone][2] 是一套以 [Docker 容器][3]技術為主的 [CI/CD][4] 開源專案，來聊聊 Drone 如何管理專案內的 Secret 資料，首先先來定義什麼是 Secret，舉個簡單例子，Drone 可以輕易完成基本打包+上傳到遠端伺服器，過程中一定會需要用到兩個 Plugin，就是 [drone-scp][5] 及 [drone-ssh][6]，而使用這兩個 plugin 需要有一組 Password 或是一把金鑰 (Public Key Authentication)，在 Drone 可以透過後台 UI 介面將密碼或者是金鑰內容儲存在 Secret 設定頁面。預覽圖如下:

[<img src="https://i1.wp.com/farm5.staticflickr.com/4561/24659201508_1517253288_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2017-11-20 at 9.10.10 AM" data-recalc-dims="1" />][7]

<!--more-->

## 安全性?

但是透過 Drone 後台新增的 Secret 資料不是很安全，因為每個 Steps 都可以直接存取 Secret 資料。

```yml
pipeline:
  test1:
    image: mhart/alpine-node:9.1.0
    group: testing
    secrets: [ test46 ]
    commands:
      - echo "node.js"
      - echo $TEST46

  test2:
    image: appleboy/golang-testing
    group: testing
    secrets: [ test46, readme ]
    commands:
      - echo "golang"
      - echo $TEST46
      - echo $README
```

從上面可以得知，透過 `appleboy/golang-testing` 或 `mhart/alpine-node:9.1.0` 都可以存取 `test46` 變數，這樣哪裡不安全？答案是，假設今天服務的是開源專案，這樣別人是不是可以發個 PR，內容新增一個步驟，將變數內容直接印出來即可。當然你可以把 Drone 的頁面關閉，只有管理者可以存取，但是這樣就失去開源專案的意義，因為貢獻者總該需要看到哪裡編譯錯誤，或者是測試失敗的地方。

## 透過 drone cli 管理

要解決安全性問題，必須要將 Secret 變數綁定只有**特定 Image** 才可以存取。而要做到此功能只能透過 [drone cli][8] 工具才可以完成。該如何使用 drone secret 指令呢？其實不會很難，drone cli 可以做的比 Web UI 還強大。所以關於 Secret 部分，我幾乎都是用 cli 來管理

```bash
$ drone secret -h
NAME:
   drone secret - manage secrets

USAGE:
   drone secret command [command options] [arguments...]

COMMANDS:
     add     adds a secret
     rm      remove a secret
     update  update a secret
     info    display secret info
     ls      list secrets

OPTIONS:
   --help, -h  show help
```

先假設 `ssh-password` 變數需要綁定在 `appleboy/drone-ssh` 映像檔上面，該如何下指令:

```bash
$ drone secret add \
  --name ssh-password \
  --value 1234567890 \
  --image appleboy/drone-ssh \
  --repository go-training/drone-workshop
```

上述例子可以用在存密碼欄位，如果是想存`檔案`類型呢？也就是把金鑰 `public.pem` 給存進變數。這邊可以透過 `@檔案路徑` 的方式來存取該檔案，並且直接寫入到 Drone 資料庫。注意只要是 `@` 開頭，後面就必須接實體檔案路徑。

```bash
$ drone secret add \
  --name ssh-key \
  --value @/etc/server.pem \
  --image appleboy/drone-ssh \
  --repository go-training/drone-workshop
```

## 心得

將 Drone 安裝在公司內部，又想要防止團隊成員直接拿到 Pem 資料，就必須透過 drone cli 工具來達成此功能，否則當同事可以輕易拿到這把 Key 時，就可以隨時登入機器惡搞。如果你拿 Drone 管理開源專案，更是要這麼做了。上述教學，我已經錄製成影片檔放在 [Udemy 線上課程][9]，如果已經購買的朋友們，可以直接看線上教學。

 [1]: https://www.flickr.com/photos/appleboy/34957940160/in/dateposted-public/ "drone-logo_512"
 [2]: https://github.com/drone/drone
 [3]: https://www.docker.com/what-container
 [4]: https://www.docker.com/use-cases/cicd
 [5]: https://github.com/appleboy/drone-scp
 [6]: https://github.com/appleboy/drone-ssh
 [7]: https://www.flickr.com/photos/appleboy/24659201508/in/dateposted-public/ "Screen Shot 2017-11-20 at 9.10.10 AM"
 [8]: https://github.com/drone/drone-cli
 [9]: https://www.udemy.com/devops-oneday/?couponCode=KUBERNETES