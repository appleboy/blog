---
title: 初探 Pulumi 上傳靜態網站到 AWS S3 (二)
author: appleboy
type: post
date: 2021-02-11T07:55:36+00:00
url: /2021/02/upload-static-content-to-aws-s3-using-pulumi-02/
dsq_thread_id:
  - 8393290344
categories:
  - DevOps
  - Golang
tags:
  - golang
  - pulumi

---
[![cover][1]][1]

上一篇『[初探 Pulumi 上傳靜態網站到 AWS S3 (一)][2]』主要介紹 Pulumi 基本使用方式，而本篇會延續上一篇教學把剩下的章節教完，底下是本篇會涵蓋的章節內容:

  1. 設定 Pulumi Stack 環境變數
  2. 建立第二個 Pulumi Stack 環境
  3. 刪除 Pulumi Stack 環境

讓開發者可以自由新增各種不同環境，像是 Testing 或 Develop 環境，以及該如何動態帶入不同環境的變數內容，最後可以透過單一指令將全部資源刪除。

<!--more-->

## 教學影片

  * 00:00​ Pulumi 教學內容簡介 (Stack 介紹)
  * 01:04​ 設定 Pulumi Stack 環境變數
  * 05:04​ 用 Go 語言讀取多個檔案上傳到 AWS S3
  * 08:04​ 用 Pulumi 建立多個開發環境
  * 09:00​ 用 pulumi config 設定環境參數
  * 12:35​ 如何清除單一 Pulumi Stack 環境
  * 15:30​ Pulumi 管理 AWS 心得

## 設定 Pulumi Stack 環境變數

大家可以看到，現在所有 `main.go` 的程式碼，都是直接 hardcode 的，那怎麼透過一些環境變數來動態改變設定呢？這時候可以透過 pulumi config 指令來調整喔，底下來看看怎麼實作，假設我們要讀取的 index.html 放在其他目錄底下，該怎麼動態調整？

### 步驟一: 撰寫讀取 Config 函式

<pre><code class="language-go">func getEnv(ctx *pulumi.Context, key string, fallback ...string) string {
    if value, ok := ctx.GetConfig(key); ok {
        return value
    }

    if len(fallback) &gt; 0 {
        return fallback[0]
    }

    return ""
}</code></pre>

pulumi 的 context 內有一個讀取環境變數函式叫 `GetConfig`，接著我們在設計一個 fallback 當作 default 回傳值。底下設定一個變數 `s3:siteDir`

<pre><code class="language-sh">pulumi config set s3:siteDir production</code></pre>

打開 `Pulumi.dev.yaml` 可以看到

<pre><code class="language-yaml">config:
  aws:profile: demo
  aws:region: ap-northeast-1
  s3:siteDir: production</code></pre>

接著將程式碼改成如下:

<pre><code class="language-go">        site := getEnv(ctx, "s3:siteDir", "content")
        index := path.Join(site, "index.html")
        _, err = s3.NewBucketObject(ctx, "index.html", &s3.BucketObjectArgs{
            Bucket:      bucket.Bucket,
            Source:      pulumi.NewFileAsset(index),
            Acl:         pulumi.String("public-read"),
            ContentType: pulumi.String(mime.TypeByExtension(path.Ext(index))),
        })</code></pre>

### 步驟二: 更新 Infrastructure

<pre><code class="language-sh">$ pulumi up
Previewing update (dev)

View Live: https://app.pulumi.com/appleboy/demo/dev/previews/d76d2f9b-16c8-4bfd-820d-d5368d29f592

     Type                    Name        Plan       Info
     pulumi:pulumi:Stack     demo-dev
 ~   └─ aws:s3:BucketObject  index.html  update     [diff: ~source]

Resources:
    ~ 1 to update
    2 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::demo::pulumi:pulumi:Stack::demo-dev]
    ~ aws:s3/bucketObject:BucketObject: (update)
        [id=index.html]
        [urn=urn:pulumi:dev::demo::aws:s3/bucketObject:BucketObject::index.html]
      - source: asset(file:77aab46) { content/index.html }
      + source: asset(file:01c09f4) { production/index.html }</code></pre>

可以看到 source 會被換成 `production/index.html`

### 步驟三: 讀取更多檔案

整個 Web 專案肯定不止一個檔案，所以再來改一下原本的讀取檔案列表流程

<pre><code class="language-go">        site := getEnv(ctx, "s3:siteDir", "content")
        files, err := ioutil.ReadDir(site)
        if err != nil {
            return err
        }

        for _, item := range files {
            name := item.Name()
            if _, err = s3.NewBucketObject(ctx, name, &s3.BucketObjectArgs{
                Bucket:      bucket.Bucket,
                Source:      pulumi.NewFileAsset(filepath.Join(site, name)),
                Acl:         pulumi.String("public-read"),
                ContentType: pulumi.String(mime.TypeByExtension(path.Ext(filepath.Join(site, name)))),
            }); err != nil {
                return err
            }
        }</code></pre>

