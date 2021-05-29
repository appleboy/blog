---
title: '[Linux] 將 iperf 導入嵌入式系統 Router'
author: appleboy
type: post
date: 2011-01-06T05:51:04+00:00
url: /2011/01/linux-將-iperf-導入嵌入式系統-router/
views:
  - 1197
bot_views:
  - 220
dsq_thread_id:
  - 247203470
categories:
  - Embedded System
  - Linux
tags:
  - Embedded System
  - Linux

---
[iperf][1] 是一套測試網路效能工具，對於網通廠各工程師們不可或缺的啦，分享如何將 iperf 裝到嵌入式板子，其實在 Porting 每一個工具到板子上的方式差不多，步驟大概是利用 configure file 產生 Makefile，修改 gcc tool chain 路徑，將編譯好的程式放到 root file system，基本上就是如此，目前 iperf 到 2.0.5 版，大家快去[下載][2]吧。 直接修改 user space 的 Makefile: 

<pre class="brush: bash; title: ; notranslate" title="">cd ./user/apps/iperf-2.0.5; \
./configure --host=mips-linux CC=$(TOOLPREFIX)gcc CXX=$(TOOLPREFIX)g++ --disable-ipv6 \
--prefix=$(shell (pwd -P))/user/apps/iperf-2.0.5/romfs;\
$(MAKE) && $(MAKE) install ;\</pre> --host, CC, CXX 請換上 Tool Chain 對應路徑，大致上就可以了，更多設定可以參考 ./configure --help 編譯過程如果出現底下錯誤 

<pre class="brush: bash; title: ; notranslate" title="">undefined reference to malloc</pre> 就將 config.h.in 這檔案，底下整段 mark 起來，就可以編譯過了 

<pre class="brush: cpp; title: ; notranslate" title="">/* Define to rpl_malloc if the replacement function should be used. */
undef malloc</pre> ref: 

[undefined reference to rpl_malloc][3]

 [1]: http://iperf.sourceforge.net/
 [2]: http://sourceforge.net/projects/iperf/
 [3]: http://blog.csdn.net/linux_lyb/archive/2008/12/17/3536911.aspx