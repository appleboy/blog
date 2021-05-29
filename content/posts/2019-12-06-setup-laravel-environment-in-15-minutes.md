---
title: 用 15 分鐘快速打造 Laravel 開發環境
author: appleboy
type: post
date: 2019-12-06T02:00:59+00:00
url: /2019/12/setup-laravel-environment-in-15-minutes/
dsq_thread_id:
  - 7749403584
categories:
  - Docker
  - php
tags:
  - Docker
  - Laradock
  - Laravel

---
[![cover page][1]][1]

相信大家對 Laravel 都很熟悉，但是初學者或是新進同事要快速入門 Laravel 最大的門檻就是該如何在短時間內在本機電腦快速安裝好公司專案。這時候使用 Laradock 就是一個最佳時機，透過 Docker 容器話，快速切換 PHP 版本，或者是安裝額外的服務像是 MySQL, MariaDB, phpMyAdmin 或 nginx 等服務，讓本機端不受到自訂安裝套件的困擾，用完隨時關閉，完全不會影響到電腦環境。底下我會介紹使用 Laradock 該注意的事情。完整詳細的操作步驟可以直接看 Youtube 影片。

<!--more-->

## 教學影片

同步放在 Udemy 平台上面，有興趣的可以直接參考底下:

  * [Go 語言基礎實戰 (開發, 測試及部署)][2]
  * [一天學會 DevOps 自動化測試及部署][3]

## 前置處理

先來定義 laradock 該如何跟既有或者是全新專案結合，底下提供一種目錄結構

```sh
├── laradock
└── www
```

其實蠻好懂的，先建立空目錄，www 代表專案的程式碼，而 laradock 就是本機端開發環境。你也可以直接將 laradock 放進 www 內也可以。

## 編輯 laradock/.env (從 env-example 複製)

修改

```yaml
APP_CODE_PATH_HOST=../www
```

專案架構調整為:

```sh
├── laradock
└── www
```

如果機器本身已經有 [nginx][4], [apache][5] 或 [traefik][6]，請將 nginx container port 修改為:

```sh
NGINX_HOST_HTTP_PORT=8000
NGINX_HOST_HTTPS_PORT=4430
```

## 下載專案原始碼

如果已經有 Source Code 了請忽略此步驟，如果是全新的專案，請先進入 `workspace` 容器:

```sh
docker-compose exec workspace bash
```

進去後預設會在 `/var/www` 目錄底下，接著下載 laravel 官方原始碼

```sh
composer create-project laravel/laravel --prefer-dist .
```

完成後請離開 container，就可以看到在 `www` 底下有完整的 laravel 代碼，避免跟主機 Host 衝突。接著啟動專案 (nginx + mariadb)

```sh
docker-compose up -d nginx mariadb
```

## 設定 nginx 檔案

先假設網域名稱為 `laravel.test`，先複製 config

```sh
cp -r nginx/sites/laravel.conf.example nginx/sites/laravel.test.conf
```

修改 `nginx/sites/laravel.test.conf`

```sh
# 將底下
root /var/www/laravel/public
# 改成
root /var/www/public
```

這邊我有[發個 PR][7] 到 Laradock，最後新增 laravel.test 到 `/etc/hosts` 檔案

## 修改目錄權限

由於 php-fpm 容器運行的 www-data 的使用者，所以您必須在 Host 設定相對應的 uid 及 gid，先進入 `php-fpm` 來取得 www-data 個人資訊:

```sh
$ docker-compose exec php-fpm id www-data
uid=1000(www-data) gid=1000(www-data) groups=1000(www-data)
```

設定權限

```sh
chown -R 1000:1000 www/storage/
```

## 編輯 laradock/docker-compose.yml

Docker 預設使用 172.21.x 開頭的 IP，可以修改 docker-compose.yml 來調整網路設定:

```yaml
networks:
  frontend:
    driver: ${NETWORKS_DRIVER}
    ipam:
      driver: default
      config:
        - subnet: 192.168.100.0/24
  backend:
    driver: ${NETWORKS_DRIVER}
    ipam:
      driver: default
      config:
        - subnet: 192.168.101.0/24
  default:
    driver: ${NETWORKS_DRIVER}
    ipam:
      driver: default
      config:
        - subnet: 192.168.110.0/24
```

避免跟公司網路 172.xxx.xxx.xxx 網域衝到造成網路斷線。

 [1]: https://lh3.googleusercontent.com/pjvNN9g1j3Viepuj7ujFJxOOaXPW4GalM1N0nTEmtrH84y36YVJuDfLDmoVv9PgmsuyEJ9o1iwSnItKfyg91fLGETDSsxGXCnquhs1qy_SDYNw5S0MuS0caVbnWZzx9hB13LqRN7JYw=w1920-h1080 "cover page"
 [2]: https://www.udemy.com/course/golang-fight/?couponCode=20191201
 [3]: https://www.udemy.com/course/devops-oneday/?couponCode=20191201
 [4]: https://www.nginx.com/
 [5]: https://httpd.apache.org/
 [6]: https://traefik.io/
 [7]: https://github.com/laradock/laradock/pull/2399 "發個 PR"