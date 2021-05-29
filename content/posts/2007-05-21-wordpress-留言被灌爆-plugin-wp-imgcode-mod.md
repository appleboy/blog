---
title: wordpress 留言被灌爆 – plugin – WP-ImgCode mod
author: appleboy
type: post
date: 2007-05-21T13:10:15+00:00
url: /2007/05/wordpress-留言被灌爆-plugin-wp-imgcode-mod/
views:
  - 3072
bot_views:
  - 1660
dsq_thread_id:
  - 247303776
categories:
  - blog
  - php
  - wordpress

---
今天有人問我，blog留言版被灌爆，都是廣告信，我想說 wordpress 不是有內建一個外掛 [Akismet][1] 這個外掛可以擋掉很多spam，讓你的留言版不至於有廣告信，不過還是可以加上留言版的驗證圖形，這樣會更安全一點。 今天找到一個國人改寫的 WordPress plugin &#8211; [WP-ImgCode mod][2] 這個還不錯用，安裝方式如下 

##### 安裝啟用

  1. 將解壓縮出來的 wp-imgcode 資料夾放到 WordPress 的 plugin 資料夾，預設為 wp-content/plugins。
  2. 在控制台中啟用這個 plugin。

##### 加入驗證碼

  1. 開啟目前使用佈景的相關檔案，例如 comments.php。
  2. 在要顯示驗證碼的地方，加上這個程式碼：

<pre class="brush: php; title: ; notranslate" title=""><? php do_action("comment_form", $post->ID); ?>
</pre> 明天在去搞定別人的網站吧~ 先紀錄一下~

 [1]: http://akismet.com/
 [2]: http://blog.chweng.idv.tw/wordpress/wp-imgcode-mod/