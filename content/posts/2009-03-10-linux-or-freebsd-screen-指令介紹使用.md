---
title: Linux or FreeBSD screen 指令介紹使用
author: appleboy
type: post
date: 2009-03-10T09:47:43+00:00
url: /2009/03/linux-or-freebsd-screen-指令介紹使用/
views:
  - 9534
bot_views:
  - 468
dsq_thread_id:
  - 247334494
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - Linux
  - screen

---
在管理 Linux 或者是 [FreeBSD][1] 系統常常用到的指令：screen，一方面如果 pietty 當掉，那您執行的指令升級系統都會繼續在 background 跑，那有時候可能跑的時間很長，這時候當然就要靠 screen 來達成這個目的，當然您也可以用 nohup 的方式來做到此目的，底下就是一些 screen 我常用的一些指令，還蠻方便的 首先如何開啟新的 screen 呢，當然就直接打指令 screen 就可以了，在 FreeBSD 底下開始沒有支援 screen 指令，利用 [FreeBSD ports][2] 來安裝 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/sysutils/screen; make install clean</pre>

<!--more--> 接下來進入到 screen 的模式之後，可以利用底下一些指令來操作： 

<pre class="brush: bash; title: ; notranslate" title="">C-a c -> Create == 開啟新的 window
C-a n -> Next == 切換到下個 window
C-a p -> Previous == 前一個 window
C-a C-a -> Other == 在兩個 window 間切換
C-a w -> Windows == 列出已開啟的 windows 有那些
C-a 0 -> 切換到第 0 個 window
C-a 1..9 -> 切換到第 1..9 個window
C-a t -> Time，顯示當前時間，和系統的 load
C-a K(大寫) -> kill window，強行關閉當前的 window</pre> 上面這些是我比較常用的指令，C-a c 就是 Ctrl A + C，非常好懂，如何跳出 screen 呢，可以利用 exit 離開目前的 screen 視窗，但是如果要讓它繼續跑，兒只是不想用 screen，可以利用 Ctrl+A + D的方式跳出 screen 那下次再登入 shell 的時候，可以利用 screen -r 的指令來恢復到上一個 screen，也可以利用 screen -ls 來觀看目前有哪一個 screen 正在運作： 

[<img src="https://i1.wp.com/farm4.static.flickr.com/3624/3343161001_a2b02f630a.jpg?resize=466%2C162&#038;ssl=1" title="screen-1 (by appleboy46)" alt="screen-1 (by appleboy46)" data-recalc-dims="1" />][3] 大家可以看到 25101 這個 number，那如果要轉換到 25101 這一個 screen，那就下 screen -r 25101 這樣就可以了，那如果發現該 screen 是 attached，那可以利用 screen -d [number] -> 強制 detach，以便「接手」過來。 參考文章： [Linux 底下 「screen」指令的使用][4]

 [1]: http://www7.tw.freebsd.org/
 [2]: http://www.freshports.org/
 [3]: https://www.flickr.com/photos/appleboy/3343161001/ "screen-1 (by appleboy46)"
 [4]: http://blog.roodo.com/albertarea/archives/3358957.html