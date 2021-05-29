---
title: '[Mysql] 資料庫備份[big5]utf8轉換成utf-8'
author: appleboy
type: post
date: 2007-04-08T13:14:29+00:00
url: /2007/04/mysql-資料庫備份big5utf8轉換成utf-8/
views:
  - 7398
bot_views:
  - 1625
dsq_thread_id:
  - 252006372
categories:
  - FreeBSD
  - Linux
  - MySQL
  - sql
  - wordpress
tags:
  - MySQL

---
其實在很多opensource底下的套裝軟體，資料庫預設都是用 utf8，我想這會造成在 phpMyAdmin 底下看到亂碼，然後自己之前也有遇到問題，然後又在網路上看到這篇 <a title="Permanent Link: 搶救 xdite.net 所用的奇技淫巧" rel="bookmark" href="http://blog.xdite.net/?p=307">搶救 xdite.net 所用的奇技淫巧</a> 裡面所寫的備份方式跟我在轉換 phpBB2 跟自己的 wordpress 一樣 大同小異，我還在想說有更好的解法說，看來是沒有，在 wordpress 底下，只能利用後台的資料庫備份，不然用phpMyAdmin的話，我想你備份出來也是沒用。 <!--more--> 其實解法很容易，在 

<a title="Permanent Link: 搶救 xdite.net 所用的奇技淫巧" rel="bookmark" href="http://blog.xdite.net/?p=307">搶救 xdite.net 所用的奇技淫巧</a> 裡面有提到一篇大陸的解法：[搞定亂碼，搬家到 Dreamhost][1] 其實內容大概就跟我第一段寫的差不多，如果有提供ssh的虛擬主機的話，還可以利用ssh mysqldump 的方式來備份 備份步驟如下 

>   1. 利用 wordpress 後台管理介面備份database，如果不利用後台的話，用phpmyadmin的話，會在成亂碼喔 不然就是ssh連線到主機上面，下指令 mysqldump -h mydomain -u root -p &#8211;default-character-set=utf8 database > database.sql
>   2. 在phpMyadmin中設定MySQL 字符集: UTF-8 Unicode (utf8)
>   3. phpMyadmin中設定MySQL 連線校對 選 utf8\_general\_ci
>   4. 修改剛剛備份好的 sql 檔案，用編輯器打開 <span style="color: red">查找&#8221;DEFAULT CHARSET=utf8&#8243; 用&#8221;DEFAULT CHARSET=utf8&#8243;替换</span>
>   5. 然後在重新利用phpmyadmin把檔案匯入到新建立的資料庫，或者是下指令 mysql -u root -p new_database < database.sql
>   6. 修改 wordpress 程式碼，修改wp-includes/wp-db.php內，找到 $this->dbh = @mysql_connect($dbhost,$dbuser,$dbpassword); //後面加入 $this->query(&#8220;SET NAMES &#8216;utf8&#8242;&#8221; ); 上面的方法適用於再任何套裝軟體，我在 phpBB2 的big5轉換成utf-8的時候，也是用這種方法，給大家參考看看

 [1]: http://zhiqiang.org/blog/359.html