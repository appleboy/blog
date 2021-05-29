---
title: 切換 Ubuntu apt 的 mirror site
author: appleboy
type: post
date: 2011-02-22T14:30:09+00:00
url: /2011/02/切換-ubuntu-apt-的-mirror-site/
views:
  - 293
bot_views:
  - 175
dsq_thread_id:
  - 246755882
categories:
  - Ubuntu
tags:
  - Debian
  - Linux
  - Ubuntu

---
**Update: 國網內部員工建議用 http://ftp.twaren.net 這台**

最近常常會發生 apt-get update 指令失敗，台大這台 <span style="color:red">tw.archive.ubuntu.com</span> 似乎常常掛點，所以網路上找一下其他的 mirror site，看到似乎很多人都在用國網的 Server ( http://free.nchc.org.tw )，要換的話，請更改 `/etc/apt/sources.list`，將全部 tw.archive.ubuntu.com 都取代成 free.nchc.org.tw，其實還有另一個 domain 就是 opensource.nchc.org.tw，這些都可以用，沒有 apt 的 [Ubuntu][1] 或 [Debian][2] 簡直就不是 Server 了...XD

 [1]: http://www.ubuntu.com/
 [2]: http://www.debian.org/