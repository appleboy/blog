---
title: '[AJAX] jQuery plugin cascade 多重下拉選單應用 by json'
author: appleboy
type: post
date: 2008-12-19T02:25:11+00:00
url: /2008/12/ajax-jquery-plugin-cascade-多重下拉選單應用-by-json/
views:
  - 15408
bot_views:
  - 868
dsq_thread_id:
  - 246697985
categories:
  - AJAX
  - javascript
  - jQuery
  - www
tags:
  - AJAX
  - javascript
  - jQuery
  - plugin

---
最近在弄動態下拉式選單，因為層級的關係，所以必須用到，大學裡面各學院，底下在各系所，在網路上看到一篇 [[AJAX] jQuery的多重下拉式選單應用 PART1][1]，實做起來是不會困難，可是我遇到一些怪問題就是了，目前還沒有解決，當然首推 [jQuery plugin][2] 套件 [cascade][3]，那也參考了國外的一篇文章 [jQuery.cascade : Cascading values from forms][4] ，這幾篇看完其實就差不多了，因為大家都寫得很清楚，[官方網站][5] 更是把所有應用都寫出來了，詳細很多用法可以參考 [官方網站][5]，看原始碼大概就知道在寫甚麼了。 先來說明一下使用的方法：在這個 jQuery cascade plugin 裡面，定義了一格式： 

<pre class="brush: jscript; title: ; notranslate" title="">/*
格式就在底下總共有三攔
*/
{'when':'selectedValue','value':'itemValue','text':'itemText'}
</pre> 第一個 when：這是上一層的 select 的 value 值 第二個 value：這是下一層的 select 的 value 值 第三個 text：這是下一層 option 的 text 我想有一點 html 基礎的，大概就知道我在說什麼了吧 

<!--more--> 製作動態選單，可以用兩種方法，第一使用 ajax 去呼叫，也可以使用 json 的方式來達到，只是傳送的格式不同而已，第二個方法，就是在前端就輸出正確格式，然後利用 jQuery 讀近來。 先講解第一個方法：當然直接輸出就可以了，這就不必使用 ajax 去後端要資料了 首先把資料先撈出來： 

<pre class="brush: php; title: ; notranslate" title=""><?
$sql = "SELECT a.*, b.* FROM " . USERS_COLLEGE_TABLE . " as a, " . USERS_DEP_TABLE . " as b where a.college_id = b.college_id order by a.college_id";

if( !($result = $db->sql_query($sql)) )
{
	die("Could not query config information" . $sql);
}
while($row = $db->sql_fetchrow($result)){
  /* 先把中文用 trim 輸出 */
  $row['dep_name'] = trim($row['dep_name']);
  $dep_array .= ($dep_array == '' ) ? "{'When':'".$row['college_id']."','Value':'".$row['dep_id']."','Text':'".$row['dep_name']."'}" : ", {'When':'".$row['college_id']."','Value':'".$row['dep_id']."','Text':'".$row['dep_name']."'}";
}
?></pre> 注意輸出的部份：$dep_array 那邊，記得先用 trim 把中文的部份先使用，不然會顯示不出來，前端的寫法如下： 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 前端 html 部份： 

<pre class="brush: php; title: ; notranslate" title=""><select name="user_college" id="user_college">
<option value="">請選擇</option>
<?
$sql = "SELECT * FROM " . USERS_COLLEGE_TABLE;
if( !($result = $db->sql_query($sql)) )
{
	die("Could not query config information" . $sql);
}
while($row = $db->sql_fetchrow($result)){
   $selected = ($row['college_id'] == $profiledata['user_college']) ? "selected" : "";
   echo '<option value="'.$row["college_id"].'" '.$selected.'>'.$row["college_name"].'</option>';
}
?> 
</select>


<select name="user_department" id="user_department">
<option value="">請選擇</option>
</select></pre> 這樣大致上就可以動了，那如果是要三層選單，那就自己再去加上 jQuery 的部份就可以了，舉一反三，我想大家都會，那底下介紹一下 ajax json 拿取得動態資料，這樣就不必先載入。 那首先修改 jQuery 寫法部份： 

