---
title: '[RHEL]Installing PHP 5.1.x 5.2.x or 5.3.x on RedHat ES5, CentOS 5'
author: appleboy
type: post
date: 2009-09-08T02:34:10+00:00
url: /2009/09/rhelinstalling-php-52x-or-53x-on-redhat-es5-centos-5/
views:
  - 13770
bot_views:
  - 1085
dsq_thread_id:
  - 246766766
categories:
  - Linux
tags:
  - Linux
  - php
  - RHEL

---
最近幫公司處理一台 RHEL 機器，把原本的 PHP 版本 5.1.6 升級到 5.3.0，不過因為 5.3.0 把很多支援的函數都拿掉了，造成很 open source 套件都沒辦法支援，[phpMyAdmin][1] 也要換成 3 版以上才可以運作，PHP 5.3.0 已經不支援很多函數，可以參考 [Deprecated features in PHP 5.3.x][2]，有用到 [ereg()][3] 或者是 [eregi()][4] 都必須統統換成 [preg_match()][5]，最後終究因為 json 的關係，把 PHP 升級到 5.2 以上才有支援，參考了一篇 [Installing PHP 5.2.x or 5.3.x on RedHat ES5, CentOS 5, etc][6]，作法其實很容易，不用幾個指令就可以完成了 

<pre class="brush: bash; title: ; notranslate" title="">wget http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
rpm -Uvh remi-release-5*.rpm epel-release-5*.rpm</pre> 如果是 X86_64 的，請自行更換網址，這裡有些注意的是，你要升級 PHP 請利用下面： 

<pre class="brush: bash; title: ; notranslate" title="">yum --enablerepo=remi update php</pre> 不過升級的時候，必須把 MySQL 也一併升級，不然會出現錯誤，原本的 MySQL 套件用 yum remove 移除掉，在利用 yum --enablerepo=remi 方式升級 MySQL 跟 PHP 套件，就可以了。 在 RHEL 裡面，PHP 5.1.6 也是可以支援 pecl-json 的，利用 yum search 然後安裝就ok了 

> php-pecl-json.x86_64 : PECL library to implement JSON in PHP<pre class="brush: bash; title: ; notranslate" title="">yum install php-pecl-json</pre>

 [1]: http://www.phpmyadmin.net/home_page/index.php
 [2]: http://tw.php.net/manual/en/migration53.deprecated.php
 [3]: http://tw.php.net/manual/en/function.ereg.php
 [4]: http://tw.php.net/manual/en/function.eregi.php
 [5]: http://tw.php.net/manual/en/function.preg-match.php
 [6]: http://bluhaloit.wordpress.com/2008/03/13/installing-php-52x-on-redhat-es5-centos-5-etc/