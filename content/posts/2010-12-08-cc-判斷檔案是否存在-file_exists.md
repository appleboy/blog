---
title: '[C/C++] 判斷檔案是否存在 file_exists'
author: appleboy
type: post
date: 2010-12-08T04:36:48+00:00
url: /2010/12/cc-判斷檔案是否存在-file_exists/
views:
  - 1203
bot_views:
  - 201
dsq_thread_id:
  - 246929905
categories:
  - C/C++
tags:
  - C/C++

---
在 PHP 函式裡面，有直接 file_exists 可以使用，相當方便:

<pre><code class="language-php"><?php
if(file_exists("files/appleboy.c")) {
    echo "File found!";
}
?></code></pre>

在 C 裡面該如何實做？有兩種方式如下:

### 1. 直接開檔

<pre><code class="language-C">bool file_exists(const char * filename)
{
    if (FILE * file = fopen(filename, "r"))
    {
        fclose(file);
        return true;
    }
    return false;
}</code></pre>

C++ 寫法

<pre><code class="language-c">std::fstream foo;

foo.open("bar");

if(foo.is_open() == true)
     std::cout << "Exist";
else 
     std::cout << "Doesn't Exist";</code></pre>

### 2. 讀取檔案狀態

<pre><code class="language-C">#include<sys/stat.h>
int file_exists (char * fileName)
{
   struct stat buf;
   int i = stat ( fileName, &buf );
     /* File found */
     if ( i == 0 )
     {
       return 1;
     }
     return 0;

}</code></pre>