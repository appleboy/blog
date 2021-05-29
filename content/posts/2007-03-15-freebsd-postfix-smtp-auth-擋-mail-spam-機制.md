---
title: '[FreeBSD] postfix + auth smtp + anti-UCE 詳細設定'
author: appleboy
type: post
date: 2007-03-16T05:40:40+00:00
url: /2007/03/freebsd-postfix-smtp-auth-擋-mail-spam-機制/
views:
  - 13782
bot_views:
  - 1779
dsq_thread_id:
  - 247194155
categories:
  - FreeBSD
  - mail
  - Network
  - www

---
自從考上中正電機「94年考上」之後接上 中正電機 郵件伺服器網管工作，目前 中正電機 已經把網路組歸到 中正通 訊底下了，所以我已經不再是 中正電機 了，目前是以 中正通訊 的身份，不過目前我休學狀態，還在服兵役當中，在南投 國史館台灣文獻館 底下工作。我是在入學 中正電機 研究所的第一個學期末就已經休學了，目前已經快退伍了。 <!--more--> 安裝環境： 

> 4.11-STABLE FreeBSD postfix-2.2.10_1 cyrus-sasl-2.1.22 RFC 2222 SASL (Simple Authentication and Security Layer) cyrus-sasl-saslauthd-2.1.22 SASL authentication server for cyrus-sasl2 首先安裝 postfix 

> \# cd /usr/ports/mail/postfix # make install clean [X] SASL2 Cyrus SASLv2 (Simple Authentication and Security Layer) [X] TLS SSL and TLS [X] DB41 Berkeley DB4.1 (required if SASL also built with DB4.1) 無論裝那套 postfix，若有選用 SASLv2 ，則會自動安裝 cyrus-sasl2。 如果這裡出現一些套件相依性的問題，例如：造成 mysql 問題，解決方法是分開裝 

> \# cd /usr/ports/security/cyrus-sasl2 # make install clean # cd /usr/ports/mail/postfix[-current]/ # make install clean 安裝好之後，請在 /etc/rc.conf 架上下面訊息 

> sendmail\_enable=&#8221;NONE&#8221; sendmail\_flags=&#8221;-bd&#8221; sendmail\_pidfile=&#8221;/var/spool/postfix/pid/master.pid&#8221; sendmail\_procname=&#8221;/usr/local/libexec/postfix/master&#8221; sendmail\_outbound\_enable=&#8221;NO&#8221; sendmail\_submit\_enable=&#8221;NO&#8221; sendmail\_msp\_queue_enable=&#8221;NO&#8221; 接著，請在 /etc/periodic.conf 中關閉 sendmail 原本每日預設的動作 請在 /etc/periodic.conf 中加入 (如果沒有這個檔案，請新增一個) 

> daily\_clean\_hoststat\_enable=&#8221;NO&#8221; daily\_status\_mail\_rejects\_enable=&#8221;NO&#8221; daily\_status\_include\_submit\_mailq=&#8221;NO&#8221; daily\_submit_queuerun=&#8221;NO&#8221; 接下來設定 postfix 的 main.cf 這段是重點，目前設定檔，我加了很多ordb的機制，可能會擋掉很多廣告信，也擋掉很多公司DNS沒進行反解的動作 1. /usr/local/etc/postfix/main.cf 每一行的第一個字為空白「空白鍵或者是tab鍵」的文字，都是代表上一行的延續，方便底下講解 2. 根據postfix的官方文件，在main.cf裡面所有的規則，只要是被先寫的，就會先被執行，所以順序變得很重要 3. 用戶端檢查郵件規則的順序如下： 1 → smtpd\_client\_restrictions 2 → smtpd\_helo\_restrictions [我沒用到] 3 → smtpd\_sender\_restrictions 4 → smtpd\_recipient\_restrictions 5 → smtpd\_data\_restrictions [我沒用到] 6 → header\_checks 7 → body\_checks 

