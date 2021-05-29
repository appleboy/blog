---
title: '前端工程師必看: 十大 CSS 技巧'
author: appleboy
type: post
date: 2014-01-03T07:05:53+00:00
url: /2014/01/10-great-css-tips-for-every-web-developer/
dsq_thread_id:
  - 2088865138
categories:
  - Compass CSS Framework
  - CSS
tags:
  - Compass
  - CSS
  - SASS

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/11699847034/" title="css3 by appleboy46, on Flickr"><img src="https://i2.wp.com/farm3.staticflickr.com/2847/11699847034_6b43d779b8_n.jpg?resize=228%2C320&#038;ssl=1" alt="css3" data-recalc-dims="1" /></a>
</div>

2014 年第一篇文章來寫前端工程師必須要瞭解的 [CSS] 技巧，此篇其實來自於 [KidsIL Blog][1] 內的一篇 [10 Great CSS Tips for every Web Developer][2]，裡面作者紀錄了十大 CSS 技巧，看完這十大後，發現有些技巧曾經出現在 [Even Wu 給網頁設計師的建議一文][3]，這些技巧都算是蠻基本的，對於前端工程師有很大的幫助，如果尚未瞭解或還沒開始使用的開發者，也可以建議團隊開始使用。底下內容來自於原網站，在加上筆者的一些補充。

<!--more-->

## 用 firebug 或 console 來除錯

在 [Firefox][4] 還沒有推出 [Developer Tools][5] 時，大家一定是用 [Firebug][6] 來除錯，2006 年 Firebug 第一版 release 出來，讓 web 開發者可以更快速的瞭解網站除錯，也可以透過 Firebug 來瞭解網站的 performance。但是現今，Firefox 推出了自家 Developer Tools，而 [Chrome][7] 也是有很多好用的 [Tool tips][8] 及強大的 [Workspace][9]，對 Workspace 不熟悉的，可以參考之前我寫的一篇: [Coding on workspace of Chrome Developer tools][10]。

## Float or Inline-Block css

先來看看[範例1][11]，中間有三個 column，分別用 `float: left` 方式來排列

<div>
  <pre class="brush: xml; title: ; notranslate" title="">


<div class="wrapper">
  <div class="column">
    test
  </div>
      
  
  <div class="column">
    test
  </div>
      
  
  <div class="column">
    test
  </div>
  
</div>
</pre>
</div>

CSS 寫法:

<div>
  <pre class="brush: css; title: ; notranslate" title="">.wrapper {
    width: 400px;
    min-height: 50px;
    background-color: red;
}

.column {
    float: left;
    width: 100px;
    height: 100px;
    background-color: blue;
    margin-left: 20px;
}</pre>
</div>

會發現背景紅色 `.wrapper` 區塊被砍了一半，原因就是沒使用 `clear: both`，正確解法請看[範例2][12]，如果不是用此解法，也可以將 float 取代成 `display: inline-block`，解法請看[範例3][13]。上述兩種解法是最常見的，終極解法可以透過 `pseudo-class :after` 來解決此問題，晚點會提到此解法

## 用 CSS animation 取代 Javascript

原文作者寫了一篇 [CSS3 Transitions to replace JavaScript animations][14] 文章，就是要告訴前端工程師盡可能將原本使用的 [jQuery][15] animation 取代成 CSS 作法，原因在於 CSS animation 的效能遠大於 [JavaScript Native Language][16] 效能，請參考 <http://www.cssanimate.com/> 網站。

## Form 表單請使用 Label input

上面的例子，只要點選 **Name** 或 **Email** 會發現瀏覽器游標自然會移動到 text input 欄位上，設定方式很簡單，只要將 `label` 的 `for attribute` 設定為 `input id` 即可

<div>
  <pre class="brush: bash; title: label language=example; notranslate" title="label language=example">
<label for="username">Name:</label><input type="text" id="username" />
<label for="email">Email:</label><input type="text" id="email" /></pre>
</div>

## Performance: Spiriting everything

每個網站一定會有很多小 icon 圖，不管是直接使用在 html 或者是寫在 CSS 內，在網路傳輸的時候，如果 10 張 icon 就會建立 10 條 connection，然而 [css_spite][17] 就是解決了此問題，將所有的小圖集結成一張大圖，透過 css 設定來減少網路連線數，網路上很多工具來達成此目的，像是 [CSS Sprite Generator][18]，如果熟悉 [Compass][19] 工具，可以直接使用 [Spriting with Compass][20]

<div>
  <pre class="brush: css; title: CSS language=Example; notranslate" title="CSS language=Example">
.my-icons-sprite,
.my-icons-delete,
.my-icons-edit,
.my-icons-new,
.my-icons-save   { background: url('/images/my-icons-s34fe0604ab.png') no-repeat; }

.my-icons-delete { background-position: 0 0; }
.my-icons-edit   { background-position: 0 -32px; }
.my-icons-new    { background-position: 0 -64px; }
.my-icons-save   { background-position: 0 -96px; }
</pre>
</div>

