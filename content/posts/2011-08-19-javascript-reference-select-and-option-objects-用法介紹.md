---
title: JavaScript Reference Select and Option objects 用法介紹
author: appleboy
type: post
date: 2011-08-19T08:18:08+00:00
url: /2011/08/javascript-reference-select-and-option-objects-用法介紹/
dsq_thread_id:
  - 390386642
categories:
  - javascript
  - jQuery
tags:
  - javascript
  - jQuery

---
在網頁裡面用 <a href="http://www.w3schools.com/jsref/dom_obj_select.asp" target="_blank">Select</a> 是很常遇到的，之前也寫了一篇<a href="http://blog.wu-boy.com/2009/03/jquery-%E5%A6%82%E4%BD%95%E5%8F%96%E5%BE%97-select-liset-index-%E5%92%8C-value-%E5%80%BC/" target="_blank">如何利用 jQuery 動態增加 option 或取值</a>，<a href="http://jQuery.com" target="_blank">jQuery</a> 部份就不介紹了，那是需要搭配 <a href="http://www.texotela.co.uk/code/jquery/select/" target="_blank">jQuery Plugin: Select box manipulation</a>，今天要介紹的是如何用 javascript 動態取值或者是增加 option 選項。因為我發現有使用者直接利用 <a href="http://www.tizag.com/javascriptT/javascript-innerHTML.php" target="_blank">innerHtml</a> 的方式來把資料塞入到 Select 裡面，雖然 <a href="http://moztw.org/" target="_blank">FireFox</a> 或 <a href="http://www.google.com/chrome?hl=zh-TW" target="_blank">Chrome</a> 都可以正常運作，但是遇到 IE 還是沒辦法動。 

### 如何取得 select element 底下很多方法可以取得 select element: 1. 透過 form name + element name 

<pre class="brush: jscript; title: ; notranslate" title="">document.myform.selectname</pre> 2. 透過 form name + element 陣列(注意看 select 是位在 form element index 值多少) 

<pre class="brush: jscript; title: ; notranslate" title="">document.myform.elements<em></em></pre> 3. 透過獨一無二的 ID 

<pre class="brush: jscript; title: ; notranslate" title="">document.getElementById("selectid")</pre>

<!--more-->

### 如何取得 select option 選項 透過陣列方式取得 option 選項。取第一個選項: 

<pre class="brush: jscript; title: ; notranslate" title="">document.getElementById("myselect").options[0]</pre> 取第四個選項 

<pre class="brush: jscript; title: ; notranslate" title="">document.getElementById("myselect").options[3] </pre>

### 如何取得 select option value 跟 text 直接在 option 後面接上 value 跟 text 即可 

<pre class="brush: jscript; title: ; notranslate" title="">document.getElementById("myselect").options[0].value 
document.getElementById("myselect").options[3].text </pre>

### Select Event 介紹

<span style="color:red">onBlur</span>: 假設目前 focus 在 select 上時，如果下一步移開到另一個 element 的時候將會觸發 <span style="color:red">onChange</span>: 用於選單選項改變時，會觸發條件，底下看個簡單例子 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 首先我們可以看到程式碼 

<span style="color:green"><strong>selectmenu.onchange</strong></span>，也就是選擇其他選項時候將會觸發，透過 <span style="color:green"><strong>this.selectedIndex</strong></span> 你選擇的 index 來取 value 值。 <span style="color:red">onFocus</span>: 如果 focus 在 Select element 時，將會觸發 

### Select Property 介紹

<span style="color:red">disabled</span>: 設定 Boolean value 用來控制 select 是否 disabled。 <span style="color:red">length</span>: 計算有多少個 options 

<pre class="brush: jscript; title: ; notranslate" title="">document.getElementById("mymenu").length</pre>

<span style="color:red">selectedIndex</span>: 用來取得目前 options 陣列索引值 index，假如沒有選任何選項則回傳 -1，底下範例: 

<pre class="brush: jscript; title: ; notranslate" title=""></pre>

<span style="color:red">type</span>: select 提供兩種 type: select-one 跟 select-multiple，我們可以針對 form 裡面所有的 element 來找出屬於 select 選單，底下範例： 

<pre class="brush: jscript; title: ; notranslate" title=""></pre>

### Select Methods 介紹

<span style="color:red">add(newoption, beforeoption*)</span>: 用來動態增加 option，不多說底下先來看一個範例 

<pre class="brush: jscript; title: ; notranslate" title=""></pre> 從上面程式，大家可以看到透過 new Option("text", "value") 來動態新增 option，至於 add 的第二個參數是設定要增加到哪個 option 後面，IE 瀏覽器必須用 integer 來帶入，其他瀏覽器都需要 object reference。 

<span style="color:red"><strong>*Important</strong></span>: beforeoption should be an object reference to an option except in IE, where it must be an integer representing the index of the option instead. <span style="color:red">remove(optionindex)</span>: 移除 option，只要知道 index 即可刪除，看底下範例 

<pre class="brush: jscript; title: ; notranslate" title="">var myselect=document.getElementById("sample")
myselect.remove(myselect.length-1) //removes last option within SELECT</pre> 上面範例是移除最後一個 option 

### Select Option object 介紹

<span style="color:red">index</span>: 回傳該 option index 值 <span style="color:red">selected</span>: 判斷是否選擇了該 option，直接看範例: 

<pre class="brush: jscript; title: ; notranslate" title=""></pre>

<span style="color:red">text</span>: option 指定說明 <span style="color:red">value</span>: option 指定值 

### 如何取代既有的 option 只要針對該 option index 重新指定 new Option 即可，底下範例： 

<pre class="brush: jscript; title: ; notranslate" title="">var myselect=document.getElementById("sample")
myselect.options[0]=new Option("New 1st option", "who") //replace 1st option with a new one
myselect.options[myselect.length]=new Option("Brand new option", "what") //add a new option to the end of SELECT</pre> 上面全部的範例皆來自 

<a href="http://www.javascriptkit.com/jsref/select.shtml" target="_blank">JavaScript Reference Select 網站</a>