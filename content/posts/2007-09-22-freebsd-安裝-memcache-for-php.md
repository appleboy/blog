---
title: '[FreeBSD] 安裝 memcache for php 多重伺服器共享 Session'
author: appleboy
type: post
date: 2007-09-22T13:16:04+00:00
url: /2007/09/freebsd-安裝-memcache-for-php/
views:
  - 12113
bot_views:
  - 1361
dsq_thread_id:
  - 246847197
categories:
  - apache
  - FreeBSD
  - Linux
  - php
  - www
tags:
  - FreeBSD
  - memcache
  - php

---
今天來玩看看 memcache 看看，話說 memcache 是個非常好用的東西，可以參考官網作法 [連結][1]，其實我在前一個工作，就有老闆問我說，像公司作這麼多網站，有沒有辦法統整成一個，然後底下各種服務，只需要登入過一次就好，而不必重複登入，畢竟會讓使用者覺得很煩，所以就有了 memcache 這東西出來，底下就來介紹 FreeBSD 的安裝方式 

  * 安裝方法： 安裝 ports 的套件 memcache 跟 pecl-memcache 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/databases/memcached; make install clean
cd /usr/ports/databases/pecl-memcache; make install clean
</pre> 然後他會把 extension=memcache.so 寫到 /usr/local/etc/php/extensions.ini 然後你只需要重新啟動 apache 即可，還有把 memcached 服務打開 所以請下底下指令 

<pre class="brush: bash; title: ; notranslate" title="">echo "memcached_enable=\"YES\"" >> /etc/rc.conf
/usr/local/etc/rc.d/memcached start
/usr/local/etc/rc.d/apache22 restart
</pre>

<!--more-->

  * 測試方法： 寫一個php檔案，然後在執行他，範例檔如下 

<pre class="brush: php; title: ; notranslate" title=""><?php
$memcache = new Memcache; //Star memcache
$memcache->connect('localhost', 11211) or die ("Could not connect"); //Connect Memcached
$memcache->set('uname', 'appleboy'); 
$get_value = $memcache->get('uname'); //
echo $get_value;
print "

<br />";
$b = $memcache->getStats();
print_r($b);exit;
?>
</pre> 如果你需要用 session 寫法，就如下了，這是別人寫好的範例 

<pre class="brush: php; title: ; notranslate" title=""><?php
$mem_cache_obj = new Memcache;
$mem_cache_obj->connect('localhost', 11211) or die ("Could not connect");
class Shared_Session
{
  function init()
  {
    ini_set("session.gc_maxlifetime", 3600);
    ini_set("session.use_cookies", 1);
    ini_set("session.cookie_path", "/");
    ini_set("session.cookie_domain", ".wu-boy.com");

    session_module_name("User");
    session_set_save_handler(
        array("Shared_Session", "open"),
        array("Shared_Session", "close"),
        array("Shared_Session", "read"),
        array("Shared_Session", "write"),
        array("Shared_Session", "destroy"),
        array("Shared_Session", "gc")
        );
  }

  function open($save_path, $session_name) {
    return true;
  }

  function close() {
    return true;
  }

  function read($sesskey) {
    global $mem_cache_obj;
    return $mem_cache_obj->get($sesskey);
  }

  function write($sesskey, $data) {
    global $mem_cache_obj;
    $mem_cache_obj->set($sesskey, $data, 3600);
    return true;
  }

  function destroy($sesskey) {
    global $mem_cache_obj;
    $mem_cache_obj->delete($sesskey);
    $mem_cache_obj->flush_all();

    return true;
  }

  function gc($maxlifetime = null) {
    return true;
  }
}

Shared_Session::init();

?> 
</pre> 這是利用 memory 存取資料，所以想必一定比妳用 database 或者是檔案存取更快了，但是如果一台機器已經用完記憶體了，所以我們必須新增另一台 memcache server了，所以新增方法如下 

<pre class="brush: php; title: ; notranslate" title=""><?php

/* OO API */

$memcache = new Memcache;
$memcache->addServer('memcache_host', 11211);
$memcache->addServer('memcache_host2', 11211);

/* procedural API */

$memcache_obj = memcache_connect('memcache_host', 11211);
memcache_add_server($memcache_obj, 'memcache_host2', 11211);

?>
</pre> 在網路上找到一篇，有人寫好的 memcache class 

[php-memcached-client][2] 官網：[點我][3] 範例： 

<pre class="brush: php; title: ; notranslate" title=""><?php
//  包含 memcached 类文件
require_once('memcached-client.php');
//  选项设置
$options = array(
    'servers' => array('192.168.1.1:11211'), //memcached 服务的地址、端口，可用多个数组元素表示多个 memcached 服务
    'debug' => true,  //是否打开 debug
    'compress_threshold' => 10240,  //超过多少字节的数据时进行压缩
    'persistant' => false  //是否使用持久连接
    );
//  创建 memcached 对象实例
$mc = new memcached($options);
//  设置此脚本使用的唯一标识符
$key = 'mykey';
//  往 memcached 中写入对象
$mc->add($key, 'some random strings');
$val = $mc->get($key);
echo "n".str_pad('$mc->add() ', 60, '_')."n

<br />";
var_dump($val)."<br />";
//  替换已写入的对象数据值
$mc->replace($key, array('some'=>'haha', 'array'=>'xxx'));
$val = $mc->get($key);
echo "n".str_pad('$mc->replace() ', 60, '_')."n<br />";
var_dump($val)."<br />";
//  删除 memcached 中的对象
$mc->delete($key);
$val = $mc->get($key);
echo "n".str_pad('$mc->delete() ', 60, '_')."n<br />";
var_dump($val)."<br />";
?>
</pre> 不過大家可以把 debug mode 關掉，不然畫面會比較亂一點。 再來大家可以跟資料庫連接，然後把SQL讀出來的資料寫到 memcache中 範例： 

<pre class="brush: php; title: ; notranslate" title=""><?php
$sql = 'SELECT * FROM users';
$key = md5($sql);   //memcached 对象标识符
if ( !($datas = $mc->get($key)) ) {
    //  在 memcached 中未获取到缓存数据，则使用数据库查询获取记录集。
    echo "n".str_pad('Read datas from MySQL.', 60, '_')."n";
    $conn = mysql_connect('localhost', 'test', 'test');
    mysql_select_db('test');
    $result = mysql_query($sql);
    while ($row = mysql_fetch_object($result))
        $datas[] = $row;
    //  将数据库中获取到的结果集数据保存到 memcached 中，以供下次访问时使用。
    $mc->add($key, $datas);
} else {
    echo "n".str_pad('Read datas from memcached.', 60, '_')."n";
}
var_dump($datas);
?>
</pre> reference 

[非mmcache！Memcached的應用：多網站伺服器 PHP 共享 Session][4] [PHP & memcached][5] <http://blog.johnpupu.tw/?p=62>

 [1]: http://tw.php.net/memcache
 [2]: http://blog.wu-boy.com/wp-content/uploads/2007/09/memcached-client.zip "php-memcached-client"
 [3]: http://wikipedia.sourceforge.net/doc/memcached-client/_includes_memcached-client_php.html
 [4]: http://blog.twpug.org/post/30/239
 [5]: http://nio.infor96.com/php-memcached/