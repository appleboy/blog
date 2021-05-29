---
title: '[PHP] 好用 Web Framework : CodeIgniter 安裝教學'
author: appleboy
type: post
date: 2009-04-17T14:53:20+00:00
url: /2009/04/php-好用-web-framework-codeigniter-安裝教學/
views:
  - 13657
bot_views:
  - 510
dsq_thread_id:
  - 247196078
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
最近都在 survey 一堆 PHP Web Framework，自己想學一套可以馬上上手的，其實因為目前在 PHP 的開發上面講求速度，以及程式的可維護性，雖然我自己有一套自己的開發方法，包含包好的 SQL Class 以及上傳模組，不過還是覺得熟悉一套 MVC 架構的寫法，將來維護或者是團隊合作方面會比較好分工，在小專案上面還可以自己來，但是大型專案就必須靠 MVC Framework 了，畢竟一個人寫程式，永遠比不上團隊合作，紀錄一下最近找到的一些網路比較多人用的 FrameWork： 

  * <a href="http://www.symfony-project.org/" target="_blank">Symfony</a>
  * <a href="http://cakephp.org/" target="_blank">CakePHP</a>
  * <a href="http://codeigniter.com/" target="_blank">CodeIgniter</a>
  * <a href="http://framework.zend.com/" target="_blank">Zend Framework</a>
  * <a href="http://docs.kohanaphp.com/" target="_blank">Kohana</a>

<!--more--> 上面這幾套，我目前用過 Zend Framework 跟 CakePHP，這兩套在文件方面都非常多，以台灣的開發者相當推崇這兩套，至於好不好上手，看個人的狀況了，在我用一個禮拜開發 Zend AUTH 跟 login 還有 

<a href="http://code.google.com/intl/zh-TW/apis/calendar/" target="_blank">Google Calendar API</a>，可以參考 <a href="http://blog.wu-boy.com/category/%E9%9B%BB%E8%85%A6%E6%8A%80%E8%A1%93/php/zend-framework-php-%E9%9B%BB%E8%85%A6%E6%8A%80%E8%A1%93/" target="_blank">Zend Framework Tag</a>，那這不是重點，這次要介紹 Web Framework : CodeIgniter，今天花了一些時間安裝了 CodeIgniter，來紀錄安裝心得，包含 .htaceess 設定，css 路徑的解決，那也可以參考這一篇<a href="http://doublekai.org/docs/CI_Install_Guide/CI.html" target="_blank">中文安裝</a>，大陸那邊已經有了簡體版的官方網站，不過<a href="http://codeigniter.com/user_guide/" target="_blank">英文官方文件</a>就已經寫的很清楚了，大家可以閱讀英文就可以了。 安裝方法如下：首先下載最新版 <a href="http://codeigniter.com/download.php" target="_blank">1.7.1</a> 版本，解壓縮之後，可以看到兩個資料夾 system 跟 user\_guide 還有一個 index.php 檔案，user\_guide 這裡面就跟網站上的 Doc 是一樣的，方便您離線閱讀文件，那重點只剩下 system 跟 index.php 了，其實如果都沒有改的話，只要瀏覽器打入 http://網址，這樣就可以看到 welcome 的畫面了 [<img title="Welcome to CodeIgniter_1239978367906 (by appleboy46)" src="https://i0.wp.com/farm4.static.flickr.com/3329/3449565401_c4dbebf84d.jpg?resize=500%2C217&#038;ssl=1" alt="Welcome to CodeIgniter_1239978367906 (by appleboy46)" data-recalc-dims="1" />][1] 這樣其實很容易吧，您一定很想知道怎麼會預設讀這個檔案呢，那就是在 system/application/config 裡面的 routes.php 裡面設定的，找到 

<pre class="brush: php; title: ; notranslate" title="">$route['default_controller'] = "welcome";</pre> 這就是預設的 Controller，所以 index.php 會先去載入 welcome.php 這隻檔案，放在 system/application/controllers/welcome.php 

<pre class="brush: php; title: ; notranslate" title=""><?php

class Welcome extends Controller {

	function Welcome()
	{
		parent::Controller();	
	}
	
	function index()
	{
		$this->load->view('welcome_message');
	}
}

/* End of file welcome.php */
/* Location: ./system/application/controllers/welcome.php */</pre> 注意 Conrtroller 第一個字母要大寫喔，所以是寫 

<span style="color:red">Welcome</span>，網址只需要打 http://localhost/CodeIgniter/ 這樣就可以看到畫面，那也可以打入 http://localhost/CodeIgniter/index.php/welcome，會看到同樣的畫面，我們可以利用 mod_rewrite 方式把 index.php 拿掉，只要在根目錄新增 .htaccess 檔案，寫入底下程式碼： RewriteEngine on RewriteBase /CodeIgniter/ RewriteCond $1 !^(index\.php|css|flash|images|img|includes|js|language|robots\.txt) RewriteRule ^(.*)$ index.php/$1 [L] 首先因為我的子目錄是 CodeIgniter，所以必須設定 RewriteBase，如果你是根目錄，那就取消這行，RewriteCond 這邊如果網站有 images 或者 css 檔案，請加上去，不然所有檔案都被導入到 index.php，這樣網站圖片 css 效果都不會出來，可以參考 [wiki][2] 或者是[論壇這篇文章][3]，接下來自己寫一個 Blog.php 的 controller 檔案，檔內容如下： 

<pre class="brush: php; title: ; notranslate" title=""><?php
class Vbs extends Controller {

  function __construct()
  {
      parent::Controller();
  }
    
  function _remap($method)
  {
    if ($method == 'comments')
    {
      $this->$method();
    }
    else
    {
      $this->header();
      $this->footer();
    }
  }
  
  function header()
  {
    $this->load->helper('url');
    $data = array(
      'sitename' => 'VBS禾唐-VBS安穩煞車器 行車更安全',
      'page_title' => '首頁'
    );    
    $this->load->view('header',$data);
  
  }
	
  function footer()
  {
  	$this->load->view('footer');
  }
}
?>
</pre> 其中 $this->load->helper('url'); 是抓取您設定的 url 網址 

<pre class="brush: php; title: ; notranslate" title="">/*
* 這會去抓取 application/config/config.php 裡面的 $config['base_url'] = "http://localhost/CodeIgniter/";
*/
$this->load->helper('url');</pre> 目前還在摸索中，如果還有心得，會在繼續追加。

 [1]: https://www.flickr.com/photos/appleboy/3449565401/ "Welcome to CodeIgniter_1239978367906 (by appleboy46)"
 [2]: http://codeigniter.com/wiki/css/
 [3]: http://codeigniter.com/forums/viewthread/62527/#307761