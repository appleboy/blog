---
title: WordPress 2.8.5 Hardening Release
author: appleboy
type: post
date: 2009-10-22T12:37:16+00:00
url: /2009/10/wordpress-2-8-5-hardening-release/
views:
  - 5279
bot_views:
  - 629
dsq_thread_id:
  - 247296004
categories:
  - blog
  - wordpress
tags:
  - blog
  - php
  - wordpress

---
<img src="https://i2.wp.com/s.wordpress.org/about/images/buttons/buttonw-blue.png?w=840" alt="wordpress logo" data-recalc-dims="1" /> [WordPress][1] 在10月20號發出安全性的更新，大家快把 2.8.4 升級到 2.8.5，可以參考 [WordPress 2.8.5: Hardening Release][2]，這次更新最主要是在安全性的議題，Wordpress 團隊在過去幾個月已經開始針對 2.9 進行新功能上的開發，但是在 2.8 branch 的版本如果有安全性的漏洞，官方網站還是會提出修正的，以增加網站的安全。 底下是一些 Release 的安全性改良： 

>   * A fix for the Trackback Denial-of-Service attack that is currently being seen.
>   * Removal of areas within the code where php code in variables was evaluated.
>   * Switched the file upload functionality to be whitelisted for all users including Admins.
>   * Retiring of the two importers of Tag data from old plugins 假如您的網站最近有受到攻擊，那可以利用官網提供的弱點掃描工具 
[WordPress Exploit Scanner][3] 來針對網站檔案以及資料庫內容文章，還有 comment 的資料表，以及所裝的 plugin 檔案進行漏洞檢查。 升級方式很容易，可以參考之前寫的 [[wordpress] 快速升級 Upgrade 2.5.0 -> 2.5.1 for Linux & FreeBSD][4] ps. [FreeBSD][5] commit 到 ports 裡面了，參考：[ports/139812][6]

 [1]: http://wordpress.org/
 [2]: http://wordpress.org/development/2009/10/wordpress-2-8-5-hardening-release/
 [3]: http://wordpress.org/extend/plugins/exploit-scanner/
 [4]: http://blog.wu-boy.com/2008/04/27/192/
 [5]: http://www.freebsd.org
 [6]: http://www.freebsd.org/cgi/query-pr.cgi?pr=139812