---
title: '[PHP] preg_replace 效能測試 (將兩個空白字元以上取代成一個)'
author: appleboy
type: post
date: 2012-09-21T12:28:29+00:00
url: /2012/09/php-preg_replace-performance/
dsq_thread_id:
  - 853235819
categories:
  - php
tags:
  - Performance
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div>

<a href="http://php.net/manual/en/function.preg-replace.php" target="_blank">preg_replace</a> 可以使用正規語法來取代字串任何字元，，今天探討取代空白字元的效能，雖然這是個不起眼的效能評估，一般人不太會這樣去改，不過這是國外 PHP Framework 有人提出來修正的，經過許多人的測試一致同意。功能就是一篇文章內如果有多餘的空白能空取代成一個，一般人都會用 **<span style="color:green">\s+</span>** 正規語法，畢竟大家都知道 \s 代表單一空白或 \r 等符號，但是國外有人提出用 **<span style="color:green">{2,}</span>** 方式來取代空白。程式碼如下，大家可以測試看看。 

<pre class="brush: php; title: ; notranslate" title=""><?php
$nb = 10000;
$str = str_repeat('Hi, I am appleboy  ' . "\n", 10);
$t1 = microtime(true);
for ($i = $nb; $i--; ) {
    preg_replace('/\s+/', ' ', $str);
}
$t2 = microtime(true);
for ($i = $nb; $i--; ) {
    preg_replace('/ {2,}/', ' ', str_replace(array("\r", "\n", "\t", "\x0B", "\x0C"), ' ', $str));
}
$t3 = microtime(true);

echo $t2 - $t1;
echo "\n";
echo $t3 - $t2;[/code]

測試結果(1萬次)
<!--more-->
PHP 5.3.3
old: 0.13053798675537
new: 0.058536052703857

PHP 5.3.15
old: 0.11732506752014
new: 0.071418046951294

PHP 5.3.17
old: 0.11612010002136
new: 0.07065486907959

PHP 5.4.5
old: 0.1185781955719
new: 0.066012859344482

PHP 5.4.7
old: 0.11343121528625
new: 0.066931962966919
</pre> 結論至少快蠻多的，如果整體資料量再大一點，我想差別會更大，那至於要不要用呢，就看個人了 XD。