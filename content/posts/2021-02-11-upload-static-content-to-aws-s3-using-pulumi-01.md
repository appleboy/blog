---
title: 初探 Pulumi 上傳靜態網站到 AWS S3 (一)
author: appleboy
type: post
date: 2021-02-11T07:29:56+00:00
url: /2021/02/upload-static-content-to-aws-s3-using-pulumi-01/
dsq_thread_id:
  - 8393267688
categories:
  - DevOps
  - Golang
tags:
  - golang
  - pulumi

---
[![cover][1]][1]

上一篇作者提到了兩套 [Infrastructure as Code][2] 工具，分別是 [Terraform][3] 跟 [Pulumi][4]，大家對於前者可能會是比較熟悉，那本篇用一個實際案例『建立 AWS S3 並上傳靜態網站』來跟大家分享如何從無開始一步一步使用 Pulumi。本教學使用的程式碼都可以在 [GitHub 上面瀏覽及下載][5]。教學會拆成七個章節:

  1. 建立 Pulumi 新專案
  2. 設定 AWS 環境
  3. 初始化 Pulumi 架構 (建立 S3 Bucket)
  4. 更新 AWS 架構 (S3 Hosting)
  5. 設定 Pulumi Stack 環境變數 ([教學二][6])
  6. 建立第二個 Pulumi Stack 環境 ([教學二][6])
  7. 刪除 Pulumi Stack 環境 ([教學二][6])

<!--more-->

## 教學影片

{{< youtube ujkXfPsU3Is >}}

  * 00:00​ Pulumi 應用實作簡介
  * 01:30​ 章節一: 用 Pulumi 建立新專案
  * 02:39​ 用 Pulumi CLI 初始化專案
  * 04:47​ 介紹 Pulumi 產生的 AWS Go 目錄結構內容
  * 06:10​ 章節二: 設定 AWS 環境
  * 08:36​ 章節三: 建立 AWS S3 Bucket
  * 13:44​ 指定 S3 Bucket 名稱
  * 16:09​ 章節四: 將 S3 Bucket 變成 Web Host
  * 16:25​ 上傳 index.html 到 S3 Bucket 內
  * 18:22​ 設定 S3 Bucket 為 Web Host 讀取 index.html
  * 19:17​ 取得 AWS S3 的 Web URL
  * 20:55​ 修改 S3 Object 的 Permission (ACL)
  * 22:45​ 心得感想

## 用 Pulumi 建立新專案

### 步驟一: 安裝 Pulumi CLI 工具

首先你要在自己電腦安裝上 Pulumi CLI 工具，請參考[官方網站][2]，根據您的作業環境有不同的安裝方式，底下以 Mac 環境為主

<pre><code class="language-sh">brew install pulumi</code></pre>

透過 brew 即可安裝成功，那升級工具透過底下即可

<pre><code class="language-sh">brew upgrade pulumi</code></pre>

或者您沒有使用 brew，也可以透過 curl 安裝

<pre><code class="language-sh">curl -fsSL https://get.pulumi.com | sh</code></pre>

測試 CLI 指令

<pre><code class="language-sh">$ pulumi version
v2.20.0</code></pre>

有看到版本資訊就是安裝成功了

### 步驟二: 初始化專案

透過 `pulumi new -h` 可以看到說明

<pre><code class="language-sh">Usage:
  pulumi new [template|url] [flags]

Flags:
  -c, --config stringArray        Config to save
      --config-path               Config keys contain a path to a property in a map or list to set
  -d, --description string        The project description; if not specified, a prompt will request it
      --dir string                The location to place the generated project; if not specified, the current directory is used
  -f, --force                     Forces content to be generated even if it would change existing files
  -g, --generate-only             Generate the project only; do not create a stack, save config, or install dependencies
  -h, --help                      help for new
  -n, --name string               The project name; if not specified, a prompt will request it
  -o, --offline                   Use locally cached templates without making any network requests
      --secrets-provider string   The type of the provider that should be used to encrypt and decrypt secrets (possible choices: default, passphrase, awskms, azurekeyvault, gcpkms, hashivault) (default "default")
  -s, --stack string              The stack name; either an existing stack or stack to create; if not specified, a prompt will request it
  -y, --yes                       Skip prompts and proceed with default values</code></pre>

