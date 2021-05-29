---
title: '[Ubuntu] 安裝 java-tool for Flickr upload tool'
author: appleboy
type: post
date: 2006-11-18T10:28:55+00:00
url: /2006/11/ubuntu-安裝-java-tool-for-flickr-upload-tool/
bot_views:
  - 726
views:
  - 3498
dsq_thread_id:
  - 246819339
categories:
  - Linux
  - Network
tags:
  - Java
  - Linux
  - Ubuntu

---
國外知名的相簿網站 [Zooomr][1]　[Flickr][2] 有支援同一套上傳軟體，２個相簿的網頁空間分別如下 Flickr 升級後如下 [<img style="border: medium none " alt="Upgrade to a Pro Account today for just $24.95! Click here!" src="https://i2.wp.com/www.flickr.com/images/new_upgrade_page.gif?resize=510%2C302&#038;ssl=1" data-recalc-dims="1" />][3] 還蠻便宜的，zooomr　則是　１００ＭＢ用完就沒有了，Flickr 則是每個月可以上傳２０ＭＢ 接下來～來說明　ｕｂｕｎｔｕ安裝方式 下載Flickr 上傳軟體　[http://juploadr.sourceforge.net/][4] 下載之後，解壓縮到桌面 ，到該資料夾之後執行 ./jUploadr , 不過如果你沒有安裝ｊａｖａ的話，會執行失敗 首先安裝ｊａｖａ apt-get install sun-java5*　java-package 安裝時會出現下面錯誤訊息 

> This package is an installer package, it does not actually contain the J2SDK documentation. You will need to go download one of the archives: jdk-1\_5\_0-doc.zip jdk-1\_5\_0-doc-ja.zip (choose the non-update version if this is the first installation). Please visit http://java.sun.com/j2se/1.5.0/download.html now and download. The file should be owned by root.root and be copied to /tmp. 這時候要去下載　去 [www.google.com.tw][5] 收尋　jdk-1\_5\_0-doc-ja.zip　第一個收尋就是了 然後分別下載　jdk-1\_5\_0-doc.zip　jdk-1\_5\_0-doc-ja.zip 然後在放到　/tmp/　底下 ，然後在重新執行 

> apt-get install sun-java5*　java-package 然後完成之後，在執行 

> update-java-alternatives -s java-1.5.0-sun 這樣就可以了，大功告成 [<img alt="Screensho11t" src="https://i2.wp.com/static.flickr.com/113/300502144_cff60a077c_o.jpg?resize=452%2C601" data-recalc-dims="1" />][6] [<img alt="Screenshot" src="https://i2.wp.com/static.flickr.com/100/300502173_0ec877095c_o.jpg?resize=646%2C455" data-recalc-dims="1" />][7]

 [1]: http://beta.zooomr.com/home "http://beta.zooomr.com/home"
 [2]: https://www.flickr.com/ "https://www.flickr.com/"
 [3]: https://www.flickr.com/account/order/ "Click here to upgrade your account"
 [4]: http://juploadr.sourceforge.net/ "http://juploadr.sourceforge.net/"
 [5]: http://www.google.com.tw "http://www.google.com.tw"
 [6]: https://www.flickr.com/photos/10526457@N00/300502144/ "Photo Sharing"
 [7]: https://www.flickr.com/photos/10526457@N00/300502173/ "Photo Sharing"