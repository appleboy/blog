---
title: 利用 freebsd-update 升級 FreeBSD security patch 安全性
author: appleboy
type: post
date: 2009-04-02T03:13:33+00:00
url: /2009/04/利用-freebsd-update-升級-freebsd-security-patch-安全性/
views:
  - 7862
bot_views:
  - 386
dsq_thread_id:
  - 246727593
categories:
  - FreeBSD
tags:
  - FreeBSD
  - security

---
在玩 [FreeBSD][1] 系統一定會常常需要升級 [security][2] 的 patch，之前寫過一篇手動升級 FreeBSD security patch：[FreeBSD 的 security patch 跟 如何 upgrade][3]，那篇寫的內容也很容易瞭解，那現在又有另一種升級方式，就是利用 FreeBSD 內建指令 [freebsd-update][4]，這是可以 fetch 或者是 install 和 rollback binary 升級系統，不過這指令只能用在 <span style="color: #ff0000;">Release Engineering</span> 的系統上面，例如 FreeBSD 7.1-RELEASE and FreeBSD 7.1-RC1，<span style="color: #ff0000;">不可以</span>使用在 FreeBSD 6.2-STABLE 或者是 FreeBSD 7.0-CURRENT 版本上面，那在 [DK大神 blog][5] 上面有寫一篇可以升級 PRERELEASE 系統：[用 freebsd-update 將 FreeBSD 7.1-PRERELEASE 升級到 7.1-RELEASE][6]，這方法可以騙過 freebsd-update 指令，不過我想本身要對 FreeBSD 很熟阿，不然會遇到很多地雷阿。 基本 OPTIONS 如下： 

<pre class="brush: bash; title: ; notranslate" title="">-b basedir   -- 指定系統掛載根目錄 預設值：/
                (default: /)
-d workdir   -- 檔案暫存的地方
                (default: /var/db/freebsd-update/)
-f conffile  -- 讀取基本設定檔
                (default: /etc/freebsd-update.conf)
-k KEY       -- Trust an RSA key with SHA256 hash of KEY
-r release   -- 指定 Release 版本 (e.g., 6.2-RELEASE)
-s server    -- 指定抓取哪一台伺服器
                (default: update.FreeBSD.org)
-t address   -- 搭配 corn 指定 email，當執行完畢，寄信通知使用者
                (default: root)</pre>

<!--more--> 基本 command 用法： 

<pre class="brush: bash; title: ; notranslate" title="">fetch：抓取可用的 binary update 檔案
cron：隨機休息 1～3600 秒數，當有指定 fetch 就會開始下載 binary 檔案，可以指定 -t 參數來達到下載好之後通知使用者
upgrade：搭配 -r 參數指定需要升級版本，如：7.1-RELEASE
rollback：可以反安裝最近升級的系統  </pre> 系統 freebsd-update fetch 畫面： 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3460/3405401581_d179ba1ace.jpg?resize=500%2C353&#038;ssl=1" title="FreeBSD_update_01 (by appleboy46)" alt="FreeBSD_update_01 (by appleboy46)" data-recalc-dims="1" />][7] 升級方式： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 先 fetch
#
freebsd-update fetch -r 7.1-RELEASE
#
# 升級安全性
#
freebsd-update install -r 7.1-RELEASE
#
# 升級好重新開機，就可以看到 uname -a
FreeBSD 7.1-RELEASE-p4 FreeBSD 7.1-RELEASE-p4 #2</pre> 後面 p4 代表 SA patch 次數，可以參考：

[FreeBSD-SA-09:06.ktimer][8]，裡面寫到： 

> Topic: Local privilege escalation Category: core Module: kern Announced: 2009-03-23 Affects: FreeBSD 7.x Corrected: 2009-03-23 00:00:50 UTC (RELENG\_7, 7.2-PRERELEASE) 2009-03-23 00:00:50 UTC (RELENG\_7\_1, 7.1-RELEASE-p4) 2009-03-23 00:00:50 UTC (RELENG\_7_0, 7.0-RELEASE-p11) CVE Name: CVE-2009-1041 表示 7.1-RELEASE 出來，第四次發布 patch，7.0-RELEASE 發布第11次。 可以利用 cron 放入 crontab 

<pre class="brush: bash; title: ; notranslate" title="">0  4  *  *  *  root    /usr/sbin/freebsd-update -t appleboy@XXXX.com cron</pre> 參考網站： 

[freebsd-update 擷取及安裝binary更新FreeBSD][9]

 [1]: http://www.freebsd.org
 [2]: http://www.freebsd.org/security/
 [3]: http://blog.wu-boy.com/2008/08/26/338/
 [4]: http://www.freshports.org/security/freebsd-update/
 [5]: http://blog.gslin.org/
 [6]: http://blog.gslin.org/archives/2009/03/24/1980/
 [7]: https://www.flickr.com/photos/appleboy/3405401581/ "FreeBSD_update_01 (by appleboy46)"
 [8]: http://security.freebsd.org/advisories/FreeBSD-SA-09:06.ktimer.asc
 [9]: http://ohaha.ks.edu.tw/post/1/32