---
title: '[相簿] Coppermine Photo Gallery Album Expander'
author: appleboy
type: post
date: 2008-04-01T07:48:01+00:00
url: /2008/04/相簿-coppermine-photo-gallery-album-expander/
views:
  - 6504
bot_views:
  - 1084
dsq_thread_id:
  - 247343089
categories:
  - javascript
  - www
tags:
  - Coppermine
  - Greasemonkey
  - javascript

---
[<img src="https://i0.wp.com/farm4.static.flickr.com/3022/2378954219_945799366e.jpg?resize=500%2C340&#038;ssl=1" alt="js_1" data-recalc-dims="1" />][1] 今天看到 gslin大神 文章：[PIXNET Album Expander][2]，然後裝了一下，發覺非常好用，而我自己本身也有架設相簿，相簿程式是 open source [Coppermine Photo Gallery][3]，想說就自己練習看看，寫一個自己上傳相簿之後，可以快速瀏覽相簿，而這隻程式要先安裝好外掛 [Greasemonkey][4]，這隻外掛我之前有介紹過：[firefox and IE 的 greasemonkey][5]，大家可以看看，google 上面也有很多文章 script：[Coppermine Photo Gallery Album Expander][6] 測試相簿：[我的相簿 Angel & Devil][7] <!--more--> 原本的顯示如下： 

[<img src="https://i2.wp.com/farm3.static.flickr.com/2145/2378954319_83fae3be34.jpg?resize=500%2C386&#038;ssl=1" alt="js_2" data-recalc-dims="1" />][8] 裝完之後，顯示 normal 的圖形 [<img src="https://i0.wp.com/farm3.static.flickr.com/2088/2379789784_415cd882aa.jpg?resize=500%2C433&#038;ssl=1" alt="js_3" data-recalc-dims="1" />][9] 這樣看起來非常方便，不用一直點連結，就可以看到該頁面所有圖片 我順便去測試了一下 segaa 大大的相簿系統：[薰衣草之戀][10]，測試結果如下 [<img src="https://i1.wp.com/farm4.static.flickr.com/3262/2379789838_2bfc8dce6f.jpg?resize=422%2C500&#038;ssl=1" alt="js_4" data-recalc-dims="1" />][11] 老大的相簿系統太 sex 了，哈哈 我在 script 裡面還有另外寫一個顯示方法，就是直接把圖片換成 normal 而已，沒有經過排列，顯示如下 [<img src="https://i1.wp.com/farm3.static.flickr.com/2356/2379801656_7f289f171f.jpg?resize=500%2C287&#038;ssl=1" alt="js_5" data-recalc-dims="1" />][12] 轉錄 jQuery 的取值教學：[jQuery Attributes 筆記][13] 

<pre class="brush: jscript; title: ; notranslate" title="">@addClass( class )
// 在 

