---
title: '[jQuery] AJAX 學習筆記 (一) 如何使用 JSON 驗證使用者表單'
author: appleboy
type: post
date: 2008-09-22T04:09:46+00:00
url: /2008/09/jquery-ajax-學習筆記-一-如何使用-json-驗證使用者表單/
views:
  - 37312
bot_views:
  - 1245
dsq_thread_id:
  - 246689554
categories:
  - AJAX
  - javascript
  - jQuery
  - Linux
  - Network
  - php
  - www
tags:
  - AJAX
  - javascript
  - jQuery

---
最近開始摸了 [jQuery][1]，因為自己本身也很想學習，這是目前當紅的技術，許多網站已經開始在使用 jQuery AJAX 了，包含各大入口網站：[Pixnet 痞客幫][2]，大家會發現學習 jQuery 好處很多，重點是她將 javascript 整合了，讓你方便使用來讓網站 web 2.0 我想現在很多網站都是朝這個方向去進行了，如果想知道什麼是 AJAX 可以上網查[維基百科解釋][3]，已目前來說，大家都使用javascript 客戶端來取得資料，然而 AJAX 可以從Server端取的資料 show 在使用者端給大家看，底下會大概講解以及實做一個驗證。 <!--more--> 首先要 include jQuery 的檔案，這部份昨天看到 

[DK大神部落格][4]：[Google 的 jQuery 與 jQuery UI][5] 裡面有提到 <a href="http://code.google.com/apis/ajaxlibs/documentation/" target="_blank">AJAX Libraries API Developer’s Guide</a>，可以使用底下方法來 include 各種 Ajax Libraries: 

<pre class="brush: jscript; title: ; notranslate" title="">google.load("jquery", "1.2.3");
google.load("jqueryui", "1.5.2");
google.load("prototype", "1.6");
google.load("scriptaculous", "1.8.1");
google.load("mootools", "1.11");
google.load("dojo", "1.1.1");</pre> 不過我自己是下載 jQuery 放在自己的伺服器來使用 

<pre class="brush: jscript; title: ; notranslate" title="">#
# 可以下載 mini 版本，如果 load 不要這麼重的話
#

</pre> 首先來使用最簡單的 

[jQuery AJAX][6] 先建立一個 text 欄位： 

<pre class="brush: xml; title: ; notranslate" title=""><!--
使用 id="user_name"
-->


<p>
  <input type="text" name="user_name" size="20" id="user_name" /><span id="msg_user_name"></span>
</p>
</pre>

<pre class="brush: jscript; title: ; notranslate" title="">checkRegAcc = function (){
    $.ajax({
      url: 'id_validate.php',
      type: 'GET',
      data: {
        user_name: $('#user_name').val()
      },
      error: function(xhr) {
        alert('Ajax request 發生錯誤');
      },
      success: function(response) {
          $('#msg_user_name').html(response);
          $('#msg_user_name').fadeIn();

      }
    });
  };
</pre> 首先可以看到 

