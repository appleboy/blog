---
title: '[FreeBSD] 利用 fsck 指令修復不正常斷電關機'
author: appleboy
type: post
date: 2011-01-26T13:49:45+00:00
url: /2011/01/freebsd-利用-fsck-指令修復不正常斷電關機/
views:
  - 1665
bot_views:
  - 194
dsq_thread_id:
  - 246819317
categories:
  - FreeBSD
tags:
  - FreeBSD

---
由於人不在機器前面，所以都請學弟妹幫忙直接拔電在插電，現在問題出來了，完全不能開機了，現在就只能進去單人模式修復，其實修復也非常容易，進入開機選單，選擇 Single user mode 模式，進入之後會直接看到底下訊息提示: 

<pre class="brush: bash; title: ; notranslate" title="">enter full pathname of shell or return for :/bin/sh:</pre> 沒意外就直接按下 Enter 鍵就可以了，由於 fsck 指令在修復過程不可以先 mount 磁區，所以先利用 mount -a 來掛上所有磁區 

<pre class="brush: bash; title: ; notranslate" title=""># 掛上所有磁區
mount -a
# 顯示硬碟磁區
df -h</pre> Console 會看到 

<pre class="brush: bash; title: ; notranslate" title="">Filesystem                                    Size    Used   Avail Capacity  Mounted on
/dev/da0s1a                                   496M    341M    115M    75%    /
devfs                                         1.0K    1.0K      0B   100%    /dev
/dev/da0s1e                                   496M     16M    440M     4%    /tmp
/dev/da0s1f                                    24G     15G    6.4G    71%    /usr
/dev/da1s1d                                    33G     22G    8.4G    73%    /usr/home
/dev/da0s1d                                   4.7G    2.5G    1.8G    58%    /var</pre> 如果針對 /dev/da1s1d 做修復，請下底下指令 

<pre class="brush: bash; title: ; notranslate" title="">umont /usr/home
fsck -y /dev/da1s1d</pre> fsck 修復完成會出現底下訊息 

<pre class="brush: bash; title: ; notranslate" title="">** /dev/da1s1d
** Last Mounted on
** Phase 1 - Check Blocks and Sizes
** Phase 2 - Check Pathnames
** Phase 3 - Check Connectivity
** Phase 4 - Check Reference Counts
** Phase 5 - Check Cyl groups
2 files, 2 used, 506337 free (25 frags, 63289 blocks, 0.0% fragmentation)</pre> 如果中間有錯誤訊息，就繼續 fsck 步驟，直到修復完成，完成之後下 reboot 重新開機，就可以看到 login as: 可以在 rc.conf 裡面加入兩行設定 

<pre class="brush: bash; title: ; notranslate" title="">fsck_y_enable="YES"
background_fsck="YES"</pre>

[[整理] 文件系統修復][1] [【FreeBSD】系統異常關機修複方式 FSCK][2] [[FreeBSD] 請教: FreeBSD斷電後fsck後能不能自動reboot][3]

 [1]: http://hi.baidu.com/hy0kl/blog/item/934e744a49fbe42509f7efb7.html
 [2]: http://bojack.pixnet.net/blog/post/20082824
 [3]: http://bbs.chinaunix.net/viewthread.php?tid=1020897