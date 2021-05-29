---
title: 在 Ubuntu 底下快速安裝 CakePHP Framework 環境
author: appleboy
type: post
date: 2011-05-11T12:51:38+00:00
url: /2011/05/在-ubuntu-底下快速安裝-cakephp-framework-環境/
views:
  - 148
bot_views:
  - 146
dsq_thread_id:
  - 300959088
categories:
  - CakePHP
tags:
  - CakePHP
  - php
  - Ubuntu

---
最近因為別的專案用到 [CakePHP][1] 這套 PHP Framwork，剛好有這機會來學習 CakePHP，目前已經 Release 到 [1.3.8 & 1.2.10 Stable][2]，本篇紀錄如何在 Ubuntu 10.10 安裝 1.3.8 版本，本人不推薦用 2.0， 因為踩到很多雷阿，大家可以到 [CakePHP GitHub][3] 找尋自己想要的版本，安裝環境如下: 

> Ubunut 10.10 32 Desktop 版本 Apache/2.2.16 (Ubuntu) PHP 5.3.3-1ubuntu9.5 with Suhosin-Patch (cli) MySQL 5.1.49 1. 先下載 [1.3.8][4] 版本 2. 解壓縮到 **<span style="color:green">/var/www</span>** 底下 3. 設定 apache virtual host 複製 virtual host 設定檔 

<pre class="brush: bash; title: ; notranslate" title="">cp /etc/apache2/sites-available/default /etc/apache2/sites-available/cakephp</pre> 修改設定檔 

<pre class="brush: bash; title: ; notranslate" title="">ServerName  cakephp.localhost
    DocumentRoot /var/www/cakephp/app/webroot
    &lt;Directory /var/www/cakephp/app/webroot>
        Options All
        AllowOverride All
        Order allow,deny
        allow from all
    &lt;/Directory></pre> 4. 啟動 apache virtual host 跟 mod_rewrite 模組 

<pre class="brush: bash; title: ; notranslate" title="">a2enmod rewrite
a2ensite cakephp
</pre> ServerName 部份可以自己亂取，之後到 

<span style="color:green"><strong>/etc/hosts</strong></span> 裡面加入 127.0.0.1 就可以了 5. 將 **<span style="color:green">app/tmp</span>** 目錄改成 apache 使用者，這樣確定該目錄可以寫入 大致上就這樣完成了，可以參考 [CakePHP 線上手冊][5]

 [1]: http://cakephp.org/
 [2]: http://bakery.cakephp.org/articles/markstory/2011/03/20/cakephp_1_3_8_and_1_2_10_released
 [3]: https://github.com/cakephp/cakephp/downloads
 [4]: https://github.com/cakephp/cakephp/zipball/1.3.8
 [5]: http://book.cakephp.org/