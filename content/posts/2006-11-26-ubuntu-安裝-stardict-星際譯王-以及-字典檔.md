---
title: '[Ubuntu] 安裝 StarDict 星際譯王 以及 字典檔'
author: appleboy
type: post
date: 2006-11-25T23:18:51+00:00
url: /2006/11/ubuntu-安裝-stardict-星際譯王-以及-字典檔/
views:
  - 14331
bot_views:
  - 2053
dsq_thread_id:
  - 246688512
categories:
  - Linux
  - Ubuntu
tags:
  - Linux
  - Ubuntu

---
如何在Ubuntu 底下安裝字典呢 先去搜尋 [StarDict Shell Script][1]{#p94}[StarDict Shell Script][1]{#p94}[StarDict Shell Script][1]{#p94} 套件 

> \[root@appleboy-dorm\]\[~\][21:59:39]# apt-cache search stardict sdcv &#8211; StarDict Console Version stardict &#8211; International dictionary for GNOME 2 stardict-common &#8211; International dictionary for GNOME 2 &#8211; data files stardict-tools &#8211; The dictionary conversion tools of stardict 然後安裝 

> apt-get install stardict-* 安裝好之後就可以在 應用程式->附屬應用程式->星際譯王 但是安裝好之後沒有任何字典檔,所以請自行到網路上下載 [http://stardict.sourceforge.net/Dictionaries\_zh\_TW.php][2] 下載軟體後 請把他解壓縮到 /usr/share/stardict/dic/ 解壓縮的目錄應該有 \*.dz \*.idx *.ifo 這3個檔案 重新啟動該軟體 就可以使用了 Update: 2007.04.16 有人有寫好script了，底下給大家參考 [StarDict Shell Script][1]{#p94}

 [1]: http://blog.wu-boy.com/wp-content/uploads/2007/04/stardictsh.txt
 [2]: http://stardict.sourceforge.net/Dictionaries_zh_TW.php