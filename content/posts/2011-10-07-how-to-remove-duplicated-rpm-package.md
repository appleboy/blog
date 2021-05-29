---
title: AWS 機器上 duplicated RPM 問題
author: appleboy
type: post
date: 2011-10-07T05:28:45+00:00
url: /2011/10/how-to-remove-duplicated-rpm-package/
dsq_thread_id:
  - 436506094
categories:
  - Linux
tags:
  - AWS
  - Fedora
  - Linux

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/6219253012/" title="AWS-logo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm7.static.flickr.com/6174/6219253012_f5f9a7ed0c.jpg?resize=270%2C110&#038;ssl=1" alt="AWS-logo" data-recalc-dims="1" /></a>
</div> 昨天幫忙升級全部 

<a href="http://aws.amazon.com/" target="_blank">AWS</a> RPM 套件，升級過程本來很順利，不過不知道哪一個 RPM 造成 SSH 全面斷線，接著我直接到 <a href="http://aws.amazon.com/console/" target="_blank">AWS Management Console</a> 把機器 restart，登入系統之後下 yum update，直接給我噴出底下錯誤訊息 

<pre class="brush: plain; title: ; notranslate" title="">---> Package zlib.i686 0:1.2.3-24.7.amzn1 will be updated
---> Package zlib.i686 0:1.2.3-25.8.amzn1 will be an update
--> Finished Dependency Resolution
 You could try using --skip-broken to work around the problem
** Found 155 pre-existing rpmdb problem(s), 'yum check' output follows:
audit-libs-2.1-5.15.amzn1.x86_64 is a duplicate with audit-libs-2.0.4-1.14.amzn1.x86_64
authconfig-6.1.12-5.14.amzn1.x86_64 is a duplicate with authconfig-6.1.4-6.13.amzn1.x86_64
basesystem-10.0-4.9.amzn1.noarch is a duplicate with basesystem-10.0-4.8.amzn1.noarch
bash-4.1.2-8.14.amzn1.x86_64 is a duplicate with bash-4.1.2-3.13.amzn1.x86_64
binutils-2.20.51.0.2-5.20.17.amzn1.x86_64 is a duplicate with binutils-2.20.51.0.2-5.12.15.amzn1.x86_64
cloud-init-0.5.15-16.amzn1.noarch is a duplicate with cloud-init-0.5.15-8.amzn1.noarch
coreutils-8.4-13.13.amzn1.x86_64 is a duplicate with coreutils-8.4-9.12.amzn1.x86_64
coreutils-libs-8.4-13.13.amzn1.x86_64 is a duplicate with coreutils-libs-8.4-9.12.amzn1.x86_64
cpp-4.4.5-6.35.amzn1.x86_64 is a duplicate with cpp-4.4.4-13.33.amzn1.x86_64
</pre>

<!--more--> 看到上面問題其實也不用訝異，因為就是升級過程如果遇到重新開機，就會變成這樣，那該如何修復這些套件呢，想當然就是要移除 duplicate 的套件，網路上在 

<a href="http://forums.fedoraforum.org/" target="_blank">Frodra Forum</a> 找到一篇解法 <a href="http://forums.fedoraforum.org/showthread.php?t=52758" target="_blank">HOWTO: Remove older duplicated RPMs automatically</a>，請按照底下方式來解決此問題: 

<pre class="brush: bash; title: ; notranslate" title=""># 首先安裝 yum-utils 套件
yum install yum-utils
# 執行 clean duplicate package
package-cleanup --cleandupes</pre> 執行完上面步驟，在接著把沒有安裝的 RPM 繼續安裝，透過 

**<span style="color:green">yum update</span>** 即可。