---
title: 用 Drone CI/CD 整合 Packer 自動產生 GCP 或 AWS 映像檔
author: appleboy
type: post
date: 2018-07-29T10:57:21+00:00
url: /2018/07/drone-with-hashicorp-packer/
dsq_thread_id:
  - 6823588785
categories:
  - DevOps
  - Drone CI
tags:
  - drone
  - hashicorp
  - packer

---
[<img src="https://i1.wp.com/farm1.staticflickr.com/856/43657047222_387563a137_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-07-29 at 12.47.51 PM" data-recalc-dims="1" />][1] 

本篇來介紹 [Hashicorp][2] 旗下其中一個產品叫 [Packer][3]，其實在 Hashicorp 旗下有很多其他雲端工具都非常好用，如果大家有興趣都可以上[官網][2]參考看看。而 Packer 是用來產生各大雲平台映像檔的工具，平行產生 [AWS][4], [GCP][5], [Docker][6] 或 [DigitalOcean][7] ... 等等眾多雲平台之映像檔對 Packer 來說相當容易，詳細可以[參考這邊][8]，也就是說透過 Packer 來統一管理各大雲平台的映像檔，用 JSON 檔案進行版本控制。假設您有需求要管理工程團隊所使用的 Image，你絕對不能錯過 Packer。Packer 不是用來取代像是 [Ansible][9] 或是 [Chef][10] 等軟體，而是讓開發者更方便整合 Ansible .. 等第三方工具，快速安裝好系統環境。 <!--more-->

## 影片教學 

{{< youtube oR3wbdYikIQ >}}

如果不想看底下文字介紹，可以直接參考 Youtube 影片: 如果您對 Drone 整合 Docker 有興趣，可以直接參考線上課程 

  * [一天學會 DEVOPS 自動化流程][11] $1800 

買了結果沒興趣想退費怎麼辦？沒關係，在 Udemy 平台 30 天內都可以全額退費，所以不用擔心買了後悔。 

## 自動建立 AWS AMI 映像檔

不多說直接拿實際例子來實做看看，假設我們有個需求，就是需要產生一個 AMI 裡面已經內建包含了 Docker 服務，該如何來實現呢？底下是 Packer 所撰寫的 JSON 檔案，底下範例可以直接在[這邊][12]找到

```bash
{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "ssh_bastion_host": "",
    "ssh_bastion_port": "22",
    "ssh_bastion_username": "",
    "ssh_bastion_private_key_file": "",
    "region": "ap-southeast-1"
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "{{user `region`}}",
    "source_ami_filter": {
      "filters": {
        "virtualization-type": "hvm",
        "name": "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*",
        "root-device-type": "ebs"
      },
      "owners": ["099720109477"],
      "most_recent": true
    },
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "ggz-docker-image-{{isotime | clean_ami_name}}",
    "tags": {
      "Name": "ggz",
      "Environment": "production"
    },
    "communicator": "ssh",
    "ssh_bastion_host": "{{user `ssh_bastion_host`}}",
    "ssh_bastion_port": "{{user `ssh_bastion_port`}}",
    "ssh_bastion_username": "{{user `ssh_bastion_username`}}",
    "ssh_bastion_private_key_file": "{{user `ssh_bastion_private_key_file`}}"
  }],
  "provisioners": [{
      "type": "file",
      "source": "{{template_dir}}/welcome.txt",
      "destination": "/home/ubuntu/"
    },
    {
      "type": "shell",
      "script": "{{template_dir}}/docker.sh",
      "execute_command": "echo 'ubuntu' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    }
  ]
}
```

第一部分 `variables` 讓開發者可以定義變數，可以讀取系統環境變數，第二部分 `builders` 就是用來定義要產生不同平台的 Image，像是 GCP 或 AWS，可以看到是傳入一個 Array 值，上面的例子就是要產生 [AWS AMI][13]，所以設定 `"type": "amazon-ebs"`，第三部分 `provisioners`，就是來寫 script，映像檔預設可能會有一些檔案，或者是預設安裝一些工具，看到 type 可以是 `file`、`shell` 等等，也就是說 `provisioners` 可以讓開發者安裝套件，更新 Kernel，建立使用者，或者是安裝下載 application source code。這對於部署來說是一個非常棒的工具。 

