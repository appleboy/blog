---
title: 深入探討 CodeIgniter Input Class 核心程式流程
author: appleboy
type: post
date: 2011-08-03T12:55:58+00:00
url: /2011/08/深入探討-codeigniter-input-class-核心程式流程/
dsq_thread_id:
  - 376047138
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<div style="margin: 0 auto; width:100%;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/4928689646/" title="codeigniter_2 by appleboy46, on Flickr"><img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?resize=137%2C189&#038;ssl=1" alt="codeigniter_2" data-recalc-dims="1" /></a>
</div> 為什麼會寫到這篇呢？當然是有網友希望可以幫他解決困難，由於問題的解答需要比較長的文章解釋，就寫出這一篇啦。在我 2009 年開始推廣到現在，相信在台灣已經有不少人開始使用 

<a href="http://codeigniter.org.tw/" target="_blank">CodeIgniter</a>，自己覺得非常感動 XD，也非常欣慰，希望把好東西推廣給大家知道。廢話不多說，先來說說問題點，先前發表的一篇 <a href="http://blog.wu-boy.com/2010/08/codeigniter-利用-jquery-簡易驗證使用者帳號email/" target="_blank">[CodeIgniter] 利用 jQuery 簡易驗證使用者帳號/Email</a> 最後有人<a href="http://blog.wu-boy.com/2010/08/codeigniter-%E5%88%A9%E7%94%A8-jquery-%E7%B0%A1%E6%98%93%E9%A9%97%E8%AD%89%E4%BD%BF%E7%94%A8%E8%80%85%E5%B8%B3%E8%99%9Femail/#comment-275946631" target="_blank">留言</a>針對 input->post() 在中文官網上面的 <a href="http://codeigniter.org.tw/user_guide/libraries/input.html" target="_blank">Input Class 教學</a>有些疑慮，底下我先來說明網友的問題點。 

### input->post 如果為空，則塞進去資料庫竟然是 0 該網友引用了 Input Class 中文文件的內容 

> 使用 POST, COOKIE, 或 SERVER 資料CodeIgniter 提供三個讓你取出 POST, COOKIE 或 SERVER 中項目的補助函數。使用這些函數的主要便利性在於, 它們會確認並檢視是否這些項目已被設定並且在未設定時回傳 false (boolean) , 而不是直接取出 ($\_POST['something'])，官方範例↓這讓你可以方便地使用資料而不必預先測試它們是否存在。不然, 通常你可能會像這樣做：if ( ! isset($\_POST['something'])) { $something = FALSE; } else { $something = $_POST['something']; } 網友敘述: 

> 但是為什麼還是為設定為0呢??這應該是檢查資料有沒有被設定而已，那我如果沒有輸入，又怎麼會出現 0 呢?? 網友希望 $username = <span style="color:green">$this->input-post</span>("username"); 能幫他判斷如果 username 沒有資料，就直接回傳 NULL，Insert 到資料庫時，應該是 NULL 而不是 0。 

### 程式範例 網友其實沒有錯，根據文件上顯示，如果 $something = 

<span style="color:green">$this->input->post</span>("something"); 取值過後，如果系統沒有 <span style="color:green">$_POST['something']</span>，則會回傳 <span style="color:red">FALSE</span>，我猜網友在跟 model 作搭配的時候使用了底下的寫法來塞值進入資料庫: 

<pre class="brush: php; title: ; notranslate" title="">$data = array(
    "username" => $this->input->post('username'),
    "passwd" => $this->input->post('passwd'), 
    "email" => $this->input->post('email'),
);
$this->load->model('members'); 
$this->members->register($data);  
</pre> 假設如果沒有 $_POST['email'] 的話，該欄位就會被設定為 0，原因很簡單，就是出在要塞值進入資料庫的時候，程式針對資料的型態判斷啦，底下從最開始取得 

<span style="color:green">$_POST</span> 資料開始說起。 <!--more-->

### Input Class 核心程式流程($_POST) 程式剛開始是這樣寫 $username = $this->input->post("username"); 對應到系統 

