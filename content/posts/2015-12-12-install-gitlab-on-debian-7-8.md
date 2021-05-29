---
title: 在 Debian 7.8 安裝 Gitlab 筆記
author: appleboy
type: post
date: 2015-12-12T09:22:02+00:00
url: /2015/12/install-gitlab-on-debian-7-8/
dsq_thread_id:
  - 4397202181
categories:
  - Git
  - Git
  - 版本控制
tags:
  - Debian
  - Docker
  - git
  - GitLab
  - Jenkins

---
<img src="https://i2.wp.com/farm4.staticflickr.com/3830/10605193576_54b54e4dfc_n.jpg?w=840&#038;ssl=1" alt="gitlab_logo" data-recalc-dims="1" />

之前寫過一篇 [GitLab 快速安裝筆記][1]，但是這次在 Debian 7.8 上安裝起來遇到蠻多問題，故寫此篇來記錄安裝遇到的問題，也會寫到如何搭配 Nginx 設定。GitLab 分兩種版本，一種是 Community Edition packages 另一種是 Enterprise Edition packages，本篇是記錄 Community 版本安裝步驟，可以到[下載頁面][2]選擇您的作業系統，就可以看到安裝方式

<!--more-->

```bash
$ curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
$ sudo apt-get install gitlab-ce
```

完成後，請直接透過底下指令重新啟動服務

```bash
$ gitlab-ctl reconfigure
```

下一步驟就是透過帳號 `root` 及密碼 `5iveL!` 登入 Gitlab，這時候你會發現為什麼都無法登入，後來找了很久，原來安裝完後，資料庫預設是空的，所以需要搭配底下指令來初始化資料庫

```bash
$ gitlab-rake gitlab:setup RAILS_ENV=production
```

接著打開 `/etc/gitlab/gitlab.rb` 修改 `external_url` 設定

```bash
## Url on which GitLab will be reachable.
## For more details on configuring external_url see:
## https://gitlab.com/gitlab-org/omnibus-gitlab/blob/629def0a7a26e7c2326566f0758d4a27857b52a3/README.md#configuring-the-external-url-for-gitlab
external_url 'http://localhost:8088'
```

後面的 8088 port 就是 Gitlab 內建的 Nginx port，可以任意改成其他 port，不要設定為 80 就好，這樣會噴 port 已經被佔用的錯誤。到這邊打開 `<a href="https://localhost:8088">https://localhost:8088</a>` 就可以看到登入畫面了

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23062631624/in/dateposted-public/" title="Screen Shot 2015-12-12 at 2.14.41 PM"><img src="https://i2.wp.com/farm6.staticflickr.com/5734/23062631624_11fc40a3dc_z.jpg?resize=640%2C550&#038;ssl=1" alt="Screen Shot 2015-12-12 at 2.14.41 PM" data-recalc-dims="1" /></a>

安裝過程請多開一個 Terminal 視窗來監控 Log 狀態

```bash
$ gitlab-ctl tail
```

### 跟 github 整合帳號

請先申請 Github 帳號，點選右上角個人頭像內的 Settings，接著點選左邊 Applications

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23323067689/in/dateposted-public/" title="Screen Shot 2015-12-12 at 2.30.16 PM"><img src="https://i0.wp.com/farm6.staticflickr.com/5675/23323067689_a8e437d2be_z.jpg?resize=640%2C389&#038;ssl=1" alt="Screen Shot 2015-12-12 at 2.30.16 PM" data-recalc-dims="1" /></a>

把上述資料填寫完成後，按下送出就可以拿到 Client ID 及 Client Secret 接著到 `/etc/gitlab/gitlab.rb` 把 Github 相關設定檔打開

```bash
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = false
gitlab_rails['omniauth_block_auto_created_users'] = true
gitlab_rails['omniauth_providers'] = [
    {
      "name" => "github",
      "app_id" => "xxxxxxxx",
      "app_secret" => "xxxxxxxxxxx",
      "url" => "https://github.com/",
      "args" => { "scope" => "user:email" }
    }
]
```

重新啟動 `gitlab-ctl reconfigure`，這樣就完成了，更詳細的步驟可以參考 [Integrate your server with GitHub][3]，但是這不代表你可以不用註冊帳號，用第三方帳號註冊，GitLab 還是要你先註冊帳號，然後到帳戶設定內，把 `Connected Accounts` 內的 Github 啟動，這樣才可以用 Github 帳號登入

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23323178639/in/dateposted-public/" title="Screen Shot 2015-12-12 at 2.37.32 PM"><img src="https://i0.wp.com/farm6.staticflickr.com/5819/23323178639_65dab7e6fe_z.jpg?resize=640%2C345&#038;ssl=1" alt="Screen Shot 2015-12-12 at 2.37.32 PM" data-recalc-dims="1" /></a>

