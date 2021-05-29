---
title: FreeBSD 的 security patch 跟 如何 upgrade
author: appleboy
type: post
date: 2008-08-26T09:38:59+00:00
url: /2008/08/freebsd-的-security-patch-跟-如何-upgrade/
views:
  - 3791
bot_views:
  - 441
dsq_thread_id:
  - 246727588
categories:
  - FreeBSD
tags:
  - FreeBSD
  - security

---
剛剛看到 [chinsan&#8217;s Blog][1] 裡面提到 [關於 FreeBSD 的 security patch 是怎麼處理的?][2]，這篇寫的非常不錯，所以順道把手上機器都全部處理了 upgrade 系統了，當然首先是要先習慣閱讀 [/usr/src/UPDATING][3] 跟 [/usr/ports/UPDATING][4]，當然這兩個其中一個是系統的安全性更新，一個是 ports tree 安全性更新。 裡面 chinsan 大大提到的 SA(Security Advisories) 

> <http://www.freebsd.org/security/advisories.html> 相關反應管道請參考 http://security.freebsd.org 這裡的 SA 其實也可以在 [/usr/src/UPDATING][3] 這裡面看到，但是網頁版似乎比較好，我提供解法，做起來也不會很困難。 <!--more--> 嗯嗯，要升級系統安全性，首先先去修改 /usr/share/examples/cvsup/standard-supfile 把 cvs tag 採 RELENG\_7 改成 cvs tag 採 RELENG\_7_0 然後再去修改 /etc/make.conf 加上底下： 

<pre class="brush: bash; title: ; notranslate" title="">KERNCONF=GENERIC
SUPHOST=cvsup.tw.FreeBSD.org
SUPFILE=/usr/share/examples/cvsup/standard-supfile</pre> 然後更先步驟就如下了： 

<pre class="brush: bash; title: ; notranslate" title=""># 更新 source tree
cd /usr/src; make update
# 或者是
csup -g -L 2 /usr/share/examples/cvsup/standard-supfile
#執行 全套作法？
cd /usr/src; make buildworld; make kernel; make installworld
# 或者是半套？
cd /usr/src; make kernel</pre> 這邊我有去查了一下 Makefile： 

<pre class="brush: bash; title: ; notranslate" title=""># buildworld          - Rebuild *everything*, including glue to help do upgrades.
# installworld        - Install everything built by "buildworld".
# world               - buildworld + installworld, no kernel.
# buildkernel         - Rebuild the kernel and the kernel-modules.
# installkernel       - Install the kernel and the kernel-modules.
# installkernel.debug
# reinstallkernel     - Reinstall the kernel and the kernel-modules.
# reinstallkernel.debug
# kernel              - buildkernel + installkernel.</pre> 所以 make kernel = make buildkernel + make installkernel make world = make buildworld + make installworld 半套跟全套我不是很懂，可能要去實際去看看，編完之後重新開機就可以了～ 更新 ports/ 方面 # # 也是一樣修改 /usr/share/examples/cvsup/ports-supfile，加到 make.conf 

<pre class="brush: bash; title: ; notranslate" title="">PORTSSUPFILE=   /usr/share/examples/cvsup/ports-supfile
SUPHOST=        freebsd.csie.nctu.edu.tw
SUP_UPDATE=     yes
SUP=            /usr/local/bin/cvsup
SUPFLAGS=       -g -L 2</pre> 這樣 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports; make update
# 或者是
csup -g -L 2 /usr/share/examples/cvsup/ports-supfile
</pre> 這樣就ok了

 [1]: http://chinsan2.twbbs.org
 [2]: http://chinsan2.twbbs.org/wp/2008/08/26/106/
 [3]: http://www.freebsd.org/cgi/cvsweb.cgi/src/UPDATING
 [4]: http://www.freebsd.org/cgi/cvsweb.cgi/ports/UPDATING