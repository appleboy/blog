---
title: PHP 將長期宣導程式設計師將 ext/mysql 改用 pdo_mysql 和 mysqli
author: appleboy
type: post
date: 2011-07-18T02:50:36+00:00
url: /2011/07/php-將長期宣導程式設計師將-extmysql-改用-pdo_mysql-和-mysqli/
dsq_thread_id:
  - 361073051
categories:
  - MySQL
  - php
tags:
  - MySQL
  - PDO
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div> 今天看到一篇 PHP-Dev 公佈一篇 

<a href="http://marc.info/?l=php-internals&m=131031747409271&w=2" target="_blank">[PHP-DEV] deprecating ext/mysql</a>，大意就是 PHP 官方未來將打算移除 ext/mysql 的所有相關文件及功能，作者相信很多程式開發者都是用 mysql 套件下去開發，聽到這消息會非常錯愕吧。 官方 documentation team 討論移除的原因在於安全性的考量，在 <a href="http://blog.gslin.org/archives/2011/07/17/2711/php-%E9%95%B7%E6%9C%9F%E8%A8%88%E7%95%AB%EF%BC%9A%E5%BB%A2%E9%99%A4-extmysql%EF%BC%8C%E6%94%B9%E7%94%A8-pdo_mysql-%E6%88%96-mysqli/" target="_blank">DK 大神</a>那邊看到是使用 ext/mysql 必須自己處理 mysql\_real\_escape\_string 和 mysql\_escape_string，所以官方希望教育使用者不要再使用 ext/mysql 了，底下是官方會做的事情 

  * 增加說明指出 ext/mysql 已過時
  * 建議和取代方案
  * 包含取代方案的範例 官方提供了兩個解決方案 

<a href="http://php.net/manual/en/ref.pdo-mysql.php" target="_blank">pdo_mysql</a> 和 <a href="http://php.net/manual/en/book.mysqli.php" target="_blank">mysqli</a>，官方列了幾點說明： 

  * 從現在開始教育使用者及增加說明文件
  * 在 5.4 版本增加 E_DEPRECATED 訊息，甚至 5.5 6.0 都可以
  * 提供 pdo_mysql 轉換的說明文件
  * 專注於整理 pdo_mysql 跟 mysqli 的線上文件
  * 增加 "The MySQL situation" 的文件說明現況 看完這篇，大家現在趕快轉換到 mysqli 或者是使用 PDO 來開發程式吧