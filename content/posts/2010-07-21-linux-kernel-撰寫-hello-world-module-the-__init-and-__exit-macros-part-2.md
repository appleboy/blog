---
title: '[Linux Kernel] 撰寫 Hello, World module: The __init and __exit Macros (part 2).'
author: appleboy
type: post
date: 2010-07-20T16:04:16+00:00
url: /2010/07/linux-kernel-撰寫-hello-world-module-the-__init-and-__exit-macros-part-2/
views:
  - 3070
bot_views:
  - 365
dsq_thread_id:
  - 246787102
categories:
  - Kernel
tags:
  - Driver
  - Linux Kernel

---
再看此篇之前，可以先閱讀作者先前寫的：『[[Linux Kernel Driver] 撰寫簡單 Hello, World module (part 1).][1]』，今天要介紹 Driver 的 init module 區別，在 Kernel 2.4 版本，您可以自行定義 init 跟 cleanup 函式，他們不再被個別稱為 <span style="color:green">init_module()</span> 和 <span style="color:green">cleanup_module()</span>，現在都使用 <span style="color:green"><strong>module_init()</strong></span> 和 <span style="color:green"><strong>module_exit()</strong></span> 兩大巨集，這兩函式被定義在 <span style="color:red">linux/init.h</span> 檔案裡面，所以在寫程式務必將其 include 喔，另外一個核心模組(MODULE_LICENSE)，用於讓核心知道此模組遵守自由授權條款，若沒這項宣告，核心會跟您抱怨的喔，底下為範例： 

<pre class="brush: cpp; title: ; notranslate" title="">#include <linux/kernel.h> /* pr_info所需 include 檔案*/
#include <linux/init.h>
#include <linux/module.h> /* 所有 module 需要檔案*/
#include <linux/version.h>

MODULE_DESCRIPTION("Hello World !!");
MODULE_AUTHOR("Bo-Yi Wu <appleboy.tw AT gmail.com>");
MODULE_LICENSE("GPL");

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

module_init(hello_init);
module_exit(hello_exit);</pre> 編譯過程，可以自行修改 Makefile，可以打開 

<span style="color:green">kernel/android-2.6.29/drivers/i2c/chips/Makefile</span> 參考範例，您會發現很多類似底下寫法： 

<pre class="brush: bash; title: ; notranslate" title="">obj-$(CONFIG_TWL4030_POWEROFF)  += twl4030-poweroff.o
obj-$(CONFIG_TWL4030_MADC)  += twl4030-madc.o
obj-$(CONFIG_RTC_X1205_I2C) += x1205.o
obj-$(CONFIG_SENSORS_BOSCH_BMA150)  += bma150.o</pre> 如果要編譯成 module 可以設定成 

<span style="color:green">obj-m += bma150.o</span>，編譯到 Kernel image，則會寫成 <span style="color:green">obj-y += bma150.o</span>，然而 $(CONFIG\_SENSORS\_BOSCH_BMA150) 是從 **make menuconfig** 設定，當然為什麼 menuconfig 會出現此設定，那就要從 <span style="color:green">kernel/android-2.6.29/drivers/i2c/chips/Kconfig</span> 裡面加入 <span style="color:green">CONFIG_SENSORS_BOSCH_BMA150</span> 設定， 選好之後，觀看 Kernel 資料夾底下的 .config 內容，看到 <span style="color:green"><strong>CONFIG_SENSORS_BOSCH_BMA150=y</strong></span>，這樣就正確了。 

### What is different of **__init** and **__exit**? 在寫 G-Senser Driver 時候，您會發現 static int 

<span style="color:red">__init</span> BMA150_init(void) 跟 static void <span style="color:red">__exit</span> BMA150\_exit(void)，跟平常寫 C 語言宣告函式不一樣吧，這兩個巨集分別有不同意義喔，當然也可以將 span style="color:red">\__init</span> 跟 <span style="color:red">__exit</span> 拿掉，這不會影響 Driver 的編譯，但是會影響記憶體的優化，Driver 啟動時會呼叫 BMA150_init 函式，如果有加上 <span style="color:red">__init</span>，當此 init function 執行完，會將記憶體 Release 給系統，這是針對 built-in 的方式才適用，如果是編譯成模組方式，則不會有此功能，然而 <span style="color:red">__exit</span> 是 Driver 結束後會呼叫的 function，但是跟 \_\_init 剛好功能相反，在 built-in 的 Kernel 映像檔並不會執行到 \_\_exit，編譯成模組才會有釋放記憶體效果，這兩巨集可以參考 <span style="color:green">linux/init.h</span> 檔案。

 [1]: http://blog.wu-boy.com/2010/06/21/2231/