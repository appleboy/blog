---
title: "使用 AWS IAM Policy 設定 S3 Bucket 底下特定目錄權限"
date: 2022-04-02T15:49:44+08:00
type: post
slug: grant-access-to-user-specific-folders-in-amazone-s3-bucket
share_img: https://i.imgur.com/zg8abD1.png
categories:
  - Golang
tags:
  - golang
  - pulumi
  - amazone
  - s3
---

如何有效控制 [AWS][2] User 能看到哪些功能，以及執行哪些操作，最仰賴的就是 [AWS Identity and Access Management][1] (簡稱 IAM)，IAM 可以讓管理者透過 UI 或自定義 JSON 格式來客製化使用者權限。剛好最近跟其他團隊合作到一個專案，需求就是開發者透過 Web 進行 AI Model 訓練，訓練前 [SageMaker][11] 會將使用者的 Dataset 下載到容器內，接著開始訓練，而團隊將此下載 Dataset 動作記錄到 AWS S3 Bucket 的 `syslog` 目錄內，確保檔案存取紀錄。最後將目錄底下的檔案，開權限給客戶進行查看，避免管理者或其他 User 不小心存取到別人的 Dataset 資料。

![log](https://i.imgur.com/zg8abD1.png)

[1]:https://aws.amazon.com/iam/
[2]:https://aws.amazon.com/tw/
[11]:https://aws.amazon.com/pm/sagemaker

一般來說在 Bucket 內會有許多 Sub-Folder，而 AWS 透過 IAM 方式設定 User 只能存取特定的目錄。可以參考 AWS 官方這篇文章『[Writing IAM Policies: Grant Access to User-Specific Folders in an Amazon S3 Bucket][3]』。

[3]:https://aws.amazon.com/blogs/security/writing-iam-policies-grant-access-to-user-specific-folders-in-an-amazon-s3-bucket/

<!--more-->

## 設定 User 存取 AWS S3 Console

使用者第一步登入 AWS Console 後，點選 S3 Storage 可以看到此帳號底下全部的 Buckets。

![bucket list](https://i.imgur.com/biWHYyp.jpg)

如果要能讓使用者看到上述頁面，管理者需要給定底下權限

```json
{
 "Version":"2012-10-17",
 "Statement": [
   {
     "Sid": "AllowUserToSeeBucketListInTheConsole",
     "Action": ["s3:ListAllMyBuckets", "s3:GetBucketLocation"],
     "Effect": "Allow",
     "Resource": ["arn:aws:s3:::*"]
   }
 ]
}
```

從上面可以看到賦予 `ListAllMyBuckets` 跟 `GetBucketLocation` 權限，其中 `ListAllMyBuckets` 是一定要的，原因是如果沒有給此權限的話，使用者登入 S3 畫面後，是看不到任何一個 Bucket 的，如果看不到，那更不用想 User 可以透過畫面進入到子目錄列表內。而 `GetBucketLocation` 則是讓使用者可以初始化 S3 Console 畫面，如果沒有這兩項，使用者就會看到許多錯誤在此畫面。

## 查看特定目錄檔案列表

假設要開特定目錄列表給使用者，可以透過底下 JSON 格式

```json
{
  "Sid": "AllowListingOfUserFolder",
  "Action": [
    "s3:ListBucket"
  ],
  "Effect": "Allow",
  "Resource": [
    "arn:aws:s3:::my-bucket"
  ],
  "Condition": {
    "StringLike": {
      "s3:prefix": [
        "syslog/*"
      ]
    }
  }
}
```

`StringLike` 條件來執行正規表示限制特定的路徑。下一步就是讓使用者可以針對檔案進行特定的操作，由於是 `syslog` 目錄，我們只讓使用者可以下載查看檔案

## 針對特定操作打開權限

針對特定的操作打開即可，請參考底下範例

```json
{
  "Sid": "AllowAllS3ActionsInUserFolder",
  "Effect": "Allow",
  "Action": [
    "s3:GetObject"
  ],
  "Resource": [
    "arn:aws:s3:::my-bucket/syslog/*"
  ]
}
```

只讓使用者可以下載觀看 Log 檔案，其他操作都不行，故只開放 `GetObject` 動作。由於團隊內有許多專案，全部專案共用同一個帳號，所以此帳號底下有蠻多 bucket 的，但是這些 bucket 以及底下的子目錄都不能讓使用者知道，故最後將權限此開放 `ListBucket` + `GetObject`，如同底下最終的權限格式。

```json
{
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Condition": {
        "StringLike": {
          "s3:prefix": [
            "syslog/*"
          ]
        }
      },
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::my-bucket"
      ]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::my-bucket/syslog/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
```

## 心得

上面透過 AWS IAM 方式在同一個帳號底下進行權限相關卡控，由於不得已關係，我們才將 `ListAllMyBuckets` 等權限移除，這會造成使用者無法在 Console 頁面內一步一步進行操作，而需要團隊提供正確的 URL 才能將檔案列表顯示出來。未來應該是將 `syslog` 檔案直接寫到客戶端自行申請的 AWS 專屬帳號內，不共用帳號，才不會針對此情境進行卡控。
