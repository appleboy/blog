---
title: Laravel Homestead 搭配 phpMyAdmin Docker
author: appleboy
type: post
date: 2016-01-02T08:14:08+00:00
url: /2016/01/laravel-homestead-and-phpmyadmin-docker/
dsq_thread_id:
  - 4454001091
categories:
  - CodeIgniter
  - Docker
  - Laravel
  - php
tags:
  - Docker
  - Homestead
  - Laravel
  - Laravel Homestead

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23493872563/in/dateposted-public/" title="laravel"><img src="https://i1.wp.com/farm2.staticflickr.com/1655/23493872563_4f01a9c336_o.png?resize=400%2C400&#038;ssl=1" alt="laravel" data-recalc-dims="1" /></a>

相信大家對於 [Laravel][1] 推出的 [Homestead][2] 開發環境不陌生，本篇不會教學使用 Homestead，直接看[繁中官網的教學][3]就可以完成了，Homestead 可以幫助開發者快速架設好 Laravel 環境，當然 Homestead 也適用於 [CodeIgniter][4] 的開發，因為兩套 Framework 的環境是一樣的，Homestead 開啟 VM 後，會自動將 Local port 對應到 VM port 如下

  * SSH: 2222 → Forwards To 22
  * HTTP: 8000 → Forwards To 80
  * HTTPS: 44300 → Forwards To 443
  * MySQL: 33060 → Forwards To 3306
  * Postgres: 54320 → Forwards To 5432

<!--more-->

所以可以透過電腦 Client 軟體控制相對應你想使用的 service，但是唯獨沒有提供 [phpMyAdmin][5]，所以我到 [Docker Hub][6] 找看看有無別人弄好的 phpMyAdmin 環境，很快的找到 [Docker PHPMyAdmin][7]，只要將相關指令設定好，就可以用一行指令在你的電腦開啟 phpMyAdmin 服務，Homestead 預設的 [MySQL][8] 帳號為 `homestead` 密碼 `secret`，看到上面 port 為 33060，用 `docker-machine` 指令來找 `Host` 名稱，請直接參考底下指令

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ docker run -d \
  -e MYSQL_USERNAME=homestead \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_PORT_3306_TCP_ADDR=192.168.99.1 \
  -e MYSQL_PORT_3306_TCP_PORT=33060 \
  --name laravel-phpmyadmin \
  -p 80 corbinu/docker-phpmyadmin</pre>
</div>

完成後，用 `docker ps` 來看目前啟動的 [Docker][9] VM

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23825374840/in/dateposted-public/" title="Screen Shot 2016-01-02 at 4.08.56 PM"><img src="https://i2.wp.com/farm2.staticflickr.com/1543/23825374840_7101b42be5_z.jpg?resize=640%2C34&#038;ssl=1" alt="Screen Shot 2016-01-02 at 4.08.56 PM" data-recalc-dims="1" /></a>

從上圖可以發現 `0.0.0.0:32771->80/tcp` 打開 http://localhost:32771 就可看到 phpMyAdmin 登入介面，輸入預設帳號密碼就可以了。

 [1]: https://laravel.com/
 [2]: https://laravel.com/docs/5.1/homestead
 [3]: https://laravel.tw/docs/5.1/homestead
 [4]: https://codeigniter.org.tw/
 [5]: https://www.phpmyadmin.net/
 [6]: https://hub.docker.com/
 [7]: https://github.com/corbinu/docker-phpmyadmin
 [8]: https://www.mysql.com/
 [9]: https://www.docker.com/