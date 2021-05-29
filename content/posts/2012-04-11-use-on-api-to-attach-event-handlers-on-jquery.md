---
title: jQuery 1.7 透過 on 來綁定事件
author: appleboy
type: post
date: 2012-04-11T12:49:27+00:00
url: /2012/04/use-on-api-to-attach-event-handlers-on-jquery/
dsq_thread_id:
  - 644995624
categories:
  - javascript
  - jQuery
tags:
  - JavaScrpt
  - jQuery

---
既上一篇作者寫了 <a href="http://blog.wu-boy.com/2012/04/backbonejs-framework-tutorial-example-1/" target="_blank">Javascript 前端工具 Backbone.js Framework 初學介紹</a>，這次來將程式改寫成 jQuery 寫法，藉這個機會來介紹 jQuery 新功能 <a href="http://api.jquery.com/on/" target="_blank">on API</a>，底下來看看 jQuery event handle 的演進 

<pre class="brush: jscript; title: ; notranslate" title="">//在 jQuery 1.3 以上版本
$(selector).live(events, data, handler);
//在 jQuery 1.4.3 以上版本 
$(document).delegate(selector, events, data, handler);
//在 jQuery 1.7 以上版本
$(document).on(events, selector, data, handler);</pre> 上面三種寫法都可以綁定網頁上全部元件，如果只是單純只是用 click bind event 的話，那只要新增的元件就無法作用，講得有點抽象，底下直接看個例子: 

<!--more--> html 程式碼: 

<pre class="brush: xml; title: ; notranslate" title=""><div class="container well">
  <h1>
    jQuery Click Event
  </h1>
      
  
  <p>
    &nbsp;
  </p>
      
  
  <button class="btn btn-primary add">Click me to add new item</button>
      
  
  <ul style="margin-top:5px;margin-bottom:5px;" class="li">
    <li style="margin-top:5px; font-size:1.2em">
      I am old item.&nbsp;&nbsp;<button class="btn btn-danger delete">Delete</button>
    </li>
            
    
    <li style="margin-top:5px; font-size:1.2em">
      I am old item.&nbsp;&nbsp;<button class="btn btn-danger delete">Delete</button>
    </li>
            
    
    <li style="margin-top:5px; font-size:1.2em">
      I am old item.&nbsp;&nbsp;<button class="btn btn-danger delete">Delete</button>
    </li>
            
    
    <li style="margin-top:5px; font-size:1.2em">
      I am old item.&nbsp;&nbsp;<button class="btn btn-danger delete">Delete</button>
    </li>
        
  </ul>
  
</div></pre> jQuery Click 事件 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 上面例子，大家可以發現只要是透過 button 新增加的 li element 都不可以被刪除，原因就是在 .delete 是 bind 在 click 事件。這時候就要用 jQuery.on API 來重新實做，其實很簡單，只要將 click 改成 on 就完成了，請取代底下程式碼。 

<pre class="brush: jscript; title: ; notranslate" title="">$(".delete").click(function(){
    $(this).parent().remove();
});
</pre> 換成 

<pre class="brush: jscript; title: ; notranslate" title="">$(document).on('click', '.delete', function(event){
    $(this).parent().remove();
});
</pre> 直接看 

<a href="http://appleboy.github.com/jquery/example_1/" target="_blank">Demo 範例</a>，這樣可以更直接瞭解。