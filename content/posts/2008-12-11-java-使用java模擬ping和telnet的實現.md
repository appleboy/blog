---
title: '[Java] 使用java模擬ping和telnet的實現'
author: appleboy
type: post
date: 2008-12-11T07:18:18+00:00
url: /2008/12/java-使用java模擬ping和telnet的實現/
views:
  - 7197
bot_views:
  - 903
dsq_thread_id:
  - 246864862
categories:
  - Java
tags:
  - Java

---
今天在寫 Java 的時候，遇到問題跑去問 TonyQ 兄，他丟了一個網址給我，剛剛測試過了，還漫好用的,紀錄一下 模擬 ping 的實現 

<pre class="brush: java; title: ; notranslate" title="">import java.io.*;
import java.net.*;

public class PseudoPing {
  public static void main(String args[]) {
        try {

            InetAddress address = InetAddress.getByName(args[0]);
            System.out.println(address.isReachable(5000));
        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
  }
}</pre>

<!--more--> 模擬 telnet 的實現 

<pre class="brush: java; title: ; notranslate" title="">Socket server = null;
        try {
            server = new Socket();
            InetSocketAddress address = new InetSocketAddress("192.168.0.201",8899);
            server.connect(address, 5000);
        } catch (UnknownHostException e) {
            System.out.println("telnet失败");
        } catch (IOException e){
            System.out.println("telnet失败");
        }finally{
            if(server!=null)
                try {
                    server.close();
                } catch (IOException e) {
                }
        }
</pre> 參考網站：

[使用java简单模拟ping和telnet的实现][1]

 [1]: http://blog.csdn.net/hbcui1984/archive/2007/10/23/1839096.aspx