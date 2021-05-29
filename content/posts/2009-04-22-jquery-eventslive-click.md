---
title: '[jQuery] Events/live Click'
author: appleboy
type: post
date: 2009-04-22T13:35:57+00:00
url: /2009/04/jquery-eventslive-click/
views:
  - 12442
bot_views:
  - 537
dsq_thread_id:
  - 250250880
categories:
  - jQuery
tags:
  - jQuery

---
今天在利用 <a href="http://jquery.com/" target="_blank">jQuery</a> 來動態新增表格 <tr><td> 看到 ptt <a href="http://tony1223.no-ip.org:81/test/testTableGird.html" target="_blank">Tony 的網站教學</a>，可以用 parent 的方式，一層一層往上尋找到 tr 標籤，然後再整個 remove 掉，覺得相當好用，不過內容是直接網頁動態載入 delete button，現在我想弄的是新增一個 button，Click 之後，會新增一組 tr 選單，裡面包含 delete button，但是這個 button 利用底下的 jQuery 寫法，會沒辦法作用。 

<pre class="brush: jscript; title: ; notranslate" title="">$(":input[value=delete]").click(
function(e){
$(this).parent().parent().remove();
}
);</pre> 原來看 Tony 是直接網頁載入 button，而我的狀況是後來人工點選產生的 button 跟 tr 標籤，所以問了一下 Tony，發現了一個解決方法，那就是利用 

[Events/live][1]，這是新增在 1.3 版本的，他可以 bind 在現有的標籤，或者是未來新增的標籤上面，可以榜定的事件如下： 

> click, dblclick, mousedown, mouseup, mousemove, mouseover, mouseout, keydown, keypress, keyup 沒有支援底下的事件： 

> blur, focus, mouseenter, mouseleave, change, submit<!--more--> 所以原本我的 html 語法是底下這樣寫的： 

<pre class="brush: xml; title: ; notranslate" title=""><table id="plug" border="1">
  
  
  
  <tr>
    <td>
      <input id="room_plug" name="room_plug[]" type="text" />
    </td>
    
    
    <td>
      <input type="button" value="delete" />
    </td>
    
  </tr>
  
</table>


<hr />

<input id="plug_name" name="plug_name" type="text" /> <input id="add_plug" name="add_plug" type="button" value="新增" /></pre> jQuery 是底下寫法： 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).ready(function(){
$("#add_plug").click(
  function(e){
    $("#plug").append('<input name="room_plug[]" type="text" value="'+$("#plug_name").attr("value")+'" /> <input type="button" value="delete" />');
  });

$(":input[value=delete]").click(
  function(e){
    $(this).parent().parent().remove();
  });

});</pre> 上面的寫法只能新增動態表格，但是沒辦法動態減少表格，所以只好利用 

[Events/live][1] 把 jQuery 的部份改寫成底下，就可以工作了喔 

<pre class="brush: jscript; title: ; notranslate" title="">$(":input[value=delete]").live("click" ,function(){
  $(this).parent().parent().remove();
});</pre>

 [1]: http://docs.jquery.com/Events/live