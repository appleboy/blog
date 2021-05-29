---
title: '[筆記] ssh Tunnel 運用在 Linux and Windows FireFox'
author: appleboy
type: post
date: 2008-03-19T05:11:34+00:00
url: /2008/03/筆記-ssh-tunnel-運用在-linux-and-windows/
views:
  - 12821
bot_views:
  - 876
dsq_thread_id:
  - 246790358
categories:
  - FreeBSD
  - Linux
  - windows
tags:
  - FreeBSD
  - Linux
  - SSH

---
今天在看 [gslin][1] 部落格的一篇文章：[穿越公司的 FireWall][2]，看完之後我覺得相當不錯，可以解決我想要的 forwarding 的問題，以及繞過防火牆的機制，剛剛自己測試一下，發現還蠻好用的，其實利用這個方式還可以遠端管理很多伺服器，如：[Mysql][3] 伺服器&#8230;. SSH Tunnel必須建立於一個SSH連線上，它可以讓我們穿透防火牆，建立一個安全加密的傳輸。 例如：我們現在要透過 A主機去對 smtp 或者是 http 做連接的動作，那我們就必須先建立一個到A主機的SSH連線，然後在透過它建立 Tunnel 我們會使用到的putty和plink都可以在 [這裡下載][4]， 不過我更喜歡[pietty][5]，由[piaip][6]長輩製作。 <!--more--> 底下是實際的例子: 實戰一: 1.假設我們現在要透過主機A利用 ftp 的方式連到 

[中正大學檔案伺服器][7]，那我們就利用下面辦法 首先我們先開啟 pietty，然後連到主機A [<img src="https://i1.wp.com/farm3.static.flickr.com/2109/2345022854_bc90ca0181_o.jpg?resize=421%2C298&#038;ssl=1" alt="SSH_01" data-recalc-dims="1" />][8] 2. 輸入登入的帳號密碼 [<img src="https://i2.wp.com/farm3.static.flickr.com/2002/2345022812_b87cd566b4.jpg?resize=500%2C387&#038;ssl=1" alt="SSH_02" data-recalc-dims="1" />][9] 3.登入之後，在工具列上的這個putty視窗按右鍵選擇Change Settings，然後選 Tunnel [<img src="https://i1.wp.com/farm3.static.flickr.com/2041/2344192629_96e3cf67da_o.jpg?resize=456%2C435&#038;ssl=1" alt="SSH_03" data-recalc-dims="1" />][10] 4. 填入如下： 第一個 souce ports 就是你 local 端要連接的 ports，destinations 就是你要填你要前往的地方那這部份我們就填 ftp.ccu.edu.tw:21 後面接 ports [<img src="https://i0.wp.com/farm3.static.flickr.com/2322/2345022956_19051effe3_o.jpg?resize=456%2C435&#038;ssl=1" alt="SSH_04" data-recalc-dims="1" />][11] 然後再按旁邊的 Add 就好了 [<img src="https://i1.wp.com/farm3.static.flickr.com/2405/2345022988_e42a9c7d75_o.jpg?resize=456%2C435&#038;ssl=1" alt="SSH_05" data-recalc-dims="1" />][12] 5.然後最後按下面的 apply，就可以使用了喔 實戰二：使用plink從win32平台至某主機A, 並透過主機A連線至主機B的port 80 (httpd) plink是putty作者提供，在win32下的命令列程式， 可以讓我們打一行指令就可以進行SSH Tunnel連線。 

> 1. 把plink放到windows資料夾裡面(為了方便) 2. 在命令列字元打：plink -ssh -L 9000:hostB.narahuang.com:80 user@hostA.narahuang.com，如果 ssh Port 不是22，那就要加-p參數 3. 在輸入user在hostA的密碼之後，就進到hostA的Shell，這時候通到hostB的SSH Tunnel就完成了。 使用瀏覽器連線 http://localhost:9000/ ，若是可以連線到主機B就是成功了。 但是要注意的是，這段連線中安全的部分只有從local到hostA，從hostA到hostB這段是沒有加密的。 實戰三：從Unix-like的Shell開啟SSH Tunnel至hostB的POP3 port $ssh -N -f -L 9000:hostB.narahuang.com:21 user@hostB.narahuang.com -N 參數的用途是&#8221;不建立shell&#8221; -f 參數的用途是&#8221;連線後執行於背景&#8221; 輸入完密碼後即會回到原來的shell，建立Tunnel之後的操作就跟前面差不多了。 另外可以在 FireFox 裡面可以設定走 ssh tunnel 出去，設定方式如下： 先設定 SSH 部份 [<img src="https://i0.wp.com/farm4.static.flickr.com/3025/2416463290_4048b64f31.jpg?resize=456%2C435&#038;ssl=1" title="ssh_tunnel_03 (by appleboy46tream)" alt="ssh_tunnel_03 (by appleboy46tream)" data-recalc-dims="1" />][13] Source 打自己想要的 port，destination 不要打，然後下面勾選 dynamic FireFox 部份： [<img src="https://i2.wp.com/farm4.static.flickr.com/3115/2416463234_58c75b0cfa.jpg?resize=469%2C454&#038;ssl=1" title="ssh_tunnel_01 (by appleboy46)" alt="ssh_tunnel_01 (by appleboy46)" data-recalc-dims="1" />][14] [<img src="https://i0.wp.com/farm3.static.flickr.com/2147/2415642407_f11f9db991.jpg?resize=414%2C457&#038;ssl=1" title="ssh_tunnel_02 (by appleboy46)" alt="ssh_tunnel_02 (by appleboy46)" data-recalc-dims="1" />][15] 打入 localhost port 打你剛剛打的，然後走 socks v5 參考資料： [gslin長輩的 Firefox over SSH Tunnel][16] [gslin長輩的 穿越公司的Firewall][2] [sth-SSH Tunnel][17] [FreeBSD Handbook &#8211; OpenSSH][18] [SSH Tunnel][19]

 [1]: http://blog.gslin.org/
 [2]: http://blog.gslin.org/archives/2005/08/17/43/
 [3]: http://www.mysql.com/
 [4]: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
 [5]: http://www.csie.ntu.edu.tw/~piaip/pietty/
 [6]: http://www.csie.ntu.edu.tw/~piaip/
 [7]: http://ftp.ccu.edu.tw/
 [8]: https://www.flickr.com/photos/appleboy/2345022854/ "SSH_01 by appleboy46, on Flickr"
 [9]: https://www.flickr.com/photos/appleboy/2345022812/ "SSH_02 by appleboy46, on Flickr"
 [10]: https://www.flickr.com/photos/appleboy/2344192629/ "SSH_03 by appleboy46, on Flickr"
 [11]: https://www.flickr.com/photos/appleboy/2345022956/ "SSH_04 by appleboy46, on Flickr"
 [12]: https://www.flickr.com/photos/appleboy/2345022988/ "SSH_05 by appleboy46, on Flickr"
 [13]: https://www.flickr.com/photos/appleboy/2416463290/ "ssh_tunnel_03 (by appleboy46tream)"
 [14]: https://www.flickr.com/photos/appleboy/2416463234/ "ssh_tunnel_01 (by appleboy46)"
 [15]: https://www.flickr.com/photos/appleboy/2415642407/ "ssh_tunnel_02 (by appleboy46)"
 [16]: http://blog.gslin.org/archives/2008/03/18/1451/
 [17]: http://stefan.huberdoc.at/comp/info/ssh_tunnel.html
 [18]: http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/fs-acl.html
 [19]: http://plog.longwin.com.tw/post/1/163