<span style="color:green"><strong>system/core/Input.php</strong></span> 程式裡面的 post method: 

<pre class="brush: php; title: ; notranslate" title="">/**
* Fetch an item from the POST array
*
* @access	public
* @param	string
* @param	bool
* @return	string
*/
function post($index = NULL, $xss_clean = FALSE)
{
	// Check if a field has been provided
	if ($index === NULL AND ! empty($_POST))
	{
		$post = array();

		// Loop through the full _POST array and return it
		foreach (array_keys($_POST) as $key)
		{
			$post[$key] = $this->_fetch_from_array($_POST, $key, $xss_clean);
		}
		return $post;
	}
	
	return $this->_fetch_from_array($_POST, $index, $xss_clean);
}</pre> 當你傳入 username 的參數，就會直接會被送到 

<span style="color:green"><strong>$this->_fetch_from_array($_POST, $index, $xss_clean);</strong></span> 接著我們看 <span style="color:green"><strong>_fetch_from_array</strong></span> 這 private method 

<pre class="brush: php; title: ; notranslate" title="">/**
 * Fetch from array
 *
 * This is a helper function to retrieve values from global arrays
 *
 * @access	private
 * @param	array
 * @param	string
 * @param	bool
 * @return	string
 */
function _fetch_from_array(&$array, $index = '', $xss_clean = FALSE)
{
	if ( ! isset($array[$index]))
	{
		return FALSE;
	}

	if ($xss_clean === TRUE)
	{
		return $this->security->xss_clean($array[$index]);
	}

	return $array[$index];
}</pre> 有看到程式會先判斷 

<span style="color:green">$_POST['username']</span> 是否存在，如果不存在則回傳 <span style="color:red"><strong>FALSE</strong></span>，也就是先前的 $username 就會是個 bool 函數，其值是 <span style="color:red"><strong>FALSE</strong></span>，那接著我們來看看 Database 怎麼處理傳入的 Value 值，先到 <span style="color:green"><strong>system/database</strong></span> 打開 <span style="color:green">DB_driver.php</span>，找到 Insert 資料庫的 method: 

<pre class="brush: php; title: ; notranslate" title="">/**
 * Generate an insert string
 *
 * @access	public
 * @param	string	the table upon which the query will be performed
 * @param	array	an associative array data of key/values
 * @return	string
 */
function insert_string($table, $data)
{
	$fields = array();
	$values = array();

	foreach ($data as $key => $val)
	{
		$fields[] = $this->_escape_identifiers($key);
		$values[] = $this->escape($val);
	}

	return $this->_insert($this->_protect_identifiers($table, TRUE, NULL, FALSE), $fields, $values);
}</pre> 會看到處理 value 是在 

<span style="color:green"><strong>$values[] = $this->escape($val);</strong></span>，接著我們找到 escape 這 method: 

<pre class="brush: php; title: ; notranslate" title="">/**
 * "Smart" Escape String
 *
 * Escapes data based on type
 * Sets boolean and null types
 *
 * @access	public
 * @param	string
 * @return	mixed
 */
function escape($str)
{
	if (is_string($str))
	{
		$str = "'".$this->escape_str($str)."'";
	}
	elseif (is_bool($str))
	{
		$str = ($str === FALSE) ? 0 : 1;
	}
	elseif (is_null($str))
	{
		$str = 'NULL';
	}

	return $str;
}</pre> 有看到解答了嗎？關鍵就在 is_bool($str) 這判斷式，因為 $username 值為 FALSE，所以在這裡會被設定為 0，也就是為什麼網友會說資料庫欄位怎麼都是一堆 0，原因就是這樣啦，當然也不是沒有解法阿，其實解法很容易，只是自己還是要判斷一下： 

<pre class="brush: php; title: ; notranslate" title="">$data = array(
    "username" => ($username) ? $username : NULL,
    "passwd" => ($passwd) ? $passwd : NULL,
    "email" => ($email) ? $email : NULL,
);</pre> 這樣就可以了