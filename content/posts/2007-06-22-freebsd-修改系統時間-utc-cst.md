---
title: '[FreeBSD] 修改系統時間 UTC -> CST'
author: appleboy
type: post
date: 2007-06-23T02:52:08+00:00
url: /2007/06/freebsd-修改系統時間-utc-cst/
views:
  - 5708
bot_views:
  - 1009
dsq_thread_id:
  - 246715170
categories:
  - FreeBSD

---
剛安裝好系統是屬於格林時間，所以去設定一下如何弄回去台灣 GMT+8 的時間 有2種方式～一個用圖形介面： 

<pre class="brush: bash; title: ; notranslate" title="">#tzsetup
</pre> 是一個不錯的 timezone 設定工具 , 進去之後選擇 5.Asia -> 42.Taiwan 另一個方法是： 

<pre class="brush: bash; title: ; notranslate" title="">#cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime
#adjkerntz -a
#date
#Sat Jun 23 10:50:40 CST 200
</pre> 1. 使用 date 指令 格式 date [yymmdd]HHMM 說明: yy 年數，如 02 代表 2002 年 mm 月份 01-12 dd 日數 01-31 HH 時數 01-59 MM 分鐘 01-59 yy mm dd 皆可省略 例: 調整日期為 2002-03-25 # date 022325 調整時間為 14:20 # date 1420 2. 使用對時主機 # ntpdate clock.stdtime.gov.tw 這項需能連上網路，其中 clock.stdtime.gov.tw 是一標準時間的主機 ps：(adjkerntz = adjust kernal timezone) 這樣就可以了，容易吧