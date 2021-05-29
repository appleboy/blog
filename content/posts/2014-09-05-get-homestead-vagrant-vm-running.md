---
title: 快速安裝 Laravel Homestead 環境
author: appleboy
type: post
date: 2014-09-05T03:56:35+00:00
url: /2014/09/get-homestead-vagrant-vm-running/
dsq_thread_id:
  - 2989580319
categories:
  - Laravel
  - php
tags:
  - Homestead
  - Laravel
  - Laravel Homestead
  - php

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

在看本篇安裝教學前可以參考翻譯完成的 [Laravel Homestead][1]，此篇會紀錄如何在 Ubuntu 底下快速架設 [Laravel][2] 環境，對於一般新手而言，剛開始安裝 Laravel 開發環境一定會遇到許多問題，為了解決開發環境，Laravel 推出 Homestead 搭配 Vagrant Box，讓初學者不用為環境問題而煩惱，減少浪費時間在架設 Laravel。簡單來說 Laravel Homestead = Vagrant + [VirtualBox][3] + Laravel 安裝包。底下簡單幾個步驟就可以完成 Laravel 開發環境。

<!--more-->

### 步驟一：事前準備

由於 Laravel Homestead 是由 Vagrant + VirtualBox 組成，所以環境請先安裝好這兩個套件

  * [安裝 Vagrant Installer][4]
  * [安裝 Virtual Box][5]

假如您是 Windows 開發環境，請多安裝 [Bash Tool][6]，完成後你需要透過 Vagrant 下載封裝好的安裝包

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ vagrant box add laravel/homestead</pre>
</div>

由於檔案還蠻大的，需要一段時間，請耐心等候

### 步驟二: 安裝 Homestead 程式碼

此部份為 Vagrant 的設定檔，請直接抓取官方 Homestead 程式碼

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ git clone https://github.com/laravel/homestead.git Homestead</pre>
</div>

### 步驟三: 設定虛擬目錄

此步驟為設定開發虛擬目錄及相對應主機名稱，請先打開 `Homestead.yaml`

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

variables:
    - key: APP_ENV
      value: local</pre>
</div>

這邊需要注意的就是 `folders` 及 `sites` 兩項設定，假設今天你有兩個 Laravel 網站需要設定，環境相關路徑如下

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># 網站一
主目錄: /home/git/laravel_1
public 目錄: /home/git/laravel_1/public
網域名稱: a.tw
# 網站二
主目錄: /home/git/laravel_2
public 目錄: /home/git/laravel_2/public
網域名稱: b.tw</pre>
</div>

則我們在 `Homestead.yaml` 內則設定如下

<div>
  <pre class="brush: bash; title: ; notranslate" title="">folders:
    - map: /home/git/laravel_1
      to: /home/vagrant/laravel_1
    - map: /home/git/laravel_2
      to: /home/vagrant/laravel_2

sites:
    - map: a.tw
      to: /home/vagrant/laravel.tw/public
    - map: b.tw
      to: /home/vagrant/laravel.tw/public</pre>
</div>

### 步驟四: 設定主機名稱

設定連接虛擬目錄的網域名稱，請打開 `/etc/hosts` 加入兩行設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">127.0.0.1 a.tw
127.0.0.1 b.tw</pre>
</div>

之後就可以透過這兩個虛擬網域來開發了

### 步驟五: 啟動 Vagrant up

最後請在 Homestead 目錄下執行 `vagrant up` 啟動訊息可以發現底下 port mapping

<div>
  <pre class="brush: bash; title: ; notranslate" title="">default: 80 =&gt; 8088 (adapter 1)
default: 3306 =&gt; 33060 (adapter 1)
default: 5432 =&gt; 54320 (adapter 1)
default: 22 =&gt; 2222 (adapter 1)</pre>
</div>

如果 port 已經被佔用，請修改 `scripts/homestead.rb`

<div>
  <pre class="brush: ruby; title: ; notranslate" title=""># Configure Port Forwarding To The Box
config.vm.network "forwarded_port", guest: 80, host: 8088
config.vm.network "forwarded_port", guest: 3306, host: 33060
config.vm.network "forwarded_port", guest: 5432, host: 54320
</pre>
</div>

如果你要啟動時更新系統套件及 composer 話請加入底下程式碼

<div>
  <pre class="brush: ruby; title: ; notranslate" title=""># Copy The Bash Aliases
config.vm.provision "shell" do |s|
  s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
end</pre>
</div>

改成

<div>
  <pre class="brush: ruby; title: ; notranslate" title=""># Copy The Bash Aliases
config.vm.provision "shell" do |s|
  s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
  s.inline = "sudo apt-get update"
  s.inline = "sudo composer self-update"
end</pre>
</div>

透過 `vagrant ssh` 可以登入系統，目前系統預設環境已經升級到 PHP 5.6.0 了，感謝 Laravel 作者更新 Box。

<div>
  <pre class="brush: bash; title: ; notranslate" title="">PHP 5.6.0-1+deb.sury.org~trusty+1 (cli) (built: Aug 28 2014 14:55:42) 
Copyright (c) 1997-2014 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2014 Zend Technologies
    with Zend OPcache v7.0.4-dev, Copyright (c) 1999-2014, by Zend Technologies
    with Xdebug v2.2.5, Copyright (c) 2002-2014, by Derick Rethans
</pre>
</div>

如果你的 Hoststead 並非是 5.6.0 環境，請直接透過 `vagrant box update` 更新 Box。最後補上啟動截圖

<img src="https://i2.wp.com/farm4.staticflickr.com/3898/15143491542_93d7679f85_z.jpg?w=840&#038;ssl=1" alt="快速安裝 Laravel Homestead 環境" data-recalc-dims="1" />

 [1]: http://laravel.tw/docs/homestead
 [2]: http://Laravel.tw
 [3]: https://www.virtualbox.org/
 [4]: https://www.vagrantup.com/downloads.html
 [5]: https://www.virtualbox.org/wiki/Downloads
 [6]: http://git-scm.com/downloads