---
title: 自動化更新 AWS Lambda 函數
author: appleboy
type: post
date: 2018-01-25T02:20:11+00:00
url: /2018/01/update-aws-lambda-using-drone-lambda-tool/
dsq_thread_id:
  - 6436405883
categories:
  - blog

---
[<img src="https://i1.wp.com/farm5.staticflickr.com/4745/38984480815_c8284784d4_z.jpg?w=840&#038;ssl=1" alt="Snip20180125_1" data-recalc-dims="1" />][1]

昨天介紹了『[在 AWS Lambda 上寫 Go 語言][2]』，無服務器的時代已經來臨，透過昨天的教學，開發者可以很快的用 [Go 語言][3]寫簡易的 [Restful API][4] 或 [GraphQL][5] 服務，直接無痛丟到 [AWS Lambda][6]，然而寫完編譯打包上傳整個流程，是非常枯燥乏味的，如何有效地透過自動化工具像是 [Jenkins][7] 或 [Drone][8] 來達到自動化上傳，減少工程師花時間手動上傳，省下的時間，可以讓工程師多寫個幾行程式碼呢。

<!--more-->

## 上傳 AWS Lambda

要上傳更新 Lambda 服務，步驟很簡單 `編譯` => `打包` => `上傳`，三個步驟就可以搞定，底下來看看如何執行指令

```bash
# 編譯
$ GOOS=linux go build -o main .
# 打包
$ zip deployment.zip main
```

上傳部分則是可以透過 Web Console 或 [AWS CLI][9]，這些步驟可以很輕易的整合進 Jenkins 或其他 CI/CD 服務，但是我個人又開發了 [drone-lambda][10]，讓開發者可以不用裝任何套件，就可以跨平台執行 Lambda 上傳。

## drone-lambda 功能

[drone-lambda][10] 是 Go 語言開發的跨平台 CLI 工具，目前支援 Windows, MacOS, Linux 三種系統環境，開發者可以透過[此頁面來下載][11]最新版本。此 CLI 功能如下

  * 動態指定 AWS Secret 及 Access Key
  * 動態指定 AWS Profile (多環境)
  * 支援自動 zip 打包功能
  * 支援 Rexp Path (打包多個檔案)
  * 支援 zip 上傳
  * 支援 s3 bucket 上傳

底下來看看如何使用此工具

## 透過 zip 檔案上傳

假設已經打包好 zip 檔案，就可以透過底指令上傳

```shell
$ drone-lambda --region ap-southeast-1 \
  --access-key xxxx \
  --secret-key xxxx \
  --function-name upload-s3 \
  --zip-file deployment.zip
```

## 透過 s3 bucket 上傳

前提是 zip 檔案已經在 s3 bucket 內

```shell
$ drone-lambda --region ap-southeast-1 \
  --access-key xxxx \
  --secret-key xxxx \
  --function-name upload-s3 \
  --s3-bucket some-bucket \
  --s3-key lambda-dir/lambda.zip
```

## 自動打包上傳

開發者可以指定需要打包的檔案，如果有多個檔案，這邊支援正規語法喔

```shell
$ drone-lambda --region ap-southeast-1 \
  --access-key xxxx \
  --secret-key xxxx \
  --function-name upload-s3 \
  --source main
```

其中的 `main` 就是 Go 語言產生的執行檔，使用 `--source` 好處就是直接幫忙打包成 zip 檔案直接上傳，這樣在 Deploy 流程就可以少一個 zip 步驟。

## 設定 AWS 權限

由於此工具使用到 AWS Lambda 上傳的功能，所以必須要在 AWS Role 打開底下權限:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "iam:ListRoles",
        "lambda:UpdateFunctionCode",
        "lambda:CreateFunction"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

注意務必加上 `UpdateFunctionCode`。

## 整合 Drone CI/CD

在 Drone 的 Yaml 檔案設定方式非常容易，請直接參考底下:

```json
  lambda:
    image: appleboy/drone-lambda
    pull: true
    secrets: [ aws_access_key_id, aws_secret_access_key ]
    region: ap-southeast-1
    function_name: gin
    source:
      - main
```

其中 `aws_access_key_id` 及 `aws_secret_access_key` 可以透過 Web 或 CLI 方式設定。

## 後記

如果不用 Drone 而是 jenkins 或 GitLab CI，可以直接下載此工具，就可以使用了，也不需要寫任何 Plugin。

# [開源專案 drone-lambda][10]

 [1]: https://www.flickr.com/photos/appleboy/38984480815/in/dateposted-public/ "Snip20180125_1"
 [2]: https://blog.wu-boy.com/2018/01/write-golang-in-aws-lambda/
 [3]: https://golang.org
 [4]: https://ithelp.ithome.com.tw/articles/10157431
 [5]: http://graphql.org/learn/
 [6]: https://aws.amazon.com/tw/lambda/
 [7]: https://jenkins.io
 [8]: https://github.com/drone/drone
 [9]: https://aws.amazon.com/cli/
 [10]: https://github.com/appleboy/drone-lambda
 [11]: https://github.com/appleboy/drone-lambda/releases
