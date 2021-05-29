---
title: Linux 程式開發編輯器 Geany + Fuse 遠端掛載
author: appleboy
type: post
date: 2011-07-21T09:45:38+00:00
url: /2011/07/linux-geany-fuse/
dsq_thread_id:
  - 364142925
categories:
  - Linux
  - Ubuntu
tags:
  - Fuse
  - Geany
  - Linux
  - SSH
  - sshfs

---
[<img src="https://i1.wp.com/farm7.static.flickr.com/6139/5960473038_a673f811c5.jpg?resize=500%2C297&#038;ssl=1" alt="Geny" data-recalc-dims="1" />][1] 自己買的筆電灌上了 Ubuntu 作業系統，Linux 系統好處多多，指令自己也熟悉，想架什麼站都可以，但是最主要還是要找一套程式開發編輯器，網路上看了大部份文章，我決定用 <a href="http://www.geany.org/" target="_blank">Geany</a> 這套免費的編輯器，在 Windows XP 底下我則是使用 <a href="http://www.pspad.com/" target="_blank">PSPad</a> 搭配內建的 FTP 功能遠端編輯寫程式，但是 Geany 並沒有支援 FTP 功能，可以詳細看到<a href="http://www.geany.org/Documentation/FAQ#QQuestions10" target="_blank">官方網站 Q&A</a>，官方建議搭配 <a href="http://fuse.sourceforge.net/" target="_blank">Fuse</a> 或 <a href="http://sourceforge.net/projects/lufs/" target="_blank">LUFS</a>，這樣並不只是 Geany 可以使用，其他 Application 也可以任意使用了。 在介紹 Fuse 之前可以先參考過去寫的一篇教學: <a href="http://blog.wu-boy.com/2008/04/linux-freebsd-%E5%A5%BD%E7%94%A8%E7%9A%84-ssh-filesystem-fusefs-sshfs-in-freebsd-or-linux/" target="_blank">[SSHFS] 好用的 SSH Filesystem fusefs-sshfs in FreeBSD or Linux</a>，裡面分享了 <a href="http://www.FreeBSD.org" target="_blank">FreeBSD</a> 跟 Linux 底下的 tarball 安裝方式，當然現階段 Ubuntu 安裝就很容易了，透過 Apt 管理的方式安裝: 

<pre class="brush: bash; title: ; notranslate" title="">$ apt-cache search sshfs
sshfs - filesystem client based on SSH File Transfer Protocol
sshfs-dbg - filesystem client based on SSH File Transfer Protocol (with debbuging symbols)
sbackup-plugins-fuse - Simple Backup Suite FUSE plugins
$ apt-get install sshfs</pre> 安裝完成，透過底下指令把遠端資料夾 mount 過來吧。 

<pre class="brush: bash; title: ; notranslate" title="">$ mkdir /home/appleboy/tmp
$ sshfs -p 22 appleboy@XXX.XXX.XXX.XXX:/home/appleboy /home/appleboy/tmp</pre> Geany 真的蠻好用的喔，推薦給大家，還有其他 screenshot 可以參考

<a href="http://www.geany.org/Documentation/Screenshots" target="_blank">這裡</a>

 [1]: https://www.flickr.com/photos/appleboy/5960473038/ "Geny by appleboy46, on Flickr"