---
title: '[CodeIgniter] 利用 jQuery 簡易驗證使用者帳號/Email'
author: appleboy
type: post
date: 2010-08-26T06:01:47+00:00
url: /2010/08/codeigniter-利用-jquery-簡易驗證使用者帳號email/
views:
  - 4770
bot_views:
  - 392
dsq_thread_id:
  - 246887634
categories:
  - AJAX
  - CodeIgniter
  - jQuery
tags:
  - CodeIgniter
  - jQuery

---
<div style="margin: 0 auto; width:100%;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/4928689646/" title="codeigniter_2 by appleboy46, on Flickr"><img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?resize=137%2C189&#038;ssl=1" alt="codeigniter_2" data-recalc-dims="1" /></a>
</div> 好久沒寫相關 

[CodeIgniter][1] 文章，針對於剛入門 CI 的新手們，此篇教學如何使用 [jQuery][2] AJAX 搭配 CI 來驗證使用者帳號及相關資訊，本篇教學帶您如何在 CI 中發出 AJAX request 給伺服器端。 請先在網頁 header 自行 include jQuery 檔案，或者可以使用 [Google AJAX CDN][3] 方式來讀取，將底下程式碼放到 </header> 之前： 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).ready(function() {
    /* 先停止讀取狀態 */
    $('#Loading').hide();

    /* 填寫好 email 欄位，按下 Tab 會進行讀取 */
    $('#email').blur(function(){
    /* 讀取 email 欄位 */
	var a = $("#email").val();
    /* email 正規語法 */
	var filter = /^[a-zA-Z0-9]+[a-zA-Z0-9_.-]+[a-zA-Z0-9_-]+@[a-zA-Z0-9]+[a-zA-Z0-9.-]+[a-zA-Z0-9]+.[a-z]{2,4}$/;
    /* 簡易驗證 email */
	if(filter.test(a)){
        /* 讀取狀態 */
		$('#Loading').show();
        /* AJAX 比對資料庫 */
		$.post("<?php echo base_url()?>controller_name/check_email_availablity", {
			email: $('#email').val()
		}, function(response){
            /* 驗證後讀取 reponse 狀態 */
			$('#Loading').hide();
			setTimeout("finishAjax('Loading', '"+escape(response)+"')", 400);
		});
		return false;
	}
});
</pre>

<!--more--> 在 CI Viewer 加入： 

<pre class="brush: xml; title: ; notranslate" title=""><div>
  <label>E-mail</label>
  	<input id="email" name="email" type="text" value="" />
  	<span id="Loading"><img src="loader.gif" alt="Ajax Indicator" /></span>	
  
</div></pre> CI Controller(控制器)寫法： 

<pre class="brush: php; title: ; notranslate" title="">function check_email_availablity()
{
	$this->load->model('My_model');
	$email = $this->input->post('email');
	$get_result = $this->My_model->check_email_availablity($email);

	if($get_result )
	echo '<span style="color:#f00">Email already in use. </span>';
	else
	echo '<span style="color:#0c0">Email Available</span>';
}
</pre> 驗證 email 函式 

<span style="color:green"><strong>$this->My_model->check_email_availablity()</strong></span> 

<pre class="brush: php; title: ; notranslate" title="">function check_email_availablity($email)
{
    $this->db->select('*');
    $this->db->from('project_users');
    $this->db->where('email', $email);
    $query = $this->db->get('');
    if($query->num_rows() > 0)
        return true;
    else
        return false;
}</pre> 此函式會從資料庫比對是否有註冊過此 email，如果有的話回傳 true 反之回傳 false，然後在將處理後的狀態回傳給 response，這樣就可以顯示驗證訊息了。另外可以使用 

[jQuery plugin: Validation][4] 來驗證 js 部份。^^ Ref: [Codeigniter Tutorial: How To check Username/Email availablity using jQuery in Codeigniter?][5]

 [1]: http://CodeIgniter.com
 [2]: http://jquery.com/
 [3]: http://code.google.com/intl/zh-TW/apis/libraries/devguide.html
 [4]: http://bassistance.de/jquery-plugins/jquery-plugin-validation/
 [5]: http://www.99points.info/2010/07/codeigniter-tutorial-check-usernameemail-availablity-using-jquer-in-codeigniter/