## 不修改 image width & height attribute

這點其實蠻重要的，現在網站架構的瓶頸，說實在的 80% 以上都是在讀取圖檔，有時候 UI 設計師切出一張大圖，前端工程師拿去使用，結果圖檔很大，工程師就直接透過 css width height 修改圖片大小，這樣看起來是沒問題，但是網站就開始很慢，使用者開始不爽，網站自然就不會有人繼續用。正確方式就是將 image resize 成各種版本，可以直接參考這篇 [Tools for image optimization][21]

  * Generate multi-resolution images: [grunt-responsive-images][22]
  * [Clowncar][23] technique: [grunt-clowncar][24]

## 使用 max width and height 來調整 image 比例

這招其實還蠻好用的，我們先來看看例子

我們看到這張圖本來的比例大小為寬 228 高 320，但是經過底下 CSS 語法

<div>
  <pre class="brush: css; title: ; notranslate" title="">img {
    width: 228px;
    height: 228px;
}
</pre>
</div>

圖片就變成上述的例子，但是如果我們把 CSS 改成底下呢

<div>
  <pre class="brush: css; title: ; notranslate" title="">img {
    max-width: 228px;
    max-height: 228px;
}
</pre>
</div>

出來的結果就是

<img src="https://i2.wp.com/farm3.staticflickr.com/2847/11699847034_6b43d779b8_n.jpg?w=840&#038;ssl=1" style="max-width: 228px;max-height: 228px;" alt="css3" data-recalc-dims="1" /> 

## 善用 :before and :after

在前面有提到 `float: left` 後要加上一個 element `clear: both` 現在我們可以透過 `:after` 來解決這問題

<div>
  <pre class="brush: css; title: ; notranslate" title="">.wrapper:after {
    content: ' ';
    clear:both;
    display:block;
}</pre>
</div>

## 減少 CSS 程式碼

這部份就是減少不必要的程式碼

<div>
  <pre class="brush: css; title: ; notranslate" title="">.class {
    margin-top:5px;
    margin-right:10px;
    margin-bottom:15px;
    margin-left:20px;
}
</pre>
</div>

可以寫成

<div>
  <pre class="brush: css; title: ; notranslate" title="">.class {
    margin:5px 10px 15px 20px;
}</pre>
</div>

CSS color 部份 `#RRGGBB` 可以寫成 `#RGB`

## SASS or Compass

團隊內尚未使用 [SASS][25] 或 [Compass][19] 嗎？個人建議儘快導入這兩套工具，還不熟悉這兩套工具，建議將底下投影片看完

  * [Sass language 和 Compass 教學投影片][26]
  * [淺談 SASS ＆ Maintainable CSS][27]
  * [Sass + Compass 101 Workshop][28]
  * [Recreating Subtle Design Details Using Sass][29]

 [1]: http://www.kidsil.net
 [2]: http://www.kidsil.net/2013/12/10-great-css-tips/
 [3]: http://blog.evendesign.tw/post/38567423298/web-designer
 [4]: http://www.mozilla.org
 [5]: https://developer.mozilla.org/en-US/docs/Tools
 [6]: https://getfirebug.com/
 [7]: http://www.google.com/intl/zh-TW/chrome/
 [8]: https://developers.google.com/chrome-developer-tools/docs/tips-and-tricks
 [9]: https://developers.google.com/chrome-developer-tools/docs/settings#workspace
 [10]: http://blog.wu-boy.com/2013/07/coding-on-workspace-of-chrome-developer-tools/
 [11]: http://jsfiddle.net/appleboy/t8rLQ/
 [12]: http://jsfiddle.net/appleboy/t8rLQ/1/
 [13]: http://jsfiddle.net/appleboy/t8rLQ/2/
 [14]: http://www.kidsil.net/2013/12/10-great-css-tips/www.kidsil.net/2013/11/css3-transitions-to-replace-javascript-animations/
 [15]: http://jquery.com/
 [16]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
 [17]: http://en.wikipedia.org/wiki/Sprite_%28computer_graphics%29
 [18]: http://spritegen.website-performance.org/
 [19]: http://compass-style.org/
 [20]: http://compass-style.org/help/tutorials/spriting/
 [21]: http://addyosmani.com/blog/image-optimization-tools/
 [22]: https://github.com/andismith/grunt-responsive-images
 [23]: http://coding.smashingmagazine.com/2013/06/02/clown-car-technique-solving-for-adaptive-images-in-responsive-web-design/
 [24]: https://npmjs.org/package/grunt-clowncar
 [25]: http://sass-lang.com/
 [26]: http://blog.wu-boy.com/2011/11/the-future-of-stylesheets-sass-compass/
 [27]: https://speakerdeck.com/zheng7615/qian-tan-sass-maintainable-css
 [28]: https://speakerdeck.com/hlb/sass-plus-compass-101-workshop
 [29]: http://timhettler.github.io/cssconf-2013/#!/0