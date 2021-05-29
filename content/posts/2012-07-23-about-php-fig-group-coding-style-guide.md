---
title: 關於 PHP FIG Group 所制定的 PSR-0, PSR-1, PSR-2
author: appleboy
type: post
date: 2012-07-23T06:06:59+00:00
url: /2012/07/about-php-fig-group-coding-style-guide/
dsq_thread_id:
  - 776382308
categories:
  - php
tags:
  - php
  - php-fig

---
上禮拜寫了一篇 <a href="http://blog.wu-boy.com/2012/07/how-to-write-maintainable-php-source-code/" target="_blank">寫出好維護的 PHP 程式碼</a>，看到 <a href="http://blog.gslin.org/" target="_blank">gslin 大神</a>回應了一篇 <a href="http://blog.gslin.org/archives/2012/07/23/2928/%E9%97%9C%E6%96%BC%E5%8F%AF%E7%B6%AD%E8%AD%B7%E7%9A%84-php-%E5%B0%88%E6%A1%88%EF%BC%9Aphp-fig-%E7%9A%84-psr-0%E3%80%81psr-1%E3%80%81psr-2/" target="_blank">關於可維護的 PHP 專案：PHP-FIG 的 PSR-0、PSR-1、PSR-2</a>，其實我已經關注 <a href="http://www.php-fig.org/" target="_blank">PHP FIG</a> 有一陣子了，FIG 所定義的三份文件 PSR-0 (<a href="https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md" target="_blank">Auto loading Standard</a>), PSR-1 (<a href="https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-1-basic-coding-standard.md" target="_blank">Basic Coding Standard</a>), PSR-2 <a href="https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md" target="_blank">(Coding Style Standard</a>) 寫的非常清楚，目的就是讓 PHP Open Source 專案有共同的 Coding Standard，方便大家共同開發。所以上禮拜提到的投影片內容有大部份參考了這份文件，裏面的內容比較不同的地方就差於 Control Structures 部份，舉個簡單例子： 寫 if 條件式，網路上只有兩種寫法 <?php
if ($a == $b) {
    ......
}[/code]

另外一種寫法

[code lang="php"]<?php
if ($a == $b) 
{
    ......
}[/code]
<!--more--> 原先我提供的 coding style 是上述第2種，這寫法在一些 open source 專案也是這樣寫，例如 

<a href="http://www.phpbb.com/" target="_blank">phpBB</a>, <a href="http://codeigniter.com" target="_blank">CodeIgniter</a>, <a href="http://fuelphp.com/" target="_blank">FuelPHP</a> ... 等，但是後來我仔細想想，還是按照 PHP FIG 的 Coding Style 會比較適合，也偏向大部份專案的寫法。底下是更新好的投影片，歡迎大家參考。 

<div style="margin-bottom:5px">
  <strong> <a href="http://www.slideshare.net/appleboy/maintainable-php-source-project-13712190" title="Maintainable PHP Source Code" target="_blank">Maintainable PHP Source Code</a> </strong> from <strong><a href="http://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div>