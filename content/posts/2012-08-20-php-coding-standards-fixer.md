---
title: 快速修正專案 PHP Coding Standards
author: appleboy
type: post
date: 2012-08-20T03:52:32+00:00
url: /2012/08/php-coding-standards-fixer/
dsq_thread_id:
  - 811569625
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php
  - php-cs-fixer
  - php-fig

---
底下是之前的投影片教導創業團隊制定 PHP 程式碼規範，讓工程師可以遵循此規則達到團隊合作

<div style="margin-bottom:5px">
  <strong> <a href="http://www.slideshare.net/appleboy/maintainable-php-source-project-13712190" title="Maintainable PHP Source Project" target="_blank">Maintainable PHP Source Project</a> </strong> from <strong><a href="http://www.slideshare.net/appleboy" target="_blank">Bo-Yi Wu</a></strong>
</div>

投影片內容都是<a href="http://blog.wu-boy.com/2012/07/about-php-fig-group-coding-style-guide/" target="_blank">現有 PHP FIG Group 所制定的 PSR-0, PSR-1, PSR-2 規則</a>，那如何將既有專案的 Coding Style 轉換成上述標準呢，可以透過 <a href="http://cs.sensiolabs.org/" target="_blank">PHP Coding Standards Fixer tool</a> 來快速完成，此工具是由 <a href="http://www.symfony-project.org/" target="_blank">Symfony Framework</a> 完成。透過此工具可以快速且無痛轉換程式碼風格，舉個簡單例子:

<!--more-->

本來

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php
if ($a > $b)
{
    .....
}</pre>
</div>

轉換後變成

<div>
  <pre class="brush: php; title: ; notranslate" title=""><?php
if ($a > $b) {
    .....
}</pre>
</div>

也可以透過指定的方式來修正，例如: `indentation` (將 Tabs 轉換成 4 Spaces)，`trailing_spaces` (去除單行程式碼結尾空白)，`php_closing_tag` (忽略檔案結尾 ?> 符號) ... 等，大家可以到<a href="http://cs.sensiolabs.org/" target="_blank">官網</a>看看，如果是透過 `wget` 方式下載，請務必轉換該執行檔權限

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ chmod 755 /usr/local/bin/php-cs-fixer</pre>
</div>

如果是用在修正其他 Framework 上面，請務必注意 <a href="https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md" target="_blank">PSR-0</a> 規則會跟 Framework 命名方式相衝突 (如命名方式 by <a href="http://www.codeigniter.org.tw/" target="_blank">CodeIgniter</a>)