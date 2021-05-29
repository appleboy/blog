---
title: 初探 Infrastructure as Code 工具 Terraform vs Pulumi
author: appleboy
type: post
date: 2021-02-08T03:41:15+00:00
url: /2021/02/introduction-to-infrastructure-as-code-terraform-vs-pulumi/
dsq_thread_id:
  - 8388894370
categories:
  - DevOps
tags:
  - IaC
  - Infrastructure as code
  - pulumi
  - terraform

---
[![cover pulumi and terraform][1]][2]

想必大家對於 [Infrastructure as Code][3] 簡稱 (IaC) 並不陌生，而這個名詞在很早以前就很火熱，本篇最主要介紹為什麼我們要導入 IaC，以及該選擇哪些工具來管理雲平台 (AWS, GCP, Azure 等...)。觀看現在很火紅的 [Terraform][4] 及後起之秀 [Pulumi][5] 是大家可以作為選擇的參考，而底下會來歸納優缺點及技術比較，以及為什麼我最後會選擇 Pulumi。這兩套都是由 [Go 語言][6]所開發，現在選擇工具前，都要先考慮看看什麼語言寫的，以及整合進團隊自動化部署流程難易度。

<!--more-->

## 教學影片

{{< youtube jClYPLGZU >}}

  * 00:00 Infrastructure as code 簡介 (簡稱 IaC)
  * 00:43 資料工程師 Roadmap
  * 01:35 為什麼需要 IaC
  * 02:26 IaC 帶來什麼樣的好處及優勢
  * 04:20 工具的選擇 Pulumi vs Terraform
  * 04:52 Terraform 跟 Pulumi 基本介紹
  * 06:58 Terraform 代碼展示 (HCL)
  * 07:51 Pulumi 代碼展示 (Go 語言)
  * 08:43 Terraform 可否用程式語言撰寫?
  * 11:06 為什麼要選擇 Pulumi
  * 13:19 自行開發整合工具 (不用安裝 CLI)
  * 15:17 用 Pulumi 開發資料庫 Migration 流程

如果對於課程內容有興趣，可以參考底下課程。

  * [Go 語言基礎實戰 (開發, 測試及部署)][7]
  * [一天學會 DevOps 自動化測試及部署][8]
  * [DOCKER 容器開發部署實戰][9]

如果需要搭配購買請直接透過 [FB 聯絡我][10]，直接匯款（價格再減 **100**）

## IaC 帶來的好處

在沒有這些工具之前，大家土法煉鋼的就是手動連進去機器，不然就是透過 Web UI 畫面進行 VPC 或 EC2 的建置，這些步驟都沒有經過任何方式紀錄下來，也沒辦法透過 Review 的方式來避免人為上的操作，故現在有了一些工具，把這些實際上的操作，轉換成程式碼或者是其他文件格式像是 JSON 或 Yaml 等 ...，就可以解決蠻多之前無法避免的問題，底下是個人整理導入 IaC 所帶來的好處。

  1. 建置 CI/CD 自動化 (不用依賴 UI 操作)
  2. 版本控制 (大家可以一起 Review 避免錯誤)
  3. 重複使用 (減少建置時間)
  4. 環境一至性 (Testing, Staging, Production)
  5. 團隊成長 (分享學習資源)

個人覺得最後一點是最主要的考量，畢竟如果事情綁在一個人身上，最後沒人可以承接，會相當慘的，有時候技術就需要互相 Share，等到出狀況的時候，才可以互相 Cover。

## Pulumi vs Terraform

IaC 工具真的太多了，此篇先拿 Pulumi 跟 Terraform 來管理雲平台做比較。Terraform 在 2014 年由 [HashiCorp][11] 公司推出，由 Go 語言所撰寫，並自定義了 [HCL 語言][12] (HashiCorp configuration language)，所以如果要入門 Terraform 的話，你首先需要先熟悉 HCL 語法，熟悉到一定程度後，就可以開始撰寫 HCL 來管理雲平台。底下看看 HCL 語法

```yaml
data "aws_ami" "ubuntu_16_04_docker" {
  filter {
    name   = "name"
    values = ["app-base-docker-image-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["161654634948"] # Canonical
}

resource "aws_instance" "foobar_api_01" {
  ami                    = data.aws_ami.ubuntu_16_04_docker.id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.foobar_api.id]
  key_name               = aws_key_pair.foobar_deploy.key_name
  subnet_id              = aws_subnet.foobar_a.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_role.id

  tags = {
    Name        = "foobar api 01"
    Project     = "foobar"
    Environment = var.environment["production"]
  }
}
```

另外來看一下後起之秀 [Pulumi][5]，其實 Pulumi 是站在 [Terraform Provider][13] 的肩膀上發展出來，也就是 Pulumi 寫了 Terraform Provider 的 Bridge，所以 Terrafrom Provider 提供了各種雲平台的 CRUD 之後，開發者就可以透過自己喜歡的語言來撰寫整體架構跟流程。最後讓我選擇 Pulumi 最大的原因還是在於開發者可以透過自己喜歡的語言來做到一樣的事情，新人不用重新熟悉 HCL 語法，加上如果在整體架構上有些額外的需求像是變數或邏輯上 Loop 比較複雜，在 HCL 上面會比較難實現，但是對於自己熟悉的語言 (GO, Python, JS ... 等) 就可以很簡單的去實現出業務邏輯。

