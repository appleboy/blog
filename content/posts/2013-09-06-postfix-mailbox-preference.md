---
title: Postfix mailbox 設定
author: appleboy
type: post
date: 2013-09-06T11:39:58+00:00
url: /2013/09/postfix-mailbox-preference/
dsq_thread_id:
  - 1722717086
categories:
  - Linux
  - Ubuntu
tags:
  - mail
  - Postfix

---
[<img src="https://i0.wp.com/farm3.staticflickr.com/2817/9683449971_5fc991dd0c_z.jpg?resize=545%2C289&#038;ssl=1" alt="Postfix_logo" data-recalc-dims="1" />][1] 此篇不會講太多 <a href="http://www.postfix.org/" target="_blank">Postfix</a> 的設定，只是紀錄如何設定 Postfix mailbox。Postfix 提供兩種 E-mail 儲存格式，一種就是將全部的 mail 都寫到同一個檔案，此方式是 Postfix 裝好後預設的模式，另外的就是一封 E-mail 一個檔案，這兩者各有優缺點好壞，前者最大的問題就在於如果該檔案壞掉，那使用者的全部 Email 就消失了，所以個人比較偏好後面方式，最主要最近裝按要實做 E-mail Queue 功能，後者才能讓程式好判斷該目錄是否有異動。 

### Mailbox 如果都不修改任何設定預設裝好 Postfix，就可以看到 /var/spool/mail/ 目錄下有許多使用者檔案，一個使用者一個檔案，當然你也可以將使檔案設定在家目錄裡面。打開 /etc/postfix/main.cf 設定檔，並加入底下設定 

<pre class="brush: bash; title: ; notranslate" title="">home_mailbox = Mailbox</pre> 此設定會將原本放在 /var/spool/mail/ 目錄下的檔案都換成 /home/appleboy/Mailbox，注意在 bashrc 請加入 

<pre class="brush: bash; title: ; notranslate" title="">$ export MAIL=~/Mailbox</pre>

### Maildir 如果改成此設定，就會變成一個檔案代表一封 email，請在 

<span style="color:green">/etc/postfix/main.cf</span> 加入底下設定 

<pre class="brush: bash; title: ; notranslate" title="">home_mailbox = Maildir/</pre> 接著取消 MAIL 變數 

<pre class="brush: bash; title: ; notranslate" title="">$ unset MAIL</pre> 最後寫入新的變數內容 

<pre class="brush: bash; title: ; notranslate" title="">$ export MAILDIR=~/Maildir</pre> 重新啟動 postfix 

<pre class="brush: bash; title: ; notranslate" title="">$ /etc/init.d/postfix restart</pre> 寄封信測試看看目錄是否有建立: 

<pre class="brush: bash; title: ; notranslate" title="">$ echo "This is the message body" | mail -s "This is the subject" root@localhost</pre> 這時你會發現在自己的 Home 目錄底下多出了 

<span style="color:red">Maildir/tmp</span>, <span style="color:red">Maildir/cur</span>, <span style="color:red">Maildir/new</span> 等三個目錄，代表設定成功了

 [1]: https://www.flickr.com/photos/appleboy/9683449971/ "Postfix_logo by appleboy46, on Flickr"