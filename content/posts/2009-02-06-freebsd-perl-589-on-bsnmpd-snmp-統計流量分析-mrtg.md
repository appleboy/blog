---
title: '[FreeBSD] Perl 5.8.9 on bsnmpd SNMP 統計流量分析 mrtg'
author: appleboy
type: post
date: 2009-02-06T09:57:20+00:00
url: /2009/02/freebsd-perl-589-on-bsnmpd-snmp-統計流量分析-mrtg/
views:
  - 7456
bot_views:
  - 1666
dsq_thread_id:
  - 246815545
categories:
  - FreeBSD
tags:
  - FreeBSD
  - snmp

---
在 [FreeBSD][1] 7.1 Release 要裝起 SNMP 搭配 MRTG 已經非常容易，請參考之前寫的教學：[[FreeBSD] SNMP 統計流量分析 mrtg][2] ，可是這次因為安裝新系統，使用 Perl 5.8.9 在 MRTG 相依性好像安裝的不是很好，所以造成底下錯誤訊息： 

> Can&#8217;t locate SNMP\_util.pm in @INC (@INC contains: /usr/local/bin/../lib/mrtg2 / usr/local/bin /usr/local/lib/perl5/5.8. 9/BSDPAN /usr/local/lib/perl5/site\_perl /5.8.9/mach /usr/local/lib/perl5/site\_p erl/5.8.9 /usr/local/lib/perl5/site\_per l /usr/local/lib/perl5/5.8.9/mach /usr/ local/lib/perl5/5.8.9 .) at /usr/local/ bin/cfgmaker line 105<!--more--> 在網路上 google 了一堆，終於找到解答：

[MRTG missing SNMP_util][3]，只要將底下裝上，就可以 work 了 

<pre class="brush: bash; title: ; notranslate" title=""># FreeBSD ports
cd /usr/ports/net-mgmt/p5-SNMP_Session
make install clean</pre> 後來發現在 tw.bbs.comp.386bsd 討論列上剛好有看過這問題，找到 chinsan.bbs@bbs.sayya.org 發表 

[這篇][4]，一樣的問題。 底下這討論串，也可以解決問題 http://forums.freebsd.org/showthread.php?t=1493

 [1]: http://www.freebsd.org/
 [2]: http://blog.wu-boy.com/2008/03/20/158/
 [3]: http://www.powertrip.co.za/blog/archives/000610.html
 [4]: http://www.ptt.cc/bbs/FreeBSD/M.1233316665.A.html