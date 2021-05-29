---
title: 'How to change run levels and init.d scripts in Ubuntu & Debian'
author: appleboy
type: post
date: 2010-01-28T02:15:27+00:00
url: /2010/01/how-to-change-run-levels-and-init-d-scripts-in-ubuntu-debian/
views:
  - 5704
bot_views:
  - 400
dsq_thread_id:
  - 246706408
categories:
  - Debian
  - Linux
  - Ubuntu
tags:
  - Debian
  - Fedora
  - Linux
  - Ubuntu

---
[Ubuntu][1] [6.10 (Edgy Eft)][2] 之後使用 [Upstart][3] 代替原來的 sysinit，而 init 是用來管理 Upstart 的 Daemon，本來系統預設的 runlevel 可以在 /boot/menu.list 或者是 /etc/inittab，可是現在這檔案已經移除了，取而代之的就是 Upstart 管理，可以利用 [telinit][4] 來改變系統 runlevel，然而現在 runlevel 的定義跟以前不太一樣了，原先 Ubuntu 跟 Fedora 系列 runlevel 代表意義如下： 

> 0:系統關機 (to halt the system) 1:單一使用者模式 (single-user mode) 2:尚未使用（可由使用者定義） 3:多使用者模式 (文字介面登入) 4:尚未使用 (可由使用者定義) 5:多使用者模式 (含有一個X介面的登入畫面) 6:重新開機 (reboot the system) 轉換成 Upstart 的話，就會變成底下 

> 0:系統關機 (to halt the system) 1:單一使用者模式 (single-user mode) 2:多使用者模式 (含有一個X介面的登入畫面) 3:多使用者模式 (含有一個X介面的登入畫面) 4:多使用者模式 (含有一個X介面的登入畫面) 5:多使用者模式 (含有一個X介面的登入畫面) 6:重新開機(reboot the system) 上面資訊可以在 man telinit 裡面找到，寫得很詳細，現在 Ubuntu 9.10 系統，預設啟用是在 runlevel 2，只要執行 runlevle 指令，就可以查出先前跟目前所設定的 runlevel 值，這些數值是存放在 /var/run/utmp，這是一個 [UTMP File][5]，你會發現，現在只要安裝好 Ubuntu Desktop 系統，就會自動啟動，所以常常會看到 Linux 使用者會來詢問如何關閉 gdm 桌面程式，其實有很多手動的方式，init 也管理了開機所需執行的程式，如果是跑 runlevel 2，就會去執行 /etc/rc2.d/* 底下所有的 script 檔案，所以大家可以發現會有 /etc/rcX.d/ (X:0,1,2,3,4,5,6,S)，其中的 S 代表 single user mode，我們用 rc2.d 底下的檔案來說明： [<img src="https://i1.wp.com/farm5.static.flickr.com/4028/4310037627_a22f2ec884.jpg?resize=500%2C254&#038;ssl=1" title="/ect/rcX.d/ all script (by appleboy46)" alt="/ect/rcX.d/ all script (by appleboy46)" data-recalc-dims="1" />][6] 大家可以看到，每個檔案命名方式：[S|K]\d{2}script_name，S 代表開機會啟動，K 代表開機不啟動，後面接兩位數字，代表開機優先權順序，這些檔案都是利用 Soft link 方式連接到 /etc/init.d/ 底下，所以修改 /etc/init.d/ 資料夾檔案內容，就可以自動更新 /etc/rc[0-6].d/ 檔案，相當方便吧，那該如何產生對應檔案到 /etc/rc[0-6].d/ 資料夾底下，可以利用 [update-rc.d][7] 這指令，update-rc.d 是用來產生或移除 init script links，可以參考 [Debian Policy Manual][8]。 

## 如何使用 update-rc.d 管理 init script links 利用系統預設值來新增 script links，預設值啟動 runlevels 2-5 跟停止於 runlevels 0, 1 and 6 

<pre class="brush: bash; title: ; notranslate" title="">update-rc.d script_name defaults</pre> 或者是可以自行設定執行優先順序跟自訂啟動 runlevel (ps. 請注意後面都有 

<span style="color:red;font-size:11pt">.</span> 符號) 

<pre class="brush: bash; title: ; notranslate" title="">update-rc.d script_name start 20 2 3 4 5 . stop 20 0 1 6 .</pre> 移除這些 script links (-f 參數代表強制移除) 

<pre class="brush: bash; title: ; notranslate" title="">update-rc.d -f script_name remove</pre>

[<img src="https://i1.wp.com/farm5.static.flickr.com/4048/4310832866_617a2c8e8d.jpg?resize=500%2C144&#038;ssl=1" title="2010-01-28 11 52 06 (by appleboy46)" alt="2010-01-28 11 52 06 (by appleboy46)" data-recalc-dims="1" />][9] 可以看到在 runlevel 0126 是不啟動，345 是啟動 gdm 狀態，在 Ubuntu 9.10 底下，如果不想要開機就執行桌面程式，那就是必須要把 gdm 關閉，可以用下面兩種 command line 關閉 

<pre class="brush: bash; title: ; notranslate" title="">/etc/init.d/gdm stop
service gdm stop</pre> 但是這兩種方式只會在開機後手動執行，大家需要的是開機不會啟動，當然可以寫到 /etc/rc.local，因為在 rcX.d 底下會有 S99rc.local 執行，底下分享一下如何修改開機 runlevel，預設值是 2，但是之前都是另用 /etc//inittab 方式來修改，那其實現在這檔案消失了，您也可以自行新增喔，請先看 /etc/init/rc-sysinit.conf 

<pre class="brush: bash; title: ; notranslate" title=""># Default runlevel, this may be overriden on the kernel command-line
# or by faking an old /etc/inittab entry
env DEFAULT_RUNLEVEL=2</pre> 在這裡就可以修改系統 runlevel，註解也有說明，可以新增 /etc/inittab 來讓系統讀取其內容 

<pre class="brush: bash; title: ; notranslate" title="">id:2:initdefault: </pre> 最後也是會讀取 /etc/inittab 

<pre class="brush: bash; title: ; notranslate" title=""># Check for default runlevel in /etc/inittab
if [ -r /etc/inittab ]
then
    eval "$(sed -nre 's/^[^#][^:]*:([0-6sS]):initdefault:.*/DEFAULT_RUNLEVEL="\1";/p' /etc/inittab || true)"
