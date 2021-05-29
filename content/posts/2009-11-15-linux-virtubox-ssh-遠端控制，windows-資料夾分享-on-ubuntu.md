---
title: '[Linux] VirtuBox ssh 遠端控制，Windows 資料夾分享 [On Ubuntu]'
author: appleboy
type: post
date: 2009-11-15T14:21:10+00:00
url: /2009/11/linux-virtubox-ssh-遠端控制，windows-資料夾分享-on-ubuntu/
views:
  - 6888
bot_views:
  - 423
dsq_thread_id:
  - 246781835
categories:
  - Linux
tags:
  - Linux
  - Ubuntu
  - VirtualBox

---
<div style="float:left;margin-right:25px">
  <a href="https://www.flickr.com/photos/appleboy/4105985126/" title="vbox_logo2_gradient (by appleboy46)"><img src="https://i1.wp.com/farm3.static.flickr.com/2522/4105985126_591a664ca4_o.png?resize=140%2C180&#038;ssl=1" title="vbox_logo2_gradient (by appleboy46)" alt="vbox_logo2_gradient (by appleboy46)" data-recalc-dims="1" /></a>
</div>

[VirtualBox][1] 是一套可以模擬虛擬作業系統的軟體，目前 Release 到 3.0.10 版本，可以去官網查看 [Changelog][2]，它可以 run 在各種不同的作業系統，例如：Windows, Linux, Macintosh and OpenSolaris etc. 可以看 [guest operating systems][3]，每次只要新的 OS Release 出來，就要先用 VirtualBox 模擬一下，還有如果需要 IE6，也是需要另一套 Windows XP，在教學方面也是相當方便的，底下紀錄一下如何 [pietty][4] 去連接 VirtuBox 裡面的 [Ubuntu][5] Server。 <!--more-->

[<img title="Ubuntu_Desktop_Screenshot (by appleboy46)" src="https://i0.wp.com/farm3.static.flickr.com/2685/4105124357_17f83d2087.jpg?resize=500%2C323&#038;ssl=1" alt="Ubuntu_Desktop_Screenshot (by appleboy46)" data-recalc-dims="1" />][6] 安裝好畫面如上，當然桌面就可以隨時操作，如果你想要從 Host 端 Windows XP 利用 Pietty 連線過去的話，那必須用 command line 指令設定本機端 port 連接到 guest 端 Ubuntu，設定方法如下： 先假設 Ubuntu 已經安裝好 open ssh server，如果尚未安裝，可以透過 apt-get 方式來安裝： apt-get install openssh-server 接下來設定 Windows XP 部份：按開始 -> 執行 -> 打入 cmd，會跳出一個<span style="color: #ff0000;">命令提示字元視窗</span> # 進入你安裝virtualbox的目錄 

<pre class="brush: bash; title: ; notranslate" title="">cd "c:\Program Files\sun\VirtualBox"
# 設定本機端 3456 port 對應到 VirtualBox Ubuntu ssh 22 port
VBoxManage setextradata ubuntu "VBoxInternal/Devices/pcnet/0/LUN#0/Config/ssh/Protocol" TCP
VBoxManage setextradata ubuntu "VBoxInternal/Devices/pcnet/0/LUN#0/Config/ssh/GuestPort" 22
VBoxManage setextradata ubuntu "VBoxInternal/Devices/pcnet/0/LUN#0/Config/ssh/HostPort" 3456</pre> 有看到上面 