執行部署

<pre><code class="language-sh">     Type                    Name        Status      Info
     pulumi:pulumi:Stack     demo-dev
 +   ├─ aws:s3:BucketObject  about.html  created
 ~   └─ aws:s3:BucketObject  index.html  updated     [diff: ~source]

Outputs:
    bucketEndpoint: "foobar-1234.s3-website-ap-northeast-1.amazonaws.com"
    bucketID      : "foobar-1234"
    bucketName    : "foobar-1234"

Resources:
    + 1 created
    ~ 1 updated
    2 changes. 2 unchanged

Duration: 9s</code></pre>

完整程式碼如下:

<pre><code class="language-go">package main

import (
    "io/ioutil"
    "mime"
    "path"
    "path/filepath"

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

        site := getEnv(ctx, "s3:siteDir", "content")
        files, err := ioutil.ReadDir(site)
        if err != nil {
            return err
        }

        for _, item := range files {
            name := item.Name()
            if _, err = s3.NewBucketObject(ctx, name, &s3.BucketObjectArgs{
                Bucket:      bucket.Bucket,
                Source:      pulumi.NewFileAsset(filepath.Join(site, name)),
                Acl:         pulumi.String("public-read"),
                ContentType: pulumi.String(mime.TypeByExtension(path.Ext(filepath.Join(site, name)))),
            }); err != nil {
                return err
            }
        }

        // Export the name of the bucket
        ctx.Export("bucketID", bucket.ID())
        ctx.Export("bucketName", bucket.Bucket)
        ctx.Export("bucketEndpoint", bucket.WebsiteEndpoint)

        return nil
    })
}

func getEnv(ctx *pulumi.Context, key string, fallback ...string) string {
    if value, ok := ctx.GetConfig(key); ok {
        return value
    }

    if len(fallback) &gt; 0 {
        return fallback[0]
    }

    return ""
}</code></pre>

## 建立第二個 Pulumi Stack 環境

在 Pulumi 可以很簡單的建立多種環境，像是 Testing 或 Production，只要將動態變數抽出來設定成 config 即可。底下來看看怎麼建立全先的環境，這步驟在 Pulumi 叫做 Stack。前面已經建立一個 dev 環境，現在我們要建立一個全新環境來部署 Testing 或 Production 該如何做呢？

### 步驟一: 建立全新 Stack 環境

透過 pulumi stack 可以建立全新環境

<pre><code class="language-sh">$ pulumi stack ls
NAME  LAST UPDATE   RESOURCE COUNT  URL
dev*  1 minute ago  5               https://app.pulumi.com/appleboy/demo/dev</code></pre>

建立 stack

<pre><code class="language-sh">$ pulumi stack init prod
Created stack &#039;prod&#039;
$ pulumi stack ls
NAME   LAST UPDATE   RESOURCE COUNT  URL
dev    1 minute ago  5               https://app.pulumi.com/appleboy/demo/dev
prod*  n/a           n/a             https://app.pulumi.com/appleboy/demo/prod</code></pre>

設定參數

<pre><code class="language-sh">pulumi config set s3:siteDir www
pulumi config set aws:profile demo
pulumi config set aws:region ap-northeast-1</code></pre>

### 步驟二: 建立 www 內容

建立 `content/www` 目錄，一樣放上 index.htm + about.html

<pre><code class="language-html">&lt;html&gt;
  &lt;body&gt;
    &lt;h1&gt;Hello Pulumi S3 Bucket From New Stack&lt;/h1&gt;
  &lt;/body&gt;
&lt;/html&gt;</code></pre>

about.html

<pre><code class="language-html">&lt;html&gt;
  &lt;body&gt;
    &lt;h1&gt;About us From New Stack&lt;/h1&gt;
  &lt;/body&gt;
&lt;/html&gt;</code></pre>

### 步驟三: 部署 New Stack

先看看 Preview 結果

<pre><code class="language-sh">$ pulumi up
Previewing update (prod)

View Live: https://app.pulumi.com/appleboy/demo/prod/previews/3b85a340-0e71-455e-9b96-48dc38538d18

     Type                    Name        Plan
 +   pulumi:pulumi:Stack     demo-prod   create
 +   ├─ aws:s3:Bucket        my-bucket   create
 +   ├─ aws:s3:BucketObject  index.html  create
 +   └─ aws:s3:BucketObject  about.html  create

Resources:
    + 4 to create

