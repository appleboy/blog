---
title: 利用 IE7 CSS 2.0 tbody 解決 IE6 hover 問題
author: appleboy
type: post
date: 2009-05-07T03:43:42+00:00
url: /2009/05/利用-css-tbody-解決-ie-hover-問題/
views:
  - 7948
bot_views:
  - 573
dsq_thread_id:
  - 247039342
categories:
  - CSS
  - jQuery
tags:
  - CSS
  - jQuery

---
**update 2009.05.07: IE7 之後開始支援 CSS 2.0，因此可以開始使用 hover** 之前發表一篇用 <a href="http://blog.wu-boy.com/2009/04/03/1131/" target="_blank">jQuery 解決 IE 不支援 :hover css</a>，今天在看 <a href="http://handlino.com/" target="_blank">和多</a> 寫的網站 [Registrano][1] html 原始碼，發現利用 CSS 也可以辦到啦，底下就是 Registrano css 原始碼： html 部份： 

<pre class="brush: xml; title: ; notranslate" title=""><table class="auto">
  <tr>
    <td>
      test1
    </td>
        
    
    <td>
      test2
    </td>
      
  </tr>
  
</table></pre>

<!--more--> CSS 原始碼： 

<pre class="brush: css; title: ; notranslate" title="">table.auto tbody tr:hover td,
table.auto tbody tr:hover th {
    background-color: #CBFF95;
}
</pre>

<del datetime="2009-05-07T07:26:13+00:00">重點在於 tbody 這裡喔。</del>

 [1]: http://registrano.com