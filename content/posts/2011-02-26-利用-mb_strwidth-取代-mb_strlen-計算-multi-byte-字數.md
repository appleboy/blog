---
title: 利用 mb_strwidth 取代 mb_strlen 計算 Multi-byte 字數
author: appleboy
type: post
date: 2011-02-26T14:18:28+00:00
url: /2011/02/利用-mb_strwidth-取代-mb_strlen-計算-multi-byte-字數/
views:
  - 347
bot_views:
  - 222
dsq_thread_id:
  - 246739347
categories:
  - php
tags:
  - php

---
之前寫了一篇[如何切割中文標題][1]，裡面計算中文字數，這樣才不會直接切到中文字，但是 [PHP][2] 有很多函式可以算出字串有多少字元，我們看看底下例子，使用了 [strlen][3]、[mb_strlen][4]、[mb_strwidth][5] 分別下去測試，看看會把中文字算成幾個字元: 

<pre class="brush: php; title: ; notranslate" title=""><?php
echo strlen("測試ABC") . "<br />";
# 輸出 9
echo mb_strlen("測試ABC", 'UTF-8') . "

<br />";
# 輸出 5
echo mb_strwidth("測試ABC") . "<br />";
#輸出 7
?>
</pre> 看到這結果並不意外，大家可以看到 strlen 把中文字元算成3個字元，mb\_strlen 不管是中文還是英文就都算成單一字元，mb\_strwidth 則是把中文算成 2 字元，mb_strwidth 算出來正是我想要的，如果是想要在 Web 上面切割中文，建議大家用 

[mb_substr][6] 即可。因為作者本人在弄跟 BBS 相關技術，所以必須江中文字算成2字元，底下節錄 mb_strwidth 如何算字元長度: 

<pre class="brush: bash; title: ; notranslate" title="">Chars	  => Width
U+0000 - U+0019	=> 0
U+0020 - U+1FFF	=> 1
U+2000 - U+FF60	=> 2
U+FF61 - U+FF9F	=> 1
U+FFA0 -	=> 2</pre> PS: 測試環境 PHP 5.2.6

 [1]: http://blog.wu-boy.com/2007/05/php-%E5%A6%82%E4%BD%95%E5%88%87%E5%89%B2%E4%B8%AD%E6%96%87%E6%A8%99%E9%A1%8C/
 [2]: http://tw2.php.net/
 [3]: http://tw2.php.net/manual/en/function.strlen.php
 [4]: http://tw2.php.net/manual/en/function.mb-strlen.php
 [5]: http://php.net/manual/en/function.mb-strwidth.php
 [6]: http://tw2.php.net/manual/en/function.mb-substr.php