> 先重第一個開始講 smtpd\_client\_restrictions # # 這是在確定 client端的ip跟domain「我設定如下」 # smtpd\_client\_restrictions =
> 
> permit\_mynetworks permit\_sasl\_authenticated check\_client\_access regexp:/usr/local/etc/postfix/client\_check reject\_rbl\_client dul.dnsbl.sorbs.net reject\_rbl\_client cbl.anti-spam.org.cn reject\_rbl\_client rbl.softworking.com reject\_rbl\_client or.ecenter.idv.tw reject\_rbl\_client dialup.ecenter.idv.tw reject\_rbl\_client spam.ecenter.idv.tw reject\_rbl\_client bl.spamcop.net reject\_rbl\_client sbl-xbl.spamhaus.org reject\_rbl\_client list.dsbl.org reject\_rbl\_client rbl.maps.vix.com reject\_rbl\_client dul.maps.vix.com reject\_rbl\_client relays.maps.vix.com reject\_rhsbl\_client dns.rfc-ignorant.org  再來是 smtpd\_sender\_restrictions # # 這是在偵測寄件人，也就是 mail from: appleboy@exapmle.com # smtpd\_sender\_restrictions = 
> 
> permit\_mynetworks, permit\_sasl\_authenticated, check\_sender\_access regexp:/usr/local/etc/postfix/sender\_check, reject\_unknown\_sender\_domain, reject\_unknown\_client, reject\_non\_fqdn\_sender 再來是 smtpd\_recipient\_restrictions # # 這是在偵測信件收件的限制規則，也就是 RCPT TO: appleboy@exapmle.com # smtpd\_recipient\_restrictions = 
> 
> permit\_mynetworks, permit\_sasl\_authenticated, check\_client\_access regexp:/usr/local/etc/postfix/client\_check, check\_sender\_access regexp:/usr/local/etc/postfix/sender\_check, reject\_unauth\_destination, reject\_non\_fqdn\_recipient, reject\_invalid\_hostname, reject\_non\_fqdn\_hostname, reject\_non\_fqdn\_sender, reject\_non\_fqdn\_recipient, reject\_unknown\_sender\_domain, reject\_unknown\_recipient\_domain, reject\_unauth_destination, # 在 mynetworks 這個項目設定的網域 IP 都可以被允許連線喔 permit\_mynetworks # 許可用sasl寄送 permit\_sasl\_authenticated # 非認證的來源不准寄送 reject\_unauth_destination 其實這樣上面的機制全部加到 main.cf 裡面的話，會擋掉很多不該擋的信件，所以這只能在自己玩的伺服氣上面這麼作，如果到大公司，則不能這樣，畢竟很多重要文件，不是說擋就可以擋掉，不然資訊部門，我想電話接到手軟，可能要用 SpamAssassin 過濾郵件，讓使用者可以自訂擋信規則，這樣會是比較好的 重點在下面這邊 

> check\_client\_access regexp:/usr/local/etc/postfix/client\_check, check\_sender\_access regexp:/usr/local/etc/postfix/sender\_check, 這兩行 可以設定不要擋掉的郵件伺服器，不然很多 ordb會勿擋掉一些重要的伺服器 

> \# # client_check # /\.dynamic\./ REJECT We can&#8217;t allow dynamic IP to relay! /.*\.indimodels.com/ REJECT We can&#8217;t allow indimodels IP to relay! 上面是擋掉所有利用 dynamic ip 架設伺服器，沒辦法，因為郵件太氾濫，所以擋掉比較好，就會在maillog擋裡面發現 

> Mar 15 23:16:05 alumni postfix/smtpd[47224]: NOQUEUE: reject: RCPT from 103.143.85.218.board.xm.fj.dynamic.163data.com.cn[218.85.143.103]: 554 <103.143.85.218.board.xm.fj.dynamic.163data.com.cn[218.85.143.103]>: Client host rejected: **We can&#8217;t allow dynamic IP to relay!**; from=<qbbbqzf.urmuwd@msa.hinet.net> to=<beetle@alumni.ee.ccu.edu.tw> proto=SMTP helo=<103.143.85.218.board.xm.fj.dynamic.163data.com.cn> Mar 13 23:27:43 alumni postfix/smtpd[19066]: NOQUEUE: reject: RCPT from dotwise.indimodels.com[74.52.182.2]: 554 <dotwise.indimodels.com[74.52.182.2]>: Client host rejected: **We can&#8217;t allow indimodels IP to relay!**; from=<xlmszxkpkgldmlsxnqvfr@ms18.hinet.net> to=<swuntoe@alumni.ee.ccu.edu.tw> proto=ESMTP helo=<dotwise.indimodels.com> 再來就是 sender_check 

