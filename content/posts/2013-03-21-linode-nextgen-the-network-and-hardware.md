---
title: Linode VPS 升級網路及硬體設備
author: appleboy
type: post
date: 2013-03-21T11:00:32+00:00
url: /2013/03/linode-nextgen-the-network-and-hardware/
dsq_thread_id:
  - 1154043403
categories:
  - Network
  - www
tags:
  - Linode
  - network
  - VPS

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/www.linode.com/images/linode_logo_gray.png?w=840" alt="Linode VPS" data-recalc-dims="1" />
</div>

<a href="linode.com" target="_blank">Linode</a> 是我最喜歡的國外 VPS 廠商，重點是速度跟穩定度都還不錯，不過今年不知道是不是被 <a href="https://www.digitalocean.com/" target="_blank">DigitalOcean</a> 刺激到？所以這個月將網路設備全面升級，不僅降低 latency 和 redundancy，出口端網路設備全部換成 Cisco Nexus 7000 series 等級，此系列提供了足夠的 Mac Address 及處理大量 Request，另外 access layer switches 則換成 Cisco Nexus 5000 series switches 跟 Nexus 2000 series Fabric Extenders，這些都不是重點，重點是每台 VPS 現在**<span style="color:red">對外流量都變成原先的十倍</span>**，當然<a href="http://blog.wu-boy.com/2011/09/linode-vps-inbound-%E6%B5%81%E9%87%8F%E5%B0%87%E4%B8%8D%E5%86%8D%E6%94%B6%E8%B2%BB/" target="_blank">對內流量是無限制的</a>，底下是 Linode 最新網路架構圖 <!--more-->

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8576418983/" title="Linode-NextGen-Network by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8233/8576418983_111fb34488.jpg?resize=500%2C453&#038;ssl=1" alt="Linode-NextGen-Network" data-recalc-dims="1" /></a>
</div> 對外流量都增加十倍如下表，真是太超過了。 

> Linode 512 upgraded from 200GB to 2000GB (2TB) Linode 1G upgraded from 400GB to 4000GB (4TB) Linode 2G upgraded from 800GB to 8000GB (8TB) Linode 4G upgraded from 1600GB to 16000GB (16TB) Linode 8G upgraded from 2000GB to 20000GB (20TB) 這樣就算了，接著升級 VPS 硬體，**<span style="color:red">每個 Linode 全升級成 8 Core CPU Instances</span>**，這簡直是太瘋狂了，已經讓作者忍不住來玩看看了，官方直接提供了重新編譯系統核心的速度，使用機器為 Linode 1024 with 8 cores，編譯完成時間大概為 100 秒，這速度...... 

> apt-get update && apt-get -y install build-essential wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz tar xf linux-3.8.tar.xz cd linux-3.8/ make distclean && make defconfig && time make -j8 real 1m41.861s user 10m37.423s sys 1m41.298s 最後文章提到，那硬碟呢？人家 <a href="https://www.digitalocean.com/" target="_blank">DigitalOcean</a> 全面採用 SSD，那 Linode 呢？沒關係，官方說這是未來的計畫，要全面換成 SSD 需要一大筆資金阿，所以讓大家期待一下吧。不過 CPU 已經這麼快了，那 Ram 呢？大家其實希望增加的是 Ram 吧 XD 最後補一張圖來證明真的是 8 Core CPU: 

<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8576336061/" title="linode by appleboy46, on Flickr"><img src="https://i0.wp.com/farm9.staticflickr.com/8228/8576336061_90e3a86a17.jpg?resize=381%2C219&#038;ssl=1" alt="linode" data-recalc-dims="1" /></a>
</div> Ref 兩篇官方說明： 

<a href="http://blog.linode.com/2013/03/18/linode-nextgen-the-hardware/" target="_blank">Linode NextGen: The Hardware</a> <a href="http://blog.linode.com/2013/03/07/linode-nextgen-the-network/" target="_blank">Linode Nextgen: The Network</a>