---
title: '[C/C++] 指標相加 = ？or 相減 = offset'
author: appleboy
type: post
date: 2010-02-08T06:50:16+00:00
url: /2010/02/cc-指標相加-？or-相減-offset/
views:
  - 6891
bot_views:
  - 532
dsq_thread_id:
  - 246807838
categories:
  - C/C++
tags:
  - C/C++

---
最近看到網路上討論 C/C++ 題目，某公司主管給新進人員面試的 C/C++ 考題，如下：

```C
int main(void)
{
     int *a,*b;
     a=1;
     b=1;
     printf("%d\n",a+b);
     return 0;
}
```

請問上面這個題目，哪裡有出問題，這是面試官問新進人員的題目之一，看也知道這程式丟到 [Dev-C++][1] 是不會過的，_a_ b 都是宣告為整數指標型態，可是在 a=1 或 b=1 在 Dev-C++ 裡面是編譯不過的，但是那寫法是沒有錯的，就像你設定 a=0 或者是 a=NULL 是一樣意思，不過最好是不要這樣寫，assignment 這樣寫不太好，可以改成 a = (int _)1; b = (int_ )1; 這樣就可以順利編譯通過，再來 printf("%d\n",a+b); 這行錯很大，指標相加會爆炸吧，如果程式這樣寫，不把 OS 搞掛，那我還會覺得懷疑呢，正確寫法是指標加上 offset(位移)，這樣才是可以正確執行的，所以我們把程式改成下面：

```C
int main(void)
{
     int *a,*b;
     a = (int *)1;
     b = (int *)1;
     printf("%d\n",a+(int)b);
     return 0;
}
```

最後的執行結果是 5，(int) b 就相當於 sizeof(_b) 也等於 sizeof(int_ ) 答案都是四，所以就是 1+4 =5，指標是不能相加的，只能透過 offset 方式來讓指標指向不同 base，但是如果是指標相減，那就是求 offset 的意思喔，看一下底下例子

```C
int main(void)
{
    int *a,*b;
    a = (int *)0x5566;
    b = (int *)0x5570;
    printf("%d %d %d %d %d\n", a, b, (int)a+(int)b, a+(int)b, sizeof(int *));
    printf("%d\n", a - b);
    printf("%d\n", ((int)b - (int)a)/sizeof(int *));
    return 0;
}
```

要算 offset 也非常容易，只要先轉成 10 進位相減在除以 sizeof(int *) 這樣就可以求出結果了，a-b 除以四其實 -2.5 取補數，所以是 -3，如果是 b-a 就是整數3了，只是位移 3 個 bit，其實觀念就是這樣，指標位址不能相加，但是指標位址可以相減 = Offset，觀念大致上是這樣，最後補上完整程式，大家可以 run 一次看看就知道了

```C
#include "string.h"
#include "stdlib.h"
#include "stdio.h"

int main(void)
{
    int *a, *b;
    a = (int *)1;
    b = (int *)1;
    printf("%d %d %d\n", a + (int)b, (int)(a + (int)b), (int)a + (int)b); 
    a = (int *)0x5566;
    b = (int *)0x5570;

    printf("%d %d %d %d %d\n", a, b, (int)a+(int)b, a+(int)b, sizeof(int *));
    printf("%d\n", a - b);
    printf("%d\n", ((int)b - (int)a)/sizeof(int *));

    a = (int*)0x1000;
    b = a + 3;
    printf("%d %d %p %p \n", a, b, a, b);

    system("pause");
    return 0;
}
```

 [1]: http://www.bloodshed.net/index.html