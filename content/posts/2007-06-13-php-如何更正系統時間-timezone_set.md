---
title: '[PHP] 如何更正系統時間 timezone_set'
author: appleboy
type: post
date: 2007-06-14T05:47:17+00:00
url: /2007/06/php-如何更正系統時間-timezone_set/
views:
  - 4287
bot_views:
  - 932
dsq_thread_id:
  - 248120092
categories:
  - FreeBSD
  - Linux
  - php

---
相信很多虛擬主機都會碰到時間的問題，比如說少 8 小時，或者是多 8 小時，現在只要在執行 php 的前端加上

<div>
  <pre class="brush: php; title: ; notranslate" title="">date_default_timezone_set("Asia/Taipei");</pre>
</div>

這樣就會更新到正確時間了，這樣在使用 `mktime()` 就沒啥問題了

或者去系統改 `php.ini` 檔案

<div>
  <pre class="brush: bash; title: ; notranslate" title="">;Defines the default timezone used by the date functions
date.timezone = Asia/Taipei</pre>
</div>

Linux 系統校正時間，可以執行底下 Script:

<div>
  <pre class="brush: bash; title: ; notranslate" title=""># check if link file
[ -L /etc/localtime ] && unlink /etc/localtime
# update time zone
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
aptitude -y install ntpdate
ntpdate time.stdtime.gov.tw
# write time to clock.
hwclock -w</pre>
</div>