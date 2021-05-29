---
title: 簡易 CodeIgniter Layout Library for Template
author: appleboy
type: post
date: 2011-07-10T09:49:40+00:00
url: /2011/07/簡易-codeigniter-layout-library-for-template/
dsq_thread_id:
  - 354393534
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
在 Web 開發網站，最重要的就是切割版面 CSS 化，制定共同部份 header 跟 footer…等，如果是用在 <a href="http://codeigniter.org.tw" target="_blank">CodeIgniter</a> Controller 裡面，呼叫 Views 的時候，如底下程式碼: 

<pre class="brush: php; title: ; notranslate" title="">$data = array(
    "title" => "Welcome to Test"
);
$this->load->view("header");
$this->load->view("welcome", $data);
$this->load->view("footer");</pre> 大家可以發現只要任何一個 Controller 的函式都必須寫上面的程式碼，這樣是不是重複率太高了呢？在 

<a href="http://codeigniter.com/wiki/" target="_blank">CodeIgniter Wiki</a> 裡面發現一個不錯用的簡易 <a href="http://codeigniter.com/wiki/layout_library/" target="_blank">layout library</a>，他的作法就是利用 $this->load->view 裡面的第三個參數來達成，可以參<a href="http://www.codeigniter.org.tw/user_guide/general/views.html" target="_blank">考線上文件 - Views</a> 最後一個段落 **Returning views as data**，我們參考看看底下官網提供的程式碼: 

<pre class="brush: php; title: ; notranslate" title=""><?php  
if (!defined('BASEPATH')) exit('No direct script access allowed');

class Layout
{
    
    var $obj;
    var $layout;
    
    function Layout($layout = "layout_main")
    {
        $this->obj =& get_instance();
        $this->layout = $layout;
    }

    function setLayout($layout)
    {
      $this->layout = $layout;
    }
    
    function view($view, $data=null, $return=false)
    {
        $loadedData = array();
        $loadedData['content_for_layout'] = $this->obj->load->view($view,$data,true);
        
        if($return)
        {
            $output = $this->obj->load->view($this->layout, $loadedData, true);
            return $output;
        }
        else
        {
            $this->obj->load->view($this->layout, $loadedData, false);
        }
    }
}
?> </pre> 注意裡面制定了 layout_main.php 這個 Template PHP 檔案，所以大家需要在 

<span style="color:green"><strong>application/views</strong></span> 資料夾產生此檔案，或者是可以透過程式 <span style="color:green"><strong>setLayout</strong></span> 函式去修改，至於我們怎麼傳變數到 Template 裡面呢，作者的作法是建立一個 config 檔案，裡面把不會變動的變數都寫在裡面，比如說是網站 site\_name site\_description site_keywords 等資料寫到 <span style="color:green"><strong>application/config/site_settings.php</strong></span>，接下來修改 layout library 裡面的 view function: 

<pre class="brush: php; title: ; notranslate" title="">$loadedData = array(
    "content" => $this->obj->load->view($view, $data, true),
    "site_name" => $this->obj->config->item('site_name') . $title,
    "site_description" => $this->obj->config->item('site_description'),
    "site_keywords" => $this->obj->config->item('site_keywords'),
); 
</pre> 可以自己變化看看，我想應該是不難的。如果有任何問題，歡迎到

<a href="http://www.codeigniter.org.tw/forum/" target="_blank">討論區留言</a>