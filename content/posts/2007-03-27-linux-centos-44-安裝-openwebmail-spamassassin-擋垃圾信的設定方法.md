---
title: '[Linux] CentOS 4.4 安裝 Openwebmail + spamassassin 擋垃圾信的設定方法'
author: appleboy
type: post
date: 2007-03-28T02:10:17+00:00
url: /2007/03/linux-centos-44-安裝-openwebmail-spamassassin-擋垃圾信的設定方法/
views:
  - 9763
bot_views:
  - 1617
dsq_thread_id:
  - 249193013
categories:
  - Linux
  - mail
  - Network

---
其實以現在linux安裝方式已經相當容易了，不像以前都要tarball安裝，相當複雜，昨天安裝 openwebmail 只花了幾分鐘的時間，目前系統CentOS4.4 主機相當好，所以安裝起來特別快

想利用 yum install 的安裝方式，不過發現沒有 openwebmail 的套件，所以上網找了rpm

注意：要架設 Open Webmail 前，請務必先將 postfix(架設mail伺服器)、dovecot(POP3伺服器) 架設好

<!--more-->


安裝

```bash

# http://apt.sw.be/redhat/el4/en/x86_64/dag/RPMS/
# 系統X86_64
yum -y install perl-suidperl
rpm -ivh http://apt.sw.be/redhat/el4/en/x86_64/dag/RPMS/perl-Compress-Zlib-1.42-1.el4.rf.x86_64.rpm
rpm -ivh http://apt.sw.be/redhat/el4/en/x86_64/dag/RPMS/perl-Text-Iconv-1.4-1.2.el4.rf.x86_64.rpm
wget http://openwebmail.org/openwebmail/download/redhat/rpm/release/openwebmail-2.52-1.i386.rpm
rpm -ivh openwebmail-2.52-1.i386.rpm
rm -rf openwebmail-2.52-1.i386.rpm

```

修改 openwebmail.conf



```bash
enable_pop3 yes 修改成--> enable_pop3 no
default_language en 修改成--> default_language zh_TW.Big5
default_iconset Cool3D.English 修改成--> default_iconset Cool3D.Chinese.Traditional
<default_signature>
--
國史館台灣文獻館 (http://nas.th.gov.tw)
</default_signature>
#此此四行是使用者寄信的預設簽名檔，請自行修改紅字部分
webdisk_rootpath /webdisk 修改成--> webdisk_rootpath /
```

修改 dbm.conf

```bash
dbm_ext .db
dbmopen_ext .db
dbmopen_haslock no
```

使用 Open WebMail 變更密碼的時候，順便修改 samba 密碼

```bash

change_smbpasswd no 修改成--> change_smbpasswd yes

```

初始化

```bash
/var/www/cgi-bin/openwebmail/openwebmail-tool.pl --init
```

spamassassin 擋垃圾信的設定方法

首先要先確認，有無安裝 spamassassin



```bash
yum install spamassassin
```

修改 openwebmail.conf  找到 enable_spamcheck 這一段，然後加入以下設定



```bash

spamcheck_pipe                  /usr/bin/spamc  -c -x -t60 -u @@@USERNAME@@@
learnham_pipe                   /usr/bin/sa-learn --local --ham
learnspam_pipe                  /usr/bin/sa-learn --local --spam
enable_spamcheck                yes
enable_learnspam                yes
spamcheck_source_allowed        all

```

然後測試看看有無學習，以 sample-spam.txt 寄一封測試的廣告信

mail -s test appleboy@nas.th.gov.tw < /path/sample-spam.txt

如果成功的話，會出現以下訊息



```bash
Tue Mar 27 15:20:19 2007 - [40092] (218.163.176.18) appleboy - learnspam - 1 learned, 1 examined
```

這樣每個使用者就可以開始使用 OpenWebMail 的擋廣告信及學習廣告信的功能了

