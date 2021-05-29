---
title: Windows 下安裝 sshfs
author: appleboy
type: post
date: 2012-09-26T08:57:10+00:00
url: /2012/09/sshfs-filesystem-for-windows/
dsq_thread_id:
  - 859854322
categories:
  - windows
tags:
  - sshfs
  - windows

---
遠端寫程式最方便的就是架個 FTP，並且用支援 FTP 模式的編輯器開始編輯，個人推薦 Windows 底下用 <a href="http://www.pspad.com/" target="_blank">PSPad</a> 或 <a href="http://www.sublimetext.com/" target="_blank">Sublime</a>，另外一種方式就是透過 <a href="http://fuse.sourceforge.net/sshfs.html" target="_blank">sshfs</a> 將 Linux 的硬碟 mount 到自己的系統，如果是 <a href="http://www.ubuntu.com/" target="_blank">Ubuntu</a> 就很簡單，可以參考我以前寫的<a href="http://blog.wu-boy.com/2011/07/linux-geany-fuse/" target="_blank">教學</a>，那 Windows 呢，可以透過 <a href="http://code.google.com/p/win-sshfs/" target="_blank">Google win-sshfs project</a>，把 <a href="http://dokan-dev.net/wp-content/uploads/DokanInstall_0.6.0.exe" target="_blank">Dokan Library 0.6.0</a> 跟<a href="http://win-sshfs.googlecode.com/files/win-sshfs-0.0.1.5-setup.exe" target="_blank">主程式 win-sshfs</a> 安裝好就可以用了。比較需要注意的是，如果 Server 是 <a href="http://www.freebsd.org" target="_blank">FreeBSD</a>，那需要而外設定 **<span style="color:green">/etc/ssh/sshd_config</span>** 

<pre class="brush: bash; title: ; notranslate" title="">PasswordAuthentication yes</pre>