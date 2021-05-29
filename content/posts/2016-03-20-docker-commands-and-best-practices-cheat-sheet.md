---
title: Docker 實用指令及 Best Practices Cheat Sheet 圖表
author: appleboy
type: post
date: 2016-03-20T05:33:37+00:00
url: /2016/03/docker-commands-and-best-practices-cheat-sheet/
dsq_thread_id:
  - 4677406633
categories:
  - Docker
tags:
  - Docker
  - Docker compose

---
[<img src="https://i2.wp.com/farm2.staticflickr.com/1600/25660808075_c8190290f7_z.jpg?w=840&#038;ssl=1" alt="docker" data-recalc-dims="1" />][1]

在網路上看到有人提供 [Docker][2] 的 [Cheat Sheet][3]，裡面整理了很多常用的指令，建議剛入門 Docker 的初學者務必把底下指令學完，底下就是 Cheat Sheet

[<img src="https://i1.wp.com/farm2.staticflickr.com/1633/25622175940_277a89c6a1_z.jpg?w=840&#038;ssl=1" alt="Docker-cheat-sheet-by-RebelLabs" data-recalc-dims="1" />][4]

**[點我大圖][5]**

container 放大架構圖

[<img src="https://i0.wp.com/farm2.staticflickr.com/1458/25802770142_8c525c3309_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2016-03-20 at 1.11.30 PM" data-recalc-dims="1" />][6]

### 基本指令

下載映像檔

```bash
$ docker pull image_name
```

啟動或關閉 container

```bash
$ docker [start|stop] container_name
```

建立 -> 啟動 -> 執行指令 (`-ti` 參數)

```bash
$ docker run -ti --name container_name image_name command
```

建立 -> 啟動 -> 執行指令 -> 刪除 container (`-rm` 參數)

```bash
$ docker run --rm -ti image_name command
```

file system 及 port 對應 (`-v` 及 `-p` 參數)

```bash
$ docker run -ti --rm -p 80:80 -v /your_path:/container_path -e PASSWORD=1234 image_name
```

### Docker 清除 (cleanup) 指令

刪除所有正在執行的 container

```bash
$ docker kill $(docker ps -q)
```

刪除 dangling 映像檔

```bash
docker rmi $(docker images -q -f dangling=true)
```

刪除全部已停止的 container

```bash
docker rm $(docker ps -a -q)
```

### Docker machine 指令

啟動 machine

```bash
$ docker-machine start machine_name
```

指定 machine 來設定 docker

```bash
$ eval "$(docker-machine env machine_name)"
```

### 與 container 互動指令

在 container 內執行指令

```bash
$ docker exec -ti container_name command
```

線上觀看 container logs

```bash
$ docker logs -ft container_name
```

儲存正在執行的 container 成 image 檔案

```bash
$ docker commit -m "message" -a "author" container_name username/image_name:tag
```

### docker compose 格式

`docker-compose.yml` 格式如下

```yml
version: "2"
service:
  container_name: "hello-world"
  image: golang
  command: "go run hello-world.go"
  ports
    - "80:8080"
  volumes:
    - /hello-world:/root/hello-world
redis:
  image: redis
```

建立 -> 執行 container

```bash
$ docker-compose up
```

以上是常用的 docker 指令，初學者務必學習。

 [1]: https://www.flickr.com/photos/appleboy/25660808075/in/dateposted-public/ "docker"
 [2]: https://www.docker.com/
 [3]: http://zeroturnaround.com/rebellabs/docker-commands-and-best-practices-cheat-sheet/
 [4]: https://www.flickr.com/photos/appleboy/25622175940/in/dateposted-public/ "Docker-cheat-sheet-by-RebelLabs"
 [5]: https://farm2.staticflickr.com/1633/25622175940_e4540f1e7e_o.png
 [6]: https://www.flickr.com/photos/appleboy/25802770142/in/dateposted-public/ "Screen Shot 2016-03-20 at 1.11.30 PM"
