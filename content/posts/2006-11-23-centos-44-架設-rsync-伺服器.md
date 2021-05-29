---
title: '[CentOS 4.4] 架設 rsync 伺服器'
author: appleboy
type: post
date: 2006-11-23T12:23:11+00:00
url: /2006/11/centos-44-架設-rsync-伺服器/
views:
  - 5408
bot_views:
  - 1034
dsq_thread_id:
  - 246998328
categories:
  - Linux
tags:
  - Centos
  - Linux
  - rsync

---
  * 安裝方式：
  * 先檢查是否有安裝rsync

  * yum list installed | grep rsync
  * rsync.x86_64 2.6.3-1 installed

  *  <span class="postbody">vi /etc/xinetd.d/rsync </span>

> <span class="postbody">service rsync</span> <span class="postbody">{</span>         <span class="postbody">disable = yes</span>         <span class="postbody">socket_type = stream</span>         <span class="postbody">wait = no</span>         <span class="postbody">user = root</span>         <span class="postbody">server = /usr/bin/rsync</span>         <span class="postbody">server_args = &#8211;daemon</span>         <span class="postbody">log_on_failure += USERID</span> <span class="postbody">}</span>
> <span class="postbody">disable = yes</span> 改成 <span class="postbody">disable = no</span>
> 然後重新啟動xinetd
> /etc/init.d/xinetd restart<span class="postbody" />
  * <span class="postbody">vi /etc/rsyncd.conf</span>
  * <span class="postbody">[backup] path = /backup02 auth users = admin uid = root gid = root secrets file = /etc/rsyncd.secrets read only = no</span>

 <span class="postbody">[主機代號:自訂] path = 備份資料放置的路徑 auth users = 定義援權的帳號 uid = 應是執行時的uid gid = 應是執行時的gid secrets file = 認證密碼檔的位置 read only = 是否唯讀</span> 

  *  <span class="postbody">vi /etc/rsyncd.secrets</span>
  * <span class="postbody">填上 admin:1234 ＃自己建立密碼 </span>
  *  <span class="postbody">chown root:root /etc/rsyncd.secrets chmod 600 /etc/rsyncd.secrets </span>

<span class="postbody">設定client端：</span> 

  *  <span class="postbody">自行建立rsyncd.secrets vi /etc/rsyncd.secrets</span>
> /usr/bin/rsync -a &#8211;progress &#8211;log-format=/var/log/rsync.log &#8211;delete &#8211;password-file=/etc/rsyncd.secrets /var/www/html admin@192.168.100.244::backup
  * 說明 ：最後面backup名稱，就是你設定conf檔的名稱 <span class="postbody">[主機代號:自訂] </span>
  * &#8211;progress：顯示傳送進度
  * &#8211;delete：如果傳送端沒有此檔案的話，就刪除該檔案
  * &#8211;password-file：放置密碼檔案的地方