---
title: 'MySQL 預設儲存引擎: InnoDB 介紹'
author: appleboy
type: post
date: 2012-11-10T09:00:02+00:00
url: /2012/11/innodb-as-the-default-mysql-storage-engine/
dsq_thread_id:
  - 921622318
categories:
  - InnoDB
  - MyISAM
  - MySQL
tags:
  - InnoDB
  - MyISAM
  - MySQL

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/8171305355/" title="mysql_logo by appleboy46, on Flickr"><img src="https://i1.wp.com/farm9.staticflickr.com/8488/8171305355_7fb578fdc9.jpg?resize=489%2C253&#038;ssl=1" alt="mysql_logo" data-recalc-dims="1" /></a>
</div>

<a href="http://www.mysql.com" target="_blank">MySQL</a> 是一套眾所皆知的 Database System，今天來簡介 <a href="http://dev.mysql.com/doc/refman/5.5/en/myisam-storage-engine.html" target="_blank">InnoDB</a> 儲存引擎，在 MySQL 5.5.5 之前預設的儲存引擎是 <a href="https://dev.mysql.com/doc/refman/5.5/en/myisam-storage-engine.html" target="_blank">MyISAM</a>，但是為什麼在 5.5 之後官方要將預設儲存引擎換成 InnoDB 呢？大家都知道 InnoDB 用來交易管理非常方便，因為 InnoDB 透過 row lock，相對於 <a href="http://dev.mysql.com/doc/refman/5.5/en/myisam-storage-engine.html" target="_blank">MyISAM</a> 透過 table lock 來的有效率，也避免大量寫入的時候，造成無法讀取資料，這就是 row lock 的優勢，當然用 InnoDB 最主要的原因還有 Full-text search indexes 功能，但是別擔心 MySQL 5.6.4 之後(含此版本) InnoDB 開始支援 Full-text search 功能，另外在使用 MyISAM 時候，如果資料突然出問題，還必須使用 <a href="http://dev.mysql.com/doc/refman/5.0/en/binary-log.html" target="_blank">MySQL Binary Log</a> 來恢復資料，如果用 InnoDB 這就沒關係了。大家還在用 MyISAM 嘛？開始升級伺服器，一起體驗 InnoDB 的功能，如果已經上線很久的網站，作者不建議轉換，因為可能會遇到很多雷。 <!--more--> 目前不用太擔心硬體的架構這方面了，隨便都是 64G 記憶體，四核心主機，大家所在意的還是 MySQL 是否 reliability 跟錯誤恢復，所以 MySQL 在 5.5 以後的版本大膽將 InnoDB 儲存引擎，建立資料表不用再加上 

<span style="color: green;"><strong>ENGINE=InnoDB</strong></span>，但是大家可以發現 MySQL 安裝好後，內建 <span style="color: red;"><strong>mysql</strong></span> 和 <span style="color: red;"><strong>information_schema</strong></span> 資料庫還是用 InnoDB 儲存引擎，請大家不要亂動這兩個資料庫。底下來看看 InnoDB 的優勢。 

### InnoDB 優勢 已經使用過 InnoDB 的朋友們，作者相信你可以來嘗試看看 InnoDB，使用的同時會發現很多 InnoDB 優點。 1. 如果伺服器因為硬體或軟體疏失，無論發生任何問題，請重新啟動伺服器，啟動之後並不需要做任何事情，InnoDB 會自動修復 crash 部份，將已經 commit 的資料全部寫回資料表。假如您處理任何資料，但是尚未 commit，系統會自動恢復，所以只要將伺服器重新啟動，就可以恢復到 crash 之前的狀態。 2. InnoDB 將 Table 及 index 資料 cache 在 buffer pool，所以可以快速存取任何資料，因為這些資料都是直接從 Memory 讀取，快取可以存放任和型態的資料，提升處理效能，假如您有實體主機，請設定 60% ~ 80% 實體記憶體給 InnoDB buffer pool。 3. 設計資料庫時，請務必在每個資料表設定適當的 Primary key，當您在執行任何 SQL 語法時，只要牽扯到 Primary key，InnoDB 會自動優化效能，如果將 Primary key 用在 WHERE，ORDER BY，GROUP 等條件子句或 join 操作，讀取速度會是非常快。 4. InnoDB 可以讓您同時讀取或寫入同一個資料表，它將需要改變的資料存在 streamline disk I/O。所以大家不用擔心 Lock Table 的問題了。 5. InnoDB 提供錯誤偵測 (checksum mechanism)，假如有資料已經損壞在 Disk 或 Memory，使用此資料之前，系統將會提醒你。 6. InnoDB 具備處理極大量資料的效能優勢，假如在同一資料表存取同樣的資料，內部透過 Adaptive Hash Index 機制提升讀取速度。 以上是作者覺得 InnoDB 改善的地方，大家可以透過 

<span style="color: green;"><strong>SHOW ENGINES</strong></span> 指令知道伺服器是否支援 InnoDB