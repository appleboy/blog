---
title: '[Apache] 使用者只能使用 https 進入 mod_rewrite force ssl 進階設定'
author: appleboy
type: post
date: 2007-03-22T16:54:02+00:00
url: /2007/03/apache-使用者只能使用-https-進入-mod_rewrite-force-ssl-進階設定/
views:
  - 7082
bot_views:
  - 1170
dsq_thread_id:
  - 246785193
categories:
  - apache
  - Linux
  - php
  - www

---
最近館內機器我想全部使用上ssl機制會比較安全，之前剛來到 國史館台灣文獻館 的時候，有研究助理對我不爽，說什麼我開發的薪資管理系統，沒有ssl機制，會出現漏洞，囧~導至系統目前只有我在用，哈哈，不過這不是重點~重點是接下來的介紹啦 首先要看看你的機器是否有支援 mod_ssl 目前我用的機器是 CentOS 4.4 所以指令如果有所改變，請自行debug 

> cat /etc/httpd/conf/httpd.conf | grep rewrite LoadModule rewrite\_module modules/mod\_rewrite.so 這樣代表有支援了，那如果沒有支援呢，請用下面指令來新增 

> yum install mod_ssl<!--more--> 主機有支援了以後，想必大家一定想要讓使用者全部都改成ssl來連接主機，可是使用者已經把網站都加入我的最愛了，那要怎麼不改變使用者之下，只改變主機端呢？這就利用 mod_rewrite 囉 其實這個也不是只有一個方法，我先用 php 的方式： 

<pre class="brush: php; title: ; notranslate" title=""><?php
if (!isset($_SERVER["HTTPS"]) || $_SERVER["HTTPS"]!='on')
{
  $ssl_url = 'https://' . $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"];
  header("Location: $ssl_url");
  exit;
}
?>
</pre> 當然上面是利用 php的 $_SERVER 變數來做到的，這個也是一個方法，如果對 rewrite 的 技術還不是很熟的話，可以用上面的方法，當然底下就是 rewrite的作法了 設定 httpd.conf RewriteEngine On ##設定虛擬主機所對應的目錄 <Directory "/var/www/site01"> Options Indexes FollowSymLinks AllowOverride All Order allow,deny Allow from all </Directory> 首先在你的網站根目錄底下新增或編輯 .htpasswd ，如果沒有此檔請新增，然後加入下面語法 RewriteEngine On RewriteCond %{SERVER\_PORT} !443 RewriteCond %{REMOTE\_ADDR} ^192\.168 RewriteRule ^(.\*)$ https://192.168.100.244/dar/$1 [L] RewriteCond %{SERVER\_PORT} 80 RewriteCond %{REMOTE\_ADDR} !^192\.168 RewriteRule ^(.\*)$ https://nas.th.gov.tw/dar/$1 [L] 上面是我的設定，目前我們館內這套系統對外不開放，所以我把ip切割成館內跟館外，挨 因為我們這裡的網管 routing table 不知道怎麼弄的，只要用外部網址去連館內伺服器 就會發生封包繞出去在繞進來現象，所以我才做了此設定，只要是在 192.168.\*.\* 底下的使用者，連進來系統都會轉到 https://192.168.100.244 ，如果是在外面的人，就直接轉到正確網址，這樣才對 上面的 RewriteCond %{SERVER\_PORT} !443 改成 RewriteCond %{SERVER\_PORT} 80 這樣也是可以 參考： 

[Apache Module mod_rewrite][1] 相關： [[Apache] mod_rewrite 實做 防盜圖][2] [為什麼要使用 mod_rewrite？][3]

 [1]: http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html
 [2]: http://blog.wu-boy.com/2006/12/03/50
 [3]: http://blog.gslin.org/archives/2006/05/19/586/