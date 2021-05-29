---
title: '[Linux] CentOS 4.4 安裝過程 NAS 2U Server'
author: appleboy
type: post
date: 2006-11-26T17:17:01+00:00
url: /2006/11/linux-centos-44-安裝過程-nas-2u-server/
bot_views:
  - 1550
views:
  - 8937
dsq_thread_id:
  - 246791334
categories:
  - Linux
  - th.gov.tw
tags:
  - Centos
  - Linux

---
新主機 2u nas server 

  * 2顆amd Opteron 2.2ghz
  * 機架高度2u
  * 2*1GB RAM ECC DDR400
  * SCSI硬碟 ULTRA320磁碟陣列卡支援RAID0，1，5，1000RPM 72GB4顆
  * 網路卡10/100/ 1000 Mbps介面卡2個
  * 主機板型號<span class="mb-model-name" style="color: #1a1a1a">GA-7A8DRH <a title="http://www.gigabyte.com.tw/Products/Networking/Products_Spec.aspx?ProductID=1063" href="http://www.gigabyte.com.tw/Products/Networking/Products_Spec.aspx?ProductID=1063">連結</a></span>

[<img alt="主機照片" src="https://i1.wp.com/static.flickr.com/122/307475431_442e5f0226.jpg?resize=500%2C375" data-recalc-dims="1" />][1] 上面那台，下面那台也是NAS WIN2003 SERVER 

  * 安裝步驟：
> 利用光碟開機，鍵入linux dd[<img src="https://i1.wp.com/static.flickr.com/113/307475117_21612aa6fd.jpg?resize=500%2C375" alt="DSCF0059" data-recalc-dims="1" />][2] <!--more-->

> 要先安裝scsi的driver，所以要選floppy[<img src="https://i1.wp.com/static.flickr.com/106/307475312_831ed5aa3b.jpg?resize=500%2C375" alt="DSCF0063" data-recalc-dims="1" />][3] 

> 選擇完成之後，按下確定重複2次[<img src="https://i1.wp.com/static.flickr.com/106/307475274_7f387ad221.jpg?resize=500%2C375" alt="DSCF0062" data-recalc-dims="1" />][4] 

> 然後會看到下面選驅動程式的畫面[<img src="https://i2.wp.com/static.flickr.com/103/307475346_839c162e81.jpg?resize=500%2C375" alt="DSCF0064" data-recalc-dims="1" />][5] 

> 然後選擇我們scsi的介面 i2o driver[<img src="https://i2.wp.com/static.flickr.com/116/307475368_0d8ac975e7.jpg?resize=500%2C375" alt="DSCF0065" data-recalc-dims="1" />][6] 

> 然後就會正確抓到我們的硬碟 i2o/hda[<img src="https://i0.wp.com/static.flickr.com/113/307475402_939be7e21a.jpg?resize=500%2C375" alt="DSCF0066" data-recalc-dims="1" />][7] 再來就是教學，如何把driver 燒入到floppy裡面 ，先下載windows版的linux dd <http://uranus.it.swin.edu.au/~jn/linux/rawwrite.htm> 然後下載scsi driver [http://163.29.208.22/i2o/dpt\_i20-drv\_2.5.0-rh9-i686.img][8] 分割硬碟如下，切割LVM [<img src="https://i1.wp.com/static.flickr.com/118/307475518_0fe63906a1.jpg?resize=500%2C375" alt="分割硬碟 LVM" data-recalc-dims="1" />][9]

 [1]: https://www.flickr.com/photos/appleboy/307475431/ "Photo Sharing"
 [2]: https://www.flickr.com/photos/appleboy/307475117/ "Photo Sharing"
 [3]: https://www.flickr.com/photos/appleboy/307475312/ "Photo Sharing"
 [4]: https://www.flickr.com/photos/appleboy/307475274/ "Photo Sharing"
 [5]: https://www.flickr.com/photos/appleboy/307475346/ "Photo Sharing"
 [6]: https://www.flickr.com/photos/appleboy/307475368/ "Photo Sharing"
 [7]: https://www.flickr.com/photos/appleboy/307475402/ "Photo Sharing"
 [8]: http://163.29.208.22/i2o/dpt_i20-drv_2.5.0-rh9-i686.img
 [9]: https://www.flickr.com/photos/appleboy/307475518/ "Photo Sharing"