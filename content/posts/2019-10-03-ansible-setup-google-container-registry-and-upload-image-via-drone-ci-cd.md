---
title: Ansible 設定 Google Container Registry 搭配 Drone 自動上傳
author: appleboy
type: post
date: 2019-10-03T02:14:07+00:00
url: /2019/10/ansible-setup-google-container-registry-and-upload-image-via-drone-ci-cd/
dsq_thread_id:
  - 7660223328
categories:
  - DevOps
  - Docker
  - Drone CI
  - Google
tags:
  - Docker
  - drone
  - GitLab

---
![blog logo][1]

最近剛好有需求要串接 [GCR][2] (Google Container Registry)，專案如果是搭配 GCP 服務，個人建議就直接用 GCR 了。本篇要教大家如何透過 Ansible 管理遠端機器直接登入 GCR，透過特定的帳號可以直接拉 Image，接著用 [docker-compose][3] 來重新起動服務，這算是最基本的部署流程，那該如何用 [Ansible][4] 登入呢？請看底下教學。

<!--more-->

## 使用 ansible docker_login 模組

Google 提供了[好幾種方式][5]來登入 Docker Registry 服務，本篇使用『[JSON 金鑰檔案][6]』方式來長期登入專案，開發者會拿到一個 JSON 檔案，在本機電腦可以透過底下指令登入:

```bash
cat keyfile.json | docker login \
  -u _json_key \
  --password-stdin \
  https://[HOSTNAME]
```

如果沒有支援 `password-stdin` 則可以使用底下:

```bash
docker login -u _json_key \
  -p "$(cat keyfile.json)" \
  https://[HOSTNAME]
```

請注意這邊的使用者帳號統一都是使用 `_json_key`，而在 Ansible 則是使用 [docker_login][7] 模組

```yaml
- name: Log into GCR private registry and force re-authorization
  docker_login:
    registry: "https://asia.gcr.io"
    username: "_json_key"
    password: "{{ lookup('template', 'gcr.json', convert_data=False) | string }}"
    config_path: "{{ deploy_home_dir }}/.docker/config.json"
    reauthorize: yes
```

注意 `password` 欄位，請將 `gcr.json` 放置在 `role/templates` 目錄，透過 lookup 方式並轉成 string 才可以正常登入，網路上有解法說需要在 `password` 前面加上一個空白才可以登入成功，詳細情況可以[參考這篇][8]。

## 使用 Drone 自動化上傳 Image

講 Drone 之前，我們先來看看 GitLab 怎麼上傳，其實也不難:

```yaml
cloudbuild:
  stage: deploy
  image: google/cloud-sdk
  services:
    - docker:dind
  dependencies:
    - build
  script:
    - echo "$GCP_SERVICE_KEY" > gcloud-service-key.json
    - gcloud auth activate-service-account --key-file gcloud-service-key.json
    - gcloud config set project $GCP_PROJECT_ID
    - gcloud builds submit . --config=cloudbuild.yaml --substitutions _IMAGE_NAME=$PROJECT_NAME,_VERSION=$VERSION
  only:
    - release
```

透過 [gcloud][9] 就可以快速自動上傳。而使用 Drone 設定也是很簡單:

```yaml
- name: publish
  pull: always
  image: plugins/docker
  settings:
    auto_tag: true
    auto_tag_suffix: linux-amd64
    registry: asia.gcr.io
    cache_from: asia.gcr.io/project_id/image_name
    daemon_off: false
    dockerfile: docker/ponyo/Dockerfile.linux.amd64
    repo: asia.gcr.io/project_id/image_name
    username:
      from_secret: docker_username
    password:
      from_secret: docker_password
  when:
    event:
      exclude:
      - pull_request
```

其中 `password` 可以透過後台將 json 資料寫入。這邊有幾個重要功能列給大家參考

  * 使用 `cache_from` 加速
  * 使用 `auto_tag` 快速部署標籤

這兩項分別用在什麼地方，`cache_from` 可以直接看我之前寫過的一篇『[在 docker-in-docker 環境中使用 cache-from 提升編譯速度][10]』裡面蠻詳細介紹，並且有影片。而 auto_tag 最大的好處是在 release 開源專案 Image，只要你的 tag 有按照標準格式，像是如果是打 `v1.0.1` 這時候 Drone 會分別產生三個 Image: `1`, `1.0`, `1.0.1`，下次又 release `v1.0.2`，這時候 `1.0` 就會指向 `1.0.2`，類似這樣以此類推，方便其他使用者抓取 Image。這是在其他像是 GitLab 無法做到，應該說不是無法做到，而是變成要自己寫 script 才能做到。

## 教學影片

底下是教您如何使用 docker cache 機制，如果你的 Image 特別大，像是有包含 Linux SDK 之類的，就真的用 cache 會比較快喔。

歡迎訂閱我的 Youtube 頻道: <http://bit.ly/youtube-boy>

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

 [1]: https://lh3.googleusercontent.com/mese3VEnyNElOz7iL-z3w0nxM4PcNjC6lfPWxLbPrHTFr3PvKeyxGwIxTXoRztpidxN7gX8WlRtzBsfxkOVb_Pt-jEwCbZtYDD3l0DLeBger7XaC40XVyPUgAyT6yU_FdqJeAUCSQik=w1920-h1080
 [2]: https://cloud.google.com/container-registry/
 [3]: https://docs.docker.com/compose/
 [4]: https://www.ansible.com/
 [5]: https://cloud.google.com/container-registry/docs/advanced-authentication?hl=zh-tw
 [6]: https://cloud.google.com/container-registry/docs/advanced-authentication?hl=zh-tw#json_key_file
 [7]: https://docs.ansible.com/ansible/latest/modules/docker_login_module.html
 [8]: https://stackoverflow.com/questions/57260374/docker-login-to-gce-using-ansible-docker-login-and-json-key
 [9]: https://cloud.google.com/sdk/gcloud/?hl=zh-tw
 [10]: https://blog.wu-boy.com/2019/02/using-cache-from-can-speed-up-your-docker-builds