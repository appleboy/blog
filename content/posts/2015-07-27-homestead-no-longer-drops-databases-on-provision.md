---
title: Laravel Homestead 2.1.5 版本將不再刪除舊有資料庫
author: appleboy
type: post
date: 2015-07-27T01:14:05+00:00
url: /2015/07/homestead-no-longer-drops-databases-on-provision/
dsq_thread_id:
  - 3974161030
categories:
  - Laravel
  - php
tags:
  - Homestead
  - Laravel
  - Laravel Homestead

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6248708214/" title="Laravel PHP Framework by appleboy46, on Flickr"><img src="https://i0.wp.com/farm7.static.flickr.com/6038/6248708214_ef1133d0e9_o.png?resize=283%2C101&#038;ssl=1" alt="Laravel PHP Framework" data-recalc-dims="1" /></a>
</div>

[Laravel Homestead][1] 提供一套虛擬機器，讓開發者可以快速將 Laravel 環境架設起來。在 2.1.5 版本以前，要新增新的 Site 都會透過修改 yaml 設定檔後，直接下 homestead `provision` 來重新啟動 VM，問題就來了，此指令會將現有的 Database 全部刪除，重先建立一次，這樣開發者就要重新跑 DB Migration 才有資料。此問題作者聽到了，所以在 `2.1.5` 版本作者拿掉 Drop Database 指令，而是透過 CREATE DATABASE IF NOT EXISTS 來取代原有指令 (下面程式碼)，這樣開發者就不用擔心資料會被刪除。當然作者也很貼心，如果開發者想要清除整個資料庫，一樣可以透過指令 homestead `destroy` 來將整個 VM 刪除即可。

<div>
  <pre class="brush: sql; title: ; notranslate" title="">
// 取代原有 mysql -uhomestead -psecret -e "DROP DATABASE IF EXISTS \`$DB\`";
mysql -uhomestead -psecret -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";</pre>
</div>

詳細的資訊可以參考 [official documentation][1]，或參考最近修改的 [commit 內容][2]。

 [1]: http://laravel.com/docs/master/homestead
 [2]: https://github.com/laravel/homestead/commit/f2931d94d9598c330925e3ceb45fccd50c66bcae