> \# # PChome 廣告 # /edm[1-9].digitimes.com.tw/ DISCARD /ms[1-9]\.epaper\.com\.tw/ DISCARD PC HOME Spam /ms[a-z]\.epaper\.com\.tw/ DISCARD PC HOME Spam /ecfs[1-9]\.epaper\.com\.tw/ DISCARD PC HOME Spam /ecfs10\.epaper\.com\.tw/ DISCARD PC HOME Spam /ecfsrv\.epaper\.com\.tw/ DISCARD PC HOME Spam # # 天瓏資訊圖書 # /tenlong\.com\.tw/ OK /mail\.th\.gov\.tw/ OK #帶有 dynamic, dhcp 所發信主機或client 端皆拒收 /.\*dynamic\..\*/ DISCARD dynamic spam  這樣你會發現，天瓏網路書局 正反解沒有設定對 non_fqdn，所以造成信件被擋掉 

> Mar 15 21:57:22 alumni postfix/smtpd[46897]: NOQUEUE: discard: RCPT from msi.epaper.com.tw[211.20.188.88]: <edm@msx.epaper.com.tw>: **Sender address PC HOME Spam**; from=<edm@msx.epaper.com.tw> to=<beetle@alumni.ee.ccu.edu.tw> proto=ESMTP helo=<msi.epaper.com.tw> Mar 13 21:50:19 alumni postfix/smtpd[18777]: NOQUEUE: reject: RCPT from unknown[61.63.12.43]: 450 Client host rejected: **cannot find your hostname**, [61.63.12.43]; from=<ezbuy@tenlong.com.tw> to=<appleboy@alumni.ee.ccu.edu.tw> proto=ESMTP helo=<mail.tenlong.com.tw> Mar 12 21:02:08 alumni postfix/smtpd[78494]: NOQUEUE: reject: RCPT from unknown[163.29.208.5]: 450 Client host rejected: **cannot find your hostname**, [163.29.208.5]; from=<appleboy@mail.th.gov.tw> to=<appleboy@alumni.ee.ccu.edu.tw> proto=ESMTP helo=<mail.th.gov.tw> 所以才要設定 sender_check 讓 天瓏網路書局 通過檢測，pchome廣告信也可以全部擋掉 安裝 cyrus-sasl2-saslauthd 

> \# cd /usr/ports/security/cyrus-sasl2-saslauthd # make install clean  在 /usr/local/etc/postfix/main.cf 最後面加入 

> #//開啟 smtp 認證 smtpd\_sasl\_auth\_enable = yes #保持client端的相容性,例如MSOE4 broken\_sasl\_auth\_clients = yes #允許任何非匿名的使用者 smtpd\_sasl\_security\_options = noanonymous #sasl的本地網域 smtpd\_sasl\_local\_domain = $myhostname smtpd\_sasl\_application_name = smtpd 請注意這上面還沒設定好，如果你在maillog檔裡面發現 

> Mar 13 15:25:17 alumni postfix/smtpd[16523]: warning: SASL authentication failure: no user in db Mar 13 15:25:17 alumni postfix/smtpd[16523]: warning: SASL authentication failure: **no secret in database** Mar 13 15:25:17 alumni postfix/smtpd[16523]: warning: unknown[163.29.208.2]: **SASL NTLM authentication failed** Mar 13 15:25:23 alumni postfix/smtpd[16523]: warning: SASL authentication failure: no user in db Mar 13 15:25:23 alumni postfix/smtpd[16523]: warning: SASL authentication failure: no secret in database Mar 13 15:25:23 alumni postfix/smtpd[16523]: warning: unknown[163.29.208.2]: SASL NTLM authentication failed Mar 13 15:25:33 alumni postfix/smtpd[16523]: warning: SASL authentication failure: no user in db 這時你必須些改 /usr/local/lib/sasl2/smtpd.conf 

