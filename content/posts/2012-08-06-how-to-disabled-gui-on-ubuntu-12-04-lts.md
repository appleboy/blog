---
title: Ubuntu 停止使用 GUI 介面 12.04 LTS
author: appleboy
type: post
date: 2012-08-06T06:28:12+00:00
url: /2012/08/how-to-disabled-gui-on-ubuntu-12-04-lts/
dsq_thread_id:
  - 794195202
categories:
  - Ubuntu
tags:
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div>

今天又拿到同事一台電腦來搞 Web Server，原先安裝 Ubuntu Desktop 要把它關閉，避免佔用太多資源，12.04 採用 <a href="http://en.wikipedia.org/wiki/LightDM" target="_blank">LightDM</a> 來管理 X Display，輕量級及高效能管理工具，直接停止 LightDM 可以直接用底下 command line。

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ service lightdm stop</pre>
</div>

如果開機直接不執行 X Display，可以透過底下步驟，

### 編輯 /etc/default/grub

用您個人喜歡的編輯器打開 `/etc/default/grub` 並且找到底下字串

<div>
  <pre class="brush: bash; title: ; notranslate" title="">GRUB_CMDLINE_LINUX_DEFAULT="<no matter what's you find here>"</pre>
</div>

改成

<div>
  <pre class="brush: bash; title: ; notranslate" title="">GRUB_CMDLINE_LINUX_DEFAULT="text"</pre>
</div>

### 重新產生 Grub

只要有修改 `/etc/default/grub`，請務必重執行

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ sudo update-grub</pre>
</div>

接著重新開機即可。

參考資料:

<a href="http://askubuntu.com/questions/74645/possible-to-install-ubuntu-desktop-and-then-boot-to-no-gui" target="_blank">Possible to install ubuntu-desktop and then boot to no GUI</a> <a href="http://superuser.com/questions/310978/starting-ubuntu-without-the-gui" target="_blank">Starting Ubuntu without the GUI</a>