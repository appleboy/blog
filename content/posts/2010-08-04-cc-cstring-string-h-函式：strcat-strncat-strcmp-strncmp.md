---
title: '[C/C++] cstring (string.h) 函式：strcat, strncat, strcmp, strncmp'
author: appleboy
type: post
date: 2010-08-04T07:29:46+00:00
url: /2010/08/cc-cstring-string-h-函式：strcat-strncat-strcmp-strncmp/
views:
  - 6555
bot_views:
  - 350
dsq_thread_id:
  - 246731541
categories:
  - C/C++
tags:
  - C/C++

---
## 串接函式 strcat

[strcat][1] 此函式用來連接兩字串合併成單一字串，直接看底下範例：

```c
/* strcat example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char str[80];
  strcpy (str,"these ");
  strcat (str,"strings ");
  strcat (str,"are ");
  strcat (str,"concatenated.");
  puts (str);
  return 0;
}
```

output: 

```sh
these strings are concatenated. 
```

看一下 strcat 原始碼：

```c
char *
strcat(char * __restrict s, const char * __restrict append)
{
    char *save = s;

    for (; *s; ++s);
    while ((*s++ = *append++));
    return(save);
}
```

設定指標 save 成 source，再將 s 指標指向最後，接下來根據 append 字串一個一個往後串接，直到碰到 \0 終止 while 迴圈，最後在將指標 *save 回傳即可。

## 比較函式 strcmp

[strcmp][2] 用來比較兩字串是否相同，相同回傳 0，不相同則回傳兩字串 ASCII 相減的值。底下範例：

```c
/* strcmp example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char szKey[] = "apple";
  char szInput[80];
  do {
     printf ("Guess my favourite fruit? ");
     gets (szInput);
  } while (strcmp (szKey,szInput) != 0);
  puts ("Correct answer!");
  return 0;
}
```

來看看 strcmp 原始碼

```c
#include <string.h>

/*
 * Compare strings.
 */
int
strcmp(s1, s2)
    const char *s1, *s2;
{
    while (*s1 == *s2++)
        if (*s1++ == 0)
            return (0);
    return (*(const unsigned char *)s1 - *(const unsigned char *)(s2 - 1));
}
```

大家可以看到，比對字串會依序比對，直到 s1 最後字元 \0 則會回傳 0 代表比對成功，如果中途有字元比對不同，則會將兩個字元相減回傳。

## 串接函式 strncat

[strncat][3] 用來串接指定多少字元，底下範例：

```c
/* strncat example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char str1[20];
  char str2[20];
  strcpy (str1,"To be ");
  strcpy (str2,"or not to be");
  strncat (str1, str2, 6);
  printf("%s\n", str1);
  return 0;
}
```

strncat 原始碼

```c
#include <string.h>

/*
 * Concatenate src on the end of dst.  At most strlen(dst)+n+1 bytes
 * are written at dst (at most n+1 bytes being appended).  Return dst.
 */
char *
strncat(char * __restrict dst, const char * __restrict src, size_t n)
{
    if (n != 0) {
        char *d = dst;
        const char *s = src;

        while (*d != 0)
            d++;
        do {
            if ((*d = *s++) == 0)
                break;
            d++;
        } while (--n != 0);
        *d = 0;
    }
    return (dst);
}
```

一樣是先將 dst 指標指向最後一個字元+1，再根據需要串接的大小來決定 dst 最後的指標。

## 比較函式 strncmp

直接看範例，比較字串前兩個字元是否相同，如果相同則印出

```c
/* strncmp example */
#include <stdio.h>
#include <string.h>

int main ()
{
  char str[][5] = { "R2D2" , "C3PO" , "R2A6" };
  int n;
  puts ("Looking for R2 astromech droids...");
  for (n=0 ; n<3 ; n++)
    if (strncmp (str[n],"R2xx",2) == 0)
    {
      printf ("found %s\n",str[n]);
    }
  return 0;
}
```

[strncmp][4] 原始碼

```c
#include <string.h>

int
strncmp(s1, s2, n)
    const char *s1, *s2;
    size_t n;
{

    if (n == 0)
        return (0);
    do {
        if (*s1 != *s2++)
            return (*(const unsigned char *)s1 -
                *(const unsigned char *)(s2 - 1));
        if (*s1++ == 0)
            break;
    } while (--n != 0);
    return (0);
}
```

最後參數傳入 0 則會直接回傳 0，依序比對，直到 n =0 的時候跳出比較迴圈，然後回傳 0，代表比對成功。

 [1]: http://www.cplusplus.com/reference/clibrary/cstring/strcat/
 [2]: http://www.cplusplus.com/reference/clibrary/cstring/strcmp/
 [3]: http://www.cplusplus.com/reference/clibrary/cstring/strncat/
 [4]: http://www.cplusplus.com/reference/clibrary/cstring/strncmp/