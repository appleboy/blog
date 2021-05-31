---
title: 'PHP 5.5.0 Release note: support  Zend OPcache'
author: appleboy
type: post
date: 2013-06-25T06:53:45+00:00
url: /2013/06/php-5-5-0-release-zend-opcache/
dsq_thread_id:
  - 1432828880
categories:
  - php
tags:
  - APC
  - OPcache
  - php
  - PHP 5.5

---
  <a title="php-logo by appleboy46, on Flickr" href="https://www.flickr.com/photos/appleboy/6034284842/"><img alt="php-logo" src="https://i2.wp.com/farm7.static.flickr.com/6186/6034284842_351ff33711_m.jpg?resize=240%2C127&#038;ssl=1" data-recalc-dims="1" /></a>

<a href="http://www.php.net/" target="_blank">PHP</a> 5.5.0 在上週 20 號正式 Release，也看到 PHP 官網終於改版了，新的版面看起來比較清爽，想嘗試新版面的朋友們，可以點選官網最上面鎖提示的 Bar，如果覺得新版面不是很好看，也可以切回去舊版。本篇來介紹 PHP 5.5.0 有哪些新 Feature。 

## 新增 generators and coroutines 功能

<a href="http://php.net/generators" target="_blank">Generators</a> 提供了最簡單的寫法來實做 iterators，而不需要實做 Class 去實做 Iterator 介面，generators function 就跟一般的 PHP function 一樣，只是多了 yield 這 keyword，簡單舉個例子 

```php
<?php
function gen_one_to_three() {
    for ($i = 1; $i <= 3; $i++) {
        // Note that $i is preserved between yields.
        yield $i;
    }
}

$generator = gen_one_to_three();
foreach ($generator as $value) {
    echo "$value\n";
}
?>
```


<!--more--> 雖然有了 generators，但是我們可以來比較看看 generators 和 Iterator objects 的差異，官網例子來解釋開啟檔案的程式碼 

```php
<?php
function getLinesFromFile($fileName) {
    if (!$fileHandle = fopen($fileName, 'r')) {
        return;
    }
 
    while (false !== $line = fgets($fileHandle)) {
        yield $line;
    }
 
    fclose($fileHandle);
}

// versus...

class LineIterator implements Iterator {
    protected $fileHandle;
 
    protected $line;
    protected $i;
 
    public function __construct($fileName) {
        if (!$this->fileHandle = fopen($fileName, 'r')) {
            throw new RuntimeException('Couldn\'t open file "' . $fileName . '"');
        }
    }
 
    public function rewind() {
        fseek($this->fileHandle, 0);
        $this->line = fgets($this->fileHandle);
        $this->i = 0;
    }
 
    public function valid() {
        return false !== $this->line;
    }
 
    public function current() {
        return $this->line;
    }
 
    public function key() {
        return $this->i;
    }
 
    public function next() {
        if (false !== $this->line) {
            $this->line = fgets($this->fileHandle);
            $this->i++;
        }
    }
 
    public function __destruct() {
        fclose($this->fileHandle);
    }
}
?>

```
 兩者差異其實很清楚，如果是用 generators，是無法回覆上一步驟，但是如果是用 Class 寫法，就可以重複使用，只需要宣告一次即可，但是 generators 就必需要一直呼叫 function 來使用。 

## 新增 finally keyword 

直接來看官網的例子比較清楚 

```php
<?php
function inverse($x) {
    if (!$x) {
        throw new Exception('Division by zero.');
    }
    return 1/$x;
}

try {
    echo inverse(5) . "\n";
} catch (Exception $e) {
    echo 'Caught exception: ',  $e->getMessage(), "\n";
} finally {
    echo "First finally.\n";
}

try {
    echo inverse(0) . "\n";
} catch (Exception $e) {
    echo 'Caught exception: ',  $e->getMessage(), "\n";
} finally {
    echo "Second finally.\n";
}

// Continue execution
echo "Hello World\n";
?>
```
 上面執行後會輸出 

```bash
0.2
First finally.
Caught exception: Division by zero.
Second finally.
Hello World
```


<a href="http://php.net/exceptions" target="_blank">finally</a> try cache 執行完畢後一定會執行到 finally block，另外在留言部份有個例子也很棒 

```php
<?php
try{
        try {
                throw new \Exception("Hello");
        } catch(\Exception $e) {
                echo $e->getMessage()." catch in\n";
                throw $e;
        } finally {
                echo $e->getMessage()." finally \n";
                throw new \Exception("Bye");
        }
} catch (\Exception $e) {
        echo $e->getMessage()." catch out\n";
}
?>
```
 執行結果為 

```bash
Hello catch in
Hello finally
Bye catch out
```


## 新增 Password Hashing API 

