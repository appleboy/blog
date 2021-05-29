---
title: '[jQuery] 解決 IE6 不支援 :hover CSS'
author: appleboy
type: post
date: 2009-04-03T06:14:22+00:00
url: /2009/04/jquery-解決-ie-不支援-hover-css/
views:
  - 12006
bot_views:
  - 564
dsq_thread_id:
  - 247003118
categories:
  - javascript
  - jQuery
  - www
tags:
  - jQuery

---
目前 IE 並不支援 :hover 的功能，難怪只有 [FireFox][1] 可以看的懂 :hover CSS 的功能，上網查了一下解決方法，當然就是利用幫忙處理瀏覽器相容性的 javascript Framework：利用 [jQuery][2] 就可以解決 IE 這部份的不相容，參考了 [Whatup 的 Blog][3]：[tr hover 在 IE 上的 hack][4]，解法也寫的很清楚。 先看看 html 

<pre class="brush: xml; title: ; notranslate" title=""><table border="0">
  
  
  
  <tr class="row1">
    <td>
      test1
    </td>
    
    
    <td>
      test2
    </td>
    
  </tr>
  
</table>
</pre> css 寫法： 

<pre class="brush: css; title: ; notranslate" title="">tr.row1	{ background-color: #EFEFEF; }
tr.row1:hover td{
background-color: #D1D7DC;
}</pre>

<!--more--> 上面 CSS 寫法 only for FirFox，所以必須搭配 

[jQuery][2] 來實做 hover 的 style，底下是修正 IE 的 CSS 問題： 

<pre class="brush: jscript; title: ; notranslate" title="">$(".row1").hover(function() {
$(this).css("background-color","#D1D7DC");
},function(){
$(this).css('background-color','#EFEFEF');
});</pre> 果然還是要靠 jQuery 來解決瀏覽器不相容的問題。

 [1]: http://www.moztw.org/
 [2]: http://jquery.com/
 [3]: http://blog.twkang.net
 [4]: http://blog.twkang.net/2008/11/08/tr-hover-%E5%9C%A8-ie-%E4%B8%8A%E7%9A%84-hack/