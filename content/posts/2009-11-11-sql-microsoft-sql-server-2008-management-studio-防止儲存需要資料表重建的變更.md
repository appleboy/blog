---
title: '[SQL] Microsoft SQL Server 2008 Management Studio 防止儲存需要資料表重建的變更'
author: appleboy
type: post
date: 2009-11-11T15:45:31+00:00
url: /2009/11/sql-microsoft-sql-server-2008-management-studio-防止儲存需要資料表重建的變更/
views:
  - 9624
bot_views:
  - 435
dsq_thread_id:
  - 246730663
categories:
  - sql
tags:
  - MSSQL

---
最近要寫 ASP.Net 專案，弄 [MSSQL][1] Server 2008 當作 Database，利用 [SQL 2008 SQL Server Management Studio][2] 管理資料庫，有點類似 [MySQL][3] [Navicat Lite][4] 軟體，或者是 Web 介面的 [phpMyAdmin][5]，在資料表填入欄位新增第一次之後，接下來要去修改資料表，發現會出現錯誤訊息：『**<span style="color: #ff0000;">防止儲存需要資料表重建的變更</span>**』 [<img src="https://i0.wp.com/farm3.static.flickr.com/2716/4093213252_7dba49bc8d.jpg?resize=455%2C339&#038;ssl=1" title="MSSQL2008_01 (by appleboy46)" alt="MSSQL2008_01 (by appleboy46)" data-recalc-dims="1" />][6] 解決方法其實很簡單：工具->選項->左邊選單 Designers，裡面把**<span style="color: #ff0000;">防止儲存需要資料表重建的變更</span>**，取消掉，就可以了 [<img title="MSSQL2008_02 (by appleboy46)" src="https://i1.wp.com/farm3.static.flickr.com/2743/4093213314_8c537177c1.jpg?resize=500%2C271&#038;ssl=1" alt="MSSQL2008_02 (by appleboy46)" data-recalc-dims="1" />][7] 參考資料：[[SQL]使用SQL 2008 SQL Server Management Studio 更改資料表結構 出現錯誤訊息不允許儲存變更][8]

 [1]: http://www.microsoft.com/taiwan/sql/default.mspx
 [2]: http://msdn.microsoft.com/zh-tw/library/ms174173.aspx
 [3]: http://www.mysql.com/
 [4]: http://www.navicat.com/
 [5]: http://www.phpmyadmin.net/
 [6]: https://www.flickr.com/photos/appleboy/4093213252/ "MSSQL2008_01 (by appleboy46)"
 [7]: https://www.flickr.com/photos/appleboy/4093213314/ "MSSQL2008_02 (by appleboy46)"
 [8]: http://www.dotblogs.com.tw/dotjum/archive/2009/09/11/10572.aspx