password hashing API 提供了 

<a href="http://tw2.php.net/manual/en/function.crypt.php" target="_blank">crypt()</a> 演算法加密，所以現在不用自己寫 Password hash 了，直接使用 PHP 內建吧 

```php
<?php
echo password_hash("rasmuslerdorf", PASSWORD_DEFAULT)."\n";[/code]

輸出為

[code lang="bash"]$2y$10$.vGA1O9wmRjrwAVXD98HNOgsNpDczlqm3Jq7KnEd1rVAGv3Fykk1a[/code]

如果使用 CRYPT 演算法

[code lang="php"]<?php
/**
 * In this case, we want to increase the default cost for BCRYPT to 12.
 * Note that we also switched to BCRYPT, which will always be 60 characters.
 */
$options = [
    'cost' => 12,
];
echo password_hash("rasmuslerdorf", PASSWORD_BCRYPT, $options)."\n";
?>
```
 輸出為 

```bash
$2y$12$QjSH496pcT5CEbzjD/vtVeH03tfHKFy36d4J0Ltp3lRtee9HDxY3K
```
 那該如何驗證使用者登入密碼正確呢？可以透過 

<a href="http://tw1.php.net/manual/en/function.password-verify.php" target="_blank">password_verify</a> function 

```php
<?php
// See the password_hash() example to see where this came from.
$hash = '$2y$07$BCryptRequires22Chrcte/VlQH0piJtjXl.0t1XkA8pw9dMXTpOq';

if (password_verify('rasmuslerdorf', $hash)) {
    echo 'Password is valid!';
} else {
    echo 'Invalid password.';
}
?>
```


###empty() supports arbitrary expressions

<a href="http://tw1.php.net/manual/en/function.empty.php" target="_blank">empty()</a> 開始支援 function return value，不只是判斷變數而已。 

```php
<?php
function always_false() {
    return false;
}

if (empty(always_false())) {
    echo "This will be printed.\n";
}

if (empty(true)) {
    echo "This will not be printed.\n";
}
?>
```
 如果在 5.5 版本以前就會噴 

> PHP Fatal error: Can't use function return value in write context

###支援 ::class keyword 

5.5 開始支援 Class name resolution 

```php
<?php
namespace NS {
    class ClassName {
    }
    
    echo ClassName::class;
}
?>
```
 上述輸出為 

```bash
NS\ClassName
```


## foreach 支援階乘式陣列

```php
<?php
$array = [
    [1, 2],
    [3, 4],
];

foreach ($array as list($a, $b)) {
    // $a contains the first element of the nested array,
    // and $b contains the second element.
    echo "A: $a; B: $b\n";
}
?>
```
 輸出為 

```bash
A: 1; B: 2
A: 3; B: 4
```
 真的是太強大了。 

## 內建 Zend OPcache 

本篇重點就是 5.5 開始內建 

<a href="http://tw1.php.net/opcache" target="_blank">Zend OPcache</a>，在之前要 tune php performance，無非就是加上 <a href="http://php.net/manual/en/book.apc.php" target="_blank">APC</a>，為了改善 cache 效能，Zend 官方又寫了一套 <a href="https://github.com/zendtech/ZendOptimizerPlus" target="_blank">ZendOptimizerPlus</a>，將 PHP 編譯程 bytecode 存放在 shared memory，此方式避免到硬碟讀取 PHP 程式碼，並且編譯再執行。 目前支援 PHP 5.2.\*, 5.3.\*, 5.4.\* and PHP-5.5，但是也許 PHP 5.2.\* 將來會拔掉，但是這還沒確定。如果您的系統是 php5.5 以前的版本，可以透過 pecl 方式來安裝 

```bash
# support Zend OPcache on PHP 5.2, 5.3 and 5.4
pecl install channel://pecl.php.net/ZendOpcache-7.0.2

```
 完成後新增設定檔 

**<span style="color:green">/etc/php5/cli/conf.d/10-opcache.ini</span>** 

```bash
zend_extension=opcache.so

[opcache]
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1
```
 需要注意的是 

**<span style="color:green">opcache.revalidate_freq</span>** 設定，預設是2秒，也就是兩秒內 opcache 不會去偵測程式碼是否有修改，如果正在開發狀態，並且搭配 <a href="http://livereload.com/" target="_blank">Livereload</a> 的話，使用 opcache 請把 revalidate_freq 設定為 0，讓每次 reload 都重新偵測程式碼是否改變。另外提供官方給的效能數據，可以參考 <a href="https://docs.google.com/spreadsheet/ccc?key=0Agw0hgqCxf0cdEZsdm1yNjd3amJReG05MzJYSF9USGc#gid=0" target="_blank">Opcode Cache Benchmarks</a>
