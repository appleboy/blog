---
title: '[Linux Kernel] 撰寫簡單 Hello, World module (part 1).'
author: appleboy
type: post
date: 2010-06-21T09:36:10+00:00
url: /2010/06/linux-kernel-driver-撰寫簡單-hello-world-module-part-1/
views:
  - 4830
bot_views:
  - 332
dsq_thread_id:
  - 246787103
categories:
  - Kernel
  - Linux
tags:
  - Driver
  - Linux Kernel

---
來筆記如何在 Kernel 撰寫 hello world! module，在 Ubuntu Kernel 2.6.31-14 環境下撰寫，其實不難啦，首先先進入 Kernel 目錄，請在 <span style="color:green">/usr/src</span> 底下看自己的系統版本，或者是利用 <span style="color:green">uname -r</span> 來知道 Kernel 版本，底下是在 Ubuntu Kernel 2.6.31-14 Kernel 實做： 

### 進入 Kernel 目錄

<pre class="brush: bash; title: ; notranslate" title="">#
# cd Kernel directory
#
cd /usr/src/linux-headers-2.6.31-14-generic-pae</pre>

### 建立 hello 目錄

<pre class="brush: bash; title: ; notranslate" title="">#
# mkdir directory
#
mkdir hello</pre>

### 建立 Makfile 以及 hello.c hello.c: 

<pre class="brush: cpp; title: ; notranslate" title="">#include <linux/kernel.h> /* pr_info 所需 include 檔案*/
#include <linux/init.h>
#include <linux/module.h> /* 所有 module 需要檔案*/
#include <linux/version.h>

MODULE_DESCRIPTION("Hello World !!");
MODULE_AUTHOR("Bo-Yi Wu <appleboy.tw AT gmail.com>");
MODULE_LICENSE("GPL");

static int __init hello_init(void)
{
    pr_info("Hello, world\n");
    pr_info("The process is \"%s\" (pid %i)\n", current->comm, current->pid);
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Goodbye\n");
}

module_init(hello_init);
module_exit(hello_exit);</pre> Makefile: 

<pre class="brush: bash; title: ; notranslate" title="">#
# Makefile by appleboy <appleboy.tw AT gmail.com>
#
obj-m       += hello.o
KVERSION := $(shell uname -r)

all:
    $(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) modules

clean:
    $(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) clean</pre> 之後只要切換到 hello 目錄，直接打 make 就可以產生出 hello.ko 檔案，直接載入 hello.ko 方式： 

<pre class="brush: bash; title: ; notranslate" title="">insmod ./hello.ko</pre> 移除 hello.ko 

<pre class="brush: bash; title: ; notranslate" title="">rmmod ./hello.ko</pre> 之後到 /var/log/message 底下就可以看到訊息： 

[<img src="https://i0.wp.com/farm5.static.flickr.com/4068/4719816041_ffa47ac6d5.jpg?resize=500%2C136&#038;ssl=1" alt="Kernel Hello World" data-recalc-dims="1" />][1]

 [1]: https://www.flickr.com/photos/appleboy/4719816041/ "Flickr 上 appleboy46 的 Kernel Hello World"