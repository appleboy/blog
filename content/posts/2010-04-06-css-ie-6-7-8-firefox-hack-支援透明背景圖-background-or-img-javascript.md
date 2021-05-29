---
title: '[CSS] IE 6, 7, 8 FireFox hack 支援透明背景圖 background or img javascript'
author: appleboy
type: post
date: 2010-04-05T16:44:12+00:00
url: /2010/04/css-ie-6-7-8-firefox-hack-支援透明背景圖-background-or-img-javascript/
views:
  - 11532
bot_views:
  - 546
dsq_thread_id:
  - 246738581
categories:
  - CSS
  - javascript
tags:
  - CSS
  - html

---
先前在國外部落格發現一篇非常好用的教學：[Quick Tip: How to Target IE6, IE7, and IE8 Uniquely with 4 Characters][1]，裡面有提供一部教學影片，非常好用，也很實在，底下可以先看影片，看完大概就可以針對 IE, FireFox, Chrome 進行 CSS Hack。 目前網頁製作，要符合多瀏覽器跨平台([IE][2], [Safari][3], [Chrome][4], [FireFox][5]…等)，就必須動到 CSS Hack，雖然 Google 已經宣稱不支援 IE6，但是很多單位，很多學校跟客戶都是使用 IE6 瀏覽器，不只國內這樣，國外大廠也都希望支援 IE 系列，包含 IE6, IE7, IE8，這時候就必須知道如何分別針對各種不同 IE 做設定，底下就來看看實做例子。 <!--more-->

## 包含 IE8 底下瀏覽器 先看底下例子： 

<pre class="brush: css; title: ; notranslate" title="">body {
 color: red; /* all browsers, of course */
 color : green\9; /* IE8 and below */
}</pre> 請注意 color 後面的 

<span style="color:red">\9</span>，這是 IE only 的 tag，不可以任意修改，只有 IE 瀏覽器可以讀取，請勿修改成 \IE 或者是 \8 這些都是不對的，您會發現IE8,IE7,IE6 所有文字顏色都是綠色，但是 FireFox 是紅色。 

## 包含 IE7 底下瀏覽器 先看底下例子： 

<pre class="brush: css; title: ; notranslate" title="">body {
 color: red; /* all browsers, of course */
 color : green\9; /* IE8 and below */
 *color : yellow; /* IE7 and below */
}</pre> 上面例子可以發現，重點是在 *color 前面的 

<span style="color:red">*</span>，只有 IE7 跟其版本底下才看的到效果，上面程式碼會得到，FireFox Chrome 瀏覽器字型顏色是紅色，IE8 會是綠色，IE7 則是黃色。 

## 包含 IE6 底下瀏覽器 先看底下例子： 

<pre class="brush: css; title: ; notranslate" title="">body {  
 color: red; /* all browsers, of course */  
 color : green\9; /* IE8 and below */  
 *color : yellow; /* IE7 and below */  
 _color : orange; /* IE6 */  
}  </pre> 可以發現 

<span style="color:red">_</span> 是屬於 IE6 所認得的字元，全部瀏覽器會是紅色，IE8 會是綠色，IE7 會是黃色，IE6 會是橘色，這些都是 CSS Hack 的方法，大家可以注意到本篇重點就是在 <span style="color:green">\9 * _</span> 這三個符號，這三個符號針對了 IE8 IE7 IE6 這三個瀏覽器 CSS 的 Hack，也請大家注意優先權順序，如果把順序兌換，改成底下： 

<pre class="brush: css; title: ; notranslate" title="">body {  
 color: red; /* all browsers, of course */  
 _color : orange; /* IE6 */ 
 *color : yellow; /* IE7 and below */
 color : green\9; /* IE8 and below */   
}</pre> 可以去看看會出現什麼結果？ 

## IE6 Png 透明背景修正，以及 background-image filter 大家都知道 IE6 不支援透明背景 PNG 圖檔，所以網路上有很多解法，一種就是針對 img tag 做處理，另一種就是設定在 css background 的 IE6 filter，底下提供兩種不同狀況解法，第一種是 js 修改 img tag PNG 圖檔：這是網路上寫好的 js 檔案 

