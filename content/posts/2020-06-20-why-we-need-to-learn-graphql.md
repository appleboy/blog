---
title: 為什麼要學 GraphQL?
author: appleboy
type: post
date: 2020-06-20T04:57:38+00:00
url: /2020/06/why-we-need-to-learn-graphql/
dsq_thread_id:
  - 8085920699
categories:
  - GraphQL
tags:
  - GraphQL

---
[![][1]][1]

身為網站工程師，您不能不知道什麼是 [GraphQL][2]，這是一個前端跟後端溝通的 API Query 語法，大幅改善了前後端的合作模式，這篇會跟大家介紹為什麼麼要學 GraphQL，以及整理出三大 GraphQL 優勢，讓大家了解跟傳統 RESTful API 有什麼不同。當然不是叫開發者捨棄 RESTful API，而是根據專案的不同，來決定不同的技術 Stack。像是服務跟服務之前您說要用 GraphQL，肯定被打槍，而是要用更輕量的 RESTful API 或 [gRPC][3]。好了，底下來說明三點 GraphQL 的優勢。

<!--more-->

## 教學影片

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][4]
  * [一天學會 DevOps 自動化測試及部署][5]
  * [DOCKER 容器開發部署實戰][6]

如果需要搭配購買請直接透過 [FB 聯絡我][7]，直接匯款（價格再減 **100**）

## 1. 一次連線拿回前端所需資料

[![graphql][8]][8]

從上面的圖可以看到，要完成這頁面需要兩次 Request 才可以拿回全部資料，也就是需要兩次 connection。但是在 GraphQL 可以直接將 Query 語法寫在一起送到後端，後端全部處理完成後再一次回給前端

<pre><code class="language-bash">query {
  blog (
    id: 10
  ) {
    title
    post
    createdAt
    updatedAt
    user {
      id
      email
      username
    }
  }
  me {
    username
    email
  }
}</code></pre>

用上面的語法就可以直接拿到全部資料，大幅降低 connection 次數。

## 2. 根據不同畫面拿不同欄位資料

在 RESTful API 世界裡，後端會一次回傳所有資料，不會管前端需不需要這欄位，也就是前端沒有權力決定該拿什麼欄位，這樣會造成很多不必要的網路傳輸。一樣拿底下圖來說明

[![graphql][8]][8]

在右上角前端只需要使用者的個人頭像 + email 好了，但是後端 API 卻回給前端 10 個欄位，但是真正只需要兩個欄位，其他 8 個都是多餘的，這邊在 RESTful API 也可以根據不同畫面回不同的欄位資訊，卻造成後端很大的負擔。這時候用 GraphQL 解決了此問題，只要在 Query 語法內定義好要拿的資料即可

<pre><code class="language-bash">query {
  me {
    username
    email
    firstName
    lastName
  }
}</code></pre>

## 3. 即時 API 文件

大家應該都知道文件沒有一天是即時更新的，寫 RESTful API 要求後端也補上文件，簡直是難上加難，專案在趕的時候，誰還在管文件有沒有到最新，這邊就要推薦 GraphQL 了，因為只要程式碼一動，開發者透過 Client 工具就可以即時知道現在的 API 文件。

[![graphql][9]][9]

## 心得

以上三點是我認為 GraphQL 相較 RESTful API 的三大優勢，大家可以根據不同的專案屬性來決定是否要用 GraphQL，而只要是您在 Web 開發領域，就一定要知道 GraphQL 的這三大好處。

 [1]: https://lh3.googleusercontent.com/2N2CsbTrA9I78S376IqY4LYiw02t8a6xNwO96lZG3CAENy4bSX8dRFrdFYxQnmIesEjLBQoG1tccIjKF944I7M91-POoYrHhHOS6kgiuKt39QuTI5zZ9NSAjbCrQYmktjct3YZfiJ4I=w1920-h1080
 [2]: https://graphql.org/
 [3]: https://grpc.io/
 [4]: https://www.udemy.com/course/golang-fight/?couponCode=202006
 [5]: https://www.udemy.com/course/devops-oneday/?couponCode=202006
 [6]: https://www.udemy.com/course/docker-practice/?couponCode=202006
 [7]: http://facebook.com/appleboy46
 [8]: https://lh3.googleusercontent.com/mo43jp7WcXtcc5e69fIZnoooiLEpicPHGHUookRAy-tEbD_oXMI4PWYIoj8b9bUeiAWSTGFDBvcrK5b1U9v1LQQTVX3R_J2jgqDICksucKn_XvokhIdymMLyoIAKbxyEa3OI6XQfmc4=w1920-h1080 "graphql"
 [9]: https://lh3.googleusercontent.com/2x1n9mP0lov4WyQWaO8P3ieDWJqCnua0lOgc0DnmTOMbLrp-eedZhWqdNbZhORfyw6oGcMul29OMq7_S8p-YPpgqYe2LvTrYEKH6PnL7dQAlMhdwOuYaadK3NAfCAgScC8M7uFOQatQ=w1920-h1080 "graphql"