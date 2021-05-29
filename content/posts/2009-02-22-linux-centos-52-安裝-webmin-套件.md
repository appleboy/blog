---
title: '[Linux] CentOS 5.2 安裝 Webmin 套件'
author: appleboy
type: post
date: 2009-02-22T06:55:35+00:00
url: /2009/02/linux-centos-52-安裝-webmin-套件/
views:
  - 13293
bot_views:
  - 615
dsq_thread_id:
  - 246711966
categories:
  - FreeBSD
  - Linux
tags:
  - Linux
  - rpm
  - Webmin

---
目前幫台北朋友維護一台 [CentOS][1] 5.2 主機，想試試看的可以來 [這裡][2] 下載，在剛開始裝好的時候，預設好像沒有把 [Webmin][3] 給裝上去，所以就要去網路上找 rpm 來安裝，如果是要找 rpm 套件，我個人推薦 <http://rpm.pbone.net/>，裡面可以搜尋到相關您想要的套件，也可以找到很多 mirror site 網站，相當方便，首先我們可以輸入 webmin 來找尋套件，可以找到此套件：[webmin-1.420-1.noarch.rpm][4] 這是給 Centos 安裝的。 [<img title="RPM Search webmin_1235284992618 (by appleboy46)" src="https://i0.wp.com/farm4.static.flickr.com/3299/3299708090_84fa4f1240.jpg?resize=370%2C500&#038;ssl=1" alt="RPM Search webmin_1235284992618 (by appleboy46)" data-recalc-dims="1" />][5] <!--more--> 利用 wget 下載套件，在使用 rpm -ivh 來安裝此套件 

<pre class="brush: bash; title: ; notranslate" title="">wget ftp://ftp.pbone.net/mirror/yum.trixbox.org/centos/5/trixswitch/webmin-1.420-1.noarch.rpm
rpm -ivh webmin-1.420-1.noarch.rpm
#
# 開機自動開啟服務 level 3 純文字模式開機 level 5 圖形介面
chkconfig  --level 3 webmin on
</pre> 安裝好就可以輸入網址：

[http://url\_host\_name:10000/][6] 可以先去官方網站使用看看：<http://webmin.com/demo.html> 登入畫面： [<img src="https://i1.wp.com/farm4.static.flickr.com/3214/3298888753_b7fb066ee1.jpg?resize=395%2C182&#038;ssl=1" title="webmin_login (by appleboy46)" alt="webmin_login (by appleboy46)" data-recalc-dims="1" />][7] 登入之後： [<img src="https://i0.wp.com/farm4.static.flickr.com/3424/3299718522_0dbd9434cf.jpg?resize=500%2C214&#038;ssl=1" title="webmin_index (by appleboy46)" alt="webmin_index (by appleboy46)" data-recalc-dims="1" />][8] **Update 2009.02.23：留言網友說 Webmin 最新版：1.45 可以從 [官方網站][9] 下載就可以了喔，之前沒注意到，感謝網友**

 [1]: http://www.centos.org/
 [2]: http://isoredirect.centos.org/centos/5/isos/i386/
 [3]: http://webmin.com/
 [4]: http://rpm.pbone.net/index.php3/stat/4/idpl/7974770/com/webmin-1.420-1.noarch.rpm.html
 [5]: https://www.flickr.com/photos/appleboy/3299708090/ "RPM Search webmin_1235284992618 (by appleboy46)"
 [6]: http://url_host_name:10000/
 [7]: https://www.flickr.com/photos/appleboy/3298888753/ "webmin_login (by appleboy46)"
 [8]: https://www.flickr.com/photos/appleboy/3299718522/ "webmin_index (by appleboy46)"
 [9]: http://www.webmin.com/download.html