GitLab 也支援多個 open source project 平台的匯入功能，像是可以將 Github Project 匯入

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23666550016/in/dateposted-public/" title="Screen Shot 2015-12-12 at 4.25.14 PM"><img src="https://i2.wp.com/farm6.staticflickr.com/5814/23666550016_2606ecfbbd_z.jpg?resize=640%2C360&#038;ssl=1" alt="Screen Shot 2015-12-12 at 4.25.14 PM" data-recalc-dims="1" /></a>

### 整合 Nginx

Gitlab 內建 Nginx 服務，但是通常都會用自己架設的 Nginx，尤其是我比較喜歡裝 Nginx mainline 的版本，這樣才可以用 [Http2][4]。一樣先打開 `/etc/gitlab/gitlab.rb`，修改底下設定

```bash
nginx['enable'] = false
gitlab_workhorse['enable'] = true
gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "localhost:8181"
unicorn['listen'] = '127.0.0.1'
unicorn['port'] = 10080
```

注意將內建的 Nginx 關閉，在 8.2 版本的時候，官方已經將 `gitlab_git_http_server` 換成 `gitlab_workhorse`，所以網路上看到的教學文件記得要過濾，GitLab 必須要開啟 unicorn 及 workhorse 服務，才可以跟 Nginx 串接，底下是 Nginx 完整設定檔

```bash

upstream gitlab {
  server 127.0.0.1:10080 fail_timeout=0;
}

upstream gitlab-git-http-server {
  server 127.0.0.1:8181 fail_timeout=0;
}

# let gitlab deal with the redirection
server {
  listen 0.0.0.0:80;
  server_name gitlab.wu-boy.com;
  server_tokens off;
  root /opt/gitlab/embedded/service/gitlab-rails/public;

  # include ssl config
  include ssl/gitlab.conf;

  # Increase this if you want to upload larger attachments
  client_max_body_size      20m;

  # individual nginx logs for this vhost
  access_log                /var/log/nginx/gitlab_access.log;
  error_log                 /var/log/nginx/gitlab_error.log;

  # Increase this if you want to upload larger attachments
  client_max_body_size      20m;

  ## Individual nginx logs for this GitLab vhost
  access_log  /var/log/nginx/gitlab_access.log;
  error_log   /var/log/nginx/gitlab_error.log;

  location / {
    ## Serve static files from defined root folder.
    ## @gitlab is a named location for the upstream fallback, see below.
    try_files $uri $uri/index.html $uri.html @gitlab;
  }

  ## We route uploads through GitLab to prevent XSS and enforce access control.
  location /uploads/ {
    ## If you use HTTPS make sure you disable gzip compression
    ## to be safe against BREACH attack.
    gzip off;

    ## https://github.com/gitlabhq/gitlabhq/issues/694
    ## Some requests take more than 30 seconds.
    proxy_read_timeout      300;
    proxy_connect_timeout   300;
    proxy_redirect          off;

    proxy_set_header    Host                $http_host;
    proxy_set_header    X-Real-IP           $remote_addr;
    proxy_set_header    X-Forwarded-Ssl     on;
    proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
    proxy_set_header    X-Forwarded-Proto   $scheme;
    proxy_set_header    X-Frame-Options     SAMEORIGIN;

    proxy_pass http://gitlab;
  }

  ## If a file, which is not found in the root folder is requested,
  ## then the proxy passes the request to the upsteam (gitlab unicorn).
  location @gitlab {
    ## If you use HTTPS make sure you disable gzip compression
    ## to be safe against BREACH attack.
    gzip off;

    ## https://github.com/gitlabhq/gitlabhq/issues/694
    ## Some requests take more than 30 seconds.
    proxy_read_timeout      300;
    proxy_connect_timeout   300;
    proxy_redirect          off;

    proxy_set_header    Host                $http_host;
    proxy_set_header    X-Real-IP           $remote_addr;
    proxy_set_header    X-Forwarded-Ssl     on;
    proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
    proxy_set_header    X-Forwarded-Proto   $scheme;
    proxy_set_header    X-Frame-Options     SAMEORIGIN;

    proxy_pass http://gitlab;
  }

  location ~ [-\/\w\.]+\.git\/ {
    ## If you use HTTPS make sure you disable gzip compression
    ## to be safe against BREACH attack.
    gzip off;

    ## https://github.com/gitlabhq/gitlabhq/issues/694
    ## Some requests take more than 30 seconds.
    proxy_read_timeout      300;
    proxy_connect_timeout   300;
    proxy_redirect          off;

    # Do not buffer Git HTTP responses
    proxy_buffering off;

    # The following settings only work with NGINX 1.7.11 or newer
    #
    # # Pass chunked request bodies to gitlab-git-http-server as-is
    # proxy_request_buffering off;
    # proxy_http_version 1.1;

    proxy_set_header    Host                $http_host;
    proxy_set_header    X-Real-IP           $remote_addr;
    proxy_set_header    X-Forwarded-Ssl     on;
    proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
    proxy_set_header    X-Forwarded-Proto   $scheme;
    proxy_pass http://gitlab-git-http-server;
  }

  ## Enable gzip compression as per rails guide:
  ## http://guides.rubyonrails.org/asset_pipeline.html#gzip-compression
  ## WARNING: If you are using relative urls remove the block below
  ## See config/application.rb under "Relative url support" for the list of
  ## other files that need to be changed for relative url support
  location ~ ^/(assets)/ {
    root /opt/gitlab/embedded/service/gitlab-rails/public;
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  error_page 502 /502.html;
}
```

