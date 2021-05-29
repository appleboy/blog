---
title: '[Linux筆記] 利用 mount 指令解決 Read-only file system 問題'
author: appleboy
type: post
date: 2008-05-19T02:53:57+00:00
url: /2008/05/linux筆記-利用-mount-指令解決-read-only-file-system-問題/
views:
  - 17992
bot_views:
  - 691
dsq_thread_id:
  - 246701976
categories:
  - Linux
tags:
  - Linux

---
之前幫別人處理機器的時候，發生這個問題，如果你針對 / 根目錄做寫入動作，她就會出現 Read-only file system，所以我去 google 到一篇文章：[如何讓file system 變成可以write, 而不是read only][1]，這篇的解法就還蠻簡單的，就是只要下指令就可以了。

```bash
#
# 讓 root file system 可以寫入
#
mount -o remount,rw /
```

這樣大概就解決問題，至於為甚麼會發生這個問題，這其實我不太知道，哈哈。

 [1]: http://moto.debian.org.tw/viewtopic.php?p=58706