<p>
  節點裡加入class = "selected"
  // 移除 : removeClass( class ).
  $("p").addClass("selected")
  
  @attr( name ) 
  // 取得<img src="test" /> 裡的src值
  // before : <img src="test.jpg" />
  // Result :  test.jpg
  $("img").attr("src");
  
  @attr( properties ) 
  // 將<img />  加入 src="test.jpg" alt="Test Image"
  // before : <img />
  // Result :  <img src="test.jpg" alt="Test Image" />
  $("img").attr({ src: "test.jpg", alt: "Test Image" });
  
  
  @attr( key, value ) 
  // 指定物件 的 key 並 設定 value
  // 將 <img /> 加入 src = "test.jpg"
  // before : <img />
  // Result :  <img src="test.jpg" />
  $("img").attr("src","test.jpg");
  // 將 <input /> 加入 value = "test.jpg"
  // before : <input />
  // Result : <input value="test.jpg" />
  $("input").attr("value","test.jpg");
  
  @attr( key, fn ) 
  // 在<img />裡加入 title 
  //title 值 則是用function 回傳
  //Before: <img src="test.jpg" />
  //Result: <img src="test.jpg" title="test.jpg" />
  $("img").attr("title", function() { return this.src });
  //Before : <img title="pic" /><img title="pic" /><img title="pic" />
  //Result: <img title="pic1" /><img title="pic2" /><img title="pic3" />
  $("img").attr("title", function(index) { return this.title + (++index); });
  
  
  @html() 
  // 取得 
  
  <div>
    xxx 
  </div> xxx <= 取得的東西
  // Before : 
  
  <div>
    xxx 
  </div>
  // Result : xxx 
  $("div").html()
  
  
  @html( val ) 
  // 改變 
  
  <div>
    xxx
  </div> 為 
  
  <div>
    <b>new stuff</b>
  </div>
  // Before : 
  
  <div>
    xxx 
  </div>
  // Result : 
  
  <div>
    <b>new stuff</b>
  </div>
  $("div").html("
  
  <b>new stuff</b>");
  
  
  @removeAttr( name ) 
  //移除<input disabled="disabled" />
  // Before : <input disabled="disabled" />
  // Result : <input />
  $("input").removeAttr("disabled")
  
  
  @removeClass( class )
  //移除 
  
  <p>
    裡的 class
    // Before : 
    
    <p class="selected">
      Hello
    </p>
    // Result : 
    
    <p>
      Hello
    </p>
    $("p").removeClass()
    
    // Before : 
    
    <p class="selected first">
      Hello
    </p>
    // Result : 
    
    <p class="first">
      Hello
    </p>
    $("p").removeClass("selected")
    
    // Before : 
    
    <p class="highlight selected first">
      Hello
    </p>
    // Result : 
    
    <p class="first">
      Hello
    </p>
    $("p").removeClass("selected highlight")
    
    
    @text() 
    //取得  
    
    <p>
      裡的字串
      // Before : 
      
      <p>
        <b>Test</b> Paragraph.
      </p>
      
      <p>
        Paraparagraph
      </p>
      // Result : Test Paragraph.Paraparagraph
      $("p").text();
      
      
      @text( val ) 
      //取代
      
      <p>
        內的字串
        // Before : 
        
        <p>
          Test Paragraph.
        </p>
        // Result :  
        
        <p>
          <b>Some</b> new text.
        </p>
        $("p").text("
        
        <b>Some</b> new text.");
        
        // Before : 
        
        <p>
          Test Paragraph.
        </p>
        // Result :  
        
        <p>
          <b>Some</b> new text.
        </p>
        $("p").text("
        
        <b>Some</b> new text.", true);
        
        
        @toggleClass( class )
        // 將
        
        <P>
          有 class="selected" 移除 , 如果
          
          <P>
            沒有 class="selected" 則加入 
            // Before :  
            
            <p>
              Hello
            </p>
            
            <p class="selected">
              Hello Again
            </p>
            // Result : 
            
            <p class="selected">
              Hello
            </p>, 
            
            <p>
              Hello Again
            </p>
            $("p").toggleClass("selected")
            
            
            @val()
            // 抓取 INPUT 的 VALUE值
            // Before :  
            
            <input type="text" value="some text" />
            // Result :  "some text"
            $("input").val();
            
            
            @val( val ) 
            // 將INPUT 的 VALUE 值 改變為指定
            // Before :  <input type="text" value="some text" />
            // Result :  <input type="text" value="test" />
            $("input").val("test");
            </pre>

 [1]: https://www.flickr.com/photos/appleboy/2378954219/ "js_1 by appleboy46, on Flickr"
 [2]: http://blog.gslin.org/archives/2008/04/01/1463/
 [3]: http://coppermine-gallery.net/
 [4]: https://addons.mozilla.org/en-US/firefox/addon/748
 [5]: http://blog.wu-boy.com/2008/02/23/140/
 [6]: http://userscripts.org/scripts/show/24610
 [7]: http://pic.wu-boy.com
 [8]: https://www.flickr.com/photos/appleboy/2378954319/ "js_2 by appleboy46, on Flickr"
 [9]: https://www.flickr.com/photos/appleboy/2379789784/ "js_3 by appleboy46, on Flickr"
 [10]: http://pic.segaa.net/
 [11]: https://www.flickr.com/photos/appleboy/2379789838/ "js_4 by appleboy46, on Flickr"
 [12]: https://www.flickr.com/photos/appleboy/2379801656/ "js_5 by appleboy46, on Flickr"
 [13]: http://blog.pixnet.net/shian0745/post/8718699