---
title: '[WordPress] Upgrade 2.2.x to 2.5 無痛升級法 For Linux or FreeBSD'
author: appleboy
type: post
date: 2008-04-16T07:55:22+00:00
url: /2008/04/wordpress-upgrade-22x-to-25-無痛升級法-for-linux-or-freebsd/
views:
  - 2903
bot_views:
  - 749
dsq_thread_id:
  - 249459686
categories:
  - blog
  - FreeBSD
  - Linux
  - php
  - windows
  - wordpress
  - www
tags:
  - FreeBSD
  - Linux
  - wordpress

---
今天終於決定升級 [wordpress][1] 的版本了，之前剛安裝好，都沒有時間去升級，剛剛去升級一下，發現其實步驟不會很複雜，所以一下子都弄好了，除非你的外掛很多，不然升級一定還蠻快的，我最後花的時間幾乎都是在升級 [wordpress plugin][2]，當然我是先去測試我的另一個生活部落格：[life.wu-boy.com][3]，目前看起來是沒有什麼問題，所以待會會來生及其他的 [wordpress blog][4]，底下來操作一遍吧 步驟一：備份資料庫，可以參考這篇 [[Mysql] 資料庫備份[big5]utf8轉換成utf-8][5] 

<pre class="brush: bash; title: ; notranslate" title="">#
# 備份方式
#
mysqldump -u root -p database_name > db_backup_name.sql
</pre>

<!--more--> 步驟二：備份你 wordpress 資料夾 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 Linux 的 cp 指令即可
#
cp -R wordpress wordpress_backup
</pre> 步驟三：去後台停用你的所有外掛：

[Administration panel][6] 這步驟很重要，避免升級的時候發生錯誤，請全部停用，因為有些外掛可能因為升級而沒有作用 步驟四：下載 wordpress 最新版本，目前最新就是 2.5 版： [zip版本][7]，[tar.gz 版本][8] 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 wget 的方式去下載
#
wget http://wordpress.org/latest.tar.gz
#
# 解壓縮
#
gunzip -c wordpress-2.5.tar.gz | tar -xf - 
#
# or by using:  
#
tar -xzvf latest.tar.gz
</pre> 步驟五：刪除原本資料夾的部份檔案 底下是不要刪除的喔 

<pre class="brush: bash; title: ; notranslate" title="">#
# 底下檔案請麻煩備份，以免發生錯誤
#
wp-config.php file;
wp-content folder;
wp-images folder--only older installations from 1.5.x days will have this folder;
#
# 語系檔案資料夾，如果有安裝請勿刪除
#
wp-includes/languages/
#
# 網站 rewrite rule 這個也請保留
#
.htaccess file
</pre> 底下是必須刪除的喔 

<pre class="brush: bash; title: ; notranslate" title=""># 
# 刪除
#
wp-* (except for those above), readme.html, wp.php, xmlrpc.php, and license.txt;
#
# 請勿刪除到 wp-config.php file
# 
wp-admin folder;
#
# 請勿刪除到 wp-includes/languages/ 
#
wp-includes folder;
#
# 如果你是從 2.0 升級上來，請刪除底下資料夾
#
wp-content/cache folder;
</pre> 要如何刪除會比較好，底下介紹 Linux 的作法 

<pre class="brush: bash; title: ; notranslate" title="">#
# 這裡步驟寫的很清楚
#
mkdir backup
cp wp-config.php .htaccess backup
cp -R wp-content backup
rm wp*.php .htaccess license.txt readme.html xmlrpc.php
rm -rf wp-admin wp-includes
cp backup/wp-config.php . 
</pre> 步驟六：上傳最新的檔案 只要是剛剛有刪除的，你就要用新的檔案回去 

<pre class="brush: bash; title: ; notranslate" title="">#
# 上傳好，把舊資料弄回來
#
.htaccess
wp-content folder
wp-config.php
</pre> 步驟七：升級資料庫：請打入你的網址：http://xxxx.xxxx.com/wp-admin/upgrade.php 

[<img src="https://i0.wp.com/farm3.static.flickr.com/2025/2417889136_42c8bd2ff9.jpg?resize=500%2C166&#038;ssl=1" title="wordpress_upgrade_1 (by appleboy46tream)" alt="wordpress_upgrade_1 (by appleboy46tream)" data-recalc-dims="1" />][9] 然後按下一步就升級完成了 然後在進入後台，把所有外掛啟動就可以了，後台畫面也改很多喔，還多加了 tag 的功能，相當不錯 [<img src="https://i1.wp.com/farm3.static.flickr.com/2256/2417092513_995e155787.jpg?resize=500%2C289&#038;ssl=1" title="wordpress_upgrade_2 (by appleboy46)" alt="wordpress_upgrade_2 (by appleboy46)" data-recalc-dims="1" />][10] [<img src="https://i1.wp.com/farm3.static.flickr.com/2081/2417911122_4671c8d659.jpg?resize=500%2C220&#038;ssl=1" title="wordpress_upgrade_3 (by appleboy46)" alt="wordpress_upgrade_3 (by appleboy46)" data-recalc-dims="1" />][11] 畫面超棒，希望大家都可以升級成功喔 參考網站： [http://codex.wordpress.org/Upgrading\_WordPress\_Extended][12]

 [1]: http://wordpress.org/
 [2]: http://wordpress.org/extend/plugins/
 [3]: http://life.wu-boy.com
 [4]: http://blog.wu-boy.com/
 [5]: http://blog.wu-boy.com/2007/04/08/92/
 [6]: http://codex.wordpress.org/Administration_Panels
 [7]: http://wordpress.org/latest.zip
 [8]: http://wordpress.org/latest.tar.gz
 [9]: https://www.flickr.com/photos/appleboy/2417889136/ "wordpress_upgrade_1 (by appleboy46tream)"
 [10]: https://www.flickr.com/photos/appleboy/2417092513/ "wordpress_upgrade_2 (by appleboy46)"
 [11]: https://www.flickr.com/photos/appleboy/2417911122/ "wordpress_upgrade_3 (by appleboy46)"
 [12]: http://codex.wordpress.org/Upgrading_WordPress_Extended