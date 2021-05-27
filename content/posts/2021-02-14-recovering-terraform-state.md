---
title: 搶救 Terraform State 檔案
author: appleboy
type: post
date: 2021-02-14T13:59:28+00:00
url: /2021/02/recovering-terraform-state/
dsq_thread_id:
  - 8397612909
categories:
  - DevOps
tags:
  - devops
  - terraform

---
![recovery the terraform state file][1]

近期其中一個專案使用 Terraform 來管理 AWS 雲平台，初期預計只有我一個人在使用 Terraform，所以就沒有將 [Backend State][2] 放在 AWS S3 進行備份管理，這個粗心大意讓我花了大半時間來搶救 State (.tfstate) 檔案，而搶救過程也是蠻順利的，只是需要花時間用 **[terraform import][3]** 指令將所有的 State 狀態全部轉回來一次，當然不是每個 Resource 都可以正常運作，還是需要搭配一些修正才能全部轉換。

結論: 請使用 `terraform import` 指令，這是最終解法。

<!--more-->

## 教學影片

  * 00:00 為什麼需要搶救 Terraform state 檔案
  * 02:10 步驟一: 使用 Terraform refres 指令
  * 04:00 步驟二: 使用 Terraform import 指令
  * 09:15 步驟三: 將 State 備份到 S3 上面並且做版本控制

## 步驟一: 使用 terraform refresh

先用 [terraform refresh][4] 將所有 tf 檔案內的 `data` 框架內容讀取進來，像是底下格式:

```tf
data "aws_acm_certificate" "example_com" {
  domain = "*.example.com"
  types  = ["IMPORTED"]
}
```

或是

```yaml
data "aws_ami" "ubuntu_16_04" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "image-id"
    values = ["ami-0d97809b54a5f01ba"]
  }

  owners = ["099720109477"] # Canonical
}
```

這時候你可以看到專案底下多了 `terraform.tfstate` 檔案，記錄了這些檔案資料。

## 步驟二: 用 terraform import

這邊沒啥技巧，就是使用 terraform import 將剩下的 resource 慢慢匯入進來，此步驟需要花蠻多時間的，請大家慢慢操作跟使用，後續搭配 terraform plan 方式來看看有哪些資源還沒匯入，最重要的是一些機器的資源匯入，像是 EC2, RDS 等.. 這些是非常重要的部分。像是我這邊遇到，原本建立 RDS 的密碼都是透過 `random_string`

```yaml
resource "random_string" "db_password" {
  special = false
  length  = 20
}
```

這邊你就需要把這邊整段拿掉，並且在 RDS 那邊把密碼欄位拿掉，否則你會發現密碼會被重新產生。只要是有產生動態密碼的地方，請務必小心，該拿掉的地方還是要拿掉，最後請務必把 `terraform plan` 檢查清楚，最後才下 `terraform apply`。

## 步驟三: 上傳 state 到 S3

有了這次經驗，上述完成步驟二，整個更新 infra 也沒問題後，就需要把本機端的 state 上傳到 AWS S3 進行備份，並且做版本控制啊。打開 `main.tf`

```yaml
terraform {
  backend "s3" {
    bucket = "xxxxx.backup"
    key    = "terraform/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
```

存檔後，直接下 terraform init 就會將檔案直接轉到 AWS S3 上了。

 [1]: https://lh3.googleusercontent.com/3ZDBZ2vZbRS1NTRzSg1ftpwIhEltm9iPe4-DFNE4y6yuLxbsvxGd6UQfLwcSvHb-AhGBcmtK36NiWBT1BeUzE8ra713qNV-cFnDk2pSVP_mqpz_MG5bpNg0Yx8jZc2-wlkOTb-xk1FE=w1920-h1080
 [2]: https://www.terraform.io/docs/language/settings/backends/index.html
 [3]: https://www.terraform.io/docs/cli/import/index.html
 [4]: https://www.terraform.io/docs/cli/commands/refresh.html