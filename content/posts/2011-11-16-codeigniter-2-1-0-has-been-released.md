---
title: CodeIgniter 2.1.0 has been released
author: appleboy
type: post
date: 2011-11-16T03:12:08+00:00
url: /2011/11/codeigniter-2-1-0-has-been-released/
dsq_thread_id:
  - 473431989
categories:
  - CodeIgniter
tags:
  - CodeIgniter

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 2011/11/16 台灣官方公告訊息:『

<a href="http://www.codeigniter.org.tw/blog/codeigniter_2.1.0_released" target="_blank">CodeIgniter 2.1.0 Release</a>』 在上禮拜參加了 <a href="http://phpconf.tw/2011" target="_blank">2011 PHP Conference</a>，並且介紹了 <a href="http://CodeIgniter.org.tw" target="_blank">CodeIgniter</a> 目前官方動態、安裝及使用方式，結果就在過沒幾天就釋出 2.1.0 版本了，在這次的版本修正了許多 Bug 以及增加了一些功能，底下就來看看 CodeIgniter 2.1.0 修正及改變了哪些。 <!--more-->

### User Guide 使用手冊 官方非常貼心的在這一次的版本多增加了一個入門手冊：

<a href="http://codeigniter.org.tw/user_guide/tutorial/index.html" target="_blank">指導手冊</a>，裡面教使用者如何快速寫好<a href="http://codeigniter.org.tw/user_guide/tutorial/news_section.html" target="_blank">簡易新聞模組</a>，包含資料庫設定，以及 Model 寫法，該如何跟 Controller 搭配，官方都寫得非常清楚，只要按照底下手冊動手操作，就可以寫出簡單的 Application: 

  * <a href="http://codeigniter.org.tw/user_guide/tutorial/index.html" target="_blank">基本簡介</a>
  * <a href="http://codeigniter.org.tw/user_guide/tutorial/static_pages.html" target="_blank">靜態頁面</a>
  * <a href="http://codeigniter.org.tw/user_guide/tutorial/news_section.html" target="_blank">新聞模組介紹</a>
  * <a href="http://codeigniter.org.tw/user_guide/tutorial/create_news_items.html" target="_blank">動態新增新聞</a>

### 一般變更 General Changes 在 

<a href="http://codeigniter.org.tw/user_guide/general/common_functions.html" target="_blank">Common functions</a> 裡面新增 html_escape() 全域函式，幫忙過濾 html 特殊符號來防止 XSS 攻擊，其實就是用 <a href="http://php.net/manual/en/function.htmlspecialchars.php" target="_blank">htmlspecialchars</a> 函式而已，您可以傳入陣列或者是單一資料，此函式都會將特殊符號轉換成 Html 顯示符號，例如 <span style="color:green">&</span> 轉換成 <span style="color:red">&</span> 等。 

### 資料庫 Database

  * 開始支援 CUBRID 及 PDO Driver
  * $this->db->insert_batch() 開始支援 OCI8 (Oracle) driver 對於常使用 

<a href="http://www.cubrid.org/" target="_blank">CUBRID</a> 及 <a href="http://www.php.net/manual/en/intro.pdo.php" target="_blank">PDO</a> 這兩種 <a href="http://codeigniter.org.tw/user_guide/database/index.html" target="_blank">Driver</a> 的開發者是一大福音阿 

### 函式庫 Libraries 新增 

<a href="http://codeigniter.org.tw/user_guide/libraries/migration.html" target="_blank">Migration 類別</a>，用來管理或升級您的 DB 架構，這對於開發者來說是相當好的工具，大家可以詳細參考使用手冊。 新增 <a href="http://codeigniter.org.tw/user_guide/libraries/form_validation.html" target="_blank">is_unique</a> 去驗證表單欄位，這函式非常有用，假如我們要驗證 User 資料表是否有重複的使用者或者是 Email 就可以按照底下方式寫： 

<pre class="brush: php; title: ; notranslate" title="">$this->form_validation->set_rules('email', 'Email', 'required|valid_email|is_unique[users.email]');</pre> 系統會拿 email 欄位到 Users 資料表比對 Email，如果有重複，就 Return False，這樣開發者就不用另外寫 Call back 函式。 

### 結論 以上是我個人覺得比較重大的改變，如果想知道更詳細資訊，請參考 

<a href="http://codeigniter.org.tw/user_guide/changelog.html" target="_blank">Change Log</a>，大家快去下載測試吧 

  * <a href="http://www.codeigniter.org.tw/downloads" target="_blank">CodeIgniter 2.1.0 Download</a>
  * [從 2.0.3 升級到 2.1.0 教學][1]

 [1]: http://codeigniter.org.tw/user_guide/installation/upgrade_210.html