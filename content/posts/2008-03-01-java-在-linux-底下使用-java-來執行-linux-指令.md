---
title: '[java] 在 linux 底下使用 java 來執行 Linux 指令'
author: appleboy
type: post
date: 2008-03-01T14:14:04+00:00
url: /2008/03/java-在-linux-底下使用-java-來執行-linux-指令/
views:
  - 6320
bot_views:
  - 634
dsq_thread_id:
  - 249418531
categories:
  - Java
tags:
  - Java
  - Linux

---
其實可以在 linux 底下去寫 shell script 然後去執行 java 程式，而並非用 java 去執行 Linux 指令，不過java也是可以做到執行 shell command，底下就是我寫的 java 測試 code，去列出自己所在的目錄底下的檔案 ls 這個指令 

<pre class="brush: java; title: ; notranslate" title="">import java.io.*;
import java.net.*;
import java.util.*;

public class runstart{
        public static void main(String a[]) throws Exception{
                Process pl = Runtime.getRuntime().exec("/bin/ls");
                String line = "";
                BufferedReader p_in = new BufferedReader(new InputStreamReader(pl.getInputStream()));
                while((line = p_in.readLine()) != null){
                        System.out.println(line);
                }
                p_in.close();
        }
}
</pre> 參考 

[http://debut.cis.nctu.edu.tw/~ching/Course/JavaCourse/05\_input\_output/02\_input\_output.htm][1]

 [1]: http://debut.cis.nctu.edu.tw/~ching/Course/JavaCourse/05_input_output/02_input_output.htm