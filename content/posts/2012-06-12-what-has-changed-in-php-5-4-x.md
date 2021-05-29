---
title: 程式設計師需要注意的 PHP 5.4 變化
author: appleboy
type: post
date: 2012-06-12T05:48:51+00:00
url: /2012/06/what-has-changed-in-php-5-4-x/
dsq_thread_id:
  - 722317524
categories:
  - php
tags:
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div>

<a href="http://www.php.net" target="_blank">PHP</a> 5.4.0 在美國時間2012年3月1號釋出，到現在已經發展到 <a href="http://www.php.net/archive/2012.php#id2012-05-08-1" target="_blank">5.4.3</a>，之前寫過一篇 <a href="http://blog.wu-boy.com/2012/03/php-5-4-0-released/" target="_blank">PHP 5.4.0 released!! 新功能</a>，這次我們來探討看看 PHP 5.4.x 對於程式設計師在轉換平台或者是開發新功能所需要注意的地方。 <!--more-->

### Incompatible Changes 1. 

<a href="http://docs.php.net/manual/en/features.safe-mode.php" target="_blank">Safe mode</a> 不再被支援，如果專案有任何牽扯到 Safe mode，請務必要調整 2. <a href="http://docs.php.net/manual/en/security.magicquotes.php" target="_blank">Magic quotes</a> 正式被移除，基本上目前開發 PHP 程式，務必將此設定為 FALSE，這樣之後轉移機器比較不會有任何問題，由於此設定已被移除，所以 <a href="http://docs.php.net/manual/en/function.get-magic-quotes-gpc.php" target="_blank">get_magic_quotes_gpc()</a> and <a href="http://docs.php.net/manual/en/function.get-magic-quotes-runtime.php" target="_blank">get_magic_quotes_runtime()</a> 這兩函式都會直接 **<span style="color:red">return FALSE</span>**; 3. php.ini 正式移除 <a href="http://docs.php.net/manual/en/ini.core.php#ini.register-globals" target="_blank">register_globals</a> and <a href="http://docs.php.net/manual/en/ini.core.php#ini.register-long-arrays" target="_blank">register_long_arrays</a> 兩項設定，這就不必多說了，遇到 POST 或 GET 資料，請大家全部改用 <span style="color:green"><strong>$_POST</strong></span> 或 <span style="color:green"><strong>$_GET</strong></span> 4. 移除 <a href="http://docs.php.net/manual/en/language.references.pass.php" target="_blank">Call-time pass by reference</a> 功能 以前可以 Call-time pass by reference 傳位址到 function 參數 

<pre class="brush: php; title: ; notranslate" title=""><?php
function foo($var)
{
    $var++;
}

$a=5;
foo(&$a);
// $a is 6 here
?></pre> 5.4.X 請改寫成底下方式 

<pre class="brush: php; title: ; notranslate" title=""><?php
function foo(&$var)
{
    $var++;
}

$a=5;
foo($a);
?></pre> 或是用 global 寫法 

<pre class="brush: php; title: ; notranslate" title=""><?php
$a = 5;
function foo()
{
    global $a;
    $a++;
}
// $a is 6 here
?></pre> 5. 

<a href="http://docs.php.net/manual/en/control-structures.break.php" target="_blank">break</a> and <a href="http://docs.php.net/manual/en/control-structures.continue.php" target="_blank">continue</a> 不再接受變數參數 (e.g., break 1 + foo() * $bar;)，另外 break 0; 跟 continue 0; 也不能使用，只能直接使用 break 1; break 2; 等 之前如果這樣寫 

<pre class="brush: php; title: ; notranslate" title="">$num = 2; 
break $num;</pre> 在 5.4.x 請改寫成 

<pre class="brush: php; title: ; notranslate" title="">break 2;</pre> 6. 在 

<a href="http://docs.php.net/manual/en/book.datetime.php" target="_blank">date and time extension</a>，timezone 不再使用 TZ environment variable，進而取代用 php.ini 裡的 date.timezone 或者是使用 php <a href="http://docs.php.net/manual/en/function.date-default-timezone-set.php" target="_blank">date_default_timezone_set()</a> function，如果都沒有設定，PHP 將會吐出 E_WARNING 訊息 7. <a href="http://docs.php.net/manual/en/function.isset.php" target="_blank">isset()</a> 跟 <a href="http://docs.php.net/manual/en/function.empty.php" target="_blank">empty()</a> 變化 我想大家對這兩個函數並不陌生，isset 用來判斷變數<span style="color:red">是否存在</span>，empty 用來判斷變數<span style="color:red">是否為空值</span>，在 5.4 比較值得注意的地方是 isset on string 的用法。 PHP 5.3.x 以前 