Do you want to perform this update? details
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:prod::demo::pulumi:pulumi:Stack::demo-prod]
    + aws:s3/bucket:Bucket: (create)
        [urn=urn:pulumi:prod::demo::aws:s3/bucket:Bucket::my-bucket]
        acl         : "private"
        bucket      : "my-bucket-ba8088c"
        forceDestroy: false
        website     : {
            indexDocument: "index.html"
        }
    + aws:s3/bucketObject:BucketObject: (create)
        [urn=urn:pulumi:prod::demo::aws:s3/bucketObject:BucketObject::index.html]
        acl         : "public-read"
        bucket      : "my-bucket-ba8088c"
        contentType : "text/html; charset=utf-8"
        forceDestroy: false
        key         : "index.html"
        source      : asset(file:460188b) { www/index.html }
    + aws:s3/bucketObject:BucketObject: (create)
        [urn=urn:pulumi:prod::demo::aws:s3/bucketObject:BucketObject::about.html]
        acl         : "public-read"
        bucket      : "my-bucket-ba8088c"
        contentType : "text/html; charset=utf-8"
        forceDestroy: false
        key         : "about.html"
        source      : asset(file:376c42a) { www/about.html }</code></pre>

如果看起來沒問題，就可以直接執行了

<pre><code class="language-sh">Updating (prod)

View Live: https://app.pulumi.com/appleboy/demo/prod/updates/1

     Type                    Name        Status
 +   pulumi:pulumi:Stack     demo-prod   created
 +   ├─ aws:s3:Bucket        my-bucket   created
 +   ├─ aws:s3:BucketObject  about.html  created
 +   └─ aws:s3:BucketObject  index.html  created

Outputs:
    bucketEndpoint: "my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com"
    bucketID      : "my-bucket-a7044ab"
    bucketName    : "my-bucket-a7044ab"

Resources:
    + 4 created

Duration: 18s</code></pre>

最後用 curl 執行看看

