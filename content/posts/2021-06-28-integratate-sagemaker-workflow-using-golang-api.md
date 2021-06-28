---
title: "AI 團隊整合導入 AWS SageMaker 流程"
date: 2021-06-27T11:35:53+08:00
author: appleboy
type: post
url: /2021/06/integratate-sagemaker-workflow-using-golang-api/
share_img: https://i.imgur.com/REuJgTP.png
categories:
  - Golang
  - AWS
tags:
  - golang
  - sagemaker
  - aws
---

![Flow](https://i.imgur.com/REuJgTP.png)

## 團隊困境

如果團隊未來想把[機器學習][2]推廣成一個服務，可以讓開發者帶入不同的參數進行客製化的學習，最終拿到學習過的 Model。或是團隊資源不夠，想要使用大量的 GPU 資源來加速 AI Model Training，這時就是要朝向使用第三方資源像是 [AWS SageMaker][1] 來進行整合。而在團隊內會分成機器學習團隊，及後端團隊，前者是專門進行資料分析及 AI Model 演算法及程式碼開發，後者則是專攻全部工作流程，從產生測試資料，前置準備，到 Training Model，及將產生的結果發送給開法者，這整段流程會由後端團隊進行串接。所以當我們要用第三方服務時 AWS SageMaker，對於機器學習團隊來說，要將整個環境打包成容器模式，並且符合 SageMaker 所規定的格式，**過程相當複雜**，而為了讓開發環境統一，我們使用了[容器技術][3] (Docker Container) 來進行 SageMaker 串接，本篇會教大家如何整合 SageMaker 流程，讓機器學習團隊可以專注於 Model 流程開發，而不需要花時間在整合容器技術並符合 SageMaker 格式。

[1]:https://docs.aws.amazon.com/sagemaker/latest/dg/whatis.html
[2]:https://medium.com/@troy801125/machine-learning-%E4%BA%BA%E5%B7%A5%E6%99%BA%E6%85%A7%E5%92%8C%E6%A9%9F%E5%99%A8%E5%AD%B8%E7%BF%92%E6%98%AF%E4%BB%80%E9%BA%BC-49a6ba41ab3e
[3]:https://docs.aws.amazon.com/sagemaker/latest/dg/docker-containers.html

<!--more-->

## 需求目標

使用像是 AWS 第三方服務，我個人最怕的就是被服務綁死，也就是今天團段如果要轉移到 GCP 甚至其他第三方服務時，不要被特定服務限制住，所以會避免特定的流程被單一服務綁死，能透過自己寫代碼取代掉會更好。而我們要推出的服務流程也不複雜。

1. 使用者上傳資料
   - Training Data
   - Evaluation Data
   - Pretrained Data
2. 使用者調整參數
   - Learning Rate
   - Training Iteration
   - Batch Size
3. 進行 Model Taining
4. 檔案下載
   - Training Log
   - Prediction Result
   - Fine-tuned model

以上四個步驟，團隊希望可以單純使用 AWS SageMaker 內的 GPU 資源，及 S3 Storage 空間來進行整合，最終讓使用者可以一次上傳多個不同參數組合，進行 Model Trainging，並且拿到最後的 model 進行驗證。透過 SageMaker 幫忙管理 GPU Farming 資源，我們就不需要自己啟動 GPU 機器。

## SageMaker 流程介紹

團隊重點在於如何讓機器學習團隊不用管 SageMaker 如何運作，只要將環境包成容器後，再將此容器交給後端團隊，進行最後的整合，而中間的溝通的方式，可以透過接受一個 `JSON` 格式的方式進行傳遞。我們將整個 Workflow 整理如下，從使用者在 UI 介面進行檔案上傳，及參數的調整，啟用 SageMaker 進行 AI Model Trainging。

![Flow](https://i.imgur.com/REuJgTP.png)

接著我們要在 SageMaker 使用容器技術，前提要看看 SageMaker 怎麼將 S3 的資料及參數下載到指定的位置，底下是整個容器目錄的結構:

```bash
/opt/ml
|-- code
|   |-- cifar10.py
|   `-- run.sh
|-- input
|   |-- config
|   |   |-- hyperparameters.json
|   |   |-- init-config.json
|   |   |-- inputdataconfig.json
|   |   |-- metric-definition-regex.json
|   |   |-- resourceconfig.json
|   |   |-- trainingjobconfig.json
|   |   `-- upstreamoutputdataconfig.json
|   `-- data
|       |-- checkpoint
|       |   `-- 016c7bd3-13a6-49bd-9c8c-4abfc3522781.zip
|       |-- config
|       |   `-- 054cb1f8-ab42-44f1-b441-700c1635f519.zip
|       |-- evaluation
|       |   `-- 0117d14a-8621-4744-b42c-8d12391835a7.zip
|       |-- training
|       |   `-- 00c7b0fe-c871-45a9-9272-be986162f2ce.zip
|-- model
`-- output
    |-- data
    |-- metrics
    |   `-- sagemaker
    `-- profiler
```

可以看出來 SageMaker 都是在 `/opt/ml` 底下進行整個工作流程，如果你是機器學習團隊成員，這些都是需要知道的，從哪邊拿 AI Model 參數或 Training Data，而在這過程對機器學習工程師來說，非常不方便，還要為了 SageMaker 學習目錄結構，解決此問題很簡單，我們在針對容器包一層程式，然後將所有的路徑都轉成 `JSON` 格式，只要跟其他團隊溝通好此格式即可，而由後端團隊來整合 SageMaker 目錄結構，而 AI 團隊只要負責使用 [AWS 所提供的 Base Image][11] 進行整合即可。

[11]:https://docs.aws.amazon.com/sagemaker/latest/dg/pre-built-containers-frameworks-deep-learning.html

## 用 Go 語言整合 SageMaker

網路上可以非常容易找到用 [Python 語言整合 SageMaker 的方式][21]，而我們這邊需求就是可以將公司包好的容器跑在 SageMaker 環境上，底下就用 [Go 語言][22]開啟整合流程

```go
package main

import (
	"fmt"
	"log"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sagemaker"
)

func main() {
	sess, err := session.NewSessionWithOptions(session.Options{
		// Provide SDK Config options, such as Region.
		Config: aws.Config{
			Region: aws.String("ap-southeast-1"),
		},

		// Force enable Shared Config support
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		log.Fatal(err)
	}

	// Create a SageMaker client from just a session.
	svc := sagemaker.New(sess)
	_, err = svc.CreateTrainingJob(&sagemaker.CreateTrainingJobInput{
		RoleArn: aws.String("arn:aws:iam::XXXXXXXXXXXX:role/sagemaker-role"),
		InputDataConfig: []*sagemaker.Channel{
			{
				ChannelName: aws.String("training"),
				DataSource: &sagemaker.DataSource{
					S3DataSource: &sagemaker.S3DataSource{
						S3DataDistributionType: aws.String("FullyReplicated"),
						S3DataType:             aws.String("S3Prefix"),
						S3Uri:                  aws.String("s3://sample-s3/converts/00c7b0fe-c871-45a9-9272-be986162f2ce"),
					},
				},
			},
			{
				ChannelName: aws.String("evaluation"),
				DataSource: &sagemaker.DataSource{
					S3DataSource: &sagemaker.S3DataSource{
						S3DataDistributionType: aws.String("FullyReplicated"),
						S3DataType:             aws.String("S3Prefix"),
						S3Uri:                  aws.String("s3://sample-s3/converts/0117d14a-8621-4744-b42c-8d12391835a7"),
					},
				},
			},
			{
				ChannelName: aws.String("checkpoint"),
				DataSource: &sagemaker.DataSource{
					S3DataSource: &sagemaker.S3DataSource{
						S3DataDistributionType: aws.String("FullyReplicated"),
						S3DataType:             aws.String("S3Prefix"),
						S3Uri:                  aws.String("s3://sample-s3/converts/016c7bd3-13a6-49bd-9c8c-4abfc3522781"),
					},
				},
			},
			{
				ChannelName: aws.String("config"),
				DataSource: &sagemaker.DataSource{
					S3DataSource: &sagemaker.S3DataSource{
						S3DataDistributionType: aws.String("FullyReplicated"),
						S3DataType:             aws.String("S3Prefix"),
						S3Uri:                  aws.String("s3://sample-s3/converts/054cb1f8-ab42-44f1-b441-700c1635f519"),
					},
				},
			},
		},
		StoppingCondition: &sagemaker.StoppingCondition{
			MaxRuntimeInSeconds: aws.Int64(3600),
		},
		TrainingJobName: aws.String(fmt.Sprintf("training-%d", time.Now().Unix())),
		AlgorithmSpecification: &sagemaker.AlgorithmSpecification{
			TrainingImage:     aws.String("XXXXXXXXXXXXX.dkr.ecr.ap-southeast-1.amazonaws.com/tl-training-model"),
			TrainingInputMode: aws.String("File"),
		},
		OutputDataConfig: &sagemaker.OutputDataConfig{
			S3OutputPath: aws.String("s3://sample-s3/outputs/"),
		},
		ResourceConfig: &sagemaker.ResourceConfig{
			InstanceCount:  aws.Int64(1),
			InstanceType:   aws.String("ml.m4.xlarge"),
			VolumeSizeInGB: aws.Int64(50),
		},
		Environment: map[string]*string{
			"FOO": aws.String("bar"),
			"BAR": aws.String("foo"),
		},
		HyperParameters: map[string]*string{
			"learning_rate": aws.String("0.5"),
			"end_rate":      aws.String("0.6"),
		},
	})
	if err != nil {
		log.Fatal(err)
	}
}
```

首先建立 SageMaker 專屬的 Role (`RoleArn` 設定)，如果想瞭解權限的話，可以直接[參考這篇][23]，而底下列出要跑簡單模型串通流程需要的權限:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload"
      ],
      "Resource": [
        "arn:aws:s3:::sample-s3/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListAllMyBuckets",
        "s3:GetBucketCors",
        "s3:PutBucketCors"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketAcl",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::*/*",
        "arn:aws:s3:::sample-s3"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetRegistryPolicy",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:GetLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

注意務必要打開 [CloudWatch][24] 跟 logs 的權限，不然跑完無法看到正常的 Log 訊息。接著 `InputDataConfig` 參數可以指定在 S3 上面任何檔案，透過 `Prefix` 設定來下載多個檔案，而 `ChannelName` 當作目錄分類。像是底下設定:

```go
			{
				ChannelName: aws.String("checkpoint"),
				DataSource: &sagemaker.DataSource{
					S3DataSource: &sagemaker.S3DataSource{
						S3DataDistributionType: aws.String("FullyReplicated"),
						S3DataType:             aws.String("S3Prefix"),
						S3Uri:                  aws.String("s3://sample-s3/converts/016c7bd3-13a6-49bd-9c8c-4abfc3522781"),
					},
				},
			},
```

可以在 `/opt/ml/data/input` 底下找到 `checkpoint` 目錄，更多詳細設定可以參考 [S3DataSource][25]。

[21]:https://docs.aws.amazon.com/sagemaker/latest/dg/adapt-training-container.html
[22]:https://golang.org
[23]:https://docs.aws.amazon.com/sagemaker/latest/dg/security-iam.html
[24]:https://aws.amazon.com/cloudwatch/
[25]:https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_S3DataSource.html

接著透過 `AlgorithmSpecification` 指定用哪個演算法來進行訓練，`TrainingImage` 可以指定預先包好的容器名稱。更多詳細設定請看[參考官方文件](https://docs.aws.amazon.com/sagemaker/latest/APIReference/API_AlgorithmSpecification.html)

```go
		AlgorithmSpecification: &sagemaker.AlgorithmSpecification{
			TrainingImage:     aws.String("XXXXXXXXXXXXX.dkr.ecr.ap-southeast-1.amazonaws.com/tl-training-model"),
			TrainingInputMode: aws.String("File"),
		},
```

當模型完成時，會有很多資料需要給使用者查閱或下載，可以將檔案都丟到 `/opt/ml/output/data` 內，而 SageMaker 會將裡面的檔案全部壓縮成 `.tar.gz` 格式放到 `OutputDataConfig` 指定的 S3 路徑內。

如果有寫成 Wrapper 包在外層，在呼叫 Python 的話，你一定需要 `Environment` 將而外的資訊帶入容器內，這樣就可以在容器拿到此變數進行處理。另外 AI 團隊需要的參數可以透過 `HyperParameters` 方式傳入，SageMaker 會將全部參數放到 `/opt/ml/input/config/hyperparameters.json` 內，透過 Python 讀取此檔案就可以拿到參數資料。而這邊為了讓 AI 團隊可以專心在演算法，後端會將全部參數，包含所以 Input Data 的路徑，全部寫進單一個 `JSON` 檔案，而容器內 Python 只要接受這個 JSON 路徑，裡面就可以看到所以參數集合，讓演算法團隊，不需要了解整個容器結構，完成訓練模型，並將結果產生在指定的目錄底下。

## 心得

本來 SageMaker 就是要讓 AI 團隊可以更容易方便使用，但是對於已經在自家使用 GPU 來訓練模型的團隊來說，轉換到 SageMaker 總會需要一些時間來熟悉整個流程，而為了避免讓演算法團隊花時間在這上面，不如後端團隊再包一層 Wrapper 來處理跟 SageMaker 介接的部分，這樣會省下不少時間，另外一個好處就是，有這一層 Wrapper 後，在訓練模型中途，需要跟 Web Server 溝通的部分，都可以透過 Wrapper 處理了，像是前端頁面需要目前 Training 的進度，需要每 5 秒讀取 Process 檔案，透過 API 傳到後端數據庫，前端透過 GraphQL Subscription 來讀取資料。