可以選擇的 Template 超多，那我們這次用 AWS 搭配 Go 語言的 Temaplate 當作範例

<pre><code class="language-sh">$ pulumi new aws-go --dir demo
This command will walk you through creating a new Pulumi project.

Enter a value or leave blank to accept the (default), and press <ENTER>.
Press ^C at any time to quit.

project name: (demo)
project description: (A minimal AWS Go Pulumi program)
Created project 'demo'

Please enter your desired stack name.
To create a stack in an organization, use the format <org-name>/<stack-name> (e.g. `acmecorp/dev`).
stack name: (dev)
Created stack 'dev'

aws:region: The AWS region to deploy into: (us-east-1) ap-northeast-1
Saved config

Installing dependencies...

Finished installing dependencies

Your new project is ready to go! ✨

To perform an initial deployment, run 'cd demo', then, run 'pulumi up'</code></pre>

### 步驟三: 檢查專案目錄結構

<pre><code class="language-sh">└── demo
    ├── Pulumi.dev.yaml
    ├── Pulumi.yaml
    ├── go.mod
    ├── go.sum
    └── main.go</code></pre>

其中 `main.go` 就是主程式檔案

<pre><code class="language-go">package main

import (
    "github.com/pulumi/pulumi-aws/sdk/v3/go/aws/s3"
    "github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        // Create an AWS resource (S3 Bucket)
        bucket, err := s3.NewBucket(ctx, "my-bucket", nil)
        if err != nil {
            return err
        }

        // Export the name of the bucket
        ctx.Export("bucketName", bucket.ID())
        return nil
    })
}</code></pre>

## 設定 AWS 環境

在使用 Pulumi 之前要先把 AWS 環境建立好

### 前置作業

請先將 AWS 環境設定完畢，請用 `aws configure` 完成 profile 設定

<pre><code class="language-sh">aws configure --profile demo</code></pre>

### 步驟一: 設定 AWS Region

可以參考 [AWS 官方的 Available Regions][7]，並且透過 Pulumi CLI 做調整

<pre><code class="language-sh">cd demo && pulumi config set aws:region ap-northeast-1</code></pre>

切換到 demo 目錄，並執行 `pulumi config`

### 步驟二: 設定 AWS Profile

如果你有很多環境需要設定，請使用 AWS Profile 作切換，不要用 default profile。其中 `demo` 為 profile 名稱

<pre><code class="language-sh">pulumi config set aws:profile demo</code></pre>

## 初始化 Pulumi 架構 (建立 S3 Bucket)

### 步驟一: 建立新的 S3 Bucket

<pre><code class="language-go">        bucket, err := s3.NewBucket(ctx, "my-bucket", nil)
        if err != nil {
            return err
        }</code></pre>

### 步驟二: 執行 Pulumi CLI 預覽

透過底下指令可以直接預覽每個操作步驟所做的改變:

<pre><code class="language-sh">pulumi up</code></pre>

可以看到底下預覽:

<pre><code class="language-sh">Previewing update (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/previews/db6a9e4e-f391-4cc4-b50c-408319b3d8e2

     Type                 Name       Plan
 +   pulumi:pulumi:Stack  demo-dev   create
 +   └─ aws:s3:Bucket     my-bucket  create

Resources:
    + 2 to create

Do you want to perform this update?  [Use arrows to move, enter to select, type to filter]
  yes
> no
  details</code></pre>

選擇最後的 details:

<pre><code class="language-sh">Do you want to perform this update? details
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:dev::demo::pulumi:pulumi:Stack::demo-dev]
    + aws:s3/bucket:Bucket: (create)
        [urn=urn:pulumi:dev::demo::aws:s3/bucket:Bucket::my-bucket]
        acl         : "private"
        bucket      : "my-bucket-e3d8115"
        forceDestroy: false</code></pre>

