---
title: '[Linux,FreeBSD] scp 上傳跟下載'
author: appleboy
type: post
date: 2006-11-25T20:43:17+00:00
url: /2006/11/linuxfreebsd-scp-上傳跟下載/
bot_views:
  - 808
views:
  - 4243
dsq_thread_id:
  - 246815916
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - Linux
  - SSH

---
上傳： 

> scp -r -P 2500 /etc/crontab appleboy@hostname.com:/home/appleboy/ 下載： 

> scp -r -P 2500 appleboy@hostname.com:/home/appleboy/crazy.sql . -r 遞迴 下載 -P ssh port 後面的點 . 你可以換成你想下載到你的哪個目錄