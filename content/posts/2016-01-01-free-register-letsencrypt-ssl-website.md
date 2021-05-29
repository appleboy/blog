---
title: 免費幫您申請 Letsencrypt 憑證網站
author: appleboy
type: post
date: 2016-01-01T05:14:11+00:00
url: /2016/01/free-register-letsencrypt-ssl-website/
dsq_thread_id:
  - 4451198662
categories:
  - Linux
  - SSL
tags:
  - Letsencrypt
  - SSL

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23840721545/in/dateposted-public/" title="Letsencrypt"><img src="https://i1.wp.com/farm6.staticflickr.com/5803/23840721545_e0350b687f.jpg?w=300&#038;ssl=1" alt="Letsencrypt" data-recalc-dims="1" /></a>

自從 2015/12 [Letsencrypt][1] 開放[免費申請 SSL 憑證的消息][2]，馬上有人[開發出網站][3]，讓不會使用 Letsencrypt 指令的網站管理者免費申請憑證，此網站透過開發者提過 FTP 帳號密碼或下載檔案放到 Web 根目錄就可以執行認證成功，完成後會給你 SSL Certificate，這邊有些問題，就是 Private key 也一起給你了，所以用這網站請務必小心，雖然該作者說明，網站不會存下任何憑證資料，但是你相信他嗎？Letsencrypt 討論區有[一篇討論關於此網站][4]的做法，引起很大的爭議。底下是該網站提供兩種認證方式

<!--more-->

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/23801921310/in/datetaken-public/" title="Screen Shot 2016-01-01 at 12.53.57 PM"><img src="https://i2.wp.com/farm2.staticflickr.com/1569/23801921310_d1d1cb9d39_z.jpg?resize=640%2C307&#038;ssl=1" alt="Screen Shot 2016-01-01 at 12.53.57 PM" data-recalc-dims="1" /></a>

如果不信任此網站，官網上面有提供超多語言的[工具及 library][5]，開發者只要有一點點 Linux 基礎，就可以申請完成，其實真的不建議透過上面網站來申請，如果是自己網站就算了，營運網站的話就不要使用了啦。

 [1]: https://letsencrypt.org/
 [2]: https://blog.wu-boy.com/2015/12/letsencrypt-entering-public-beta-free-ssl/
 [3]: https://www.sslforfree.com/
 [4]: https://community.letsencrypt.org/t/easiest-way-to-use-lets-encrypt/7633/2
 [5]: https://community.letsencrypt.org/t/list-of-client-implementations/2103