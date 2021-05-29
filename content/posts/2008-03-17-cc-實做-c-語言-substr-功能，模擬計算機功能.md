---
title: '[C/C++] 實做 C 語言 substr 功能，模擬計算機功能'
author: appleboy
type: post
date: 2008-03-17T14:05:12+00:00
url: /2008/03/cc-實做-c-語言-substr-功能，模擬計算機功能/
views:
  - 9447
bot_views:
  - 770
dsq_thread_id:
  - 246991000
categories:
  - 'BCB[Borland C/C++ Builder]'
  - C/C++
tags:
  - C/C++

---
前天在幫學弟寫程式，寫一個計算機程式，題目如下：

> 寫一程式模擬簡單的計算機 每個資料列含下列的運算子中的一個及其右運算元 假設左運算元存在累加器中(初值為0) 需要函式scan\_data 有2個輸出參數回傳 從資料列讀入的運算子元和右運算元 亦需函式do\_next_op 執行運算子的功能 此函式有2個輸入參數(運算子和運算元) 及一個輸入/輸出參數(累加器) 有效運算子有 + 加 &#8211; 減 * 乘 / 除 ^ 次方 q 結束 此計算器在每次運算後要顯示累加器之值 一個執行範例如下 +5.0 result so far is 5.0 ^2 result so far is 25.0 /2.0 result so far is 12.5 q0 final ressult is 12.5
上面是我學弟的題目，不過他有傳一份他朋友的作業給我看，我本身不太喜歡用 scanf，我比較喜歡用 fgets，但是後來遇到要切割文字的問題，也就是 C 語言沒有 substr 取字串的函式，所以利用底下來實做：

<!--more-->

<pre><code class="language-c">#include &lt;stdio.h&gt;
#include &lt;string.h&gt;

int main() {
  char s[] = "Hello World";
  char t[6];
  strncpy(t, s + 6, 5);
  t[5] = 0;
  printf("%s\n", t);
}
</code></pre>

strncpy函數原型如下

<pre><code class="language-c">char *strncpy(char *dest, const char *src, size_t n);
</code></pre>

dest為目標字串，src為來源字串，n為複製的字數。所以我們可以去變動src的指標，這樣就可以用strncpy()來模擬substr()了，我想這也是為什麼C語言不提供substr()的原因，畢竟用strncpy()就可以簡單的模擬出來。

唯一比較討厭的是

<pre><code class="language-c">t[5] = 0;</code></pre>

因為strncpy()不保證傳回的一定是NULL terminated，所以要自己補0當結尾，這是C語言比較醜的地方，若覺得strncpy()用法很醜陋，可以自己包成substr()。 然後也可以利用底下 function 的方式來實做：

<pre><code class="language-c">void substr(char *dest, const char* src, unsigned int start, unsigned int cnt) {
  strncpy(dest, src + start, cnt);
  dest[cnt] = 0;
}</code></pre>

寫成 function 方式來呼叫比較簡單，底下就是上面學弟作業的解答

<pre><code class="language-c">#include &lt;stdio.h&gt;
#include &lt;string.h&gt;
#include &lt;math.h&gt;
#include &lt;stdlib.h&gt;

char *p, ans[10], op[10], t[10];
double result = 0.0;

void substr(char *dest, const char* src, unsigned int start, unsigned int cnt) {
  strncpy(dest, src + start, cnt);
  dest[cnt] = 0;
}

void scan_data();
void scan_data()
{
  printf("請輸入你想要計算的方法(輸入 exit 離開)：");
  fgets(ans, sizeof(ans), stdin);
  if ((p = strchr(ans, &#039;\n&#039;)) != NULL)
    *p = &#039;\0&#039;;      
  substr(op, ans, 0, 1);
  substr(t, ans, 1, (sizeof(ans)-1));
}

void do_next_op(char *op1);
void do_next_op(char *op1)
{ 
  char k = *op1;
  if(!strcmp(k, "+"))
    result = result + atof(t);  
  else if(!strcmp(k, "-"))
    result = result - atof(t);
  else if(!strcmp(k, "*"))
    result = result * atof(t);
  else
    result = result / atof(t);
  printf("final result is %.2f\n", result);   
}

int main(int argc,char *argv[])
{
  int flag = 1;
  while (flag)
  {
    scan_data();
    if(strcmp(ans,"exit") == 0)
    {
      flag = 0;
    }
    do_next_op(&op);         
  }
  return 0;
}</code></pre>

reference: [<http://www.cnblogs.com/oomusou/archive/2008/03/08/1096832.html>][1]

 [1]: http://www.cnblogs.com/oomusou/archive/2008/03/08/1096832.html