<pre class="brush: jscript; title: ; notranslate" title="">/*
 
Correctly handle PNG transparency in Win IE 5.5 & 6.
http://homepage.ntlworld.com/bobosola. Updated 18-Jan-2006.

Use in 

<HEAD>
  with DEFER keyword wrapped in conditional comments:
  <!--[if lt IE 7]>

<![endif]-->
  
  */
  
  var arVersion = navigator.appVersion.split("MSIE")
  var version = parseFloat(arVersion[1])
  
  if ((version >= 5.5) && (document.body.filters)) 
  {
     for(var i=0; i<document.images.length; i++)
     {
        var img = document.images[i]
        var imgName = img.src.toUpperCase()
        if (imgName.substring(imgName.length-3, imgName.length) == "PNG")
        {
           var imgID = (img.id) ? "id='" + img.id + "' " : ""
           var imgClass = (img.className) ? "class='" + img.className + "' " : ""
           var imgTitle = (img.title) ? "title='" + img.title + "' " : "title='" + img.alt + "' "
           var imgStyle = "display:inline-block;" + img.style.cssText 
           if (img.align == "left") imgStyle = "float:left;" + imgStyle
           if (img.align == "right") imgStyle = "float:right;" + imgStyle
           if (img.parentElement.href) imgStyle = "cursor:hand;" + imgStyle
           var strNewHTML = "<span " + imgID + imgClass + imgTitle
           + " style=\"" + "width:" + img.width + "px; height:" + img.height + "px;" + imgStyle + ";"
           + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
           + "(src=\'" + img.src + "\', sizingMethod='scale');\"></span>" 
           img.outerHTML = strNewHTML
           i = i-1
        }
     }
  }</pre>
  存檔之後，請在 header 中間加入底下：
  
  
  <pre class="brush: xml; title: ; notranslate" title=""><!--[if lt IE 7]>

<![endif]--></pre>
  另一種就是 css 狀況解法：
  
  
  <pre class="brush: css; title: ; notranslate" title="">#pic{
 background-image: none;
 filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='./images/test.png', sizingMethod='scale');
} </pre>
  如果要針對 IE6 瀏覽器，請改寫為
  
  
  <pre class="brush: css; title: ; notranslate" title="">#pic{
 background-image: url('./images/test.png');
 _background-image: none;
 filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='./images/test.png', sizingMethod='scale');
} </pre>
  這樣就可以了。當然您可以針對 IE6 去 import 不同 CSS 檔案
  
  
  <pre class="brush: xml; title: ; notranslate" title="">
<!--[if lt IE 7]>
  
<![endif]-->
</pre>
  
  另外就是要提一下 html 針對不同 IE 的 hack，這是微軟在 IE5 就開始支援的功能，在 html 註解都是使用 
  
  <span style="color:green"><!-- 註解開始 --></span>，這是所有瀏覽器都看得懂得註解，那微軟針對 IE 有提供不同的方式來針對各種 IE 瀏覽器版本進行 Hack，例如底下：
  
  
  
  <pre class="brush: xml; title: ; notranslate" title=""><!--[if lt IE 7]>
  我是 IE6 才會執行
<![endif]-->


<!--[if IE]>
  IE 才會執行的內容
<![endif]-->


<!--[if gte IE 8]>
  只有IE8以上(包含IE8)才會執行內容
<![endif]-->


<!--[if !IE]>-->
 

<p>
  您正在使用的瀏覽器不是 ie 。
</p>


<!--<![endif]--></pre>
  大致上是這樣，如果有任何問題，可以提出來一起討論，CSS Hack 真是好玩 ^^。因為以前在學校常常被 IE6 折磨所整理出來的 Q&A。希望對於 CSS 愛好者有幫助。
  
  reference:
  
  
  <a href="http://net.tutsplus.com/tutorials/html-css-techniques/quick-tip-how-to-target-ie6-ie7-and-ie8-uniquely-with-4-characters/">Quick Tip: How to Target IE6, IE7, and IE8 Uniquely with 4 Characters</a>
  <a href="http://boohover.pixnet.net/blog/post/12309095">Conditional Comments [if IE] : IE 專用 (IE only) 條件式 HTML 註解的語法</a>
  <a href="http://blog.kyart.com.tw/article/4593762575/3739511159/">IE6支援PNG透明背景 CSS設定</a>

 [1]: http://net.tutsplus.com/tutorials/html-css-techniques/quick-tip-how-to-target-ie6-ie7-and-ie8-uniquely-with-4-characters/
 [2]: http://www.microsoft.com/taiwan/products/ie/
 [3]: http://www.apple.com/tw/safari/download/
 [4]: http://www.google.com.tw/chrome
 [5]: http://moztw.org/