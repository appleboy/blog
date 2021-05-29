---
title: CodeIgniter 2.0 的發展以及特性改變
author: appleboy
type: post
date: 2010-10-02T18:20:58+00:00
url: /2010/10/codeigniter-2-0-的發展以及特性改變/
views:
  - 3225
bot_views:
  - 244
dsq_thread_id:
  - 246803553
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter

---
<div style="margin: 0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 在今年3月11日 

[EllisLab][1] 發布了一則[新訊息][2]，信件內容大致上提到，他們將會改變程式的版本控制軟體，由原本的 [Subversion][3] 轉換到 [Mercurial][4]，CodeIgniter 也選擇了網路知名版本控制 [BitBucket][5] 網站來存放 CI 的程式碼，CI 團隊目前致力於 CodeIgniter 2.0 作開發，如果要取得程式碼，可以透過[這裡][6]，利用底下指令來取得: 

<pre class="brush: bash; title: ; notranslate" title="">hg clone http://bitbucket.org/ellislab/codeigniter</pre> 這次我們來看看 CodeIgniter 2.0 跟 1.7.2 的版本差異性，雖然說這些不是官方公告的，可是也是改變蠻多的，也許有哪些沒有列到的，之後再慢慢補: 

**<span style="color:red">1. PHP4 正式掰掰</span>** 我想使用 CI 最方便的地方，就是支援 PHP5 & PHP4，方便使用者轉換網站到 CI 上面，現在 CI 2.0 之後將完全不支援 PHP4，一些舊有的函式會在 2.1 之後也不支援 PHP4 了，我想這樣整個 CI 的架構會縮小許多，PHP4 也太多漏洞了，這樣跟 [Kohana PHP Framwork][7](原本從 CI branch 出來的) 一樣只會支援 PHP5 了，效能應該可以增加不少 **<span style="color:red">2. Scaffolding 正式移除</span>** [Scaffolding][8] 對於沒有後台管理的網站，臨時可以修改新增或者是刪除資料庫，不過相當危險，所以 CI 正式移除它，可以看一下[中文文件][9]。 **<span style="color:red">3. 重新命名核心資料夾</span>** 將 <span style="color:green">system/codeigniter/</span> 名稱變成 <span style="color:green">system/core/</span>，核心程式 Router, Loader, Output 等，都可以用 application/core 之中去替換([參考][10]) **<span style="color:red">4. system/plugins/ 正式走入歷史</span>** 其實本來就沒有必要有這資料夾，這跟 library 有衝突性的，應該說很類似差不多，我真的不知道為什麼會有此資料夾 **<span style="color:red">5. 正式支援 jQuery</a></span>** CI 開始支援 [jQuery][11]，檔案 (system/libraries/javascript/Jquery.php) 這跟 database library 差不多 ，之後陸續更多 javascript 支援([參考][12]) **<span style="color:red">6. 新增 Drivers Library 功能</span>** 這功能在 Kohana 這套 Framework 已經實做出來，這對於 CI 是一個新的 Library，他能擁有一個父類(parent class)，可以很多子類(child classes)，最好的範例就是 JavaScript library，他是一個 parent class，而 jQuery Driver 是 child class，還有其他例子，例如 Cache class 它底下就會有 Memcache, APC 等諸如此類的 Driver。 **<span style="color:red">7. 新增 /third_party/ 資料夾</span>** 在 application 裡面會多出 third_party 資料夾，它會提供最基本的一些資料夾，包含 libraries, models, helpers, 等，架構如下 

<pre class="brush: bash; title: ; notranslate" title="">/system/application/third_party/foo_bar
config/
helpers/
language/
libraries/
models/</pre>

**<span style="color:red">8. Cookie helper 改變</span>** 將 <span style="color:green">system/helpers/cookie_helper.php</span> 拉出來整合到 Input Class。([參考][13]) 目前大致上列出上面比較重要的，其他的可以參考底下連結: [CodeIgniter 2.0 and Mercurial Transition][14] [CodeIgniter 2.0 In Progress – The Critical Changes, Implications, and What You Should Know][15] [CodeIgniter 2.0: Everything you need to know][16]

 [1]: http://www.ellislab.com/
 [2]: http://codeigniter.com/news/ellislab_moves_to_mercurial_assembla_bitbucket_codeigniter_2.0_baking/
 [3]: http://zh.wikipedia.org/zh-tw/Subversion
 [4]: http://zh.wikipedia.org/zh-tw/Mercurial
 [5]: http://bitbucket.org/
 [6]: http://bitbucket.org/ellislab/codeigniter/
 [7]: http://kohanaframework.org/
 [8]: http://codeigniter.com/user_guide/general/scaffolding.html
 [9]: http://www.codeigniter.org.tw/user_guide/general/scaffolding.html
 [10]: http://bitbucket.org/ellislab/codeigniter/src/tip/system/core/
 [11]: http://jquery.com/
 [12]: http://bitbucket.org/ellislab/codeigniter/src/tip/system/libraries/Javascript.php
 [13]: http://bitbucket.org/ellislab/codeigniter/src/tip/system/helpers/cookie_helper.php
 [14]: http://www.michaelwales.com/2010/03/codeigniter-2-0-and-mercurial-transition/
 [15]: http://www.haughin.com/2010/03/11/codeigniter-2-critical-changes-implications/
 [16]: http://philsturgeon.co.uk/news/2010/03/codeigniter-2