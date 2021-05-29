---
title: '[PHP Framework] How to implement Plurk API in CodeIgniter'
author: appleboy
type: post
date: 2009-12-30T12:58:33+00:00
url: /2009/12/php-framework-how-to-implement-plurk-api-in-codeigniter/
views:
  - 5256
bot_views:
  - 493
dsq_thread_id:
  - 249931143
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php
  - Plurk API

---
[<img src="https://i2.wp.com/farm3.static.flickr.com/2519/4228352638_19b13306d3_o.gif?resize=170%2C73&#038;ssl=1" title="ci_logo2 (by appleboy46)" alt="ci_logo2 (by appleboy46)" data-recalc-dims="1" />][1] 很開心在12月看到 [Plurk Release API][2] 出來，而自己也跟網路上一些朋友合作開發 [PHP implementation of Plurk API][3]，Plurk (簡稱噗浪)在台灣這一兩年紅了起來，網路高手分別針對噗浪研究產生非官方的 API，現在官網 Release 出來，提供了 [Java][4] 跟 [Python][5] 的 Example，我想因為 Plurk 是用 Python 寫出來的，所以提供了範例，但是 API 出來沒多久，[roga][6] 就集合了網路一些強者，一起開發了 PHP Plurk API，我也拿了此 API 在實作到 [CodeIgniter Framework][7]，讓在使用此套 open source 的使用者可以享用 Plurk API。不過從2009.12.29日之後，Plurk 官網有限制每天只能 call 50.000 次，已經蠻多了，不要操掛 Plurk 的機器阿。 <!--more--> 1. 首先下載 CodeIgniter 1.7.2 版本：

[下載][8] 2. 新增檔案 plurk\_config.php 和 plurk\_constant.php 到 <span style="color:green">application/config/</span> 目錄底下 plurk_config.php 檔案內容如下： 

<pre class="brush: php; title: ; notranslate" title=""><?php
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

$config['api_key'] = "xxxxx";
$config['username'] = "xxxxx";
$config['password'] = "xxxxx";

?> </pre> api_key 請到 

[Plurk API][2] 網站申請，申請過後會寄信到您的信箱，username 是 Plurk 帳號，password 是 Plurk 密碼。 plurk_constant.php <http://github.com/appleboy/CodeIgniter-Plurk-API/blob/master/config/plurk_constant.php> 這檔案不需要修改什麼，唯一要注意的是，可以設定 Plurk 的 log 跟 Cookie 檔案位置，目前是存放到 <span style="color:green">application/logs/</span> 目錄，如果沒有此目錄，請麻煩建立此資料夾，之後設定 755 讓 Web 可以存取。 

<pre class="brush: php; title: ; notranslate" title="">define('PLURK_COOKIE_PATH', APPPATH . 'logs/cookie');
define('PLURK_LOG_PATH', APPPATH . 'logs/plurk_log');</pre> 3. 新增 Common.php 跟 Plurk.php 檔案到 

<span style="color:green">application/libraries/</span> 資料夾裡面 Common.php 檔案如下： <http://github.com/appleboy/CodeIgniter-Plurk-API/blob/master/libraries/Common.php> Plurk.php 主程式： <http://github.com/appleboy/CodeIgniter-Plurk-API/blob/master/libraries/Plurk.php> 4. 接下來就可以新增 Controller 來測試看看，直接些改 CodeIgniter 所預設的 Welcome Controller 

<pre class="brush: php; title: ; notranslate" title=""><?php
class Welcome extends Controller {
	function __construct()
	{
        parent::Controller();
        $this->config->load('plurk_config');
        $this->load->library('plurk');

	}
	
