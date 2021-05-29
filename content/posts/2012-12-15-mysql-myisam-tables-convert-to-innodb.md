---
title: MySQL MyISAM Engine 轉換成 InnoDB
author: appleboy
type: post
date: 2012-12-15T02:50:04+00:00
url: /2012/12/mysql-myisam-tables-convert-to-innodb/
dsq_thread_id:
  - 975240186
categories:
  - InnoDB
  - MyISAM
  - MySQL
tags:
  - InnoDB
  - MySQL

---
<div style="margin: 0 auto; text-align: center;">
  <img src="https://i2.wp.com/farm9.staticflickr.com/8488/8171305355_db09e220a4_o.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />
</div> 如果對於 InnoDB 不了解的讀者們，可以參考作者之前寫的 

<a href="http://blog.wu-boy.com/2012/11/innodb-as-the-default-mysql-storage-engine/" target="_blank">MySQL 預設儲存引擎: InnoDB 介紹</a>，最近開始把原本 <a href="http://dev.mysql.com" target="_blank">MySQL</a> 5.1 預設 <a href="http://dev.mysql.com/doc/refman/5.5/en/myisam-storage-engine.html" target="_blank">MyISAM</a> Table 全部轉換成 <a href="http://dev.mysql.com/doc/refman/5.5/en/innodb-storage-engine.html" target="_blank">InnoDB</a>，MySQL 5.5 版本開始預設的儲存引擎就是 InnoDB，InnoDB 現在也非常完整，也支援 Full Text (5.6.4 開始支援)。作者在轉換過程其實蠻順利的，步驟也不是很複雜，只要按底下步驟，就可以順利轉換。 <!--more-->

### 備份原本資料庫 為了避免資料庫被玩壞，轉換之前一定要做好備份，也或者先在別台機器實驗，備份 MySQL InnoDB 非常簡單，如果你是安裝 Windows 版的 MySQL，透過像是 

<a href="http://www.appservnetwork.com/" target="_blank">Appserv</a> 或 <a href="http://www.apachefriends.org/en/xampp.html" target="_blank">xampp</a> 懶人包，其實可以找到 MySQL 底下有個 data 目錄，將這目錄直接備份即可。如果是 Linux 也是一樣，備份 **<span style="color:green">/var/lib/mysql</span>**，最後提供 MySQL 指令備份，透過 <a href="http://dev.mysql.com/doc/refman/5.5/en/mysqldump.html" target="_blank">mysqldump</a> 就可以了 

<pre class="brush: bash; title: ; notranslate" title="">$ mysqldump -u root -p database_name > db_name.sql</pre>

### 轉換 MyISAM tabe to InnoDB 直接用 vim 或編輯器打開上面指令所備份的 .sql 檔案，將 

<pre class="brush: bash; title: ; notranslate" title="">ENGINE=InnoDB</pre> 改成 

<pre class="brush: bash; title: ; notranslate" title="">ENGINE=InnoDB ROW_FORMAT=COMPRESSED</pre> 存檔後，再透過底下指令將資料存回到指定資料庫 

<pre class="brush: bash; title: ; notranslate" title="">$ mysql -u root -p database_name < db_name.sql[/code]

完成後可以透過 <a href="http://www.phpmyadmin.net" target="_blank">phpMyAdmin</a> 檢查看看是不是全部的都已經轉換成 InnoDB。



<h3>
  新增 FOREIGN KEY
</h3>
最後設定 InooDB 好用的 

<a href="http://dev.mysql.com/doc/refman/5.5/en/innodb-foreign-key-constraints.html" target="_blank">FOREIGN KEY</a>，FOREIGN KEY 可以綁定 parent table 跟 child table 多個 key 值，可以指定，當刪除 parent table 資料時，連帶 child table 也一起刪除或者是改成 Default value，轉換之前有一點非常要注意的是，FOREIGN KEY 的欄位格式需要一致，也就是如果 parent 欄位是 int(11) 那 child 的欄位就必須一樣，否則會無法設定 FOREIGN KEY，另外如果原本的資料庫非常大，也許會存在有些 child key 沒對應到 parent key，原因就是刪除了 parent row，但是忘記刪除相關 table 資料，所以務必寫程式將那些冗員刪除。

利用 ALTER 指令來增加 FOREIGN KEY

alter table tbl_name add FOREIGN KEY (index_name) REFERENCES tbl_name (index_col_name) ON DELETE reference_option ON UPDATE reference_option;</pre> reference\_option 可以是 CASCADE, SET NULL, RESTRICT, NO ACTION 或 SET DEFAULT。舉個例子，建立 users 跟 uses\_groups 資料表，users 內有 id auto increament key，uses\_groups 則是有 user\_id 欄位來對應，所以透過底下可以設定該 FOREIGN KEY 

<pre class="brush: sql; title: ; notranslate" title="">alter table uses_groups add FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;</pre> 經過上述步驟，相信大家都可以輕鬆轉換，如果遇到什麼問題，可以在此篇留言。或者可以參考 

<a href="http://blog.gslin.org/" target="_blank">gslin</a> 大神寫的 <a href="http://blog.gslin.org/archives/2012/04/22/2869/%E6%8A%8A%E5%A4%A7%E9%87%8F%E7%9A%84-myisam-table-%E6%8F%9B%E6%88%90-innodb/" target="_blank">把大量的 MyISAM table 換成 InnoDB</a>