<pre class="brush: jscript; title: ; notranslate" title="">jQuery(document).ready(function()
{
  $("#user_department33").cascade("#user_college", {
  ajax: {
      url: 'ajax.php',
      type: 'GET',
      /*
			complete: function(){ 
				alert('my list is updated'); 
			},
      */      
      data: { 
        action: 'show', 
        /* 這裡一定要用 val 這個變數接上，下面有解說 */
        val: $('#user_college').val() 
      },
      dataType: "json"
  },
  template: commonTemplate,
  match: commonMatch
  
  });
  			
});</pre> 注意 datatype 那邊是寫 json，然後丟 GET 的 action 值過去，以及 select user_college 的 value，那 ajax.php 部份如下： 

<pre class="brush: php; title: ; notranslate" title=""><?
$root_path = './';
include($root_path . 'config.php');
$college_id = $_GET['val'];
$action = $_GET['action'];

switch($action)
{
  case "show":
  
    $sql = "SELECT a.college_id, b.dep_id, b.dep_name FROM " . USERS_COLLEGE_TABLE . " as a, " . USERS_DEP_TABLE . " as b where a.college_id = b.college_id and a.college_id = '".$college_id."' order by a.college_id";

    
    if( !($result = $db->sql_query($sql)) )
    {
    	die("Could not query config information" . $sql);
    }
    $list = array();
    $dep_array = array();
    while($row = $db->sql_fetchrow($result))
    {
      $row['dep_name'] = trim($row['dep_name']);
      $row['college_id'] = trim($row['college_id']);
      $row['dep_id'] = trim($row['dep_id']);
      /* 如果不是用 json 方式，就必須用下面這程式碼 */
      //$dep_array .= ($dep_array == "" ) ? "[{'When':'".$row['college_id']."','Value':'".$row['dep_id']."','Text':'".$row['dep_name']."'}" : ",{'When':'".$row['college_id']."','Value':'".$row['dep_id']."','Text':'".$row['dep_name']."'}";
      /* json 專用格式 */
      $dep_array = array ('When' => $row['college_id'], 'Value' => $row['dep_id'], 'Text' => $row['dep_name']);
      $list[] = $dep_array;
    }    
  break;
}
echo json_encode($list);
?></pre>

<del datetime="2008-12-21T11:33:53+00:00">這樣大致上完成，可使有一個問題，不知道是我的問題，還是 jQuery plugin cascade，因為我用 ajax 這個方法，會讓選單，只出現一個，其他的都不會出現。</del> update 2008.12.21: 我發現哪裡出問題，原來在 jquery.cascade.ext.js 這檔案裡面，直接寫死的 

<pre class="brush: jscript; title: ; notranslate" title="">$.ui.cascade.ext.ajax = function(opt) {				
		var ajax = opt.ajax;//ajax options hash...not just the url
		return { getList: function(parent) { 					
			var _ajax = {};
			var $this = $(this);//child element
			var defaultAjaxOptions = {
				type: "GET",
				dataType: "json",
				success: function(json) { $this.trigger("updateList", [json]); },
				data: $.extend(_ajax.data,ajax.data,{ val: opt.getParentValue(parent) })				
			};						
			//overwrite opt.ajax with required props (json,successcallback,data)		
			//this lets us still pass in handling the other ajax callbacks and options
			$.extend(_ajax,ajax,defaultAjaxOptions);	
			
			$.ajax(_ajax);		 		  
		} };
	};</pre> 裡面看到這一段： 

<pre class="brush: jscript; title: ; notranslate" title="">/*
裡面已經用這個 val 變數去使用了，所以造成其他變數去連接會不對
*/
val: opt.getParentValue(parent)</pre> 網址測試：

<http://appleboy.no-ip.org/plan/index.php>

 [1]: http://blog.roodo.com/taikobo0/archives/6166625.html
 [2]: http://plugins.jquery.com
 [3]: http://plugins.jquery.com/project/cascade
 [4]: http://devlicio.us/blogs/mike_nichols/archive/2008/05/25/jquery-cascade-cascading-values-from-forms.aspx
 [5]: http://dev.chayachronicles.com/jquery/cascade/index.html