	function index()
	{ 
        $api_key = $this->config->item('api_key');
        $username = $this->config->item('username');
        $password = $this->config->item('password');
        $this->plurk->login($api_key, $username, $password);  
        
        /**
         ******************************************
         * @Get plurks
         *
         * set plurk id = {123, 456, 789}
         ******************************************/
        
        echo "

<h1>
  ----- get plurks -----
</h1>";
        echo "

<pre>";
        print_r($this->plurk->get_plurks());
        echo "</pre>";
        
        /*
        echo "

<h1>
  ----- get someone's plurk ----- 
</h1>";
        print_r($plurk->get_plurk(123));
        
        echo "

<h1>
  ----- get unread plurks ----- 
</h1>";
        print_r($plurk->get_unread_plurks());
        
        echo "

<h1>
  ----- mark plurk as read ----- 
</h1>";
        $plurk->mark_plurk_as_read(array(123,456,789));
        
        echo "

<h1>
  ----- add plurk ----- 
</h1>";
        $plurk->add_plurk('en', 'says', 'Hello World');
        
        echo "

<h1>
  ----- edit plurk ----- 
</h1>";
        $plurk->edit_plurk(123, 'be edited');
        
        echo "

<h1>
  ----- delete plurk ----- 
</h1>";
        $plurk->delete_plurk(123);
        
        echo "

<h1>
  ----- mute plurks ----- 
</h1>";
        print_r($plurk->mute_plurks(123));
        
        echo "

<h1>
  ----- unmute plurks ----- 
</h1>";
        print_r($plurk->unmute_plurks(123));
        */
        
        /**
         ******************************************
         * @Get alerts
         *
         ******************************************/
        
        /*
        echo "

<h1>
  ----- get active alerts ----- 
</h1>";
        print_r($plurk->get_active());
        
        echo "

<h1>
  ----- get a list of past 30 alerts ----- 
</h1>";
        print_r($plurk->get_history());
        
        echo "

<h1>
  ----- remove notification ----- 
</h1>";
        $plurk->remove_notification(123);
        */
        
        /**
         ******************************************
         * @Get plurk's responses
         *
         ******************************************/
        
        /*
        echo "

<h1>
  ----- get responses ----- 
</h1>";
        echo "set plurk id = 123&lt;/h1>";
        print_r($plurk->get_responses(123));
        
        echo "

<h1>
  ----- add response ----- 
</h1>";
        echo "set plurk id = 123&lt;/h1>";
        print_r($plurk->add_response(123, 'test response', 'says'));
        
        echo "

<h1>
  ----- delete response ----- 
</h1>";
        echo "set plurk id = 123, response id = 456&lt;/h1>";
        $plurk->delete_response(123, 456);
        */
        
        /**
         ******************************************
         * @Control user 
         *
         ******************************************/
        
        /*
        echo "

<h1>
  ----- get own profile ----- 
</h1>";
        print_r($plurk->get_own_profile());
        
        echo "

<h1>
  ----- get user public profile ----- 
</h1>";
        echo "set user id = 123&lt;/h1>";
        print_r($plurk->get_public_profile(123));
        
        echo "

<h1>
  ----- get user info ----- 
</h1>";
        print_r($plurk->get_user_info());
        
        echo "

<h1>
  ------ get users friends (nick name and full name)
</h1>";
        print_r($plurk->get_completion());
        
        echo "

<h1>
  ----- get block user's list ----- 
</h1>"; 
        print_r($plurk->get_blocks());
        
        echo "

<h1>
  ----- block user ----- 
</h1>"; 
        $plurk->block_user(5366984);
        
        echo "

<h1>
  ----- unblock user ----- 
</h1>"; 
        $plurk->unblock_user(5366984);
        */
        
        /**
         ******************************************
         * @Control friends 
         *
         * set user id = 123
         * set friend id = 789
         ******************************************/
        
        /*
        echo "

<h1>
  ----- get someone's friends ----- 
</h1>";
        print_r($plurk->get_friends(123));
        
        echo "

<h1>
  ----- become someone's friend ----- 
</h1>";
        $plurk->become_friend(789);
        
        echo "

<h1>
  ----- remove friend ----- 
</h1>";
        $plurk->remove_friend(789);
        
        echo "

<h1>
  ----- accept friendship request as friend ----- 
</h1>";
        $plurk->add_as_friend(789);
        
        echo "

<h1>
  ----- accept all friendship requests as friends ----- 
</h1>";
        $plurk->add_all_as_friends();
        
        echo "

<h1>
  ----- deny friendship ----- 
</h1>";
        $plurk->deny_friendship(789);
        */
        
        /*
         ******************************************
         * @Control fans
         *
         * set user id = 123
         * set fan id = 789
         ******************************************/
         
        /*
        echo "

<h1>
  ----- get following ----- 
</h1>";
        print_r($plurk->get_following());
        
        echo "

<h1>
  ----- get someone's fans ----- 
</h1>";
        print_r($plurk->get_fans(123));
        
        echo "

<h1>
  ----- become someone's fan ----- 
</h1>";
        $plurk->become_fan(5366983);
        
        echo "

<h1>
  ----- accept a friendship request as fan ----- 
</h1>";
        plurk->add_as_fan(789);
        
        echo "

<h1>
  ----- accept all friendship requests as fans ----- 
</h1>";
        $plurk->add_all_as_fan();
        */
        
        /* can't use */
        //echo "

<h1>
  ----- set user following ----- 
</h1>"; 
        //echo "user id = 789&lt;/h1>";
        //echo ($plurk->set_following(3440147, $follow = FALSE)) ? 'success' : 'disable';
        
        
        /*
         ******************************************
         * @Search 
         *
         ******************************************/
        
        /*
        echo "

<h1>
  ----- search plurk ----- 
</h1>"; 
        print_r($plurk->search_plurk('php-plurk-api'));
        
        echo "

<h1>
  ----- search user ----- 
</h1>"; 
        print_r($plurk->search_user('roga lin'));
        
        echo "

<h1>
  ----- get emoticons ----- 
</h1>"; 
        print_r($plurk->get_emoticons());
        */
        
        
        /*
         ******************************************
         * @Clique
         *
         ******************************************/
        
        /*
        echo "

<h1>
  ----- get clique list ----- 
</h1>"; 
        print_r($plurk->get_cliques());
        
        echo "

<h1>
  ----- create a clique ----- 
</h1>"; 
        print_r($plurk->create_clique("test"));
        
        echo "

<h1>
  ----- rename clique ----- 
</h1>"; 
        print_r($plurk->rename_clique("test","test1"));
        
        echo "

<h1>
  ----- get clique ----- 
</h1>"; 
        print_r($plurk->get_clique('test1'));
        
        echo "

<h1>
  ----- add a user to a clique ----- 
</h1>"; 
        print_r($plurk->add_to_clique("test1", 3440147));
        
        echo "

<h1>
  ----- remove a user from a clique ----- 
</h1>"; 
        print_r($plurk->remove_from_clique("test1", 3440147));
        
        echo "

<h1>
  ----- delete a clique ----- 
</h1>"; 
        print_r($plurk->delete_clique("test1"));  
        */      
	}
}
/* End of file welcome.php */
/* Location: ./system/application/controllers/welcome.php */</pre> 底下載入相關設定以及 Plurk Library，當然也可以設定在 

