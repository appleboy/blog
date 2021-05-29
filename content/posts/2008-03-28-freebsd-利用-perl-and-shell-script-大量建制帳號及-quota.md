---
title: '[FreeBSD] 利用 perl and shell script 大量建制帳號及 Quota'
author: appleboy
type: post
date: 2008-03-28T07:39:56+00:00
url: /2008/03/freebsd-利用-perl-and-shell-script-大量建制帳號及-quota/
views:
  - 4107
bot_views:
  - 528
dsq_thread_id:
  - 246757467
categories:
  - FreeBSD
  - Perl
tags:
  - bash
  - FreeBSD
  - Perl
  - quota
  - Shell Script

---
最近幫繫上處理 [FreeBSD][1] 機器，要碰到大量建制帳號跟 quota，所以上網找了一下教學，網路上就很多教學了，只不過要懂一些 [perl][2] 跟 [shell script][3] 的基本觀念，在弄起來會比較方便，時間也會縮短許多。 首先開帳號的話，就是利用 [pw][4] 這個指令了，這個裡指令非常強大，可以新增使用者，或者是修改使用者的特性，如登入的 shell，comment&#8230;.等等 先產生一個 passwd.txt 裡面內容格式就是 &#8220;帳號,密碼&#8221;，這樣的格式 

<pre class="brush: bash; title: ; notranslate" title="">biomat,"xxxx"
biomed,"xxxx"
surface,"xxxx"
tissue,"xxxx"</pre> 然後在寫一個 shell 檔去把它讀進來，shell 檔如下： 

<!--more-->

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/sh
lab_name=($(cut -d ',' -f1 passwd.txt))
lab_number=${#lab_name[@]}
for (( i=1; i&lt;=$lab_number; i=i+1 ))
do
  if [ "${lab_name[$i]}" != "" ]; then
    if [ "${i}" -gt 10 ]; then
      j="${i}"
    else
      j="0${i}"
    fi
    printf "pw useradd -n ${lab_name[$i]} -c Lab${j} -d /home/Lab/Lab${j} -g Lab -s /sbin/nologin -m \n"
  fi
done
[/code]

然後再來是設定使用者的密碼
[code lang="bash"]
lab_name=($(cut -d ',' -f1 passwd.txt))
lab_number=${#lab_name[@]}
lab_password=($(cut -d ',' -f2 passwd.txt))
for (( i=1; i&lt;=$lab_number; i=i+1 ))
do
  if [ "${lab_name[$i]}" != "" ]; then
    printf "/usr/bin/perl /root/change_passwd.pl ${lab_name[$i]} ${lab_password[$i]} \n"
  fi
done
[/code]
裡面有用到一隻 change_passwd.pl 的 perl 程式如下：
[code lang="perl"]
#!/usr/bin/perl
    $PW_COMMAND="pw usermod -n $ARGV[0] -h 0 " ;
    $fname="|".$PW_COMMAND ; open(OUT, $fname) ;
    print OUT $ARGV[1] ;
    close(OUT) ;
[/code]
這樣就完成了建立帳號的動作，不過你有分群組的話，請記得先建立群組

[code lang="bash"]pw groupadd lab[/code]

再來是啟動 Quota 的部份，首先要在 kernel 裡面新增

[code lang="bash"]Options Quota[/code]

然後重新編譯核心，請參考 <a href="http://blog.wu-boy.com/2006/10/29/28/">[FreeBSD] 系統核心支援ipfw 更新kernel</a>

再來修改 /etc/fstab 的部份：

# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/ad0s1b             none            swap    sw              0       0
/dev/ad0s1a             /               ufs     rw              1       2
/dev/ad0s1e             /tmp            ufs     rw              2       2
/dev/ad0s1f             /usr            ufs     rw<span style="color:red">,userquota,groupquota</span>         2       0
/dev/ad0s1d             /var            ufs     rw              2       2
/dev/acd0               /cdrom          cd9660  ro,noauto       0       0</pre> 這樣就可以了，在 /etc/rc.conf 加入 

<pre class="brush: bash; title: ; notranslate" title="">check_quotas="YES"
# 第一次安裝 Quota 時，必須先到要管理硬碟空間的分割區的所屬目錄中執行 quotacheck -avug。
cd /home
quotacheck -avug</pre> # 開機時啟動 Quota 建立 

**<span style="color:green">/usr/local/etc/rc.d/quota_on.sh</span>** 

<pre class="brush: bash; title: ; notranslate" title="">#!/bin/sh
# Check quota and then turn quota on.
if [ -x /sbin/quotacheck ]
then
       echo "Checking quotas. This may take some time."
       /sbin/quotacheck -avug
       echo " Done."
fi

if [ -x /usr/sbin/quotaon ]
then
       echo "Turning on quota."
       /usr/sbin/quotaon -avug
fi
</pre> 更改權限 chmod +x /usr/local/etc/rc.d/quota_on.sh 使其開機時自動執行。 

<pre class="brush: bash; title: ; notranslate" title="">#設定 User1 的 Quota
$ edquota -u User1

#將User1的設定值copy給其他人
$ edquota -p User1 User2,User3,User4,.....

#將User1的設定值copy給所有人
$ edquota -p User1 *

#檢查所有使用者硬碟使用情形
$ repquota -v -a</pre> reference: 

<http://www.captain.at/howto-linux-shell-reference.php> <http://freebsd.lab.mlc.edu.tw/quotas.shtml> <http://www.freebsd.org/doc/en/books/handbook/quotas.html>

 [1]: http://www.freebsd.org/
 [2]: http://cpan.perl.org/
 [3]: http://linux.vbird.org/linux_basic/0340bashshell-scripts.php
 [4]: http://www.freebsd.org/cgi/man.cgi?query=pw&apropos=0&sektion=0&manpath=FreeBSD+7.0-RELEASE&format=html