---
title: 在 Ubuntu 建置 OpenWrt 編譯環境
author: appleboy
type: post
date: 2014-07-01T02:53:30+00:00
url: /2014/07/openwrt-build-environment-on-ubuntu/
dsq_thread_id:
  - 2808466752
categories:
  - Ubuntu
tags:
  - OpenWrt
  - Ubuntu
  - VirtualBox

---
[<img src="https://i0.wp.com/farm4.staticflickr.com/3873/14546598542_5c9337ab7e_o.png?resize=386%2C98&#038;ssl=1" alt="openwrt-logo" data-recalc-dims="1" />][1]

紀錄一下如何在用 [VirtualBox][2] 架設 Ubuntu [OpenWrt][3] 編譯環境，請記住不要下載 **Ubuntu Server Disk** 來安裝，會遇到很多奇怪的問題，為了避免編譯出錯，請選擇 [Ubuntu][4] 12.04 Desktop 版本，安裝時空間請盡量調大，反正 VirtualBox 也不會吃掉這麼多空間，用多少吃多少。Ubuntu 安裝完成後，請先安裝 openssh server 套件。完成後透過 VirtualBox Network 開啟 22 port forwarding。

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># 有 aptitude 指令
$ aptitude -y install openssh-server
# 無 aptitude 指令
$ apt-get -y install openssh-server</pre>
</div>

由於是安裝桌面版本，所以一開始就會直接打開 lightdm 服務，請透過之前寫的文章 [Ubuntu 停止使用 GUI 介面 12.04 LTS][5] 來把桌面停用，這樣開機就直接進去 Text mode 了，避免浪費記憶體在桌面。最後補上相依性套件安裝

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ aptitude -y install build-essential bison flex gettext g++ help2man help2man zlib1g-dev libssl-dev gawk unzip</pre>
</div>

如果編譯過程有看到 script 檔編譯不過，可能就要換 Bash 環境編譯，請先備份 `/bin/sh`

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ cp -r /bin/sh /bin/sh2
$ ln -sf /bin/bash /bin/sh</pre>
</div>

完整的 GCC 套件相依性安裝可以直接看 [Github 上面的安裝紀錄][6]

 [1]: https://www.flickr.com/photos/appleboy/14546598542 "openwrt-logo by Bo-Yi Wu, on Flickr"
 [2]: https://www.virtualbox.org/
 [3]: https://openwrt.org/
 [4]: http://www.ubuntu.com/
 [5]: http://blog.wu-boy.com/2012/08/how-to-disabled-gui-on-ubuntu-12-04-lts/
 [6]: https://github.com/appleboy/Shell-Script/blob/master/Ubuntu.sh#L270-L290