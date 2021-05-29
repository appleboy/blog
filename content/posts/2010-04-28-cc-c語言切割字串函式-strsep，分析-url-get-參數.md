---
title: '[C/C++] C語言切割字串函式 strsep，分析 URL GET 參數'
author: appleboy
type: post
date: 2010-04-28T03:25:44+00:00
url: /2010/04/cc-c語言切割字串函式-strsep，分析-url-get-參數/
views:
  - 8423
bot_views:
  - 436
dsq_thread_id:
  - 246806955
categories:
  - C/C++
tags:
  - C/C++

---
今天來簡介 UNIX 內建的 [strsep][1] 函式，這在 Windows [Dev-C++][2] 是沒有支援的，在寫 UNIX 分析字串常常需要利用到此函式，大家可以 man strsep 來看如何使用 strsep，假設我們要分析 URL Get 字串：<span style="color:green">user_command=appleboy&test=1&test2=2</span>，就可以利用兩次 strsep 函式，將字串全部分離，取的個別的 name, value。strsep(stringp, delim) 第一個參數傳入需要分析的字串，第二個參數傳入 delim 符號，假設 stringp 為 NULL 字串，則函式會回傳 NULL，換句話說，strsep 會找到 stringp 字串<span style="color:red"><strong>第一個出現 delim 符號</strong></span>，並將其取代為 \0 符號，然後將 stringp <span style="color:red"><strong>更新</strong></span>指向到 \0 符號的下一個字串，strsep() function 回傳原來的 stringp 指標。看上面文字敘述，好像不太瞭解，沒關係，底下是 UNIX strsep.c 的原始碼：

<pre><code class="language-c">/*
 * Get next token from string *stringp, where tokens are possibly-empty
 * strings separated by characters from delim.
 *
 * Writes NULs into the string at *stringp to end tokens.
 * delim need not remain constant from call to call.
 * On return, *stringp points past the last NUL written (if there might
 * be further tokens), or is NULL (if there are definitely no more tokens).
 *
 * If *stringp is NULL, strsep returns NULL.
 */
char *
strsep(stringp, delim)
    char **stringp;
    const char *delim;
{
    char *s;
    const char *spanp;
    int c, sc;
    char *tok;

    if ((s = *stringp) == NULL)
        return (NULL);
    for (tok = s;;) {
        c = *s++;
        spanp = delim;
        do {
            if ((sc = *spanp++) == c) {
                if (c == 0)
                    s = NULL;
                else
                    s[-1] = 0;
                *stringp = s;
                return (tok);
            }
        } while (sc != 0);
    }
    /* NOTREACHED */
}</code></pre>

<!--more-->

上面程式碼可以看到 stringp 如果為 NULL 就回傳 NULL，接下來進行每一個字的比對，如果發現到有 delim，如果是在字串結尾符號 \0，則將字串設定為 NULL 並且更新 stringp，如果並非字串結尾，就將字串(s)往前一個(delim 符號)，並且將其改變為 \0 分割點，且更新 *stringp 指向 delim 符號下一個字，回傳初始字串。

底下來分析 <span style="color:green">username=appleboy&password=1234&action=delete</span> 字串，程式碼如下：

<pre><code class="language-c">
/*
*
* Author      : appleboy
* Date        : 2010.04.27
* Filename    : strsep.c
*
*/
int main()
{
    int len, nel;
    char query[] = "user_command=appleboy&test=1&test2=2";
    char *q, *name, *value;

    /* Parse into individual assignments */

    q = query;
    fprintf(stderr, "CGI[query string] : %s\n", query);

    len = strlen(query);
    nel = 1;
    while (strsep(&q, "&"))
        nel++;
    fprintf(stderr, "CGI[nel string] : %d\n", nel);

    for (q = query; q < (query + len);) {
        value = name = q;

        /* Skip to next assignment */
        fprintf(stderr, "CGI[string] : %s\n", q);
        fprintf(stderr, "CGI[string len] : %d\n", strlen(q));
        fprintf(stderr, "CGI[address] : %x\n", q);
        for (q += strlen(q); q < (query + len) && !*q; q++);
        /* Assign variable */
        name = strsep(&value, "=");
        fprintf(stderr, "CGI[name ] : %s\n", name);
        fprintf(stderr, "CGI[value] : %s\n", value);
    }
    return 0;
}
</code></pre>

裡面大家可以看一下 <span style="color:green">while (strsep(&q, "&"))</span> 這邊，這是利用 & 符號切割字串，並且算出有幾個符合，底下再把 q 重新指向 query，跑 for 迴圈，要小於字串長度，由於已經經過一次 strsep 函式，所以全部的 & 符號都取代成 \0，整體字串變成 **user_command=appleboy<span style="color:red">\0</span>test=1<span style="color:red">\0</span>test2=2**，故執行到 <span style="color:green">for (q += strlen(q); q < (query + len) && !*q; q++);</span>，會將 q 指標指向 test=1 的 t 字母，底下在 name = strsep(&value, "="); 將原本的 user\_command=appleboy 分割，所以 name 輸出 user\_command，value 輸出 appleboy，大致上是這樣。

輸出結果：

<pre><code class="language-bash">CGI[query string] : user_command=appleboy&test=1&test2=2
CGI[nel string] : 4
CGI[string] : user_command=appleboy
CGI[string len] : 21
CGI[address] : bfb537b0
CGI[name ] : user_command
CGI[value] : appleboy
CGI[string] : test=1
CGI[string len] : 6
CGI[address] : bfb537c6
CGI[name ] : test
CGI[value] : 1
CGI[string] : test2=2
CGI[string len] : 7
CGI[address] : bfb537cd
CGI[name ] : test2
CGI[value] : 2</code></pre>

 [1]: http://linux.about.com/library/cmd/blcmdl3_strsep.htm
 [2]: http://www.bloodshed.net/dev/devcpp.html