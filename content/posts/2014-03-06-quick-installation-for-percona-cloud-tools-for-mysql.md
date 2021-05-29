---
title: Percona Cloud Tools for MySQL 介紹及安裝
author: appleboy
type: post
date: 2014-03-06T07:53:05+00:00
url: /2014/03/quick-installation-for-percona-cloud-tools-for-mysql/
dsq_thread_id:
  - 2370417962
categories:
  - MySQL
  - Percona XtraDB Cluster
tags:
  - MySQL
  - Percoba XtraDB Cluster
  - Percona
  - Percona Cloud Tools

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/12023069753/" title="percona by appleboy46, on Flickr"><img src="https://i1.wp.com/farm4.staticflickr.com/3820/12023069753_de60d0c86d_m.jpg?resize=240%2C234&#038;ssl=1" alt="percona" data-recalc-dims="1" /></a>
</div>

[Percona][1] 去年推出一套 [Cloud Tools for MySQL][2]，藉由這套雲端服務可以幫忙分析 MySQL 系統內全部 Slow Query，並且計算出時間，畫出統計圖，此套系統目前還在 Beta 版，並且有些限制，只能開 3 個 organizations，每個 organizations 只能有 5 agents，最後資料只會保留 8 天，超過就會清除。這套系統後端是由 [GO Language][3] 完成，前端則是由 [AngularJS][4] 串起來，上個月 Percona 還在 [MySQL Performance Blog][5] 徵求 [GO 的開發者][6]，可見 Percona 也看好此服務，大膽使用 Google 推的 GO Language。

<!--more--> Percona Cloud Tools 由三個部份組成，分別是 

[Slow log files][7]、[Percona Toolkit][8]、[Percona Cloud][2]，`Slow log files` 就是系統要將 slow query 紀錄到檔案，經由 `Percona Toolkit` 將檔案分析好，最後透過 https 上傳到 `Percona Cloud`。所底下安裝就是這三個部份。

### 安裝方式

CentOS 安裝方式如下:

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ yum install percona-toolkit perl-JSON</pre>
</div>

請用 Google 帳號登入 https://cloud.percona.com/ 取得 API Key，畫面如下

[<img src="https://i0.wp.com/farm8.staticflickr.com/7390/12965200114_ca66c5f8e0_o.png?resize=594%2C352&#038;ssl=1" alt="Percona Cloud Tools 2014-03-06 15-42-34" data-recalc-dims="1" />][9]

接著用 pt-agent 指令安裝 Daemon

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ pt-agent --install --user={mysql username} --password={password} --api-key={API Key copied from web site}</pre>
</div>

也可以簡化成

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ pt-agent --install</pre>
</div>

執行後可以看到底下結果

<div>
  <pre class="brush: bash; title: ; notranslate" title="">$ pt-agent --install
Step 1 of 12: Verify the user is root: OK
Step 2 of 12: Check Perl module dependencies: OK
Step 3 of 12: Check for crontab: OK
Step 4 of 12: Verify pt-agent is not installed: OK
Step 5 of 12: Verify the API key:
Enter your API key: 631f9cc0c54a41248300cbc16a047ad6
Step 5 of 12: Verify the API key: OK
Step 6 of 12: Connect to MySQL: OK
Step 7 of 12: Check if MySQL is a slave: NO
Step 8 of 12: Create a MySQL user for the agent: OK
Step 9 of 12: Initialize /etc/percona/agent/my.cnf: OK
Step 10 of 12: Initialize /root/.pt-agent.conf: OK
Step 11 of 12: Create the agent: OK
Step 12 of 12: Run the agent: pt-agent has daemonized and is running as PID 22791:

  --lib /var/lib/pt-agent
  --log /var/log/pt-agent.log
  --pid /var/run/pt-agent.pid

These values can change if a different configuration is received.
OK
INSTALLATION COMPLETE
The agent has been installed and started, but it is not running any services yet.  Go to https://cloud.percona.com/agents#xxx to enable services for the agent.</pre>
</div>

最後到 cloud.percona 看執行結果，就算大功告成了，只要等個半小時就會有資料進來了

[<img src="https://i1.wp.com/farm3.staticflickr.com/2522/12964973573_1bc3ee8d3f_z.jpg?resize=640%2C252&#038;ssl=1" alt="Percona Cloud Tools 2014-03-06 15-47-13" data-recalc-dims="1" />][10]

Percona Cloud 成功收到資料就會變成綠色標記

[<img src="https://i2.wp.com/farm3.staticflickr.com/2176/12965014173_69097e27ce_o.png?resize=435%2C450&#038;ssl=1" alt="Percona Cloud Tools 2014-03-06 15-50-39" data-recalc-dims="1" />][11]

點選 Report 可以看到執行效率很慢的 Query 結果

[<img src="https://i2.wp.com/farm8.staticflickr.com/7309/12965031193_e207bc6553_z.jpg?resize=640%2C315&#038;ssl=1" alt="Percona Cloud Tools 2014-03-06 15-52-04" data-recalc-dims="1" />][12]

 [1]: https://www.percona.com
 [2]: https://cloud.percona.com
 [3]: http://golang.org/
 [4]: http://angularjs.org/
 [5]: http://www.mysqlperformanceblog.com
 [6]: http://www.mysqlperformanceblog.com/2014/01/20/percona-hiring-go-back-end-engineer/
 [7]: http://dev.mysql.com/doc/refman/5.5/en/slow-query-log.html
 [8]: http://www.percona.com/software/percona-toolkit
 [9]: https://www.flickr.com/photos/appleboy/12965200114/ "Percona Cloud Tools 2014-03-06 15-42-34 by appleboy46, on Flickr"
 [10]: https://www.flickr.com/photos/appleboy/12964973573/ "Percona Cloud Tools 2014-03-06 15-47-13 by appleboy46, on Flickr"
 [11]: https://www.flickr.com/photos/appleboy/12965014173/ "Percona Cloud Tools 2014-03-06 15-50-39 by appleboy46, on Flickr"
 [12]: https://www.flickr.com/photos/appleboy/12965031193/ "Percona Cloud Tools 2014-03-06 15-52-04 by appleboy46, on Flickr"