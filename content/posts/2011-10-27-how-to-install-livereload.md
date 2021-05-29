---
title: LiveReload 網頁程式設計師必備工具
author: appleboy
type: post
date: 2011-10-27T09:55:48+00:00
url: /2011/10/how-to-install-livereload/
dsq_thread_id:
  - 454377171
categories:
  - CSS
  - FreeBSD
tags:
  - CSS
  - LiveReload
  - Ruby

---
如果讀者目前從事的工作跟 Web Develop 相關，相信每天在按 Ctrl + R 的次數至少在上百次吧，也許花在這上面的時間會真的很煩，有沒有想過如果每次修改 html php css s[ca]ss js 檔案後，網頁會自動幫忙 reload 呢，這樣就可以另外買個螢幕把網頁拉過去，修改好檔案，螢幕就會幫忙重新整理，大家省下這些時間就可以專心寫 Code 了啦，解決此問題非常容易，那就是裝上 <a href="https://github.com/mockko/livereload" target="_blank">livereload</a> 這套 <a href="http://rubygems.org/" target="_blank">rubygem</a> 程式，底下先看看 livereload 影片: <!--more--> 底下會簡單介紹 Ubuntu 及 FreeBSD 的安裝方法，其實在

<a href="https://github.com/mockko/livereload#readme" target="_blank">官網 README</a> 都寫的蠻清楚。 

### Linux 安裝方式 用 apt-get 指令安裝 

<pre class="brush: bash; title: ; notranslate" title="">$ sudo gem install rb-inotify livereload</pre>

### FreeBSD 安裝方式 原本我也是打算用 gem 方式安裝，不過安裝好之後噴出底下錯誤訊息 

<pre class="brush: bash; title: ; notranslate" title="">/usr/local/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:36:in `gem_original_require': no such file to load -- em-dir-watcher/platform/nix (LoadError)
        from /usr/local/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:36:in `require'
        from /usr/local/lib/ruby/gems/1.8/gems/em-dir-watcher-0.9.4/lib/em-dir-watcher.rb:16
        from /usr/local/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:36:in `gem_original_require'
        from /usr/local/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:36:in `require'
        from /usr/local/lib/ruby/gems/1.8/gems/livereload-1.6/bin/../lib/livereload.rb:2
        from /usr/local/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:55:in `gem_original_require'
        from /usr/local/lib/ruby/site_ruby/1.8/rubygems/custom_require.rb:55:in `require'
        from /usr/local/lib/ruby/gems/1.8/gems/livereload-1.6/bin/livereload:3
        from /usr/local/bin/livereload:19:in `load'
        from /usr/local/bin/livereload:19</pre> 會出現這錯誤訊息的原因是在 Ruby 偵測 OS 的時候出現問題 

<pre class="brush: ruby; title: ; notranslate" title="">module EMDirWatcher
    PLATFORM = ENV['EM_DIR_WATCHER_PLATFORM'] ||
        case Config::CONFIG['target_os']
            when /mswin|mingw/ then 'Windows'
            when /darwin/      then 'Mac'
            when /linux/       then 'Linux'
            else                    'Nix'
        end
end</pre> 在 

<a href="http://www.freebsd.org" target="_blank">FreeBSD</a> 底下 Config::CONFIG['target_os'] 會顯示 FreeBSD 字眼，所以此變數就會被設定到 Nix 然後就炸開了，為了解決這個雷，請另外安裝 **<span style="color:green">sysutils/rubygem-guard-livereload</span>** port，透過底下指令來執行 LiveReload # 初始化設定 guard init livereload 此指令會在目錄底下產生 Guardfile 檔案，內容是 

<pre class="brush: bash; title: ; notranslate" title=""># A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{.+\.(css|js|html)})
  watch(%r{(.+\.css)\.s[ac]ss}) { |m| m[1] }
  watch(%r{(.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end</pre> 可以看到 LiveReload 會偵測 css js html s[ac]ss 

<a href="http://jashkenas.github.com/coffee-script/" target="_blank">coffee script</a> 都可以。此步驟是用在 FreeBSD 機器，如果是 Linux 請參考以下步驟 

### LiveReload 使用 經過上面步驟安裝 LiveReload 後，接著來介紹如何在 Server 端使用 LiveReload，這指令會在 Server 端開啟一個 port 好讓 Client 端連接上，底下是建立方法。 

<pre class="brush: bash; title: ; notranslate" title=""># livereload 目錄
livereload /path</pre> livereload 預設會 listen 0.0.0.0 address 及 tcp port 35729，如果要更改這兩項設定，請更改 option 設定 

<pre class="brush: bash; title: ; notranslate" title="">livereload --address [ADDRESS] --port [PORT]</pre> 執行後會吐出下面訊息 

<pre class="brush: bash; title: ; notranslate" title="">Version:  1.6  (compatible with browser extension versions 1.6.x)
Port:     35729
Watching: /var/www/html/Client
  - extensions: .html .css .js .png .gif .jpg .php .php5 .py .rb .erb
  - live refreshing disabled for .js: will reload the whole page when .js is changed
  - excluding changes in: */.git/* */.svn/* */.hg/*
  - with a grace period of 0.05 sec after each change

LiveReload is waiting for browser to connect.</pre> 以及會在目錄底下產生 .livereload 隱藏檔，檔案內容可以針對不想要偵測哪些檔案或者是目錄分別做設定，相當方便，此原理是偵測 server 端修改檔案，透過 web socket 通知 client browser reload 網頁，解決掉手動 reload 網頁時間，同時也支援 server side language: 

<a href="http://www.PHP.net" target="_blank">PHP</a> , <a href="http://compass-style.org/" target="_blank">Compass</a> <a href="http://sass-lang.com/" target="_blank">SASS</a> <a href="http://lesscss.org/" target="_blank">Less.js</a> …等。 

### Client 端安裝 至於 Web Browser 就是安裝 Plugin，且設定 Web Host 及 port 就可以連接上了，目前官方提供了 FireFox, Safari, Google Chrome 等三者瀏覽器 plugin 

  * <a href="https://addons.mozilla.org/firefox/addon/livereload/" target="_blank">Firefox 4 extension</a>
  * <a href="https://github.com/downloads/mockko/livereload/LiveReload-1.6.2.safariextz" target="_blank">Safari extension</a>
  * <a href="https://chrome.google.com/extensions/detail/jnihajbhpnppcggbcgedagnkighmdlei" target="_blank">Google Chrome extension</a> 如果讀者環境是 Windows，請參考

<a href="http://www.jaceju.net/blog/" target="_blank">鐵兄</a>的網誌 <a href="http://www.jaceju.net/blog/archives/1795" target="_blank">在 Windows 下使用 LiveReload</a>，另外也可以參考 <a href="http://blog.xdite.net/" target="_blank">XDite</a> 大大寫的 <a href="http://wp.xdite.net/?p=1791" target="_blank">LiveReload：你的套版好幫手！</a>