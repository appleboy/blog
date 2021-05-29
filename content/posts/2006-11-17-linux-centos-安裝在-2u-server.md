---
title: '[Linux] CentOS 安裝在 2u server'
author: appleboy
type: post
date: 2006-11-17T10:50:20+00:00
url: /2006/11/linux-centos-安裝在-2u-server/
bot_views:
  - 567
views:
  - 1907
dsq_thread_id:
  - 247451738
categories:
  - life
  - Linux
tags:
  - Linux

---
最近館內買了一台2u的伺服器，雙cpu AMD，底下圖片上面那台，下面那台是後端的圖片資料庫 

<div style="width: 500px; text-align: right">
  <a title="Zooomr Photo Sharing :: Photo Sharing" href="http://beta.zooomr.com/photos/23204@Z01/415115/"><img border="0" style="border: 1px solid #000000" alt="DSCF0070" src="https://i0.wp.com/static.zooomr.com/images/415115_4a1a1a6c14.jpg?resize=500%2C375" data-recalc-dims="1" /></a><span style="float: left">DSCF0070</span> Hosted on <strong>Zooom<span style="color: #9eae15">r</span></strong>
</div> processor : 1 vendor_id : AuthenticAMD cpu family : 15 model : 37 model name : AMD Opteron(tm) Processor 248 stepping : 1 cpu MHz : 2193.217 cache size : 1024 KB MemTotal: 2055132 kB 2顆，不過重點不是這個，重點這台機器我搞了1個星期 就是因為抓不到scsi介面卡，打電話給客服，好像機器不是他們裝的 原本機器送過裝好suse 9.0 enterorise server，可是我不喜歡suse，還可以安裝桌面 一堆有的沒有程式，所以我只好砍掉自己系統重做，不過原本想用freebsd 6.1 release 也沒辦法 外接卡不支援freebsd 那就別安裝了，根本抓不到硬碟，最後上網找driver，終於找到for fc centos 想說沒玩過centOS 4.4 就裝來玩看看 , 順便動手切了LVM 

<div style="width: 500px; text-align: right">
  <a title="Zooomr Photo Sharing :: Photo Sharing" href="http://beta.zooomr.com/photos/23204@Z01/415116/"><img border="0" style="border: 1px solid #000000" alt="DSCF0075" src="https://i0.wp.com/static.zooomr.com/images/415116_5657d082fa.jpg?resize=500%2C375" data-recalc-dims="1" /></a><span style="float: left">DSCF0075</span> Hosted on <strong>Zooom<span style="color: #9eae15">r</span></strong>
</div> 安裝好之後機器大概就ok了，沒什麼問題 這台機器，是在 

<font size="2" face="新細明體" color="black"><span style="font-size: 10pt; color: black"><a title="http://www.jcnetcorp.com" href="http://www.jcnetcorp.com">捷洲資訊股份有限公司</a><span lang="EN-US" /></span></font> <font size="2" face="新細明體" color="black"><span style="font-size: 10pt; color: black">台中分公司<span lang="EN-US"> </span>台中市南屯區大英街<span lang="EN-US">636</span>號<span lang="EN-US" /></span></font> <font size="2" face="新細明體" color="black"><span lang="EN-US" style="font-size: 10pt; color: black">Web Site : <a target="_blank" onclick="return top.js.OpenExtLink(window,event,this)" href="http://www.jcnetcorp.com/">http://www.jcnetcorp.com</a></span></font> 


	<span id="ctl00_cphBody_FormView1_HTMLLabel" class="Support_ServiceRule_ContentText"> 

<li>
  基本保固服務內容：
</li>
<ol>
  <li>
    主要以本公司自有品牌或所代理之品牌機器為主，其它經銷品牌以各品牌自有保固維修條款而定。
  </li>
  <li>
    整機（包含零配件）含基本到府服務（5 × 8 × 8），空機則不含到府服務。
  </li>
</ol></span>

[http://www.jcnetcorp.com/v2cht/Support/ServiceRule.aspx][1] 我想隨時都可以找他們過來支援吧，不過這不是我想要的，能自己解決就自己解決

 [1]: http://www.jcnetcorp.com/v2cht/Support/ServiceRule.aspx "http://www.jcnetcorp.com/v2cht/Support/ServiceRule.aspx"