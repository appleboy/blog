---
title: 用 Ansible 安裝 Drone CI/CD 開源專案
author: appleboy
type: post
date: 2019-06-17T07:18:39+00:00
url: /2019/06/install-drone-ci-cd-using-ansible/
dsq_thread_id:
  - 7483023484
categories:
  - DevOps
  - Docker
  - Drone CI
tags:
  - ansible
  - drone
  - drone ci

---
[![drone and ansible][1]][1]

相信大家對於 [Drone 開源專案][2]並不陌生，如果對於 Drone 不了解的朋友們，可以直接看之前寫的[系列文章][3]，本篇要教大家如何使用 [Ansible][4] 來安裝 Drone CI/CD 開源專案。目前 Drone 可以支援兩種安裝方式: 1. 使用 Docker 2. 使用 binary，如果您是進階開發者，可以使用 binary 方式來安裝，像是在 Debug 就可以透過 build binary 方式來測試。一般來說都是使用 Docker 方式來安裝，在使用 ansible 之前，請先準備一台 Ubuntu 或 Debian 作業系統的 VM 來測試。

<!--more-->

## 影片教學

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## 事前準備

首先在您的電腦上安裝 ansible 環境，在 MacOS 很簡單，只需要透過 `pip` 就可以安裝完成

```bash
$ pip install ansible
```

更多安裝方式，可以直接看[官方文件 Installation Guide][5]

## Ansible 環境

來看看 Ansible 專案目錄結構

```bash
├── Makefile
├── host.ini
├── playbook.yml
├── roles
│   ├── base
│   └── docker
└── vars
    ├── drone-agent.yml
    └── drone-server.yml
```

其中 `roles` 目錄是放置原本專案的角色，本篇內容不會提到，接著我們一一講解每個檔案，首先是 `Makefile`，裡面其實很簡單，只是兩個 ansible 指令，透過 `ansible-lint` 可以驗證 playbook 語法是否有錯誤，可以選用。

```makefile
all: ansible

lint:
    ansible-lint playbook.yml

ansible: lint
    ansible-playbook -i host.ini playbook.yml
```

接著定義要在哪一台 VM 上面安裝 drone-server 或 drone-agent，請打開 `host.ini`

```yaml
[drone_server]
dog ansible_user=multipass ansible_host=192.168.64.11 ansible_port=22

[drone_agent]
cat ansible_user=multipass ansible_host=192.168.64.11 ansible_port=22
```

這邊先暫時把 server 跟 agent 裝在同一台，如果要多台 drone-agent，請自行修改。接下來寫 `playbook`

```yaml
- name: "deploy drone server."
  hosts: drone_server
  become: true
  become_user: root
  roles:
    - { role: appleboy.drone }
  vars_files:
    - vars/drone-server.yml

- name: "deploy drone agent."
  hosts: drone_agent
  become: true
  become_user: root
  roles:
    - { role: appleboy.drone }
  vars_files:
    - vars/drone-agent.yml
```

可以看到其中 `var` 目錄底下是放 server 跟 agent 的設定檔案，server 預設是跑 sqlite 資料庫。其中 `drone_server_enable` 要設定為 `true`，代表要安裝 drone-server

```yaml
drone_server_enable: "true"
drone_version: "latest"
drone_github_client_id: "e2bdde88b88f7ccf873a"
drone_github_client_secret: "b0412c975bbf2b6fcd9b3cf5f19c8165b1c14d0c"
drone_server_host: "368a7a66.ngrok.io"
drone_server_proto: "https"
drone_rpc_secret: "30075d074bfd9e74cfd0b84a5886b986"
```

接著看 `drone-agent.yml`，也會看到要安裝 agent 就必須設定 `drone_agent_enable` 為 `true`。

```yaml
drone_agent_enable: "true"
drone_version: "latest"
drone_rpc_server: "http://192.168.64.2:8081"
drone_rpc_secret: "30075d074bfd9e74cfd0b84a5886b986"
```

更多變數內容請參考[這邊][6]。

## Ansible 套件

我寫了 [ansible-drone][7] 角色來讓開發者可以快速安裝 drone 服務，安裝方式如下

```bash
$ ansible-galaxy install appleboy.drone
```

上面步驟是安裝 master 版本，如果要指定穩定版本請改成如下 (後面接上 `,0.0.2` 版號)

```bash
$ ansible-galaxy install appleboy.drone,0.0.2
```

安裝角色後，就可以直接執行了，過程中會將機器先安裝好 Docker 環境，才會接著安裝 server 及 agent。

```bash
$ ansible-playbook -i host.ini playbook.yml
```

以上 Ansible 程式碼可以直接從[**這邊下載**][8]

## 心得

如果有多台機器需要建置，用 Ansible 非常方便。如果是多個 VM 需要快速開啟跟關閉，請透過 [packer][9] 來建置 Image 來達到快速 auto scale。更多詳細的設定可以參考 [drone role of ansible][7]。

 [1]: https://lh3.googleusercontent.com/HZqWLZjp96azorhAZseeSbSj9Q5-dj99lM8cX4ApJjnDL0grXaMEoIHJl3dQEx-ZyFcI713_CeQlPSFMOLgxD19tBOLMmgdQlwMe_QMhwGKrh2pQDWE2bj4cul4ENt21sWRFOYq6agc=w1920-h1080 "drone and ansible"
 [2]: https://github.com/drone/drone
 [3]: https://blog.wu-boy.com/?s=drone
 [4]: https://www.ansible.com/
 [5]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
 [6]: https://github.com/appleboy/ansible-drone/blob/master/defaults/main.yml
 [7]: https://github.com/appleboy/ansible-drone
 [8]: https://github.com/go-training/drone-tutorial/tree/b1f215261feb390c4bc02d2c83cb48511b3f76cf/ansible
 [9]: https://www.packer.io/