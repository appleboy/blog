---
title: '[Linux Kernel] 讀取 /proc 底下資料最佳方法: seq_file interface'
author: appleboy
type: post
date: 2011-03-14T11:38:55+00:00
url: /2011/03/linux-kernel-讀取-proc-底下資料最佳方法-seq_file-interface/
views:
  - 1020
bot_views:
  - 153
dsq_thread_id:
  - 253526709
categories:
  - Driver
  - Kernel
  - Linux
tags:
  - C/C++
  - Linux Kernel

---
### 前言 最近在整合公司內部 

[Atheros][1](被[高通][2]買下) 晶片的 Router，從原本 2.6.15 升級到 2.6.34.7，升級過程遇到很多困難，其中一項升級 Wireless Driver 部份，發現在 Kernel Socket 與 User Space 溝通之間出了問題，利用 Ioctl 來取得目前在 AP 上面所有 Client 資料(包含 mac address, 處於 N or G mode...等)，在 User Space 上會掉資料，後來利用 /proc 底下檔案來跟 User 之間溝通，才沒有發生任何問題，由於輸出的檔案比較多，就偏向用 2.6 Kernel 提供的 [seq_file 介面( interface )][3]建立虛擬檔案 (virtual file) 與 User Space 溝通(此方法為 Alexander Viro 所設計)，此功能其實在 2.4.15 已經實做了，只是在 2.6 版本才被大量使用。 程式設計師可以透過引入 <span style="color:green"><strong><linux/seq_file.h></strong></span> 來實做 seq\_file interface，seq\_file 最大優勢就是讀取完全沒有4k boundry 的限制，也就是不用管會不會超出 output buffer。 

### The iterator interface 為了能夠讓 iterator 正常運作，我們必須實做 4 個 function (start, next, stop, show)，跑得過程為 start -> show -> next -> show -> next -> stop，為了方便講解，參考 

[Linux Kernel（4）- seq_file][4] 裡面範例如下： 

<pre class="brush: cpp; title: ; notranslate" title="">#include <linux/init.h>
#include <linux/module.h>
#include <linux/proc_fs.h> /* Necessary because we use proc fs */
#include <linux/seq_file.h> /* for seq_file */
#include <linux/uaccess.h>

MODULE_LICENSE("GPL");

#define MAX_LINE 1000
static uint32_t *lines;

/**
 * seq_start() takes a position as an argument and returns an iterator which
 * will start reading at that position.
 */
static void* seq_start(struct seq_file *s, loff_t *pos)
{
    uint32_t *lines;

    if (*pos >= MAX_LINE) {
        return NULL; // no more data to read
    }

    lines = kzalloc(sizeof(uint32_t), GFP_KERNEL);
    if (!lines) {
        return NULL;
    }

    *lines = *pos + 1;

    return lines;
}

/**
 * move the iterator forward to the next position in the sequence
 */
static void* seq_next(struct seq_file *s, void *v, loff_t *pos)
{
    uint32_t *lines = v;
    *pos = ++(*lines);
    if (*pos >= MAX_LINE) {
        return NULL; // no more data to read
    }
    return lines;
}

/**
 * stop() is called when iteration is complete (clean up)
 */
static void seq_stop(struct seq_file *s, void *v)
{
    kfree(v);
}

/**
 * success return 0, otherwise return error code
 */
static int seq_show(struct seq_file *s, void *v)
{
    seq_printf(s, "Line #%d: This is Brook's demo\n", *((uint32_t*)v));
    return 0;
}

static struct seq_operations seq_ops = {
    .start = seq_start,
    .next  = seq_next,
    .stop  = seq_stop,
    .show  = seq_show
};

static int proc_open(struct inode *inode, struct file *file)
{
    return seq_open(file, &seq_ops);
}

static struct file_operations proc_ops = {
    .owner   = THIS_MODULE, // system
    .open    = proc_open,
    .read    = seq_read,    // system
    .llseek  = seq_lseek,   // system
    .release = seq_release  // system
};

static int __init init_modules(void)
{
    struct proc_dir_entry *ent;

    ent = create_proc_entry("brook", 0, NULL);
    if (ent) {
        ent->proc_fops = &proc_ops;
    }
    return 0;
}

static void __exit exit_modules(void)
{
    if (lines) {
        kfree(lines);
    }
    remove_proc_entry("brook", NULL);
}

module_init(init_modules);
module_exit(exit_modules);</pre>

<!--more--> 裡面可以發現實做了 seq\_start, seq\_next, seq\_stop, seq\_show，首先，我們要實作 start() 函式，其主要功能就是回傳 iterator 要讀取的單一位置(position)，position 從 0 開始，而我們打算從第一行開始讀取 

**<span style="color:green">void * (*start) (struct seq_file *m, loff_t *pos);</span>** 接下來實做 next() 功能，其主要是將 position 移動到下一個位置，所以移動到下一個，我們必須將 iterator 加一 **<span style="color:green">void * (*next) (struct seq_file *m, void *v, loff_t *pos);</span>** 最後要實作 stop()，當 iterator 執行完畢，我們必須將 start() 所用到的記憶體釋放 **<span style="color:green">void (*stop) (struct seq_file *m, void *v);</span>** 

### Formatted Output 顯示的 callback function 為 show，seq_file 提供了幾個 function 讓大家使用 

<pre class="brush: bash; title: ; notranslate" title="">int seq_printf(struct seq_file *m, const char *f, ...): 類似 printf 或 printk
int seq_puts(struct seq_file *m, const char *s): 印字串
int seq_putc(struct seq_file *m, char c): 印字元</pre> 最後說明一下 module 啟動流程，首先定義您要的 /proc/file，給接下來在 module 初始化的時候宣告 

<pre class="brush: cpp; title: ; notranslate" title="">static int __init init_modules(void)
{
    struct proc_dir_entry *ent;

    ent = create_proc_entry("brook", 0, NULL);
    if (ent) {
        ent->proc_fops = &proc_ops;
    }
    return 0;
}</pre> 我們可以看到當建立 proc file 時綁定特定 

<span style="color:green">proc_ops</span> operation 

<pre class="brush: cpp; title: ; notranslate" title="">static struct file_operations proc_ops = {
    .owner   = THIS_MODULE, // system
    .open    = proc_open,
    .read    = seq_read,    // system
    .llseek  = seq_lseek,   // system
    .release = seq_release  // system
};</pre> 接著打開檔案時呼叫 

<span style="color:green">proc_open</span>: 

<pre class="brush: cpp; title: ; notranslate" title="">static int proc_open(struct inode *inode, struct file *file)
{
    return seq_open(file, &seq_ops);
}</pre> proc\_open 則是回傳 seq\_file 四個 

<span style="color:green">seq_ops</span> operation 

<pre class="brush: cpp; title: ; notranslate" title="">static struct seq_operations seq_ops = {
    .start = seq_start,
    .next  = seq_next,
    .stop  = seq_stop,
    .show  = seq_show
};</pre> 就是上面所列的四個最主要的 function。

 [1]: http://www.atheros.com/
 [2]: http://www.qualcomm.com/
 [3]: http://lwn.net/Articles/22355/
 [4]: http://nano-chicken.blogspot.com/2009/12/linux-modulesiv-seqfile.html