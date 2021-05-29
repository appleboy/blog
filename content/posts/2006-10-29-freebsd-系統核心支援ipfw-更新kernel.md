---
title: '[FreeBSD] 系統核心支援ipfw 更新kernel'
author: appleboy
type: post
date: 2006-10-28T17:52:18+00:00
url: /2006/10/freebsd-系統核心支援ipfw-更新kernel/
bot_views:
  - 651
views:
  - 2642
dsq_thread_id:
  - 254314880
categories:
  - FreeBSD
tags:
  - FreeBSD
  - ipfw

---
系統預設是不能使用 ipfw 指令，因為系統核心不支援，要使系統支援 ipfw，則需要修改核心  
  


> cd /usr/src/sys/i386/conf  
> vi GENERIC  
>  
#在最後面加入  
  


> options IPFIREWALL  
> options IPFIREWALL\_DEFAULT\_TO_ACCEPT  
> options IPFIREWALL_VERBOSE  
> options IPFIREWALL\_VERBOSE\_LIMIT=10  
> options IPDIVERT  
> #然後存檔  
> config GENERIC  
> cd ../compile/GENERIC/  
> make cleandepend; make depend;  
> make depend all install  
>  
編譯好沒有錯誤之後，就可以重新開機 <font color="#ff0000">ipfw list 65535 allow ip from any to any</font> 看到上面訊息，就是成功 我在自己的論壇寫過一遍  
  
[http://www.forum.wu-boy.com/t=10210][1]  
[http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/firewalls-ipfw.html][2]  
[http://freebsd.lab.mlc.edu.tw/natd/][3]

 [1]: http://www.forum.wu-boy.com/t=10210 "http://www.forum.wu-boy.com/t=10210"
 [2]: http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/firewalls-ipfw.html "http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/firewalls-ipfw.html"
 [3]: http://freebsd.lab.mlc.edu.tw/natd/ "http://freebsd.lab.mlc.edu.tw/natd/ "