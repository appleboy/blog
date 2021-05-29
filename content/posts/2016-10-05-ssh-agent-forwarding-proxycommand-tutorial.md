---
title: SSH agent forwarding 教學
author: appleboy
type: post
date: 2016-10-05T02:09:41+00:00
url: /2016/10/ssh-agent-forwarding-proxycommand-tutorial/
dsq_thread_id:
  - 5197333740
categories:
  - DevOps
tags:
  - AWS
  - devops
  - SSH

---
**2016.11.13 Update: SSH Agent Forwarding 有安全性問題，請用 `ProxyCommand` 取代，請參考 [SSH Agent Forwarding considered harmful][1]** <a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/30008040142/in/dateposted-public/" title="Screen Shot 2016-10-05 at 9.26.13 AM"><img src="https://i0.wp.com/c7.staticflickr.com/6/5219/30008040142_9d50881bba_z.jpg?resize=640%2C371&#038;ssl=1" alt="Screen Shot 2016-10-05 at 9.26.13 AM" data-recalc-dims="1" /></a>

[SSH agent forwarding][2] 可以讓開發者將 Local 端的 SSH Key Pair 帶到另外一台機器進行傳送，也就是說你不用將 SSH Key 複製到遠端 Server 再進行跳板動作，原本在 AWS 維護多台 EC2 主機，都會固定有一台跳板機，大家都把自己需要登入遠端機器的 SSH Key 複製到跳板機，這做法其實沒有很安全，又需要多下一個指令進行跳板。

> 個人電腦 \----> EC2 跳板機 \----> EC2 Server

大家都會把 Key Pair 存放到跳板機，安全性堪憂，只要這台主機被 Hack，或者是內部員工登入，拿別人的 Key Pair 登入其它主機，不就可以搞破壞？所以此篇教學主要教大家如何設定 SSH agent forwarding，讓憑證只存放在自己電腦，而不需上傳到 `EC2 跳板機`。這樣跳板機就真的只是跳板機，不需要存放任何憑證資料，每小時設定清空 Ubuntu User 家目錄，避免內部員工放個人資料或憑證，提升主機安全性。

<!--more-->

### 將 Key Pair 放到清單

透過 `ssh-add` 指令將 Private Key Pair 加入清單

<pre><code class="language-bash">$ ssh-add ~/.ssh/keys/labs.pem</code></pre>

透過底下指令可以看到清單列表

<pre><code class="language-bash">$ ssh-add -L</code></pre>

這邊注意可以將所有機器的 key pair 都放到 `~/.ssh/keys` 目錄，並且設定 `400` 權限

### 設定 ~/.ssh/config

**方法一**: 設定 `~/.ssh/config` 檔案，每個 Host 都加上 `ForwardAgent yes` 參數 (此方法並不安全，請參考 [SSH Agent Forwarding considered harmful][1])

<pre><code class="language-bash">Host aws
  HostName 10.130.xxx.xxx
  User ubuntu
  ServerAliveInterval 60
  ForwardAgent yes
  UseRoaming no
  IdentityFile ~/.ssh/keys/aws.pem</code></pre>

最後執行底下指令就可以直接跳到您要的 EC2 Server

<pre><code class="language-bash">$ ssh -t aws &#039;ssh example.inc&#039;</code></pre>

**方法二**: 也是設定 `~/.ssh/config`，但是透過 `ProxyCommand` 而不是 `ForwardAgent yes` (**建議使用此方法**)

<pre><code class="language-bash">Host hosta
  User userfoo
  Hostname 123.123.123.123

Host hostb
  User userbar
  Hostname 192.168.1.1
  Port 22
  ProxyCommand ssh -q -W %h:%p hosta
  IdentityFile ~/.ssh/keys/xxxx.pem</code></pre>

ProxyCommand 也不用將 pem 透過 `ssh-add` 匯入，省下一步指令，接著執行底下指令就可以 ssh 到指定機器，跟方法一比起來更安全又快速

<pre><code class="language-bash">$ ssh hostb</code></pre>

不用再跳板機多下一個 SSH 登入指令，蠻方便又安全。內部 Host Name 可以透過設定 [AWS Private Hosted Zones][3]。

 [1]: https://heipei.github.io/2015/02/26/SSH-Agent-Forwarding-considered-harmful/
 [2]: https://developer.github.com/guides/using-ssh-agent-forwarding/
 [3]: http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html