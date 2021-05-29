---
title: '[jQuery] 解決 IE6 PNG 透明背景 (Supersleight jQuery Plugin for Transparent PNGs in IE6)'
author: appleboy
type: post
date: 2010-05-02T08:56:05+00:00
url: /2010/05/jquery-解決-ie6-png-透明背景-supersleight-jquery-plugin-for-transparent-pngs-in-ie6/
views:
  - 12404
bot_views:
  - 622
dsq_thread_id:
  - 246750635
categories:
  - javascript
  - jQuery
tags:
  - CSS
  - IE
  - javascript
  - jQuery
  - png

---
今天無意間看到 [Drew McLellan][1] 在 2007 年寫了這篇 [Transparent PNGs in Internet Explorer 6][2]，真的是太晚發現這篇了，之前自己寫到一篇：『[[CSS] IE 6, 7, 8 FireFox hack 支援透明背景圖 background or img javascript][3]』，雖然 [Google 官方網站宣佈完全不支援 IE6 瀏覽器][4]，打算只支援 [Microsoft Internet Explorer 7.0+][5], [Mozilla Firefox 3.0+][6], [Google Chrome 4.0+][7], [Safari 3.0+][8]，可是我們這些 Web Developer 還是需要考慮客戶的瀏覽器阿，因為客戶才是最大的，尤其是在一些學術機構，安裝好 XP，預設就是 IE6，從 Google 分析裡面，IE6 也是網站的客戶大群。

先來介紹 Drew McLellan 寫的一支好用 js 來改善所有 png 透明圖檔，最主要是修正 background-image 跟 img tag 所包含的 png 圖檔

  1. 先下載：[Download SuperSleight][9]，解壓縮放到 js 資料夾

  2. 針對 IE6 瀏覽器寫入 html 
    
    <pre class="brush: xml; title: ; notranslate" title=""><!--[if lte IE 6]>
<script type="text/javascript" src="supersleight-min.js"></script>
<![endif]-->
</pre>

來分析 supersleight.js 檔案，看它是如何運作，底下是完整程式碼：

<pre class="brush: jscript; title: ; notranslate" title="">var supersleight = function() {
    var root = false;
    var applyPositioning = true;
    // Path to a transparent GIF image
    var shim = 'x.gif';
    // RegExp to match above GIF image name
    var shim_pattern = /x&#46;gif$/i;
    var fnLoadPngs = function() {
        if (root) {
            root = document.getElementById(root);
        }else{
            root = document;
        }
        for (var i = root.all.length - 1, obj = null; (obj = root.all<em></em>); i--) {
            // background pngs
            if (obj.currentStyle.backgroundImage.match(/&#46;png/i) !== null) {
                bg_fnFixPng(obj);
            }
            // image elements
            if (obj.tagName=='IMG' && obj.src.match(/&#46;png$/i) !== null){
                el_fnFixPng(obj);
            }
            // apply position to 'active' elements
            if (applyPositioning && (obj.tagName=='A' || obj.tagName=='INPUT') && obj.style.position === ''){
                obj.style.position = 'relative';
            }
        }
    };
    var bg_fnFixPng = function(obj) {
        var mode = 'scale';
        var bg  = obj.currentStyle.backgroundImage;
        var src = bg.substring(5,bg.length-2);
        if (obj.currentStyle.backgroundRepeat == 'no-repeat') {
            mode = 'crop';
        }
        obj.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "', sizingMethod='" + mode + "')";
        obj.style.backgroundImage = 'url('+shim+')';
    };
    var el_fnFixPng = function(img) {
        var src = img.src;
        img.style.width = img.width + "px";
        img.style.height = img.height + "px";
        img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "', sizingMethod='scale')";
        img.src = shim;
    };
    var addLoadEvent = function(func) {
        var oldonload = window.onload;
        if (typeof window.onload != 'function') {
            window.onload = func;
        } else {
            window.onload = function() {
                if (oldonload) {
                    oldonload();
                }
                func();
            };
        }
    };
    return {
        init: function() {
            addLoadEvent(fnLoadPngs);
        },
        limitTo: function(el) {
            root = el;
        },
        run: function() {
            fnLoadPngs();
        }
    };
}();
// limit to part of the page ... pass an ID to limitTo:
// supersleight.limitTo('header');
supersleight.init();
</pre>

bg\_fnFixPng: 針對背景圖修正 el\_fnFixPng: 針對單一 element 修正 fnLoadPngs: js 主要 function，會使用到上述兩個 function

列出 supersleight 特性:

  * 針對 inline and background images tag 作處理修正
  * 可以針對特定區域進行 PNG 透明修正，加速網站 Performence (預設是針對整個 body 進行轉換)

第二點的意思是說，本來是寫 supersleight.init(); 針對整個 body 作轉換動作，可以改為 supersleight.limitTo("header"); 假設您知道只有 header element 需要進行 PNG 的轉換，就可以使用此語法來加速網站執行速度。

## jQuery Plugin

[Supersleight jQuery Plugin for Transparent PNGs in IE6][10] 作者也寫了 [jQuery Plugin][11]，造福了 [jQuery][12] 使用者，使用方式也相當簡單。

可以針對單一區域進行變換 

<pre class="brush: jscript; title: ; notranslate" title="">$('#content').supersleight();</pre> 或者是針對整個 body 

<pre class="brush: jscript; title: ; notranslate" title="">$('body').supersleight();</pre> 因為 plugin 需要 transparent GIF shim image，所以將語法改成： 

<pre class="brush: jscript; title: ; notranslate" title="">$('body').supersleight({shim: '/img/transparent.gif'});</pre>

 [1]: http://24ways.org/
 [2]: http://24ways.org/2007/supersleight-transparent-png-in-ie6
 [3]: http://blog.wu-boy.com/2010/04/06/2110/
 [4]: http://googleenterprise.blogspot.com/2010/01/modern-browsers-for-modern-applications.html
 [5]: http://www.microsoft.com/windows/Internet-explorer/default.aspx
 [6]: http://www.mozilla.com/en-US/firefox/firefox.html
 [7]: http://www.google.com/chrome?brand=CHFV
 [8]: http://www.apple.com/safari/
 [9]: http://24ways.org/code/supersleight-transparent-png-in-ie6/supersleight.zip
 [10]: http://allinthehead.com/retro/338/supersleight-jquery-plugin
 [11]: http://plugins.jquery.com/
 [12]: http://jquery.com/