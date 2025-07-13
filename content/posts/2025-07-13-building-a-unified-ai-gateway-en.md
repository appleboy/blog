---
title: "Building a Unified API Gateway for Cross-Cloud AI Services: A Secure and Scalable Enterprise Solution"
date: 2025-07-13T09:00:00+08:00
author: appleboy
type: post
slug: building-a-unified-api-gateway-en
share_img: /images/2025-07-13/IMG_6694_1024x683.JPG
categories:
  - golang
  - AI
  - gateway
---

![blog logo](/images/2025-07-13/IMG_6694_1024x683.JPG)

In today's enterprise environment, Generative AI technology has become key to enhancing business efficiency and innovation. However, with the diversification and decentralization of AI services, how to uniformly manage and call these services has become a challenge. This article will introduce how to use [Golang][1] to develop a [unified API Gateway for cross-cloud AI services][3], achieving a secure and scalable enterprise-level solution.

This was my second [public talk][3] at the 2025 [iThome CloudSummit Taiwan][2]. Below is the outline of the talk.

1. Authentication and Authorization
2. Multi-Cloud AI Backend Integration ([Azure OpenAI][4], [AWS Bedrock][5], [Google Gemini AI][6], etc.)
3. Traffic Control and Resource Management
4. Monitoring and Metrics Aggregation

[1]: https://go.dev/
[2]: https://cloudsummit.ithome.com.tw/2025/
[3]: https://cloudsummit.ithome.com.tw/2025/session-page/3684
[4]: https://azure.microsoft.com/en-us/products/ai-services/openai-service
[5]: https://aws.amazon.com/bedrock/
[6]: https://cloud.google.com/products/gemini

<!--more-->

## Slides

{{< speakerdeck id="78492040ee3c4be9af4ca76a8b8d7fa9" >}}

The slides for this talk have been uploaded to Speaker Deck, and you can [view them here](https://speakerdeck.com/appleboy/building-a-unified-api-gateway-for-secure-and-scalable-cross-cloud-ai-service). In the 90-minute presentation, we delved into how to use Golang to develop a unified API Gateway and achieve integration of cross-cloud AI services.

## Talk Content

![slide01](/images/2025-07-13/slide01.png)

In 2022, the emergence of ChatGPT rapidly popularized Generative AI technology. With tech giants like OpenAI, Google, and Microsoft joining the fray, the ecosystem of AI services has become increasingly complex. At that time, there was no available API Gateway to uniformly manage these services. Developers had to deal with different APIs, authentication, and authorization mechanisms, which was a huge challenge for enterprises. Therefore, the team spent a lot of time developing a unified API Gateway. This Gateway not only integrates multiple AI services but also provides a secure and scalable solution. I am also very grateful to the team members at the time, [Rueian](https://github.com/rueian), and other colleagues who assisted.

Behind the scenes, it uses the [rueidis][11] package developed by [Rueian](https://github.com/rueian), which is a high-performance Redis client that supports features like Pub/Sub, Pipeline, and Transaction. This package has been officially recognized by Redis and is widely used.

[11]: https://github.com/redis/rueidis

![slide02](/images/2025-07-13/slide02.png)

The purpose of this talk is to share our experiences and lessons learned during the development of this API Gateway and to demonstrate how to use Golang to implement an efficient and scalable solution. It includes the following items:

- API Gateway & Routing Management
- Authentication & Authorization
- Quota & Billing Management
- Multi AI/ML Service Integration
- Monitoring & Logging

We will have the opportunity to discuss the details later, and iThome will also release related videos. We will post them for everyone's reference. This API Gateway service only uses Redis for caching and does not use any database. This design makes the system more lightweight and able to respond to requests quickly. For details, please refer to the slides.

## Photos from the Event

![photo3](/images/2025-07-13/IMG_6694_1024x683.JPG)

![photo4](/images/2025-07-13/IMG_6695_1024x683.JPG)

![photo5](/images/2025-07-13/IMG_6696_1024x683.JPG)

![photo6](/images/2025-07-13/IMG_6697_1024x683.JPG)

![photo1](/images/2025-07-13/IMG_6687_1024x683.JPG)

![photo2](/images/2025-07-13/IMG_6690_1024x683.JPG)

On that day, I wore the 2024 [GopherCon Taiwan](https://gopherday.golang.tw/2024/en) T-shirt. Thanks to the iThome team for the arrangements. The number of attendees was around 150. The venue was very spacious, and lunch was provided.
