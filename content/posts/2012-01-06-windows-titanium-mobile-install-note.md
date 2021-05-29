---
title: Windows Titanium Mobile 入門安裝紀錄
author: appleboy
type: post
date: 2012-01-06T02:52:40+00:00
url: /2012/01/windows-titanium-mobile-install-note/
dsq_thread_id:
  - 528468420
categories:
  - Titanium Mobile
tags:
  - Mobile
  - Titanium
  - windows

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6644783075/" title="PROD_tit_mobile by appleboy46, on Flickr"><img src="https://i0.wp.com/farm8.staticflickr.com/7007/6644783075_453701f61a_m.jpg?resize=240%2C163&#038;ssl=1" alt="PROD_tit_mobile" data-recalc-dims="1" /></a>
</div> 最近安裝 Windows 版本 

<a href="http://www.appcelerator.com/products/titanium-mobile-application-development/" target="_blank">Titanium Mobile SDK</a> 遇到蠻多地雷，也不確定官方什麼時候會把這 Bug 解掉，安裝過程可以參考閃光大部落格 <a href="http://tc.hinablue.me/945" target="_blank">[Titanium note.] Titanium Mobile, Windows + Android 入門安裝</a>，其實最主要就是三個套件必須安裝: 

  * <a href="http://www.oracle.com/technetwork/java/javase/downloads/index.html" target="_blank">Java SDK</a>
  * <a href="http://developer.android.com/sdk/index.html" target="_blank">Android SDK</a>
  * <a href="http://www.appcelerator.com/products/download/" target="_blank">Titanium Studio</a> 請先註冊帳號 請務必註冊 Titanium Studio 新帳號，不然沒辦法下載安裝檔案以及登入使用 Titanium Studio，下載好三個檔案後，請務必注意底下事項，免的安裝好之後沒辦法在 Titanium Studio 測試模擬器。Java SDK 就直接下載安裝，這邊比較沒有問題。 1. Android SDK 請務必安裝在 C:/ 底下即可，不要安裝在 "C:/Program File" 2. 安裝完成務必增加 Path 路徑，ANDROID\_SDK 跟 JAVA\_HOME 

<pre class="brush: bash; title: ; notranslate" title="">ANDROID_SDK: C:\android-sdk
JAVA_HOME: C:\Program Files\Java\jdk1.6.0_30</pre> 最後注意 Titanium Studio 的 mobilesdk 編譯模擬器的程式，因為執行編譯指令沒有加上 quote 符號，所以造成 SD Card 錯誤，所以請找檔案 

<span style="color:green"><strong>mobilesdk/win32/1.7.5/android/builder.py</strong></span>，將 405 行處的程式碼換掉，原本是 

<pre class="brush: bash; title: ; notranslate" title="">self.sdcard,</pre> 請改成 

<pre class="brush: bash; title: ; notranslate" title="">'\"' + self.sdcard + '\"',</pre>