---
title: "用 AWS EFS 或 FSx Lustre 加速 Sagemaker AI 模型訓練"
date: 2021-09-04T12:43:19+08:00
author: appleboy
type: post
url: /2021/09/speed-up-amazon-sagemaker-training-using-efs-or-fsx-lustre
share_img: https://i.imgur.com/X4wpl6d.png
categories:
  - AWS
  - Golang
tags:
  - sagemaker
  - golang
  - FSx
  - Lustre
  - EFS
  - terraform
---

![cover](https://i.imgur.com/X4wpl6d.png)

前不久寫過一篇『[AI 團隊整合導入 AWS SageMaker 流程][1]』介紹如何用 [Go 語言][2]整合 [SageMaker API][3]。本篇會介紹在訓練 AI 模型前，如何將 Dataset 準備好並整合 SageMaker，過程中遇到什麼問題跟挑戰。團隊提供一個平台，讓使用者可以上傳自家的 Dataset 搭配團隊內部預設的 Dataset 進行 AI 模型的訓練，最後將模型提供給使用者下載使用，簡單來說，使用者只需要提供 Dataset 並把 AI 訓練參數設定完畢，就可以拿到最後的模型進行後續的整合開發。底下我們探討使用者上傳 Dataset 的流程。

[1]:https://blog.wu-boy.com/2021/06/integratate-sagemaker-workflow-using-golang-api/
[2]:https://golang.org
[3]:https://aws.amazon.com/tw/pm/sagemaker/

<!--more-->

## 上傳流程

![cover](https://i.imgur.com/X4wpl6d.png)

使用者上傳的會是整包 `.zip` 格式的 Image 檔案，拿到檔案後，需要轉換成 tfrecord 格式，再重新打包上傳到 [AWS S3][11] 空間。上團可以看到，後端開發一套 CLI 工具，使用者透過 CLI 進行認證，並將檔案上傳到 AWS S3 儲存空間，一旦上傳完畢後，S3 會發送 Push Event 到 [AWS SQS][12] 內，這時後端會在提供另一個服務來接受 SQS 訊息，每次拿到訊息後，會將檔案下載進行轉換，在打包上傳回 S3，並且將過程的訊息，傳回 API 服務，通知前端。

[11]:https://aws.amazon.com/tw/s3/
[12]:https://aws.amazon.com/tw/sqs/

## 檔案問題

在講問題前，先來看看 SageMaker 訓練模型流程，底下先看看 Training Job 流程:

![job flow](https://i.imgur.com/K57zeNx.png)

可以看到第二個步驟是 `Downloading`，也就是每一次的 Training 過程，都需要從 S3 下載，這樣每次訓練，都需要浪費下載時間，而這個時間在 SageMaker 是算在訓練時間內，也就是需要花費的，假設檔案有個 100G，不只是讓訓練模型增加不少時間外，也額外多花了不少費用。

除了使用者提供的 Dataset 之外，還要加上自家的 `1TB` Dataset 進行訓練，那如果把 1TB 資料放在 S3 上面，從下載到解壓縮可能就要一小時跑不掉，所以透過 S3 這方案肯定是不行的，浪費時間跟金錢。故最終有跟台灣 AWS 團隊討論出使用 [AWS FSx for Lustre][21] 解決方案。

[21]:https://aws.amazon.com/tw/fsx/lustre/?

## 使用 Amazon FSx for Lustre

首先 Lustre 就是一個雲端網路磁碟，它的最大好處就是可以整合 AWS S3，只要 S3 上面有增加任何檔案，Lustre 就會隨時將檔案同步進來，但是這僅限於單向同步，也就是 `S3 -> Lustre`，如果將 Lustre 掛載到 EC2 上面，砍掉任何檔案，是不會同步到 S3 上面的，這點需要非常小心注意。

原本團隊的想法是，這樣挺不錯的，S3 可以同步到 Lustre 磁區內，但是這邊遇到問題是，本來 AWS S3 Bucket 上有綁定了 `ObjectCreated` 到 SQS 內部，如下面 [HCL 語法][32]範例 ([Terraform][31])，但是只要使用 S3 同步到 Lustre 內，也需要綁定同樣 Event，這邊就完全不能設定，會噴 API 錯誤，等於是要開發者二選一這功能，其實相當奇怪啊，理應上 AWS S3 要可以同步發送相同的 Event 到不同的 Target 才對，也因為這樣，團隊取消了將使用者的 Dataset 轉移到 Lustre 磁碟上。

[31]:https://www.terraform.io/
[32]:https://github.com/hashicorp/hcl

```hcl
resource "aws_s3_bucket" "tl_s3" {
  bucket = "tl-dataset"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "tl s3"
    Project     = var.project_name
    Environment = var.project_env
  }
}

resource "aws_s3_bucket_notification" "tl_bucket_notification" {
  bucket = aws_s3_bucket.tl_s3.id

  queue {
    queue_arn     = aws_sqs_queue.tl_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "datasets/"
  }
}
```

最終團隊只有將自家的 Dataset (800G) 放到 Lustre 上面。這邊提醒一下，Lustre 低消是 `1.2TB`，所以團隊只有少量的 Dataset 的話，其實不應該使用 Lustre 才對。

## 使用 Amazon Elastic File System

上述 Lustre 整合 SageMaker 相當成功，也順利將整套訓練模型流程給定下來了。但是由於客戶都在中國境內居多，故將整套 Global AWS 架構，轉移到 AWS China 北京 Region。然而當在建置過程中，直接收到 SageMaker API 噴出底下錯誤訊息

> FSx for Lustre is currently not supported in the region cn-north-1 for SageMaker

看到這訊息真的蠻傻眼的，直接開 AWS Web Console 操作看看是否少了哪些功能，結果從 UI 上面是無法選擇使用 File System 功能

![china](https://i.imgur.com/NfwgEtS.png)

當下馬上跟 AWS 團隊再次確認是否有支援 Lustre，結果得到的回覆是只有支援 EFS，而 UI 上面不支援使用 EFS，只能透過 API 方式進行串接。後端團隊立馬開始將 Lustre 轉換到 EFS，轉換過程遇到一些設定上的問題，像是底下:

> ClientError: Unable to mount file system: fs-0337a79e, directory path: /efs/mtk. File system connection timed out. Please ensure that mount target IP address of file system is reachable and the security groups you associate with file system must allow inbound access on NFS port.

EFS 使用的是 `2049/TCP` 連接埠，故需要新增底下防火牆，並設定在 EFS 的 Security Group 底下。

```hcl
resource "aws_security_group" "efs" {
  name        = "allow_efs"
  description = "Allow EFS inbound traffic"
  vpc_id      = aws_vpc.cai.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow nfs rule"
  }
}
```

搞定上述網路問題後，又遇到底下問題:

> ClientError: Unable to mount file system: fs-0337a79e, directory path: /efs/mtk. No such file or directory: /efs/mtk.

這問題比較好解決，原因是在 Lustre 本身就有提供 mount point 指定在特定的位置，像是 `/efs` 這位置，而 EFS 本身的 mount point 預設在 `/`，故只需要在 API 上重新設定即可。API 寫法如下

```go
inputDataConfig = append(
  inputDataConfig,
  &sagemaker.Channel{
    ChannelName: aws.String("mtk"),
    DataSource: &sagemaker.DataSource{
      FileSystemDataSource: &sagemaker.FileSystemDataSource{
        DirectoryPath:        aws.String(options.FSX.Path),
        FileSystemAccessMode: aws.String(sagemaker.FileSystemAccessModeRo),
        FileSystemId:         aws.String(options.FSX.ID),
        FileSystemType:       aws.String(sagemaker.FileSystemTypeFsxLustre),
      },
    },
  },
)
```

搞定上述路徑問題後，又遇到另一個網路問題:

> ClientError: Data download failed:Please ensure that the subnet's route table has a route to an S3 VPC endpoint or a NAT device, and both the security groups and the subnet's network ACL allow outbound traffic to S3.

想像 AWS EC2要去存取 AWS S3 的資源，完全沒問題的，而可以成功讀取最主要因素是這台 EC2 是在 `Public Subnet`，它有權限可以存取 Internet，而 Public Subnet 最主要有 route table 搭配 [internet gateway][41] 才可以存取 Internet。

[41]:https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html

而現在遇到此問題的原因是架構使用的是 `Private Subnet`，而此 Subnet 是不能存取 Internet 的，這時候就需要使用 S3 VPC endpoints 方式來解決此問題。所以透過設定 S3 VPC Endpoint 方式就可以達成存取 S3 檔案了。

```hcl
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.cai.id
  service_name    = "com.amazonaws.cn-north-1.s3"
  route_table_ids = [aws_route_table.cai.id]
}
```

## 使用心得

這邊得到一個關鍵的結論就是，假設團隊真的要在 AWS China 進行建置的話，在測試 Gloabl AWS 同時也需要進到 China 看看是否有相同的功能不然到時候整套流程會修改蠻大一部分，好在這次只是遇到 AWS Lustre 轉換到 AWS EFS 而已。

另外在建置整套 AWS 環境時，需要對網路有一定的概念，還有防火牆，團隊針對權限部分設定的非常嚴謹，沒有用到的權限一率拔掉，或者是在 IAM 上面權限是慢慢打開，而不是一次全部開放。

## 參考連結

* [使用 Amazon FSx for Lustre 和 Amazon EFS 作数据源加快 Amazon Sagemaker 训练](https://aws.amazon.com/cn/blogs/china/use-amazon-fsx-for-lustre-and-amazon-efs-as-data-source-to-speed-up-amazon-sagemaker-training/)
* [Installing the Amazon EFS client on other Linux distributions](https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html#installing-other-distro)
* [Use a Private Docker Registry for Real-Time Inference Containers](https://docs.aws.amazon.com/sagemaker/latest/dg/your-algorithms-containers-inference-private.html)
