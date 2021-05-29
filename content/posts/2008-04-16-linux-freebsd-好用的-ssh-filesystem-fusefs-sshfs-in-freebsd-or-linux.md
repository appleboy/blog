---
title: '[SSHFS] 好用的 SSH Filesystem fusefs-sshfs in FreeBSD or Linux'
author: appleboy
type: post
date: 2008-04-15T21:02:59+00:00
url: /2008/04/linux-freebsd-好用的-ssh-filesystem-fusefs-sshfs-in-freebsd-or-linux/
views:
  - 4271
bot_views:
  - 676
dsq_thread_id:
  - 246900712
categories:
  - FreeBSD
  - Linux
  - Ubuntu
tags:
  - FreeBSD
  - fusefs
  - Linux
  - SSH
  - sshfs

---
今天在 [ptt][1] [Linux][2] 連線版文章看到有人問說，如何傳一檔案到其他的 linux 機器，有人推了一個軟體，我覺得相當不錯，就拿來玩看看了，這軟體就是 [sshfs][3] 這是一套可以直接掛載遠端機器目錄的軟體，走 ssh 協定，剛剛安裝了一下，發覺還蠻好用的，我在 [Linux][2] 跟 [FreeBSD][4] 上面都安裝好了，來紀錄一下步驟。 首先是安裝步驟 For FreeBSD，直接利用 ports 安裝即可： 

<pre class="brush: bash; title: ; notranslate" title="">#
# ports 安裝
#
# Port:   fusefs-sshfs-1.8
# Path:   /usr/ports/sysutils/fusefs-sshfs
# Info:   Mount remote directories over ssh
# Maint:  amistry@am-productions.biz
# pkg-config-0.22_1
# WWW:    http://sourceforge.net/projects/fuse/

cd /usr/ports/sysutils/fusefs-sshfs; make install clean
</pre>

<!--more--> 裝好之後，相關的軟體也會被安裝進來 

> fusefs-kmod-0.3.9.p1.20080208 Kernel module for fuse fusefs-libs-2.7.2_1 FUSE allows filesystem implementation in userspace fusefs-sshfs-1.8 Mount remote directories over ssh 接下來，開啟使用 fusefs 的功能 

<pre class="brush: bash; title: ; notranslate" title="">#
# 啟動 fusefs
#
/usr/local/etc/rc.d/fusefs start

#
# 安裝好自動會寫入 /etc/rc.conf
#
cat /etc/rc.conf | grep fusefs
#
# fusefs_enable="YES"
#
</pre> 然後在 root 使用底下是沒有問題的，但是你在普通使用者底下，就會出現底下訊息： 

> fuse: failed to open fuse device: Permission denied 解決方法就是：要將 kernel 中的 vfs.usermount 設為 1 

<pre class="brush: bash; title: ; notranslate" title="">sysctl vfs.usermount=1
vfs.usermount: 0 -> 1
#
# 然後修正 /dev/fuse* 的權限
#
devfs ruleset 10
devfs rule add path 'fuse*' mode 666
</pre> 這樣大致上就ok了 Linux 安裝方法，其實這很簡單，下載軟體 make install 就可以了 

[Download SSHFS][5] [Download FUSE][6] 安裝方法： 

<pre class="brush: bash; title: ; notranslate" title="">#
# 兩套軟體都是這樣安裝
#
./configure
make
make install (as root)
</pre> 裝好你在使用的時候，你下 sshfs 的時候，會出現底下問題： 

> foofs: error while loading shared libraries: libfuse.so.2: cannot open shared object file: No such file or directory 解決方法就是：先尋找 libfuse.so.2 

<pre class="brush: bash; title: ; notranslate" title="">#
# find  libfuse.so.2
#
updatedb
locate  libfuse.so.2
#
# 找到如下
#
/root/fuse-2.7.3/lib/.libs/libfuse.so.2
/root/fuse-2.7.3/lib/.libs/libfuse.so.2.7.3
/usr/local/lib/libfuse.so.2
/usr/local/lib/libfuse.so.2.7.3
</pre> 新增檔案 /etc/ld.so.conf.d/fuse.conf ，在裡面寫入 

<pre class="brush: bash; title: ; notranslate" title="">#
# 將 /usr/local/lib 寫入該檔案
#
/usr/local/lib
</pre> 重新載入系統 

<pre class="brush: bash; title: ; notranslate" title="">#
# 重新載入 
#
ldconfig
</pre> 這樣大致上就可以使用了 使用方法： 

<pre class="brush: bash; title: ; notranslate" title="">#
# -p PORT
# usage: sshfs [user@]host:[dir] mountpoint [options]
sshfs -p 2500 appleboy@xxx.xxxx.xxx.xxx:/home/appleboy /home/appleboy/test

#
# fstat /dev/fuse* 可以觀看狀況
#
USER     CMD          PID   FD MOUNT      INUM MODE         SZ|DV R/W NAME
root     sshfs      33936    4 /dev         95 crw-rw----   fuse0 rw  /dev/fuse0
</pre> 如果不使用話，就利用 umount 吧 FreeBSD 作法 

<pre class="brush: bash; title: ; notranslate" title="">umount /fs/to/mount
/usr/local/etc/rc.d/fusefs stop
Stopping fusefs.
</pre> 相當簡單，這樣對寫程式的人相當方便阿，哈哈 reference: 

<http://fuse.sourceforge.net/sshfs.html> <http://fuse.sourceforge.net/wiki/index.php/FAQ> [http://fuse4bsd.creo.hu/doc/html\_single\_out/doc.html][7] <http://blog.dragon2.net/2007/01/03/418.php> <http://fuse.sourceforge.net/wiki/index.php/SshfsFaq>

 [1]: http://www.ptt.cc
 [2]: http://www.linux.org/
 [3]: http://fuse.sourceforge.net/sshfs.html
 [4]: http://www.freebsd.org/
 [5]: http://sourceforge.net/project/showfiles.php?group_id=121684&package_id=140425
 [6]: http://sourceforge.net/project/showfiles.php?group_id=121684&package_id=132802
 [7]: http://fuse4bsd.creo.hu/doc/html_single_out/doc.html