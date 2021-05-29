---
title: '[筆記] iframe 父頁子頁呼叫函式 parent call function'
author: appleboy
type: post
date: 2010-05-07T16:13:48+00:00
url: /2010/05/筆記-iframe-父頁子頁呼叫函式-parent-call-function/
views:
  - 6482
bot_views:
  - 419
dsq_thread_id:
  - 246724264
categories:
  - javascript
tags:
  - html
  - javascript

---
紀錄 iframe 如何呼叫子頁或者是父頁函式，iframe 在現今 Web 2.0 時代已經不流行了，因為有很多問題的存在，例如對於 SEO 搜尋引擎也沒有幫助，但是也是很多人在使用，底下筆記心得，說不定之後會 google 到自己的文章，哈哈。 父頁(主視窗)呼叫子頁函式： 

<pre class="brush: jscript; title: ; notranslate" title="">/* iframeID 是 iframe ID*/
window.iframeID.formSubmit();
/* ifr 是 iframe ID */
document.getElementById('ifr').contentWindow.formSubmit();
</pre> 子頁(iframe)呼叫父頁(主視窗)函式： 

<pre class="brush: jscript; title: ; notranslate" title="">parent.formSubmit();</pre> 如果有兩層 

<pre class="brush: jscript; title: ; notranslate" title="">parent.parent.formSubmit();</pre> 注意 timing issue，等 iframe 視窗 load 完之後才可以呼叫 iframe function。至於如果取主視窗跟 iframe 的變數 value，可以利用 jQuery $("#ID") 方式來得到。 reference: 

[【程式】JS : parent , iframe function call][1] [Access child function from iframe][2]

 [1]: http://blog.xuite.net/chingwei/blog/22953175
 [2]: http://www.codingforums.com/showthread.php?t=136737