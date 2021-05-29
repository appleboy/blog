---
title: '[Linux] 利用 awk 或 perl command line 找出 passwd id 大於1000 的帳號'
author: appleboy
type: post
date: 2009-01-09T13:19:53+00:00
url: /2009/01/linux-利用-awk-或-perl-command-line-找出-passwd-id-大於1000-的帳號/
views:
  - 7665
bot_views:
  - 1445
dsq_thread_id:
  - 247426881
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - Linux

---
其實還蠻簡單的，只是想紀錄一下，利用 awk 或者是 perl command line 找出非系統產生的帳號 perl: 

<pre class="brush: bash; title: ; notranslate" title="">#
# perl 寫法
#
perl -an -F: -e 'if ($F[2] >= 1000) { print $F[0],"\n"; }' passwd</pre> awk: 

<pre class="brush: bash; title: ; notranslate" title="">#
# awk 寫法
#
awk -F ":" '($3 >= 1000) { printf $1 "\n"}' /etc/passwd</pre>