---
title: How to write Platform Devices and Drivers with FPGA via GPMC
author: appleboy
type: post
date: 2011-06-26T15:00:19+00:00
url: /2011/06/how-to-write-platform-devices-and-drivers-with-fpga-via-gpmc/
views:
  - 136
bot_views:
  - 61
dsq_thread_id:
  - 342659595
categories:
  - Driver
  - Embedded System
  - Kernel
  - Linux

---
 
<iframe src="//www.slideshare.net/slideshow/embed_code/key/is2GiucZdkWtbu" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/appleboy/how-to-write-platform-devices-and-drivers" title="How to write Platform Devices and Drivers with FPGA via GPMC" target="_blank">How to write Platform Devices and Drivers with FPGA via GPMC</a> </strong> from <strong><a href="https://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong> </div>

這投影片是我在接手公司其中一個專案，所做的 Slide，當然最主要是深入了解 GPMC (General Purpose Memory Control)，GPMC 本來是ARM 用來跟 Memory 溝通的 interface，現在用來跟 FPGA 溝通，目前我只有看到 

[TI][1] 的線上文件有看到相關說明，以及解釋 GPMC 的 Program Model，在寫 GPMC 之前請先注意 Platform Device 跟 Platform Driver 的關係，之後才會開始設定 GPMC Config(1~7) 的設定檔，這樣拿示波器就可以看到 GPMC Chip Select 訊號，每個 ARM 只能接 8 個 Chip Select，這點大家必須注意，Flash 會用掉一個，在這專案學到蠻多東西，畢竟 Driver 這塊非常大，之前寫 [G-Sensor 的 i2c Driver][2] 也是如此。此 Slide 只是初步介紹，更詳細的就要實際撰寫程式碼了。

 [1]: http://www.ti.com/
 [2]: http://www.slideshare.net/appleboy/introduction-to-gsensor-i2c-driver
