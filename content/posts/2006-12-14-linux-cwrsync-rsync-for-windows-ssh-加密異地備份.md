---
title: '[Linux] cwRsync [rsync for windows] SSH 加密異地備份'
author: appleboy
type: post
date: 2006-12-15T03:35:47+00:00
url: /2006/12/linux-cwrsync-rsync-for-windows-ssh-加密異地備份/
views:
  - 20953
bot_views:
  - 2426
dsq_thread_id:
  - 246709692
categories:
  - FreeBSD
  - Linux
  - windows
tags:
  - FreeBSD
  - Linux
  - rsync

---
這個我找了好久～因為館內用的系統2003server跟前端系統linux，2個是不同的作業系統 但是我每天都有備份linux資料，我想同步到win的server上面，但是這樣就要在win的機器上面架設rsync伺服器跟rsync client套件 所以我找了很久 終於找到了 cwRsync 有client端 跟server端 跟ssh 加密 open ssh server [cwRsync &#8211; Rsync for Windows][1] 請點選中間的 Download cwRsync Server [<img src="https://i1.wp.com/static.flickr.com/133/322694644_095d6d4f70_o.jpg?resize=488%2C107" alt="1" data-recalc-dims="1" />][2] 下載之後解壓縮，裡面會有一個執行檔，在安裝即可 安裝好之後，去程式集打開 cwrsync server -> 05. Start a Unix BASH Shell 會出現底下畫面 [<img src="https://i2.wp.com/static.flickr.com/125/322699548_9b0e6f0dc2.jpg?resize=500%2C322" alt="2" data-recalc-dims="1" />][3] 執行之後，會出現一個 cmd 視窗但字元卻是 $ 的。 <!--more--> 請輸入下列指令 /bin/activate-user.sh 系統時會出現訊息： 

> Do you want to activarte a (l)ocal or a (d)omain user [l/d]?  此時請按 l (小寫L) 接著畫面最下方會出現： 

> Enter a user account for activation:  可輸入 Administrator 或是其他帳號。 然後，接下來出現的訊息都可直接按 Enter 跳過了。 然後再去開啟 系統的服務 OpenSSHD 跟 Rsync Server 這樣子就可以連上了 你可以設定 rsync.conf 檔案「windows」 

<pre class="brush: bash; title: ; notranslate" title="">use chroot = false
strict modes = false
hosts allow = *
log file = rsyncd.log
pid file = rsyncd.pid

# Module definitions
# Remember cygwin naming conventions : c:\work becomes /cygwin/c/work
#
[backup_NAS]
path = /cygdrive/d/backup
read only = false
transfer logging = yes
read only = no
secrets file = /cygdrive/d/backup/rsyncd.secrets

[mv_001]
path = /cygdrive/e/001
read only = false
transfer logging = yes
read only = no
secrets file = /cygdrive/d/backup/rsyncd.secrets
</pre> windows底下對應目錄方式如下 

<pre class="brush: bash; title: ; notranslate" title=""># Module definitions
# Remember cygwin naming conventions : c:\work becomes /cygwin/c/work</pre> 這樣大致就設定成功了，現在來測試看看 底下我先用rsync server的方式 來測試速度 

<pre class="brush: bash; title: ; notranslate" title="">rsync -avl --delete --progress --password-file=/etc/rsyncd.192.168.100.7 /backup01/www_data /backup01/mysql_db  appleboy@192.168.100.7::backup_NAS</pre>

[<img src="https://i1.wp.com/farm1.static.flickr.com/133/322717036_2265974b90.jpg?resize=500%2C264&#038;ssl=1" alt="3" data-recalc-dims="1" />][4] 至少速度 都有3MB以上，速度相當不錯，半夜的時候還有衝到10MB左右 不過現在換用 ssh 加密傳輸 如下，不只速度慢，而且還要使用ssh密碼，比較麻煩，不過可以透過下面文章，來達到不必輸入密碼 [Rsync + SSH 讓 Server 自動異地備援也加密][5] 

<pre class="brush: bash; title: ; notranslate" title="">rsync -avl --delete --progress /backup01/www_data /backup01/mysql_db  Administrator@192.168.100.7:/cygdrive/d/backup</pre> 速度如下圖 

[<img src="https://i1.wp.com/static.flickr.com/138/322738674_110faff23a_o.jpg?resize=445%2C100" alt="4" data-recalc-dims="1" />][6] 真的差很多，不過終於搞定linux跟win備份的問題 其實寫script也可以，只不過懶 哈哈～ <http://phorum.study-area.org/viewtopic.php?t=42960>

 [1]: http://www.itefix.no/phpws/index.php?module=pagemaster&PAGE_user_op=view_page&PAGE_id=6&MMN_position=23:23
 [2]: https://www.flickr.com/photos/appleboy/322694644/ "Photo Sharing"
 [3]: https://www.flickr.com/photos/appleboy/322699548/ "Photo Sharing"
 [4]: https://www.flickr.com/photos/appleboy/322717036/ "3 by appleboy46, on Flickr"
 [5]: http://www.adj.idv.tw/server/linux_rsync.php
 [6]: https://www.flickr.com/photos/appleboy/322738674/ "Photo Sharing"