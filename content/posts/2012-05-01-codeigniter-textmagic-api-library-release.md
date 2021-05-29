---
title: CodeIgniter TextMagic API Library Release (簡訊功能)
author: appleboy
type: post
date: 2012-05-01T08:16:05+00:00
url: /2012/05/codeigniter-textmagic-api-library-release/
dsq_thread_id:
  - 671209245
categories:
  - CodeIgniter
  - php
tags:
  - API
  - CodeIgniter
  - php
  - SMS
  - TextMagic

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i1.wp.com/farm5.static.flickr.com/4139/4928689646_4309e16e13_o.png?w=840&#038;ssl=1" alt="CodeIgniter" data-recalc-dims="1" />
</div> 之前寫了 

<a href="http://blog.wu-boy.com/2011/11/codeigniter-nexmo-message-api-library-release/" target="_blank">Nexmo 簡訊 API Library for CodeIgniter Framework</a>，現在又發現國外新的一家簡訊系統，叫做 <a href="http://www.textmagic.com" target="_blank">TextMagic</a>，看了一下<a href="http://www.textmagic.com/app/pages/en/pricing-coverage" target="_blank">簡訊價格</a>，27 美金可以傳送 285 通簡訊，似乎比 <a href="http://nexmo.com/" target="_blank">Nexmo</a> 還貴了一些，不過沒關係，TextMagic 還支援了後台系統或者是 Email 來傳送簡訊，這點倒是不錯，相較於 Nexmo，TextMagic 後台多了太多功能了，不多說了，直接來使用 <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> TextMagic Libray。 <!--more-->

### 申請簡訊帳號跟密碼 先到 TextMagic 註冊新帳號，完成之後請到

<a href="https://www.textmagic.com/app/wt/account/api/cmd/password" target="_blank">後台申請API密碼</a>。這樣大致上完成。 

### 從 getsparks 安裝 如果您有在使用 

<a href="http://getsparks.org/" target="_blank">Getsparks</a> 服務，透過此方式安裝是最快的，請參考 <a href="http://getsparks.org/packages/TextMagic-SMS-API/show" target="_blank">TextMagic-SMS-API getsparks website</a> 

<pre class="brush: bash; title: ; notranslate" title="">// install from getSparks website
$ php tools/spark install -v1.0.1 TextMagic-SMS-API
// include TextMagic Library to controller
$this->load->spark('TextMagic-SMS-API/1.0.1');
</pre> 如果不想透過 getsparks 安裝，可以直接到 

<a href="https://github.com/appleboy/CodeIgniter-TextMagic-API" target="_blank">Github CodeIgniter-TextMagic-API</a> 下載 Source Code，將檔案放入到您的 application 目錄底下即可。 

### 使用方式 用 API 之前，請先閱讀 

<a href="http://api.textmagic.com/https-api/textmagic-api-commands" target="_blank">官方 TextMagic API 文件</a>，搭配 <a href="https://github.com/appleboy/CodeIgniter-TextMagic-API/blob/master/README.markdown" target="_blank">Github CodeIgniter-TextMagic-API Readme 文件</a> 即可。 如果有任何問題都可以直接留言給我。 

### 原始碼

<a href="https://github.com/appleboy/CodeIgniter-TextMagic-API" target="_blank">CodeIgniter-TextMagic-API Github Source Code</a> <a href="http://getsparks.org/packages/TextMagic-SMS-API/show" target="_blank">Getsparks TextMagic-SMS-API</a>