---
title: '[Linux] 使用 yum 更新 redhat enterprise server 4'
author: appleboy
type: post
date: 2006-10-28T00:05:50+00:00
url: /2006/10/linux-使用-yum-更新-redhat-enterprise-server-4/
bot_views:
  - 801
views:
  - 4752
dsq_thread_id:
  - 246757459
categories:
  - Linux
tags:
  - Linux

---
由於 [redhat][1] [enterprise][2] server 4 伺服器版本，沒有提供線上升級套件的功能yum 所以我利用 centos的yum/apt的server來更新 設定檔如下 \[base] name=Fedora Core $releasever &#8211; $basearch &#8211; Base baseurl=http://ftp.isu.edu.tw/pub/Linux/CentOS/4.4/os/$basearch/ [updates-released] name=Fedora Core $releasever &#8211; $basearch &#8211; Released Updates baseurl=http://ftp.isu.edu.tw/pub/Linux/CentOS/4.4/updates/$basearch/ 更新 yum 指令如下 yum的常用指令: yum update [套件1\] \[套件2\] \[&#8230;] 更新套件,若後面不加任何的套件,則會更新所有系統目前已經安裝了的套件 yum install 套件1 [套件2\] \[&#8230;\] 安裝套件 yum upgrade \[套件1\] \[套件2\] \[&#8230;] 升級套件,將一些過舊即將洮汰的套件也一起升級 yum remove 套件1 [套件2\] \[&#8230;\] 移除套件 yum clean packages 清除暫存(/var/cache/yum)目錄下的套件 yum clean headers 清除暫存(/var/cache/yum)目錄下的 headers yum clean oldheaders 清除暫存(/var/cache/yum)目錄下舊的 headers yum clean 或是 yum clean all 清除暫存(/var/cache/yum)目錄下的套件及舊的 headers 等於是執行 yum clean packages 及 yum clean oldheaders yum list 列出所有的套件 yum list updates 列出所有可以更新的套件 yum list installed 列出所有已安裝的套件 yum list extras 列出所有已安裝但不在 Yum Repository 內的套件 yum list \[參數] 列出所指定的套件,參數可以是套件名稱或是在 shell 中所使用的表示式,如 ? 等 yum check-update 檢查可以更新的套件 yum info 列出所有套件的資訊 yum info updates 列出所有可以更新的套件資訊 yum info installed 列出所有已安裝的套件資訊 yum info extras 列出所有已安裝但不在 Yum Repository 內的套件資訊 yum info [參數] 列出所指定的套件資訊,參數可以是套件名稱或是在 shell 中所使用的表示式,如 ? 等 yum provides 套件1 [套件2\] \[&#8230;\] 列出套件提供哪些檔案 yum search [參數] 搜尋套件 reference [http://www.php5.idv.tw/modules.php?mod=books&act=show&shid=2536][3]

 [1]: http://www.redhat.com/ "http://www.redhat.com/"
 [2]: http://www.redhat.com/rhel/ "http://www.redhat.com/rhel/"
 [3]: http://www.php5.idv.tw/modules.php?mod=books&act=show&shid=2536 "http://www.php5.idv.tw/modules.php?mod=books&act=show&shid=2536"