fi</pre> 所以最後還是會依照 /etc/inittab 寫入的資訊來判斷系統 runlevel，最後才會去執行 rcX.d 所有 script 檔案。不想執行桌面程式，會在網路上找到利用 

<pre class="brush: bash; title: ; notranslate" title="">update-rc.d gdm stop 20 0 1 2 3 4 5 6 .</pre> 這樣正常來說不會去啟動 gdm 才對，可是實驗結果，還是會繼續啟動，後來找到 /etc/init/gdm.conf 底下這段程式碼： 

<pre class="brush: bash; title: ; notranslate" title="">start on (filesystem
          and started hal
          and tty-device-added KERNEL=tty7
          and (graphics-device-added or stopped udevtrigger))
stop on runlevel [016]</pre> 把 stop on runlevel [016] 改成 stop on runlevel [0123456] 這樣就可以了 參考網站： 

[Choosing different run level in Ubuntu][10] [upstart 和ubuntu启动过程原理介绍][11] [[Linux]ubuntu下修改服務的執行等級][12] [[ubuntu] Need to disable gdm][13]

 [1]: http://www.ubuntu.com/
 [2]: http://en.wikipedia.org/wiki/Ubuntu_%28operating_system%29#Releases
 [3]: http://en.wikipedia.org/wiki/Upstart
 [4]: http://wiki.linuxquestions.org/wiki/Telinit
 [5]: http://en.wikipedia.org/wiki/Utmp
 [6]: https://www.flickr.com/photos/appleboy/4310037627/ "/ect/rcX.d/ all script (by appleboy46)"
 [7]: http://wiki.linuxquestions.org/wiki/Update-rc.d
 [8]: http://www.debian.org/doc/debian-policy/#contents
 [9]: https://www.flickr.com/photos/appleboy/4310832866/ "2010-01-28 11 52 06 (by appleboy46)"
 [10]: http://blog.yam.com/alvinkw/article/17213461
 [11]: http://www.linux521.com/2009/system/200906/5073.html
 [12]: http://kileleu.pixnet.net/blog/post/24838245
 [13]: http://ubuntuforums.org/showthread.php?t=1305659