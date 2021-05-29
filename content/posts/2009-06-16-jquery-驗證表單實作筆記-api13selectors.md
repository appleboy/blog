---
title: '[jQuery] 驗證表單實作筆記 API/1.3/Selectors'
author: appleboy
type: post
date: 2009-06-16T11:51:24+00:00
url: /2009/06/jquery-驗證表單實作筆記-api13selectors/
views:
  - 11720
bot_views:
  - 546
dsq_thread_id:
  - 247022886
categories:
  - jQuery
tags:
  - javascript
  - jQuery

---
驗證 form 表單屬於前端的工作，非常重要，避免使用者填錯格式，當然在 jQuery Plugin 可以找到專門驗證表單的外掛：[jQuery plugin: Validation][1]，此外掛不能相容於 IE 6，會沒辦法呈現效果，google 到一篇解決方法：[Validating not happening in IE6 & no error removal on keyup][2]，這篇裡面提到，必須使用 un-packed and un-minified 的版本，也就是沒有壓縮過的 javascript 檔案，不過我自己沒有試過就是了，底下針對表單的 checkbox select input radio 欄位做檢查的筆記，可以讓大家參考看看。 在 jQuery 1.3 裡面正式拿掉 [@attr] 的寫法，所以以前寫 <span style="color: #ff6600;">$("input:radio[@name=reg_sex]")</span> 都要改成 <span style="color: #008000;">$("input:radio[name=reg_sex]")</span>，這樣才是正確的，可以參考 [jQuery Selector][3] 這篇的 Attribute Filters 部份，先來一篇網路上實做提示說明在 text 來未：[jQuery: show plain text in a password field and then make it a regular password field on focus][4] 作法很簡單：建立兩個輸入 password 的 text input 欄位： 

<pre class="brush: xml; title: ; notranslate" title=""></pre>

<!--more--> 其中必須先把 #password-clear 設定為 display: none 

<pre class="brush: css; title: ; notranslate" title="">#password-clear {
    display: none;
}</pre> 底下是 jQuery 驗證部份： 

<pre class="brush: jscript; title: ; notranslate" title="">$('#password-clear').show();
$('#password-password').hide();

$('#password-clear').focus(function() {
    $('#password-clear').hide();
    $('#password-password').show();
    $('#password-password').focus();
});
$('#password-password').blur(function() {
    if($('#password-password').val() == '') {
        $('#password-clear').show();
        $('#password-password').hide();
    }
});
</pre> 作法大致上是，剛開始先顯示 #password-clear 欄位，把要輸入的 #password-password 欄位隱藏，當 focus 在 #password-clear 的時候，就把 #password-clear 欄位隱藏，顯示 #password-password，輸入密碼之後，按下 tab 跳到其他欄位的時候，開始檢查，當 #password-password 沒有資料的時候，又把 $('#password-clear') show 出來，然後把 $('#password-password') 隱藏，這樣你又會看到 $('#password-clear') 的 value 值，不過這方法有點麻煩，太多欄位又會太多 jQuery 語法。 基本驗證表單：帳號只能是英文加上數字： 

<pre class="brush: jscript; title: ; notranslate" title="">var id_check=/[^a-zA-Z0-9]/g;
if ($("#username").val()==""){
	alert("請輸入你的帳號名稱!!");
	$("#username").focus();
}
else if ($("#username").val().indexOf(' ')>=0){
	alert("請不要在帳號中使用空格!!");
	$("#username").focus();
} 
else if ($("#username").val().match(id_check)){
	alert("請不要使用非英文字當做帳號名稱!!");
	$("#username").focus();
} </pre> email 欄位 

<pre class="brush: jscript; title: ; notranslate" title="">var mail_check= /.+@.+\..+/;
if (!$("#user_email").val().match(mail_check)){
		alert("輸入的e-Mail格式不對, 請再輸入");
		$("#user_email").focus();
}</pre> 或者是: 

<pre class="brush: jscript; title: ; notranslate" title="">function isEmail(email){
  if (email=="") return true;
  reEmail=/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/
  return reEmail.test(email);
}</pre> 驗證 checkbox 是否有勾選超過一個： 

<pre class="brush: jscript; title: ; notranslate" title="">var test = $("input:checkbox:checked[name=reg_check[]]").length;
if(!test)
{
    alert("請務必勾選一個");
}</pre> 驗證 radio 是否有選取： 

<pre class="brush: jscript; title: ; notranslate" title="">if(!$("input:radio[name=reg_sex]").is(":checked")){
  alert("請選取你的性別名稱!!");
  $("#reg_sex").focus();
  $("#errormessage").html("

<p class='error'>
  請選取你的性別名稱!!
</p>");  
}</pre> 取出選取的 radio 值： 

<pre class="brush: jscript; title: ; notranslate" title="">reg_sex = $("input:radio:checked[name=reg_sex]").val();</pre> 如何取得 select 的 value 跟 text 

<pre class="brush: jscript; title: ; notranslate" title="">/*
*
* 取得 select value 值
*/
$('#selectList').val();</pre> 取得 text 值，可以利用 :selected 這個 

<pre class="brush: jscript; title: ; notranslate" title="">/*
*
* 取得 select text 值
*/
$('#selectList :selected').text();</pre>

 [1]: http://bassistance.de/jquery-plugins/jquery-plugin-validation/
 [2]: http://groups.google.com/group/jquery-en/browse_thread/thread/843bc94ffef99250
 [3]: http://docs.jquery.com/Selectors
 [4]: http://www.electrictoolbox.com/jquery-toggle-between-password-text-field/