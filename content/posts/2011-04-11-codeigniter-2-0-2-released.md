---
title: CodeIgniter 2.0.2 Released
author: appleboy
type: post
date: 2011-04-11T02:39:17+00:00
url: /2011/04/codeigniter-2-0-2-released/
views:
  - 167
bot_views:
  - 165
dsq_thread_id:
  - 276364669
categories:
  - CodeIgniter
tags:
  - CodeIgniter

---
<div style="margin: 0 auto; text-align: center;">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 很高興看到 

[CodeIgniter][1] 又推出新版 2.0.2 Released，這次升級最主要是針對**<span style="color:red">安全性的漏洞</span>**，以及一些 bug 修正，升級步驟也非常簡單，可以參考 [Upgrading from 2.0.1 to 2.0.2][2]，只要把 Core 核心檔案換掉，還有如果在程式碼有載入 [Security Library][3] 的地方全部取消，看底下： 舉例 Example: 

<pre class="brush: php; title: ; notranslate" title="">$this->load->library("security");</pre> 如果程式碼有用到上面部份，請將其拿掉，因為現在系統已經將 Security Library 加入核心一部分提高整個網站安全性。如果要想知道 2.0.2 做了哪些修正，可以參考 

[Change log][4]。

 [1]: http://www.codeigniter.org.tw
 [2]: http://www.codeigniter.org.tw/user_guide/installation/upgrade_202.html
 [3]: http://www.codeigniter.org.tw/user_guide/libraries/security.html
 [4]: http://www.codeigniter.org.tw/user_guide/changelog.html#2.0.2