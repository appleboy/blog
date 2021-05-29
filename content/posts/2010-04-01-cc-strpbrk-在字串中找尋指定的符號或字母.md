---
title: '[C/C++] strpbrk 在字串中找尋指定的符號或字母'
author: appleboy
type: post
date: 2010-04-01T15:19:04+00:00
url: /2010/04/cc-strpbrk-在字串中找尋指定的符號或字母/
views:
  - 6818
bot_views:
  - 422
dsq_thread_id:
  - 247043266
categories:
  - C/C++
tags:
  - C/C++

---
繼上一篇：『[[C/C++] 切割字串函數：strtok, Network mac address 分割][1]』，內容寫到 Microsoft 用到 [strpbrk][2] 來找尋字串中特定符號，並且回傳該符號的位址，用法如下：

<pre><code class="language-c">#include "string.h"
#include "stdlib.h"
#include "stdio.h"

int main ()
{
  char str[] = "This is a sample string";
  char key[] = "aeiou";
  char * pch;
  printf ("Vowels in &#039;%s&#039;: ",str);
  pch = strpbrk (str, key);
  while (pch != NULL)
  {
    printf ("%c " , *pch);
    /* 也可以直接輸出字串 */
    printf("\noutput=%s\n", pch);
    pch = strpbrk (pch+1,key);
  }
  printf ("\n");
  system("pause");
  return 0;
}</code></pre>

輸出結果： [<img src="https://i2.wp.com/farm5.static.flickr.com/4025/4481282945_92162c62ae_o.png?w=840&#038;ssl=1" alt="strpbrk" data-recalc-dims="1" />][3]

我們看一下 `/usr/src/lib/libc/string/strpbrk.c` 原始碼：

<pre><code class="language-c">/*
 * Find the first occurrence in s1 of a character in s2 (excluding NUL).
 */
char *
strpbrk(s1, s2)
    const char *s1, *s2;
{
    const char *scanp;
    int c, sc;

    while ((c = *s1++) != 0) {
        for (scanp = s2; (sc = *scanp++) != 0;)
            if (sc == c)
                return ((char *)(s1 - 1));
    }
    return (NULL);
}</code></pre>

首先將指定字串(str)，跟愈找尋的字串(key)方別帶入 s1, s2，當跑 while 迴圈時，會先去判斷是否到了字串最後一個字元，判斷是否為 NULL，如果不是，則進入 while 迴圈，在利用 for 迴圈去比對字串 key，其實都是利用 ASCII 轉換比對是否相同，如果相同，則回傳該指定字母之位址，回傳時還需要 s1 -1 呢？因為在 while 條件中已經將字串指到下一個字母位址，所以必需要在重新指回去前一字母。

 [1]: http://blog.wu-boy.com/2010/04/01/2103/
 [2]: http://www.cplusplus.com/reference/clibrary/cstring/strpbrk/
 [3]: https://www.flickr.com/photos/appleboy/4481282945/ "Flickr"