---
title: '[FreeBSD] 安裝Awstats 6.6'
author: appleboy
type: post
date: 2006-10-19T11:02:43+00:00
url: /2006/10/freebsd-安裝awstats-66/
bot_views:
  - 734
views:
  - 14957
dsq_thread_id:
  - 247232996
categories:
  - FreeBSD
tags:
  - FreeBSD

---
**安裝路徑** 

> cd /usr/ports/www/awstats-devel/ 安裝好之後 請在 httpd.conf 最後面加入 # Directives to allow use of AWStats as a CGI # **Alias /awstatsclasses &#8220;/usr/local/www/awstats/classes/&#8221; Alias /awstatscss &#8220;/usr/local/www/awstats/css/&#8221; Alias /awstatsicons &#8220;/usr/local/www/awstats/icons/&#8221; ScriptAlias /awstats/ &#8220;/usr/local/www/awstats/cgi-bin/&#8221;**  執行 **/usr/local/www/awstats/tools/awstats_configure.pl** 會出現錯誤訊息～ 

> Error: Failed to open &#8216;/usr/local/www/awstats/wwwroot/cgi-bin/awstats.model.conf&#8217; for read. Error: AWStats database directory defined in config file by &#8216;DirData&#8217; parameter (/var/lib/awstats) does not exist or is not writable. Setup (&#8216;/etc/awstats/awstats.192.168.100.244.conf&#8217; file, web server or permissions) may be wrong. Check config file, permissions and AWStats documentation (in &#8216;docs&#8217; directory). <span class="postbody">建立 <span style="color: blue">/var/lib/awstats</span> 目錄，並給予 777 之權限</span> <span class="postbody">chmod 777 /var/lib/awstats 註：若不給予777權限，將來若設定 <span style="color: green">AllowToUpdateStatsFromBrowser=1</span> 時，會無法透過Browser來即時更新Report</span> 

> &#8212;&#8211; AWStats awstats_configure 1.0 (build 1.6) (c) Laurent Destailleur &#8212;&#8211; This tool will help you to configure AWStats to analyze statistics for one web server. You can try to use it to let it do all that is possible in AWStats setup, however following the step by step manual setup documentation (docs/index.html) is often a better idea. Above all if: &#8211; You are not an administrator user, &#8211; You want to analyze downloaded log files without web server, &#8211; You want to analyze mail or ftp log files instead of web log files, &#8211; You need to analyze load balanced servers log files, &#8211; You want to &#8216;understand&#8217; all possible ways to use AWStats&#8230; Read the AWStats documentation (docs/index.html). &#8212;&#8211;> Running OS detected: Linux, BSD or Unix Warning: AWStats standard directory on Linux OS is &#8216;/usr/local/awstats&#8217;. If you want to use standard directory, you should first move all content of AWStats distribution from current directory: /usr/local/www/awstats to standard directory: /usr/local/awstats And then, run configure.pl from this location. Do you want to continue setup from this NON standard directory [yN] ? y &#8212;&#8211;> Check for web server install Enter full config file path of your Web server. Example: /etc/httpd/httpd.conf Example: /usr/local/apache2/conf/httpd.conf Example: c:Program filesapache groupapacheconfhttpd.conf Config file path (&#8216;none&#8217; to skip web server setup): > **/usr/local/etc/lighttpd.conf** &#8212;&#8211;> Check and complete web server config file &#8216;/usr/local/etc/lighttpd.conf&#8217; AWStats directives already present. &#8212;&#8211;> Update model config file &#8216;/usr/local/www/awstats/cgi-bin/awstats.model.conf&#8217; File awstats.model.conf updated. &#8212;&#8211;> Need to create a new config file ? Do you want me to build a new AWStats config/profile **file (required if first install) [y/N] ? y** &#8212;&#8211;> Define config file name to create What is the name of your web site or profile analysis ? Example: www.mysite.com Example: demo Your web site, virtual server or profile name: > **bbs.ee.ndhu.edu.tw** &#8212;&#8211;> Define config file path In which directory do you plan to store your config file(s) ? Default: /etc/awstats Directory path to store config file(s) (Enter for default): > **/usr/local/etc** &#8212;&#8211;> Create config file &#8216;/usr/local/etc/awstats.bbs.ee.ndhu.edu.tw.conf&#8217; Config file /usr/local/etc/awstats.bbs.ee.ndhu.edu.tw.conf created. &#8212;&#8211;> Add update process inside a scheduler Sorry, configure.pl does not support automatic add to cron yet. You can do it manually by adding the following command to your cron: **/usr/local/www/awstats/cgi-bin/awstats.pl -update -config=bbs.ee.ndhu.edu.tw** Or if you have several config files and prefer having only one command: **/usr/local/www/awstats/tools/awstats_updateall.pl now** Press ENTER to continue&#8230; A SIMPLE config file has been created: /usr/local/etc/awstats.bbs.ee.ndhu.edu.tw.conf You should have a look inside to check and change manually main parameters. You can then manually update your statistics for &#8216;bbs.ee.ndhu.edu.tw&#8217; with command: > perl awstats.pl -update -config=bbs.ee.ndhu.edu.tw You can also read your statistics for &#8216;bbs.ee.ndhu.edu.tw&#8217; with URL: > **http://localhost/awstats/awstats.pl?config=bbs.ee.ndhu.edu.tw** Press ENTER to finish&#8230; 執行 /usr/local/www/awstats/cgi-bin/awstats.pl -update -config=bbs.ee.ndhu.edu.tw From data in log file &#8220;/var/log/lighttpd.access.log&#8221;&#8230; Phase 1 : First bypass old records, searching new record&#8230; Searching new records from beginning of log file&#8230; Phase 2 : Now process new records (Flush history on disk after 20000 hosts)&#8230; Jumped lines in file: 0 Parsed lines in file: 11219 Found 0 dropped records, Found 6 corrupted records, Found 0 old records, Found 11213 new qualified records. 成功訊息 設定進入該網址的權限 

> <pre><Directory "/var/www/html/awstats/wwwroot">
    Options None
    AllowOverride None
    Order allow,deny
    Allow from 192.168.130.211 192.168.160.109
</Directory>
</pre> Demo 

[http://bbs.ee.ndhu.edu.tw/awstats/awstats.pl?config=bbs.ee.ndhu.edu.tw][1] lighttpd [http://trac.lighttpd.net/trac/wiki/#ReferenceDocumentation][2] [Awstats設定檔][3]{#p80}

 [1]: http://bbs.ee.ndhu.edu.tw/awstats/awstats.pl?config=bbs.ee.ndhu.edu.tw "http://bbs.ee.ndhu.edu.tw/awstats/awstats.pl?config=bbs.ee.ndhu.edu.tw"
 [2]: http://trac.lighttpd.net/trac/wiki/#ReferenceDocumentation "http://trac.lighttpd.net/trac/wiki/#ReferenceDocumentation"
 [3]: http://blog.wu-boy.com/wp-content/uploads/2007/03/awstats.txt