---
title: Laravel Homestead 支援 PHP 7
author: appleboy
type: post
date: 2015-10-05T12:34:25+00:00
url: /2015/10/laravel-homestead-support-php-7/
categories:
  - Laravel
  - php
tags:
  - Homestead
  - Laravel
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="//www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

很高興看到 [Laravel][1] 的 [Homestead][2] 推出 PHP 7 的版本，假如您還在使用 PHP 5.x 的 homestead box，請參考本篇教學，或者是參考[線上文件][3]來升級。底下是這次升級的兩個步驟，第一個就是重新下載新的 PHP-7 box 檔案，第二步驟修改 `Homestead.yaml`設定檔，請參考如下：

<!--more-->

### 下載 homestead php-7 分支

要使用 PHP 7.0 請直接到 `laravel/homestead` repository 內下載 `php-7` 分支

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git clone -b php-7 https://github.com/laravel/homestead.git Homestead</pre>
</div>

### 修改 Homestead.yaml

完成後，請勿執行 `init.sh`，因為這樣會直接覆蓋掉您的 `Homestead.yaml` 設定。修改您的 Homestead.yaml 加入 box 設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">box: laravel/homestead-7</pre>
</div>

最後在 laravel/homestead 目錄執行 `vagrant up`，就會開始下載新的 box 檔案並且開機，接著透過 `vagrant ssh` 登入系統即可。

<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/21776519659/in/datetaken-public/" title="Screen Shot 2015-10-05 at 2.55.16 PM"><img src="https://i0.wp.com/farm1.staticflickr.com/767/21776519659_a6124626ee.jpg?resize=500%2C88&#038;ssl=1" alt="Screen Shot 2015-10-05 at 2.55.16 PM" data-recalc-dims="1" /></a>
</div>

### 疑難排除

**問題：原本的 homestead 指令無法開啟新安裝的 PHP 7 系統？**

如果原本系統有 homestead 指令，你會發現升級後，無法透過 `homestead up` 來開機顯示新的 PHP 7.x 系統，這是因為 virtual box 的 name 衝突，要解決此問題，要先把原本的 box 刪掉，刪掉之前，請務必備份原本 box 內修改過的檔案或者是資料庫備份。請先執行底下指令

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ vagrant global-status</pre>
</div>

會顯示目前 vagrant 存在的 box 狀態

<div style="margin:0 auto; text-align:center">
  <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/21342387433/in/datetaken-public/" title="Screen Shot 2015-10-05 at 2.43.13 PM"><img src="https://i2.wp.com/farm6.staticflickr.com/5686/21342387433_df0de0714d.jpg?resize=500%2C145&#038;ssl=1" alt="Screen Shot 2015-10-05 at 2.43.13 PM" data-recalc-dims="1" /></a>
</div>

畫面顯示會有兩個 box，一個是原本 homestead (PHP 5.x) 另一個則是 PHP 5.7 版本，這時候請先透過 `vagrant destroy` 把上面畫面兩個系統刪除，然後再重新下 `homestead up` 這樣就會是跑 `laravel/homestead-7` 新系統了，最後把資料庫 restore 回去，打開 URL 就可以看到原本的網站了。

**問題：打開原本網站，結果發現 502 bad gateway?**

這原因可以在 [Nginx][4] Log 檔案發現底下訊息

<div>
  <pre class="brush: bash; title: ; notranslate" title="">2015/10/05 10:05:13 [crit] 2061#0: *12 connect() to unix:/var/run/php5-fpm.sock failed (2: No such file or directory) while connecting to upstream, client: 192.168.10.1, server: homestead.app, request: "GET /journals/J0000005585 HTTP/1.1", upstream: "fastcgi://unix:/var/run/php5-fpm.sock:", host: "homestead.app"</pre>
</div>

可以看到 Nginx 設定的 `unix:/var/run/php5-fpm.sock` 路徑錯誤，請改成 `unix:/var/run/php/php7.0-fpm.sock` 才對，完成後請重新啟動 Nginx。

 [1]: http://laravel.com
 [2]: http://laravel.com/docs/5.1/homestead
 [3]: http://laravel.com/docs/5.1/homestead#installation-and-setup
 [4]: http://nginx.org