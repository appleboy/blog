---
title: '[Perl&PHP] time() and Class::Date 日期轉換運算'
author: appleboy
type: post
date: 2009-11-03T15:28:56+00:00
url: /2009/11/perlphp-time-and-classdate-日期轉換運算/
views:
  - 6582
bot_views:
  - 543
dsq_thread_id:
  - 246713423
categories:
  - FreeBSD
  - Perl
  - php
tags:
  - FreeBSD
  - Perl
  - php

---
為了看個 [MLB][1] 美國職棒，寫了一個網站：[美國職棒影片收集站][2]，裡面的內容影片連結，以及連結說明，都是利用 [Perl][3] 搭配 [MySQL][4] 資料庫，以及 [CodeIgniter PHP Framework][5] 寫出來的，美國 MLB 開打時間，會比台灣晚一天的時差，所以在 [PHP][6] 跟 Perl 都要針對時間作修改以及轉換運算，那底下會寫 PHP 跟 Perl 如何控制時間，還有資料庫如何設計，會比較適當。 

## <span style="color: #008000;">PHP 日期轉換</span> MySQL 在資料庫時間格式方面，最主要常見的兩種儲存方式，一種就是 MySQL 預設 datetime，顯示的格式就會像是 

<span style="color: #ff0000;">2009-11-03 20:10:43</span>，另一種就是存成 [UNIX time][7] 格式，可以設定為 int(11)，這兩種其實都可以使用，在 [phpBB2][8] 是採用後者的方式，因為 open source 要支援多種資料庫，但是又要統一程式碼，所以乾脆用 UNIX 的時間標記，這樣比較好轉換時區，如果使用 UNIX 格式，可以利用 [time()][9] 函式來取的。 <!--more-->

<pre class="brush: php; title: ; notranslate" title="">#
# 得到目前系統 UNIX 時間
echo time();
# 下個禮拜時間
$nextWeek = time() + (7 * 24 * 60 * 60);
# 7 days; 24 hours; 60 mins; 60secs
# 另一種可以用 mktime 來取得系統 UNIX 時間
# 今天日期的 UNIX 時間
echo mktime(0,0,0, date("Y"),date("m"),date("d"));</pre> 所以我們可以存放到 mysql 資料庫，利用 time() 來 INSERT，接下來如何顯示時間：

[date()][10] 函式 

<pre class="brush: php; title: ; notranslate" title=""># 利用 date() 函式
$time = time();
echo date("Y-m-d H:i:s", $time);
$nextWeek = time() + (7 * 24 * 60 * 60);
echo date("Y-m-d H:i:s", $nextWeek);</pre> 如果資料庫格式用 datetime，那取出來的值必定是 

<span style="color: #ff0000;">Y-m-d H:i:s</span> 格式，那如何轉成 UNIX time 呢，可以用 [strtotime][11] 

<pre class="brush: php; title: ; notranslate" title="">#
# 將標準時間放入第一參數
echo strtotime("2009-10-10 20:22:10");
echo strtotime("now");</pre> 結論是 1. 如果資料庫用 int(11)，就利用 date(), mktime(), time() 轉換成時間格式 2. 如果資料庫用 datetime，就利用 strtotime() 轉換成 UNIX time 來做日期相加減 

## <span style="color: #008000;">Perl 日期轉換</span> 在 

[CPAN][12] 裡面找到 [Class-Date][13]，裡面就有我想要的日期相加減，以及如何轉換到昨天前天格式，FreeBSD 請找到 [devel/p5-Class-Date][14]。 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/devel/p5-Class-Date; make install clean</pre> 使用方法請參考底下： 

<pre class="brush: perl; title: ; notranslate" title=""># creating absolute date object (local time) 建立日期物件
$date = now; #同等於 $date = date(time);
# getting values of an absolute date object 取得物件內容
$date->year;        # year, e.g: 2001
$date->_year;       # year - 1900, e.g. 101
$date->yr;          # 2-digit year 0-99, e.g 1
$date->mon;         # month 1..12
$date->day;         # day of month
$date->epoch;       # UNIX time_t 取得 UNIX 時間
# 美國時間減一天
my $now = now - '1D';
my $now_day = sprintf("%04d-%02d-%02d", $now->year, $now->month, $now->mday);
my $now_month = sprintf("%04d-%02d", $now->year, $now->month);
</pre>

 [1]: http://mlb.mlb.com/index.jsp
 [2]: http://mimi.twgg.org/
 [3]: http://www.perl.org/
 [4]: http://www.mysql.com/
 [5]: http://codeigniter.com/
 [6]: http://www.php.net
 [7]: http://en.wikipedia.org/wiki/Unix_time
 [8]: http://www.phpbb.com/
 [9]: http://php.net/manual/en/function.time.php
 [10]: http://tw.php.net/manual/en/function.date.php
 [11]: http://tw.php.net/manual/en/function.strtotime.php
 [12]: http://search.cpan.org/
 [13]: http://search.cpan.org/~dlux/Class-Date-1.1.9/Date.pod
 [14]: http://www.freshports.org/devel/p5-Class-Date/