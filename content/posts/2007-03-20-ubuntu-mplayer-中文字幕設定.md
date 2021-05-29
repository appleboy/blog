---
title: '[ubuntu] Mplayer 中文字幕設定'
author: appleboy
type: post
date: 2007-03-20T13:59:36+00:00
url: /2007/03/ubuntu-mplayer-中文字幕設定/
views:
  - 8138
bot_views:
  - 1021
dsq_thread_id:
  - 246887364
categories:
  - Linux
  - Ubuntu

---
先安裝 w32codecs 

> apt-get install w32codecs Ubuntu 的 Mplayer 中文字幕設定，這是我一直搞不定的東西，後來上網找了一下文章發現用以下解法就ok了 用管理者權限編輯以下檔案 

> /etc/mplayer/mplayer.conf 加入以下內容 

> subcp=cp950 font=/usr/share/fonts/truetype/arphic/ukai.ttf subfont-text-scale=3  結束。字型可以換成自己想要的字型，打開就可以看中文字幕阿。 註：影片檔跟字幕檔要同檔名 不過還有一點，就是你原本就有對mplayer設定一些東西，麻煩先刪除 

> rm -rf ~/.mplayer/  這樣才不會影響 Mplayer 設定