<pre><code class="language-sh">$ curl -v $(pulumi stack output bucketEndpoint)
*   Trying 52.219.8.20...
* TCP_NODELAY set
* Connected to my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com (52.219.8.20) port 80 (#0)
> GET / HTTP/1.1
> Host: my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com
> User-Agent: curl/7.64.1
> Accept: */*
>
&lt; HTTP/1.1 200 OK
&lt; x-amz-id-2: oGxc+rLPi3kLOZslMsOmJqPY/WGeMoxX9sXJDRj4wlJlGVq+7pMx3ers71jxnDiDkeM9JRrd+T8=
&lt; x-amz-request-id: 528235DDFF40F365
&lt; Date: Thu, 11 Feb 2021 04:49:21 GMT
&lt; Last-Modified: Thu, 11 Feb 2021 04:48:41 GMT
&lt; ETag: "ae41d1b3f0aeef6a490e1b2edc74d2b5"
&lt; Content-Type: text/html; charset=utf-8
&lt; Content-Length: 85
&lt; Server: AmazonS3
&lt;
&lt;html&gt;
  &lt;body&gt;
    &lt;h1&gt;Hello Pulumi S3 Bucket From New Stack&lt;/h1&gt;
  &lt;/body&gt;
&lt;/html&gt;
* Connection #0 to host my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com left intact
* Closing connection 0</code></pre>

## 刪除 Pulumi Stack 環境

最後步驟就是要學習怎麼一鍵刪除整個 Infrastructure 環境。現在我們已經建立兩個 Stack 環境，該怎麼移除？

### 步驟一: 刪除所有資源

用 `pulumi destroy` 指令可以刪除全部資源

<pre><code class="language-sh">Previewing destroy (prod)

View Live: https://app.pulumi.com/appleboy/demo/prod/previews/92f9c4a4-f4a9-464d-be27-5040aff295ae

     Type                    Name        Plan
 -   pulumi:pulumi:Stack     demo-prod   delete
 -   ├─ aws:s3:BucketObject  about.html  delete
 -   ├─ aws:s3:BucketObject  index.html  delete
 -   └─ aws:s3:Bucket        my-bucket   delete

Outputs:
  - bucketEndpoint: "my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com"
  - bucketID      : "my-bucket-a7044ab"
  - bucketName    : "my-bucket-a7044ab"

Resources:
    - 4 to delete

Do you want to perform this destroy? details
- aws:s3/bucketObject:BucketObject: (delete)
    [id=about.html]
    [urn=urn:pulumi:prod::demo::aws:s3/bucketObject:BucketObject::about.html]
- aws:s3/bucketObject:BucketObject: (delete)
    [id=index.html]
    [urn=urn:pulumi:prod::demo::aws:s3/bucketObject:BucketObject::index.html]
- aws:s3/bucket:Bucket: (delete)
    [id=my-bucket-a7044ab]
    [urn=urn:pulumi:prod::demo::aws:s3/bucket:Bucket::my-bucket]
- pulumi:pulumi:Stack: (delete)
    [urn=urn:pulumi:prod::demo::pulumi:pulumi:Stack::demo-prod]
    --outputs:--
  - bucketEndpoint: "my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com"
  - bucketID      : "my-bucket-a7044ab"
  - bucketName    : "my-bucket-a7044ab"</code></pre>

選擇 `yse` 移除所以資源

<pre><code class="language-sh">Destroying (prod)

View Live: https://app.pulumi.com/appleboy/demo/prod/updates/2

     Type                    Name        Status
 -   pulumi:pulumi:Stack     demo-prod   deleted
 -   ├─ aws:s3:BucketObject  index.html  deleted
 -   ├─ aws:s3:BucketObject  about.html  deleted
 -   └─ aws:s3:Bucket        my-bucket   deleted

Outputs:
  - bucketEndpoint: "my-bucket-a7044ab.s3-website-ap-northeast-1.amazonaws.com"
  - bucketID      : "my-bucket-a7044ab"
  - bucketName    : "my-bucket-a7044ab"

Resources:
    - 4 deleted

Duration: 7s</code></pre>

### 步驟二: 移除 Stack 設定

上面步驟只是把所有資源移除，但是你還是保留了所以 stack history 操作，請看

<pre><code class="language-sh">$ pulumi stack history
Version: 2
UpdateKind: destroy
Status: succeeded
Message: chore(pulumi): 設定 Pulumi Stack 環境變數
+0-4~0 0 Updated 1 minute ago took 8s
    exec.kind: cli
    git.author: Bo-Yi Wu
    git.author.email: xxxxxxxx@gmail.com
    git.committer: Bo-Yi Wu
    git.committer.email: xxxxxxxx@gmail.com
    git.dirty: true
    git.head: 9d9f8182abefb0e90656ca45065bc07a8a3431f4
    git.headName: refs/heads/main
    vcs.kind: github.com
    vcs.owner: go-training
    vcs.repo: infrastructure-as-code-workshop

Version: 1
UpdateKind: update
Status: succeeded
Message: chore(pulumi): 設定 Pulumi Stack 環境變數
+4-0~0 0 Updated 8 minutes ago took 18s
    exec.kind: cli
    git.author: Bo-Yi Wu
    git.author.email: xxxxxxxx@gmail.com
    git.committer: Bo-Yi Wu
    git.committer.email: xxxxxxxx@gmail.com
    git.dirty: true
    git.head: 437e94e130ee3d31eb80075dd237cc17d09255d1
    git.headName: refs/heads/main
    vcs.kind: github.com
    vcs.owner: go-training
    vcs.repo: infrastructure-as-code-workshop</code></pre>

要整個完整移除，請務必要執行底下指令

<pre><code class="language-sh">pulumi stack rm</code></pre>

最後的確認

<pre><code class="language-sh">$ pulumi stack rm
This will permanently remove the &#039;prod&#039; stack!
Please confirm that this is what you&#039;d like to do by typing ("prod"):</code></pre>

### 移除其他的 Stack

按照上面的步驟重新移除其他的 Stack，先使用底下指令列出還有哪些 Stack:

<pre><code class="language-sh">$ pulumi stack ls
NAME  LAST UPDATE     RESOURCE COUNT  URL
dev   24 minutes ago  5               https://app.pulumi.com/appleboy/demo/dev</code></pre>

選擇 Stack

<pre><code class="language-sh">pulumi stack select dev</code></pre>

接著重複上面一跟二步驟即可

## 心得

本篇跟[上一篇][2]教學剛好涵蓋了整個 Pulumi 的基本使用方式，如果你還在選擇要用 [Terraform][3] 還是 [Pulumi][4]，甚至 AWS 所推出的 [CDK][5]，很推薦你嘗試看看 Pulumi，未來會介紹更多 Pulumi 進階的使用方式，或者像是部署 [Kubernetes][6] .. 等，能使用自己喜歡的語言寫 Infra 是一件令人舒服的事情。

 [1]: https://lh3.googleusercontent.com/pw/ACtC-3f_62JD9fB_bxTcLFJRGhsADlda4hjJjFkzsuDAx0SnMTGZNlX0kl1j4n3WMpjBcPP9BpNOYrIVsy80vqXwjhKSLP7hH_d01FqpdCjA_S9cCdrBXnqE14LndovknJXimWkPHVKo56bcaJgP0SpqDw3Vog=w1283-h571-no?authuser=0 "cover"
 [2]: https://blog.wu-boy.com/2021/02/upload-static-content-to-aws-s3-using-pulumi-01/
 [3]: https://www.terraform.io/
 [4]: https://www.pulumi.com/
 [5]: https://docs.aws.amazon.com/cdk/latest/guide/home.html
 [6]: https://kubernetes.io/