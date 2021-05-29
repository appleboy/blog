---
title: '[C/C++] count 1 bits of input value by shifting.'
author: appleboy
type: post
date: 2010-05-18T14:37:40+00:00
url: /2010/05/cc-count-1-bits-of-input-value-by-shifting/
views:
  - 3131
bot_views:
  - 365
dsq_thread_id:
  - 246784995
categories:
  - C/C++
tags:
  - C/C++

---
之前寫了一篇：『[[C/C++] 計算二進位任意數含有多少個位元為1?][1]』，裡面用 n &= (n - 1); 的方式來計算二進位數字總共會得到多少 bit，這次來紀錄利用 shift 方式也可以得到總共含有多少 bit 數目，函式如下：

```C
#include <stdio.h>
#include <stdlib.h>
int count_1_bit_count(unsigned int);
int main(){
    int count = 0, a;
    a = 1023;
    count = count_1_bit_count(a);
    printf("%d有%d個位元為1\n\n", a, count);
    system("pause");
    return 0;
}
int count_1_bit_count(unsigned int n)
{
    int count = 0;
    for(count = 0; n != 0; n >>= 1L)
    {    
        if(n & 0x01)
            count++;
    }    
    return count;
}
```

關鍵就是在 <span style="color:green">n >>= 1L</span>，把該數字往右位移 1 bit，然後跟 <span style="color:green">0x01</span> 去做 and，如果數字大於0，count 就加 1。

 [1]: http://blog.wu-boy.com/2010/02/24/2036/