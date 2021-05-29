---
title: '[mysql] mysqlbinlog 資料庫處理二進制日誌檔案的實用工具'
author: appleboy
type: post
date: 2007-03-29T14:59:23+00:00
url: /2007/03/mysql-mysqlbinlog-資料庫處理二進制日誌檔案的實用工具/
views:
  - 5370
bot_views:
  - 901
dsq_thread_id:
  - 249003709
categories:
  - FreeBSD
  - Linux
  - MySQL

---
當初 國史館台灣文獻館 數位點藏計劃派我去台北 中研院 參加 dor系統計劃的時候，當時有介紹此指令，不過那時候聽不是很清楚，後來在我開發的系統上面惡搞了一下，早上玩自己的資料庫，不小心把他crash掉囉，所以趕緊用 mysqlbinlog 恢復了一堆資料，真是好顯，也虧自己有備份一周的資料庫。 當然，系統剛弄好是沒有開啟 mysqlbinlog 的功能，至少在 CentOS4.4 上面我還要去開啟，不過 ubuntu 系統預設就已經開啟了，不過沒關係，只要利用下面方法就可以達到了 修改 my.cnf [ CentOS: /etc/my.cnf Ubuntu: /etc/mysql/my.cnf ]，加入下面語法 # Replication Master Server (default) # binary logging is required for replication log-bin=mysql-bin <!--more--> 不過話說當你開啟這個功能之後，你會發現在 /var/lib/mysql/ 底下多出很多檔案 

<pre class="brush: bash; title: ; notranslate" title="">-rw-rw----   1 mysql mysql  33164904  1月 17 15:44 mysql-bin.000001
-rw-rw----   1 mysql mysql      4007  1月 17 15:50 mysql-bin.000002
-rw-rw----   1 mysql mysql  70288989  1月 29 22:38 mysql-bin.000003
-rw-rw----   1 mysql mysql     16665  1月 29 22:41 mysql-bin.000004
-rw-rw----   1 mysql mysql      4792  1月 29 22:42 mysql-bin.000005
-rw-rw----   1 mysql mysql  56274069  2月 10 06:25 mysql-bin.000006
-rw-rw----   1 mysql mysql 893963240  3月 29 09:21 mysql-bin.000007
-rw-rw----   1 mysql mysql 666605284  3月 29 09:39 mysql-bin.000008
-rw-rw----   1 mysql mysql    151946  3月 29 10:02 mysql-bin.000009
-rw-rw----   1 mysql mysql   3450785  3月 29 22:38 mysql-bin.000010
</pre> 上面就是產生 mysqlbinlog 檔案，當然如果你要觀看那一個檔案下指令吧 

> shell> mysqlbinlog binlog.0000003 裏面的語法包跨 每個語句花費的時間、客戶發出的線程ID、發出線程時的時間戳，也可以遠端觀看 當讀取遠程二進制日誌時，可以通過連接參數選項來指示如何連接伺服器，但它們經常被忽略掉，除非您還指定了&#8211;read-from-remote-server選項。這些選項是&#8211;host、&#8211;password、&#8211;port、&#8211;protocol、&#8211;socket和&#8211;user。 底下來說明一下用法~ 1. 指定恢復時間語法 假如你今天早上9點不小心砍掉哪個資料庫的資料表，你可以利用下面語法來恢復 

<pre class="brush: bash; title: ; notranslate" title="">mysqlbinlog --stop-date="2007-03-29 8:59:59"  /var/lib/mysql/bin.000001 | mysql -u root -p</pre> 如果你想恢復後面9點以後sql語法 可以使用 

<pre class="brush: bash; title: ; notranslate" title="">mysqlbinlog --start-date="2007-03-29 9:00:00"  /var/lib/mysql/bin.000001 | mysql -u root -p</pre> 或者是 你想恢復 9點到10點之間的sql語法，則下面語法是您想要的 

<pre class="brush: bash; title: ; notranslate" title="">mysqlbinlog --start-date="2007-03-29 9:00:00"  --stop-date="2007-03-29 10:00:00" /var/lib/mysql/bin.000001 | mysql -u root -p</pre> 其實你也可以不要執行，先把sql語法輸出到 /tmp/restore.sql 

<pre class="brush: bash; title: ; notranslate" title="">mysqlbinlog --start-date="2007-03-29 9:00:00"  --stop-date="2007-03-29 10:00:00" /var/lib/mysql/bin.000001 &gt; /tmp/restore.sql</pre> 當然 你也可以指定你要輸出的 database，免的檔案很大 

<pre class="brush: bash; title: ; notranslate" title="">--database=db_name，-d db_name
--host=host_name，-h host_name</pre>

[mysql note(補齊binary log)][1]

 [1]: http://phorum.study-area.org/viewtopic.php?t=37983