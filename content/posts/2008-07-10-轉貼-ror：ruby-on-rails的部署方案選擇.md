---
title: '[轉貼] RoR：Ruby on Rails的部署方案選擇'
author: appleboy
type: post
date: 2008-07-10T02:04:01+00:00
url: /2008/07/轉貼-ror：ruby-on-rails的部署方案選擇/
views:
  - 4726
bot_views:
  - 844
dsq_thread_id:
  - 247295817
categories:
  - apache
  - FreeBSD
  - Lighttpd
  - Linux
  - MySQL
  - www
tags:
  - apache
  - HAProxy
  - lighttpd
  - litespeed
  - MySQL
  - nginx

---
我沒在玩 [Ruby on Rails][1]，但是底下這一篇我覺得寫的不錯，可以參考看看，裡面有介紹一下目前當紅 web daemon 的一些基本知識 

> RoR的部署方式從架構上來說分為前端和後端： 一、前端 前端的作用就是處理靜態資源，將動態請求分發到後端，有時候也帶有一些額外的功能，例如對特定URL進行rewrite和redirect，對HTTP輸出進行gzip壓縮等等。 前端目前已知的可以選擇apache, lighttpd, litespeed, nginx, haproxy 1、apache2.2 apache是全球市場佔有率最高的web server，超過全球互聯網網站50%的網站都用apache。apache2.2 + mod\_proxy\_balancer是一個非常流行，非常穩定的方案。 使用apache2.2唯一的問題就是apache的性能和後面那些輕量級web server相比，差太遠了。一方面在處理靜態請求方面apache要比lighttpd慢3-5倍，內存消耗和CPU消耗也高出一個數量級，另一方面 mod\_proxy\_balancer的分發性能也不高，比haproxy差很遠。 2、lighttpd lighttpd 是一個輕量級高性能web server，一個在MySQL Inc工作的德國人寫的。性能很好，內存和CPU資源消耗很低，支持絕大多數apache的功能，是apache的絕好替代者。目前lighttpd已經上升到全球互聯網第四大web server，市場佔有率僅此於apache，IIS和Sun。 lighttpd唯一的問題是proxy功能不完善，因此不適合搭配mongrel來使用。lighttpd下一個版本1.5.0的proxy模塊重寫過了，將會解決這個問題。 3、litespeed 和 lighttpd差不多，商業產品，收費的。比lighttpd來說，多一個web管理界面，不用寫配置文件了。litespeed專門為單機運行的 RoR開發了一個lsapi協議，號稱性能最好，比httpd和fcgi都要好。他的proxy功能比lighttpd完善。 litespeed 的缺點我卻認為恰恰是這個lsapi。因為lsapi不是web server啟動的時候啟動固定數目的ruby進程，而是根據請求繁忙程度，動態創建和銷毀ruby進程，貌似節省資源，實則和apache2.2進程模型一樣，留下很大的黑客攻擊漏洞。只要黑客瞬時發起大量動態請求，就會讓服務器忙於創建ruby進程而導致CPU資源耗盡，失去響應。 當然，litespeed也支持httpd和fcgi，這個和lighttpd用法一樣的，到沒有這種問題。 4、nginx 一個俄國人開發的輕量級高性能web server，特點是做proxy性能很好，因此被推薦取代apache2.2的mod\_proxy\_balancer，來和mongrel cluster搭配。其他方面和lighttpd到差不多。 要說缺點，可能就是發展的時間比較短，至今沒有正式版本，還是beta版。沒有經過足夠網站的驗證。 5、haproxy 就是一個純粹的高性能proxy，不處理靜態資源的，所有請求統統分發到後端。 二、後端 後端就是跑ruby進程，處理RoR動態請求了。運行後端ruby進程有兩種方式： 1、fcgi方式 準確的說，不能叫做fcgi方式，其實就是啟動一個ruby進程，讓這個ruby進程監聽一個tcp/unix socket，以fcgi協議和前端通訊。所以fcgi不是指ruby進程的運行方式，而是ruby進程使用的通訊協議。這就好比你tomcat可以用 http也可以使用ajp通訊一樣，tomcat自己的運行方式都一樣的，只是通訊方式不一樣。 fcgi方式啟動ruby進程，可以使用lighttpd帶的一個spawn-fcgi工具來啟動(JavaEye目前採用這種方式)。 值得一提的是，apache2.2的mod\_fastcgi的方式和上面還不太一樣，由apache動態創建fcgi進程和管理fcgi進程，這種方式和 litespeed的lsapi面臨的問題是一樣的，此外apache的mod\_fastcgi自己也有很多嚴重的bug，是一種很糟糕的部署方式。這種糟糕的部署方式也敗壞了fcgi的名聲。 fastcgi只是一種協議，雖然古老，但並不是不好用，http協議也很古老。沒有必要因為 apache的mod\_fastcgi的運行方式的問題而連帶把fastcgi都一同否定了。fastcgi只是一個協議(程序之間的語言)，是 apache的mod\_fastcgi這個模塊有問題。打個比方，有個人英語水平很差，和你用英語對話，總是結結巴巴的，那你說是英語(fastcgi) 這種語言有問題呢？還是和你對話的這個人 (mod_fastcgi)有問題呢？ 2、http方式 也就是用mongrel去跑ruby進程，由於mongrel實際上已經是一個簡單的http server，所以也可以單獨作為web server使用。mongrel現在越來越受歡迎了。 用fcgi方式還是http方式，我個人覺得區別不大，關鍵還是看應用的場合，一般而言，推薦的搭配是： lighttpd ＋ fcgi 或者 nginx ＋mongrel，而apache因為性能差距，而不被推薦。 JavaEye為什麼用lighttpd ＋ fcgi呢？原因如下： 1) lighttpd發展了好幾年了，市場佔有率也相當高，是一個經過實踐檢驗的server，它的文檔也很全；而nginx還沒有經過足夠的市場檢驗，文檔也很缺乏 2) JavaEye的ruby進程和web server在一台機器上面跑，通過unix socket使用fcgi協議通訊可以避免tcp的網絡開銷，其通訊速度比使用tcp socket使用http協議通訊要快一些。 什麼場合使用haproxy？ 大規模部署，例如你的RoR應用到十幾台服務器上面去，你用haproxy會更好，可以方便的添加刪除應用服務器節點，proxy性能更好。 資料來源： Csdn &#8211; http://news.csdn.net/n/20071229/112274.html

 [1]: http://www.rubyonrails.org/