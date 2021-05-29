---
title: 在 CentOS 上面安裝 Ruby 環境
author: appleboy
type: post
date: 2011-10-13T08:20:11+00:00
url: /2011/10/install-ruby-rubygems-compass-on-centos/
dsq_thread_id:
  - 441920076
categories:
  - Compass CSS Framework
  - CSS
  - Git
  - Linux
  - 版本控制
tags:
  - Centos
  - Compass
  - Fedora
  - git
  - Ruby
  - RubyGems

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6239698353/" title="centos by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6176/6239698353_3e6c99f692_o.png?resize=293%2C79&#038;ssl=1" alt="centos" data-recalc-dims="1" /></a>
</div> 目前開發網站都傾向於用 

<a href="http://compass-style.org" target="_blank">Compass</a> 這套 CSS Framework 來 develop，開發之前必須把環境先弄好，就是要有 <a href="http://www.ruby-lang.org/" target="_blank">Ruby</a> 套件才可以安裝 Compass，網路上的教學幾乎都在是 Ubuntu 底下用 apt-get 方式來安裝，其實相當方便，但是 <a href="http://fedoraproject.org/" target="_blank">Fedora</a> 或 <a href="http://www.centos.org/" target="_blank">CentOS</a> 就是要用 yum 方式來安裝，這次碰到 CentOS 竟然 yum search git 出來的結果是空的，所以決定全部都透過 tar 的方式來安裝全部套件了。由於 Fedora 幾乎都可以找到套件，但是碰到 <a href="http://rubygems.org/" target="_blank">rubygems</a> 需要用到 ruby 1.8.7 以上版本，所以還是乖乖的用 tar 方式吧。 大家可以試試看透過底下 yum 方式安裝: 

<pre class="brush: bash; title: ; notranslate" title="">yum install -y ruby ruby-devel rubygems</pre> 雖然 Fedora 透過上面可以安裝成功，可是 ruby 跟 rubygems 的版本根本是...太舊了吧 ... 

<!--more-->

### 安裝 git yum 方式: 

<pre class="brush: bash; title: ; notranslate" title="">yum install git</pre> 利用 tar 方式，先到 

<a href="http://code.google.com/p/git-core/downloads/list" target="_blank">git download 專區</a> 找到 1.7.7 版本 

<pre class="brush: bash; title: ; notranslate" title="">$ yum install curl-devel
$ wget http://git-core.googlecode.com/files/git-1.7.7.tar.gz
$ tar -zxvf git-1.7.7.tar.gz && cd git-1.7.7
$ ./configure
$ make && make install</pre>

### 安裝 Ruby 透過 yum 安裝好的 Ruby 版本太舊，乾脆直接衝

<a href="http://www.ruby-lang.org/zh_TW/downloads/" target="_blank">最新版</a> 

<pre class="brush: bash; title: ; notranslate" title="">$ wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-1.9.2-p0.tar.gz
$ tar -zxvf ruby-1.9.2-p0.tar.gz
$ cd ruby-1.9.2-p0
$ ./configure 
$ make && make install</pre> 安裝好打入 ruby -v 你會發現還是舊的版本，那是因為新版裝在 

**<span style="color:green">/usr/local/bin</span>** 底下，而 yum 方式安裝的會在 **<span style="color:green">/usr/bin</span>** 底下，所以改變一下 $PATH 變數順序即可 

<pre class="brush: bash; title: ; notranslate" title="">$ export PATH=/usr/local/bin:$PATH
$ ruby -v
ruby 1.9.2p0 (2010-08-18 revision 29036) [x86_64-linux]
</pre>

### 安裝 RubyGems 一樣到 

<a href="http://rubygems.org/" target="_blank">RubyGems</a> 下載最新版本 

<pre class="brush: bash; title: ; notranslate" title="">$ wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
$ unzip rubygems-1.8.10.tgz
$ tar -zxvf rubygems-1.8.10.tgz
$ cd rubygems-1.8.10
$ ruby setup.rb</pre> 接著可以透過 gem 來安裝 

<a href="http://compass-style.org/install/" target="_blank">Compass</a>。Windows 請參考之前寫的 <a href="http://blog.wu-boy.com/2011/10/install-compass-css-authoring-framework-on-windows/" target="_blank">在 Windows 底下安裝 Compass CSS Authoring Framework</a> 參考文章: <a href="http://www.liumin.name/20090406/installing-git-on-centos-5/" target="_blank">在CentOS 5上安裝Git</a>