可以看到更詳細的建立步驟及權限，在此步驟可以詳細知道 Pulumi 會怎麼設定 AWS 架構，透過此預覽方式避免人為操作失誤。

### 步驟三: 執行部署

看完上面的預覽，我們最後就直接執行:

<pre><code class="language-sh">Do you want to perform this update? yes
Updating (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/updates/3

     Type                 Name       Status
 +   pulumi:pulumi:Stack  demo-dev   created
 +   └─ aws:s3:Bucket     my-bucket  created

Outputs:
    bucketName: "my-bucket-9dd3052"

Resources:
    + 2 created

Duration: 17s</code></pre>

透過上述 UI 也可以看到蠻多詳細的資訊

<img src="https://i2.wp.com/i.imgur.com/MkY5BZC.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" /><img src="https://i2.wp.com/i.imgur.com/jpVpjmm.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" /> 

### 步驟四: 顯示更多 Bucket 詳細資訊

<pre><code class="language-go">        // Export the name of the bucket
        ctx.Export("bucketID", bucket.ID())
        ctx.Export("bucketName", bucket.Bucket)</code></pre>

執行 `pulumi up`

<pre><code class="language-go">Updating (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/updates/4

     Type                 Name      Status
     pulumi:pulumi:Stack  demo-dev

Outputs:
  + bucketID  : "my-bucket-9dd3052"
    bucketName: "my-bucket-9dd3052"

Resources:
    2 unchanged

Duration: 7s</code></pre>

### 步驟五: 更新 Bucket 名稱

<pre><code class="language-go">func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        // Create an AWS resource (S3 Bucket)
        bucket, err := s3.NewBucket(ctx, "my-bucket", &s3.BucketArgs{
            Bucket: pulumi.String("foobar-1234"),
        })
        if err != nil {
            return err
        }

        // Export the name of the bucket
        ctx.Export("bucketID", bucket.ID())
        ctx.Export("bucketName", bucket.Bucket)
        return nil
    })
}</code></pre>

透過 `pulumi up`

<pre><code class="language-sh">Previewing update (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/previews/7180c121-235c-40cc-9ae2-d0f68455296f

     Type                 Name       Plan        Info
     pulumi:pulumi:Stack  demo-dev
 +-  └─ aws:s3:Bucket     my-bucket  replace     [diff: ~bucket]

Outputs:
  ~ bucketID  : "my-bucket-9dd3052" => output<string>
  ~ bucketName: "my-bucket-9dd3052" => "foobar-1234"

Resources:
    +-1 to replace
    1 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::demo::pulumi:pulumi:Stack::demo-dev]
    --aws:s3/bucket:Bucket: (delete-replaced)
        [id=my-bucket-9dd3052]
        [urn=urn:pulumi:dev::demo::aws:s3/bucket:Bucket::my-bucket]
    +-aws:s3/bucket:Bucket: (replace)
        [id=my-bucket-9dd3052]
        [urn=urn:pulumi:dev::demo::aws:s3/bucket:Bucket::my-bucket]
      ~ bucket: "my-bucket-9dd3052" => "foobar-1234"
    ++aws:s3/bucket:Bucket: (create-replacement)
        [id=my-bucket-9dd3052]
        [urn=urn:pulumi:dev::demo::aws:s3/bucket:Bucket::my-bucket]
      ~ bucket: "my-bucket-9dd3052" => "foobar-1234"
    --outputs:--
  ~ bucketID  : "my-bucket-9dd3052" => output<string>
  ~ bucketName: "my-bucket-9dd3052" => "foobar-1234"</code></pre>

可以看到系統會砍掉舊的，在建立一個新的 bucket

## 更新 AWS 架構 (S3 Hosting)

上個步驟教大家如何建立 Infra 架構，那這單元教大家如何將使用 S3 當一個簡單的 Web Hosting。

  1. 將 index.html 放入 S3 內
  2. 設定 S3 當作 Web Hosting
  3. 測試 S3 Hosting

### 步驟一: 建立 index.html 放入 S3 內

建立 `content/index.html` 檔案，內容如下

<pre><code class="language-html"><html>
  <body>
    <h1>Hello Pulumi S3 Bucket</h1>
  </body>
