---
title: '[新聞] CodeIgniter v1.7.2 Released'
author: appleboy
type: post
date: 2009-09-16T14:10:03+00:00
url: /2009/09/新聞-codeigniter-v172-released/
views:
  - 5500
bot_views:
  - 496
dsq_thread_id:
  - 250119949
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
[CodeIgniter][1] 終於 Release V1.7.2 版本了，官方網站也公佈了此[消息][2]，那這次跟 v1.7.2 版本有哪些不一樣呢，我想最主要應該是支援 PHP 5.3.0 了 

  * 相容於 PHP 5.3.0
  * 新增 [Cart Class][3] 類別
  * 改善 [Form helper][4] 函數
  * 新增 is_php() 到 [Common functions][5] 來更有善的比較 PHP 版本
  * 無數個 bug 修正
  * 修改 show_error() 函數功能 更多的 bug 修正，可以觀看 

[change log][6]，我也順便了 send-pr 給 FreeBSD ports maintainer 請他 update 到 1.7.2：[ports/138848][7]，台灣的官網也需要來修正了，已經更新了 v1.7.2 上去，至於[繁體中文文件][8]方面還沒更新，有時間會把它更新，如果有任何問題，可以先到[論壇][9]留言找我。

 [1]: http://codeigniter.com/
 [2]: http://codeigniter.com/news/codeigniter_v1.7.2_released/
 [3]: http://codeigniter.com/user_guide/libraries/cart.html
 [4]: http://codeigniter.com/user_guide/helpers/form_helper.html
 [5]: http://codeigniter.com/user_guide/general/common_functions.html
 [6]: http://codeigniter.com/user_guide/changelog.html
 [7]: http://www.freebsd.org/cgi/query-pr.cgi?pr=138848
 [8]: http://www.codeigniter.org.tw/user_guide/
 [9]: http://www.codeigniter.org.tw/forum/