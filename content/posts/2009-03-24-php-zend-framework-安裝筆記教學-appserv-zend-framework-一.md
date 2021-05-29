---
title: '[PHP] Zend Framework 安裝筆記教學 Appserv + Zend Framework (一)'
author: appleboy
type: post
date: 2009-03-24T02:33:33+00:00
url: /2009/03/php-zend-framework-安裝筆記教學-appserv-zend-framework-一/
views:
  - 23413
bot_views:
  - 615
dsq_thread_id:
  - 246755871
categories:
  - Linux
  - php
  - Zend Framework
tags:
  - php
  - Zend Framework

---
今天在公司上班需要用到 [Zend Framework][1] 這一套 MVC 的軟體，用來開發 [Google Calendar APIs][2]，這 API 是用 Zend Framework 下去寫得，在 [Google 文件][3] 說的很清楚，那底下來介紹一下安裝過程吧，首先環境要先有 Apache + PHP + MySQL，我本身用 [Appserv][4] 懶人套件，我是用 AppServ 2.5.10 裡面包含底下： 

  * Apache 2.2.8
  * PHP 5.2.6
  * MySQL 5.0.51b
  * phpMyAdmin-2.10.3 1. 先修改 apache 設定 httpd.conf 

<pre class="brush: bash; title: ; notranslate" title="">#LoadModule rewrite_module modules/mod_rewrite.so</pre> 改成 unmark 掉 

<pre class="brush: bash; title: ; notranslate" title="">LoadModule rewrite_module modules/mod_rewrite.so</pre> 修改 include_path 在 php.ini 裡面，或者是利用 

[set\_include\_path][5] 來修改 2. 開始安裝 Zend Framework，首先去 [官方網站下載][6]，目前版本：[Zend Framework][1] 1.7.7，了解 [MVC][7] 架構。可以參考：[透視 WebMVC][8] 這篇。 <!--more--> 3. 資料架構： 

[<img src="https://i0.wp.com/farm4.static.flickr.com/3441/3378705669_a8ba780edc.jpg?resize=159%2C243&#038;ssl=1" title="Zend_01 (by appleboy46)" alt="Zend_01 (by appleboy46)" data-recalc-dims="1" />][9] 上面這張圖就是 Zend 的目錄架構圖，我們只需要注意 application，htdocs 跟 library 就可以了，底下介紹3個資料夾的個別用途： application 資料夾：裡面包含 controllers (MVC之C)，models (MVC之M) 跟 views (MVC之V)，Views 底下存放是要顯示的元件。 htdocs 資料夾：裡面 images (存放影像檔案)，scripts (存放script檔) styles (存放CSS檔) .htaccess (配合url rewrite之檔案) index.php (bootstrap file)，這個資料夾是對應到 Document root 的設定： 

<pre class="brush: bash; title: ; notranslate" title="">&lt;VirtualHost *:80>
  ServerName zf-tutorial.localhost
  DocumentRoot /var/www/html/zf-tutorial/public
  &lt;Directory "/www/cs">
    AllowOverride All
  &lt;/Directory>
&lt;/VirtualHost></pre> 這樣只要在網址列打入 zf-tutorial.localhost 就可以對應到 localhost，然後把網址對應IP寫入到 Linux：/etc/hosts 或者是 Windows：c:\\windows\system32\drivers\etc\hosts，library 裡面就單一個資料夾，裡面只有 Zend 這個套件，其實基本上也不用動它，升級的時厚紙需要換掉 Zend 這個資料夾即可。 接下來設定 .htaccess 跟 index.php 因為 Zend Framework 會幫忙設定簡短網址，所以我們必須要設定這兩個檔案來達到全部網址都轉向 index.php，這兩個檔案都必須放到 htdocs 資料夾裡面，底下就來說明這兩個檔案寫法。 

**htdocs/.htaccess** 

<pre class="brush: bash; title: ; notranslate" title=""># Rewrite rules for Zend Framework
# 非 PHP 檔案不轉向到 index.php
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule !\.(js|ico|gif|jpg|png|css)$ index.php
# Security: Don't allow browsing of directories
# 關閉檔案列表功能
Options -Indexes
# PHP settings
# 關閉 magic_quotes_gpc register_globals
# 打開 short_open_tag
php_flag magic_quotes_gpc off
php_flag register_globals off
php_flag short_open_tag on
</pre>

**htdocs/index.php** 

