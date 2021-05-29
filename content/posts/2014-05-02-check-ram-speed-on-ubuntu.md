---
title: 在 Ubuntu 底下查詢記憶時脈體資訊
author: appleboy
type: post
date: 2014-05-02T02:47:08+00:00
url: /2014/05/check-ram-speed-on-ubuntu/
dsq_thread_id:
  - 2654354584
categories:
  - Ubuntu
tags:
  - Ram
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6760100409/" title="logo-Ubuntu by appleboy46, on Flickr"><img src="https://i2.wp.com/farm8.staticflickr.com/7153/6760100409_b23d1ce67b_m.jpg?resize=240%2C165&#038;ssl=1" alt="logo-Ubuntu" data-recalc-dims="1" /></a>
</div>

最近想升級 Notebook 記憶體到 16G，要查看 [Ubuntu][1] 底下記憶體時脈資訊，可以透過 [dmidecode][2] 指令來取的記憶體硬體裝置資訊，此指令不只是這樣而已，還可以得知整台電腦硬體 components 資訊，底下擷取如何得到記憶體裝置資訊

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ dmidecode --type 17 | more</pre>
</div>

輸出結果為

<div>
  <pre class="brush: bash; title: ; notranslate" title="">
# dmidecode 2.11
SMBIOS 2.4 present.

Handle 0x0036, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x0035
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 2048 MB
        Form Factor: SODIMM
        Set: None
        Locator: DIMM0
        Bank Locator: BANK 0
        Type: DDR3
        Type Detail: Synchronous
        Speed: 1067 MHz
        Manufacturer: 80CE
        Serial Number: 621AD76C
        Asset Tag: Unknown
        Part Number: M471B5673FH0-CF8</pre>
</div>

可以看到目前其中一個記憶體插槽時脈為 `1067 MHz`，型態為 `DDR3`。這樣就可以直接去升級記憶體了 ...

 [1]: http://www.ubuntu.com/
 [2]: http://www.cyberciti.biz/faq/check-ram-speed-linux/