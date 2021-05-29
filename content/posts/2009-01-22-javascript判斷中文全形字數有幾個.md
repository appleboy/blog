---
title: '[javascript]判斷中文全形字數有幾個'
author: appleboy
type: post
date: 2009-01-22T12:46:06+00:00
url: /2009/01/javascript判斷中文全形字數有幾個/
views:
  - 10849
bot_views:
  - 1144
dsq_thread_id:
  - 247173310
categories:
  - javascript
  - www
tags:
  - AJAX
  - javascript

---
在 [ptt][1] [bbs][2] 的 AJAX 版討論到如何判斷計算有幾個中文字數，那 TonyQ 兄跟 toshii 兄分別提供了兩種方法，我自己測試了一下包含全形字型，如：？，。…這些都算喔，我自己想到 [中華電信][3] [emome][4] 的簡訊系統也會有判斷數字加上英文跟中文字的算法，看了一下大致上都是相同的。 TonyQ 解法： 

<pre class="brush: jscript; title: ; notranslate" title="">/*
利用 regex pattern
*/
function chineseCount(word){
    return word.split(/[\u4e00-\u9a05]/).length -1;
}

var word="test中asd文asd字as到底asd有幾asd個?";
alert(chineseCount(word));
</pre>

<!--more--> toshii 解法： function chineseCount(word){ v=0 for(cc=0;cc<word.length;cc++){ c = word.charCodeAt(cc); if (!(c>=32&&c<=126)) v++; } return v } var word="test中asd文asd字as到底asd有幾asd個?"; alert(chineseCount(word));[/code] 中華電信 emome 簡訊系統解法： [code lang="javascript"] function chineseCount(word){ var v = 0; for(var i=0;i<word.length;i++){ var c = word.charAt(i); var c2= word.charCodeAt(i); if(c2 > 0x7f) { tmp1 = false; for(var t=0;t<14832;t++) { if(c2==big5define[t]) { tmp1 = true; v++; } } } } return v; } var word="test中asd文asd字as到底asd有幾asd個?"; alert(chineseCount(word)); [/code]

 [1]: http://www.ptt.cc/index.html
 [2]: telnet://ptt.cc
 [3]: http://www.cht.com.tw/
 [4]: http://www.emome.net/