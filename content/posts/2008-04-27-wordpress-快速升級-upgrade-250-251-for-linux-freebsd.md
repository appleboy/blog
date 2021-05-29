---
title: '[wordpress] 快速升級 Upgrade 2.5.0 -> 2.5.1 for Linux & FreeBSD'
author: appleboy
type: post
date: 2008-04-27T06:13:59+00:00
url: /2008/04/wordpress-快速升級-upgrade-250-251-for-linux-freebsd/
views:
  - 3144
bot_views:
  - 937
dsq_thread_id:
  - 258692940
categories:
  - blog
  - FreeBSD
  - Linux
  - wordpress
tags:
  - Upgrade
  - wordpress

---
今天看到 [wordpress][1] 已經 release 出 Version 2.5.1，大家可以去官網下載 [wordpress 2.5.1][2]，不過這次出來的，好像沒有解決 [WordPress 2.5 版本 RSS 摘要無法斷行][3]，所以我又繼續用了大陸人寫的外掛 [wp-CJK-excerpt][4]，官方網有提供升級方法：[官網複雜升級方法][5]，其實我之前有寫一篇也是算是蠻笨的方法：[[Wordpress] Upgrade 2.2.x to 2.5 無痛升級法 For Linux or FreeBSD][6]，然後今天升級的時候，用幾個步驟就可以完成升級的動作了喔，底下就來看看我的升級方法。 <!--more--> 步驟一：先備份自己的資料夾跟資料庫 

<pre class="brush: bash; title: ; notranslate" title="">#
# 利用 cp 指令備份 
#
cp -R Blog Blog_bak
#
# mysql 備份
#
mysqdump -u root -p 資料庫名稱 > wp.sql</pre> 步驟二：去後台關掉所有 wordpress plugin，並把 theme 切換到一個沒用過的 theme，避免首頁發生問題 步驟三：下載最新的 wordpress 檔案： http://wordpress.org/download/ 

<pre class="brush: bash; title: ; notranslate" title="">#
# wget 下載
#
wget http://wordpress.org/latest.zip
#
# 解壓縮
#
unzip latest.zip
#
# 刪除解壓縮好的 wp-content 資料夾
#
rm -rf wordpress/wp-content</pre> 步驟四：copy 舊的檔案到新的 wordpress 資料夾 

<pre class="brush: bash; title: ; notranslate" title="">#
# 只需要 wp-config.php .htaccess wp-content 資料夾
#
cp old_wp/wp-config.php wordpress/
cp old_wp/.htaccess wordpress/
cp -R old_wp/wp-content wordpress/
#
# 最後再把 wordpress 命名為你原本的那個資料夾
#
mv wordpress Blog
#
# 完成
#</pre> 步驟五：去後台開啟所有外掛，順便把 theme 調整回來，這樣大致完成

 [1]: http://wordpress.org/
 [2]: http://wordpress.org/download/
 [3]: http://blog.wu-boy.com/2008/04/16/179/
 [4]: http://yskin.net/2006/07/mulberrykit.html
 [5]: http://codex.wordpress.org/Upgrading_WordPress_Extended#Detailed_Upgrade_Instructions_for_1.5.x.2C_2.0.x.2C_2.1.x.2C_2.2.x.2C_2.3.x.2C_or_2.5.2C_to_2.5.1
 [6]: http://blog.wu-boy.com/2008/04/16/177/