---
title: 使用 cwRsync 差異性備份 Windows 2003 伺服器
author: appleboy
type: post
date: 2007-04-04T03:28:44+00:00
url: /2007/04/使用-cwrsync-差異性備份-windows-2003-伺服器/
views:
  - 9110
bot_views:
  - 1451
dsq_thread_id:
  - 246773396
categories:
  - computer
  - Linux
  - windows

---
最近正在弄Windows的機器怎麼跟Windows的機器互相備份，linux跟windows之間怎麼備份已經搞定了，其實我差不會利用windows的每天固定跑程式，在linux底下可以使用cron的方式來用，可是winodws底下就要使用批次檔。 再來就是安裝步驟，請把2台windows的機器都裝上 cwRsync 參考文章 [[Linux] cwRsync [rsync for windows] SSH 加密異地備份][1] 假設已經安裝好 cwrsync 之後，在系統服務那邊 把他啟動之後，就可以開始使用了 底下是網路上抓好的 清除你系統中沒必要的垃圾檔案 <!--more--> 請打開記事本&#8230; 打入以下東西 

> @echo off echo 正在清除系統垃圾檔案，請稍等&#8230;&#8230; del /f /s /q %systemdrive%\*.tmp del /f /s /q %systemdrive%\*._mp del /f /s /q %systemdrive%\*.log del /f /s /q %systemdrive%\*.gid del /f /s /q %systemdrive%\*.chk del /f /s /q %systemdrive%\*.old del /f /s /q %systemdrive%\recycled\*.\* del /f /s /q %windir%\\*.bak del /f /s /q %windir%\prefetch\*.\* rd /s /q %windir%\temp & md %windir%\temp del /f /q %userprofile%\cookies\\*.\* del /f /q %userprofile%\recent\\*.\* del /f /s /q &#8220;%userprofile%\Local Settings\Temporary Internet Files\\*.\*&#8221; del /f /s /q &#8220;%userprofile%\Local Settings\Temp\\*.\*&#8221; del /f /s /q &#8220;%userprofile%\recent\\*.*&#8221; echo 清除系統LJ完成！ echo. & pause 儲存&#8230;副檔名.bat 不過先設定 rsync.conf [<img src="https://i2.wp.com/farm1.static.flickr.com/242/445657728_71e82ebd92.jpg?resize=500%2C347&#038;ssl=1" alt="rsync" data-recalc-dims="1" />][2] 請注意 在windows底下 都是利用 

> \# Module definitions # Remember cygwin naming conventions : c:\work becomes /cygwin/c/work 路徑不要打錯，然後在打開剛剛寫好的bat檔案，加入底下 

> @cls @echo off rem Rsync job control file path=C:\Program Files\cwRsyncServer\bin;%path% rsync -avl &#8211;delete &#8211;progress &#8211;password-file=d:\backup\rsync.txt /cygdrive/d/backup appleboy@192.168.100.5::backup_NAS echo. & pause 重點是底下這行 

> path=C:\Program Files\cwRsyncServer\bin;%path% path要設定好，不然系統會跟您說找不到指令，其實這在linux砥也會常常遇到 這樣就可以了，然後在 開始->控制台->排定工作 新增一個排程 這樣就可以了 [<img src="https://i0.wp.com/farm1.static.flickr.com/246/445657750_e310c10f79_o.jpg?resize=406%2C448&#038;ssl=1" alt="crontab" data-recalc-dims="1" />][3] 參考： [Rsync for Windows][4] [[Linux] cwRsync [rsync for windows] SSH 加密異地備份][1] 酷學園 <http://phorum.study-area.org/viewtopic.php?t=45307>

 [1]: http://blog.wu-boy.com/2006/12/14/53
 [2]: https://www.flickr.com/photos/appleboy/445657728/ "Photo Sharing"
 [3]: https://www.flickr.com/photos/appleboy/445657750/ "Photo Sharing"
 [4]: http://www.gaztronics.net/rsync.php