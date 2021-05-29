---
title: 解決在 Ubuntu 系統下 Chrome 瀏覽器亂碼
author: appleboy
type: post
date: 2014-12-10T14:58:59+00:00
url: /2014/12/chrome-unreadable-character-on-ubuntu/
dsq_thread_id:
  - 3309716075
categories:
  - Browser
  - Chrome
  - Ubuntu
tags:
  - Chrome
  - Google Chrome
  - Ubuntu

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/15964998676" title="Screenshot from 2014-12-10 22:15:27 by Bo-Yi Wu, on Flickr"><img src="https://i2.wp.com/farm9.staticflickr.com/8629/15964998676_ff1bda70b2_z.jpg?resize=640%2C360&#038;ssl=1" alt="Screenshot from 2014-12-10 22:15:27" data-recalc-dims="1" /></a>
</div>

在 [Ubuntu][1] 用 [Chrome][2] 瀏覽器一陣子後，突然發現全部的中文介面都變成亂碼，就像上面這張截圖一樣，除了網頁可以正常顯示外，其他像是 Tab 或書籤都變成亂碼，在百度找到[這篇解答][3]，解決方式很容易，但是就是不知道原因為什麼這樣改就可以，底下紀錄如何解決此問題。

<!--more-->

打開 `/etc/fonts/conf.d/49-sansserif.conf` 可以看到底下內容

<div>
  <pre class="brush: xml; title: ; notranslate" title=""><?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<!--
  If the font still has no generic name, add sans-serif
 -->
        <match target="pattern">
                <test qual="all" name="family" compare="not_eq">
                        <string>sans-serif</string>
                </test>
                <test qual="all" name="family" compare="not_eq">
                        <string>serif</string>
                </test>
                <test qual="all" name="family" compare="not_eq">
                        <string>monospace</string>
                </test>
                <edit name="family" mode="append_last">
                        <string>sans-serif</string>
                </edit>
        </match>
</fontconfig>
</pre>
</div>

找到倒數第四行的 `sans-serif` 換成 `ubuntu` 字串，關閉瀏覽器重新開啟即可。

 [1]: http://www.ubuntu.com/
 [2]: https://www.google.com.tw/chrome/browser/desktop/index.html
 [3]: http://tieba.baidu.com/p/2830235916