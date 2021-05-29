---
title: '[Linux筆記]如何製作多重開機 grub'
author: appleboy
type: post
date: 2008-06-12T11:15:26+00:00
url: /2008/06/linux筆記如何製作多重開機-grub/
views:
  - 7020
bot_views:
  - 711
dsq_thread_id:
  - 246871621
categories:
  - Linux
  - Ubuntu
tags:
  - grub
  - Linux
  - MBR

---
昨天晚上原本要看 paper 的，可是幫同學處理安裝好 Fedora 7 的時候出現底下問題： 

> Minimal BASH-like line editing is supported. For the first word, TAB lists possible command completions. Anywhere else TAB lists the possible completions of a device/filename grub> 其實我自己也不知道安裝好為啥會出現這個，電腦裡面三顆硬碟，兩顆 SATA 一顆 IDE，然後用光碟開機的時候分別是 sda sdb sdc 三顆，所以安裝好之後通常會把 sda mbr 寫入開機訊息，照道理說這樣就可以開機了，可是目前看來是不行，後來是重新安裝了 mbr 我把她安裝到 IDE 那顆硬碟，底下先轉貼開機 mbr 磁區介紹： 

> 在硬碟最最最開始的磁區叫MBR(Master Boot Record),這是MicroSoft的正式稱呼! 有些人叫它Pre-Boot磁區或Pre-Load磁區. MBR (512 bytes)can be divided into 3 parts: (1) 前面446bytes為開機程式(即Pre-Boot程式),實際只用約200bytes (2) 接著的64bytes就是partition table,每16bytes代表一個logical HD (3) 最後2bytes一定是 55 AA (十六進位) FDISK/MBR 就是把前面446 bytes 換成乾淨的Pre-Boot 程式! 它絕不會動後面的66bytes!!! mbr位於硬碟第0軌,長度為512位元組內含偵測active partition的程式及 長64位元組的partition table(16 bytes * 4 partition records) 每一partition record紀錄partition的起始位置,是否active及os type 從這裡決定要用哪一個partition開機(active partition) 文章轉錄自： http://www.pczone.com.tw/vbb3/archive/t-20579.html <!--more--> 大致上瞭解了開機 MBR 包含了什麼，那我大概講一下我的問題，因為安裝 FC7 的時候，我的 boot loader 裝在 sda 上面，也是就是 (hd0,0) ，可是安裝好之後 grub.conf 底下會這樣寫： 

<pre class="brush: bash; title: ; notranslate" title="">title Fedora Core (2.6.12-1.1456_FC4)
        root (hd2,0)
        kernel /boot/vmlinuz-2.6.12-1.1456_FC4 ro root=/dev/hda1 quiet vga=787
        initrd /boot/initrd-2.6.12-1.1456_FC4.img
title Windows partition
	root (hd0,0)
	chainloader +1</pre> 因為我硬碟開機順序是 SATA 兩顆再來才是第三顆IDE (hd2,0)，所以設定這樣是正確的，因為硬碟代號hd0,hd1,hd2 這些是根據你BIOS的硬碟開機順序來決定的喔，所以不要搞混，因為我把 boot loader 安裝在 SATA 硬碟上面，我發現不能 work，所以我就去把 grub.conf 改掉，改成 

<pre class="brush: bash; title: ; notranslate" title="">title Fedora Core (2.6.12-1.1456_FC4)
        root (hd0,0)
        kernel /boot/vmlinuz-2.6.12-1.1456_FC4 ro root=/dev/hda1 quiet vga=787
        initrd /boot/initrd-2.6.12-1.1456_FC4.img
title Windows partition
	root (hd2,0)
	chainloader +1</pre> 這可以利用光碟片開機，然後進去 resume mode 進行更改 

<pre class="brush: bash; title: ; notranslate" title="">#
# 修改
#
chroot /mnt/systemimg
vi /boot/grub/grub.conf
#
# 重新安裝 boot mbt
#
grub
grub> find /boot/grub/stage1
root(hd2,0)
grub> root(hd2,0)
#
# 安裝在 Linux 硬碟上面
#
grub> setup (hd2)
 Checking if "/boot/grub/stage1" exists... yes
 Checking if "/boot/grub/stage2" exists... yes
 Checking if "/boot/grub/e2fs_stage1_5" exists... yes
 Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are embedded.
succeeded
 Running "install /boot/grub/stage1 (hd0) (hd0)1+15 p (hd0,0)/boot/grub/stage2 
/boot/grub/grub.conf"... succeeded
Done.

#
# 重新開機
# 
</pre> 調整 bios 資訊，把 IDE 硬碟調整成第一顆開機，這樣大致上就可以 work 了 http://linux.vbird.org/linux_basic/0510osloader.php#grub