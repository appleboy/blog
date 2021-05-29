---
title: '[FreeBSD] Ports 更新 index 或 更新kernel'
author: appleboy
type: post
date: 2006-09-25T21:45:33+00:00
url: /2006/09/freebsd-ports-更新-index/
views:
  - 3745
bot_views:
  - 689
dsq_thread_id:
  - 251180726
categories:
  - FreeBSD
tags:
  - FreeBSD
  - ports

---
<pre class="brush: bash; title: ; notranslate" title="">1. cd /usr/ports &#038;& make fetchindex
2. portsdb -uU
3. rm -f /var/db/pkg/pkgdb.db
4. pkgdb -Fu
5. cd /usr/src ; make buildworld; make kernel; make installworld; reboot</pre> &#8212; 這招很好用 上面步驟如果只需要更新ports tree 只需要 cd /usr/ports && make fetchindex 就可以了