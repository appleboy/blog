---
title: '[jQuery筆記] 時間日期外掛：timepicker | jQuery Plugins'
author: appleboy
type: post
date: 2008-05-13T00:03:36+00:00
url: /2008/05/jquery筆記-時間日期外掛：timepicker-jquery-plugins/
views:
  - 13901
bot_views:
  - 1110
dsq_thread_id:
  - 247030750
categories:
  - AJAX
  - javascript
  - Linux
  - windows
tags:
  - AJAX
  - javascript
  - jQuery
  - plugin

---
之前因為需要使用到日期函式，就找到一個 jQuery 的 plugin：[[jQuery筆記] 好用的日期函式 datepicker][1]，然後現在又需要用到時間的外掛，因為 datepicker 只有日期，我需要使用到時間部份，24小時幾分幾秒之類的，所以又去找到了 [jQuery plugin][2] 裡面的 [timepicker][3]，官方提供的這個外掛，我用起來不能使用，一直給我吐錯誤訊息給我，所以我也裝不起來，後來解決方法，就是去找別人改寫好的 timepicker 來用，所以我覺得還蠻奇怪的，為啥官網提供的外掛不能使用，Orz。 然而我是去網路上再去找有人另外寫好的，底下是他的版權： 

<pre class="brush: xml; title: ; notranslate" title="">/*
 * Copyright (c) 2006 Sam Collett (http://www.texotela.co.uk)
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
 
/*
 * A time picker for jQuery
 * Based on original timePicker by Sam Collet (http://www.texotela.co.uk)
 * @name     timePicker
 * @version  0.1 
 * @author   Anders Fajerson (http://perifer.se)
 * @example  $("#mytime").timePicker();
 * @example  $("#mytime").timePicker({step:30, startTime:"15:00", endTime:"18:00"}); 
 */
</pre>

<!--more--> 他的使用方法非常簡單，她還搭配簡單的 css 技術，如果你沒有加上 css 語法的話，你的 js 是不會有動作的，所以請在標投的地方加上以下的css語法 

<pre class="brush: css; title: ; notranslate" title="">div.time-picker {
  position: absolute;
  height: 200px;
  width:60px;  /* needed for IE */
  overflow: auto;
  background: #fff;
  border: 1px solid #000;
  z-index: 99;
  margin-top: 1.1em;  
}

div.time-picker-12hours {
  width:90px; /* needed for IE */
}

div.time-picker ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}
div.time-picker li {
  padding: 1px;
  cursor: pointer;
}
div.time-picker li.selected {
  background: #316AC5;
  color: #fff;
}</pre> 在來就是最基本的語法 

<pre class="brush: jscript; title: ; notranslate" title="">// Default.
$("#time1").timePicker();</pre> 這是最簡單的，可以讓你出現下拉式選單 

<pre class="brush: jscript; title: ; notranslate" title="">// 02.00 AM - 03.30 PM, 15 minutes steps.
$("#time2").timePicker({
  startTime:new Date(0, 0, 0, 2, 0, 0),
  endTime:new Date(0, 0, 0, 15, 30, 0),
  show24Hours:false,
  separator:'.',
  step: 15});</pre> 設定起始時間跟結束時間，還蠻方便的，然後把24小時機制關掉，使用 AM 跟 PM 

<pre class="brush: jscript; title: ; notranslate" title="">// An example how the two helper functions can be used to achieve 
// advanced functionality.
// - Linking: When changing the first input the second input is updated and the
//   duration is kept.
// - Validation: If the second input has a time earlier than the firs input,
//   an error class is added.

// Use default settings
$("#time3, #time4").timePicker();
    
// Store time used by duration.
var oldTime = $.timePicker("#time3").getTime();

// Keep the duration between the two inputs.
$("#time3").change(function() {
  if ($("#time4").val()) { // Only update when second input has a value.
    // Calculate duration.
    var duration = ($.timePicker("#time4").getTime() - oldTime);
    var time = $.timePicker("#time3").getTime();
    // Calculate and update the time in the second input.
    $.timePicker("#time4").setTime(new Date(new Date(time.getTime() + duration)));
    oldTime = time;
  }
});
// Validate.
$("#time4").change(function() {
  if($.timePicker("#time3").getTime() > $.timePicker(this).getTime()) {
    $(this).addClass("error");
  }
  else {
    $(this).removeClass("error");
  }
});
});</pre> 這裡有兩個功能： 第一：當改變第一個輸入的話，就會自動把第二個輸入改變，至於改變多少，就是依照第一個輸入改變多少，輸入二就會改變多少。 第二：當第二個輸入小於第一個輸入的時候，就會以紅色的標記提醒。 相關參考網站： 作者網站： 

<http://labs.perifer.se/timedatepicker/> <http://plugins.jquery.com/project/timepicker> <http://www.texotela.co.uk/code/jquery/timepicker/>

 [1]: http://blog.wu-boy.com/2008/04/30/194/
 [2]: http://plugins.jquery.com/
 [3]: http://plugins.jquery.com/project/timepicker