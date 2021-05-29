---
title: '[Vim] 將 Tab 轉換成 Space'
author: appleboy
type: post
date: 2010-08-25T04:19:23+00:00
url: /2010/08/vim-將-tab-轉換成-space/
views:
  - 3920
bot_views:
  - 362
dsq_thread_id:
  - 246704418
categories:
  - www
tags:
  - Vim

---
Update 2010.08.28: [**Pspad 轉換既有 Tabs to Spaces**][1] by [bootleq][2]

[<img src="https://i0.wp.com/farm5.static.flickr.com/4080/4925098933_f7fb7a1312_o.gif?resize=180%2C45&#038;ssl=1" alt="vim_header" data-recalc-dims="1" />][3] 為了統一 Windows 跟 Linux 底下的編輯器在使用 Tab 功能相同，所以調整了 [Vim][4] 及 [Pspad][5](我常用編輯器)的設定，底下是針對 Vim 及 Pspad 的解決方法。首先當大家使用 Vim 編輯器撰寫程式，常常會使用 Tab 來縮排程式碼，我們可以使用 <span style="color:green"><strong>expandtab</strong></span> 來插入空白鍵(Space)取代 Tab:

```bash
:set expandtab
```

控制插入 Tab 時所需要的空白鍵(Tab)字元數，例如用4個空白鍵取代 Tab:

```bash
:set tabstop=4
```

在我們設定完 <span style="color:green"><strong>expandtab</strong></span> 之後，所有的 Tab 鍵將會被 Space 所取代，但是原本在檔案文件中的 Tab 將不會改變，為了取代原有的 Tab 到新的設定，我們必須鍵入：

```bash
:retab
```

針對程式縮排所需要的 Space 個數，我們可以使用 <span style="color:green"><strong>shiftwidth</strong></span> 選項

```bash
:set shiftwidth=4
```

底下舉個例子：

  * 將文件中 Tab 取代成 Space
  * 所有 Tab 用4個 Space 取代

```bash
:set tabstop=4
:set shiftwidth=4
:set expandtab
```

## Pspad 設定

Settings -> Programing Settings -> Editor (Part 2)

設定：

```bash
Tab Width:4
Indent Width:4
```

請勿勾選 Real Tab，如果要把既有的 Tab 轉換成 Space，可以使用: 

**<span style="color:green">編輯</span>→<span style="color:green">特殊轉換</span>→<span style="color:green">將 Tab 轉成空白</span> <span style="color:green">Edit</span>-><span style="color:green">Special conversion</span>-><span style="color:green">Convert Tabs to Spaces</span>**

[<img src="https://i0.wp.com/farm5.static.flickr.com/4076/4925691488_84b0cce659.jpg?resize=500%2C413&#038;ssl=1" alt="Pspad" data-recalc-dims="1" />][6]

針對 Makefile 需要使用 Tab，我們必須在 .vimrc 裡面在加入底下：

```bash
autocmd FileType make setlocal noexpandtab
```

## 參考文章

  * [Converting tabs to spaces][7]

 [1]: #Pspad
 [2]: http://bootleq.blogspot.com/
 [3]: https://www.flickr.com/photos/appleboy/4925098933/ "vim_header by appleboy46, on Flickr"
 [4]: http://www.vim.org/
 [5]: http://www.pspad.com/
 [6]: https://www.flickr.com/photos/appleboy/4925691488/ "Pspad by appleboy46, on Flickr"
 [7]: http://vim.wikia.com/wiki/Converting_tabs_to_spaces