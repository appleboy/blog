---
title: '[WWW] FTP 的主動模式( active )和被動模式( passive )'
author: appleboy
type: post
date: 2008-03-12T01:59:06+00:00
url: /2008/03/www-ftp-的主動模式-active-和被動模式-passive/
views:
  - 3741
bot_views:
  - 593
dsq_thread_id:
  - 247368936
categories:
  - Network
  - windows
  - www

---
這一篇轉錄自 <http://forum.icst.org.tw/phpBB2/viewtopic.php?t=79> 目前 FTP 已經是大家必備的東西，那架站之前你必須先瞭解什麼是 主動模式( active )和被動模式( passive ) 

> FTP 的主動模式( active )和被動模式( passive ) FTP 是一種檔傳輸協定 (File Transfer Protocol)，它的連線模式有兩種﹕ 主動模式( active )和被動模式( passive )。以下說明 FTP 的連線是怎樣建立的﹕ 在 active 模式下 (一般預設的模式)﹕ 1. FTP client 開啟一個隨機選擇的TCP port 呼叫 FTP server 的 port 21請求連線。當順 　利完成 Three-Way Handshake 之後，連線就成功建立，但這僅是命令通道的建立 　。 2.當兩端需要傳送資料的時候，client 透過命令通道用一個 port command 告訴 server 　，client可以用另一個TCP port 做數據通道。 3.然後 server 用 port 20 和剛才 client 所告知的 TCP port 建立數據連線。請注意：連 　線方向這是從 server 到 client 的，TCP 封包會有一個 SYN flag。 4.然後 client 會返回一個帶 ACK flag的確認封包﹐並完成另一次的 Three-Way 　Handshake 手續。這時候，數據通道才能成功建立。 5.開始數據傳送。 在 passive 模式下 1.FTP client 開啟一個隨機選擇的TCP port 呼叫 FTP server 的 port 21請求連線，並完 　成命令通道的建立。 2.當兩端需要傳送資料的時候，client 透過命令通道送一個 PASV command 給 　server，要求進入 passive 傳輸模式。 3.然後 server 像上述的正常模式之第 2 步驟那樣，挑一個TCP port ，並用命令通道 　告訴 client。 4.然後 client 用另一個TCP port 呼叫剛才 server 告知的 TCP port 來建立數據通道。此 　時封包帶 SYN flag。 5.server 確認後回應一個 ACK 封包。並完成所有交握手續?成功建立數據通道。 6.開始數據傳送。 在實際使用上, active mode 用來登入一些開設在主機上及沒有安裝防火牆的 FTP server，或是開設於 client side 的 FTP server！ Passive mode （簡稱 PASV）用來登入一些架設於防火牆保護下而又是開設於主機上的 FTP server！ 如果您覺得太深奧而弄不清楚, 那就先用預設的 active mode 登入, 失敗改用 passive mode 登入就是了。 PS: 並不是每套 FTP 軟體都支援 passive mode 登入