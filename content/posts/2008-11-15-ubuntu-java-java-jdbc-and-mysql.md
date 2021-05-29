---
title: '[Ubuntu & java] java JDBC and MySQL'
author: appleboy
type: post
date: 2008-11-15T12:34:10+00:00
url: /2008/11/ubuntu-java-java-jdbc-and-mysql/
views:
  - 10484
bot_views:
  - 1691
dsq_thread_id:
  - 246829391
categories:
  - FreeBSD
  - Java
  - Linux
  - MySQL
  - Network
  - Ubuntu
tags:
  - Java
  - MySQL

---
最近開始要摸 [java][1] 了，目前大概先實做 java with [JDBC][2] 連接 MySQL，所以在 [JavaWorld@TW][3] 這裡找了一些相關的文件，目前我在 Linux 底下實做，還沒找到一套很適合的 IDE Tool 來撰寫程式碼，大家好像都很推 [netbeans][4] 跟 [eclipse][5]，不過我目前還是使用 [PSPad][6] 來撰寫 java 程式碼，然後透過 FTP 的方式編輯，這不是重點，重點是要透過 jdbc 來連接 MySQL，目前是在 [Ubuntu][7] 7.04 這一版本上面實做，底下是實做方法： 1. 首先先安裝 deb 檔案：透過 apt-get 的方式 

<pre class="brush: bash; title: ; notranslate" title="">#
# 首先尋找 java lib with mysql
apt-get install libmysql-java
</pre> 2. 安裝好之後尋找 jar 檔案，加入到 class path 裡面 

<pre class="brush: bash; title: ; notranslate" title="">#
# 首先 echo $CLASSPAT
#
# java mysql jar 檔案如下
/usr/share/java/mysql.jar
# 加入 CLASSPATH，修改 /etc/bash.bashrc
export CLASSPATH=$CLASSPATH:/usr/share/java/mysql.jar
# 然後在
source /etc/bash.bashrc</pre>

<!--more--> 3. 底下用 java 程式測試一下 

<pre class="brush: java; title: ; notranslate" title="">import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class MainClass {
  public static Connection getConnection() throws Exception {
    // Load the JDBC driver
    String driver = "com.mysql.jdbc.Driver";
    //String driver = "org.gjt.mm.mysql.Driver";
    Class.forName(driver);

    // Create a connection to the database
    String url = "jdbc:mysql://ip:3306/NIBS?userUnicode=true";
    String username = "XXXXX";
    String password = "XXXXX";
    return DriverManager.getConnection(url, username, password);
  }

  public static void main(String args[]) {
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    int a = 1;
    try {
      conn = getConnection();
      stmt = conn.createStatement();
      String query = "SET NAMES 'utf8'";
      rs = stmt.executeQuery(query);
      query = "INSERT test (test1, test2) values ('測試','測試')";
      a = stmt.executeUpdate(query);
      query = "select * from project_users";
      rs = stmt.executeQuery(query);
      while (rs.next()) {
        System.out.println(rs.getString("username") + " " + rs.getString("user_real_name") + " "+ rs.getString("user_ether_ip"));
      }
    } catch (Exception e) {
      // handle the exception
      e.printStackTrace();
      System.err.println(e.getMessage());
    } finally {
      try {
        rs.close();
        stmt.close();
        conn.close();
      } catch (Exception ee) {
        ee.printStackTrace();
      }
    }
  }
}
</pre> 如果中文有問題，可以修改 mysql 設定 my.cnf [mysqld] character-set-server=utf8 collation-server=utf8\_general\_ci REF. http://dev.mysql.com/doc/refman/5.0/en/charset-applications.html http://wiki.ubuntu.org.cn/index.php?title=UbuntuHelp:JDBCAndMySQL http://www.javaworld.com.tw/jute/post/view?bid=21&id=366

 [1]: http://zh.wikipedia.org/wiki/Java
 [2]: http://java.sun.com/javase/technologies/database/
 [3]: http://www.javaworld.com.tw
 [4]: http://www.netbeans.org/
 [5]: http://www.eclipse.org/
 [6]: http://www.pspad.com/
 [7]: http://www.ubuntu-tw.org/