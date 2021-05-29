---
title: How to install Gearman on Ubuntu or Debian with MySQL 安裝測試篇
author: appleboy
type: post
date: 2013-06-13T09:31:40+00:00
url: /2013/06/how-to-install-gearman-on-ubuntu-or-debian-with-mysql/
dsq_thread_id:
  - 1397716230
categories:
  - Debian
  - php
  - Ubuntu
tags:
  - Debian
  - Gearman
  - memcache
  - MySQL
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <img src="https://i2.wp.com/gearman.org/_media/:wiki:logo.png?w=840" alt="" data-recalc-dims="1" />
</div>

<a href="http://gearman.org/" target="_blank">Gearman</a> 可以在背景幫忙處理繁瑣的工作，例如壓縮影片、處理縮圖、發送認證信…等，這次不會提到太多 Gearman 介紹，如果想瞭解 Gearman 可以參考<a href="http://www.jaceju.net/" target="_blank">小鐵兄</a>寫的 <a href="http://www.jaceju.net/blog/archives/1211/" target="_blank">Gearman 心得</a>，此篇會筆記如何在 Ubuntu or Debian 安裝 Gearman 搭配 MySQL 服務，當然如果你不是使用 MySQL，也可以另外搭配 <a href="http://memcached.org/" target="_blank">Memcached</a> 或 <a href="http://www.sqlite.org/" target="_blank">SQLite</a> 都可以 <!--more-->

### Ubuntu or Debian 安裝 其實安裝方式很簡單，只需要透過 apt-get 指令就可以安裝完成 

<pre class="brush: bash; title: ; notranslate" title="">$ aptitude -y install gearman gearman-job-server libgearman-dev libdrizzle0</pre> 安裝完成後，在命令列打入 

**<span style="color:green">gearmand -V</span>** 檢查版本，會發現預設的版本非常的舊，但是沒關係，Ubuntu 可以透過 Package Repository 來安裝到最新版 

<pre class="brush: bash; title: ; notranslate" title="">$ add-apt-repository ppa:gearman-developers/ppa
$ aptitude -y update</pre> 但是在 Debian 7.0 版似乎起不了任何作用，裝起來版本真的很低，爽度不夠，所以最終解法還是要透過 tar 方式安裝，安裝過程一定會遇到一些沒安裝的 develop library，只要把相對應的套件安裝即可 

<pre class="brush: bash; title: ; notranslate" title="">$ aptitude -y install libboost-program-options-dev gperf libcloog-ppl0 libpq-dev libmemcached-dev libevent-dev
$ wget https://launchpad.net/libdrizzle/5.1/5.1.4/+download/libdrizzle-5.1.4.tar.gz -O /tmp/libdrizzle-5.1.4.tar.gz
$ wget https://launchpad.net/gearmand/1.2/1.1.8/+download/gearmand-1.1.8.tar.gz -O /tmp/gearmand-1.1.8.tar.gz
$ cd /tmp && tar xvfz libdrizzle-5.1.4.tar.gz && cd libdrizzle-5.1.4 && ./configure --prefix=/usr && make && make install
$ cd /tmp && tar xvfz gearmand-1.1.8.tar.gz && cd gearmand-1.1.8 && ./configure --prefix=/usr && make && make install</pre> 安裝完成後，直接打 

**<span style="color:green">gearmand -h</span>** 

<pre class="brush: bash; title: ; notranslate" title="">builtin:

libmemcached:
  --libmemcached-servers arg List of Memcached servers to use.

Postgres:
  --libpq-conninfo arg       PostgreSQL connection information string.
  --libpq-table arg (=queue) Table to use.

MySQL:
  --mysql-host arg (=localhost)      MySQL host.
  --mysql-port arg (=3306)           Port of server. (by default 3306)
  --mysql-user arg                   MySQL user.
  --mysql-password arg               MySQL user password.
  --mysql-db arg                     MySQL database.
  --mysql-table arg (=gearman_queue) MySQL table name.</pre> 如果搭配 Mariadb 的話，請安裝 

**<span style="color:red">libmariadbclient-dev</span>** 才可以將 MySQL 功能編譯進去。從上面結果發現 Gearman 目前支援 <a href="http://libmemcached.org/libMemcached.html" target="_blank">libmemcached</a>, <a href="http://www.postgresql.org/" target="_blank">Postgres</a>, MySQL 串接方式，底下來一一介紹 

### 搭配 memcached Gearman 0.7 版本以上才支援，設定方式很簡單，開啟 /etc/default/gearman-job-server 找到底下字串 