</html></code></pre>

修改 `main.go`，將 `index.html` 加入到 S3 bucket 內

<pre><code class="language-go">        index := path.Join("content", "index.html")
        _, err = s3.NewBucketObject(ctx, "index.html", &s3.BucketObjectArgs{
            Bucket: bucket.Bucket,
            Source: pulumi.NewFileAsset(index),
        })

        if err != nil {
            return err
        }</code></pre>

其中目錄結構如下

<pre><code class="language-sh">├── demo
│   ├── Pulumi.dev.yaml
│   ├── Pulumi.yaml
│   ├── content
│   │   └── index.html
│   ├── go.mod
│   ├── go.sum
│   └── main.go</code></pre>

部署到 S3 Bucket 內

<pre><code class="language-sh">$ pulumi up
Previewing update (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/previews/a0ac1b69-06b9-4109-800d-20618b36e5c8

     Type                    Name        Plan
     pulumi:pulumi:Stack     demo-dev
 +   └─ aws:s3:BucketObject  index.html  create

Resources:
    + 1 to create
    2 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::demo::pulumi:pulumi:Stack::demo-dev]
    + aws:s3/bucketObject:BucketObject: (create)
        [urn=urn:pulumi:dev::demo::aws:s3/bucketObject:BucketObject::index.html]
        acl         : "private"
        bucket      : "foobar-1234"
        forceDestroy: false
        key         : "index.html"
        source      : asset(file:77aab46) { content/index.html }</code></pre>

### 步驟二: 設定 S3 為 Web Hosting

修改 main.go

<pre><code class="language-go">        bucket, err := s3.NewBucket(ctx, "my-bucket", &s3.BucketArgs{
            Bucket: pulumi.String("foobar-1234"),
            Website: s3.BucketWebsiteArgs{
                IndexDocument: pulumi.String("index.html"),
            },
        })

        index := path.Join("content", "index.html")
        _, err = s3.NewBucketObject(ctx, "index.html", &s3.BucketObjectArgs{
            Bucket:      bucket.Bucket,
            Source:      pulumi.NewFileAsset(index),
            Acl:         pulumi.String("public-read"),
            ContentType: pulumi.String(mime.TypeByExtension(path.Ext(index))),
        })</code></pre>

最後設定輸出 URL:

<pre><code class="language-go">ctx.Export("bucketEndpoint", bucket.WebsiteEndpoint)</code></pre>

最後完整程式碼如下:

<pre><code class="language-go">package main

import (
    "mime"
    "path"

    "github.com/pulumi/pulumi-aws/sdk/v3/go/aws/s3"
    "github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        // Create an AWS resource (S3 Bucket)
        bucket, err := s3.NewBucket(ctx, "my-bucket", &s3.BucketArgs{
            Bucket: pulumi.String("foobar-1234"),
            Website: s3.BucketWebsiteArgs{
                IndexDocument: pulumi.String("index.html"),
            },
        })
        if err != nil {
            return err
        }

        index := path.Join("content", "index.html")
        _, err = s3.NewBucketObject(ctx, "index.html", &s3.BucketObjectArgs{
            Bucket:      bucket.Bucket,
            Source:      pulumi.NewFileAsset(index),
            Acl:         pulumi.String("public-read"),
            ContentType: pulumi.String(mime.TypeByExtension(path.Ext(index))),
        })

        if err != nil {
            return err
        }

        // Export the name of the bucket
        ctx.Export("bucketID", bucket.ID())
        ctx.Export("bucketName", bucket.Bucket)
        ctx.Export("bucketEndpoint", bucket.WebsiteEndpoint)

        return nil
    })
}</code></pre>

執行 pulumi up

