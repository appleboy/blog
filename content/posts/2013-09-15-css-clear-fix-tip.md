---
title: CSS Clear Fix 小技巧
author: appleboy
type: post
date: 2013-09-15T15:19:01+00:00
url: /2013/09/css-clear-fix-tip/
dsq_thread_id:
  - 1762704759
categories:
  - CSS
tags:
  - CSS
  - CSS Clear

---
記的之前 <a href="http://blog.evendesign.tw" target="_blank">evenwu</a> 為了找尋外包 CSS 人才，出了一份<a href="http://blog.evendesign.tw/post/38567423298/web-designer" target="_blank">考題</a>，有提供上機考，真是佛心來的，還給用 Inspector 或上網。其中一題就是

> 第二題、如果一個X元素內的子元素通通 float: left 請問X元素本身會有什麼狀況？如果我要在X元素內下背景，卻沒有顯示，請問如何解決？
解決方式就是實作本身 `clearfix`，或者是在元素後加上 `clear: both` 的標籤，大概就是底下的樣子

<div>
  <pre class="brush: xml; title: ; notranslate" title=""><div class="container">
  <div class="floated">
    
  </div>
      
  
  <div class="floated">
    
  </div>
      
  
  <div class="floated">
    
  </div>
      
  
  <p style="clear:both">
    
  </p>
  
</div></pre>
</div>

如果是要在 container 實作 clearfix，就必須透過 css `before` 和 `after`。

<div>
  <pre class="brush: css; title: ; notranslate" title="">.clearfix {
  *zoom: 1;
}
.clearfix:before, .clearfix:after {
  content: "";
  display: table;
  line-height: 0;
}
.clearfix:after {
  clear: both;
}</pre>
</div>

SASS 版本

<div>
  <pre class="brush: css; title: ; notranslate" title="">.clearfix {
  *zoom: 1;
  &:before,
  &:after {
    display: table;
    content: "";
    line-height: 0;
  }
  &:after {
    clear: both;
  }
}</pre>
</div>

這樣只要在任何 element 加上 clearfix css 就可以了，支援瀏覽器版版: [Firefox][1] 3.5+, [Safari][2] 4+, [Chrome][3], [Opera][4] 9+, [IE][5] 6+

 [1]: http://moztw.org/firefox/
 [2]: https://www.apple.com/tw/safari/
 [3]: http://www.google.com/intl/zh-TW/chrome/browser/
 [4]: http://www.opera.com/
 [5]: http://windows.microsoft.com/zh-tw/internet-explorer/download-ie