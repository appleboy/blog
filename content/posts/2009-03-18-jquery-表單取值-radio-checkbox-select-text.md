---
title: '[jQuery] 表單取值 radio checkbox select text 驗證表單'
author: appleboy
type: post
date: 2009-03-18T04:37:57+00:00
url: /2009/03/jquery-表單取值-radio-checkbox-select-text/
views:
  - 21253
bot_views:
  - 464
dsq_thread_id:
  - 246959541
categories:
  - AJAX
  - FreeBSD
  - javascript
  - jQuery
  - www
tags:
  - jQuery

---
最近在專案全面使用 [jQuery][1] 來整合後台部份，目前還沒有大量用到 AJAX 的部份，等以後有時間會全部轉換 AJAX 利用 JSON 的部份，其實之前就有寫到一篇用 datatype JSON 的方式來實現 AJAX：[[jQuery] AJAX 學習筆記 (一) 如何使用 JSON 驗證使用者表單][2]，大家可以參考看看，不過今天大概寫一下昨天在實做驗證表單取值的一些心得，在設計後台的時候，我把編輯文章跟新增文章的功能做在同一塊，然後利用 jQuery 去改變傳值狀態，利用 hidden 的 mode 欄位來決定是要新增文章還是修改文章 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).ready(function() 
{
  $("#add_news_link").click(function(){
    $("#mode").attr("value", "add");
  });
})
</pre>

<!--more--> 這個時候，就把要傳送的狀態改成 add 了，不過編輯文章的資料都還留在也面上面，所以必須把很多欄位都清空，例如 text password textarea checkbox radio select 這些欄位全部都歸零，透過 jQuery 針對 Form 的 id 值，尋找 input 欄位資訊，可以參考 

[jQuery Doc 的 Form Selectors 的文件][3]，裡面提到，如果要找尋全部都欄位，就可以利用 

<pre class="brush: jscript; title: ; notranslate" title="">$('#myForm :input')</pre> 或者是： 

<pre class="brush: jscript; title: ; notranslate" title="">/* 前者 */
$('input:radio', myForm)</pre> 這還可以寫成 

<del datetime="2010-03-29T04:30:33+00:00">$('input[@type=radio]')</del> 

<pre class="brush: jscript; title: ; notranslate" title="">/* 後者 */
$('input[type=radio]')
</pre> 如果您的表單非常的大，建議可用前者，速度上面會比較快喔，所以針對整個 Form Selectors 的方式寫了一個 function 來掃全部欄位： 

<pre class="brush: jscript; title: ; notranslate" title="">$("#news_form :input").each(
function(){
  switch($(this).attr('type')){
    case 'radio':
      /* 取消所有選取 */
      $(this).attr("checked", false);
    case 'checkbox':
      /* 取消所有選取 */
      $(this).attr("checked", false);
    break;
    case 'select-one':
      /* 把 select 元件都歸到選第一項 */
      $(this)[0].selectedIndex = 0;
    break;
    case 'text':
      /* 清空 text 來欄位 */
      $(this).attr("value", "");
    break;
    case 'password':
      /* 清空 password 來欄位 */
      $(this).attr("value", "");
    case 'hidden':
      /*
      * 不清空 hidden，通常保純此欄位      
      */
    case 'textarea':
      /* 清空 textarea 來欄位 */
      $(this).attr("value", "");
    break; 
  }
});
</pre> 這樣就可以清空所有欄位，不過在網路上找到更方便的 

[jQuery Form Plugin][4]，這個外掛可以利用一行程式，取代掉上面的程式碼： 

<pre class="brush: jscript; title: ; notranslate" title="">$('#news_form').clearForm();</pre> 我去看了一下程式碼，寫法就跟我差不多 

<pre class="brush: jscript; title: ; notranslate" title="">if (t == 'text' || t == 'password' || tag == 'textarea')
    this.value = '';
else if (t == 'checkbox' || t == 'radio')
    this.checked = false;
else if (tag == 'select')
    this.selectedIndex = -1;</pre> 有興趣可以去試試看喔，那也可以檢查表單送出前欄位有無填寫完整： 

<pre class="brush: jscript; title: ; notranslate" title="">$("#news_form").submit(
  function(e){
    if($("#news_name").val() == "")  
    {
      $("#news_name").focus();
      alert("標題沒填寫");
      return false; 
    }
    else if($("#news_desc").val() == "")
    {
      $("#news_desc").focus();
      alert("內容沒填寫");
      return false;       
    }
    return true;      
  }
);</pre> 這樣檢查如果還不夠，那推薦您用 

[jQuery plugin: Validation][5]，這個還不錯用，可以先試試看 [demo][6] 程式，另外這個作者也推薦剛剛說到的 [jQuery Form Plugin][4] 可以處理 AJAX 的部份喔，還不錯。 底下一些取值判斷的筆記： 

<pre class="brush: jscript; title: ; notranslate" title="">/*
* text 欄位取值
*/
$("#news_name").val();
$("#news_name").arrt("value");
/*
* 取消 checkbox 欄位選取
*/
$(#news_top).attr("checked", false);
$(#news_top).attr("checked", "");
/*
* 判斷 checkbox 是否選取
*/
if($("#news_top").attr('checked')==undefined)
/*
* 全選 checkbox 欄位，或者反向選取
*/
$("#clickAll").click(function() {
  $("input[name='news_top[]']").each(function() {
    if($(this).attr("checked"))
    {
      $(this).attr("checked", false);
    }
    else
    {
      $(this).attr("checked", true);
    }
  });
}); 
/*
* checkbox 的 value 值
*/
$('input[name="news_top"]:checked').val();
/*
* 選取 select 的 text 值
*/
$("select[name='categories_id'] option:selected").text();
$('#categories_id :selected').text();
/*
* 選取 select 的 value 值
*/
$("select[name='categories_id']").val();
$('#categories_id').text();
</pre> 還有很多可以學習的，可以參考 

[visualjquery][7] 這網站 參考網站： [轉：jquery radio取值，checkbox取值，select取值，radio選中，checkbox選中，select選中，及其相關][8] [jQuery 點擊 Input / Textarea 全選、複製的寫法(Widget)][9] [jQuery 學習筆記 (6) — 操作 DOM 物件][10]

 [1]: http://jquery.com/
 [2]: http://blog.wu-boy.com/2008/09/22/412/
 [3]: http://docs.jquery.com/DOM/Traversing/Selectors#Form_Selectors
 [4]: http://www.malsup.com/jquery/form/
 [5]: http://bassistance.de/jquery-plugins/jquery-plugin-validation/
 [6]: http://jquery.bassistance.de/validate/demo/
 [7]: http://visualjquery.com/1.1.2.html
 [8]: http://kevyu.blogspot.com/2008/06/jquery-radiocheckboxselectradiocheckbox.html
 [9]: http://plog.longwin.com.tw/my_note-programming/2008/12/29/jquery-input-textarea-copy-widget-badge-2008
 [10]: http://blog.ericsk.org/archives/847