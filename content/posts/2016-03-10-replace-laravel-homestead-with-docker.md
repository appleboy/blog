---
title: 用 Docker 取代 Laravel Homestead 開發環境
author: appleboy
type: post
date: 2016-03-10T06:37:40+00:00
url: /2016/03/replace-laravel-homestead-with-docker/
dsq_thread_id:
  - 4649581985
categories:
  - Docker
  - Laravel
tags:
  - Docker
  - Homestead
  - Laravel

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/25660808075/in/dateposted-public/" title="docker"><img src="https://i2.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_z.jpg?resize=640%2C217&#038;ssl=1" alt="docker" data-recalc-dims="1" /></a>

新手第一次接觸 [Laravel][1]，我都會推薦使用 [Homestead][2] 來解決開發環境的困擾，但是我發現 Homestead 對於第一次接觸 [Virtualbox][3] 及指令的初學者，設定還是比較複雜，造成很多新手光是在這邊就卡關了，有沒有什麼辦法可以解決這煩人又複雜的 Homestead 設定，剛好今天在 [Github][4] 上看到 [laraedit-docker][5] 專案，此專案是把 Homestead 轉換成用 [Docker][6] 來跑，這樣只要您的環境有支援 Docker，就可以快速設定好環境含 MySQL, Redis ...等

<!--more-->

## 建立 Laravel 專案

透過 Composer 指令建立 Laravel 專案

<pre><code class="language-bash">$ composer create-project --prefer-dist laravel/laravel blog</code></pre>

先假設 blog 目錄路徑為 `~/git/blog`，此路徑底下會用到

## 使用 Docker

首先從 [Docker hub][7] 下載 [laraedit-docker][8] 映像檔

<pre><code class="language-bash">$ docker pull laraedit/laraedit</code></pre>

完成下載後，就可以直接啟動專案

<pre><code class="language-bash">$ docker run -d --name laravel -p 8082:80 -p 3307:3306 -v ~/git/blog:/var/www/html/app laraedit/laraedit</code></pre>

參數說明

<pre><code class="language-bash">--name: 啟動後服務名稱
-p: 啟動外面的 port 對應到 container 內部 port
-v: 目錄掛載</code></pre>

laraedit 預設將 80, 443, 3306, 6379 port 開出來，所以如果外部要直接存取，請使用 `-p` 參數來設定。

## 登入 Docker Shell

要透過 ssh 連入 Docker 請透過底下指令

<pre><code class="language-bash">$ docker exec -it laravel /bin/bash</code></pre>

其中 `laravel` 就是最上面 `--name` 設定，執行指令後，你就會進入 Shell 模式，可以進行 DB 操作記錄，執行 DB Migration 等...

## 進入 MySQL Console

上面我們將 3307 port 對應到 docker 內部 3306 port，所以可以透過 mysql 指令直接連上 MySQL 服務

<pre><code class="language-bash">$ mysql -u homestead -h 192.168.99.100 -P 3307 -p</code></pre>

預設帳號為 `homestead` 密碼為 `secret`

<pre><code class="language-bash">$ mysql -u homestead -h 192.168.99.100 -P 3307 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.7.11 MySQL Community Server (GPL)

Copyright (c) 2000, 2015, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type &#039;help;&#039; or &#039;\h&#039; for help. Type &#039;\c&#039; to clear the current input statement.

mysql&gt; show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| homestead          |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.01 sec)

mysql&gt;</code></pre>

大致上用 Docker 就取代了 Homestead，所以大家快點把 Docker 安裝到自己的電腦。

 [1]: http://laravel.com/
 [2]: https://laravel.com/docs/5.2/homestead
 [3]: https://www.virtualbox.org/
 [4]: https://github.com/
 [5]: https://github.com/laraedit/laraedit-docker
 [6]: https://www.docker.com/
 [7]: https://hub.docker.com/
 [8]: https://hub.docker.com/r/laraedit/laraedit/