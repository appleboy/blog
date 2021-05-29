---
title: '[UNIX] bash 記憶指令 For Linux'
author: appleboy
type: post
date: 2007-12-23T14:00:56+00:00
url: /2007/12/unix-bash-記憶指令-for-linux/
views:
  - 3030
bot_views:
  - 550
dsq_thread_id:
  - 247276200
categories:
  - FreeBSD
  - Linux
tags:
  - bash
  - Linux

---
在 FreeBSD 裡面，要做到這樣非常方便，當我們在終端機輸入 vi 之後按下 Up 鍵，終端機會顯示之前下過的 vi 指令，這在常常使用 command 的使用者來講相當方便，也非常重要，在 FreeBSD 底下，只要在 .cshrc 裡面加上 

> bindkey &#8220;^W&#8221; backward-delete-word bindkey -k up history-search-backward bindkey -k down history-search-forward  可是在 linux 底下要如何達到這樣呢，那就是 man bash『history-search-backward』，『history-search-forward』這兩個功能，對我來說非常重要，然而你要達到這功能，就是利用 showkey 跟 bind 這兩個指令 首先你要先找到 Up 這個鍵的 16 位元的編碼 

<pre class="brush: bash; title: ; notranslate" title="">showkey -a

Press any keys - Ctrl-D will terminate this program

^[[A     27 0033 0x1b
         91 0133 0x5b
         65 0101 0x41
</pre> 然後在 bind 上去，寫到 /etc/bashrc 地下就可以了 

<pre class="brush: bash; title: ; notranslate" title="">bind '"\x1b\x5b\x41":history-search-backward'
bind '"\x1b\x5b\x42":history-search-forward'</pre> 我之前有寫一篇 

[[Ubuntu] bash 記憶指令][1]，也可以參考看看

 [1]: http://blog.wu-boy.com/2007/02/01/65/