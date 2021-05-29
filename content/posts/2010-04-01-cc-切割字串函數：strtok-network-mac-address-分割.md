---
title: '[C/C++] 切割字串函數：strtok, Network mac address 分割'
author: appleboy
type: post
date: 2010-04-01T14:16:57+00:00
url: /2010/04/cc-切割字串函數：strtok-network-mac-address-分割/
views:
  - 15354
bot_views:
  - 450
dsq_thread_id:
  - 246697089
categories:
  - C/C++
tags:
  - C/C++

---
今天寫了 [strtok][1] 的範例：『如何分離網路 mac address』程式碼如下，大家一定會有疑問 strtok 第一次呼叫，第一參數輸入愈分離的字串，在 while 迴圈，則是輸入 NULL 呢？底下就來解析 strtok.c 的程式碼。

<pre><code class="language-c">/*
*
* Author      : appleboy
* Date        : 2010.04.01
* Filename    : strtok.c
*
*/

#include "string.h"
#include "stdlib.h"
#include "stdio.h"

int main()
{
  char str[]="00:22:33:4B:55:5A";
  char *delim = ":";
  char * pch;
  printf ("Splitting string \"%s\" into tokens:\n",str);
  pch = strtok(str,delim);
  while (pch != NULL)
  {
    printf ("%s\n",pch);
    pch = strtok (NULL, delim);
  }      
  system("pause");
  return 0;
}</code></pre>

執行結果如下圖：

[<img src="https://i0.wp.com/farm5.static.flickr.com/4033/4481772534_e066c7e3d2_o.png?resize=405%2C164&#038;ssl=1" alt="strtok" data-recalc-dims="1" />][2]

strtok.c 在 [FreeBSD][3] 7.1 Release 裡面路徑是 `/usr/src/lib/libc/string/strtok.c`，可以看到底下函式 `__strtok_r`

<pre><code class="language-c">__strtok_r(char *s, const char *delim, char **last)
{
    char *spanp, *tok;
    int c, sc;

    if (s == NULL && (s = *last) == NULL)
        return (NULL);

    /*
     * Skip (span) leading delimiters (s += strspn(s, delim), sort of).
     */
cont:
    c = *s++;
    for (spanp = (char *)delim; (sc = *spanp++) != 0;) {
        if (c == sc)
            goto cont;
    }

    if (c == 0) {       /* no non-delimiter characters */
        *last = NULL;
        return (NULL);
    }
    tok = s - 1;

    /*
     * Scan token (scan for delimiters: s += strcspn(s, delim), sort of).
     * Note that delim must have one NUL; we stop if we see that, too.
     */
    for (;;) {
        c = *s++;
        spanp = (char *)delim;
        do {
            if ((sc = *spanp++) == c) {
                if (c == 0)
                    s = NULL;
                else
                    s[-1] = &#039;\0&#039;;
                *last = s;
                return (tok);
            }
        } while (sc != 0);
    }
    /* NOTREACHED */
}</code></pre>

大家可以看到，在第一次執行 strtok 時候，會針對傳入s字串每一個字進行比對，c = _s++; 意思就是 c 先設定成_ s，這行執行結束之後，會將 *s 指標加1，也就是字母 T -> h 的意思，這地方必須注意，如果第一個字母符合 delim 分隔符號，就會執行 goto cont;，如果不是，則會將 tok 指標指向 s 字串第一個位址，再來跑 for 迴圈找出下一個分隔字串，將其字串設定成 \0 中斷點，回傳 tok 指標，並且將s字串初始值指向分隔字串的下一個位址。

接下來程式只要繼續執行 strtok(NULL, delim)，程式就會依照上次所執行的 s 字串繼續比對下去，等到 *last 被指向 NULL 的時候就不會在執行 strtok 了，我相信這非常好懂，微軟 Visual Studio 有不同的[寫法][4]：

<pre><code class="language-c">/* Copyright (c) Microsoft Corporation. All rights reserved. */

#include &lt;string.h&gt;

/* ISO/IEC 9899 7.11.5.8 strtok. DEPRECATED.
 * Split string into tokens, and return one at a time while retaining state
 * internally.
 *
 * WARNING: Only one set of state is held and this means that the
 * WARNING: function is not thread-safe nor safe for multiple uses within
 * WARNING: one thread.
 *
 * NOTE: No library may call this function.
 */

char * __cdecl strtok(char *s1, const char *delimit)
{
    static char *lastToken = NULL; /* UNSAFE SHARED STATE! */
    char *tmp;

    /* Skip leading delimiters if new string. */
    if ( s1 == NULL ) {
        s1 = lastToken;
        if (s1 == NULL)         /* End of story? */
            return NULL;
    } else {
        s1 += strspn(s1, delimit);
    }

    /* Find end of segment */
    tmp = strpbrk(s1, delimit);
    if (tmp) {
        /* Found another delimiter, split string and save state. */
        *tmp = &#039;\0&#039;;
        lastToken = tmp + 1;
    } else {
        /* Last segment, remember that. */
        lastToken = NULL;
    }

    return s1;
}</code></pre>

微軟用了 [strpbrk][5] 來取代 for 迴圈的字串比對，但是整個流程是差不多的，大家可以參考看看，果然看 Code 長知識。

 [1]: http://www.cplusplus.com/reference/clibrary/cstring/strtok/
 [2]: https://www.flickr.com/photos/appleboy/4481772534/ "Flickr 上 appleboy46 的 strtok"
 [3]: http://www.freebsd.org
 [4]: https://research.microsoft.com/en-us/um/redmond/projects/invisible/src/crt/strtok.c.htm
 [5]: http://www.cplusplus.com/reference/clibrary/cstring/strpbrk/