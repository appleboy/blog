---
title: '[FreeBSD] 簡易架設 git Server，git 使用教學'
author: appleboy
type: post
date: 2009-10-05T06:18:51+00:00
url: /2009/10/freebsd-簡易架設-git-server，git-使用教學/
views:
  - 16464
bot_views:
  - 888
dsq_thread_id:
  - 246722267
categories:
  - FreeBSD
  - Git
tags:
  - FreeBSD
  - git
  - 版本控制

---
[Git][1] 是一套免費 open source 的版本控制軟體，另外還有很多套版本控制軟體，如：[Mercurial][2], [Bazaar][3], [Subversion][4], [CVS][5], [Perforce][6], and [Visual SourceSafe][7]，其中 Mercurial 又是 [Google Code Project Hosting 採用的版本控制系統][8]，當然 google 也支援原本的 [Subversion][4]，Git 為現在很紅的一套版本控制 Software，底下紀錄在 [FreeBSD][9] 如何架設簡易 Git Server。 1. 利用 FreeBSD ports 安裝： 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/devel/git; make install clean</pre> 2. 修改 /etc/rc.conf 

<pre class="brush: bash; title: ; notranslate" title="">git_daemon_enable="YES"
git_daemon_directory="/path/git/repo"
git_daemon_flags="--export-all --syslog --enable=receive-pack --listen=192.168.1.1"</pre> 注意 git\_daemon\_flags 可以加入 --verbose 參數，以方便 debug 3. 新增使用者 git 

<pre class="brush: bash; title: ; notranslate" title="">pw user add git</pre> 4. 啟動 git daemon 

<pre class="brush: bash; title: ; notranslate" title="">/usr/local/etc/rc.d/git_daemon start</pre> 您會發現多出 9418 連接埠，就是成功了 

<!--more--> 架設好之後，接下來就是測試看看，順便利用 Git 建立 Local Repository，剛開始的目錄 /path/git/repo 裡面是沒有任何一個 Repository，我們可以利用下面指令建立： 

<pre class="brush: bash; title: ; notranslate" title="">mkdir /path/git/repo/php.git
cd /path/git/repo/php.git
git --bare init</pre> 第一次 Commit to Remote Repository，需要底下不走完成，才可以 clone，你在本機或者是其他機器使用下面步驟都是可以的 

<pre class="brush: bash; title: ; notranslate" title="">mkdir php.git
cd php.git
git init
touch README
git add README
git commit -m 'first commit'
git remote add origin git@REMOTE_SERVER:/path/git/repo/php.git
git push origin master</pre> 建立好之後，測試看看，Git clone 資料, 資料修改後上傳.(分兩個目錄測試) 

<pre class="brush: bash; title: ; notranslate" title=""># 建立兩個測試目錄
mkdir /tmp/a /tmp/b
# 切換到 a 目錄
cd /tmp/a
# 先把遠端 repo 抓下來
git clone http://example.com/path/git/repo/php.git
cd /tmp/b
git clone http://example.com/path/git/repo/php.git
cd php
# 增加 test.php 檔案
echo "test" > test.php
# 新增到 server
git add test.php
# 送出 commit 
git commit -m "add test.php"
# push 到伺服器
git push 
#切換 a 目錄
cd /tmp/a/php
# 抓取伺服器上面新檔案 test.php
git pull </pre> 參考網站： 

<http://blog.commonthread.com/2008/4/14/setting-up-a-git-server> <http://www.wretch.cc/blog/michaeloil/22286355> <http://plog.longwin.com.tw/my_note-unix/2009/05/20/git-learn-test-command-2009>

 [1]: http://git-scm.com/
 [2]: http://mercurial.selenic.com/wiki/
 [3]: http://bazaar-vcs.org/
 [4]: http://subversion.tigris.org/
 [5]: http://www.nongnu.org/cvs/
 [6]: http://www.perforce.com/
 [7]: http://msdn.microsoft.com/en-us/vstudio/aa718670.aspx
 [8]: http://googlecode.blogspot.com/2009/04/mercurial-support-for-project-hosting.html
 [9]: http://www.freebsd.org/