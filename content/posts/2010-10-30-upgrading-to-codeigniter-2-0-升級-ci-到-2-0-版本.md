---
title: Upgrading to CodeIgniter 2.0 (升級 CI 到 2.0 版本)
author: appleboy
type: post
date: 2010-10-30T06:10:49+00:00
url: /2010/10/upgrading-to-codeigniter-2-0-升級-ci-到-2-0-版本/
views:
  - 2315
bot_views:
  - 177
dsq_thread_id:
  - 246719337
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
**2011.02.09 Update: 由於官方推出 2.0.0 的升級方式，請參考[升級版本 1.7.3 到 2.0.0][1]** 

<div style="margin: 0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 在國外文章看到 

[Phil Sturgeon][2] 已在今年三月發佈了一篇如何將目前 [CodeIgniter][3] 版本升級到 2.0 開發版本，轉移的經驗會在底下做介紹，[PyroCMS][4] 是該作者產品之一，也升級到 2.0 了，大家可以參考看看。 <!--more-->

### 1. 取得最新開發版 從 

[BitBucket][5] 下載 [最新版本][6]。 

### 2. 資料夾架構改變 CodeIgniter 2.0 資料夾架構有些改變，原本 application 放在 system 目錄裡面，現在要將 application 移動到上一層，也就是會跟 system 目錄同一層: CI 1.7.2 之前: 

<pre class="brush: php; title: ; notranslate" title="">system/application
system/
index.php </pre> CI 2.0 目前 

<pre class="brush: php; title: ; notranslate" title="">system/
application/
index.php
</pre> 刪除 system 目錄，之後將 2.0 的 system 取代，並且複製底下檔案到您的根目錄 

<pre class="brush: bash; title: ; notranslate" title="">index.php
application/config/foreign_chars.php
application/config/profiler.php</pre>

### 3. 修改 models 目錄所有檔案 原先 CodeIgniter Models 必須遵照底下的格式撰寫 

<pre class="brush: php; title: ; notranslate" title="">class Blog_model extends Model</pre> CodeIgniter 2.0 將會改成 

<pre class="brush: php; title: ; notranslate" title="">class Blog_model extends CI_Model</pre> 也不需要問為什麼要改成這樣，改就對了 ^^。 

### 4. 轉換 Plugin 到 helper 大家有看過之前發表的一篇：『

[CodeIgniter 2.0 的發展以及特性改變][7]』2.0 將會廢除 Plugin，所以必須將自己撰寫的 plugin 通通移動到 <span style="color:green">application/helpers</span> 目錄，並且將所有檔名全部從 whatever\_pi.php 轉換 whatever\_helper.php 。 請打開 <span style="color:green">application/config/autoload.php</span>，將 <span style="color:red">$autoload['plugins']</span> 資料轉到 <span style="color:red">$autoload['helpers']</span>，這樣大致就可以了。 

### 5. 取代舊有的驗證 您可以透過底下方法解決： 

  * 改用新的表單驗證 ([參考線上文件][8])
  * 抓舊的 [Validation.php][9]，將其放入到 application/libraries/ 目錄

### 6. MY_Controller 和其他一些 extended libs CI 2.0 將建立 

<span style="color:red">system/core</span> 目錄，並且將 libraries 跟核心檔案全部放入到此目錄(像是 Router, Loader and Controller)，以前原本放在 system/libraries 一些檔案(像是 Input, Lang, Output...等)也會移動到 core 裡面，所以假如您之前開發的 extend library，必須將其檔案移動到 /application/core/ 目錄。 

### 7. CI_Language 重新命名 Language clas 原先是在 

<span style="color:green">system/libraries/Language.php</span>，現在轉移到 <span style="color:green">system/core/Lang.php</span>，並且將 <span style="color:red">CI_Language</span> 名稱換成 <span style="color:red">CI_Lang</span>，如果您有用到此 class 請務必轉換名稱 

### 8. 正式移除一些 DB method 在 1.6.x DB 一些舊有的 method orwhere, orlike, groupby, orhaving, orderby and getwhere，在 1.7.2 版本還是有保留，但是在 2.0 完全被移除了，如果您的專案裡面有這些寫法，請麻煩修正 

### 9. 關閉 query strings 個人認為既然使用了 CI，就不要將此功能打開，在 2.0 打開 

<span style="color:green">$config['enable_query_strings']</span>，您的 url 產生成 http://example.php/index.php?/controller 或 http://example.php/?/controller，所以必須將 enable\_query\_strings 改成 false，但是您想要用 $_GET 的話，可以在 Controller 或 hook 加入底下程式 

<pre class="brush: php; title: ; notranslate" title="">parse_str($_SERVER['QUERY_STRING'], $_GET);</pre> 參考： 

[Upgrading to CodeIgniter 2.0][10]

 [1]: http://www.codeigniter.org.tw/user_guide/installation/upgrade_200.html
 [2]: http://philsturgeon.co.uk
 [3]: http://CodeIgniter.com
 [4]: http://pyrocms.com/
 [5]: https://bitbucket.org/ellislab/codeigniter/overview
 [6]: http://bitbucket.org/ellislab/codeigniter/get/tip.zip
 [7]: http://blog.wu-boy.com/2010/10/03/2402/
 [8]: http://codeigniter.com/user_guide/libraries/form_validation.html
 [9]: http://bitbucket.org/ellislab/codeigniter/raw/3b6f3beea126/system/libraries/Validation.php
 [10]: http://philsturgeon.co.uk/news/2010/05/upgrading-to-codeigniter-2.0