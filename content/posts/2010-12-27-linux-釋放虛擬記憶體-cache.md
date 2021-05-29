---
title: '[Linux] 釋放虛擬記憶體 (cache)'
author: appleboy
type: post
date: 2010-12-27T14:29:30+00:00
url: /2010/12/linux-釋放虛擬記憶體-cache/
views:
  - 1672
bot_views:
  - 233
categories:
  - Embedded System
  - Kernel
  - Linux
tags:
  - Linux
  - Linux Kernel

---
Linux Kernel 2.6.16 之後加入了 drop caches 的機制，可以讓系統清出多餘的記憶體，這對於搞嵌入式系統相當重要阿，Memory 不夠就不能 upgrade firmware，我們只要利用讀寫 proc 檔案就可以清除 cache 記憶體檔案，底下是操作步驟:

### 釋放 pagecache:捨棄一般沒使用的 cache

<pre class="brush: bash; title: ; notranslate" title="">echo 1 > /proc/sys/vm/drop_caches</pre>

### 釋放 dentries and inodes

<pre class="brush: bash; title: ; notranslate" title="">echo 2 > /proc/sys/vm/drop_caches</pre>

### 釋放 pagecache, dentries and inodes

<pre class="brush: bash; title: ; notranslate" title="">echo 3 > /proc/sys/vm/drop_caches</pre>

Reference: [Drop Caches][1] [觀察 Linux 的虛擬記憶體][2]

 [1]: http://linux-mm.org/Drop_Caches
 [2]: http://blog.linux.org.tw/~jserv/archives/002039.html