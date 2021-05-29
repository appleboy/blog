---
title: '[Java] 安裝好 Jdk 設定 path 跟 classpath 路徑'
author: appleboy
type: post
date: 2008-02-27T10:40:39+00:00
url: /2008/02/java-安裝好-jdk-設定-path-路徑/
views:
  - 18011
bot_views:
  - 773
dsq_thread_id:
  - 246708716
categories:
  - Java
tags:
  - Java

---
今天剛裝好 jdk 新版 jdk1.6.0_04，如要下載請到 [這裡][1] 下載，裝好之後當然底下要找編譯檔案，就是要去 bin 這個資料夾，然後找到 javac 跟 java 執行檔就可以了，不過如果你要在任何地方都要使用這個執行檔，就要去修改 path，設定方法如下 [<img src="https://i2.wp.com/farm4.static.flickr.com/3283/2296039572_21e85b77f0_o.jpg?resize=419%2C479&#038;ssl=1" alt="java_1" border="0" data-recalc-dims="1" />][2] 我的電腦右鍵->內容 k<!--more-->

[<img src="https://i2.wp.com/farm4.static.flickr.com/3047/2295246445_5e12c8019f_o.jpg?resize=419%2C479&#038;ssl=1" alt="2003_2" border="0" data-recalc-dims="1" />][3] 然後選進階，然後環境變數 [<img src="https://i1.wp.com/farm4.static.flickr.com/3203/2295246465_e77b65f090_o.jpg?resize=384%2C423&#038;ssl=1" alt="2003_3" data-recalc-dims="1" />][4] 然後設定最上面的 path，然後加上 

> C:\Program Files\Java\jdk1.6.0_04\bin 設定 ClassPath: 

> .;C:\Program Files\Java\jdk1.6.0\_04\lib;C:\Program Files\Java\jdk1.6.0\_04\lib\tools.jar;  注意一下前面有一個點，這點大家很容易忘記，不然就是寫成 bat 檔案，然後開機自動執行就可以 

> SET PATH=C:\Program Files\Java\jdk1.6.0\_04\bin; SET CLASSPATH=.;C:\Program Files\Java\jdk1.6.0\_04\lib;C:\Program Files\Java\jd1.6.0_04\lib\tools.jar;  存檔為 java_path.bat 就可以，如果要檢查設定對不對，請打 

> echo %classpath% echo %path%  這行要看你是裝哪一個版本，版本不同就會不一樣，所以要設定正確，設定好之後，按開始->執行->打入 cmd，然後打 javac，就會看到 help 檔案，這樣就可以了，如下圖 [<img src="https://i2.wp.com/farm4.static.flickr.com/3142/2296052246_ba84c5c986.jpg?resize=387%2C500&#038;ssl=1" alt="2003_4" data-recalc-dims="1" />][5] [http://www.javaworld.com.tw/jute/post/view?bid=29&id=16093&sty=1&tpg=1&age=0][6] [http://www.javaworld.com.tw/jute/post/view?bid=29&id=22589&tpg=1&ppg=1&sty=1][6]

 [1]: http://java.sun.com/javase/downloads/index.jsp
 [2]: https://www.flickr.com/photos/appleboy/2296039572/ "java_1 by appleboy46, on Flickr"
 [3]: https://www.flickr.com/photos/appleboy/2295246445/ "2003_2 by appleboy46, on Flickr"
 [4]: https://www.flickr.com/photos/appleboy/2295246465/ "2003_3 by appleboy46, on Flickr"
 [5]: https://www.flickr.com/photos/appleboy/2296052246/ "2003_4 by appleboy46, on Flickr"
 [6]: http://www.javaworld.com.tw/jute/post/view?bid=29&id=22589&tpg=1&ppg=1&sty=1&age=0#22589