<pre class="brush: php; title: ; notranslate" title=""><?php
  /*
  * 設定 Error Report 的等級
  */  
  error_reporting(E_ALL | E_STRICT);  
  /*
  * 設定台北時區
  */   
  date_default_timezone_set('Asia/Taipei');  //設定時區為台北

  /*
  * 設定 include_path 固定把 library 資料夾加入 path 裡面
  */
  define ('P_S', PATH_SEPARATOR);
  set_include_path('.' .P_S .'../library' .P_S .'../application/models/' .P_S .get_include_path());

  require_once 'Zend/Loader.php';
  Zend_Loader::registerAutoload();

  /*
  * 設定 Controller 的資料夾
  */
  $frontController = Zend_Controller_Front::getInstance();
  $frontController->setControllerDirectory('../application/controllers');
  /*
  * 輸出程式
  */  
  $frontController->dispatch();
  
?></pre> 上面設定好之後，就來看一個範例吧，首先看底下的圖： 

[<img src="https://i2.wp.com/farm4.static.flickr.com/3645/3381127398_e86bc67500.jpg?resize=500%2C111&#038;ssl=1" alt="Zend_02" data-recalc-dims="1" />][10] 這是一張 index 的撰寫程式的圖，裡面包含 Control name，上面這張圖說明了在 index 的首頁，包含了 add edit delete 的功能，那我們必須瞭解 Control name 的命名方式跟 Zend View 的命名放置關係，Control 的命名方式就是 {Contrl\_Name}Controller.php 放置在 application/controller 裡面，那裡面包含了indexAction()，addAction()，editAction()，deleteAction() 這些功能，那對應的 html 命名方式就放在 views/scripts/{controller name}/{action\_bame}.phtml 記住副檔名是 phtml，那底下是 IndexController.php 寫法。 **application/controllers/IndexController.php**： 

<pre class="brush: php; title: ; notranslate" title=""><?php
class IndexController extends Zend_Controller_Action
{
  function indexAction()
  {
    $this->view->title = "My Albums";
  }
  function addAction()
  {
    $this->view->title = "Add New Album";
  }
  function editAction()
  {
    $this->view->title = "Edit Album";
  }
  function deleteAction()
  {
    $this->view->title = "Delete Album";
  }
}
?></pre> 會發現有4個動作，分別對應4個view 的檔案： 

**application/views/scripts/index/index.phtml** 

<pre class="brush: xml; title: ; notranslate" title="">


  

<h1>
  <?php echo $this->escape($this->title); ?>
</h1>

</pre>

**application/views/scripts/index/add.phtml** 

<pre class="brush: xml; title: ; notranslate" title="">


  

<h1>
  <?php echo $this->escape($this->title); ?>
</h1>

</pre>

**application/views/scripts/index/edit.phtml** 

<pre class="brush: xml; title: ; notranslate" title="">


  

<h1>
  <?php echo $this->escape($this->title); ?>
</h1>

</pre>

**application/views/scripts/index/delete.phtml** 

<pre class="brush: xml; title: ; notranslate" title="">


  

<h1>
  <?php echo $this->escape($this->title); ?>
</h1>

</pre> 這樣大致上就可以 work 了，請打入網址： index：http://localhost/index/index add：http://localhost/index/add edit：http://localhost/index/edit delete：http://localhost/index/delete 參考網站： 

[Zend Framework安裝][11] [Akra’s DevNotes][12]：[Getting Started with Zend Framework][13] [酷學園][14]：[php下的MVC [Zend Framework] 教學][15]

 [1]: http://framework.zend.com
 [2]: http://code.google.com/intl/zh-TW/apis/calendar/
 [3]: http://code.google.com/intl/zh-TW/apis/calendar/docs/1.0/developers_guide_php.html
 [4]: http://www.appservnetwork.com/
 [5]: http://tw2.php.net/set_include_path
 [6]: http://framework.zend.com/download/latest
 [7]: http://zh.wikipedia.org/wiki/MVC
 [8]: http://www.jaceju.net/resources/webmvc/
 [9]: https://www.flickr.com/photos/appleboy/3378705669/ "Zend_01 (by appleboy46)"
 [10]: https://www.flickr.com/photos/appleboy/3381127398/ "Flickr 上 appleboy46 的 Zend_02"
 [11]: http://blog.eddie.com.tw/2007/08/14/zend-framework-install
 [12]: http://akrabat.com
 [13]: http://akrabat.com/zend-framework-tutorial/
 [14]: http://phorum.study-area.org/
 [15]: http://phorum.study-area.org/index.php/topic,50393.0.html