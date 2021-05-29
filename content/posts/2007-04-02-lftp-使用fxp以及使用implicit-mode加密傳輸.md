---
title: Lftp 使用FXP以及使用implicit mode加密傳輸
author: appleboy
type: post
date: 2007-04-02T12:33:09+00:00
url: /2007/04/lftp-使用fxp以及使用implicit-mode加密傳輸/
views:
  - 4994
bot_views:
  - 1045
dsq_thread_id:
  - 249009255
categories:
  - FreeBSD
  - Linux
  - Network

---
其實 lftp 是一個相當好用的文字介面ftp軟體，目前我在玩 linux，就是搭配這套軟體，這套軟體可以搭配shell script，來做到備份的工作，相當不錯，之前在網路上看到 segaa大大寫的一篇 [[freebsd] lftp安裝與應用][1] 使用起來很方便，不過我遇到的server都是利用 explicit mode 方式加密，如果利用 implicit mode方式連接，指令可能有些不同，底下來介紹一下 如果你的server端用 explicit 方式來連接，你可使用 

> lftp -d -u appleboy -p PORT url 如果你用 implicit 方式的話，就用下面 

> \[appleboy@appleboy-dorm\]\[~\][20:23:03]$ lftp lftp :~> open -d ftps://username:password@url:port # # 注意 是 ftps:// # <!--more--> 這樣就可以連上 經過 implicit mode 的ftp伺服器，這是今天研究的心得 當然也可以 fxp，這個是什麼功能，就不多介紹了，他可以讓 ftpServer <-> ftpServer 互傳 其實在 man lftp 裡面就有了，底下來教教使用方法，如果你要上傳資料夾從一個網站到另一個網站你可以下 

> mirror -c [Source Directory] ftp://[Destination Username]:[Destination Password]@[Destination Address]:[Destination Port]/[Destination Directory] 如果你是要單純傳幾個檔案過去的話，那就是用 mget了 

> mget -c [Source file] -O ftp://[Destination Username]:[Destination Password]@[Destination Address]:[Destination Port]/[Destination Directory] 其實還有很多用法 

> get ftp://&#8230; -o ftp://&#8230; get -O ftp://&#8230; file1 file2&#8230; put ftp://&#8230; mput ftp://&#8230;/\* mget -O ftp://&#8230; ftp://&#8230;/\*  然後你可以把他寫成一個檔案，每天固定6點執行 

> set ftp:ssl-force true set ftp:use-fxp true open -p \[Source Port\] \[Source Address\] user \[Source Username\] \[Source Password\] mirror [Source Directory] ftp://[Destination Username]:[Destination Password]@[Destination Address]:[Destination Port]/[Destination Directory] 然後在寫到 crontab 裡面 

> lftp -f config.file

 [1]: http://blog.segaa.net/blog.php/1/post/3/100