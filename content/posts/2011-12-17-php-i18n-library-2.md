---
title: PHP 多國語系製作 i18n library 筆記 (二)
author: appleboy
type: post
date: 2011-12-17T12:53:11+00:00
url: /2011/12/php-i18n-library-2/
dsq_thread_id:
  - 507437622
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - i18n
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div> 繼續上篇講到 

<a href="http://blog.wu-boy.com/2011/12/php-i18n-library/" target="_blank">PHP 多國語系製作 i18n library 筆記 (一)</a>，相信大家使用上沒有任何問題， 但是一定會有共同疑問，那就是可不可以做到根據偵測瀏覽器來決定預設載入語系，也就是說 load method 只需要帶入第一個參數即可。 

<pre class="brush: php; title: ; notranslate" title="">$lang = new Language();
$lang->load("about");
echo $lang->line("index") . "\n";</pre>

<!--more--> 我們可以透過 

<span style="color:green"><strong>$_SERVER['HTTP_ACCEPT_LANGUAGE']</strong></span> 來取得瀏覽器語系資料，底下先來看 <span style="color:green"><strong>$_SERVER['HTTP_ACCEPT_LANGUAGE']</strong></span> 輸出什麼資訊，以英文版 FireFox 為例 

<pre class="brush: bash; title: ; notranslate" title="">en-us,en;q=0.5</pre> 我們只需要 en-us 字串，所以寫一個 \_default\_lang method 來處理 

<pre class="brush: php; title: ; notranslate" title="">private function _default_lang()
{
    $browser_lang = !empty($_SERVER['HTTP_ACCEPT_LANGUAGE']) ? strtolower(strtok(strip_tags($_SERVER['HTTP_ACCEPT_LANGUAGE']), ',')) : '';
    return (!empty($browser_lang) and array_key_exists($browser_lang, $this->_language_list)) ? strtolower($browser_lang) : 'en-us';
}</pre> 拿到 en-us 字串後，該如何對應到 language/english 目錄呢，那就是需要一個陣列對照表 

<pre class="brush: php; title: ; notranslate" title="">$this->language_list = array(
    'en-us' => 'english',
    'zh-tw' => 'zh-tw'
);</pre> 並且將 load method 部份改寫 

<pre class="brush: php; title: ; notranslate" title="">public function load($langfile = '', $idiom = 'english')
{
    // 省略幾千行程式碼 ......

    if ($idiom == '')
    {
        $deft_lang = $this->language_list[$this->__default_lang()];
        $idiom = ($deft_lang == '') ? 'english' : $deft_lang;
    }

    // 省略幾千行程式碼 ......
}</pre> 寫到這裡，我相信讀者又會出現一個疑問，那就是該如何切換語系呢？大部份都是透過 $_GET['lang'] 變數修改，並且將定存放在 session，接著看如何寫這段程式碼 

<pre class="brush: php; title: ; notranslate" title="">private function _set_language()
{
    $lang = (isset($_GET['lang'])) ? strtolower($_GET['lang']) : (isset($_GET['lang'])) ? strtolower($_GET['lang']) : "";
    if ($lang != '')
    {
        // check lang is exist in group
        if (array_key_exists($lang, $this->language_list))
        {
            $_SESSION['lang'] = $lang;
        }
    }

    // set default browser language
    if (!isset($_SESSION['lang']))
    {
        $_SESSION['lang'] = $this->_default_lang();
    }

    $this->language_folder = $this->language_list[$_SESSION['lang']];
    return $this;
}</pre> load method 改成底下 

<pre class="brush: php; title: ; notranslate" title="">public function load($langfile = '', $idiom = '')
{
    $this->_set_language();

    // 省略幾千行程式碼 ......

    if ($idiom == '')
    {
        $deft_lang = $this->language_folder;
        $idiom = ($deft_lang == '') ? 'english' : $deft_lang;
    }

    // 省略幾千行程式碼 ......

}</pre> index.php 測試程式請改成 

<pre class="brush: php; title: ; notranslate" title=""><?php
session_start();
include("Language.php");

$lang = new Language();

$lang->load("about");

echo "

<h1>
  Index value
</h1>";
echo "

<p>
  " . $lang->line("index") . "
</p>";
echo "

<a href='index.php?lang=zh-TW'>Chinese</a> | <a href='index.php?lang=en-US'>English</a><br />";</pre> 上面程式碼已經完成一個簡單的多國語系雛型，這裏面會有一個小 bug，那就是假如兩個檔案 a.php 跟 b.php 語系檔裏面都包含 

<pre class="brush: php; title: ; notranslate" title="">$lang['index'] = "xxxx";</pre> 這樣就會衝突，為了解決此問題，將架構改成 

<pre class="brush: bash; title: ; notranslate" title=""># load a 時
$this->load("a")
# load a 語系
$this->line("a.index")

# load a 時
$this->load("b")
# load a 語系
$this->line("b.index")</pre> 這時我們必須增加每個語系的 prefix 

<pre class="brush: php; title: ; notranslate" title="">private function _set_prefix($lang = array())
{
    $output = array();
    foreach ($lang as $key => $val)
    {
        $key = $this->language_prefix . "." . $key;
        $output[$key] = $val;
    }

    return $output;
}</pre> load method 改寫 

<pre class="brush: php; title: ; notranslate" title="">public function load($langfile = '', $idiom = '')
{
    $this->_set_language();

    $langfile = str_replace('.php', '', $langfile);
    // set prefix name
    $this->language_prefix = $langfile;

    // 省略幾千行程式碼 ......

    // add prefix value of array key
    $lang = $this->_set_prefix($lang);
    $this->language = array_merge($this->language, $lang);
    unset($lang);

    return TRUE;
}</pre> 多國語系就介紹到這裡了，如可以到 

<a href="https://github.com/appleboy/php-i18n" target="_blank">php-i18n @ githib</a> 參考程式碼，至於 <a href="http://codeigniter.org.tw/" target="_blank">CodeIgniter</a> 可以參考 <a href="https://github.com/appleboy/CodeIgniter-i18n" target="_blank">CodeIgniter-i18n @ github</a>