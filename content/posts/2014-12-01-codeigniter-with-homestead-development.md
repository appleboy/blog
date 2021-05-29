---
title: CodeIgniter 搭配 Homestead 開發環境
author: appleboy
type: post
date: 2014-12-01T08:18:54+00:00
url: /2014/12/codeigniter-with-homestead-development/
dsq_thread_id:
  - 3278854269
categories:
  - CodeIgniter
  - Laravel
  - php
  - Ubuntu
  - windows
tags:
  - CodeIgniter
  - Homestead
  - Laravel Homestead

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div>

[Homestead][1] 為 [Laravel Framework][2] 所提供出來的懶人安裝環境，大幅降低學習 Laravel 的門檻，大家都知道初學一套 Framework 最重要的是快速寫出 Hello world，如果初學者卡在環境都架設不來，那就更加不用接著學習 MVC 架構了，所以 Laravel 提供了 Homestead，不管你是用 Linux 或 Windows 都可以快速的把開發環境架設起來。相信很多人也從 [CodeIgniter][3] 跳往 Laravel 框架了，但是舊的網站還是要維護阿，所以這次透過 Laravel Homestead 一起來把 CodeIgniter 開發環境無痛架設起來，省去新人安裝 [Nginx][4] + [PHP][5] + [MySQL][6] 的時間。

<!--more-->

這次直接用之前在[成功大學電算中心講課][7]的專案來搭配 Homestead，專案為 [CodeIgniter-App][8]，如果尚未安裝 Homestead 指令，可以直接參考我上一篇教學 [Laravel Homestead 2.0 介紹][9]，接下來我們一步一步安裝，架設環境為 Debian 7.4。

## 設定 Homestead.yaml

先將 CodeIgniter-App 程式碼下載到 `/home/git` 目錄，此目錄可以任意指定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git clone https://github.com/appleboy/CodeIgniter-App.git /home/git/CodeIgniter-App</pre>
</div>

打開 `~/.homestead/Homestead.yaml`，原版您的 Laravel 專案設定如下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">---
ip: "192.168.10.10"
memory: 2048
cpus: 1

authorize: ~/.ssh/id_rsa.pub

keys:
  - ~/.ssh/id_rsa

folders:
  - map: /home/appleboy/newProject
    to: /home/vagrant/Code

sites:
  - map: homestead.app
    to: /home/vagrant/Code/public

databases:
  - homestead

variables:
  - key: APP_ENV
    value: local</pre>
</div>

這次增加 CodeIgniter 專案如下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">folders:
  - map: /home/appleboy/newProject
    to: /home/vagrant/Code
  - map: /home/git/CodeIgniter-App
    to: /home/vagrant/codeigniter-app

sites:
  - map: homestead.app
    to: /home/vagrant/Code/public
  - map: codeigniter.app
    to: /home/vagrant/codeigniter-app/public

databases:
  - homestead
  - app</pre>
</div>

這裡可以發現增加了一組 folders、sites 和 databases，這樣就設定完成了

## 啟動 Homestead

完成後直接透過底下指令來產生相對應設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ homestead up --provision</pre>
</div>

注意的是，如果之前的 Laravel 專案資料庫存在的話，執行 `--provision` 則會砍掉 homestead 資料庫，然後重新建立新的，所以這邊建議執行 `--provision` 之前，先把舊的 database 拿掉會比較好。或者是要把初始化資料寫到 `after.sh` 內也是可以的。

<div>
  <pre class="brush: bash; title: ; notranslate" title="">
#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

mysql -uhomestead -psecret app < /home/vagrant/codeigniter-app/sql/app.sql</pre>
</div>

## 增加 host

打開 `/etc/hosts` 增加新的 domain

<div>
  <pre class="brush: bash; title: ; notranslate" title="">172.21.117.2 homestead.app
172.21.117.2 codeigniter.app
</pre>
</div>

最後打開瀏覽器 http://codeigniter.app:8000 就可以看到結果了喔

上述的 CodeIgniter-App 專案可以參考 **<https://github.com/appleboy/CodeIgniter-App>**

 [1]: http://laravel.tw/docs/4.2/homestead
 [2]: http://laravel.tw
 [3]: http://codeigniter.org.tw/
 [4]: http://nginx.org/
 [5]: http://php.net/
 [6]: http://www.mysql.com/
 [7]: http://blog.wu-boy.com/2014/09/fight-with-codeigniter-in-ncku/
 [8]: https://github.com/appleboy/CodeIgniter-App
 [9]: http://blog.wu-boy.com/2014/11/introduction-to-laravel-homestead-2-0/