---
title: 利用 PHP MySQL Quota-Tool 來限制 MySQL 存取空間大小
author: appleboy
type: post
date: 2009-10-09T04:17:37+00:00
url: /2009/10/利用-php-mysql-quota-tool-來限制-mysql-存取空間大小/
views:
  - 14640
bot_views:
  - 984
dsq_thread_id:
  - 249241265
categories:
  - MySQL
  - php
tags:
  - MySQL
  - php

---
在[酷！學園][1]發現[這篇][2]，有人問到如何限制 MySQL 的使用空間大小，我第一個想到的就是 [Linux quota][3] 指令限制大小，看回文有一篇利用 MySQL 來解決此問題：[MySQL Quota-Tool][4]，它利用了 MySQL INSERT 跟 CREATE 的權限控管，來達成限制，當資料庫大小超過您所設定的限制，系統就會拔除您的 INSERT 跟 CREATE 權限，如果沒有超過，就會將權限設定回去，基本上非常簡單，首先要先建立一個專屬控管每個資料庫的 database 

<pre class="brush: sql; title: ; notranslate" title="">CREATE TABLE `Quota` (`Db` CHAR(64) NOT NULL, 
`Limit` BIGINT NOT NULL,
`Exceeded` ENUM('Y','N') DEFAULT 'N' NOT NULL,
PRIMARY KEY (`Db`), UNIQUE (`Db`));</pre>

<!--more--> 底下是 PHP 程式，可以利用 crontab 方式來達到每小時偵測一次，自行可以設定時間： 

<pre class="brush: php; title: ; notranslate" title="">#!/usr/bin/php -q
<?PHP

/*
 * MySQL quota script
 * written by Sebastian Marsching
 *
 */

/*
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/


/*
 * Create table for quota data with the following statement:
 *
 * CREATE TABLE `Quota` (`Db` CHAR(64) NOT NULL, 
 * `Limit` BIGINT NOT NULL,
 * `Exceeded` ENUM('Y','N') DEFAULT 'N' NOT NULL,
 * PRIMARY KEY (`Db`), UNIQUE (`Db`));
 *
 * The field 'db' stores the information for which database
 * you want to limit the size.
 * The field 'limit' is the size limit in bytes.
 * The field 'exceeded' is only used internally and must be
 * initialized with 'N'.
 */
 
/*
 * Settings
 */
 
$mysql_host  = 'localhost';
$mysql_user  = 'root'; // Do NOT change, root-access is required
$mysql_pass  = '';
$mysql_db    = 'quotadb'; // Not the DB to check, but the db with the quota table
$mysql_table = 'quota';

/*
 * Do NOT change anything below
 */
 
$debug = 0;

// Connect to MySQL Server

if (!mysql_connect($mysql_host, $mysql_user, $mysql_pass))
{
 echo "Connection to MySQL-server failed!";
 exit;
}

// Select database

if (!mysql_select_db($mysql_db))
{
 echo "Selection of database $mysql_db failed!";
 exit;
}

// Check quota for each entry in quota table

$sql = "SELECT * FROM $mysql_table;";
$result = mysql_query($sql);

while ($row = mysql_fetch_array($result))
{
 $quota_db = $row['db'];
 $quota_limit = $row['limit'];
 $quota_exceeded = ($row['exceeded']=='Y') ? 1 : 0;
 
 if ($debug)
  echo "Checking quota for '$quota_db'...\n";
 
 $qsql = "SHOW TABLE STATUS FROM $quota_db;";
 $qresult = mysql_query($qsql);
 
 if ($debug)
  echo "SQL-query is \"$qsql\"\n";
 
 $quota_size = 0;
 
 while ($qrow = mysql_fetch_array($qresult))
 {
  if ($debug)
  { echo "Result of query:\n"; var_dump($qrow); }
  $quota_size += $qrow['Data_length'] + $qrow['Index_length'];
 }
 
 if ($debug)
  echo "Size is $quota_size bytes, limit is $quota_limit bytes\n";
 
 if ($debug && $quota_exceeded)
  echo "Quota is marked as exceeded.\n";
 if ($debug && !$quota_exceeded)
  echo "Quota is not marked as exceeded.\n";
 
 if (($quota_size > $quota_limit) && !$quota_exceeded)
 {
  if ($debug)
   echo "Locking database...\n";
  // Save in quota table  
  $usql = "UPDATE $mysql_table SET exceeded='Y' WHERE db='$quota_db';";
  mysql_query($usql);
  if ($debug)
   echo "Querying: $usql\n";
  // Dismiss CREATE and INSERT privilege for database
  mysql_select_db('mysql');
  $usql = "UPDATE db SET Insert_priv='N', Create_priv='N' WHERE Db='$quota_db';";
  mysql_query($usql);
  if ($debug)
   echo "Querying: $usql\n";
  mysql_select_db($mysql_db);
 }
 
 if (($quota_size <= $quota_limit) && $quota_exceeded) 
 {
  if ($debug)
   echo "Unlocking database...\n";
  // Save in quota table
  $usql = "UPDATE $mysql_table SET exceeded='N' WHERE db='$quota_db';";
  mysql_query($usql);
  if ($debug)
   echo "Querying: $usql\n";
  // Grant CREATE and INSERT privilege for database
  mysql_select_db('mysql');
  $usql = "UPDATE db SET Insert_priv='Y', Create_priv='Y' WHERE Db='$quota_db';";
  mysql_query($usql);
  if ($debug)
   echo "Querying: $usql\n";
  mysql_select_db($mysql_db);
 }
}

?></pre> 參考網站：

<http://projects.marsching.org/mysql_quota/>

 [1]: http://phorum.study-area.org
 [2]: http://phorum.study-area.org/index.php/topic,58445.0.html
 [3]: http://linux.vbird.org/linux_basic/0420quota.php
 [4]: http://projects.marsching.org/mysql_quota/