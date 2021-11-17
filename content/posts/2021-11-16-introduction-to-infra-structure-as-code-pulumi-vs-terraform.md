---
title: infrastructure as code 優勢及工具選擇
date: 2021-11-17T08:18:19+08:00
share_img: https://i.imgur.com/Ljxw0ng.png
categories:
  - DevOps
tags:
  - IaC
  - Infrastructure as code
  - pulumi
  - terraform
---

![logo](https://i.imgur.com/Ljxw0ng.png)

今年在 [Cloud Summit](https://cloudsummit.ithome.com.tw/) 會議上分享『[初探 Infrastructure as Code 工具 Pulumi][1]』，主要幾項重點跟大家分享

1. 什麼是 infrastructure as code 簡稱 IaC
2. IaC 對團隊帶來什麼優勢
3. [Pulumi](https://www.pulumi.com/) 及 [Terraform](https://www.terraform.io/) 兩大工具比較
4. Pulumi 價格比較

IaC 帶來的好處跟優勢如下

1. 建置 CI/CD 自動化 (不用依賴 UI 操作)
2. 版本控制 (審核避免錯誤)
3. 重複使用 (減少建置時間)
4. 環境一至性 (測試及正式)
5. 團隊成長 (分享學習資源)

內容會偏向介紹 Pulumi 工具居多，如果想多了解，參考本投影片準沒錯

[1]: https://cloudsummit.ithome.com.tw/2021/speaker-page/69

<!--more-->

## 為什麼選擇 Pulumi

從三大團隊不同的面向帶來的好處

### 工程團隊

1. 可以使用熟悉的語言, 不用學習新語法
2. 模組及跨平台 (AWS, GCP, Azure)
3. 減少複製流程, 自由建立模組清單

### DevOps 團隊

1. Infrastructure as Code (可審核檢視)
2. Multi-Cloud DevOps (用一種方式管理多個雲平台)
3. Deploy Continuously (自動化部署)

### 資安團隊

1. Policy as Code
2. Built-In Secrets (加密特定資料: DB 密碼 ..)
3. Enforce Standards (同一套流程管理系統架構)

## 投影片

{{< speakerdeck id="7e5aad3c22e344d8a0ba78bef5b78c25" >}}
