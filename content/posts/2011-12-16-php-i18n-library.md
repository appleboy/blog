---
title: PHP 多國語系製作 i18n library 筆記 (一)
author: appleboy
type: post
date: 2011-12-16T15:00:27+00:00
url: /2011/12/php-i18n-library/
dsq_thread_id:
  - 506520790
categories:
  - php
tags:
  - i18n
  - php

---
<div style="margin: 0 auto;text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6034284842/" title="php-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" alt="php-logo" data-recalc-dims="1" /></a>
</div> 多國語系是目前網站必有的模組，至少都會支援繁體中文及英文，那大家都怎麼設計多國語系的架構呢，底下來一步一步來介紹。 

### 多國語系目錄架構

<pre class="brush: bash; title: ; notranslate" title="">language/
---> englisg/
---------> about.php
---> zh-tw/
---------> about.php
---> zh-cn/
---------> about.php
</pre> 這是大部分的專案設計模式，也最容易清楚了解，接著我們就寫一個簡單的 Language Class 來動態讀取各國語系。 

<!--more-->

### 撰寫 Language Class 在根目錄新增 index.php 及 language.php，當然還有 language 多國語系目錄，檔案內容如下 

**<span style="color:green">index.php</span>** 

<pre class="brush: php; title: ; notranslate" title=""><?php
include("Language.php");
$lang = new Language();
[/code]
<strong>

<span style="color:green">language.php</span></strong>
<?php
class Language {
    public function __construct()
    {
        echo "load language class\n";
    }
}[/code]
上面是 language 的初始化，直接下指令 php index.php 就會看到 <strong>

<span style="color:green">load language class</span></strong> 畫面。接著必須規畫兩個 method，分別是載入 language 檔案，以及讀取資料，程式碼變成：

<?php

class Language {
    /**
     * List of translations
     *
     * @var array
     */
    var $language   = array();
    /**
     * List of loaded language files
     *
     * @var array
     */
    var $is_loaded  = array();

    public function __construct()
    {
        echo "load language class\n";
    }
    public function load($langfile = '', $idiom = 'english')
    {
        // 載入 language 檔案到 array()
    }

    public function line($line = '')
    {
        // 讀取 language list
    }
}[/code]

首先實作 load method，第一個參數帶入讀取的語系檔案，第二個參數帶入哪一種語系(例如: zh-tw 或 english)，實作流程非常簡單，先將語系檔案載入後，所有語系都存入 $this->language 陣列，並且將檔名複製到 $this->is_loaded 陣列，代表已載入，避免重複。接著看看程式碼：

public function load($langfile = '', $idiom = 'english')
{
    $langfile = str_replace('.php', '', $langfile);

    $langfile .= '.php';

    if (in_array($langfile, $this->is_loaded, TRUE))
    {
        return;
    }

    if ($idiom == '')
    {
        $idiom = ($deft_lang == '') ? 'english' : $deft_lang;
    }

    // Determine where the language file is and load it
    if (file_exists('language/'.$idiom.'/'.$langfile))
    {
        include('language/'.$idiom.'/'.$langfile);
    }

    if ( ! isset($lang))
    {
        return;
    }

    $this->is_loaded[] = $langfile;
    $this->language = array_merge($this->language, $lang);
    unset($lang);

    return TRUE;
}</pre> 最後實作讀取語系 

<pre class="brush: php; title: ; notranslate" title="">public function line($line = '')
{
    $value = ($line == '' OR ! isset($this->language[$line])) ? FALSE : $this->language[$line];

    return $value;
}</pre> $this->language 不存在此變數，則回傳布林函數 FALSE。最後來測試看看，先針對兩個語系 english 跟 zh-tw 目錄底下新增 about.php，內容如下 

<pre class="brush: php; title: ; notranslate" title=""><?php
$lang['index'] = "Home";
[/code]

測試 php index.php

[code lang="php"]<?php

include("Language.php");

$lang = new Language();

$lang->load("about", "english");

echo $lang->line("index") . "\n";</pre> 這樣就完成了基本的多國語系 class 實作，當然還有很多應用，等下次有再繼續寫 XD。程式碼也同時放在 

<a href="https://github.com/appleboy/php-i18n" target="_blank">php-i18n @ github</a> [>>>>> 繼續閱讀 PHP 多國語系製作 i18n library 筆記 (二) <<<<<][1]

 [1]: http://blog.wu-boy.com/2011/12/php-i18n-library-2/