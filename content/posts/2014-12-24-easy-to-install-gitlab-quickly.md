---
title: GitLab 快速安裝
author: appleboy
type: post
date: 2014-12-24T08:12:25+00:00
url: /2014/12/easy-to-install-gitlab-quickly/
dsq_thread_id:
  - 3355113790
dsq_needs_sync:
  - 1
categories:
  - Git
tags:
  - Digital Ocean
  - git
  - GitLab

---
[<img src="https://i2.wp.com/farm4.staticflickr.com/3830/10605193576_54b54e4dfc_n.jpg?resize=320%2C206&#038;ssl=1" alt="gitlab_logo" data-recalc-dims="1" />][1]

最近想安裝新版的 [GitLab][2]，竟然發現 GitLab 推出[快速懶人包][3]，終於可以不用打很多指令來安裝了，大幅降低了安裝困難度，目前支援 [CentOS][4], [Ubutnu][5], [Debian][6] 等安裝包，GitLab 各版本也可以從[這邊列表][7]找到，另外安裝前請確保你的硬體環境是符合 [GitLab 所要求][8]，來看看有沒有這麼簡單安裝。

<!--more-->

# 安裝方式

底下是 Debian 7 安裝方式

```bash
wget https://downloads-packages.s3.amazonaws.com/debian-7.7/gitlab_7.6.1-omnibus.5.3.0.ci-1_amd64.deb
sudo apt-get install openssh-server
sudo apt-get install postfix # Select 'Internet Site', using sendmail instead also works, exim has problems
sudo dpkg -i gitlab_7.6.1-omnibus.5.3.0.ci-1_amd64.deb
```

完成後，你會看到畫面要求您執行 `gitlab-ctl reconfigure` 來啟動所有服務，檢查服務是否都正常啟動可以透過 `gitlab-ctl status` 看到底下就代表啟動成功

```bash

run: logrotate: (pid 29315) 2180s; run: log: (pid 25339) 2699s
run: nginx: (pid 29886) 2148s; run: log: (pid 25324) 2701s
run: postgresql: (pid 29334) 2179s; run: log: (pid 16414) 3353s
run: redis: (pid 29342) 2179s; run: log: (pid 16313) 3360s
run: sidekiq: (pid 2542) 1282s; run: log: (pid 25303) 2703s
run: unicorn: (pid 2598) 1279s; run: log: (pid 25278) 2704s
```

如果系統本身有安裝 [Nginx][4]，請將 GitLab 預設 80 port 改掉，請修改 `/etc/gitlab/gitlab.rb` 設定檔，找到底下

```bash
nginx['redirect_http_to_https_port'] = 80
```

修改成

```bash
nginx['redirect_http_to_https_port'] = 8088
```

儲存設定檔後，請重新跑 `gitlab-ctl reconfigure` 即可，另外對外網址也請設定正確 `external_url`。另外官方也有寫出 Digital Ocean 也直接推出 [One-click install and deploy GitLab][9]，一個月才 10 美金，真是太超過了。

 [1]: https://www.flickr.com/photos/appleboy/10605193576/ "gitlab_logo by appleboy46, on Flickr"
 [2]: https://about.gitlab.com/
 [3]: https://about.gitlab.com/downloads/
 [4]: http://nginx.org/
 [5]: http://www.ubuntu.com/
 [6]: https://www.debian.org/
 [7]: https://about.gitlab.com/downloads/archives/
 [8]: http://doc.gitlab.com/ce/install/requirements.html
 [9]: https://www.digitalocean.com/features/one-click-apps/gitlab/