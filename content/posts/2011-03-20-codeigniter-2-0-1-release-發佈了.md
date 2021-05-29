---
title: CodeIgniter 2.0.1 Release 發佈了
author: appleboy
type: post
date: 2011-03-20T04:44:55+00:00
url: /2011/03/codeigniter-2-0-1-release-發佈了/
views:
  - 330
bot_views:
  - 177
dsq_thread_id:
  - 258501159
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<div style="margin: 0 auto; text-align: center;">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 很高興可以聽到這消息，那就是 

[CodeIgniter Release 2.0.1][1] 版本了，原本大家都很擔心為什麼 [CodeIgniter][2] 每發佈 Release 版本都要等個好幾個月甚至到半年以上，現在不用這麼久了，因為自從官方新增了 [CodeIgniter Reactor][3] 加速版本開發及修正，所以更多人貢獻了自己的程式碼及回報問題，我相信 CodeIgniter 會越來越好，希望有更多台灣的朋友來使用。 2.0.1 版本新增了 ENVIRONMENT 這環境變數，讓程式開發者可以任意調整環境狀況，最主要是改變 [PHP error reporting][4] 狀態: 

<pre class="brush: php; title: ; notranslate" title="">/*
 * production => error_reporting(0)
 * development => error_reporting(E_ALL)
 */
define('ENVIRONMENT', 'production');</pre> 當您設定為 production，表示網站不需要任意輸出錯誤訊息，如果調整成 development，系統就會打開全部錯誤訊息，這對開發者相當重要。如果想瞭解更多，請參考 

[Handling Multiple Environments][5]。 歡迎大家下載最新版本: <http://www.codeigniter.org.tw/downloads> 如果想加入翻譯團隊，可以參考這裡: <https://github.com/appleboy/PHP-CodeIgniter-Framework-Taiwan>

 [1]: http://www.codeigniter.org.tw/blog/codeigniter_2.0.1_released
 [2]: http://www.codeigniter.org.tw
 [3]: https://bitbucket.org/ellislab/codeigniter-reactor
 [4]: http://php.net/manual/en/function.error-reporting.php
 [5]: http://codeigniter.org.tw/user_guide/general/environments.html