> (SASL version 2.1.1) pwcheck\_method: saslauthd mech\_list: PLAIN LOGIN #重新啟動 sasl /usr/local/etc/rc.d/saslauthd.sh restart 讓 Postfix 支援 TLS 請先製作憑證：參考網站：[製作憑證與建立安全連線][1] 上面網站的作法，測試過了ok，然後請在 /usr/local/etc/postfix/main.cf 加上 

> \# Enable TLS Connection smtpd\_tls\_cert\_file = /usr/local/etc/postfix/CA/HostCA.crt smtpd\_tls\_key\_file = /usr/local/etc/postfix/CA/HostCA.key smtpd\_use\_tls = yes smtpd\_tls\_session\_cache\_timeout = 3600s smtpd\_tls\_loglevel = 3 smtpd\_tls\_received\_header = yes tls\_random\_source = dev:/dev/urandom tls\_daemon\_random\_source = dev:/dev/urandom # smtpd\_tls\_auth\_only 是指僅當 postfix 提供 TLS的情形時，才允許 SMTP AUTH。 #以 outlook express 為例，當 smtpd\_tls\_auth\_only 開啟時，若在外寄郵件-SMTP中沒有勾選 SSL 的話，則會郵遞失敗，此功能強迫使用者必須在使用支援 TLS 的情形下，才給予認證通行。 #smtpd\_tls\_auth_only = yes  請注意下面這段log 

> Mar 13 15:23:03 alumni postfix/smtpd[16519]: warning: **SASL authentication failure**: no user in db Mar 13 15:23:03 alumni postfix/smtpd[16519]: warning: **SASL authentication failure**: no secret in database Mar 13 15:23:03 alumni postfix/smtpd[16519]: warning: unknown[163.29.208.2]: **SASL NTLM authentication failed** cyrus-sasl跟cyrus-sasl-saslauthd套件請麻煩安裝相同版本，如果沒有安裝相同版本，很容易發生錯誤 

> portupgrade cyrus-sasl-saslauthd-2.1.22 結論：相同版本才不會出現錯誤 自己 telnet 機器看看，如果吐出Ready to start TLS 就ok了 

> \[alumni\]\[root\][ ~ ]# telnet localhost 25 Trying 127.0.0.1&#8230; Connected to localhost. Escape character is &#8216;^]&#8217;. 220 alumni.ee.ccu.edu.tw ESMTP Postfix **ehlo localhost** 250-alumni.ee.ccu.edu.tw 250-PIPELINING 250-SIZE 10240000 250-ETRN 250-STARTTLS 250-AUTH LOGIN PLAIN 250-AUTH=LOGIN PLAIN 250 8BITMIME **STARTTLS** 220 Ready to start TLS 再來利用 Mozilla Thunderbird 來測試看看 [<img src="https://i1.wp.com/farm1.static.flickr.com/177/422091320_8f07039cf9.jpg?resize=500%2C349&#038;ssl=1" alt="TLS" data-recalc-dims="1" />][2] [<img src="https://i0.wp.com/farm1.static.flickr.com/151/422091353_793cbfc1a6_o.jpg?resize=349%2C373&#038;ssl=1" alt="mail_TLS" data-recalc-dims="1" />][3] 這樣認證就算成功了～ YA，底下附上 main.cf 設定檔給大家參考 [Postfix設定檔][4]{#p77}

 [1]: http://giayiu.twbbs.org/FreeBSD/
 [2]: https://www.flickr.com/photos/appleboy/422091320/ "Photo Sharing"
 [3]: https://www.flickr.com/photos/appleboy/422091353/ "Photo Sharing"
 [4]: http://blog.wu-boy.com/wp-content/uploads/2007/03/maincf.txt