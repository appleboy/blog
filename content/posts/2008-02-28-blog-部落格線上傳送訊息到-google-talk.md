---
title: '[blog] 部落格線上傳送訊息到 google talk'
author: appleboy
type: post
date: 2008-02-28T08:18:57+00:00
url: /2008/02/blog-部落格線上傳送訊息到-google-talk/
views:
  - 2882
bot_views:
  - 442
dsq_thread_id:
  - 250159331
categories:
  - blog
  - php
  - www

---
這個訊息是在 [重灌狂人][1] 那邊看到的，我用起來相當不錯，所以套用了我的 [電腦blog][2] 跟 [生活blog][3]，那底下就來介紹怎麼把這個功能用在部落格上面 目前我是弄在 [wordpress][4] 上面，有可以達到我的需求，首先登入 [網頁版的Google Talk聊天面板][5]，然後自己設定一下名稱按送出，他會給你一段 frame 的程式碼，然後你要把他寫到 wordpress 的 theme 程式裡面 到 /wp-content/your_theme/sidebar.php 檔案裡面，每個 theme 設計方式不同，所以大家注意一下 

<pre class="brush: php; title: ; notranslate" title=""><li class="sidebox">
  <h2>
    <?php _e('Categories'); ?>
  </h2>
  	
  
  <ul>
    <?php 
		if (function_exists('wp_list_categories')) 
		{	
			wp_list_categories('show_count=1&#038;title_li='); 
		}
		else 
		{   
			wp_list_cats('optioncount=1');  
		}  
		?>
    	
  </ul>
  
</li>
</pre> 在這後面加入 

<pre class="brush: php; title: ; notranslate" title=""><li class="sidebox">
  <h2>
    <?php _e('google 線上交談'); ?>
  </h2>
  	
  
  <ul>
    
  </ul>
  
</li>
</pre> 你會在你 blog 上面發現底下這圖案 

[<img src="https://i2.wp.com/farm4.static.flickr.com/3100/2297991458_abeb0033c2_o.jpg?resize=206%2C106&#038;ssl=1" alt="google" border="0" data-recalc-dims="1" />][6] 如果你 google talk 在線上，他就會顯示藍色的喔，這樣就代表成功了

 [1]: http://briian.com/
 [2]: http://blog.wu-boy.com/
 [3]: http://life.wu-boy.com/
 [4]: http://wordpress.org
 [5]: http://www.google.com/talk/service/badge/New
 [6]: https://www.flickr.com/photos/appleboy/2297991458/ "google by appleboy46, on Flickr"