---
title: '[新聞] CodeIgniter 發佈 2.0.0 版 Release'
author: appleboy
type: post
date: 2011-02-01T05:49:46+00:00
url: /2011/02/新聞-codeigniter-發佈-2-0-0-版-release/
views:
  - 1038
bot_views:
  - 158
dsq_thread_id:
  - 249466502
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<div style="margin: 0 auto; text-align: center;">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 繼上次 

[[新聞] PHP Framework Codeigniter 1.7.3 釋出 Release][1] 之後，[官方][2]終於釋出 2.0 的版本，消息來源: [http://codeigniter.com/news/codeigniter\_2.0.0\_released/][3]。 [CodeIgniter][4] 發展其實還蠻慢的，所以很多工程師都跳去其他 PHP Framework 了，然而我始終認為 CI 是一套非常好學習的初階 Framework，希望更多人來使用，底下是 2.0 發佈相關新聞，大家可以參考看看到底做了哪些改變以及 Fix Bug list: <!--more-->

### CodeIgniter 發佈 2.0.0 版 今天 EllisLab 和 CodeIgniter Reactor 的工程師們高興的宣佈：CodeIgniter 2.0.0 的第一個官方版本終於出來了！它有底下兩個版本（或分支）: 

### CodeIgniter Core 版 Core 版是一個更新較慢的版本，它將是 EllisLab 商業產品的基礎，例如 ExpressionEngine 和 MojoMotor 等相關產品。Core 版的更新頻率將會跟之前 CodeIgniter 差不多，這版本將適用於對穩定性與版本相容性要求較高的大型網站，或一些對 SLA 有依賴的企業產品，程式碼可於 

[BitBucket 下載][5] 

### CodeIgniter Reactor 版 Reactor 版本是 community driven 分支，這提供最快，也是最新的程式碼，這意味著大家可以提交 Bug 到此版本，新功能的改進，文件修改…等，此團隊有程式碼審核小組，這些工程師負責推動 Reactor 版本發展及維護。 只要是 EllisLab 的新功能及特性都將會被合併倒 Reactor 版本，EllisLab 也會積極推動 Reactor 版本發展，所以 Reactor 會是官方建議使用的版本，所以只要在官網上面看到 CodeIgniter，它就是指 Reactor 版本，在論壇中或者是文件裡都是這樣，簡單來說，CodeIgniter = Reactor。 CodeIgniter 從 1.7.3 到 2.0 的主要變化是： 

  * 不再支援 PHP4，最低 PHP 版本需求是 5.1 版
  * 表單函數開始支援 CSRF 保護
  * Drivers
  * Application package
  * Scaffolding 在前幾個版本已經不再使用，現在已經移除了
  * 刪除過時的驗證功能
  * 刪除 Plugin 改用補助函數取代
  * 重新撰寫 index.php 程式碼 routing overrides
  * 新增 $route[『404_override']，可以讓 Controller 使用
  * 50 個以上的 Bug 修正 Reactor 版包含上面的所有修正與特性，並且它自己也有一些優勢： 

  * 完全支援 query-string
  * 自動偵測 base_url 是否為空字串
  * 新的快取機制功能，支援 APC and memcache
  * 針對 corn job 支援 command line
  * 20個以上調整改進 可以參考線上 

[change log][6] 來詳細觀看修改與調整。 官方工作團隊將會在 2011 第一季完成底下特性： 

### 使用手冊留言功能 使用者可以在 User Guide 進行留言討論，就如同 

[php.net][7] 網站一樣，隨著時間改變，會讓使用手冊更加有用，新的留言系統將可以保留舊的訊息，以及新的評論。 

### 身份驗證功能 這已經經過長久要求的認證 Library (總共有 800 多票支持此功能 

[UserVoice][8])，不過這需要花些時間來驗證及證明，我們要想一個通用解決方法，讓使用者不會過於複雜。 

### A More Object-like Model 這個功能就是允許 Active Record 返回一個代表當前結果的 Model 的範例。這將允許以更接近語義的方式處理資料庫的內容。 相比過去，現在 CodeIgniter 是一個更加 community-oriented framework。你可以通過 BitBucket 或 Phil 的 GitHub 提交 pull 請求。你還會看到更頻繁的發布新版本。 你還在等什麼？請立即

[下載][9]並開始使用！ - Reactor 團隊 台灣 CodeIgniter 繁體中文 : [http://www.codeigniter.org.tw/blog/codeigniter\_2.0.0\_released][10]

 [1]: http://blog.wu-boy.com/2010/12/07/2488/
 [2]: http://codeigniter.com
 [3]: http://codeigniter.com/news/codeigniter_2.0.0_released/
 [4]: http://codeigniter.com/
 [5]: http://bitbucket.org/ellislab/codeigniter
 [6]: http://codeigniter.com/user_guide/changelog.html
 [7]: http://www.php.net
 [8]: http://codeigniter.uservoice.com/
 [9]: http://codeigniter.com/download
 [10]: http://www.codeigniter.org.tw/blog/codeigniter_2.0.0_released