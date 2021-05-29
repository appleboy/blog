---
title: '[jQuery] 如何取得 select List index 和 value 值'
author: appleboy
type: post
date: 2009-03-20T06:44:12+00:00
url: /2009/03/jquery-如何取得-select-liset-index-和-value-值/
views:
  - 25334
bot_views:
  - 589
dsq_thread_id:
  - 246919550
categories:
  - AJAX
  - javascript
  - jQuery
tags:
  - jQuery

---
上次寫了 [[jQuery] 表單取值 radio checkbox select text 驗證表單][1]，這篇淺顯易懂，在 ptt 有人問到如何把 select 的 value 跟 text 值加入到另一個 select 的 options 裡面，其實還蠻簡單的，利用 [jQuery - Select box manipulation][2] 這個 plugin 就可以輕鬆做到了，底下是我的一些筆記心得：

## 實作案例

首先如何取得 select 的 value 跟 text

<pre><code class="language-js">/*
*
* 取得 select value 值
*/
$(&#039;#selectList&#039;).val();</code></pre>

取得 text 值，可以利用 :selected 這個

<pre><code class="language-js">/*
*
* 取得 select text 值
*/
$(&#039;#selectList :selected&#039;).text();</code></pre>

<!--more-->

底下是一個範例，實做選取 select options 加入到另一個 select，html 部份：

<pre><code class="language-html">&lt;select id="test1" name="test1" /&gt;
  &lt;option value="1"&gt;中正大學&lt;/option&gt;
  &lt;option value="2"&gt;台灣大學&lt;/option&gt;
  &lt;option value="3"&gt;交通大學&lt;/option&gt;
&lt;/select&gt;
&lt;select id="test2" /&gt;
  &lt;option value="0"&gt;請選擇&lt;/option&gt;
&lt;/select&gt;</code></pre>

jQuery 部份：

<pre><code class="language-js">$("#test1").change(function(){
  /*
  * $(this).val() : #test1 的 value 值
  * $(&#039;#test1 :selected&#039;).text() : #test1 的 text 值     
  */
  $("#test2").addOption($(this).val(), $(&#039;#test1 :selected&#039;).text());
});</code></pre>

## 參考文章

  * [jQuery Tip - Getting Select List Values][3]

 [1]: http://blog.wu-boy.com/2009/03/18/1024/
 [2]: http://www.texotela.co.uk/code/jquery/select/
 [3]: http://marcgrabanski.com/article/jquery-select-list-values