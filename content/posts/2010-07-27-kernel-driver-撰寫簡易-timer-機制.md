---
title: '[Kernel Driver] 撰寫簡易 Timer 機制'
author: appleboy
type: post
date: 2010-07-27T14:04:30+00:00
url: /2010/07/kernel-driver-撰寫簡易-timer-機制/
views:
  - 4098
bot_views:
  - 362
dsq_thread_id:
  - 246919908
categories:
  - Driver
  - Kernel
tags:
  - Android
  - Driver
  - Linux Kernel

---
在底層 Linux Kernel 提供了時序(timing)機制，方便驅動程式設計者所使用，核心是依據硬體發出的『計時器中斷』來追蹤時間的流動狀況。我們可以依據 HZ 的值來設計 Delay 機制，讓驅動程式可以每隔固定一段時間啟動或者是發出訊號，也可以利用 Timer 來讓 LED 閃爍變化，在介紹 Timer API 之前，可以先參考 [Linux Kernel: 簡介HZ, tick and jiffies][1] 這篇文章，瞭解一些相關名詞，舉例：如果想知道一秒後的 jiffies 時間，可以寫成底下： 

<pre class="brush: cpp; title: ; notranslate" title="">#ifdef CONFIG_BMA150_TIMER
#include &lt;linux/timer.h>
#endif
j = jiffies;
/* 一秒之後 */
stamp_1 = j + HZ;
/* 半秒之後 */
stamp_1 = j + HZ/2; 
/* 20秒之後 */
stamp_1 = j + 20*HZ;</pre>

### Timer API 用法 筆記一下自己在寫 BOSCH Sensortec 三軸加速偵測器(BMA150 Sensor) Driver 的時候，遇到底層要回報 input event X,Y,Z 到 

[Android][2] HAL([Hardware abstraction layer][3])，所以利用 Timer 的機制定時 report 給 Android。 首先宣告： 

<pre class="brush: cpp; title: ; notranslate" title="">#ifdef CONFIG_BMA150_TIMER
#include &lt;linux/timer.h>
#endif
/* 定義 timer_list struct */
#ifdef CONFIG_BMA150_TIMER
struct timer_list bma150_report_timer;
#endif</pre> 在 Driver 內的 bma150_probe 裡面 call function: 

<pre class="brush: cpp; title: ; notranslate" title="">#ifdef CONFIG_BMA150_TIMER
  bma150_init_timer();
#endif</pre> 撰寫 bma150\_init\_timer 函式： 

<pre class="brush: cpp; title: ; notranslate" title="">#ifdef CONFIG_BMA150_TIMER
static void bma150_init_timer(void)
{  
  D("BMA150 init_timer start\n");
  /* Timer 初始化 */
  init_timer(&bma150_report_timer);
  /* 定義 timer 所執行之函式 */
  bma150_report_timer.function = bma150_report;
  /* 定義 timer 傳入函式之 Data */
  bma150_report_timer.data = ((unsigned long) 0);
  /* 定義 timer Delay 時間 */
  bma150_report_timer.expires = jiffies + BMA150_REPORT_DELAY_1;
  /* 啟動 Timer*/
  add_timer(&bma150_report_timer); 
}
#endif </pre> 上述 add\_timer 執行之後，會在一秒後執行 bma150\_report 函式，執行之後就會停止，所以如果要一直產生迴圈，就必須在 bma150\_report 裡面繼續加入 add\_timer，改寫如下： 

<pre class="brush: cpp; title: ; notranslate" title="">static int bma150_report(void)
{
  D("appleboy: test timer. \n");
#ifdef CONFIG_BMA150_TIMER
  bma150_report_timer.expires = jiffies + BMA150_REPORT_DELAY_2;
  add_timer(&bma150_report_timer);
#endif 
  return 0;
}</pre> 我們可以重新定義 expires 時間 

<span style="color:green">jiffies + BMA150_REPORT_DELAY_2</span>，就可以一直循環了，要離開 Timer 可以在最後加入 <span style="color:green">deltimer(&bma150_report_timer)</span>，最後就完成簡易的 Timer 功能。 參考： [add_timer的使用方法][4] [Linux Kernel: 簡介HZ, tick and jiffies][1]

 [1]: http://adrianhuang.blogspot.com/2007/10/linux-kernel-hz-tick-and-jiffies.html
 [2]: http://code.google.com/intl/zh-TW/android/
 [3]: http://en.wikipedia.org/wiki/Hardware_abstraction_layer
 [4]: http://dragli.blogspot.com/2008/12/addtimer.html