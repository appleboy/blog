---
title: CSS 垂直置中解法
author: appleboy
type: post
date: 2013-07-04T05:14:21+00:00
url: /2013/07/css-vertical-align-center/
categories:
  - CSS
tags:
  - CSS
  - inline-block

---
相信大家在 <a href="http://www.google.com" target="_blank">Google</a> 可以找到很多<a href="https://www.google.com.tw/search?q=css+vertical-align+center&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a" target="_blank">解法</a>，這幾天在 Facebook 發現<a href="https://www.facebook.com/josephj6802/posts/10200920251622230" target="_blank">更精彩的解決方式</a>，就是用 <a href="http://www.w3schools.com/cssref/sel_before.asp" target="_blank">CSS:before</a> 跟 <a href="http://www.w3schools.com/cssref/pr_class_display.asp" target="_blank">inline-block</a>，底下提供範例:

html 程式碼

<pre><code class="language-html">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset=utf-8 /&gt;
&lt;title&gt;JS Bin&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
  &lt;div class="ot"&gt;
    &lt;div class="wrapper"&gt;&lt;/div&gt;
  &lt;/div&gt; 
&lt;/body&gt;
&lt;/html&gt;</code></pre>

<!--more-->

CSS 程式碼

<pre><code class="language-css">.ot {
  width: 400px;
  height: 400px;
  border: 1px solid #FF6600;
  text-align: center;
  margin: 0 auto;
}

.ot:before {
  content: &#039;&#039;;
  display: inline-block;
  vertical-align: middle ;
  height: 100%;
}

.wrapper {
  display: inline-block;
  vertical-align: middle;
  width: 200px;
  height: 200px;
  background: #ccc;
}</code></pre>

Demo 結果

[JS Bin][1]{.jsbin-embed}

感謝留言提供一個不錯的<a href="http://www.iyunlu.com/view/css-xhtml/77.html" target="_blank">教學連結: 未知高度多行文本垂直居中</a>，可以讓文字置中，也是透過上述方法。一般單行文字置中，可以透過底下方式

<pre><code class="language-csss">.text {
  height: 26px;
  line-height: 26px;
}</code></pre>

如果是多行文字呢？也就是如果透過 P 標籤來顯示

> xxxxxxxxxxx

<pre><code class="language-css">*{margin:0;padding:0;}

.box{
  height:200px;
  width:300px;
  background:pink;
  margin:30px auto;
  font-size:0;
}
.box:before{
  content: &#039;&#039;;
  display: inline-block;
  vertical-align: middle;
  width: 0;
  height: 100%;
}
.text{
  display: inline-block;
  font-size:16px;
  vertical-align: middle;
}</code></pre>

Demo 如下

[多行文本未知高度垂直居中-by一丝][2]{.jsbin-embed}

 [1]: http://jsbin.com/ezodok/1/embed?live
 [2]: http://jsbin.com/ifexef/4/embed?live