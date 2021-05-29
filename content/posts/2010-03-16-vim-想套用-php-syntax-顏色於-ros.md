---
title: '[Vim] 想套用 *.php syntax 顏色於 *.ros'
author: appleboy
type: post
date: 2010-03-16T05:38:43+00:00
url: /2010/03/vim-想套用-php-syntax-顏色於-ros/
views:
  - 3606
bot_views:
  - 397
dsq_thread_id:
  - 249730274
categories:
  - FreeBSD
  - Linux
tags:
  - FreeBSD
  - Linux
  - Vim

---
[<img src="https://i2.wp.com/farm5.static.flickr.com/4018/4436671479_0596c469d4_o.gif?resize=180%2C45&#038;ssl=1" alt="vim_header" data-recalc-dims="1" />][1] [Vim][2] 是一套強大的編輯器，它分佈於各大 UNIX systems，安裝好一套 UNIX 系統，預設就是 Vi 編輯器([FreeBSD][3] 預設是 ee)，相當好用，他也支援各種語言的 syntax，讓您在編輯檔案能夠看到各種不同顏色，在 FreeBSD 底下可以去看 /usr/local/share/vim/vim64/syntax/ 該資料夾支援各種語言，例如 PHP、Ruby、css、html、java、C/C++…等，假設今天我們想要 .ros 的副檔名需要用 php.vim syntax 來開啟，就必須做底下設定： 執行底下： 

<pre class="brush: bash; title: ; notranslate" title="">mkdri ~/.vim
vi ~/.vim/filetype.vim </pre> 寫入 filetype.vim 資訊 if version < 600 syntax clear elseif exists("b:current_syntax") finish endif augroup filetypedetect au! BufRead,BufNewFile *.ros setfiletype php augroup END[/code] ps. on freebsd 7.1-RELEASE-p11 vim version 6.4.9 reference: 

[Vim 套用 Markdown syntax][4] [vi 設定][5]

 [1]: https://www.flickr.com/photos/appleboy/4436671479/ "Flickr 上 appleboy46 的 vim_header"
 [2]: http://www.vim.org/
 [3]: http://www.freebsd.org
 [4]: http://fourdollars.blogspot.com/2009/05/vim-markdown-syntax.html
 [5]: http://blog.longwin.com.tw/archives/000021.html