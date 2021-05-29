---
title: '[Ubuntu] bash 記憶指令'
author: appleboy
type: post
date: 2007-02-02T03:10:31+00:00
url: /2007/02/ubuntu-bash-記憶指令/
views:
  - 4254
bot_views:
  - 866
dsq_thread_id:
  - 246785058
categories:
  - Linux
  - Ubuntu
tags:
  - bash
  - Linux

---
之前 在 linux連線版有問過大家 如果讓bash 有像 freebsd cshrc的記憶功能 可以按上下鍵 就可以顯示出 以前用過的指令 比如說 我輸入 cat 然後按上 就會出現 cat /etc/bash.bashrc 結果我在 將下面寫入到　**<span style="color:green">/etc/bash.bashrc</span>** 

<pre class="brush: bash; title: ; notranslate" title="">bind \
 '"\C-n": history-search-forward' \
 '"\M-OB": history-search-forward' \
 '"\M-[B": history-search-forward' \
 '"\C-p": history-search-backward' \
 '"\M-OA": history-search-backward' \
 '"\M-[A": history-search-backward'</pre>

<!--more--> 不過上面的作法 可以用在 redhat系列 但是ubuntu跟 debian卻沒辦法 結果我最近在linux連線版 發現有人有解達 只要在 ~/.bashrc 裏面寫上 

<pre class="brush: bash; title: ; notranslate" title="">bind '"\x1b\x5b\x41":history-search-backward'
bind '"\x1b\x5b\x42":history-search-forward'</pre> 這樣就可以了，下面是 linux連線版 zxvc.bbs@ptt.cc 大大寫的 

> 如果想知道bash有多少好用的hotkey， 只要man bash，然後搜尋『history-search-backward』， 就可以在history-search-backward附近找到一堆hotkey。 或者在bash中輸入 $ bind -p 也可以看到很多hotkey，只不過沒有詳細說明。 另外『\M-』這個prefix在一般PC鍵盤上代表的是ESC key， 這man bash也是可以查得到。 如果想知道某個按鍵的keymap(例如Up鍵)，可以在『純終端機』 (我不清楚為什麼虛擬終端機會不能用showkey)輸入 $ showkey -m 查到，但是這是10進位的值，要把它轉成16進位再加上『\x』 才可以跟某個function bind在一起。 例如：Up鍵與history-search-backward bind在一起： $ bind &#8216;&#8221;\x1b\x5b\x41&#8243;:history-search-backward&#8217;