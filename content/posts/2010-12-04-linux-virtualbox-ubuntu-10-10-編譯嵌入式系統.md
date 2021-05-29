---
title: '[Linux] VirtualBox + Ubuntu 10.10 編譯嵌入式系統'
author: appleboy
type: post
date: 2010-12-04T08:45:35+00:00
url: /2010/12/linux-virtualbox-ubuntu-10-10-編譯嵌入式系統/
views:
  - 2121
bot_views:
  - 185
dsq_thread_id:
  - 246821092
categories:
  - Ubuntu

---
<div style="float:left;margin-right:25px">
  <a href="https://www.flickr.com/photos/appleboy/4105985126/" title="vbox_logo2_gradient (by appleboy46)"><img src="https://i1.wp.com/farm3.static.flickr.com/2522/4105985126_591a664ca4_o.png?resize=140%2C180&#038;ssl=1" title="vbox_logo2_gradient (by appleboy46)" alt="vbox_logo2_gradient (by appleboy46)" data-recalc-dims="1" /></a>
</div> 最近使用 

[Ubuntu][1] 來編譯嵌入式的環境，由於個人比較不喜歡 [Fedora][2] 的系統，所以自己用了 [VirtualBox][3] 來搭配 10.10 的 Ubuntu 系統，在這裡提醒一下，請安裝最新版的 **VirtualBox 3.2.12 for Windows hosts**，否則在安裝 Ubuntu 之後，繼續安裝 Guest Addition 的時候會當機喔，重開機之後可以看到桌面多出一個光碟，是要您繼續安裝 Additions [<img src="https://i1.wp.com/farm6.static.flickr.com/5128/5230492977_ea049b4d9b.jpg?resize=500%2C276&#038;ssl=1" alt="VirtualBox + Ubuntu" data-recalc-dims="1" />][4] 切換到該光碟目錄 

<pre class="brush: bash; title: ; notranslate" title="">cd /media/VBOXADDITIONS_3.2.12_68302/</pre> 直接執行 

<pre class="brush: bash; title: ; notranslate" title="">sh VBoxLinuxAdditions-x86.run</pre> 重新開機就完成了，可以直接切換視窗大小...等，編譯 gcc 必須要一些 Cross tool，利用 apt-get 方式安裝: 

<pre class="brush: bash; title: ; notranslate" title="">apt-get install build-essential</pre> 安裝額外 USB 裝置: 視窗上面 Devices -> USB Devices 選擇你要的外接硬碟，會跳出 Windows 安裝額外 Driver 

[<img src="https://i0.wp.com/farm6.static.flickr.com/5205/5230491839_0486144dc4.jpg?resize=396%2C308&#038;ssl=1" alt="VirtualBox + Ubuntu 10.10" data-recalc-dims="1" />][5] 直接按 Continue Anyway [<img src="https://i0.wp.com/farm6.static.flickr.com/5123/5230491869_0b65019a5c.jpg?resize=500%2C383&#038;ssl=1" alt="VirtualBox + Ubuntu 10.10" data-recalc-dims="1" />][6] 完成 [<img src="https://i1.wp.com/farm6.static.flickr.com/5082/5230491883_923604958e.jpg?resize=500%2C383&#038;ssl=1" alt="VirtualBox + Ubuntu 10.10" data-recalc-dims="1" />][7] 補上 Ubuntu 畫面 [<img src="https://i0.wp.com/farm6.static.flickr.com/5085/5231085398_0f81217c05.jpg?resize=500%2C304&#038;ssl=1" alt="VirtualBox + Ubuntu 10.10" data-recalc-dims="1" />][8]

 [1]: http://www.ubuntu-tw.org/
 [2]: http://fedora.tw/
 [3]: http://www.virtualbox.org/
 [4]: https://www.flickr.com/photos/appleboy/5230492977/ "VirtualBox + Ubuntu by appleboy46, on Flickr"
 [5]: https://www.flickr.com/photos/appleboy/5230491839/ "VirtualBox + Ubuntu 10.10 by appleboy46, on Flickr"
 [6]: https://www.flickr.com/photos/appleboy/5230491869/ "VirtualBox + Ubuntu 10.10 by appleboy46, on Flickr"
 [7]: https://www.flickr.com/photos/appleboy/5230491883/ "VirtualBox + Ubuntu 10.10 by appleboy46, on Flickr"
 [8]: https://www.flickr.com/photos/appleboy/5231085398/ "VirtualBox + Ubuntu 10.10 by appleboy46, on Flickr"