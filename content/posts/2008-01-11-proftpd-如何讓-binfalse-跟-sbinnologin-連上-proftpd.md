---
title: '[Proftpd] 如何讓 /bin/false 跟 /sbin/nologin 連上 Proftpd'
author: appleboy
type: post
date: 2008-01-12T03:54:28+00:00
url: /2008/01/proftpd-如何讓-binfalse-跟-sbinnologin-連上-proftpd/
views:
  - 3004
bot_views:
  - 655
dsq_thread_id:
  - 251662840
categories:
  - FreeBSD
  - Linux
  - Ubuntu
tags:
  - Linux
  - proftpd

---
昨天遇到這個問題，不過其實之前就有解決過這問題，只是忘記怎麼解決，之前是利用 MySQL 的方式建立帳號，因為相當方便，請參考這篇 [[Linux] Ubuntu 6.06 Proftpd + Mysql 安裝方式][1]，支援 /bin/false 跟 /sbin/nologin 也相當簡單 只要在 proftpd.conf 加上 

<pre class="brush: bash; title: ; notranslate" title="">RequireValidShell on
</pre> 官網寫的 

[config\_ref\_RequireValidShell][2] 然後在編輯 /etc/shells 加上 

<pre class="brush: bash; title: ; notranslate" title="">/sbin/nologin
</pre>

 [1]: http://blog.wu-boy.com/2006/10/21/22/
 [2]: http://www.proftpd.org/docs/directives/linked/config_ref_RequireValidShell.html