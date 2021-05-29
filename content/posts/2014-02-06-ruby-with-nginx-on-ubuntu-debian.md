---
title: 在 Ubuntu 或 Debian 上跑 Ruby on Rails + Nginx
author: appleboy
type: post
date: 2014-02-06T14:58:14+00:00
url: /2014/02/ruby-with-nginx-on-ubuntu-debian/
dsq_thread_id:
  - 2229599687
categories:
  - Nginx
  - Ruby on Rails
tags:
  - Debian
  - nginx
  - Ruby
  - Ruby on Rails
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12343631243/" title="Ruby_logo by appleboy46, on Flickr"><img style="max-height:200px; " src="https://i2.wp.com/farm6.staticflickr.com/5492/12343631243_7bc052fa05.jpg?w=840&#038;ssl=1" alt="Ruby_logo" data-recalc-dims="1" /></a>
</div>

本篇用來紀錄學習 [Ruby on Rails][1] 所需要的開發環境，請不要輕易嘗試使用 Windows 當開發環境，因為真的很不好裝，又很難除錯，所以作者建議開發環境一定要有 Linux 機器，如果是個人電腦用 Mac 也沒這問題。用 Rails 可以快速開發 Web 搭配 MySQL 資料庫，完成後可以透過 [Capistrano][2] 工具幫助 Deploy 到 Production Server。底下會一一介紹如何在 Debian 機器上架設好 [Ruby][3] + [Nginx][4] 環境

<!--more-->

### 安裝 RVM

相信大家如果開發過 [Node.js][5] 一定聽過 [nvm][6] 這套 Node.js 版本管理工具，那 Ruby 呢，就是透過 [RVM][7] 來管理 Ruby 版本，安裝方式如下:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ aptitude install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config
$ \curl -sSL https://get.rvm.io | bash -s stable
# install 2.0.0 version and set default version
$ rvm install 2.0.0 --default</pre>
</div>

安裝好之後可以使用 rvm ls 來看看本地端裝了哪些版本

<div>
  <pre class="brush: bash; title: ; notranslate" title="">rvm rubies

=* ruby-2.0.0-p353 [ x86_64 ]
   ruby-2.1.0 [ x86_64 ]

# => - current
# =* - current && default
#  * - default</pre>
</div>

如果不需要 gem 安裝 rdoc 和 ri 可以透過底下設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ echo "gem: --no-ri --no-rdoc" > ~/.gemrc</pre>
</div>

最後安裝 `rails` 及 `bundler`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ gem i bundler rails</pre>
</div>

### 建立 Rails 專案

透過 `rails` 指令就可以快速初始化專案

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ cd /var/www
$ rails new web_01
$ cd web_01</pre>
</div>

如果搭配 [MySQL][8] 服務請務必安裝底下套件

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ aptitude install -y libmysqlclient-dev
$ gem install mysql2</pre>
</div>

這時候就可以修改 `config/database.yml` 資料庫連線資訊，並且在 `./Gemfile` 內容加入 `gem 'mysql2'`

### 安裝 Thin

Ruby 有好幾套伺服器在業界都非常多人用，像是 [Passenger][9], [Mongrel][10], [Thin][11], [Unicorn][12] 等，這次會介紹 Thin 安裝方式

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ gem install thin
$ thin install
$ /usr/sbin/update-rc.d -f thin defaults</pre>
</div>

完成上述設定後，系統會產生 `/etc/init.d/thin` 其實跟一般伺服器很像，設定檔都是放在 `/etc/thin` 目錄下，下面 command 用來產生各網站設定檔，假設有網站根目錄在 `/var/www/web_01`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">
# or: -e production for caching, etc
$ thin config -C /etc/thin/web_01 -c /var/www/web_01 --servers 3 -e development</pre>
</div>

打開 `/etc/thin/web_01`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">chdir: /var/www/web_01
environment: development
address: 0.0.0.0
port: 3000
timeout: 30
log: /root/log/thin.log
pid: tmp/pids/thin.pid
max_conns: 1024
max_persistent_conns: 100
require: []
wait: 30
threadpool_size: 20
servers: 3
daemonize: true</pre>
</div>

啟動 thin 伺服器

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/thin start</pre>
</div>

你可以看到跑了 3 個 port 分別是 `3000`, `3001`, `3002`。

### 安裝 Nginx

這是最後一步驟，只完成這項就大功告成，首先建立 nginx vhost 檔案 `/etc/nginx/sites-available/` 並且 link 到 `/etc/nginx/sites-enable/`，內容為

<div>
  <pre class="brush: bash; title: ; notranslate" title="">upstream web.localhost {
  server 127.0.0.1:3000;
  server 127.0.0.1:3001;
  server 127.0.0.1:3002;
}
server {
  listen   80;
  server_name web.localhost;

  access_log /var/www/web_01/log/access.log;
  error_log  /var/www/web_01/log/error.log;
  root     /var/www/web_01;
  index    index.html;

  location / {
    proxy_set_header  X-Real-IP  $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header  Host $http_host;
    proxy_redirect  off;
    try_files /system/maintenance.html $uri $uri/index.html $uri.html @ruby;
  }

  location @ruby {
    proxy_pass http://web.localhost;
  }
}</pre>
</div>

存檔後透過 link 啟動此設定

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ ln -nfs /etc/nginx/sites-available/web_01 /etc/nginx/sites-enabled/web_01</pre>
</div>

最後重新啟動全部伺服器

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/thin restart
$ /etc/init.d/nginx reload
$ /etc/init.d/nginx restart</pre>
</div>

打開瀏覽器鍵入 `http://web.localhost` 就可以成功看到網站了

 [1]: http://rubyonrails.org/
 [2]: https://github.com/capistrano/capistrano
 [3]: https://www.ruby-lang.org/en/
 [4]: http://nginx.org
 [5]: http://nodejs.org/
 [6]: https://github.com/creationix/nvm
 [7]: http://rvm.io/
 [8]: http://www.mysql.com/
 [9]: http://www.modrails.com/
 [10]: http://mongrel.rubyforge.org/
 [11]: http://code.macournoyer.com/thin/
 [12]: http://unicorn.bogomips.org/