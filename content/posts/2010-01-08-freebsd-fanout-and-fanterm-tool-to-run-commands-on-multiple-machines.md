---
title: '[FreeBSD] Fanout and Fanterm Tool to run commands on multiple machines'
author: appleboy
type: post
date: 2010-01-08T07:44:10+00:00
url: /2010/01/freebsd-fanout-and-fanterm-tool-to-run-commands-on-multiple-machines/
views:
  - 3589
bot_views:
  - 345
dsq_thread_id:
  - 252008049
categories:
  - FreeBSD
  - Linux
tags:
  - Fanout
  - Fanterm
  - FreeBSD

---
在 Linux 或 [FreeBSD][1] 系統底下，如何下達 command 來達到多方控管機器，在網路上找到 [Fanout][2] and [fanterm][3] 這兩套軟體，可以實現我想要的目的，在 FreeBSD 有把 [sysutils/fanout][4] 進到 ports 裡面，安裝方式很簡單，就直接 make install clean 就可以了，用法也很簡易： 

<pre class="brush: bash; title: ; notranslate" title="">Usage:
  /usr/local/bin/fanout "MACHINES" "commands and parameters to run on each machine"
  /usr/local/bin/fanout -h      #Show this help
  /usr/local/bin/fanout --noping        # Do not ping before running command</pre> 當然事情沒有這麼簡單，因為是透過 SSH 方式去對其他機器下 command，所以作者都把預設 port 設定成 22，沒有完整考慮到其他環境，管理重要的 Server 怎麼會設定 22 阿，一定會改掉的阿，後來檢查一下 /usr/local/bin/fanout 這隻程式，並非編譯過的 binary 檔案，所以打開來看，就是利用 bash shell script 所寫的程式，網路上 Google 也找到一篇 

[Does anyone know how to specify a ssh port number with fanout?][5] 文章，但是最後我是自己把 bash 改成支援可調整 port，也就是 MACHINES 可以放入：ip:portt or hostname:port patch 檔案：需要的就拿去 patch 就可以用了 

<pre class="brush: bash; title: ; notranslate" title="">--- /usr/local/bin/fanout   2010-01-08 15:06:47.000000000 +0800
+++ fanout  2010-01-08 15:00:04.000000000 +0800
@@ -53,13 +53,22 @@
 STARTTIME=`date`
 for ONETARGET in $TARGETS ; do
    case $ONETARGET in
-   *@*)                                    #user@machine form
+   *@*)                                    #user@machine:port form
        ONEUSER="-l ${ONETARGET%%@*}"
-       ONEMACH=${ONETARGET##*@}
-       HEADER="==== As ${ONETARGET%%@*} on $ONEMACH ===="
+       SERVER=${ONETARGET##*@}
+       HOST=`echo $SERVER | awk -F: '{ printf $1 }'`
+       PORT=`echo $SERVER | awk -F: '{ printf $2 }'`
+       if [ "$PORT" != "" ]; then
+           ONEPORT="-p ${PORT}"
+       else
+           ONEPORT=""
+       fi
+       ONEMACH=${HOST}
+       HEADER="==== As ${ONEUSER} on $ONEMACH port: ${PORT}===="
        ;;
    *)                                  #just machine form
        ONEUSER=""
+       ONEPORT=""
        ONEMACH=$ONETARGET
        HEADER="==== On $ONEMACH ===="
        ;;
@@ -74,7 +83,7 @@
    if [ "$PING" = "NO" ] || ping -c 3 $ONEMACH >/dev/null 2>/dev/null ; then
        echo Starting $ONETARGET >/dev/stderr               #Machine is reachable
        #Show machine name header, show command output, indented two spaces, save all to a temp file.
-       ( echo $HEADER ; ssh -n $ONEUSER $ONEMACH "$*" | sed -e 's/^/  /' ; echo ) >$TMPFILE &
+       ( echo $HEADER ; ssh $ONEPORT -n $ONEUSER $ONEMACH "$*" | sed -e 's/^/  /' ; echo ) >$TMPFILE &
    else
        echo $ONETARGET unavailable >/dev/stderr            #Machine not responding
        echo $HEADER ; echo "==== Machine unreachable by ping" ; echo >$TMPFILE</pre>

 [1]: http://www.freebsd.org
 [2]: http://www.stearns.org/fanout/README.html#fanout
 [3]: http://www.stearns.org/fanout/README.html#fanterm
 [4]: http://www.freshports.org/sysutils/fanout/
 [5]: http://www.linuxquestions.org/questions/linux-software-2/does-anyone-know-how-to-specify-a-ssh-port-number-with-fanout-776895/