如果沒設定 gitlab-git-http-server，這樣 Client 端使用 git clone <http://xxx> 時就會跳出底下訊息。如果要設定 `https` 可以參考 [gitlab.conf][5]

```bash
Fetching changes...
Checking out dbed0c03 as master...
fatal: reference is not a tree: <ssha hash>
```

### Gitlab multiple runner

Gitlab 可以建立 Project 專屬的 CI Runner，請到 Project 內的左邊選單，點選 `Settings` 接著會看到左邊選單有 Runner 進去後可以看到底下畫面

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23610441491/in/dateposted-public/" title="Screen Shot 2015-12-12 at 4.43.49 PM"><img src="https://i0.wp.com/farm1.staticflickr.com/677/23610441491_27100e8e6d_z.jpg?resize=640%2C246&#038;ssl=1" alt="Screen Shot 2015-12-12 at 4.43.49 PM" data-recalc-dims="1" /></a>

中間有 Token 是要讓你建立 Runner 的時候使用，接著在機器內裝 gitlab multiple runner 套件

```bash
$ aptitude install gitlab-ci-multi-runner
```

最後執行 `gitlab-ci-multi-runner register`

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23065932903/in/dateposted-public/" title="Screen Shot 2015-12-12 at 4.50.11 PM"><img src="https://i0.wp.com/farm1.staticflickr.com/635/23065932903_e4a9950c21_z.jpg?resize=640%2C413&#038;ssl=1" alt="Screen Shot 2015-12-12 at 4.50.11 PM" data-recalc-dims="1" /></a>

可以發現 gitlab 支援 Docker build 及基本的 shell command。完成後，請在專案底下建立 `.gitlab-ci.yml` 檔案，寫入測試步驟即可

```bash

before_script:
  - nvm install 4

stages:
  - build
  - test

build:
  stage: build
  script:
    - npm install

test:
  stage: test
  script:
    - npm test
```

[<img src="https://i0.wp.com/farm1.staticflickr.com/608/23693388065_8872802ea0_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2015-12-12 at 5.20.54 PM" data-recalc-dims="1" />][6]

## 結論

我建議如果要串 CI Server，還是推薦使用 [Jenkins][7]，功能實在差太多了，Gitlab + Jenkins 還是比較妥當，由於 Gitlab CI 現在已經是內建的了，如果是一些單純的流程，還是可以用 Gitlab CI 喔。如果有在用 [Docker][8] 請直接參考這篇 [使用 Docker 建置 Gitlab CE 的 Source Control 及 CI 環境][9]

## 參考資料

  * [CI unable to clone with HTTP 502][10]
  * [Run gitlab-runner in a container][11]
  * [gitlab overriding nginx config files.][12]
  * [Cannot clone projects via HTTP][13]
  * [Omnibus GitLab][14]
  * [Configuration of your builds with .gitlab-ci.yml][15]

 [1]: http://blog.wu-boy.com/2014/12/easy-to-install-gitlab-quickly/
 [2]: https://about.gitlab.com/downloads/
 [3]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/integration/github.md
 [4]: https://en.wikipedia.org/wiki/HTTP/2
 [5]: https://github.com/appleboy/server-configs/blob/master/nginx/sites-available/gitlab.conf
 [6]: https://www.flickr.com/photos/appleboy/23693388065/in/dateposted-public/ "Screen Shot 2015-12-12 at 5.20.54 PM"
 [7]: https://jenkins-ci.org/
 [8]: https://www.docker.com/
 [9]: http://notes.jigsawye.com/2015/09/25/gitlab-ce-in-docker
 [10]: https://gitlab.com/gitlab-org/gitlab-ce/issues/2682
 [11]: https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/docker.md
 [12]: https://gitlab.com/gitlab-org/omnibus-gitlab/issues/516
 [13]: https://gitlab.com/gitlab-org/gitlab-ce/issues/2669
 [14]: https://gitlab.com/gitlab-org/omnibus-gitlab/blob/629def0a7a26e7c2326566f0758d4a27857b52a3/README.md
 [15]: http://doc.gitlab.com/ce/ci/yaml/README.html