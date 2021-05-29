---
title: '[PHP] Class: RSS Generator 產生器'
author: appleboy
type: post
date: 2009-05-08T03:48:42+00:00
url: /2009/05/php-class-rss-generator-產生器/
views:
  - 11643
bot_views:
  - 413
dsq_thread_id:
  - 246757213
categories:
  - php
tags:
  - php

---
最近在寫新聞系統，需要 <a href="http://zh.wikipedia.org/wiki/RSS" target="_blank">RSS</a> 線上訂閱的功能，所以在 <a href="http://www.phpclasses.org" target="_blank">PHP Classes</a> 找到了 <a href="http://www.phpclasses.org/browse/package/2569.html" target="_blank">RSS Generator</a> 產生器，這產生器使用起來也相當方便，在測試的時候剛好遇到一個問題，就是要對內容做 escape 的動作，避免 RSS 爛掉，看到 gslin 大的發表一篇 <a title="Permanent Link to &quot;WordPress 的 exporter&quot;" rel="bookmark" href="http://blog.gslin.org/archives/2009/04/24/2002/">WordPress 的 exporter</a> 裡面寫到 WordPress 的產生 xml 格式沒有經過 escape 造成程式亂掉『<a onclick="javascript:pageTracker._trackPageview('/outbound/article/core.trac.wordpress.org');" href="https://core.trac.wordpress.org/ticket/9524">Exporter does not escape url</a>』，當然解決方法也很容易，那就是用 <a href="http://tw2.php.net/htmlspecialchars" target="_blank">htmlspecialchars</a>，避免 url 裡面帶有 & 符號。 解決方法很容易，如下就可以了 

<pre class="brush: php; title: ; notranslate" title=""><?php
$item->link = htmlentities($url, ENT_QUOTES);
?></pre>