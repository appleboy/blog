---
title: '[PHP] Web Framework : CodeIgniter MySQL Database 使用教學'
author: appleboy
type: post
date: 2009-04-20T06:26:32+00:00
url: /2009/04/php-web-framework-codeigniter-mysql-database-使用教學/
views:
  - 12503
bot_views:
  - 485
dsq_thread_id:
  - 247280742
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
繼上一篇 [[PHP] 好用 Web Framework : CodeIgniter 安裝教學][1] 之後，這次來紀錄一下 [Database Class][2] 的用法，我想官方網站都已經寫的很詳細了，就大概快速講一下我的一些用法跟心得，其實最主要講的是內建的 [Active Record Class][3]，它可以快速撰寫 SQL 語法，不必打 where 或者是 From 這些字眼，insert update select 都可以利用 [Active Record Class][3] 很簡單的撰寫出來喔，它也幫忙簡單的檢查 escape SQL Injection，舉的簡單例子大概就知道了： 假設底下這個簡單的 join 一個表格的 select 語法 

<pre class="brush: php; title: ; notranslate" title="">$query = $this->db->query("SELECT a.news_id, a.news_name, a.add_time FROM project_news a
 left join project_news_categories b on a.categories_id = b.categories_id
where news_id = '".$id."' order by news_top DESC, a.add_time DESC
");</pre> 利用 

[Active Record Class][3] 可以改寫成： 

<pre class="brush: php; title: ; notranslate" title="">$this->db->select('a.news_id, a.news_name, a.add_time');
$this->db->from('project_news a');
$this->db->join('project_news_categories b', 'a.categories_id = b.categories_id', 'left'); 
$this->db->order_by("news_top DESC, a.add_time DESC");
$this->db->where('news_id', $id); </pre>

<!--more--> 是不是覺得在閱讀方面很容易瞭解呢，那之後要改 sql 語法，也可以快速找到要改的地方，交接給其他程式組員，在學習或者是除錯方面都相當容易的喔。 首先介紹設定 database 的 config 檔案 

[Database Configuration][4] 

<pre class="brush: php; title: ; notranslate" title="">$active_group = "default";
$active_record = TRUE;

$db['default']['hostname'] = "localhost";
$db['default']['username'] = "root";
$db['default']['password'] = "1234";
$db['default']['database'] = "vbs";
$db['default']['dbdriver'] = "mysql";
$db['default']['dbprefix'] = "";
$db['default']['pconnect'] = FALSE;
$db['default']['db_debug'] = TRUE;
$db['default']['cache_on'] = FALSE;
$db['default']['cachedir'] = "";
$db['default']['char_set'] = "utf8";
$db['default']['dbcollat'] = "utf8_general_ci";</pre> 上面可以在 application/config/ 底下找到 database.php 檔案裡面，$active\_group 是用來設定預設 load 哪一個 DB config 檔案，那預設就是 default 這個 name 了，$active\_record，用來設定啟動 

[Active Record Class][3]。 連接 MySQL 資料庫，基本連接方式如下： 

<pre class="brush: php; title: ; notranslate" title="">$this->load->database();</pre> 可以傳入三個參數，其實如果沒有要使用多重資料庫的話，就不用設定三個參數，第一個參數，就是傳入 db 參數的 array 變數，第二個是傳入 TRUE/FALSE (boolean)，用來設定多重資料庫，第三個參數傳入TRUE/FALSE (boolean)，用來設定 enable the Active Record class。 簡單的一些基本 sql 語法可以參考 

[線上手冊][5]，我的建議可以使用 [Active Record Class][3]，這樣方便防止 SQL Injection，不然就要利用內建的 $this->db->escape() 導入參數，其實用 Active Record Class 就會自動幫忙加入了喔，例如用了 $this->db->where(); 看說明文件後面會註明： 

> Note: All values passed to this function are escaped automatically, producing safer queries. 撰寫一個範例測試看看，首先建立一個 model.php 檔案，命名為 news_model.php，放到 application/models 裡面： 

<pre class="brush: php; title: ; notranslate" title=""><?php
class News_model extends Model {

    var $title   = '';
    var $content = '';
    var $date    = '';

    function News_model()
    {
      // Call the Model constructor
      parent::Model();
      /* load 資料庫 */
      $this->load->database();
    }
    
    function get_last_entries($count)
    {
      $this->db->select('a.news_id, a.news_name, a.add_time');
      $this->db->from('project_news a');
      $this->db->join('project_news_categories b', 'a.categories_id = b.categories_id', 'left'); 
      $this->db->order_by("news_top DESC, a.add_time DESC");
      $this->db->limit($count);    
      $query = $this->db->get('');
      $row = $query->result_array();
      $query->free_result(); // The $query result object will no longer be available        
      return $row;
    }
?></pre> 檔案內容裡面 News_model 第一個字母必須命名為大寫，再來建立 Controller 檔案 

<pre class="brush: php; title: ; notranslate" title=""><?
class Vbs extends Controller {
  
  function __construct()
  {
    parent::Controller();   
  }
  
  function index()
  {
    $data['news_data'] = $this->news_model->get_last_entries('5');
    $page_title = '首頁';
    $this->header($page_title);
    $this->load->view('index_content', $data);
    $this->footer();   	
  }  
}
?></pre> 在 controller 裡面，我們沒有 load model，$this->load->model('news_model');，可以在 config/autoload.php 加入： 

<pre class="brush: php; title: ; notranslate" title="">/*
| -------------------------------------------------------------------
|  Auto-load Models
| -------------------------------------------------------------------
| Prototype:
|
|	$autoload['model'] = array('model1', 'model2');
|
*/

$autoload['model'] = array("news_model");</pre> 這樣我們每個 controller 就都可以使用 news_model，而不必在寫入底下這一行，有些常用的的 model 都可以參考 

[Auto-loading Resources][6] 方式加入即可 

<pre class="brush: php; title: ; notranslate" title="">$this->load->model('news_model');</pre> 這時候在建立 view 檔案就大致上完成了，放在 application/views 裡面，這樣基本的 DB 連接以及取出資料都會了，新增刪除修改都在文件裡面講的很清楚，這裡就不多說了。

 [1]: http://blog.wu-boy.com/2009/04/17/1173/
 [2]: http://codeigniter.com/user_guide/database/index.html
 [3]: http://codeigniter.com/user_guide/database/active_record.html
 [4]: http://codeigniter.com/user_guide/database/configuration.html
 [5]: http://codeigniter.com/user_guide/database/queries.html
 [6]: http://codeigniter.com/user_guide/general/autoloader.html