---
title: '[phpBB3] BBCode [url] Tag 支援中文網址'
author: appleboy
type: post
date: 2010-06-30T12:05:07+00:00
url: /2010/06/phpbb3-bbcode-url-tag-轉換中文網址驗證/
views:
  - 2241
bot_views:
  - 242
dsq_thread_id:
  - 248971606
categories:
  - php
tags:
  - php
  - phpBB3

---
在 phpBB2 的時候就有發現這問題了，當時並沒有想去解決這問題，然而至今到了 [phpBB3][1]，依然出現這問題，不過我想這是因為中文網址的盛行，以及像 [Wiki][2] 之類都會有中文標籤，例如：[一分鐘教室-userChrome.css][3]，解決方法可以透過 [urlencode][4] 函式來處理掉網址編碼問題，在 phpBB 處理文章儲存，會先經過 bbcode 的處理，將 **** 標籤，會經過 <span style="color:green">get_preg_expression</span>('url') 這函式的驗證，看 url 是否合法，當然如果網址列有中文就不可能通過，所以必須在網址驗證之前，把網址編碼過，通過驗證之後再把網址解碼，這樣就沒問題了，底下為安裝步驟 打開 <span style="color:green"><strong>includes/message_parser.php</strong></span> 找尋 

<pre class="brush: php; title: ; notranslate" title="">function validate_url($var1, $var2)</pre> 前面加入 

<pre class="brush: php; title: ; notranslate" title="">/**
*  url encode
*
* @param string $string http url
*/

function encode_url($string)
{
    $entities = array('%21', '%2A', '%27', '%28', '%29', '%3B', '%3A', '%40', '%26', '%3D', '%2B', '%24', '%2C', '%2F', '%3F', '%25', '%23', '%5B', '%5D');
    $replacements = array('!', '*', "'", "(", ")", ";", ":", "@", "&", "=", "+", "$", ",", "/", "?", "%", "#", "[", "]");
    return str_replace($entities, $replacements, urlencode($string));
}</pre> 找尋 

<span style="color:green"><strong>validate_url</strong></span> 函式 

<pre class="brush: php; title: ; notranslate" title="">$url = ($var1) ? $var1 : $var2;</pre> 後面加入 

<pre class="brush: php; title: ; notranslate" title="">// encode url 
$url = $this->encode_url($url);</pre> 找尋 

<pre class="brush: php; title: ; notranslate" title="">return ($var1) ? '<a href="'.$this->bbcode_specialchars($url).':'.$this->bbcode_uid.'">='.$this->bbcode_specialchars($url).':'.$this->bbcode_uid.'</a>' . $var2 . '[/url:' . $this->bbcode_uid . ']' : '<a href=":'.$this->bbcode_uid.'">:'.$this->bbcode_uid.'</a>' . $this->bbcode_specialchars($url) . '[/url:' . $this->bbcode_uid . ']';</pre> 取代 

<pre class="brush: php; title: ; notranslate" title="">return ($var1) ? '<a href="'.$this->bbcode_specialchars($url).':'.$this->bbcode_uid.'">='.$this->bbcode_specialchars($url).':'.$this->bbcode_uid.'</a>' . $var2 . '[/url:' . $this->bbcode_uid . ']' : '<a href=":'.$this->bbcode_uid.'">:'.$this->bbcode_uid.'</a>' . urldecode($this->bbcode_specialchars($url)) . '[/url:' . $this->bbcode_uid . ']';</pre> 測試結果，請參考此網址：

[Re: 討論區判斷含中文鏈結的 bug][5]

 [1]: http://www.phpbb.com/
 [2]: http://en.wikipedia.org/wiki/Wiki
 [3]: http://wiki.moztw.org/Firefox_一分鐘教室-userChrome.css
 [4]: http://php.net/manual/en/function.urlencode.php
 [5]: http://goo.gl/y4Rz