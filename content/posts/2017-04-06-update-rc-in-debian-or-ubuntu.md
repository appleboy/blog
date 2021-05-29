---
title: Debian/Ubuntu 的 update-rc.d 使用教學
author: appleboy
type: post
date: 2017-04-06T08:34:14+00:00
url: /2017/04/update-rc-in-debian-or-ubuntu/
dsq_thread_id:
  - 5700526182
categories:
  - Debian
  - DevOps
  - Golang
  - Ubuntu
tags:
  - Debian
  - golang
  - Ubuntu

---
[<img src="https://i2.wp.com/c1.staticflickr.com/3/2849/33486150390_198a19b880_n.jpg?w=840&#038;ssl=1" alt="Debian" data-recalc-dims="1" />][1]

[update-rc.d][2] 是在 [Debian][3] 或 [Ubuntu][4] 內用來管理 `/etc/init.d` 目錄內的 scripts 工具。不管是 Nginx 或 Mysql 等相關服務，都可以在 `/etc/init.d` 目錄內找到相對應的 script 檔案，隨便打開一個 script 檔案就可以看到標頭有固定的格式寫法:

<pre><code class="language-bash">### BEGIN INIT INFO
# Provides:          gorush
# Required-Start:    $syslog $network
# Required-Stop:     $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the gorush web server
# Description:       starts gorush using start-stop-daemon
### END INIT INFO</code></pre>

<!--more-->

從上面格式可以看到預設啟動模式可以在 `2 3 4 5` 其餘的 `0 1 6` 則是關閉，這邊基本上可以不用動它，詳細的寫法可以直接參考 `/etc/init.d/skeleton` 檔案，或者是直接複製修改即可。由於筆者都在寫 [Go 語言][5]，包成二進制執行檔後，就必須靠 update-rc.d 產生相對應的 scripts。

  * 0 關機模式
  * 1 單機使用
  * 6 重新開機

## 使用方式

在 `/etc/init.d` 目錄下寫好 script 後，可以用 `update-rc.d` 自動在 `/etc/rcX` 產生 link 檔案，請直接使用底下指令

<pre><code class="language-bash">$ update-rc.d gorush default 20</code></pre>

如果執行上述指令遇到底下錯誤:

> update-rc.d: warning: start runlevel arguments (none) do not match gorush Default-Start values (2 3 4 5) update-rc.d: warning: stop runlevel arguments (none) do not match gorush Default-Stop values (0 1 6)

請直接將指令改成

<pre><code class="language-bash">$ update-rc.d gorush start 20 2 3 4 5 . stop 80 0 1 6 .</code></pre>

如果您的服務必須先將 Mysql 啟動，有兩種方式解決這問題，第一種是透過 update-rc.d 修改起動順序:

<pre><code class="language-bash">$ update-rc.d mysqld defaults 80 20
$ update-rc.d gorush defaults 90 10</code></pre>

上面就是代表啟動時，先啟動 mysqld 後啟動 gorush，關機時，先停止 gorush 後停止 mysqld。個人不推薦使用這方法，另一個方式就是調整 script 標頭內容

<pre><code class="language-diff">- # Required-Start:    $syslog $network
+ # Required-Start:    $mysqld $syslog $network</code></pre>

這樣就可以確保執行 gorush 前，MySQL 服務已經先啟動了。

 [1]: https://www.flickr.com/photos/appleboy/33486150390/in/dateposted-public "Debian"
 [2]: http://manpages.ubuntu.com/manpages/precise/man8/update-rc.d.8.html
 [3]: https://www.debian.org/
 [4]: https://www.ubuntu.com/
 [5]: https://golang.org