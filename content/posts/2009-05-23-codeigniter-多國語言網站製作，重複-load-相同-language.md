---
title: '[CodeIgniter] 多國語言網站製作，重複 load 相同 language?'
author: appleboy
type: post
date: 2009-05-23T13:43:32+00:00
url: /2009/05/codeigniter-多國語言網站製作，重複-load-相同-language/
views:
  - 10674
bot_views:
  - 528
dsq_thread_id:
  - 246703922
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
目前正在研究網站的多國語系寫法，研究了 [CodeIgniter][1] 的 Language class 用法，可以看線上中文文件：[Language 類別][2]，目前遇到一個疑問，在單一 PHP 檔案讀取，不可以同時讀取相同的 Language file 檔案，這樣是完全沒有作用的，以底下的例子來說，我在 <span style="color: #008000;">application/language</span> 目錄底下放了三個語系資料夾，English、zh-TW、zh-CN 這三個資料夾，裡面分別放路 <span style="color: #ff0000;">vbs_lang.php</span> 檔案，為了要區別各國的語系檔案，要分別開資料夾放入，在 CI 文件裡面都寫的很清楚，架構如下 

  * application/language/English
  * application/language/zh-TW
  * application/language/zh-CN

<!--more--> 在每個 

<a href="http://www.codeigniter.com.tw/user_guide/general/controllers.html" target="_blank">Controller</a> 開始讀取資料，可以利用 <a href="http://www.codeigniter.com.tw/user_guide/general/controllers.html#constructors" target="_blank">建構子(Constructor) 方式</a> 將語系檔案載入，就在這時候，問題如下，我希望可以讀取相同 <span style="color: #ff0000;">vbs_lang.php</span> 檔案，但是不同語系目錄，本來以為這樣會把原先載入的檔案蓋掉，可是結果並非是您想要的，例如底下： 

<pre class="brush: php; title: ; notranslate" title="">#
# 原來先載入繁體中文語系
$this->lang->load('vbs', 'zh-TW');
#
# 後來跑簡體中文語系
$this->lang->load('vbs', 'zh-CN');</pre> 當你同時跑這兩個的同時，後面的語系是不會被載入的，這是為甚麼呢？可以從 CodeIgniter 的 Core 裡面找到 libraries/Language.php 檔案，裡面的程式碼寫的很清楚： 

<pre class="brush: php; title: ; notranslate" title=""><?php
function load($langfile = '', $idiom = '', $return = FALSE)
{
  $langfile = str_replace(EXT, '', str_replace('_lang.', '', $langfile)).'_lang'.EXT;
	if (in_array($langfile, $this->is_loaded, TRUE))
	{
		return;
	}

	if ($idiom == '')
	{
		$CI =& get_instance();
		$deft_lang = $CI->config->item('language');
		$idiom = ($deft_lang == '') ? 'english' : $deft_lang;
	}

	// Determine where the language file is and load it
	if (file_exists(APPPATH.'language/'.$idiom.'/'.$langfile))
	{
		include(APPPATH.'language/'.$idiom.'/'.$langfile);
	}
	else
	{
		if (file_exists(BASEPATH.'language/'.$idiom.'/'.$langfile))
		{
			include(BASEPATH.'language/'.$idiom.'/'.$langfile);
		}
		else
		{
			show_error('Unable to load the requested language file: language/'.$langfile);
		}
	}

	if ( ! isset($lang))
	{
		log_message('error', 'Language file contains no data: language/'.$idiom.'/'.$langfile);
		return;
	}

	if ($return == TRUE)
	{
		return $lang;
	}

	$this->is_loaded[] = $langfile;
	$this->language = array_merge($this->language, $lang);
  unset($lang);

	log_message('debug', 'Language file loaded: language/'.$idiom.'/'.$langfile);
	return TRUE;
}
?></pre> CI 會先比對您要載入的語系資料，那就是 $langfile 這個變數資料，當在 $this->is_loaded 這陣列裡面存在了 vbs 這個語系，系統就會 return 空值給您，並不會接下去跑程式，這麼做是為了避免重複的變數名稱 merge 到 array 裡面，當然這也可以解，解法就是比對陣列裡面的 key，如果找到相同的就把陣列 key 值 unset 刪除，不過這樣降低系統效能，結論是單一語系檔案就載入一次就好，有一點要注意，請不要在 

<span style="color: #008000;">application/config/autoload.php</span> 裡面把 language 載入進來，因為這樣系統就預設載入了您要的國家語系，當您要改變的時候，就沒辦法了載入相同語系，這算是 bug 吧。^^

 [1]: http://www.codeigniter.com.tw
 [2]: http://www.codeigniter.com.tw/user_guide/libraries/language.html