---
title: '[Linux] 備份策略～shell script'
author: appleboy
type: post
date: 2006-12-10T08:16:52+00:00
url: /2006/12/linux-備份策略～shell-script/
bot_views:
  - 1718
views:
  - 7426
dsq_thread_id:
  - 246786095
categories:
  - FreeBSD
  - Linux

---
※ 引述《wenshian.bbs@bbs.wretch.cc (小拓)》之銘言： > 備份檔案時是不是只能每天整個資料夾做備份?! > 可以做到哪些檔案有更新就把那些更新加進備份檔裡面嗎? > 我也想來試試 由linux備份到windows有什麼好建議嗎? > 最好可以不需要FTP上傳,不過如果難易度差很多我還是會考慮~= = 你可以先把 win的硬碟 mount到 linux上面 這樣就不需要用ftp上傳了 當然希望硬碟是fat32格式 這樣你就可以每天備份東西到 win的系統上面了～ 你說 &#8220;可以做到哪些檔案有更新就把那些更新加進備份檔裡面嗎?&#8221; 我覺得不需要這樣 你可以每天備份 用日期當作檔名 ，然後備份7天 只要超過7天的資料在砍掉，這樣你的備份檔 只會有7天以內的資料 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/bash
date=`date +%Y-%m-%d`
RETENTION_PERIOD="7"
HEADER="Backup data"
remove_oldfiles(){
      echo "Removing directory $1 files older than $RETENTION_PERIOD days" | wall
      find $1 -type f -mtime +$2 -exec rm '{}' \;
}

BACKUPDIR="/home/appleboy /var/www/html"
back_www_dir="/backup01/www_data"

#
# 開始備份
#

cd $back_www_dir

for TARGET in $BACKUPDIR
do
      echo "System backup on $TARGET" | wall
      BASENAME=`basename $TARGET`
      tar -zcvf ${BASENAME}-${date}.tar.gz $TARGET 1>/dev/null
      sleep 2
done

#
# 刪除7天前的資料
#
remove_oldfiles $back_www_dir $RETENTION_PERIOD
</pre>

<http://nas.th.gov.tw/~appleboy/program/backup.txt> [backup script][1]{#p79}

 [1]: http://blog.wu-boy.com/wp-content/uploads/2007/03/backup.txt