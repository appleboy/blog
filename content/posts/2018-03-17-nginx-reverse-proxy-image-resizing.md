---
title: 用 Nginx 來架設線上即時縮圖機
author: appleboy
type: post
date: 2018-03-17T02:28:08+00:00
url: /2018/03/nginx-reverse-proxy-image-resizing/
dsq_thread_id:
  - 6556082644
categories:
  - Docker
  - Nginx
tags:
  - nginx

---
[<img src="https://i0.wp.com/farm1.staticflickr.com/790/26946324088_93725a917b_z.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

在更早以前我們怎麼實現縮圖機制，當使用者上傳一張檔案，後端會固定將圖片縮圖成各種前端網頁需要的大小，不管前端頁面是否有使用，後端都會先產生好，這有什麼缺陷？

  1. 佔用硬碟空間大小
  2. 前端又需要另外一種格式的縮圖?

第二個問題比較麻煩，當前端需要另一種縮圖格式，後端就要開始掃描系統的全部圖片，再重新產生一次。非常耗費後端系統效能。後來才改成透過 URL 定義長寬來決定即時縮圖，在 [Go 語言][2]內可以選擇使用 [picfit][3] 來當作後端即時的縮圖機。本篇則是要提供另一種解法，就是使用 [Nginx][4] 搭配 [image_filter][5] 外掛來達成即時縮圖機制。

<!--more-->

## 使用 image_filter

來看看縮圖網址

```bash
http://foobar.org/image_width/bucket_name/image_name
```

  * **image_width**: 圖片 width
  * **bucket_name**: 圖片目錄或 AWS S3 bucket
  * **image_width**: 圖片檔名

其中 bucket 可以是 [AWS S3][6]。底下是 Nginx 的簡單設定:

```bash
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name ${NGINX_HOST};

  location ~ ^/([0-9]+)/(.*)$ {
    set $width $1;
    set $path $2;
    rewrite ^ /$path break;
    proxy_pass ${IMAGE_HOST};
    image_filter resize $width -;
    image_filter_buffer 100M;
    image_filter_jpeg_quality ${JPG_QUALITY};
    expires ${EXPIRE_TIME};
  }
}
```

我們可以設定 expires 來讓使用這存在瀏覽器端，這樣下次瀏覽網頁的時候都可以使用快取機制。可以看到 `IMAGE_HOST` 可以是 AWS S3 URL。

  1. 先從 `IMAGE_HOST` 下載圖片
  2. Nginx 執行縮圖
  3. 儲存圖片在使用者 browser 端

[<img src="https://i1.wp.com/farm1.staticflickr.com/817/40809061222_088e694426_z.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][7]

到這邊會有個問題，假設有一萬個使用者在不同的地方同時連線，Nginx 就需要處理 1 萬次，可以直接用 [vegeta][8] 來 Benchmark 試試看

```bash
$ echo "GET http://localhost:8002/310/test/26946324088_5b3f0b1464_o.png" | vegeta attack -rate=100 -connections=1 -duration=1s | tee results.bin | vegeta report
Requests      [total, rate]            100, 101.01
Duration      [total, attack, wait]    8.258454731s, 989.999ms, 7.268455731s
Latencies     [mean, 50, 95, 99, max]  3.937031678s, 4.079690985s, 6.958110121s, 7.205018428s, 7.268455731s
Bytes In      [total, mean]            4455500, 44555.00
Bytes Out     [total, mean]            0, 0.00
Success       [ratio]                  100.00%
Status Codes  [code:count]             200:100
Error Set:
```

上面數據顯示每秒打 100 次連線，ngix 需要花費 8 秒多才能執行結束。而延遲時間也高達 3 秒多。

## 加入 proxy cache 機制

透過 proxy cache 機制可以讓 nginx 只產生一次縮圖，並且放到 cache 目錄內可以減少短時間的不同連線。但是 image_filter 無法跟 proxy cache 同時處理，所以必須要拆成兩個 host 才可以達到此目的，如果沒有透過 proxy cache，你也可以用 [cloudflare CDN][9] 來達成此目的。請參考[線上設定][10]

```bash
proxy_cache_path /data keys_zone=cache_zone:10m;

server {
  # Internal image resizing server.
  server_name localhost;
  listen 8888;

  # Clean up the headers going to and from S3.
  proxy_hide_header "x-amz-id-2";
  proxy_hide_header "x-amz-request-id";
  proxy_hide_header "x-amz-storage-class";
  proxy_hide_header "Set-Cookie";
  proxy_ignore_headers "Set-Cookie";

  location ~ ^/([0-9]+)/(.*)$ {
    set $width $1;
    set $path $2;
    rewrite ^ /$path break;
    proxy_pass ${IMAGE_HOST};
    image_filter resize $width -;
    image_filter_buffer 100M;
    image_filter_jpeg_quality ${JPG_QUALITY};
  }
}

server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name ${NGINX_HOST};

  location ~ ^/([0-9]+)/(.*)$ {
    set $width $1;
    set $path $2;
    rewrite ^ /$path break;
    proxy_pass http://127.0.0.1:8888/$width/$path;
    proxy_cache cache_zone;
    proxy_cache_key $uri;
    proxy_cache_valid 200 302 24h;
    proxy_cache_valid 404 1m;
    # expire time for browser
    expires ${EXPIRE_TIME};
  }
}
```

## 測試數據

這邊使用 [minio][11] 來當作 S3 儲存空間，再搭配 Nginx 1.3.9 版本來測試上面設定效能。底下是 [docker-compose][12] 一鍵啟動

```yml
version: '2'

services:
  minio:
    image: minio/minio
    container_name: minio
    ports:
      - "9000:9000"
    volumes:
      - minio-data:/data
    environment:
      MINIO_ACCESS_KEY: YOUR_MINIO_ACCESS_KEY
      MINIO_SECRET_KEY: YOUR_MINIO_SECRET_KEY
    command: server /data

  image-resizer:
    image: appleboy/nginx-image-resizer
    container_name: image-resizer
    ports:
      - "8002:80"
    environment:
      IMAGE_HOST: http://minio:9000
      NGINX_HOST: localhost

volumes:
  minio-data:
```

用 docker-compose up 可以將 nginx 及 minio 服務同時啟動，接著打開 <http://localhost:9000> 上傳圖片，再透過 [vegeta][8] 測試數據:

```bash
$ echo "GET http://localhost:8002/310/test/26946324088_5b3f0b1464_o.png" | vegeta attack -rate=100 -connections=1 -duration=1s | tee results.bin | vegeta report
Requests      [total, rate]            100, 101.01
Duration      [total, attack, wait]    993.312255ms, 989.998ms, 3.314255ms
Latencies     [mean, 50, 95, 99, max]  3.717219ms, 3.05486ms, 8.891027ms, 12.488937ms, 12.520428ms
Bytes In      [total, mean]            4455500, 44555.00
Bytes Out     [total, mean]            0, 0.00
Success       [ratio]                  100.00%
Status Codes  [code:count]             200:100
Error Set:
```

執行時間變成 `993.312255ms`，Latency 也降到 `3.717219ms`，效能提升了很多。透過簡單的 [docker][13] 指令就可以在任意機器架設此縮圖機。詳細步驟請參考 [nginx-image-resizer][14]

```bash
$ docker run -e NGINX_PORT=8081 \
  -e NGINX_HOST=localhost \
  -e IMAGE_HOST="http://localhost:9000" \
  appleboy/nginx-image-resizer
```

附上程式碼請參考 [nginx-image-resizer][14]

 [1]: https://i0.wp.com/farm1.staticflickr.com/790/26946324088_93725a917b_z.jpg?ssl=1
 [2]: https://golang.org
 [3]: https://github.com/thoas/picfit
 [4]: http://nginx.org
 [5]: http://nginx.org/en/docs/http/ngx_http_image_filter_module.html
 [6]: https://aws.amazon.com/tw/s3/
 [7]: https://i1.wp.com/farm1.staticflickr.com/817/40809061222_088e694426_z.jpg?ssl=1
 [8]: https://github.com/tsenart/vegeta
 [9]: https://www.cloudflare.com/cdn/
 [10]: https://github.com/appleboy/nginx-image-resizer/blob/ab1e460de8774eccc4cae06a5c7e37536899126e/default.conf#L1-L44
 [11]: https://minio.io/
 [12]: https://docs.docker.com/compose/
 [13]: https://www.docker.com
 [14]: https://github.com/appleboy/nginx-image-resizer