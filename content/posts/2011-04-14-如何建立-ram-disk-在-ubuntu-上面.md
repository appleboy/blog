---
title: 如何建立 Ram Disk 在 Ubuntu 上面
author: appleboy
type: post
date: 2011-04-14T15:54:33+00:00
url: /2011/04/如何建立-ram-disk-在-ubuntu-上面/
views:
  - 368
bot_views:
  - 132
dsq_thread_id:
  - 279376886
categories:
  - Ubuntu

---
**Update: 此篇文章建立 RAM DISK 還是用原來 3G 記憶體，而不是用 4G 裡面的 1G，感謝[威阿][1]提醒修正** 之前拜了一台筆電 [Toshiba Portege R700][2]，拿到電腦馬上二話不說，灌成 [Ubuntu 10.10][3] 32 位元，但是筆電有 4G 的記憶體，32位元只能支援到 3G，<del datetime="2011-04-15T01:47:52+00:00">所以剩下 1G 就拿來當作是 Ram Disk，反正不用白不用</del>，可以把臨時要用且關機不需要的檔案或程式丟到 RAM DISK，如果把 FireFox 的 cache 資料放在裡面應該會蠻快的，底下紀錄如何開機就直接掛上 1G 的 Ram Disk。 兩個步驟就可以了： 

<pre class="brush: bash; title: ; notranslate" title="">mkdir -p /media/ramdisk
mount -t tmpfs -o size=1024M tmpfs /media/ramdisk</pre> 把上面寫到 

**<span style="color:green">/etc/rc.local</span>** 檔案，這樣開機就會自動把 RAM Disk 掛上去。

 [1]: http://profiles.google.com/uijin.tw
 [2]: http://www.techbang.com.tw/posts/3108-toshiba-portege-r700-evaluation
 [3]: http://www.ubuntu-tw.org/