[![pulumi and terraform][14]][14]

## Pulumi 提供 Automation API

Terraform 跟 Pulumi 要使用前，一定需要安裝[各自的 CLI 工具][15]，並透過 up 或 preview 來檢視需要修正的部分，自動化部署就需要把 CLI 安裝好才算完成。但是就在 2020 年末，Pulumi 直接[推出 Automaton API][16]，讓開發者可以直接將流程整合進去自行開發的軟體架構，不再依賴 CLI 工具，簡單舉個例子，假設需要開一個 RDS 服務，這時開發者會透過 Pulumi 撰寫格式，程式碼如下:

```go=
    _, err = rds.NewClusterInstance(ctx, "dbInstance", &rds.ClusterInstanceArgs{
      ClusterIdentifier:  cluster.ClusterIdentifier,
      InstanceClass:      rds.InstanceType_T3_Small,
      Engine:             rds.EngineTypeAuroraMysql,
      EngineVersion:      pulumi.String("5.7.mysql_aurora.2.03.2"),
      PubliclyAccessible: pulumi.Bool(true),
      DbSubnetGroupName:  subnetGroup.Name,
    })
    if err != nil {
      return err
    }

    ctx.Export("host", cluster.Endpoint)
    ctx.Export("dbName", dbName)
    ctx.Export("dbUser", dbUser)
    ctx.Export("dbPass", dbPass)

```

當拿到 DB 相關資訊後，接著要做一些 Migration，開發者無法在 pulumi up 同時完成 Migration 動作，而現在透過 Automation API，就可以輕鬆完成這件事情:

```go=
  // create our stack with an "inline" Pulumi program (deployFunc)
  stack := auto.UpsertStackInlineSource(ctx, stackName, projectName, deployFunc)
  // run the update to deploy our database
  res, err := stack.Up(ctx, stdoutStreamer)

  fmt.Println("Update succeeded!")

  // get the connection info
  host := res.Outputs["host"].Value
  dbName := res.Outputs["dbName"].Value
  dbUser := res.Outputs["dbUser"].Value
  dbPass := res.Outputs["dbPass"].Value

  // establish db connection
  db := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:3306)/%s", dbUser, dbPass, host, dbName))
  defer db.Close()

  // run our database "migration"
  fmt.Println("creating table...")
  db.Query(`
  CREATE TABLE IF NOT EXISTS hello_pulumi(
    id int(9) NOT NULL,
    color varchar(14) NOT NULL,
    PRIMARY KEY(id)
  );
 `)

```

開發者現在可以輕易打造自己的服務，或撰寫好用的 CLI 工具提供給其他開發者使用，而這些工具都是透過 Pulumi API 輕鬆完成，再也不需要 Pulumi CLI 就可以完成這些事情。

 [1]: https://lh3.googleusercontent.com/pw/ACtC-3fJUweEGX-VoiJgesBpEaNM-N0ozaNkTrcCvzRxPCL22RzhuZNaA1fXVi0Gy_aNIAhP0mHlUHzV89DV9cr4Lwcmd6JTZ5ISTTzOvzyuLSOxraPtYK3lMDpcR1bKXv1dwLw5oApcmFwKhijmRi12fAiNkQ=w1228-h741-no?authuser=0 "cover pulumi and terraform"
 [2]: https://lh3.googleusercontent.com/4DRj7S_2u3Tw8P-_p0FOQ_RH25eDbx_Edasx9h52-1ouo-GGL31CuiLa2EcbPyu8uEkf5GTw45_4bfzO3IFCfDwBZol7D69mX1KP3EHAOFoNT1nKyUpdpmSUyTC8Y49ej02OEteWWLU=w1920-h1080 "cover pulumi and terraform"
 [3]: https://en.wikipedia.org/wiki/Infrastructure_as_code
 [4]: https://www.terraform.io/
 [5]: https://www.pulumi.com/
 [6]: https://golang.org/
 [7]: https://www.udemy.com/course/golang-fight/?couponCode=202101
 [8]: https://www.udemy.com/course/devops-oneday/?couponCode=202101
 [9]: https://www.udemy.com/course/docker-practice/?couponCode=202101
 [10]: http://facebook.com/appleboy46
 [11]: https://www.hashicorp.com/
 [12]: https://github.com/hashicorp/hcl
 [13]: https://www.terraform.io/docs/providers/index.html
 [14]: https://lh3.googleusercontent.com/kjQQMbSXbZeWjfRgiv4mF5XyIt0uFC9Xod0wfv_L2Cg9QEYR3wkEgPbn1ZhPj45CcKbs2P5-X01QsN_MvpyCLcKOsxNo4hiesTW-C7tY8t8ZJF1ju9aeqivmf9bJHUB5yLOAbxYHlZ4=w1920-h1080 "pulumi and terraform"
 [15]: https://www.pulumi.com/docs/reference/cli/
 [16]: https://www.pulumi.com/blog/automation-api/
