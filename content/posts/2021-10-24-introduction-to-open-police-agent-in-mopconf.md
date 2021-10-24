---
title: "Introduction to Open Policy Agent 初探權限控管機制"
date: 2021-10-24T11:39:20+08:00
author: appleboy
type: post
url: /2021/10/introduction-to-open-police-agent-in-mopconf
share_img: https://lh3.googleusercontent.com/qLGheyjm3eVL-TRP_MT1X9j2QrNrtIIAlVPmLbvNGWcLkqfUTpH87D2GCzYmce8eU88oMF-82lSqT6DwOByPWEKVZP4nGWT-IZFDvpVwnil2AeXZaYxZN5J33IpfsYfP6mljV3S51R4=w1920-h1080
categories:
  - Golang
tags:
  - golang
  - open policy agent
---

![logo](https://lh3.googleusercontent.com/qLGheyjm3eVL-TRP_MT1X9j2QrNrtIIAlVPmLbvNGWcLkqfUTpH87D2GCzYmce8eU88oMF-82lSqT6DwOByPWEKVZP4nGWT-IZFDvpVwnil2AeXZaYxZN5J33IpfsYfP6mljV3S51R4=w1920-h1080)

很高興可以在 [Mopconf](https://mopcon.org/2021/) 分享 [Open Policy Agent][1]。本議程最主要是跟大家初步分享 OPA 的概念，我們團隊如何將 OPA 導入系統架構，及分享如何設計 RBAC 及 [IAM Role][13] 架構，底下是這次預計會分享的內容:

1. Why do we need a Policy Engine?
2. Why do we choose Open Policy Agent?
3. Workflow with Open Policy Agent?
4. What is Policy Language (Rego)?
5. RBAC and IAM Role Design
6. Three ways to deploy an Open Policy Agent.

可以參考另外兩篇介紹

* [初探 Open Policy Agent 實作 RBAC (Role-based access control) 權限控管][11]
* [使用 RESTful API 串接 Open Policy Agent][12]

如果可以的話，大家可以給我一些回饋，請填寫[會後問卷](https://docs.google.com/forms/d/e/1FAIpQLSfRuK40O1j5KIPHt6RQyY3Au77bW91kgGIEGOrNxsjxHUSwgA/viewform)

[11]:https://blog.wu-boy.com/2021/04/setup-rbac-role-based-access-control-using-open-policy-agent/
[12]:https://blog.wu-boy.com/2021/05/comunicate-with-open-policy-agent-using-resful-api/
[13]:https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html

<!--more-->

## 投影片

{{< speakerdeck id="9cfef3dc602c41ee93215b3c05d4f5a8" >}}

## 教學影片

{{< youtube BMLBv9ZUbPM >}}

影片視頻會同步放到底下課程內

* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

[1]:https://www.openpolicyagent.org/

## 現場提問

底下是在 Youtube 直播時候，大家的討論，相當熱烈

```sh
Yu-Ting Lin: ​我第一次知道 Policy Agent ，我之前都自幹Orz
SiegeLeo: ​自幹+1 但多層級權限繼承不好搞
Bo-Yi Wu: ​看情境，有些簡易的系統，也沒在用這套，我用這套目的是因為 Group 權限太複雜，加上要串其他系統
Bo-Yi Wu: ​另外我也推薦 https://github.com/casbin/casbin
kevin31408: ​權限系統不是應該是
kevin31408: ​每個都不一樣?
Bo-Yi Wu: ​每個都不一樣？
MOPCON: ​有問題歡迎到 Slido 提問：https://app.sli.do/event/8dj78nnl 呦～
kevin31408: ​就是每個專案不一樣
kevin31408: ​應該這樣說
Bo-Yi Wu: ​如果有用了 OPA，幾本上就是透過此 Service
Bo-Yi Wu: ​用 OPA 掛在整個 RESTful 或 GraphlQL 前面的 Middleware
kevin31408: ​所以這個service就可以通用?
Bo-Yi Wu: ​你想像他可以寫成一個簡易的 Restful API Service
Bo-Yi Wu: ​你可以把 input + data 丟給 OPA API，回傳 Ture 或 False
J Cyuan: ​感覺 是開個接口 給各個不同需求去實作 驗證和資料面 其他架構 用OPA 不知道這樣理解正確嗎?
Bo-Yi Wu: ​你可以把 OPA 想成他就是專門做權限驗證的 API Service，其他 service 就是把 Input + Data 丟給 OPA，他會根據你的 input + data 來決定此 input 是否可以通過權限
李冠廷: ​目前碰到的權限管理都是 case by case
Bo-Yi Wu: ​不一定每一種情境都需要用到 OPA，而是把一些共同的權限，或較複雜的權限控管，交由 OPA 進行 Policy 的設計，可以減少你在服務內撰寫權限的邏輯。
李冠廷: ​最麻煩的還是在建立權限邏輯的部分，這邊就像是 Policy Rule
Bo-Yi Wu: ​是的，你用 OPA Policy Rule 可以減少你在跨平台的權限控管
Bo-Yi Wu: ​就像你的服務有 Node.js 或 Golang，但是需要共同的權限控管判斷機制，那不可能兩邊都開發一次吧？這時候 OPA 這服務就很重要
李冠廷: ​恩恩，沒錯
陳少康: ​Testing 應該算獨立對吧
Bo-Yi Wu: ​包康可看一下 https://github.com/go-training/opa-demo
kevin31408: ​講的很棒
SiegeLeo: ​每call一次restful api 就把要一大包{input, user_data} 餵給 OPA 確認嗎?
陳少康: ​washhands
SiegeLeo: ​yougotthis
SiegeLeo: ​謝謝講者分享
Mick Hsieh: ​謝謝分享
MOPCON: ​感謝大家的參與，Bo-Yi Wu 的 初探 Open Policy Agent 實作權限控管 議程即將結束。歡迎到 Discord Q&A 區跟講者繼續交流 🙌🏼Discord：https://discord.gg/6ykDqsmBVt頻道名稱：R3 Q&A 區也別忘了幫我們填寫議程問卷，抽小禮物唷！👉 議程問卷：https://forms.gle/qeZE9ir8ByqxrNtu9
Jessie Cheng: ​謝謝分享
Bo-Yi Wu: ​input 通常不會很大包，如果是 Data 先過濾，在餵給 OPA 這樣比較適合
Bo-Yi Wu: ​這樣說好了，平常我們在實作權限，也都是要整理 input + data，而中間的邏輯判斷部分，就是抽出來雪成 police rule。
```

## 實作範例

* [opa testing demo](https://github.com/go-training/opa-demo)
* [opa RESTful API](https://github.com/go-training/opa-restful)
* [opa embed in Golang](https://github.com/go-training/opa-embed)
