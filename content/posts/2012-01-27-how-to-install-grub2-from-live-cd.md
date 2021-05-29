---
title: 用 Ubuntu 10.10 Live CD 重新安裝 GRUB 2 到 Bootloader
author: appleboy
type: post
date: 2012-01-27T07:41:37+00:00
url: /2012/01/how-to-install-grub2-from-live-cd/
dsq_thread_id:
  - 554232206
categories:
  - Debian
  - Linux
  - Ubuntu
tags:
  - boot
  - bootloader
  - Debian
  - grub
  - GRUB2
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div>

今天起床打開電腦，<a href="http://www.ubuntu.com" target="_blank">Ubuntu</a> 跳出 Warning 訊息，boot 磁區剩下 84MB，所以我手殘進去 /boot/ 目錄，把舊的 Kernel 清除，不小心砍掉 initrd.img-2.6.35-32-generic Linux Image 開機所需要的檔案，結果之後開機出現

> You need to load the kernel first
大家好像都是升級 Kernel 之後才會出現上述狀況，網路上找到的解答都不符合我的需求，所以我又往 <a href="https://help.ubuntu.com/community/Grub2" target="_blank">GRUB2</a> 開機 Boot 去瞭解，新的 GRUB 2 跟原先的 GRUB 的解法已經完全不同了，沒有 <span style="color:red"><strong>/boot/grub/menu.list</strong></span>，而被 <span style="color:green"><strong>/boot/grub/grub.cfg</strong></span> 取代，所以不應該在手動編輯此檔案。grub.cfg 會在有更新 Kernel 版本時，手動執行 update-grub 的時候被修改覆寫。這次發生的原因是在我把舊版 Kernel 刪除，而忘記執行 update-grub，這時候的最佳解法就是透過 Live CD 來救援。

<!--more-->

### Ubnutu Live CD 救援

先把 Ubuntu Live CD 放入，直接先選 Try Ubuntu，接著就會進入桌面，將 Terminal 打開 (Applications -> Accessories -> Terminal)，之後只要按照底下步驟就可以成功還原 boot loader。

首先確定系統的根目錄以及 boot 磁區代號，大致上都是 sda1, sda5 等等，可以透過 <span style="color:green"><strong>fdisk -l</strong></span> 來瞭解這些資訊。

<pre class="brush: bash; title: ; notranslate" title="">$ fdisk -l</pre>

輸出底下結果

<pre class="brush: bash; title: ; notranslate" title="">Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          13       96256   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2              13       38914   312471553    5  Extended
/dev/sda5              13         499     3905536   82  Linux swap / Solaris
/dev/sda6             499        5362    39061504   83  Linux
/dev/sda7            5362       38914   269502464   83  Linux</pre>

將 / 跟 /boot mount 到任意目錄

<pre class="brush: bash; title: ; notranslate" title="">$ sudo mkdir /mnt/root
$ sudo mount -t ext4 /dev/sda6 /mnt/root
$ sudo mount /dev/sda1 /mnt/root/boot</pre>

建立 /mnt/root 目錄，用來掛載自己的 Linux 系統，/dev/sda6 是原先 / 磁區，而 /dev/sda1 則是 /boot 區域

掛載 critical virtual filesystems，請執行底下 command

<pre class="brush: bash; title: ; notranslate" title="">$ for i in /dev /dev/pts /proc /sys; do sudo mount -B $i /mnt/root$i; done
</pre>

用 chroot 指令切換到 system device

<pre class="brush: bash; title: ; notranslate" title="">$ chroot /mnt/root /bin/bash</pre>

重新將 Kernel 安裝

<pre class="brush: bash; title: ; notranslate" title="">$ sudo apt-cache search linux-image</pre>

找到您要的版本後重新安裝

<pre class="brush: bash; title: ; notranslate" title="">$ sudo apt-get install linux-image-x.x.x-xx</pre>

更新 /boot/grub/grub.cfg

<pre class="brush: bash; title: ; notranslate" title="">$ update-grub</pre>

重新安裝 GRUB 2

<pre class="brush: bash; title: ; notranslate" title="">$ grub-install /dev/sda</pre>

重新確認是否安裝成功

<pre class="brush: bash; title: ; notranslate" title="">$ grub-install --recheck /dev/sda</pre>

按 `CTRL-D` 離開 chroot

卸載全部虛擬系統

<pre class="brush: bash; title: ; notranslate" title="">$ for i in /sys /proc /dev/pts /dev; do sudo umount /mnt/root$1; done</pre>

卸載 boot 及 / 系統

<pre class="brush: bash; title: ; notranslate" title="">$ sudo umount /mnt/root/boot
$ sudo umount /mnt/root</pre>

重新開機

<pre class="brush: bash; title: ; notranslate" title="">$ sudo reboot</pre>

### 結論

因為不小心砍一個系統開機檔案，所以花了一些時間找資料，以及瞭解 GURB2，這樣也是不錯啦 XD，底下是參考的一些資料

Reference: <a href="http://ubuntuforums.org/showthread.php?t=1660989" target="_blank">[SOLVED] Can't start ubuntu (WUBI) : You need to load the kernel first</a> <a href="http://www.go2linux.org/clean-linux-kernel-images-grub-menu" target="_blank">Clean up your grub menu and the kernels you do not use</a> <a href="https://help.ubuntu.com/community/Grub2" target="_blank">Ubuntu Wiki Grub2</a> <a href="http://maketecheasier.com/restore-grub-2-as-the-main-bootloader/2010/05/05" target="_blank">How to Restore Grub 2 As The Main Bootloader</a> <a href="http://www.indiangnu.org/2009/how-to-create-editextract-initrd-in-ubuntudebian-and-redhatfedora-linux/" target="_blank">How to create edit/extract initrd in Ubuntu/Debian and Redhat/Fedora Linux ?</a> <a href="http://www.cyberciti.biz/faq/linux-kernel-upgrade-howto/" target="_blank">Howto: Upgrade Linux Kernel</a> <a href="http://www.howtogeek.com/howto/17787/clean-up-the-new-ubuntu-grub2-boot-menu/" target="_blank">Clean Up the New Ubuntu Grub2 Boot Menu</a>