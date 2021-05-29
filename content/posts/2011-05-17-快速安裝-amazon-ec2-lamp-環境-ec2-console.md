---
title: 快速安裝 Amazon EC2 LAMP 環境 (EC2 Console)
author: appleboy
type: post
date: 2011-05-17T11:07:05+00:00
url: /2011/05/快速安裝-amazon-ec2-lamp-環境-ec2-console/
views:
  - 836
bot_views:
  - 129
dsq_thread_id:
  - 305940634
categories:
  - Linux
  - www
tags:
  - Amazon
  - Linux

---
已經紅了一陣子的 [Amazon 雲端服務][1]，本篇來介紹如何使用 [Amazon EC2][2] Linux 安裝 LAMP (Linux Apache MySQL PHP) 環境，衝著 Amazon 推出的新玩家註冊開始為期**<span style="color:red">一年的免費</span>**，當然也是有一些限制條件，可以參考 [EC 2 收費標準及介紹][3]，底下這圖片就是一年內免費的方案，其實對於剛學習 Linux 的玩家而言相當足夠。 [<img src="https://i0.wp.com/farm6.static.flickr.com/5128/5729812694_77b4940d79.jpg?resize=500%2C288&#038;ssl=1" alt="AWS Free Usage Tier" data-recalc-dims="1" />][4] 如何設定及註冊 Amazon EC2 可以參考底下連結教學： [什麼是雲端服務？阿正老師教你免費玩Amazon EC2雲端主機！(上篇)][5] [阿正老師教你免費玩Amazon EC2雲端主機(下篇)：主機實戰篇][6] 看完這兩篇大概對於 Amazon 有一定程度的瞭解，接下來就是如何進入玩家們所安裝好的 Amazon Linux 主機，由於 EC 2 的服務主機會常常自動更新 IP，剛開始可以到 Console 看到底下 public DNS: [<img src="https://i0.wp.com/farm6.static.flickr.com/5190/5729910002_489d759885.jpg?resize=500%2C196&#038;ssl=1" alt="AWS Management Console" data-recalc-dims="1" />][7] 不過這 DNS IP 都會常常更新，所以剛開始都要常常來這邊看，玩家們可以用剛剛註冊此機器的 mykey.pem 透過 ssh 的方式登入機器，底下是在 Ubuntu 的操作 

<pre class="brush: bash; title: ; notranslate" title="">1. 先設定檔案權限，請將檔案權限改成 400
chmod 400 mykey.pem
2. 透過 ssh 軟體 pietty (上面阿正老師連結有教學)或 Linux ssh 指令
ssh -i mykey.pem ec2-user@ec2-XXXXXX.compute-1.amazonaws.com
</pre> 進去主機之後就是一般的 Linux 操作，可以參考 

[鳥哥的Linux 私房菜][8]，當然我想玩家們都會發現一直透過 mykey.pem 登入會有點麻煩，而且假設 pem 檔案消失，又要去 Console 申請一次，所以底下教大家如何不必透過 mykey.pem 方式登入，其實也很容易，就是修改 <span style="color:green"><strong>/etc/ssh/sshd_config</strong></span>。 

<pre class="brush: bash; title: ; notranslate" title="">1. 打開 /etc/ssh/sshd_config 找到 PasswordAuthentication
PasswordAuthentication no
改成
PasswordAuthentication yes
2. 存檔後，重新啟動 sshd
/etc/init.d/sshd restart
</pre> 上述設定完成之後，就可以直接透過 ssh -l ec2-user xxx.xxx.xxx.xxx 的方式來遠端 Linux 主機，透過 yum 繼續安裝 Apache + MySQL + PHP，方法如下： 

<pre class="brush: bash; title: ; notranslate" title="">yum groupinstall "Web Server"
yum groupinstall "MySQL Database"</pre> 最後請參考計算 

[Amazon 每個月所需費用][9]，不要傷了自己的荷包 XD，Micro Instance 的方案規格就很足夠我用 

> 613 MB memory Up to 2 EC2 Compute Units (for short periodic bursts) EBS storage only 32-bit or 64-bit platform I/O Performance: Low API name: t1.micro
### 申請 Elastic IP 補充如何申請固定IP跟 EC2 結合，其實蠻容易的，看下面這張圖 

[<img src="https://i2.wp.com/farm4.static.flickr.com/3618/5732378698_a86e255162.jpg?resize=500%2C281&#038;ssl=1" alt="AWS Management Console 2" data-recalc-dims="1" />][10] 大家申請 IP 之後，請記得跟 EC2 做結合的動作，如果申請放著不用，這樣會被收費喔

 [1]: http://aws.amazon.com
 [2]: http://aws.amazon.com/ec2/
 [3]: http://aws.amazon.com/ec2/pricing/
 [4]: https://www.flickr.com/photos/appleboy/5729812694/ "AWS Free Usage Tier by appleboy46, on Flickr"
 [5]: http://blog.soft.idv.tw/?p=823
 [6]: http://blog.soft.idv.tw/?p=824
 [7]: https://www.flickr.com/photos/appleboy/5729910002/ "AWS Management Console by appleboy46, on Flickr"
 [8]: http://linux.vbird.org/
 [9]: http://calculator.s3.amazonaws.com/calc5.html
 [10]: https://www.flickr.com/photos/appleboy/5732378698/ "AWS Management Console 2 by appleboy46, on Flickr"