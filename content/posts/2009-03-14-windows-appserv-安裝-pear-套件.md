---
title: '[Windows] Appserv 安裝 pear 套件'
author: appleboy
type: post
date: 2009-03-14T10:49:33+00:00
url: /2009/03/windows-appserv-安裝-pear-套件/
views:
  - 8191
bot_views:
  - 493
dsq_thread_id:
  - 247370475
categories:
  - php
  - windows
  - www
tags:
  - PEAR
  - php

---
最近要在 Windows 上面安裝 [Apache][1] + [MySQL][2] + [PHP][3]，我選擇利用懶人包安裝方法：[Appserv][4]，目前版本為 AppServ 2.5.10 跟 AppServ 2.6.0，如果您要寫 PHP5 的話，就選擇安裝 AppServ 2.5.10，目前支援到 PHP 5.2.6，不過我上次已經看到 [PHP 5.2.9 Released][5] 了，如果想要支援 PHP6，那就選擇 AppServ 2.6.0 這個版本，不過我建議新手可以安裝 AppServ 2.5.10，這個版本比較穩定，安裝好之後，也有支援 phpMyAdmin，底下是 2.5.10 支援的套件： 

> \* Apache 2.2.8 \* PHP 5.2.6 \* MySQL 5.0.51b \* phpMyAdmin-2.10.3  今天要安裝 pear 的套件在 Windows 上面，不過不用緊張，因為 Appserv 已經把 [Pear][6] 的模組包進來裡面了，只要執行 .bat 檔，按照視窗，就可以完成安裝了，自己平常有用 Pear 的 [HTTP_Upload 多重檔案上傳 Multiple files upload][7]，跟 [PEAR - PHP Mail and Mail_Mime 模組][8]，底下就是 Windows 的安裝方法： <!--more--> 1. 首先執行 C:\AppServ\php5\go-pear.bat 

[<img src="https://i1.wp.com/farm2.static.flickr.com/1237/3353580888_9d2a4afb00.jpg?resize=500%2C150&#038;ssl=1" title="Windows_Pear_02 (by appleboy46)" alt="Windows_Pear_02 (by appleboy46)" data-recalc-dims="1" />][9] 此程式會去呼叫 PEAR\go-pear.phar 這隻程式下去執行 2. 設定環境變數： [<img src="https://i1.wp.com/farm2.static.flickr.com/1174/3353580872_ab4ecd390c.jpg?resize=500%2C323&#038;ssl=1" title="Windows_Pear_01 (by appleboy46)" alt="Windows_Pear_01 (by appleboy46)" data-recalc-dims="1" />][10] 這些都是 Appserv 預設好的，所以基本上不用改喔 3. 安裝 Pear 套件 [<img src="https://i1.wp.com/farm2.static.flickr.com/1174/3353580872_ab4ecd390c.jpg?resize=500%2C323&#038;ssl=1" title="Windows_Pear_01 (by appleboy46)" alt="Windows_Pear_01 (by appleboy46)" data-recalc-dims="1" />][10] 4. 選取 php.ini 位置 [<img src="https://i0.wp.com/farm2.static.flickr.com/1194/3352755577_862058ff3b.jpg?resize=500%2C299&#038;ssl=1" title="Windows_Pear_04 (by appleboy46)" alt="Windows_Pear_04 (by appleboy46)" data-recalc-dims="1" />][11] 預設是在 C:\WINDOWS\php.ini 5.安裝完成，請雙點登錄檔 C:\AppServ\php5\PEAR_ENV.reg [<img src="https://i0.wp.com/farm2.static.flickr.com/1196/3352755603_cec0ecda96.jpg?resize=500%2C297&#038;ssl=1" title="Windows_Pear_05 (by appleboy46)" alt="Windows_Pear_05 (by appleboy46)" data-recalc-dims="1" />][12] 這樣就安裝好了喔，可以使用其他好用的模組，那其他安裝方式可以參考[這裡][13] 參考網站： [PEAR在windows下安裝體驗][14]

 [1]: http://www.apache.org/
 [2]: http://www.mysql.com/
 [3]: http://www.php.net
 [4]: http://www.appservnetwork.com/
 [5]: http://blog.wu-boy.com/2009/03/01/842/
 [6]: http://pear.php.net
 [7]: http://blog.wu-boy.com/2009/01/03/677/
 [8]: http://blog.wu-boy.com/2007/12/18/129/
 [9]: https://www.flickr.com/photos/appleboy/3353580888/ "Windows_Pear_02 (by appleboy46)"
 [10]: https://www.flickr.com/photos/appleboy/3353580872/ "Windows_Pear_01 (by appleboy46)"
 [11]: https://www.flickr.com/photos/appleboy/3352755577/ "Windows_Pear_04 (by appleboy46)"
 [12]: https://www.flickr.com/photos/appleboy/3352755603/ "Windows_Pear_05 (by appleboy46)"
 [13]: http://pear.php.net/manual/en/installation.php
 [14]: http://kevin-wei.blogspot.com/2007/05/pearwindows.html