<pre class="brush: bash; title: ; notranslate" title="">PARAMS="--listen=127.0.0.1"</pre> 改成 

<pre class="brush: bash; title: ; notranslate" title="">PARAMS="-q libmemcached --libmemcached-servers=localhost"</pre> 當然要先檢查系統有無啟動 memcached port 11211。重新啟動 gearmand 

<pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/gearman-job-server restart</pre>

### 搭配 MySQL 設定前，請先將 Database 建立完成 

<pre class="brush: bash; title: ; notranslate" title="">$ mysql -u root -p -e 'CREATE DATABASE gearman;'</pre> 最後設定 /etc/default/gearman-job-server 

<pre class="brush: bash; title: ; notranslate" title="">PARAMS="-q mysql --mysql-host=localhost --mysql-user=xxxx --mysql-password=xxxxx--mysql-db=gearman --mysql-table=gearman_queue"</pre> 重新啟動後，Gearman 會在資料庫建立 gearman_queue 資料表 

<pre class="brush: sql; title: ; notranslate" title="">CREATE TABLE IF NOT EXISTS `gearman_queue` (
  `unique_key` varchar(64) DEFAULT NULL,
  `function_name` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `data` longblob,
  `when_to_run` int(11) DEFAULT NULL,
  UNIQUE KEY `unique_key` (`unique_key`,`function_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;</pre> 嗯嗯，非常好，但是你會發現一個問題，都已經在搞 InnoDB 竟然沒有 primary key，所以這就請系統管理者幫忙建立上去。 

### 測試資料 首先 Gearman 支援任何程式語言 (Shell, Perl, Node.js, PHP, Python, Java ..等)，先來介紹使用 PHP command line，請安裝 PHP Gearman API Extension 

<pre class="brush: bash; title: ; notranslate" title="">$ pecl install channel://pecl.php.net/gearman-1.1.0</pre> 建立 

**<span style="color:green">/etc/php5/cli/conf.d/gearman.ini</span>**，內容為 

<pre class="brush: bash; title: ; notranslate" title="">[gearman]
extension=gearman.so</pre> 重新啟動 php5 fpm 

<pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/php5-fpm restart</pre> 用指令檢查 

<pre class="brush: bash; title: ; notranslate" title="">$ php -i | grep gearman
/etc/php5/cli/conf.d/gearman.ini,
gearman
gearman support => enabled
libgearman version => 1.1.8</pre> 撰寫 worker.php (copy from 

<a href="http://www.jaceju.net/blog/archives/1211/" target="_blank">小鐵部落格</a>) 

<pre class="brush: php; title: ; notranslate" title=""><?php
$worker = new GearmanWorker();
$worker->addServer(); // 預設為 localhost
$worker->addFunction('sendEmail', 'doSendEmail');
$worker->addFunction('resizeImage', 'doResizeImage');
while($worker->work()) {
    sleep(1); // 無限迴圈，並讓 CPU 休息一下
}
function doSendEmail($job)
{
    $data = unserialize($job->workload());
    print_r($data);
    sleep(3); // 模擬處理時間
    echo "Email sending is done really.\n\n";
}
function doResizeImage($job)
{
    $data = unserialize($job->workload());
    print_r($data);
    sleep(3); // 模擬處理時間
    echo "Image resizing is really done.\n\n";
}</pre> Client.php 

<pre class="brush: php; title: ; notranslate" title=""><?php
$client = new GearmanClient();
$client->addServer(); // 預設為 localhost
$emailData = array(
    'name'  => 'web',
    'email' => 'member@example.com',
);
$imageData = array(
    'image' => '/var/www/pub/image/test.png',
);
$client->doBackground('sendEmail', serialize($emailData));
echo "Email sending is done.\n";
$client->doBackground('resizeImage', serialize($imageData));
echo "Image resizing is done.\n";</pre> 到這裡直接先執行 Client 程式，如果安裝的 Gearman 吐出底下訊息: 

> PHP Warning: GearmanClient::doBackground(): \_client\_run\_tasks(GEARMAN\_SERVER\_ERROR) QUEUE\_ERROR:QUEUE_ERROR -> libgearman/client.cc:1581 in /root/client.php on line 11 表示 Server 沒有產生 unique key，所以造成第二次新增 job 的時候產生衝突，解決方式很解單，在 <a href="http://php.net/manual/en/gearmanclient.dobackground.php" target="_blank">doBackground</a>，第三個參數加上 unique key 

<pre class="brush: bash; title: ; notranslate" title="">$client->doBackground('sendEmail', serialize($emailData), md5(uniqid(rand(), true)));</pre> 這樣就可以完整測試了。