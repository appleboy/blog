---
title: "用 Terraform 初始化 GCP 環境"
date: 2023-05-27T10:50:33+08:00
author: appleboy
type: post
slug: initialize-gcp-environment-using-terraform
share_img: https://lh3.googleusercontent.com/pw/AJFCJaWyFC1UXBwtZxoLTamoUztI0cikLLTKKf_wugXxkeQxOsXODnMs8fMiO_BcJuC6sF5f9vzfM5s0Q-wMMjuCzvx3OwmEVnnxENYALUhOXaoBxtsu3v5_DomatQM70DpkNqSv5hYdX7NKHqLzK9-E0QLmrA=w678-h677-s-no?authuser=0
categories:
  - terraform
  - GCP
---

![logo](https://lh3.googleusercontent.com/pw/AJFCJaWyFC1UXBwtZxoLTamoUztI0cikLLTKKf_wugXxkeQxOsXODnMs8fMiO_BcJuC6sF5f9vzfM5s0Q-wMMjuCzvx3OwmEVnnxENYALUhOXaoBxtsu3v5_DomatQM70DpkNqSv5hYdX7NKHqLzK9-E0QLmrA=w678-h677-s-no?authuser=0)

我們將使用 [Terraform][1] 來初始化 [GCP 環境][2]。從建立 Service Account 到 GCS 並且將 Terraform State 儲存做版本控制，這篇文章將會一步一步帶領您完成。

[1]:https://developer.hashicorp.com/terraform/intro
[2]:https://cloud.google.com/

<!--more-->

## 前置作業

### 安裝 Terraform

請參考 [Terraform 官方文件](https://learn.hashicorp.com/tutorials/terraform/install-cli) 安裝 Terraform。MacOS 可以使用 Homebrew 安裝：

```bash
brew install terraform
```

### 安裝 Google Cloud SDK

請參考 [Google Cloud SDK 官方文件](https://cloud.google.com/sdk/docs/install) 安裝 Google Cloud SDK。MacOS 可以使用 Homebrew 安裝：

```bash
brew install --cask google-cloud-sdk
```

安裝完成後，請使用以下指令登錄您的 Google Cloud 帳號：

```bash
gcloud auth application-default login
```

## 在 GCP 上面建立 Service Account

確保已經安裝並設置了 Google Cloud SDK，並且已經登錄到您的 Google Cloud 帳號。您可以執行以下指令來檢查是否正確安裝了 gcloud 工具：

```bash
$ gcloud version
Google Cloud SDK 432.0.0
bq 2.0.93
core 2023.05.19
gcloud-crc32c 1.0.0
gke-gcloud-auth-plugin 0.5.3
gsutil 5.24
```

接下來，使用以下指令建立 service account：

```bash
gcloud iam service-accounts create [SERVICE_ACCOUNT_NAME] \
  --display-name "[DISPLAY_NAME]"
```

將 `[SERVICE_ACCOUNT_NAME]` 替換為您想要建立的 service account 名稱，並將 `[DISPLAY_NAME]` 替換為適當的顯示名稱。

建立 service account 後，您可以為該帳號新增所需的角色/權限。例如，如果要將 service account 分配為專案的所有者，請執行以下指令：

```bash
gcloud projects add-iam-policy-binding [PROJECT_ID] \
    --member "serviceAccount:[SERVICE_ACCOUNT_EMAIL]" \
    --role roles/owner
```

將 `[PROJECT_ID]` 替換為您的專案 ID，將 `[SERVICE_ACCOUNT_EMAIL]` 替換為剛剛建立的 service account 的電子郵件地址。

完成以上步驟後，您已成功使用 gcloud 指令建立了一個 service account，並為其分配了適當的角色/權限。接下來，您可以使用以下指令建立一個 service account 金鑰：

```bash
gcloud iam service-accounts keys create [FILE_NAME].json \
  --iam-account [SERVICE_ACCOUNT_EMAIL]
```

將 `[FILE_NAME]` 替換為您想要建立的金鑰檔案名稱，將 `[SERVICE_ACCOUNT_EMAIL]` 替換為剛剛建立的 service account 的電子郵件地址。請將此金鑰檔案妥善保存，因為您稍後將需要使用它。

## 建立 Terraform 設定檔

請參考 [Terraform 官方文件](https://learn.hashicorp.com/tutorials/terraform/gcp-build?in=terraform/gcp-get-started) 建立 Terraform 設定檔。您可以使用以下指令初始化 Terraform：

```bash
terraform init
```

接下來，請將 `main.tf` 檔案內的 `project`、`credentials`、`region`、`zone` 設定為您的 GCP 專案資訊：

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.66.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project     = "your-project-id"
  credentials = file("your-service-account-key.json")
  region      = "asia-east1"
  zone        = "asia-east1-a"
}
```

其中 credentials 參數為您剛剛建立的 service account 金鑰檔案。這邊可以用 `terraform.tfvars` 來設定：

```hcl
project     = "your-project-id"
credentials = "your-service-account-key.json"
region      = "asia-east1"
zone        = "asia-east1-a"
```

除了設定 `credentials` 之外，您也可以使用 `GOOGLE_APPLICATION_CREDENTIALS` 環境變數來設定 service account 金鑰檔案的路徑：

```bash
export GOOGLE_APPLICATION_CREDENTIALS="your-service-account-key.json"
```

## 建立 GCP 資源

建立 main.tf 檔案

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.66.0"
    }
  }

  required_version = ">= 0.14"
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

建立 VPC 資源

```hcl
# VPC
resource "google_compute_network" "tf-vpc" {
  name                    = "${var.project_id}-tf-vpc"
  auto_create_subnetworks = "false"
}
```

完成以上步驟後，您可以使用以下指令來預覽 Terraform 將要建立的資源：

```bash
terraform plan
```

如果預覽結果沒有問題，您可以使用以下指令來建立資源：

```bash
terraform apply
```

## 儲存 Terraform 狀態到 GCS

執行完上述步驟後，您可以發現在目錄底下多了一個 `terraform.tfstate` 檔案，這個檔案是用來記錄 Terraform 管理的資源狀態，以及資源間的關聯性。如果您想要將這個檔案儲存到 GCS，可以用 Terraform 建立 GCS 相關資源

```hcl
# GCS
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "tf-state-bucket-demo" {
  name     = "tf-state-bucket-demo-${random_id.bucket_prefix.hex}"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
```

輸出 GCS bucket 名稱

```hcl
output "tf_state_bucket" {
  value = google_storage_bucket.tf-state-bucket.name
}
```

可以看到底下結果

```bash
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

tf_state_bucket = tf-state-bucket-demo-5704c463dc9b78df
```

打開 main.tf 檔案，加入以下設定到 terraform 主設定：

```hcl
  backend "gcs" {
    bucket = "tf-state-bucket-demo-5704c463dc9b78df"
    prefix = "terraform/state"
  }
```

再進行一次 `terraform init`，就會看到底下結果

```bash
Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "gcs" backend. No existing state was found in the newly
  configured "gcs" backend. Do you want to copy this state to the new "gcs"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value:
```

輸入 `yes`，就會看到底下結果

```bash
Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed hashicorp/google v4.66.0
- Using previously-installed hashicorp/random v3.5.1

Terraform has been successfully initialized!
```

這樣就可以透過 GCS 進行 Terraform 狀態的儲存及版本控制了。最後可以將底下檔案刪除

```bash
rm terraform.tfstate
rm terraform.tfstate.backup
```

## 刪除 GCP 資源

如果您想要刪除剛剛建立的資源，可以使用以下指令：

```bash
terraform destroy
```

## 參考資料

* [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
* [Terraform GCP Backend](https://www.terraform.io/docs/language/settings/backends/gcs.html)
* [Terraform GCP Storage Bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
* [Store Terraform state in a Cloud Storage bucket](https://cloud.google.com/docs/terraform/resource-management/store-state)
* [Provision a GKE Cluster (Google Cloud)](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)
