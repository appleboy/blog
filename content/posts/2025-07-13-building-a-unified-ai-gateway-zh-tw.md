---
title: "跨雲端 AI 服務統一 API Gateway：安全、可擴展的企業級解決方案"
date: 2025-07-13T08:29:00+08:00
author: appleboy
type: post
slug: building-a-unified-api-gateway-zh-tw
share_img: /images/2025-07-13/IMG_6694_1024x683.JPG
categories:
  - golang
  - AI
  - gateway
---

![blog logo](/images/2025-07-13/IMG_6694_1024x683.JPG)

在當今的企業環境中，Generative AI 技術已經成為提升業務效率和創新能力的關鍵。然而，隨著 AI 服務的多樣化和分散化，如何統一管理和調用這些服務成為了一個挑戰。本文將介紹如何使用 [Golang][1] 開發一個[跨雲端 AI 服務的統一 API Gateway][3]，實現安全、可擴展的企業級解決方案。

這是我在 2025 年 [iThome 臺灣雲端大會][2] (CloudSummit) 的第二場[公開演講][3]，底下是演講的內容大綱。

1. 身份驗證與授權
2. 多雲人工智慧後端整合 ( [Azure OpenAI][4]、[AWS Bedrock][5]、[Google Gemini AI][6] .... )
3. 流量控制與資源管理
4. 監控與指標聚合

[1]: https://go.dev/
[2]: https://cloudsummit.ithome.com.tw/2025/
[3]: https://cloudsummit.ithome.com.tw/2025/session-page/3684
[4]: https://azure.microsoft.com/en-us/products/ai-services/openai-service
[5]: https://aws.amazon.com/bedrock/
[6]: https://cloud.google.com/products/gemini

<!--more-->

## 會議影片

{{< youtube bU2THb1SW9Q >}}

品質沒有到很好，請見諒，聲音請轉到最大聲

## 投影片

{{< speakerdeck id="78492040ee3c4be9af4ca76a8b8d7fa9" >}}

這次演講的投影片已經上傳到 Speaker Deck，您可以在 [這裡查看](https://speakerdeck.com/appleboy/building-a-unified-api-gateway-for-secure-and-scalable-cross-cloud-ai-service)。在 90 分鐘的演講中，我們深入探討了如何使用 Golang 開發一個統一的 API Gateway，並實現跨雲端 AI 服務的整合。

## 演講內容

![slide01](/images/2025-07-13/slide01.png)

2022 年 ChatGPT 橫空出世，讓 Generative AI 技術迅速普及。隨著 OpenAI、Google、Microsoft 等科技巨頭的加入，AI 服務的生態系統變得越來越複雜。而當時沒有一個可用的 API Gateway 來統一管理這些服務，開發者需要面對不同的 API、身份驗證和授權機制，這對企業來說是一個巨大的挑戰。所以團隊花了大量時間來開發一個統一的 API Gateway，這個 Gateway 不僅能夠整合多個 AI 服務，還能提供安全、可擴展的解決方案。也非常感謝當時的團隊成員 [Rueian](https://github.com/rueian) 及其他協助同仁。

背後使用的是 [Rueian](https://github.com/rueian) 所開發的 [rueidis][11] 套件，這是一個高效的 Redis 客戶端，能夠支援 Pipeline、Transaction 等功能。此套件已經被 Redis 官方認可並廣泛使用。

[11]: https://github.com/redis/rueidis

![slide02](/images/2025-07-13/slide02.png)

這場演講的目的是分享我們在開發這個 API Gateway 過程中的經驗和教訓，並展示如何使用 Golang 實現一個高效、可擴展的解決方案。裡面包含底下項目

- API Gateway & Routing Management
- Authentication & Authorization
- Quota & Billing Management
- Multi AI/ML Service Integration
- Monitoring & Logging

細節我們之後有機會再談談，之後 iThome 也會釋出相關影片。屆時會放上來讓大家參考。此 API Gateway 服務只使用了 Redis 作為快取，並沒有使用任何資料庫。這樣的設計使得系統更加輕量級，並且能夠快速響應請求，細節可以參考投影片。

## 現場照片

![photo3](/images/2025-07-13/IMG_6694_1024x683.JPG)

![photo4](/images/2025-07-13/IMG_6695_1024x683.JPG)

![photo5](/images/2025-07-13/IMG_6696_1024x683.JPG)

![photo6](/images/2025-07-13/IMG_6697_1024x683.JPG)

![photo1](/images/2025-07-13/IMG_6687_1024x683.JPG)

![photo2](/images/2025-07-13/IMG_6690_1024x683.JPG)

當天穿了 2024 年的 [GopherCon Taiwan](https://gopherday.golang.tw/2024/en) T-shirt，感謝 iThome 團隊的安排，現場人數大約在 150 人左右。場地非常寬敞，並且有提供午餐。
