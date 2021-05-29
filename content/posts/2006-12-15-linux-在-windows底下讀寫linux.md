---
title: '[Linux] 在 windows底下讀寫linux'
author: appleboy
type: post
date: 2006-12-15T07:16:10+00:00
url: /2006/12/linux-在-windows底下讀寫linux/
views:
  - 9020
bot_views:
  - 1418
dsq_thread_id:
  - 249047422
categories:
  - FreeBSD
  - Linux
  - windows

---
剛剛在ptt看到的，一連串討論 □ XP 認得 ext2/ext3 磁區嗎 ? 裡面有很多文章 寫的不錯，可以提供出來 問題： 

> 想問一下,我有一個移動式硬碟 60G 所以只能format 成 NTFS or ext2/ext3 而在 Linux 下, 目前支援 NTFS 讀寫可能要另外掛 package&#8230; 所以想問,那 Windows XP 是否支援 ext2 / ext3 ext3好像不行, 因為剛剛在 Linux 下 format成 ext3了 並備份了一些東東,到進到了Windows XP底下好像認不得了, 想問,ext2 在 Windows XP 底下,OK嗎&#8230; xp認得嗎? 解法如下 作者 wyocbu@kkcity.com.tw (wyocbu), <!--more-->

> 以前下載過一個商業軟體 Paragon Mount Everything <http://www.mount-everything.com/> 印象中好像可以讀寫 ext3 作者 ogre0403 (肚子餓) 

> 只要讀的話 試試這個 應該是free的 <http://www.chrysocome.net/explore2fs> 寫的話應該不行 作者 alpe (薛丁格的貓) 

> <http://www.fs-driver.org/> IFS Drivewrs 讀寫可&#8230; 不過中文編碼就&#8230; 作者 adolf.bbs@cd.twbbs.org (蘇怡華 有人要死了), 

> > <http://ext2fsd.sf.net/> > ext2 可讀可寫 > ext3 唯讀 其實這類的driver都可以正常寫ext3 只是把journal關掉而已&#8230; <http://pank.org/blog/archives/000621.html> 作者 jlovet (阿我真是猜不透XD) 

> ext2 跟 ext3是相容的檔案系統 在只支援ext2的OS上面mount ext3可以正常讀寫 只是會略過journal 關於ntfs-3g的測試&#8230;網站上面就有了&#8230; <http://www.ntfs-3g.org/performance.html> Ubuntu 掛載 Windows 分割區 

> Ubuntu 6.10 (Edgy): deb http://givre.cabspace.com/ubuntu/ edgy main deb http://ntfs-3g.sitesweetsite.info/ubuntu/ edgy main deb http://flomertens.keo.in/ubuntu/ edgy main Ubuntu 6.06 (Dapper Drake): deb http://givre.cabspace.com/ubuntu/ dapper main main-all deb http://ntfs-3g.sitesweetsite.info/ubuntu/ dapper main main-all deb http://flomertens.keo.in/ubuntu/ dapper main main-all 然後執行以下指令更新 repositories 及安裝 ntfs-3g: wget http://flomertens.keo.in/ubuntu/givre\_key.asc -O- | sudo apt-key add &#8211; wget http://givre.cabspace.com/ubuntu/givre\_key.asc -O- | sudo apt-key add &#8211; sudo apt-get update sudo apt-get install ntfs-3g<http://www.real-blog.com/linux-bsd-notes/290>