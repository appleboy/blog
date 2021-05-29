---
title: Google App Engine 收費機制 Frontend Instance Hours
author: appleboy
type: post
date: 2012-03-21T06:51:57+00:00
url: /2012/03/google-app-engine-frontend-instance-hours/
dsq_thread_id:
  - 618923642
categories:
  - Google
  - www
tags:
  - GAE
  - google
  - Google App Engine

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i0.wp.com/farm7.staticflickr.com/6046/7002236833_acf8926eae_o.png?w=840&#038;ssl=1" data-recalc-dims="1" />
</div> 最近把一個簡易的 Web 丟到 

<a href="http://code.google.com/intl/zh-TW/appengine/" target="_blank">Google App Engine</a> 測試，但是發現每天都會因為 Frontend Instance Hours 不夠用，而造成網站被關閉 (Quota 爆漿)，上網找一下解決方法，發現了這篇: <a href="http://groups.google.com/group/taipei-gtug/browse_thread/thread/8d00a11c0b2f4fe?pli=1" target="_blank">Frontend Instance Hours 的問題</a>，只要透過底下方式就可以暫時解決這問題，如果是網站流量很大的話，那可能要考慮開啟付費機制。 

### 解決方式 先進入 

<a href="https://appengine.google.com/" target="_blank">App engine 後台</a>，點選您的 Application 之後可以看到左邊選單 **<span style="color:green">Application Settings</span>**，進入後找到 **<span style="color:green">Max Idle Instances</span>** 還有 **<span style="color:green">Min Pending Latency</span>** 這兩項設定，我們必須將 Max Idle Instances 設定為**<span style="color:red">1</span>**，以及 Min Pending Latency 設定為 **<span style="color:red">15s</span>**，但是 Max Idle Instances 預設是不給修改，而是跑 default value "Automatic"，這時候，我們必須把 **<span style="color:red">inbound_services</span>** 設定為 warmup 才可以動態調整 **<span style="color:green">Max Idle Instances</span>**。 

### 設定 inbound_services 請打開網站根目錄底下的 

<a href="http://code.google.com/intl/zh-TW/appengine/docs/python/config/appconfig.html" target="_blank">app.yaml</a>，在上面加入 

<pre class="brush: bash; title: ; notranslate" title="">inbound_services:
- warmup</pre> 之後將設定上傳後，回到剛剛 

**<span style="color:green">Application Settings</span>** 將兩個數值調整為上面描述的設定，這樣就可以不用被 <a href="http://www.google.com" target="_blank">Google</a> 收費了，想省錢的朋友們，可以儘快設定。