---
title: 修復 Ubuntu 開機 boot loader
author: appleboy
type: post
date: 2014-05-03T01:58:32+00:00
url: /2014/05/fixed-boot-loader-on-ubuntu/
dsq_thread_id:
  - 2656775956
categories:
  - Debian
  - Ubuntu
tags:
  - boot
  - bootloader
  - Debian
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div>

昨天下午本來想幫自己的筆電 ([Ubuntu][1] OS) 升級記憶體，結果因為機型過於老舊，以現在的記憶體時脈 1600 裝上去後，直接讓 Ubuntu 當機，反覆重新開機，無法向下相容，加上現在記憶體狂漲價，找不到更低階的記憶體安裝了，無奈的是，店員幫忙測試筆電，換個記憶體，結果連 Ubuntu 的 [boot loader][2] 都可以壞掉。我看店員很緊張的說，不好意思，可以幫忙備份，幫忙我重灌。結果我還是自己拿回家處理比較安心。自己也不知道為什麼換個記憶體，可以讓 boot loader 消失。底下是修復 boot loader 過程

<!--more-->

### 製作 Ubuntu Live USB

請先準備好 Ubuntu Live USB，製作方式很簡單，在 Windows 底下請先下載 [unetbootin][3]，以及 Ubuntu 任何一版 Desktop OS，可以參考[高登][4]寫的教學: [如何製作 Ubuntu Live USB][5]

### 修復開機磁區

完成上述步驟後，請使用 USB 開機，選擇 `Try Ubuntu Desktop`，這時候會進到桌面，接著開啟系統內建的 Terminal，打入 `fdisk -l` 看看系統磁碟分割狀態

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ fdisk -l

Disk /dev/sda: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders, total 625142448 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0002c315

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      194559       96256   83  Linux
/dev/sda2          196606   625141759   312472577    5  Extended
/dev/sda5          196608    78319615    39061504   82  Linux swap / Solaris
/dev/sda6        78321664   117381119    19529728   83  Linux
/dev/sda7       117383168   625141759   253879296   83  Linux</pre>
</div>

上述結果可以發現只有一顆硬碟 `/dev/sda` 開機磁驅為 `/dev/sda1` 這是 `/boot`，而根目錄則是 `/dev/sda6`，接著將這些磁驅掛載到 `/mnt/`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ sudo mount /dev/sda6 /mnt
$ sudo mount /dev/sda1 /boot
$ sudo mount /dev/sda7 /home</pre>
</div>

使用 `grub-install` 指令重新製作開機 boot loader

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ sudo grub-install --root-directory=/mnt/ /dev/sda</pre>
</div>

最後重新啟動系統，將 USB 移除即可，就可以看到登入畫面了

 [1]: http://www.ubuntu.com/
 [2]: http://linux.vbird.org/linux_basic/0510osloader.php
 [3]: http://unetbootin.sourceforge.net/
 [4]: http://gordon168.tw
 [5]: http://gordon168.tw/?p=323