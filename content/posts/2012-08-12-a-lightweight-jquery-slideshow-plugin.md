---
title: 輕量級 jQuery Slideshow Plugin
author: appleboy
type: post
date: 2012-08-12T06:08:42+00:00
url: /2012/08/a-lightweight-jquery-slideshow-plugin/
dsq_thread_id:
  - 802077413
categories:
  - AJAX
  - javascript
  - jQuery

---
相信在網路上可以找到一堆 jQuery Slideshow Plugin，例如 <a href="http://www.themeflash.com/30-powerful-jquery-slideshow-sliders-plugins-and-tutorials/" target="_blank">33 POWERFUL JQUERY SLIDESHOW (SLIDERS) PLUGINS AND TUTORIALS</a> 介紹了 33 種不同的 Slideshow Plugin，有些用起來很複雜，有些則是過於簡易，本來是想自己寫一套出來，但是想想是否可以找一套已經有輪子的架構，再拿來修改成專案所需要的套件，於是參考了<a href="https://github.com/Ephigenia/jquery.slideShow" target="_blank">這套</a>原始碼，發現此專案只有提供 fade 和 slide 兩種效果，沒有像是投影片可以任意滑動的功能，所以自己把此功能 patch 上去，可以參考我放到 <a href="https://github.com/appleboy/jquery.slideShow" target="_blank">Github 的專案</a>，寫法很容易，可以直接看<a href="http://appleboy.github.com/jquery/example_2/" target="_blank">線上 Example</a>。 

### 載入 jQuery 和 plugin

<pre class="brush: xml; title: ; notranslate" title=""></pre>

<!--more-->

### Html 和 CSS

<pre class="brush: xml; title: ; notranslate" title=""><div class="slideShow">
  <ul class="slides">
    <li class="slide">
      <img src="900_360_2815b8f28c58175b52b535bf51f3e692.png" width="900" height="360" /></a>
    </li>
            
    
    <li class="slide">
      <img src="900_360_46d09a37f76f27815daafc4b96e46399.png" width="900" height="360" /></a>
    </li>
            
    
    <li class="slide">
      <img src="900_360_cae9a566a9a5e3a42af8b04f2ea299a0.png" width="900" height="360" /></a>
    </li>
            
    
    <li class="slide">
      <img src="900_360_dd9bb48bc247ee3f8358bea788e08ce0.png" width="900" height="360" /></a>
    </li>
            
    
    <li class="slide">
      <img src="900_360_63fa2bcabc296f47758d6aaebf23a530.png" width="900" height="360" /></a>
    </li>
        
  </ul>
      
  
  <ul class="pager">
    <li>
      <a href="javascript:void(0);" class="prev">Previous</a>
    </li>
            
    
    <li>
      <a href="javascript:void(0);" class="next">Next</a>
    </li>
        
  </ul>
  
</div></pre> 可以搭配後端 PHP, Python, Ruby 輸出網站輪播圖片 

### SlideShow Plugin

<pre class="brush: jscript; title: ; notranslate" title="">(function ($) {
    $('.slideShow').slideShow({
        interval: 3,
        start: 'random',
        transition: {
            mode: 'slideshow',
            speed: 800
        }
    });
})(jQuery);</pre> 可以自行定義輪播間隔時間，初始化為隨機或者是指定任一張圖片，以及輪播速度...等，詳細部份可以參考

<a href="https://github.com/Ephigenia/jquery.slideShow/blob/master/README.md" target="_blank">官方作者寫的 README</a> 

### [完整 Example][1]

### [jQuery Slideshow Plugin Source Code][2]

 [1]: http://appleboy.github.com/jquery/example_2/
 [2]: https://github.com/appleboy/jquery.slideShow