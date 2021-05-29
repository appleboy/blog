---
title: Nginx 判斷檔案是否存在
author: appleboy
type: post
date: 2012-11-29T13:58:01+00:00
url: /2012/11/nginx-check-if-file-exists/
dsq_thread_id:
  - 949810982
categories:
  - CodeIgniter
  - Nginx
tags:
  - CodeIgniter
  - nginx

---
如果你有在使用 <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a> + <a href="http://nginx.org/" target="_blank">Nginx</a> + <a href="http://php-fpm.org/" target="_blank">PHP-FPM</a> 使用者，務必看到這篇 <a href="https://github.com/EllisLab/CodeIgniter/issues/2038" target="_blank">CLI problem nginx php-fpm</a>，在使用 CLI 時候會有些問題，解決方式也非常簡單，只要在 index.php 裡面加上 

<pre class="brush: php; title: ; notranslate" title="">$_SERVER['PATH_INFO'] = NULL;</pre> 當然這篇最主要不是講這個，而是最後我有提到一篇解法，在 

<a href="http://www.farinspace.com/codeigniter-nginx-rewrite-rules/" target="_blank">Nginx 裡面如何設定 rewrite 功能</a>，比較不同的是，現在不用在設定這麼複雜了，要判斷檔案是否存在，不要在使用下面方式 

<pre class="brush: bash; title: ; notranslate" title="">server {
  root /var/www/domain.com;
  location / {
    if (!-f $request_filename) {
      break;
    }
  }
}</pre> 而必須改成 

<pre class="brush: bash; title: ; notranslate" title="">location / {
    try_files $uri $uri/ /index.php;
}</pre> 請看 

<a href="http://wiki.nginx.org/Pitfalls#Check_IF_File_Exists" target="_blank">Check IF File Exists</a>，看完之後可以拿掉很多設定，讓 Nginx 設定檔看起來更簡單容易。 參考: <a href="http://wiki.nginx.org/NginxHttpCoreModule#try_files" target="_blank">try_files</a>