<pre><code class="language-sh">Previewing update (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/previews/edbaefca-f723-4ac5-aabd-7cb638636612

     Type                    Name        Plan       Info
     pulumi:pulumi:Stack     demo-dev
 ~   ├─ aws:s3:Bucket        my-bucket   update     [diff: +website]
 ~   └─ aws:s3:BucketObject  index.html  update     [diff: ~acl,contentType]

Outputs:
  + bucketEndpoint: output<string>

Resources:
    ~ 2 to update
    1 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::demo::pulumi:pulumi:Stack::demo-dev]
    ~ aws:s3/bucket:Bucket: (update)
        [id=foobar-1234]
        [urn=urn:pulumi:dev::demo::aws:s3/bucket:Bucket::my-bucket]
      + website: {
          + indexDocument: "index.html"
        }
    --outputs:--
  + bucketEndpoint: output<string>
    ~ aws:s3/bucketObject:BucketObject: (update)
        [id=index.html]
        [urn=urn:pulumi:dev::demo::aws:s3/bucketObject:BucketObject::index.html]
      ~ acl        : "private" => "public-read"
      ~ contentType: "binary/octet-stream" => "text/html; charset=utf-8"
Do you want to perform this update? yes
Updating (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/updates/7

     Type                    Name        Status      Info
     pulumi:pulumi:Stack     demo-dev
 ~   ├─ aws:s3:Bucket        my-bucket   updated     [diff: +website]
 ~   └─ aws:s3:BucketObject  index.html  updated     [diff: ~acl,contentType]

Outputs:
  + bucketEndpoint: "foobar-1234.s3-website-ap-northeast-1.amazonaws.com"
    bucketID      : "foobar-1234"
    bucketName    : "foobar-1234"

Resources:
    ~ 2 updated
    1 unchanged

Duration: 13s</code></pre>

### 步驟三: 測試 URL

透過底下指令可以拿到 S3 的 URL:

<pre><code class="language-sh">pulumi stack output bucketEndpoint</code></pre>

透過 CURL 指令測試看看

<pre><code class="language-sh">$ curl -v $(pulumi stack output bucketEndpoint)
*   Trying 52.219.16.96...
* TCP_NODELAY set
* Connected to foobar-1234.s3-website-ap-northeast-1.amazonaws.com (52.219.16.96) port 80 (#0)
> GET / HTTP/1.1
> Host: foobar-1234.s3-website-ap-northeast-1.amazonaws.com
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 200 OK
< x-amz-id-2: 0NrZfFxZNOs+toz0/86FiASG+MyQE6f+KbKNi4wzcDtmn5mTnQoxupVybR464X8Oi6HDMjSU+i8=
< x-amz-request-id: A55BD2534EDC94A9
< Date: Thu, 11 Feb 2021 03:30:42 GMT
< Last-Modified: Thu, 11 Feb 2021 03:29:14 GMT
< ETag: "46e94ba24774d0c4a768f9461e6b9806"
< Content-Type: text/html; charset=utf-8
< Content-Length: 70
< Server: AmazonS3
<
<html>
  <body>
    <h1>Hello Pulumi S3 Bucket</h1>
  </body>
</html>
* Connection #0 to host foobar-1234.s3-website-ap-northeast-1.amazonaws.com left intact</code></pre>

## 心得

上述已經可以將靜態網站放在 AWS S3 上面了，[下一篇][6]會教大家底下三個章節

  1. 設定 Pulumi Stack 環境變數
  2. 建立第二個 Pulumi Stack 環境
  3. 刪除 Pulumi Stack 環境

 [1]: https://lh3.googleusercontent.com/pw/ACtC-3f_62JD9fB_bxTcLFJRGhsADlda4hjJjFkzsuDAx0SnMTGZNlX0kl1j4n3WMpjBcPP9BpNOYrIVsy80vqXwjhKSLP7hH_d01FqpdCjA_S9cCdrBXnqE14LndovknJXimWkPHVKo56bcaJgP0SpqDw3Vog=w1283-h571-no?authuser=0 "cover"
 [2]: https://www.pulumi.com/docs/get-started/install/
 [3]: https://www.terraform.io/
 [4]: https://www.pulumi.com/
 [5]: https://github.com/go-training/infrastructure-as-code-workshop/tree/main/pulumi/labs/lab01-modern-infrastructure-as-code
 [6]: https://blog.wu-boy.com/2021/02/upload-static-content-to-aws-s3-using-pulumi-02/
 [7]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
