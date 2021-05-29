---
title: '[教學] 加入 Sphinx 繁體中文全文檢索 on CodeIgniter'
author: appleboy
type: post
date: 2009-07-26T03:40:26+00:00
url: /2009/07/教學-加入-sphinx-繁體中文全文檢索-on-codeigniter/
views:
  - 8477
bot_views:
  - 495
dsq_thread_id:
  - 247137950
categories:
  - CodeIgniter
tags:
  - CodeIgniter
  - sphinx

---
[<img class="alignleft size-full wp-image-1467" title="sphinx" src="https://i0.wp.com/blog.wu-boy.com/wp-content/uploads/2009/06/sphinx.jpg?resize=200%2C51" alt="sphinx" data-recalc-dims="1" />][1] 在寫這篇之前，有介紹過了 [Sphinx][1] 一篇針對繁體中文檢索的[教學][2]，大家可以先去參考看看，把 Sphinx 服務架設起來，在搭配 CodeIgniter MVC Framework 使用，把 Sphinx 提供的 PHP API 放到 CI 的 Library 裡面就可以運作了，首先去官網下載套件，然後參考[官方的安裝文件][3]，大致上就差不多了，下載的檔案裡面會有 api 資料夾，裡面提供了 python, ruby, java, php 的 client 端檔案，讓您去自由呼叫，PHP 部份可以看 sphinxapi.php 這個檔案，我們也只需要把這個檔案放入 CI 的 Library 裡面，不過寫法有些改變，請看底下 <!--more--> 1. 非常簡單，開啟 sphinxapi.php 然後前面加上： 這是 

[Library][4] 的擴充寫法，可以參考[中文文件][5]。存檔之後放入 application/libraries 檔名取 Sphinxapi.php 就可以了 2. 如何使用：預先載入到建構子 

<pre class="brush: php; title: ; notranslate" title="">function __construct()
{
parent::Controller();
$this->load->library("sphinxapi");
}</pre> 或者是加入到 config/autoload.php 裡面也是可以的 3. 使用 sphinxapi，請先設定 sphinxapi 裡面的 host 跟 port，設定完之後，就可以正常連接了 

<pre class="brush: php; title: ; notranslate" title="">$index = 'test2'; // 您要索引的名稱
$start = 0; // 抓取起始筆數
$limit = 100;	// 一次抓取 100 筆
$this->sphinxclient->SetWeights(array(100,1));
$this->sphinxclient->SetMatchMode(SPH_MATCH_ALL);
$this->sphinxclient->SetLimits($start,$limit);
$this->sphinxclient->SetArrayResult(true);
// $keyword 你要查詢的字串
$res = $this->sphinxclient->Query($keyword,$index);</pre> $res 會回傳我們想要的資料，拿到之後，利用 $total = $res['total_found']; 取得查到的筆數，然後利用底下程式碼取得資料 auto increment ID 

<pre class="brush: php; title: ; notranslate" title="">foreach($res['matches'] as $row)
{
$vedio[] = $row['id'];
} </pre> 在丟到 model 找到自己想要的資料，這樣就可以了，其實還有很多進階作法，這裡就不多說了，可以參考官方文件，都是設定 sphinx.conf 檔案。最後附上 sphinxapi.php 檔案程式碼:

[檔案下載][6]

 [1]: http://sphinxsearch.com/
 [2]: http://blog.wu-boy.com/2009/06/20/1466/
 [3]: http://www.sphinxsearch.com/docs/current.html#installation
 [4]: http://codeigniter.com/user_guide/general/creating_libraries.html
 [5]: http://www.codeigniter.org.tw/user_guide/general/creating_libraries.html
 [6]: http://blog.wu-boy.com/wp-content/uploads/2009/07/sphinxapi.php