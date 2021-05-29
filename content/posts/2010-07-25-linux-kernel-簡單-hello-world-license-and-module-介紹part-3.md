---
title: '[Linux Kernel] 簡單 hello world: License and Module 介紹(part 3)'
author: appleboy
type: post
date: 2010-07-25T08:17:52+00:00
url: /2010/07/linux-kernel-簡單-hello-world-license-and-module-介紹part-3/
views:
  - 2578
bot_views:
  - 353
dsq_thread_id:
  - 249141476
categories:
  - Kernel
  - Linux
tags:
  - Driver
  - Kernel
  - Linux Kernel

---
在 Kernel 2.4 或以上版本，在編譯模組完成，要進行 load module 之前，你會發現底下訊息： 

<pre class="brush: bash; title: ; notranslate" title=""># insmod hello-3.o
Warning: loading hello-3.o will taint the kernel: no license
  See http://www.tux.org/lkml/#export-tainted for information about tainted modules</pre> 很顯然這訊息是要您在 kernel module 裡面加上版權宣告，例如："GPL"，"GPL v2"…等來宣告您的 module 並非 open source，利用 

**<span style="color:green">MODULE_LICENSE()</span>** 巨集來宣告程式 License，同樣的，可以用 **<span style="color:green">MODULE_DESCRIPTION()</span>** 來描述此模組或者是 Driver 的功用跟簡介，以及用 **<span style="color:green">MODULE_AUTHOR()</span>** 來定義此模組作者，這些巨集都可以在 <span style="color:red">linux/module.h</span> 裡找到，但是這些並非用於 Kernel 本身，如果大家想看範例程式，可以到 <span style="color:red">drivers</span>/ 資料夾底下觀看每一個 Driver 程式，底下是簡單 hello world 範例： 

<pre class="brush: cpp; title: ; notranslate" title="">#include &lt;linux/kernel.h> /* pr_info所需 include 檔案*/
#include &lt;linux/init.h>
#include &lt;linux/module.h> /* 所有 module 巨集需要檔案*/
#include &lt;linux/version.h>

static int __init hello_init(void)
{
    pr_info("Hello, world appleboy\n");
    pr_info("The process is \"%s\" (pid %i)\n", current->comm, current->pid);
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Goodbye\n");
}
MODULE_DESCRIPTION("Hello World !!");/* 此程式介紹與描述*/
MODULE_AUTHOR("Bo-Yi Wu &lt;appleboy.tw AT gmail.com>");/* 此程式作者*/
MODULE_LICENSE("GPL");/* 程式 License*/
module_init(hello_init);
module_exit(hello_exit);</pre> 在 linux/module.h 裡頭，可以找到 MODULE_LICENSE 可定義的 License 

<pre class="brush: cpp; title: ; notranslate" title="">/*
 * The following license idents are currently accepted as indicating free
 * software modules
 *
 *	"GPL"				[GNU Public License v2 or later]
 *	"GPL v2"			[GNU Public License v2]
 *	"GPL and additional rights"	[GNU Public License v2 rights and more]
 *	"Dual BSD/GPL"			[GNU Public License v2
 *					 or BSD license choice]
 *	"Dual MIT/GPL"			[GNU Public License v2
 *					 or MIT license choice]
 *	"Dual MPL/GPL"			[GNU Public License v2
 *					 or Mozilla license choice]
 *
 * The following other idents are available
 *
 *	"Proprietary"			[Non free products]
 *
 * There are dual licensed components, but when running with Linux it is the
 * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
 * is a GPL combined work.
 *
 * This exists for several reasons
 * 1.	So modinfo can show license info for users wanting to vet their setup 
 *	is free
 * 2.	So the community can ignore bug reports including proprietary modules
 * 3.	So vendors can do likewise based on their own policies
 */</pre> 巨集 define: 

<pre class="brush: cpp; title: ; notranslate" title="">#define MODULE_LICENSE(_license) MODULE_INFO(license, _license)

/*
 * Author(s), use "Name &lt;email>" or just "Name", for multiple
 * authors use multiple MODULE_AUTHOR() statements/lines.
 */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

/* What your module does. */
#define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)</pre>