## 執行 Packer 

完成上述 JSON 檔案後，就可以透過 Packer 來產生 [AWS AMI][13] 了 

```bash
$ packer build -var-file=config/mcs.json mcs.json
amazon-ebs output will be in this color.

==> amazon-ebs: Prevalidating AMI Name: ggz-docker-image-2018-07-29T06-11-12Z
    amazon-ebs: Found Image ID: ami-1c6627f6
==> amazon-ebs: Creating temporary keypair: packer_5b5d5a80-c1e2-e266-e0b8-bc7c6e63dba3
==> amazon-ebs: Creating temporary security group for this instance: packer_5b5d5a82-5d1f-c702-18f4-992ac37e885a
==> amazon-ebs: Authorizing access to port 22 from 0.0.0.0/0 in the temporary security group...
==> amazon-ebs: Launching a source AWS instance...
==> amazon-ebs: Adding tags to source instance
    amazon-ebs: Adding tag: "Name": "Packer Builder"
    amazon-ebs: Instance ID: i-0d12e2a9e6f00a410
==> amazon-ebs: Waiting for instance (i-0d12e2a9e6f00a410) to become ready...
``` 

透過 `-var-file` 將隱秘資訊寫到檔案內，像是 AWS Secret Key 等等。 

## 整合 Drone CI/CD

 上一個步驟可以透過指令方式完成映像檔，本章節會教大家如何跟 [Drone][14] 整合，這邊可以直接使用 [drone-packer][15] 套件，[使用文件][16]也已經放到 [drone plugin][17] 首頁了。使用方式非常簡單，請參考底下範例: 

```bash
pipeline:
  packer:
    image: appleboy/drone-packer
    pull: true
    secrets: [ aws_access_key_id, aws_secret_access_key ]
    template: ggz.json
    actions:
      - validate
      - build
    when:
      branch: master
``` 

其中 template 請輸入 json 檔案路徑，actions 目前只有支援 `validate` 跟 `build`，我建議兩者都寫，先驗證 json 檔案是否寫錯，再執行 build。另外我們可以看到 


```json
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}"
  },
``` 其中 

`aws_access_key` 是讀取系統環境變數 `AWS_ACCESS_KEY_ID`，所以可以透過 `drone secret` 將變數設定上去 

```bash
$ drone secret add \
  -repository go-ggz/packer \
  -image appleboy/drone-packer \
  -event push \
  -name aws_access_key_id \
  -value xxxxxx
``` 

請注意記得將敏感資訊綁定在 `-image` 身上，避免被偷走。上面的範例，可以直接參考 [go-ggz/packer][18]。

 [1]: https://www.flickr.com/photos/appleboy/43657047222/in/dateposted-public/ "Screen Shot 2018-07-29 at 12.47.51 PM"
 [2]: https://www.hashicorp.com/
 [3]: https://www.packer.io
 [4]: https://aws.amazon.com/
 [5]: https://cloud.google.com/
 [6]: https://www.docker.com/
 [7]: https://www.digitalocean.com/
 [8]: https://www.packer.io/docs/builders/index.html
 [9]: https://www.ansible.com/
 [10]: https://www.chef.io/chef/
 [11]: https://www.udemy.com/devops-oneday/?couponCode=DRONE-DEVOPS
 [12]: https://github.com/go-ggz/packer/blob/0c171e6af8cc1a4602f8d0d74504c67029ce2205/ggz.json
 [13]: https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/AMIs.html
 [14]: https://drone.io
 [15]: https://github.com/appleboy/drone-packer
 [16]: http://plugins.drone.io/appleboy/drone-packer/
 [17]: http://plugins.drone.io/
 [18]: https://github.com/go-ggz/packer
