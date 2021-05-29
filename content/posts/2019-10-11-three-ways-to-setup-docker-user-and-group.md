---
title: 在 Docker 內設定使用者及群組權限的三種方式
author: appleboy
type: post
date: 2019-10-10T23:04:08+00:00
url: /2019/10/three-ways-to-setup-docker-user-and-group/
dsq_thread_id:
  - 7671439679
categories:
  - Docker
tags:
  - Docker

---
[![docker][1]][1]

如果平常本身有在玩 [Docker][2] 的開發者肯定知道透過 docker command 啟動的容器預設是使用 `root` 來當作預設使用者及群組，這邊會遇到一個問題，當 Host 環境你有 root 權限就沒有此問題，如果你沒有 root 權限，又有需求在 Docker 容器內掛上 Volume，會發現產生出來的檔案皆會是 root 權限，這時候在 Host 完全無法寫入。本篇教大家使用三種方式來設定容器使用者權限。

<!--more-->

## 使用 docker 指令時指定使用者

進入 Ubuntu 容器會透過底下指令:

<pre><code class="language-bash">docker run -ti ubuntu /bin/bash</code></pre>

這時候可以透過 `-u` 方式將使用者 uid 及群組 gid 傳入容器內。

<pre><code class="language-bash">mkdir tmp
docker run -ti -v $PWD/tmp:/test \
  -u uid:gid ubuntu /bin/bash</code></pre>

如何找到目前使用者 uid 及 gid 呢，可以透過底下方式

<pre><code class="language-bash">id -u
id -g</code></pre>

上述指令可以改成:

<pre><code class="language-bash">docker run -ti -v $PWD/tmp:/test \
  -u $(id -u):$(id -g) ubuntu /bin/bash</code></pre>

## 使用 Dockerfile 指定使用者

也可以直接在 [dockerfile][3] 內直接指定使用者:

<pre><code class="language-bash"># Dockerfile

USER 1000:1000</code></pre>

我個人不是很推薦這方式，除非是在 container 內獨立建立使用者，並且指定權限。

## 透過 docker-compose 指定權限

透過 [docker-compose][4] 可以一次啟動多個服務。用 `user` 可以指定使用者權限來寫入特定的 volume

<pre><code class="language-yaml">services:
  agent:
    image: xxxxxxxx
    restart: always
    networks:
      - proxy
    logging:
      options:
        max-size: "100k"
        max-file: "3"
    volumes:
      - ${STORAGE_PATH}:/data
    user: ${CURRENT_UID}</code></pre>

接著可以透過 `.env` 來指定變數值

<pre><code class="language-bash">STORAGE_PATH=/home/deploy/xxxx
CURRENT_UID=1001:1001</code></pre>

## 心得

會指定使用者權限通常都是有掛載 Host volume 進入容器內，但是您又沒有 root 權限，如果沒有這樣做，這樣產生出來的檔案都會是 root 權限，一般使用者無法寫入，只能讀取，這時就需要用到此方法。

 [1]: https://lh3.googleusercontent.com/CDrKX9nVEAkUnrVNX26Mf0HY1iW73gM6z8WCITgo5QUWx3yXZPOzAI6op59p-YxKYgPkBQalH-rWUb2gElpc2gwjZ3M5jgKeHQ4MI88DkMXjxzkAhQX-zgIqjbGpRrlV38uXLFDxcMU=w1920-h1080 "docker"
 [2]: https://www.docker.com/
 [3]: https://docs.docker.com/engine/reference/builder/
 [4]: https://docs.docker.com/compose/