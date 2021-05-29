---
title: PHP 免費雲端主機 PHPFog vs Pagoda vs AppFog
author: appleboy
type: post
date: 2012-10-20T02:35:52+00:00
url: /2012/10/php-cloud-hosting-phpfog-pagoda-appfog/
dsq_thread_id:
  - 892339120
categories:
  - Git
  - php
  - www
tags:
  - AppFog
  - git
  - Pagoda
  - php
  - phpfog

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div> 今天筆者來介紹幾套目前免費的雲端虛擬主機服務，自從 

<a href="http://git-scm.com/" target="_blank">Git</a> 版本控制的出現後，大家可以發現，以往免費的虛擬主機搭配後台 Panel，這種模式已經不再看到，取代而之的就是用 Git 來管理程式碼，而不是用 FTP 上下傳方式了。筆者認為學會 Git，是一件非常重要的事情，這樣可以嘗試不同雲端服務，，像是 <a href="https://phpfog.com/" target="_blank">PHPFog</a>，<a href="https://pagodabox.com/" target="_blank">Pagoda Box</a>，<a href="http://www.appfog.com/" target="_blank">AppFog</a> ...等。這次介紹的雲端主機服務不同於 <a href="http://www.linode.com/" target="_blank">Linode VPS</a>，Linode 是可以拿到完整的虛擬主機權限，可以進行主機的效能優化，以及安裝合適的套件。 <!--more-->

### PHPFog 這是一家筆者非常推薦的雲端服務，操作起來是最簡單的，建立新的 Application 不會超過五分鐘，也不需要設定煩人且複雜的 firewalls, Apache, security ..等，一切都由系統會調整設定好，另外可以安裝目前流行的 App 服務，像是 

<a href="http://wordpress.org/" target="_blank">WordPress</a>， <a href="http://drupal.org/" target="_blank">Drupal</a>， Sugar CRM， or Joomla ..等，或者是 PHP Framework: <a href="http://cakephp.org/" target="_blank">CakePHP</a>, <a href="http://framework.zend.com/" target="_blank">Zend Framework</a>, or <a href="http://www.codeigniter.org.tw" target="_blank">CodeIgniter</a> 等，那使用者該如何存取檔案呢，就如同筆者所說的，透過 git clone 將檔案下載 git commit 紀錄修改的資料 git push 更新伺服器檔案 git revert 恢復檔案 ... 等，PHPFog 也有直接提供 <a href="http://www.phpmyadmin.net/home_page/index.php" target="_blank">phpMyAdmin</a> 讓使用者直接存取資料庫，免費帳號可以使用 20MB，另外可以開3個 Application，這大概是唯一的缺點，除了這些以外，介面簡單，也沒有其他需要設定了，推薦給大家。 

### Pagoda Box An Object Oriented Hosting Framework 一樣提供了目前比較 popular 的 Framework，跟 PHPFog 比較不同的是，您可以根據專案架構來調整伺服器，Web,Cache,database,Works 等，價格也是依照您使用的機器來決定，可以

<a href="https://pagodabox.com/cloud-hosting-price#/web=24.c.200" target="_blank">參考這裡</a>，登入後看到的 Dashboard 功能蠻完整的，隨時可以調整架構增加記憶體等等，但是缺點是不提供 phpMyAdmin 控管資料庫，如果要把自己的 DB 匯入到 Pagoda，則必須安裝 pagoda 指令，接著用 Tunnel 方式連到 MySQL，在用 MySQL 指令匯入資料庫，這邊 Tunnel 請用 127.0.0.1 而不要用 localhost，不然永遠連不上伺服器。這真是奇怪的雷，另外如果 DB 很大的話，筆者覺得可以放棄了，因為光是 10MB 的 DB 就要花很多時間了，所以筆者最後也放棄了，另外 DB 也只有 10 MB 的免費記憶體使用，不過沒關係，也可以不用 pagoda 的 DB 服務，可以在程式碼連到別台 DB 機器即可。 <a href="https://pagodabox.com/cloud-hosting-price#/web=1.c.200" target="_blank">看看價目表</a> 

### AppFog 直接先看影片介紹 可以無限制建立 App，並且免費提供 2G Ram 讓使用者自行分配 50GB 免費流量，但是不確定是單月還是單天？支援 

<a href="http://www.java.com/zh_TW/" target="_blank">Java</a>, .Net, <a href="http://www.ruby-lang.org/en/" target="_blank">Ruby</a>, <a href="http://nodejs.org/" target="_blank">Node</a>, <a href="http://www.python.org/" target="_blank">Python</a>, <a href="http://www.php.net" target="_blank">PHP</a> 等程式語言，資料庫支援 <a href="http://www.mysql.com/" target="_blank">MySQL</a>, <a href="http://www.mongodb.org/" target="_blank">Mongo</a>, <a href="http://www.postgresql.org/" target="_blank">PostgreSQL</a>，資料庫大小可以 100MB 到 1GB。免費的部份就已經夠大家去玩了。建立 App 時候需要選擇程式語言以及搭配 <a href="http://aws.amazon.com/" target="_blank">Amazon AWS</a> 所屬機器(目前有 Asia Southeas, Europe West, US East)。如果要搭配資料庫，一樣也是透過 af 指令搭配 Tunnel 方式存取，匯入的速度不盡理想，所以想嘗試的玩家還是要有點心理準備。 介紹了3個雲端服務，個人玩後的感想就是"免費的玩玩看看就好"，如果真正要 Run Service，還是需要租用 AWS 或者是考慮付費專案。