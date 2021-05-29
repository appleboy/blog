---
title: Ruby 安裝 debugger package 發生 No source for ruby 錯誤
author: appleboy
type: post
date: 2014-02-27T03:22:11+00:00
url: /2014/02/ruby-debugger-and-no-source-for-ruby-error/
dsq_thread_id:
  - 2327909433
categories:
  - Ruby on Rails
tags:
  - Ruby
  - Ruby on Rails
  - RubyGems

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12343631243/" title="Ruby_logo by appleboy46, on Flickr"><img style="max-height:200px; " src="https://i2.wp.com/farm6.staticflickr.com/5492/12343631243_7bc052fa05.jpg?w=840&#038;ssl=1" alt="Ruby_logo" data-recalc-dims="1" /></a>
</div>

當您在特定 [Ruby][1] 版本下安裝 [debugger gem][2] 套件，會碰到底下錯誤訊息

<div>
  <pre class="brush: bash; title: ; notranslate" title="">Using debugger-ruby_core_source (1.2.4) 
Installing debugger-linecache (1.2.4) with native extensions 
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native
extension.

checking for vm_core.h... no
checking for vm_core.h... no
Makefile creation failed
**************************************************************************
No source for ruby-2.0.0-p451 provided with debugger-ruby_core_source
gem.
**************************************************************************</pre>
</div>

會發生此錯誤的最大原因是在 `debugger-ruby_core_source` 原始碼內，只有包含特定少數的 Headers，解決此錯誤也非常簡單，可以直接將目前的 ruby 版本 headers 安裝到 `debugger-ruby_core_source` 目錄內即可，透國 rake 就可以完成

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ cd /usr/local/rvm/gems/ruby-2.0.0-p451/gems/debugger-ruby_core_source-1.2.4/lib/debugger/ruby_core_source
$ rake add_source VERSION=2.0.0-p451 --trace</pre>
</div>

執行完成後，就可以回到原專案目錄透過 `bundle install` 繼續安裝套件。

 [1]: https://www.ruby-lang.org/en/
 [2]: https://rubygems.org/gems/debugger