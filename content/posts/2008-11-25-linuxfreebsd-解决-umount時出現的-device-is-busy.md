---
title: '[Linux&FreeBSD] 解决 umount時出現的 “Device is busy”'
author: appleboy
type: post
date: 2008-11-25T08:32:08+00:00
url: /2008/11/linuxfreebsd-解决-umount時出現的-device-is-busy/
bot_views:
  - 551
views:
  - 5365
dsq_thread_id:
  - 249003569
categories:
  - FreeBSD
  - Linux
  - Ubuntu
tags:
  - FreeBSD
  - Linux

---
在 Linux 系列 OS 安裝好之後，都會有支援一個 fuser 這一個指令，那有時候在 linux 底下 mount 隨身碟，或者是其他硬體的時候，有時候沒辦法讓您移除，會出現：『Device is busy』，那這個訊息是在保護確保你的資料有儲存到該裝置，有時候如果沒有正確移除，會造成資料遺失，或者是資料不完整，那基本上裝上任何一套 Linux 作業系統，都會有支援了，所以不必在另外安裝，那 [FreeBSD][1] 那就要在安裝 [/usr/ports/sysutils/fuser][2] 這一個 tool 這樣才會有喔 安裝：『FreeBSD』 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/sysutils/fuser
make install clean</pre> 那使用方法： for FreeBSD 

<pre class="brush: bash; title: ; notranslate" title=""># fuser -m /var/log/maillog
/var/log/maillog:   513wa
# 加上 -u 參數
# fuser -mu /var/log/maillog
/var/log/maillog:   513wa(root)</pre>

**2008.11.28 update** 另外解法： 可以使用 fstat -f /home 來觀看有哪些 process access /home <!--more--> for Linux 

> fuser可以顯示出當前哪個程序在使用磁盤上的某個文件、掛載點、甚至網路端口，並給出程序進程的詳細訊息。 假設無法卸載的設備為/media/USB，運行下列命令即可： $ fuser -m -v /media/USB/ 用戶進程號權限命令 /media/BAK/: galeki 335 ..c.. gqview -m 參數顯示所有使用指定文件系統的進程，後面可以跟掛載點，或是dev設備( Thanks lisir :)，-v參數給出詳細的輸出，可以看出，原來是gqview這個程序還在霸占著移動設備，fuser還給出了程序的進程號，知道了進程號，你就可以隨便怎麼處置這個程序了。 另外你也可以添加一個-k參數： fuser -m -k /media/USB/ 這招自動把霸佔著/media/USB/的程序殺死。如果你不是很明確是否要殺死所有霸佔設備的程序，你還可以加一個-i參數，這樣每殺死一個程序前，都會詢問： $ fuser -m -v -i -k /media/BAK/ 用戶進程號權限命令 /media/BAK/: galeki 371 ..c.. gqview 殺死進程371 ? (y/N) 轉貼自：[[轉貼]解决 umount時出現的 &#8220;Device is busy&#8221;][3] 相關文章：[Linux: umount 時 出現 &#8220;Device is busy&#8221; 的解法][4] Linux: umount 時 出現 &#8220;Device is busy&#8221; 的解法

 [1]: http://www.freebsd.org
 [2]: http://www.freshports.org/sysutils/fuser
 [3]: http://www.ubuntu-tw.org/modules/newbb/viewtopic.php?post_id=40287
 [4]: http://plog.longwin.com.tw/my_note-unix/2008/11/18/debian-ubuntu-linux-umount-device-busy-2008