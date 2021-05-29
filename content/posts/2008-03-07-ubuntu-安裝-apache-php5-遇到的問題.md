---
title: '[Ubuntu] 安裝 apache php5 遇到的問題'
author: appleboy
type: post
date: 2008-03-07T14:49:55+00:00
url: /2008/03/ubuntu-安裝-apache-php5-遇到的問題/
views:
  - 5548
bot_views:
  - 549
dsq_thread_id:
  - 247452465
categories:
  - apache
  - Linux
  - php
  - www

---
很奇怪的，今天在安裝 apache2 跟 php5 想說很簡單，可是安裝好，寫測試檔測試的時候，發現當會變成下載 php5 的檔案，然後我看了一下 apache2.conf 觀察到如下 <IfModule mod_php5.c> AddType application/x-httpd-php .php .phtml .php3 AddType application/x-httpd-php-source .phps </IfModule> LoadModule php5_module /usr/lib/apache2/modules/libphp5.so 然後我去 /usr/lib/apache2/modules/ 底下看，也有看到 libphp5.so 這個檔案，但是就是不能執行 php，後來在 ubuntu 官網找到解答，解答方法如下 

> 檢查 /etc/apache2/mods-enabled 內有沒有php5.conf , php5.load若沒有, 請 sudo a2enmod php5 重新啟動 apahce2 sudo /etc/init.d/apache2 restart
[ http://www.ubuntu.org.tw/modules/newbb/viewtopic.php?viewmode=flat&type=&topic_id=5298&forum=9][1]

 [1]: http://www.ubuntu.org.tw/modules/newbb/viewtopic.php?viewmode=flat&type=&topic_id=5298&forum=9