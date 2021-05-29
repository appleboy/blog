---
title: Laravel Homestead 2.0 介紹
author: appleboy
type: post
date: 2014-11-24T04:22:29+00:00
url: /2014/11/introduction-to-laravel-homestead-2-0/
dsq_thread_id:
  - 3256824532
categories:
  - Laravel
  - php
tags:
  - Homestead
  - Laravel
  - Vagrant
  - VirtualBox

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

在九月寫了 [Laravel Homestead 的基礎介紹][1]，最近 [Laravel][2] 推出 Laravel Homestead 2.0，在 1.0 套件是沒有支援 `homestead` 指令，現在 2.0 可以直接使用 `homestead` 指令，前置安裝 [Vagrant][3] + [Virtualbox][4] 就不在此介紹了。

<!--more-->

# 安裝 Homestead

如同上面所說，以前是直接 clone homestead 專案下來就包含了全部 config 檔案，2.0 則是直接支援 `homestead` 指令，可以直接透過 [composer][5] 來安裝

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ composer global require "laravel/homestead=~2.0"</pre>
</div>

完成後可以在使用者目錄發現 `~/.composer/vendor/bin` 目錄，此目錄內會含有 `homestead` 指令，所以只要把 `~/.composer/vendor/bin` 寫入到 `PATH` 變數即可，直接寫到使用者 `.bashrc` 或 `.zhsrc` 設定黨內即可，接著如何產生 Homestead 設定檔，請執行底下指令

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ homestead init</pre>
</div>

到使用者目錄可以看到 `~/.homestead` 裡面就含有 `Homestead.yaml` 設定檔，將此檔案打開

<div>
  <pre class="brush: bash; title: ; notranslate" title="">---
ip: "192.168.10.10"
memory: 2048
cpus: 1

authorize: ~/.ssh/id_rsa.pub

keys:
    - ~/.ssh/id_rsa

folders:
    - map: ~/Code
      to: /home/vagrant/Code

sites:
    - map: homestead.app
      to: /home/vagrant/Code/Laravel/public

databases:
    - homestead

variables:
    - key: APP_ENV
      value: local</pre>
</div>

可以發現跟 1.0 不一樣的地方在於，現在 2.0 可以直接指定 Databases，以及區域變數。另外在 `~/.homestead` 下可以發現多了 `after.sh`，詳細說明如下

> If you would like to do some extra provisioning you may add any commands you wish to this file and they will be run after the Homestead machine is provisioned.
意思是說，中途要增加任何 command 可以將指令寫到 `after.sh` 後，直接執行 `vagrant provision` 即可，而不用登入 `vagrant ssh`。2.0 變化大致如下

  * 支援 homestead 指令
  * 增加 database 及 variables 設定
  * 增加 after.sh

詳細介紹可以參考 [Introducing Laravel Homestead 2.0][6]，更多介紹可以參考 [Laravel Homestead 官方文件][7]，或者直接看 [Laracasts 教學影片][8]。

 [1]: http://blog.wu-boy.com/2014/09/get-homestead-vagrant-vm-running/
 [2]: http://laravel.com
 [3]: https://www.vagrantup.com/
 [4]: https://www.virtualbox.org/wiki/Downloads
 [5]: https://getcomposer.org/
 [6]: http://mattstauffer.co/blog/introducing-laravel-homestead-2.0
 [7]: http://laravel.tw/docs/4.2/homestead
 [8]: https://laracasts.com/lessons/say-hello-to-laravel-homestead-two