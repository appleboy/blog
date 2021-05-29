---
title: '[Perl] 解決 Wide character in print with UTF-8 mode'
author: appleboy
type: post
date: 2009-07-01T08:30:03+00:00
url: /2009/07/perl-with-utf-8-mode/
views:
  - 16045
bot_views:
  - 859
dsq_thread_id:
  - 247335686
categories:
  - Perl
tags:
  - Perl

---
最近在寫 Perl 的程式，發現在正規比對的時候，print 出中文資料會出現 "<span style="color: #ff0000;">Wide character in print at</span>" 的 warning 訊息，在 google 找到一篇解決方法：[Perl with UTF-8 mode][1]，這篇提出的解決方法有很多種，comment 留言也有提供解法，可以去看一下，還蠻不錯的，那底下是我參考的解法： 只要在表頭加上： 

<pre class="brush: perl; title: ; notranslate" title="">use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');</pre> 完整的檔案如下： 

<pre class="brush: perl; title: ; notranslate" title="">#! /usr/bin/perl -w
use Carp;
use File::Basename;
use LWP::Simple;
use WWW::Mechanize;
use LWP::UserAgent;
use WWW::Shorten '0rz';
use Getopt::Std;
use DBI;
use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
if($_ =~ m/\s*<div\s*class="title"><a\s*href=".+">(.+)<\/a><\/div>\s*/)
{
  $pic_desc = $1;
  print "desc: " . $1 . " \n" if $verbose;
} </pre>

 [1]: http://www.jeffhung.net/blog/articles/jeffhung/417/