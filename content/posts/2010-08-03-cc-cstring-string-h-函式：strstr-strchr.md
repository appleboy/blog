---
title: '[C/C++] cstring (string.h) 搜尋函式：strstr, strchr'
author: appleboy
type: post
date: 2010-08-03T08:24:23+00:00
url: /2010/08/cc-cstring-string-h-函式：strstr-strchr/
views:
  - 7707
bot_views:
  - 386
categories:
  - C/C++
tags:
  - C/C++

---
這次介紹 C 語言常用 string 函式：[strstr][1]，主要是針對兩個輸入參數做比對，<span style="color:green">Parameters 1</span> 是<span style="color:red">輸入字串</span>，<span style="color:green">Parameters 2</span> 是<span style="color:red">找尋字串</span>，strstr 會先將頭一次比對成功的 pointer 回傳，也就是如果要找尋 appleboyappleboy 字串中的 boy，函式會回傳第一次比對成功的 boy pointer，而並非回傳最後一個比對到的，底下是一個參考範例：

## strstr

<pre><code class="language-c">/* strstr example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char str[] ="This is a simple string";
  char * pch;
  /* 找尋 simple 字串 */
  pch = strstr (str,"simple");
  /* 將 simple 換成 sample */
  strncpy (pch,"sample",6);
  puts (str);
  return 0;
}</code></pre>

看一下 Kernel 原始檔案，strstr 函式：

<pre><code class="language-c">/*
 * Find the first occurrence of find in s.
 */
char *
strstr(s, find)
    const char *s, *find;
{
    char c, sc;
    size_t len;

    if ((c = *find++) != 0) {
        len = strlen(find);
        do {
            do {
                if ((sc = *s++) == 0)
                    return (NULL);
            } while (sc != c);
        } while (strncmp(s, find, len) != 0);
        s--;
    }
    return ((char *)s);
}</code></pre>

先將 sc 指定為內容字串，c 指定為找尋字串，利用兩個迴圈開始一一筆對，利用 strncmp 比對字串，在將比對成功的 pointer 回傳，但是回傳之前需要在將 s-- 回到前一個指標，這樣就ok了。

## strchr

這字串用來找尋<span style="color:red">第一次比對成功單一字母符號</span>，也是一樣回傳該指標，底下是範例：

<pre><code class="language-c">/* strchr example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char str[] = "This is a sample string";
  char * pch;
  printf ("Looking for the 's' character in \"%s\"...\n",str);
  pch=strchr(str,'s');
  while (pch!=NULL)
  {
    printf ("found at %d\n",pch-str+1);
    pch=strchr(pch+1,'s');
  }
  return 0;
}</code></pre>

上面範例很容易，那底下來看看完整 [strchr][2] 程式碼：

<pre><code class="language-c">char * strchr
(const char *p, int ch)
{
    char c;

    c = ch;
    for (;; ++p) {
        if (*p == c)
            return ((char *)p);
        if (*p == '\0')
            return (NULL);
    }
    /* NOTREACHED */
}</code></pre>

就只能針對<span style="color:red"><strong>單一字母</strong></span>符號做搜尋，跟 strstr 不同的是 strstr 是針對<span style="color:red"><strong>多個字母符號</strong></span>搜尋，很好區別吧 ^^。

 [1]: http://www.cplusplus.com/reference/clibrary/cstring/strstr/
 [2]: http://www.cplusplus.com/reference/clibrary/cstring/strchr/