<span style="color:green">application/config/autoload.php</span> 裡面喔 

<pre class="brush: php; title: ; notranslate" title="">$this->config->load('plurk_config');
$this->load->library('plurk');</pre> 這樣就算是安裝成功了，大家可以試試看，如果需要程式碼，可以到 

[CodeIgniter-Plurk-API][9] 下載完整的程式碼 

## INSTALLATION Download all file from this site. 

<pre class="brush: bash; title: ; notranslate" title="">$ http://github.com/appleboy/CodeIgniter-Plurk-API/archives/master
$ git clone git://github.com/appleboy/CodeIgniter-Plurk-API.git</pre> Copy some files into directory. 

<pre class="brush: bash; title: ; notranslate" title="">$ copy config/plurk_config.php your_application/config/
$ copy config/plurk_constant.php your_application/config/
$ copy libraries/Common.php your_application/libraries/
$ copy libraries/Plurk.php your_application/libraries/</pre> Create logs directory, and chmod 755 directory 

<pre class="brush: bash; title: ; notranslate" title="">$ mkdir your_application/logs
$ chmod 755 your_application/logs
$ chown www:www your_application/logs</pre> Edit config/plurk_config.php, and configure your api key, plurk username, and plurk password 

<pre class="brush: php; title: ; notranslate" title="">$config['api_key'] = "xxxxx";
$config['username'] = "xxxxx";
$config['password'] = "xxxxx";</pre> Test your controller file: welcome.php http://localhost/welcome

 [1]: https://www.flickr.com/photos/appleboy/4228352638/ "ci_logo2 (by appleboy46)"
 [2]: http://www.plurk.com/API
 [3]: http://code.google.com/p/php-plurk-api/
 [4]: http://en.wikipedia.org/wiki/Java_(programming_language)
 [5]: http://www.python.org/
 [6]: http://blog.roga.tw/
 [7]: http://codeigniter.com
 [8]: http://www.codeigniter.com/download_files/CodeIgniter_1.7.2.zip
 [9]: http://github.com/appleboy/CodeIgniter-Plurk-API