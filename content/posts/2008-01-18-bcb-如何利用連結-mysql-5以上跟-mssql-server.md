---
title: '[BCB] 如何利用連結 MySQL 5以上跟 MSSQL Server'
author: appleboy
type: post
date: 2008-01-18T14:33:36+00:00
url: /2008/01/bcb-如何利用連結-mysql-5以上跟-mssql-server/
bot_views:
  - 786
views:
  - 4810
dsq_thread_id:
  - 249962254
categories:
  - 'BCB[Borland C/C++ Builder]'
  - sql

---
這兩天開始玩 BCB 的這東西，其實我原本就有打算要學一套視窗軟體，畢竟好像還不錯，可以寫寫軟體，所以就拿了 BCB 來學習。 剛開始想說寫個要跟 MSSQL 資料庫的統計圖，發現 BCB 並不支援 MSSQL，解決方式，當然就是拿 Delphi 的元件 利用 Delphi 7 的 MSSQL Driver Update 內的「dbexpmss.dll」 Copy 到「 $(BCB)\BIN 」 然後在設定 dbxconnections.ini 

> [MSSQL] GetDriverFunc=getSQLDriverMSSQL LibraryName=dbexpmss.dll VendorLib=oledb HostName=ServerName DataBase=Database Name User_Name=user Password=password BlobSize=-1 ErrorResourceFile= LocaleCode=0000 MSSQL TransIsolation=ReadCommited OS Authentication=False 然後再來是 MySQL5，原本的 BCB 並不支援 MSQL5 所以自己另外找了文章 [http://www.justsoftwaresolutions.co.uk/delphi/dbexpress\_and\_mysql_5.html][1]

 [1]: http://www.justsoftwaresolutions.co.uk/delphi/dbexpress_and_mysql_5.html