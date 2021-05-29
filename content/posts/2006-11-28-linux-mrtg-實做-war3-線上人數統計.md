---
title: '[Linux] Mrtg 實做 war3 線上人數統計'
author: appleboy
type: post
date: 2006-11-28T09:13:34+00:00
url: /2006/11/linux-mrtg-實做-war3-線上人數統計/
bot_views:
  - 1009
views:
  - 4670
dsq_thread_id:
  - 246748838
categories:
  - computer
  - FreeBSD
  - Linux
  - Network
tags:
  - FreeBSD
  - Linux
  - mrtg

---
應大家觀眾要求，來寫一下教學 當然我不想怎麼安裝mrtg了，搜尋一下本站就會找到教學 相信mrtg最主要是他的設定檔 cfg檔，先來看看 這個cfg檔怎麼寫 

<pre class="brush: bash; title: ; notranslate" title=""># Created by
#          Appleboy 2006/09/25

WorkDir: /usr/local/www/data-dist
Language: big5

Target[bnet_person]: `/usr/local/etc/mrtg/mrtg.person.sh`
MaxBytes[bnet_person]: 10000
Options[bnet_person]: gauge, nopercent, growright
YLegend[bnet_person]: Online Users
ShortLegend[bnet_person]: 人
LegendI[bnet_person]: &nbsp; 線上人數 :
LegendO[bnet_person]: &nbsp; 遊戲數目 :
Title[bnet_person]: 小熊戰網 上線人數統計表
</pre> 先來解釋 

<pre class="brush: bash; title: ; notranslate" title="">WorkDir: /usr/local/www/data-dist</pre> 這個是來存放mrtg統計圖的資料夾，請對應到相關可以放html的資料夾 

<pre class="brush: bash; title: ; notranslate" title="">Target[bnet_person]: `/usr/local/etc/mrtg/mrtg.person.sh`</pre> 以下是 mrtg.person.sh 這個檔案 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/sh
# 這個程式主要在計算有多少人以 bnetd 的方式連線進我們的主機！

# 1. 計算線上的數目
cat /~pvpgn/server.dat  | grep "Users" | cut -d "=" -f2

# 2. 計算遊戲數目
cat /~pvpgn/server.dat  | grep "Games" | cut -d "=" -f2

# 3. 輸出時間咚咚
UPtime=`/usr/bin/uptime | awk '{print $3 " " $4 " " $5}'`
echo $UPtime
echo bnet.dearbear.net
</pre> 要先來看看war3在啟動的時候，會把線上人數 寫在 server.dat 檔案裏面，下面是該檔案的模式 

> [STATUS] Version=1.8.0 Uptime=9 hours 20 minutes 0 seconds Games=62 Users=323 Channels=8 UserAccounts=1909 所以我們最主要需要下面這2個值 

> Games=62 Users=323 所以當我執行下面這道指令 

<pre class="brush: bash; title: ; notranslate" title="">cat /~pvpgn/server.dat  | grep "Users" | cut -d "=" -f2
</pre> 就會計算出線上人數有多少傳回mrtg圖表裏面 

[<img src="https://i0.wp.com/static.flickr.com/112/309032129_cbff8c4692_o.png?resize=500%2C135" alt="bnet_person-day" data-recalc-dims="1" />][1]

 [1]: https://www.flickr.com/photos/appleboy/309032129/ "Photo Sharing"