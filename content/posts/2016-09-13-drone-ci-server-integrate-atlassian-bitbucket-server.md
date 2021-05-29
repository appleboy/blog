---
title: Drone CI Server 搭配 Atlassian Bitbucket Server (前身 Stash)
author: appleboy
type: post
date: 2016-09-13T03:25:29+00:00
url: /2016/09/drone-ci-server-integrate-atlassian-bitbucket-server/
dsq_thread_id:
  - 5139988181
categories:
  - DevOps
  - Docker
  - Git
  - Golang
  - Testing
tags:
  - Bamboo
  - Bitbucket
  - devops
  - drone
  - Drone.io

---
<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29645454615/in/dateposted-public/" title="Screen Shot 2016-09-13 at 10.36.58 AM"><img src="https://i2.wp.com/c8.staticflickr.com/9/8044/29645454615_79d329eacb_z.jpg?resize=640%2C361&#038;ssl=1" alt="Screen Shot 2016-09-13 at 10.36.58 AM" data-recalc-dims="1" /></a>

目前團隊是使用 [Atlassian Bitbucket][1] 搭配 [Bamboo][2]，雖然 Bamboo 搭配自家的 Bitbucket (前身是 Stash Server) 整合得相當不錯，但是個人覺得設定上蠻複雜的，所以才想測試看看其他家 CI Service 對團隊學習及設定上更容易。最近找到一套用 [Golang][3] 寫的 CI Server 就是 [Drone][4]，Drone [線上文件][5]提供了 [Github][6], [Gitlab][7], [Gogs][8], Bitbucket (Stash) 等整合。在整合 Drone 搭配 Bitbucket 時，文件寫得不是很清楚，尤其是在 Bitbucket 建立 Application Link 遇到許多問題，官方文件也沒寫得很清楚，故寫此篇記錄如何將 Drone 服務整合 Bitbucket 伺服器。

<!--more-->

### 建立 Application Link

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29534966392/in/dateposted-public/" title="Screen Shot 2016-09-13 at 10.59.51 AM"><img src="https://i2.wp.com/c1.staticflickr.com/9/8524/29534966392_7978a89b1c_o.png?resize=481%2C713&#038;ssl=1" alt="Screen Shot 2016-09-13 at 10.59.51 AM" data-recalc-dims="1" /></a>

表單需要注意的地方是 **`Customer Key`** 跟 **`Shared Secret`** 這兩欄位請直接到 Drone 設定檔內找到

<pre><code class="language-yml">DRONE_SECRET: "replace-this-with-your-own-random-secret"
DRONE_STASH_CONSUMER_KEY: "AppleBoy46"</code></pre>

最下面的 `Create Incoming Link` 要勾選，完成後按下一步會出現底下畫面

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29355412370/in/dateposted-public/" title="Screen Shot 2016-09-13 at 11.07.59 AM"><img src="https://i2.wp.com/c1.staticflickr.com/9/8305/29355412370_64468fd44b_o.png?resize=484%2C498&#038;ssl=1" alt="Screen Shot 2016-09-13 at 11.07.59 AM" data-recalc-dims="1" /></a>

這邊要注意的是我們尚未建立 Public Key，所以請繼續看底下如何建立。

### 建立 Private Key File

要跟 Bitbucket 的 OAuth 建立連線，則需要 private 跟 public RSA certificate，底下是建立 private certificate

<pre><code class="language-bash">$ openssl genrsa -out /etc/bitbucket/key.pem 1024</code></pre>

上面會建立一把 private key 存放到 `mykey.pem`，下一個指令則是產生 public certificate

<pre><code class="language-bash">$ openssl rsa -in /etc/bitbucket/key.pem -pubout >> /etc/bitbucket/key.pub</code></pre>

完成後，請打開 `/etc/bitbucket/key.pub`，將內容複製到上述表單內 `public key` 欄位。另外要將 `/etc/bitbucket/key.pem` 位置設定在 Drone config 內。

<pre><code class="language-bash">DRONE_STASH_CONSUMER_RSA: "/etc/bitbucket/key.pem"</code></pre>

完成後就可以看到底下畫面

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/29646154235/in/dateposted-public/" title="Screen Shot 2016-09-13 at 11.21.24 AM"><img src="https://i1.wp.com/c1.staticflickr.com/9/8056/29646154235_d8e02723b1_o.png?resize=583%2C344&#038;ssl=1" alt="Screen Shot 2016-09-13 at 11.21.24 AM" data-recalc-dims="1" /></a>

看到這畫面算是大功告成了。送了新 [PR][9] 給 [Drone][10] 官方團隊，今天寫文件才知道之前送的 [PR][11] 有錯誤。

### 參考

  * [How to use OAuth with Atlassian products][12]
  * [How to connect VersionEye Enterprise with Atlassian Stash][13]

 [1]: https://www.atlassian.com/software/bitbucket/server
 [2]: https://www.atlassian.com/software/bamboo
 [3]: https://golang.org/
 [4]: https://drone.io/
 [5]: http://readme.drone.io/
 [6]: https://github.com/
 [7]: https://about.gitlab.com/
 [8]: https://gogs.io/
 [9]: https://github.com/drone/docs/pull/180
 [10]: https://github.com/drone/drone
 [11]: https://github.com/drone/docs/pull/169
 [12]: https://www.mibexsoftware.com/blog/how-to-use-oauth-with-atlassian-products/
 [13]: https://blog.versioneye.com/2014/10/06/how-to-connect-versioneye-enterprise-with-atlassian-stash/