---
title: Google App Engine SDK：python 基本教學安裝
author: appleboy
type: post
date: 2009-03-07T04:41:30+00:00
url: /2009/03/google-app-engine-sdk：python-基本教學安裝/
views:
  - 16396
bot_views:
  - 575
dsq_thread_id:
  - 246739145
categories:
  - FreeBSD
  - Linux
  - Network
  - www
tags:
  - FreeBSD
  - google
  - Linux
  - Python

---
<img src="https://i0.wp.com/code.google.com/appengine/images/appengine-silver-120x30.gif?resize=120%2C30" alt="Powered by Google App Engine" data-recalc-dims="1" /> [Google App Engine][1] 利用 python 程式語言所組成，可以利用 [Google][2] 背後的技術來開發您的 Web application，後端就交給 Google 的強大雲端運算能力，前端就可以利用 [SDK][3] 來開發您的 Web 介面，後端儲存可以用 [Google][2] <a href="http://labs.google.com/papers/bigtable.html" target="_blank">Bigtable</a> 及 <a href="http://labs.google.com/papers/gfs.html" target="_blank">GFS</a> 的儲存方式，那現在就不多說了，花了一點時間把環境建立起來，遇到一些問題，現在來筆記一下，目前我在 [FreeBSD][4] 7.1 Release 來當作 [Google App Engine][1] 開發平台，在安裝方面有遇到一些小問題，底下來看看： 在 FreeBSD 安裝方法還蠻簡單的，首先把 python 環境弄好 

<pre class="brush: bash; title: ; notranslate" title=""># cd /usr/ports/lang/python25/
# make install clean</pre> 底下這張圖就是安裝好的結果： 

[<img title="GAE (by appleboy46)" src="https://i2.wp.com/farm4.static.flickr.com/3556/3333900131_dd95bd7d35.jpg?resize=500%2C151&#038;ssl=1" alt="GAE (by appleboy46)" data-recalc-dims="1" />][5] <!--more--> 安裝好之後就是下載開發環境 SDK 

[Downloads][3]，目前支援 Mac OS、Linux、Windows 都可以安裝： 當然我就選擇 Linux 的 zip 檔案，下載好解壓縮就可以了，接下來介紹怎麼使用，其實網路上說明文件都寫的還蠻詳細的，解壓縮產生一個資料夾 google_appengine，裡面兩個檔案是大家都會用到的： 

  * [dev_appserver.py][6]：這個檔案用來編譯您寫的 Web application
  * [appcfg.py][7]：用來上傳您寫好的檔案到 App Engine 系統 再來寫測試檔案，測試看看喔，寫一個 

[Hello, World!][8] 來看看 先建立一個 hello 的資料夾 

<pre class="brush: bash; title: ; notranslate" title=""># mkdir hello</pre> 裡面放入兩個檔案，分別是：hello.py 跟 app.yaml，hello.py 就是您的程式檔案，app.yaml 就是網站設定檔，檔案內容分別如下： hello.py： 

<pre class="brush: python; title: ; notranslate" title="">print 'Content-Type: text/plain'
print ''
print 'Hello, world!'</pre> app.yaml： 

<pre class="brush: bash; title: ; notranslate" title="">application: hello
version: 1
runtime: python
api_version: 1

handlers:
- url: /.*
script: hello.py</pre> 接下來開始編譯：利用 dev_appserver.py 這隻 python 程式編譯 

<pre class="brush: bash; title: ; notranslate" title="">google_appengine/dev_appserver.py hello</pre> 這樣預設編譯 8080 port，這樣就可以利用 http://localhost:8080 來看到網站，不過底下會出現一些問題： 

<pre class="brush: bash; title: ; notranslate" title="">WARNING  2009-03-07 03:09:14,371 dev_appserver.py] 
Could not initialize images API; you are likely missing the Python "PIL" module. ImportError: No module named _imaging</pre> 這個問題，就是沒有安裝 pytho 的 imaging 這隻 ports，我是參考了 

[FreeBSD ports and Python versions][9]，找到答案的，所以解決方式如下 

<pre class="brush: bash; title: ; notranslate" title=""># cd /usr/ports/graphics/py-imaging
# make install clean</pre> 再來就是為甚麼只能在本機端觀看網頁，只要不是用 127.0.0.1 跟 localhost 就不能看，我想要用 domain name 下去看阿，所以只要加上參數就可以了 

<pre class="brush: bash; title: ; notranslate" title="">google_appengine/dev_appserver.py --address=0.0.0.0 --port=9999 hello</pre> 這樣就可以利用 host name 下去看了，也可以把預設 8080 port 改成 9999，另外一個問題： 

<pre class="brush: bash; title: ; notranslate" title="">WARNING  2009-03-07 04:27:36,197 datastore_file_stub.py] 
Could not read datastore data from /tmp/dev_appserver.datastore</pre> 這問題其實很簡單，這只是提供一個 warning 的訊息，不會造成系統不能啟動，因為如果您是寫 hello 這隻程式，根本不需要用到 data store 自然就會提醒出這個訊息，如果該檔案沒有存在也會出現這個訊息，不過系統會在啟動自動建立，所以也不用擔心，然而如果您 compiler demo 檔案，就是 guest book 這個資料夾 

<pre class="brush: bash; title: ; notranslate" title="">google_appengine/dev_appserver.py --address=0.0.0.0 --port=9999 google_appengine/demos/guestbook</pre> 系統因為剛開始找不到 dev_appserver.datastore 這個檔案，所以會有 warning 訊息，然後也會自動建立該檔案，等您下次從新啟動，這個 warning 訊息就會消失了，可以參考此 

[文章][10]，您也可以利用 --datastore_path=/usr/home/hello/datastore 來改變存 data store 的地方。 參考文章： [ericsk][11] 大大文章： [Google App Engine][12]

 [1]: http://code.google.com/appengine/
 [2]: http://www.google.com.tw/
 [3]: http://code.google.com/appengine/downloads.html
 [4]: http://www.tw.freebsd.org/
 [5]: https://www.flickr.com/photos/appleboy/3333900131/ "GAE (by appleboy46)"
 [6]: http://code.google.com/appengine/docs/python/tools/devserver.html
 [7]: http://code.google.com/appengine/docs/python/tools/uploadinganapp.html
 [8]: http://code.google.com/appengine/docs/python/gettingstarted/helloworld.html
 [9]: http://blog.e-shell.org/35
 [10]: http://markmail.org/message/7woseyiwv5vlbkty#query:Could%20not%20read%20data%20store%20data+page:1+mid:7woseyiwv5vlbkty+state:results
 [11]: http://blog.ericsk.org/
 [12]: http://blog.ericsk.org/archives/884 "Google App Engine"