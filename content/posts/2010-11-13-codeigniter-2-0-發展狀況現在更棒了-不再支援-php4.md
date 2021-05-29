---
title: CodeIgniter 2.0 發展狀況(現在更棒了) 不再支援 PHP4
author: appleboy
type: post
date: 2010-11-13T10:54:15+00:00
url: /2010/11/codeigniter-2-0-發展狀況現在更棒了-不再支援-php4/
views:
  - 1824
bot_views:
  - 190
dsq_thread_id:
  - 246757563
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter

---
<div style="margin: 0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div>

[CodeIgniter][1] 在官網正式公告了一篇 2.0 目前的狀況及改善 [CodeIgniter 2.0 - Now with more Awesome][2]，該篇重點莫過於 <span style="color:red"><strong>CI 2.0 將不再支援 PHP 4.0 版本</strong></span>了，這是一項重大改變，官方給目前版本取了一個名稱：<span style="color:green"><strong>CodeIgniterNoPhp4</strong></span>，看到這名字大概就可以知道官方要捨棄 PHP4 了。 自從 CodeIgniter 將所有程式碼搬到 Bitbucket 上面時，就已經宣稱不再 support PHP4，運行了好幾個月，現在以 PHP 5.1.6 來當作開發重點，底下是官方說明 CI 2.0 該注意的地方(其實還有很多地方要注意): 1. 所有類別將以 CI_ 當作前置符號 2. 因為不支援 PHP4 了，所以建構子一律改成 _\_construct 3. CI\_Base 已經被移除，取而代之的是 CI_Controller 4. 之前有提供 [Compatibility 輔助函數][3]，目前已經支援 PHP5 了，故將此移除 開始支援 Email and Validation chaining，看一下範例： 

<pre class="brush: php; title: ; notranslate" title="">$this->email->from('your@example.com', 'Your Name')
            ->to('someone@example.com')
            ->cc('another@another-example.com')
            ->bcc('them@their-example.com')
            ->subject('Email Test')
            ->message('Testing the email class.')
            ->send(); </pre> 最後官方作者有提到一些事情：ExpressionEngine and CodeIgniter 將不再支援 PHP4，PHP4 從2000年出來，到 2007 年結束，重點來了，官方說 

<span style="color:red"><strong>PHP 4 帶給您的困擾，就如同現在 Internet Explorer 6</strong></span>。 可以參考: [What's New in CodeIgniter 2.0][4]

 [1]: http://CodeIgniter.com
 [2]: http://codeigniter.com/news/codeigniter_2.0_-_now_with_more_awesome/
 [3]: http://www.codeigniter.org.tw/user_guide/helpers/compatibility_helper.html
 [4]: http://bitbucket.org/ellislab/codeigniter/wiki/What's%20New