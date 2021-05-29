---
title: '[Pear] 利用 Validate 套件驗證 E-mail 多重表單認證'
author: appleboy
type: post
date: 2009-03-15T08:07:14+00:00
url: /2009/03/pear-利用-validate-套件驗證-e-mail-多重表單認證/
views:
  - 5087
bot_views:
  - 368
dsq_thread_id:
  - 247044732
categories:
  - FreeBSD
  - jQuery
  - Linux
  - php
tags:
  - jQuery
  - PEAR

---
最近都在玩 [open source][1] 的程式，方便加速自己開發 PHP 的專案，在申請帳號密碼部份就可以利用 [Validate][2] 套件來驗證，以及 email 填寫正確性，可以檢查 MX 或者是 A record 紀錄，還蠻方便的，也可以檢查 [multiple][3] 欄位，設計的相當不錯，也有金融相關套件可以驗證 [CreditCard][4]，金融套件名稱是 [Validate_Finance][5] 裡面的 [Validate\_Finance\_CreditCard][6] 部份，線上也有很多相關說明，可以參考 [Validate 線上手冊][7]，目前已經到 0.8.2 (beta)，如果使用 Release 版本，請選用 0.8.1，軟體可以在此[下載][8]，0.8.2 是在 2009-01-31 Release 出來的，還不錯用，最主要的功能如下 

> Package to validate various datas. It includes : - numbers (min/max, decimal or not) - email (syntax, domain check, [rfc822][9]) - string (predifined type alpha upper and/or lowercase, numeric,...) - date (min, max, rfc822 compliant) - uri ([RFC2396][10]) - possibility valid multiple data with a single method call (::multiple)
  1. 驗證各種不同的日期函式
  2. 驗證數字(最小/最大,是否是10進位)
  3. email 驗證(正規語法驗證，check domain name 是否存在，[rfc822][9] 驗證)
  4. 字串驗證(正規語法驗證，是否包含數字英文字母，可輸入最長或最短)
  5. url 驗證(遵從 [RFC2396][10] 規定)
  6. 多重欄位(multiple data)驗證(可以同時驗證上述功能)

<!--more--> 來介紹 

[Validate][2] 套件用法： 1. [Validate::date][11] 這部份我比較不推薦用這裡的方法，可以用 jQuery 的套件：[[jQuery筆記] 好用的日期函式 datepicker][12]，那底下是這個函式用法：必須多安裝 [Pear Date][13] 套件 

<pre class="brush: php; title: ; notranslate" title="">/**
* 驗證此套件必須在加裝 Date_Calc class
*
* @param string $date  需要驗證的值
*                          'format' 可以自行制定 (%d-%m-%Y)
*
*                          'min'    array($day, $month, $year)
*                          'max'   array($day, $month, $year)
* 回傳值 true or false
*/
$values = "2009-01-10";

$opts = array(
  'format'=> "%Y-%d-%m",
  'min'  => array('02','10','2009'),
  'max'  => array('05','10','2009')
);
$result = Validate::date($values, $opts);

if($result)
{
echo $result;
}
else
{
echo "error";
}</pre> 2. 

[Validate::email][14] 

<pre class="brush: php; title: ; notranslate" title="">/**
 * 
 * @param string $email  您要驗證的 email
 * @param mixed
 *    check_domain 檢查 domain 是否有 A 或者 MX Record
 *    use_rfc822 檢查 domain 是否符合 rfc822 規範 
 * 回傳值 true or false
 *  
 */
$values = "appleboy@XXXXX";

$options = array(
  'check_domain' => 'true',
  'fullTLDValidation' => 'true',
  'use_rfc822' => 'true',
  'VALIDATE_GTLD_EMAILS' => 'false',
  'VALIDATE_CCTLD_EMAILS' => 'false',
  'VALIDATE_ITLD_EMAILS' => 'false',
);
$result = Validate::email($values, $options);

if($result)
{
echo $result;
}
else
{
echo "error
";
}</pre> 3. 

[Validate::number][15]： 

<pre class="brush: php; title: ; notranslate" title="">/**
 * 
 * @param string $number  您要驗證的數字
 * param array  $options array 選單
 *    decimal 可否在數字中間出現非數字符號如：., 代表可以使用 .,
 *    dec_prec 有多少 decimal 可以出現在數字中
 *    min      最小值
 *    max      最大值 
 * 回傳值 true or false
 *  
 */

$values = "12300,45";

$options = array(
    'decimal' => ',',
    'dec_prec' => '2',
    'min' => '1000',         
    );
