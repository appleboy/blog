---
title: '[Apache] mod_bw 頻寬下載限制'
author: appleboy
type: post
date: 2007-08-20T08:06:34+00:00
url: /2007/08/apache-mod_bw-頻寬下載限制/
views:
  - 5189
bot_views:
  - 1114
dsq_thread_id:
  - 249266794
categories:
  - apache
  - FreeBSD
  - Linux
  - www

---
自己在站內有寫一篇 [[apache] mod_cband 頻寬限制][1]，不過這套好像沒有真對網站用 header「[[PHP] header下載檔案 搭配資料庫][2]」 吐出來的下載方式做限制，只能針對單存下載的連結做限制，所以自己爬文了一下，又找到了 Bandwidth Module 這個套件，[Banwidth官方網][3]，目前出到 mod_bw v0.8 [說明檔][4]。 底下是針對 FreeBSD 安裝方式，所以其他安裝方法就參考上面的說明檔了 

<pre class="brush: bash; title: ; notranslate" title="">cd /usr/ports/www/mod_bw/
make install clean
</pre> 上面這樣就安裝好了，再來就是設定 mod_bw 了 

  * BandWidthModule [On|Off]  apaceh 預設是關閉的，所以請把他打開 BandWidthModule on 

  * ForceBandWidthModule [On|Off]  這個設定預設情形，他不會對每個要求限制，如果你把他打開，他就會對每個要求做限制 普通要求：AddOutputFilterByType MOD_BW text/html text/plain 打開設定：ForceBandWidthModule On 

  * BandWidth \[From\] \[bytes/s\]  這個設定有2個參數，第一是from，第二是速度，第一你可以用整個ip位址，或者是network mask例如：192.168.0.0/24 or 192.168.0.0/255.255.255.0) or all。最後的all就是全部皆可，不限制 BandWidth localhost 10240 BandWidth 192.168.218.5 0 上面針對 localhost 給 10KB的速度，然後針對 192.168.218.5 不限制速度 在版本0.8還可以針對client端的瀏覽器做限制 

  * BandWidth u:\[User-Agent\] \[bytes/s\]  你可以利用正規語法比對client端瀏覽器 BandWidth "u:^Mozilla/5(.*)" 10240 BandWidth "u:wget" 102400 還蠻不錯的功能 

  * MinBandWidth \[From\] \[bytes/s\]  BandWidth all 102400 MinBandWidth all 50000 The example above, will have a top speed of 100kb for the 1º client. If more clients come, it will be splitted accordingly but everyone will have at least 50kb (even if you have 50 clients) BandWidth all 50000 MinBandWidth all -1 上面這個例子是保證client端下載速度保證 50KB/s 

  * LargeFileLimit \[Type\] \[Minimum Size\] [bytes/s]  這個專門是用來限制大型檔案，譬如說影音檔 avi wmv 之類的 還蠻好用的喔 LargeFileLimit .avi 500 10240 上面是說如果 avi檔案超過500KB 就限制速度在 10KB 

  * BandWidthPacket [Size]  這個不用理他，不要隨便調整他 

  * BandWidthError [Error]  這是錯誤訊息導向，比如說超過限制，你可以寫個html檔然後導向那邊 ErrorDocument 510 /errors/maxconexceeded.html BandWidthError 510 

  * MaxConnection \[From\] \[Max\]  限制連線數目，這個還蠻好用的 限制所有連線速度無限，但是只能有20條連線 BandWidth all 0 MaxConnection all 20 限制無限制ip速度無限，連線數20，然後網域192.168.0.0/24的速度 10KB，連線數目5 BandWidth all 0 BandWidth 192.168.0.0/24 10240 MaxConnection all 20 MaxConnection 192.168.0.0/24 5 然後在舉一些官方的例子 Limit every user to a max of 10Kb/s on a vhost : <Virtualhost *> BandwidthModule On ForceBandWidthModule On Bandwidth all 10240 MinBandwidth all -1 Servername www.example.com </Virtualhost> Limit al internal users (lan) to 1000 kb/s with a minimum of 50kb/s , and files greater than 500kb to 50kb/s. <Virtualhost \*> BandwidthModule On ForceBandWidthModule On Bandwidth all 1024000 MinBandwidth all 50000 LargeFileLimit \* 500 50000 Servername www.example.com </Virtualhost> 限制 avi 跟 mpg 速度 20kb/s. <Virtualhost *> BandwidthModule On ForceBandWidthModule On LargeFileLimit .avi 1 20000 LargeFileLimit .mpg 1 20000 Servername www.example.com </Virtualhost> Using it the &#8220;right&#8221; way, with output filter by mime type (for text) to 5kb/s: <Virtualhost *> BandwidthModule On AddOutputFilterByType MOD_BW text/html text/plain Bandwidth all 5000 Servername www.example.com </Virtualhost>

 [1]: http://blog.wu-boy.com/2007/01/22/64/
 [2]: http://blog.wu-boy.com/2007/05/25/106/
 [3]: http://www.ivn.cl/apache/
 [4]: http://www.ivn.cl/apache/files/txt/mod_bw-0.8.txt