<pre class="brush: php; title: ; notranslate" title=""><?php
$expected_array_got_string = 'somestring';
var_dump(isset($expected_array_got_string['some_key']));
var_dump(isset($expected_array_got_string[0]));
var_dump(isset($expected_array_got_string['0']));
var_dump(isset($expected_array_got_string[0.5]));
var_dump(isset($expected_array_got_string['0.5']));
var_dump(isset($expected_array_got_string['0 Mostel']));
?></pre> 大家會發現全部 return true;，可是到了 PHP 5.4.X 版本，除了 [0] 或 ['0'] 會 return true 之外，其他都是 return false;。不過個人建議程式最好不要這樣寫，在判斷變數是否存在的時候，最好先透過 

<a href="http://docs.php.net/manual/en/function.is-array.php" target="_blank">is_array()</a> 跟 <a href="http://docs.php.net/manual/en/function.is-string.php" target="_blank">is_string()</a> 判斷此變數是 array 或者是 string，反而上面的舉例是很少看到的。 8. 禁止 super globals 變數當作任何 function 參數，例如: 

<pre class="brush: php; title: ; notranslate" title="">function ($_POST, $_GET) {
}</pre> 9. 移除 

<a href="http://docs.php.net/manual/en/function.session-is-registered.php" target="_blank">session_is_registered()</a>, <a href="http://docs.php.net/manual/en/function.session-register.php" target="_blank">session_register()</a> and <a href="http://docs.php.net/manual/en/function.session-unregister.php" target="_blank">session_unregister()</a> function。 Session 的操作其實非常簡單，上面的 function 其實都是多餘的。 判斷 Session 是否存在: 

<pre class="brush: php; title: ; notranslate" title="">if (isset($_SESSION['foo']))
{
    echo 'session is exist';
}</pre> 註冊 Session 

<pre class="brush: php; title: ; notranslate" title="">$_SESSION['foo'] = 'bar';</pre> 移除 Session 

<pre class="brush: php; title: ; notranslate" title="">unset($_SESSION['foo']);</pre> 結論是操作 Session 就等同於操作 array 是一樣意思，所以才說那三個 function 早該移除了。 

### 新功能 (New features) 可以先看之前寫的一篇 

<a href="http://blog.wu-boy.com/2012/03/php-5-4-0-released/" target="_blank">PHP 5.4.0 released!! 新功能</a> 裡面提到 <a href="http://docs.php.net/manual/en/language.oop5.traits.php" target="_blank">traits</a>, array 新用法以及 <a href="http://docs.php.net/manual/en/features.commandline.webserver.php" target="_blank">web server in CLI mode</a>，另外底下在整理幾點新功能: 1. <a href="http://docs.php.net/manual/en/ini.core.php#ini.short-open-tag" target="_blank">short_open_tag</a> 不需要設定就可以支援，也就是說底下程式會變成通用寫法 我們在 view 裡面都會這樣寫 

<pre class="brush: php; title: ; notranslate" title=""><?php echo $foo; ?></pre> 或者是(先決條件是將 short\_open\_tag 設定為 on) 

<pre class="brush: php; title: ; notranslate" title=""><?= $foo;?></pre> 但是在 PHP 5.4.X 之後全部支援 short\_open\_tag 寫法。不過勸大家還是不要懶惰，用最原始的寫法還是最安全的。 2. 支援 Class member access on instantiation has been added 以前宣告 Class 都必須透過指定單一變數 

<pre class="brush: php; title: ; notranslate" title="">$test = new foo();
$test->bar();</pre> 5.4.X 可以透過底下寫法 

<pre class="brush: php; title: ; notranslate" title="">(new foo)->bar();</pre> 其實還有很多細節的部份，可以直接參考官網 

<a href="http://docs.php.net/manual/en/migration54.php" target="_blank">Migrating from PHP 5.3.x to PHP 5.4.x</a>，希望上面的例子，可以讓大家更瞭解 PHP 5.4.X。