$result = Validate::number($values, $options);

if($result)
{
  echo $result;
}
else
{
  echo "error<br />";
}</pre> 4. 

[Validate::String][16] 

<pre class="brush: php; title: ; notranslate" title="">/**
 * 
 * @param string $string  您要驗證的字串
 * param array  $options array 選單
 *    'format' 字串的格式
 *    Ex:VALIDATE_NUM(數字 0-9) . VALIDATE_ALPHA_LOWER(a-z) 
 *    VALIDATE_ALPHA_UPPER (A-Z) VALIDATE_ALPHA(a-zA-Z) 
 *    dec_prec 有多少 decimal 可以出現在數字中
 *    'min_length' 字串最小長度
 *    'max_length' 字串最大長度
 * 回傳值 true or false
 *  
 */
$values = "appleboy";

$options = array(
    'format' => VALIDATE_NUM,
    'min_length' => '2',
    'max_length' => '1000',         
    );
$result = Validate::number($values, $options);

if($result)
{
  echo $result;
}
else
{
  echo "error<br />";
}</pre> 5. 

[Validate::Uri][17] 

<pre class="brush: php; title: ; notranslate" title="">/**
 * Validate an URI (RFC2396)
 * EX: 
 * $options = array('allowed_schemes' => array('http', 'https', 'ftp'))
 * var_dump(Validate::uri('http://www.example.org', $options));  
 * 注意事項：
 * 1. 在 RFC2396 裡面定義了"-" 這個符號可以使用在 URI 裡面
 *    e.g. http://example.co-m 這是可以驗證通過的 
 *    但是在any known TLD裡面是不被准許的
 * 2.   
 * @param string $url     您要驗證的網址列
 * @param array  $options Options used by the validation method.
 *    'domain_check' 檢查 domain 是否存在 DNS 裡
 *    'allowed_schemes' 陣列 for list protocols ex: https, http
 *    'strict'  預設值： ';/?:@$,' 空值: accept all rfc2396 foreseen chars     
 * 回傳值 true or false
 *  
 */
$options = array(
    'check_domain'=>true,
    'allowed_schemes' => array('http','https'),
    'strict' => ';/?:@$,'       
    );
var_dump(Validate::uri('http://blog.wu-boy.com/', $options));</pre> 6. 

[Validate::multiple][3] 結合上述的語法，整合成一個函式 

<pre class="brush: php; title: ; notranslate" title="">$values = array(
    'amount'=> '13234,344343',
    'name'  => 'foo@example.com',
    'mail'  => 'foo@example.com',
    'mystring' => 'ABCDEabcde'

    );
$opts = array(
    'amount'=> array('type'=>'number','decimal'=>',.','dec_prec'=>null,'min'=>1,'max'=>32000),
    'name'  => array('type'=>'email','check_domain'=>false),
    'mail'  => array('type'=>'email'),
    'mystring' => array('type'=>'string',array('format'=>VALIDATE_ALPHA, 'min_length'=>3))
    );

$result = Validate::multiple($values, $opts);

print_r($result);</pre>

 [1]: http://en.wikipedia.org/wiki/Open_source
 [2]: http://pear.php.net/package/Validate
 [3]: http://pear.php.net/package/Validate/docs/0.8.2/Validate/Validate.html#methodmultiple
 [4]: http://en.wikipedia.org/wiki/Credit_card
 [5]: http://pear.php.net/package/Validate_Finance
 [6]: http://pear.php.net/package/Validate_Finance_CreditCard
 [7]: http://pear.php.net/package/Validate/docs/0.8.2/
 [8]: http://pear.php.net/package/Validate/download/
 [9]: http://www.w3.org/Protocols/rfc822/
 [10]: http://www.w3.org/2002/11/dbooth-names/rfc2396-numbered_clean.htm
 [11]: http://pear.php.net/package/Validate/docs/0.8.2/Validate/Validate.html#methoddate
 [12]: http://blog.wu-boy.com/2008/04/30/194/
 [13]: http://pear.php.net/package/Date
 [14]: http://pear.php.net/package/Validate/docs/0.8.2/Validate/Validate.html#methodemail
 [15]: http://pear.php.net/package/Validate/docs/0.8.2/Validate/Validate.html#methodnumber
 [16]: http://pear.php.net/package/Validate/docs/0.8.2/Validate/Validate.html#methodstring
 [17]: http://pear.php.net/package/Validate/docs/0.8.2/Validate/Validate.html#methoduri