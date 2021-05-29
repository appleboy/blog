---
title: Ruby Deploy With Capistrano 碰到 SSH Connection Closed
author: appleboy
type: post
date: 2015-03-18T04:25:53+00:00
url: /2015/03/ruby-deploy-with-capistrano-ssh-connection-closed/
dsq_thread_id:
  - 3604819720
categories:
  - Linux
  - Ruby on Rails
  - Ubuntu
tags:
  - capistrano
  - Ruby
  - SSH

---
<div style="margin:0 auto; text-align:center">
  <a href="https://www.flickr.com/photos/appleboy/13256445484/" title="CapistranoLogo by appleboy46, on Flickr"><img src="https://i2.wp.com/farm4.staticflickr.com/3756/13256445484_d0ca222f48.jpg?resize=500%2C125&#038;ssl=1" alt="CapistranoLogo" data-recalc-dims="1" /></a>
</div>

在 [Ruby][1] 開發環境最常用的 Deploy 工具就是 [Capistrano][2]，讓開發者可以快速部署程式碼，在部署進行中，由於大量的 js 及 css 需要處理，所以花最長的時間就是 `assets:precompile`，執行 `cap deploy` 就會發現卡在底下錯誤訊息

> \*\* [whenever:update\_crontab] exception while rolling back: Net::SSH::Disconnect, connection closed by remote host \*\*\* [deploy:update\_code] rolling back \* executing "rm -rf /home/deploy/nami/releases/20150317135422; true" servers: ["xxxxx.tw"] ** [deploy:update_code] exception while rolling back: Net::SSH::Disconnect, connection closed by remote host<!--more-->

遇到這問題顧名思義就是 ssh timeout，造成原因就是由於 `assets:precompile` 執行時間過長，所以 Client 端的 ssh 就斷線，要解決這其實不難，請在 Server 端的 sshd 設定檔加入底下參數

<div>
  <pre class="brush: bash; title: ; notranslate" title="">ClientAliveInterval 120
ClientAliveCountMax 3</pre>
</div>

我們來看看 ClientAliveInterval 跟 ClientAliveCountMax 分別代表什麼意思，`ClientAliveInterval` 以上面例子來說，就是如果 120 秒內沒有收到 Client 端任何訊息，則 Server 會透過加密通道發送 Requerst 並且等待 Client 回應，而 `ClientAliveCountMax` 的用途就是，如果 120 秒沒收到回應，則繼續發送 Request 的次數，所以看到上面設定，就可以知道 120 * 3 秒後都沒有收到 Client 回應，則 SSH Server 就會強迫斷線，也就是會看到 `Net::SSH::Disconnect`。SSH 的設定檔位置為 `/etc/ssh/sshd_config`，完成後請記得重新啟動 sshd。

伺服器設定完成後，我們來看看 Client 端也要設定，請打開 `/etc/ssh/ssh_config` 輸入底下參數

<div>
  <pre class="brush: bash; title: ; notranslate" title="">ServerAliveInterval 120</pre>
</div>

讓 Client 端，每 120 秒可以送 response 給 Server 端，這樣就可以保持 ssh 連線。

參考：[SSH Connection Closed While Deploying With Capistrano][3]

 [1]: https://www.ruby-lang.org/en/
 [2]: https://github.com/capistrano/capistrano
 [3]: https://railsadventures.wordpress.com/2013/05/03/ssh-connection-closed-while-deploying-with-capistrano/