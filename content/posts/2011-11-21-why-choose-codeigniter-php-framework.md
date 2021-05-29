---
title: 為什麼要選擇 CodeIgniter PHP Framework？
author: appleboy
type: post
date: 2011-11-21T07:38:50+00:00
url: /2011/11/why-choose-codeigniter-php-framework/
dsq_thread_id:
  - 478970435
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 大家一定會有疑問，在眾多 PHP Framework 選擇下，我為什麼要推廣 

<a href="http://codeigniter.org.tw" target="_blank">CodeIgniter</a> 這套呢？寫這篇的原因就是我在<a href="http://phpwrite.blogspot.com/" target="_blank">腦殘 PHP 部落格</a>看到了這篇：[Codeigniter是萬靈丹？][1]，底下針對此作者寫的內容做一些回應 

> 在最近幾次去面試的過程 或是和朋友聊天聊到framework 都發現了一個問題 許多完完全全不懂framework的人一直在談論它的好 也發現了有很多基本PHP程式設計基礎都不好的人都在用它 連台灣在推廣它的人都把它尊奉為神.... 看完上面的內容，我實在很想知道，有哪些推廣 CI 的人，把 CI 尊奉為神？如果有的話，可以介紹認識認識。不知道此部落格作者有沒有深入想過，為什麼這些人會覺得 CI 非常好用和 CI 的好處在哪裡？至少在我聽到的大部都是覺得 **<span style="color:green">容易上手及架構清楚</span>**，光是這樣就足以讓一些基礎的人可以快速上手這套 Framework。 <!--more-->

> 在某個推廣它的blog看到 有人問了為什麼我用codeigniter使用 $this->input->post("user"); user是空值時，為什麼我存入資料庫會是填0？ 於是推廣它的人很好心的看了原始碼 發現codeigniter是這樣處理的 $this->input->post("user"); 為空值時會回傳FALSE，然後在database的函式庫內會將bool轉為0 所以就建議了發問者，應該要多增加判斷式，為FALSE時應該回傳NULL 相信有人看到這兒應該覺得我倒底在唸什麼...... 明說了！這個根本是一個大BUG！非常大的BUG 如果在這個情形之下的話！ 正確的處理方式是$this->input->post('user'); 要嘛就是丟出exception或者是回傳NULL 根本不應該回傳FLASE啊！ 這個應該對它提出質疑並修正它才對啊...... 看完上面這段，你應該是看到之前我寫的這篇 <a href="http://blog.wu-boy.com/2011/08/%E6%B7%B1%E5%85%A5%E6%8E%A2%E8%A8%8E-codeigniter-input-class-%E6%A0%B8%E5%BF%83%E7%A8%8B%E5%BC%8F%E6%B5%81%E7%A8%8B/" target="_blank">深入探討 CodeIgniter Input Class 核心程式流程</a> 教學，不過個人認為這不是一個 Bug，當使用者在欄位裡面沒有輸入任何值，系統會回傳 FALSE，這是沒有問題的，我想你應該是對於資料庫把此值轉為 0 有疑慮，為什麼資料庫會將資料轉為 0 呢？答案當然是**<span style="color:red">欄位型態不同</span>**，所以資料庫跟轉換了，那為什麼不在寫入資料庫之前把所有變數轉換成**<span style="color:green">符合</span>**欄位型態的格式呢？ 

<pre class="brush: php; title: ; notranslate" title="">$data = array(
    "user_id" => (int) $this->input->get_post("user_id"),
    "user_name" => (string) $this->input->get_post("user_name"),
    "user_company" => (string) $this->input->get_post("user_company"),
);</pre> 這樣是不是可以解決問題，還可以增加資料的正確及安全性，至少在國外 PHP 各大 open source 專案都是這樣在開發程式了。欄位是 string 就傳入 string 型態，布林型態就傳入布林型態。當欄位為空值時，CI 回傳 False，將 False 丟入到 int 欄位，資料庫當然會將此資料轉成 0，那你說這是 Bug 還是個人程式設計上面的疏失呢？如果您覺得這是 Bug 的話，那何不貢獻您的 Patch 提交到 

<a href="https://github.com/EllisLab/CodeIgniter" target="_blank">CodeIgniter Github</a> 上，而不是抱怨官方應該修正，才能符合您的期待。 

> 所以framework是萬靈丹嗎？ 當然不是，它的核心精神祇是協助你加速開發程式而已！ 最主要的還是你本身的程式設計基礎... 大家千萬別忽略了真正重要的事..... 最後一段說的非常好，Framework 核心精神就是加速開發程式，以及避免讓開發者在程式設計設面出現錯誤，至少安全性上面 Framework 都做的很好，當然這只是一個工具，工具需要大量的開發者去測試，以及回報貢獻 Patch，以利官方可以思考及掌握未來的 Road map。當然使用此工具之前，最好是對於 PHP 有一些程式的基礎，這樣學習起來會更快，這也是今年在台北 PHP 第一屆 Conference 我所講得 <a href="http://www.slideshare.net/appleboy/phpconf-2011-introductiontocodeigniter" target="_blank">快速上手 - CodeIgniter</a> 的前幾張 Slide。會推廣這套的原因，也只是單純希望台灣在 Web 領域可以有更多人接觸 Framework 這種程式架構，不管是不是 PHP 都是一樣，而我只是推薦大家比較簡單的架構，之後也許跳到其它 Framework 的時候，或許就可以減少很多摸索時間。

 [1]: http://phpwrite.blogspot.com/2011/11/codeigniter.html