<span style="color: #ff0000;">setextradata ubuntu</span>，ubuntu 是您設定 VirtualBox 的名稱，就是底下這張圖紅色框框的名稱 [<img title="VirtualBox (by appleboy46)" src="https://i1.wp.com/farm3.static.flickr.com/2632/4105140037_e15e9c3bb1.jpg?resize=500%2C371&#038;ssl=1" alt="VirtualBox (by appleboy46)" data-recalc-dims="1" />][7] 設定好之後，請<span style="color: #ff6600;"><strong>務必重新啟動 VirtualBox 軟體</strong></span>，這樣就可以了，請使用 pietty 打入 localhost，port 請打 3456 就可以了。 Q:如何分享 Windows Xp 資料夾給 Ubuntu 使用 1.先設定虛擬目錄給 Ubuntu: 參考下圖，請先不要啟動 Ubuntu，先設定 [<img src="https://i2.wp.com/farm3.static.flickr.com/2656/4105162147_618b9aec23.jpg?resize=500%2C441&#038;ssl=1" title="Ubuntu_setting (by appleboy46)" alt="Ubuntu_setting (by appleboy46)" data-recalc-dims="1" />][8] 上面目錄可以一直增加，你也不需要將 Windows 的目錄做分享資料夾的動作，請注意前面的 Name 你可以自行設定，後面的目錄路徑，就是 Windows 的系統目錄 2. 在 Ubuntu 系統底下增加目錄 

<pre class="brush: bash; title: ; notranslate" title="">mkdir /mnt/share
mkdir /mnt/Ubuntu</pre> 3. 安裝 guest 端 Additions 軟體 

<pre class="brush: bash; title: ; notranslate" title="">apt-get install virtualbox-ose-guest-utils</pre> 4. 利用 mount 指令把 share folder 掛載到 Ubuntu 底下 

<pre class="brush: bash; title: ; notranslate" title="">mount -t vboxsf  Ubuntu /mnt/test</pre> 上面 vboxsf 是 type，如果沒有安裝步驟三，會出現錯誤，後面所接的 Ubuntu 參數，是剛剛前面設定的目錄分享名稱 Windows 畫面： 

[<img src="https://i2.wp.com/farm3.static.flickr.com/2780/4105197659_12b4e92a58.jpg?resize=500%2C375&#038;ssl=1" title="VBox_01 (by appleboy46)" alt="VBox_01 (by appleboy46)" data-recalc-dims="1" />][9] Ubuntu 畫面： [<img src="https://i0.wp.com/farm3.static.flickr.com/2585/4105197759_ac903568ae.jpg?resize=500%2C379&#038;ssl=1" title="Vobx_02 (by appleboy46)" alt="Vobx_02 (by appleboy46)" data-recalc-dims="1" />][10] 當然你也可以寫成 shell script 弄成開機自動 mount，這些都可以做到喔。 參考文件： [[Linux]VirtualBox - host端為XP, guest端為Ubuntu, 設定分享資料夾][11] [[Linux]xp下使用VirtualBox安裝ubuntu ,設定ssh遠端連線][12] [Sharing Folders with VirtualBox][13] [用ssh或http連線進Virtualbox的虛擬電腦][14]

 [1]: http://www.virtualbox.org/
 [2]: http://www.virtualbox.org/wiki/Changelog
 [3]: http://www.virtualbox.org/wiki/Guest_OSes
 [4]: http://www.csie.ntu.edu.tw/~piaip/pietty/
 [5]: http://www.ubuntu.com/
 [6]: https://www.flickr.com/photos/appleboy/4105124357/ "Ubuntu_Desktop_Screenshot (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/4105140037/ "VirtualBox (by appleboy46)"
 [8]: https://www.flickr.com/photos/appleboy/4105162147/ "Ubuntu_setting (by appleboy46)"
 [9]: https://www.flickr.com/photos/appleboy/4105197659/ "VBox_01 (by appleboy46)"
 [10]: https://www.flickr.com/photos/appleboy/4105197759/ "Vobx_02 (by appleboy46)"
 [11]: http://kileleu.pixnet.net/blog/post/24556222
 [12]: http://kileleu.pixnet.net/blog/post/24548390
 [13]: http://virtualdebian.blogspot.com/2007/12/sharing-folders-with-virtualbox.html
 [14]: http://dev.sopili.net/2009/05/connect-ssh-http-into-virtualbox.html