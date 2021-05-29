---
title: '[Linux Kernel] built-in vs. module'
author: appleboy
type: post
date: 2010-05-28T14:36:43+00:00
url: /2010/05/linux-kernel-built-in-vs-module/
views:
  - 3848
bot_views:
  - 395
dsq_thread_id:
  - 246709525
categories:
  - Android
  - Kernel
tags:
  - Android
  - Driver
  - Linux Kernel

---
在編譯 [Android][1] Linux Kernel 2.6.29 Driver，常常遇到該把 Driver 用 built-in 或者是編譯成 module 呢？這其實看人習慣，就跟問你編輯器是用 [Vim][2] 或者是 [emacs][3] 是同樣意思，這兩者是有很大的差異，built-in 用在開機自動讀取載入，所以直接編譯成 uImage 檔案給嵌入式系統，像是 SCSI 或者是 SATA Driver 都建議編譯成 built-in 的方式，反而是一些音效驅動程式，可以編譯成 module，NTFS 就是可以編譯成 module，等您需要的時候在動態載入就可以，這樣可以減少 Kernel Image 的使用空間。 如果不想用 built-in 編譯，開機又需要驅動程式，那就需要透過 initrd 方式來啟動。底下整理兩者差異： 

### built-in：

> 開機自動載入，不可移除 Linux Kernel Image 大 需要重新 Compile
### module：

> 可動態載入 Linux Kernel Image 小 不需要重新 Compile reference: [[gentoo-user] kernel: built-in vs. module][4]

 [1]: http://code.google.com/android/
 [2]: http://www.vim.org/
 [3]: http://www.gnu.org/software/emacs/
 [4]: http://www.mail-archive.com/gentoo-user@gentoo.org/msg09418.html