<span style="color: #993300;">$.ajax</span> 這個就是在呼叫 jQuery ajax 物件，前面這個 $ 字號，那是 jQuery 的 alias，其實你也可以雪寫成 <span style="color: #993300;">jQuery.ajax()</span> 這是一樣的，然後可以看到 url type data 這三個參數，分別是你要傳到伺服器端的網址，以及你是要用 <span style="color: #0000ff;">POST</span> 或者是 <span style="color: #0000ff;">GET</span> 方式傳遞，data 是你要傳送的參數，這裡的例子 <span style="color: #993300;">user_name: $(&#8216;#user_name&#8217;).val()</span>，傳送 <span style="color: #ff6600;">$_GET[&#8216;user_name&#8217;]</span> 到 id_validate.php 然後它的 value 是 <span style="color: #993300;">$(&#8216;#user_name&#8217;).val()</span>，這樣其實還蠻容易的，然後回傳值 call back 可能是 <span style="color: #ff0000;">error</span> 或者是 <span style="color: #0000ff;">success</span> 表示成功，如果失敗就是跳出視窗說明，成功的話，jQuery 回傳預設是 html 然後直接寫到 <span style="color: #993300;">$(&#8216;#msg_user_name&#8217;)</span> 這個 span id 裡面，也可以回傳不同的data type，那就是要改 ajax 裡面的 <span style="color: #800000;">datatype </span>下面會介紹回傳 datetyep: json 這樣就很簡單實做一個驗證了，多重驗證，可以在加寫，很容易吧 使用 JSON 方式： 

<pre class="brush: jscript; title: ; notranslate" title="">checkRegAcc = function (){
    alert($('#user_name').val());
    $.getJSON('id_validate.php?type=json&#038;method=checkRegisterAccount', 
	    {user_name: $('#user_name').val()},
	    function(ret) {
	       $('#msg_user_name').html(ret);
	    });

  };
  $('#user_name').blur(checkRegAcc);  
</pre> 剛剛有說回傳的datatype可以有下面四種 

> &#8220;xml&#8221;: Returns a XML document that can be processed via jQuery. &#8220;html&#8221;: Returns HTML as plain text, included script tags are evaluated. &#8220;script&#8221;: Evaluates the response as Javascript and returns it as plain text. &#8220;json&#8221;: Evaluates the response as JSON and returns a Javascript Object 上面用到 <span style="color: #993300;">getJSON</span> 的方法，這是利用 <span style="color: #993300;">datatype:json</span> 的方式，利用這個方式，就可以不必依照回傳 error 或者是 success 的 call back 而可以自訂函式唷，當然在 id_validate.php 這個 php 裡面，回傳的部份可以利用 [json_encode()][7] 這個函式來達成，下面是實際 check user_name 是否存在的 php 程式 

<pre class="brush: php; title: ; notranslate" title="">$type = ( isset($_POST['type']) ) ? $_POST['type'] : $_GET['type'];

$sql = "SELECT user_id, username, user_password, user_active, user_level, user_login_tries, user_last_login_try
	FROM " . USERS_TABLE . "
	WHERE username = '" . str_replace("\'", "''", $_GET['user_name']) . "'";   
if( !($result = $db->sql_query($sql)) )
{
	die("Could not query config information " . $sql);
}
if(!$db->sql_numrows($result))
{  
  $ret = "<span style='color:green'> " . $_GET['user_name'] . " 此帳號可以使用</span>";
}
else
{
  $ret = "<span style='color:red'>此帳號已經有人使用</span>";
}

echo ($type == 'json') ? json_encode($ret) : $ret;
?>
</pre>

<span style="color: #993300;">$(&#8216;#user_name&#8217;).blur(checkRegAcc);</span> 這一行的用意是在，原本 focus 在 user_name 這個 text 欄位，如果你按 TAB 之後就會去直行 checkRegAcc 這個 function，相當容易瞭解 參考網站： [PHP::JSON in PHP][8] <http://visualjquery.com/1.1.2.html> [jQuery 學習心得筆記 (4) &#8211; Ajax (上)][9] [jQuery 學習心得筆記 (5) &#8211; Ajax (下)][10]
[][9] [][11]

 [1]: http://jquery.com/
 [2]: http://www.pixnet.net/
 [3]: http://zh.wikipedia.org/wiki/Ajax
 [4]: http://blog.gslin.org/
 [5]: http://blog.gslin.org/archives/2008/09/19/1703/
 [6]: http://docs.jquery.com/Ajax
 [7]: http://tw2.php.net/manual/en/function.json-encode.php
 [8]: http://blog.roodo.com/rocksaying/archives/1966080.html
 [9]: http://blog.ericsk.org/archives/838 "jQuery 學習心得筆記 (4) - Ajax (上)"
 [10]: http://blog.ericsk.org/archives/839 "jQuery 學習心得筆記 (5) - Ajax (下)"
 [11]: http://visualjquery.com/1.1.2.html