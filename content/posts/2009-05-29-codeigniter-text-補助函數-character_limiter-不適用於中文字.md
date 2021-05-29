---
title: '[CodeIgniter] Text 補助函數 character_limiter 不適用於中文字'
author: appleboy
type: post
date: 2009-05-29T07:43:11+00:00
url: /2009/05/codeigniter-text-補助函數-character_limiter-不適用於中文字/
views:
  - 8489
bot_views:
  - 487
dsq_thread_id:
  - 251249462
categories:
  - CodeIgniter
  - php
tags:
  - CodeIgniter
  - php

---
在 [CodeIgniter][1] 裡面的 [Text 補助函數][2]，目前只適用於英文字體，不支援 utf-8 或者是簡體字體，bite 數超過2的都會出問題，當然是因為這是國外的 mvc 所以也沒有考慮到這麼週到就是了，也不是沒有辦法解決，之前就用了PHP官方網站所提供的一個函式來正確切割中文字串，就是要利用 [ord][3] 判斷 ASCII 編碼範圍，或者是可以使用 [mb_substr][4] 函式正確切割，之前寫一篇可以參考看看：[[PHP] 如何切割中文標題][5]。 底下是原本 CodeIgniter 所提供的 Text 函數 

<pre class="brush: php; title: ; notranslate" title="">if ( ! function_exists('character_limiter'))
{
	function character_limiter($str, $n = 500, $end_char = '&#8230;')
	{
		if (strlen($str) < $n)
		{
			return $str;
		}
		
		$str = preg_replace("/\s+/", ' ', str_replace(array("\r\n", "\r", "\n"), ' ', $str));
    
		if (strlen($str) <= $n)
		{
			return $str;
		}
    
		$out = "";
		foreach (explode(' ', trim($str)) as $val)
		{
			$out .= $val.' ';
			
			if (strlen($out) >= $n)
			{
				$out = trim($out);
				return (strlen($out) == strlen($str)) ? $out : $out.$end_char;
			}		
		}
	}
}</pre>

<!--more--> character\_limiter 不能用在中文切割字串，只能用於英文切割，所以自己就要加上切割的函數才可以正確使用喔，利用簡單的 mb\_substr 就可以做到了，這算是 CodeIgniter 的 bug 嗎？好像也不是，不過自己有找到函數來使用，那就沒差了，自己可以定義函數在 libraries/ 底下： 

<pre class="brush: php; title: ; notranslate" title=""><?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class System
{ 

  function bite_str($string, $start, $len, $byte=3)
  {
    $str     = "";
    $count   = 0;
    $str_len = strlen($string);
    for ($i=0; $i<$str_len; $i++) {
      if (($count+1-$start)>$len) {
          $str  .= "...";
          break;
      } elseif ((ord(substr($string,$i,1)) <= 128) && ($count < $start)) {
          $count++;
      } elseif ((ord(substr($string,$i,1)) > 128) && ($count < $start)) {
          $count = $count+2;
          $i     = $i+$byte-1;
      } elseif ((ord(substr($string,$i,1)) <= 128) && ($count >= $start)) {
          $str  .= substr($string,$i,1);
          $count++;
      } elseif ((ord(substr($string,$i,1)) > 128) && ($count >= $start)) {
          $str  .= substr($string,$i,$byte);
          $count = $count+2;
          $i     = $i+$byte-1;
      }
    }
    return $str;
  }
}
?></pre>

> utf-8:$byte=3 | gb2312:$byte=2 | big5:$byte=2 現在都是用 utf-8，所以先把預設值 $byte 設定為 3，就可以正常使用了，使用方法是 $this->system->bite_str($string, $start, $len) 寫這樣就可以成功切割中文字串了。

 [1]: http://www.codeigniter.com.tw/
 [2]: http://www.codeigniter.com.tw/user_guide/helpers/text_helper.html
 [3]: http://tw.php.net/ord
 [4]: http://tw.php.net/mb_substr
 [5]: http://blog.wu-boy.com/2007/05/18/104/