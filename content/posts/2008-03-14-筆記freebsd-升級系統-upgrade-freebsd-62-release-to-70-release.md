---
title: '[筆記][FreeBSD] 升級系統 upgrade FreeBSD 6.2 release to 7.0 release'
author: appleboy
type: post
date: 2008-03-14T14:14:46+00:00
url: /2008/03/筆記freebsd-升級系統-upgrade-freebsd-62-release-to-70-release/
views:
  - 3690
bot_views:
  - 593
dsq_thread_id:
  - 249180708
categories:
  - FreeBSD
tags:
  - FreeBSD

---
今天在 Sayya BBS 看到 JoeHorn 的個人版，裡面寫到 &#8220;[筆記] remote upgrade FreeBSD 6.2 -> 7.0&#8221; 這一篇文章，裡面寫的作法，我自己實做到我自己的機器，就成功了，作法如下 首先修改 /usr/share/examples/cvsup/stable-supfile，找到 

<pre class="brush: bash; title: ; notranslate" title=""># Defaults that apply to all the collections
#
# IMPORTANT: Change the next line to use one of the CVSup mirror sites
# listed at http://www.freebsd.org/doc/handbook/mirrors.html.
*default host=CHANGE_THIS.FreeBSD.org
*default base=/var/db
*default prefix=/usr
# The following line is for 7-stable.  If you want 6-stable, 5-stable,
# 4-stable, 3-stable, or 2.2-stable, change to "RELENG_6", "RELENG_5",
# "RELENG_4", "RELENG_3", or "RELENG_2_2" respectively.
*default release=cvs tag=RELENG_6
*default delete use-rel-suffix
</pre>

<!--more--> 在 /usr/share/examples/cvsup/ 裡面的檔案，說明如下 

> cvs-supfile //更新Main source tree and ports collection doc-supfile //更新Document gnats-supfile //更新FreeBSD bug database ports-supfile //更新Ports collection stable-supfile //更新Main source tree standard-supfile //更新Main source tree www-supfile //更新FreeBSD 官方網頁
> To maintain the sources for the FreeBSD-current release, use: standard-supfile Main source tree ports-supfile Ports collection To maintain the sources for the FreeBSD-stable release, use: stable-supfile Main source tree To maintain a copy of the CVS repository containing all versions of FreeBSD, use: cvs-supfile Main source tree and ports collection To maintain a copy of the FreeBSD bug database, use the file: gnats-supfile FreeBSD bug database 改掉 

> \# The following line is for 7-stable. If you want 6-stable, 5-stable, # 4-stable, 3-stable, or 2.2-stable, change to &#8220;RELENG\_6&#8221;, &#8220;RELENG\_5&#8221;, # &#8220;RELENG\_4&#8221;, &#8220;RELENG\_3&#8221;, or &#8220;RELENG\_2\_2&#8221; respectively. *default release=cvs tag=RELENG_6 改成 

> *default release=cvs tag=RELENG\_7\_0 然後修改 /etc/make.conf 

<pre class="brush: bash; title: ; notranslate" title="">PORTSSUPFILE=   /usr/local/etc/ports-supfile
SUPHOST=        freebsd.csie.nctu.edu.tw
SUP_UPDATE=     yes
SUP=            /usr/local/bin/cvsup
SUPFLAGS=       -g -L 2
NO_KERBEROS=true
# End portconf settings
KERNCONF=GENERIC
SUPFILE=/usr/share/examples/cvsup/stable-supfile
</pre> 底下我大概按照了 JoeHorn 的作法，如下 

> 1. 改 /usr/share/examples/cvsup/stable-supfile ，用 RELENG\_7\_0 。 2. cd /usr/src && make update 3. make buildworld 4. make kernel 如果把 IPv6 相關的東西拿掉的話，要把 SCTP 拿掉。 5. make installworld 6. mergemaster -i 正常來說，有這幾個要砍： \*\\*\* The following files exist in /etc/rc.d but not in /var/tmp/temproot/etc/rc.d/: ike nfslocking pccard pcvt ramdisk ramdisk-own usbd 搞定後注意一下 ifconfig ，如果機器用 nve 的網卡。 記得在 /etc/rc.conf 改成 nfe ，不然 reboot 之後就得跑 console 了～ XD \*\*\* reboot \**\* 7. cd /usr/ports && rm INDEX-6\* && make fetchindex && portsdb -u 8. cd /var/db/pkg && rm pkgdb.db && pkgdb -F 9. portupgrade -af 10. cd /usr/src && make BATCH\_DELETE\_OLD_FILES=YES delete-old delete-old-libs \*\\*\* reboot \*\** 在 make 之前，要先系統對時，為了避免因為系統時間不準而造成執行 make 時失敗，我們先以 ntpdate 進行網路對時 #ntpdate -s watch.stdtime.gov.tw 完成升級之後，打 uname -a 會看到 

> FreeBSD freebsd.ee.ccu.edu.tw 7.0-RELEASE FreeBSD 7.0-RELEASE 完成後，重開機之後，只要打指令就會出現下面問題 

> /libexec/ld-elf.so.1: Shared object &#8220;libssl.so.4&#8221; not found 解決方法就是： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/misc/compat6x; make install clean;
</pre> reference： 

<http://www.bsdforums.org/forums/showthread.php?threadid=57098> <http://www.weithenn.idv.tw/cgi-bin/wiki.pl?search=stable-supfile-%e5%88%a9%e7%94%a8CVSUP%e6%9b%b4%e6%96%b0Security%2bPatch> <http://www.freebsd.org/doc/zh_TW/books/handbook/makeworld.html> <http://blog.pixnet.net/Izero/post/13269894>