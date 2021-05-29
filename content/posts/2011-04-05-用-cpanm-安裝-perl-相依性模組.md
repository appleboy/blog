---
title: 用 cpanm 安裝 Perl 相依性模組
author: appleboy
type: post
date: 2011-04-05T06:29:15+00:00
url: /2011/04/用-cpanm-安裝-perl-相依性模組/
views:
  - 76
bot_views:
  - 145
dsq_thread_id:
  - 271350438
categories:
  - Perl
tags:
  - Perl

---
最近在寫 [Perl][1] 爬蟲程式，需要用到短網址 Bitly 的 API，所以找了 [WWW::Shorten::Bitly][2]，本篇紀錄安裝使用 cpanm 這 Perl 的小工具，此工具不需要任何設定，只要下載到 bin 目錄就可以正成使用了。由於 [Ubuntu][3] 沒有包好的 dpkg 可以用，所以才想到用 cpanm。 

### 安裝 cpanm

<pre class="brush: bash; title: ; notranslate" title="">mkdir ~/bin
wget --no-check-certificate http://bit.ly/cpanm -O ~/bin/cpanm
chmod +x ~/bin/cpanm</pre> 或者可以直接安裝到 

<span style="color:green"><strong>/usr/local/bin/</strong></span> 底下，這樣不用在重新把 PATH 改寫 

<pre class="brush: bash; title: ; notranslate" title="">sudo cp ~/bin/cpanm /usr/local/bin/</pre>

### 使用 cpanm

<pre class="brush: bash; title: ; notranslate" title=""># 安裝 WWW::Shorten::Bitly
cpanm WWW::Shorten::Bitly
# 安裝 distribution path
cpanm MIYAGAWA/Plack-0.99_05.tar.gz
# 從 URL 安裝
cpanm http://example.org/LDS/CGI.pm-3.20.tar.gz
# 安裝本機檔案
cpanm ~/dists/MyCompany-Enterprise-1.00.tar.gz</pre> 另外介紹幾個 option --sudo 直接用 sudo 方式安裝，也就是 root 啦 --verbose 檢查安裝過程 --notest 不需要測試 --force 強制安裝 --reinstall 重新安裝，假如已經有安裝過的軟體，一樣會 reinstall --installdeps 只安裝相依性軟體 非常簡單吧，這是懶人做法，如果在 

[FreeBSD][4] 直接安裝 [ports][5] 就好。

 [1]: http://www.perl.org/
 [2]: http://search.cpan.org/~pjain/WWW-Shorten-Bitly-1.14/lib/WWW/Shorten/Bitly.pm
 [3]: http://www.ubuntu.com/
 [4]: http://www.FreeBSD.org
 [5]: http://www.freebsd.org/ports/index.html