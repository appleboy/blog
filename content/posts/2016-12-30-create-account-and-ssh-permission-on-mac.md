---
title: 在 Mac 建立新帳號，並且開通 ssh 權限
author: appleboy
type: post
date: 2016-12-30T06:19:27+00:00
url: /2016/12/create-account-and-ssh-permission-on-mac/
dsq_thread_id:
  - 5421377743
categories:
  - Linux
  - Mac
tags:
  - golang
  - OpenSSH
  - SCP
  - SSH

---
[<img src="https://i1.wp.com/live.staticflickr.com/397/31822815762_fea6b2c9f4_c.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

為什麼我會需要在 [Mac][2] 建立新帳號呢，原因就是最近用 [Golang][3] 寫了 [SCP 工具][4]，此工具支援 Password 或 SSH Public Key 登入，我又不想拿個人帳號寫在 Testing 檔案內，所以才會想到在 Mac 建立一個帳號好了，本篇就是教大家如何在 Mac 建立新帳號，並且開通 SSH 權限。

<!--more-->

## 建立 Mac 帳號

Mac 不像是其他 Linux 作業系統，可以直接透過一行指令完成建立帳號動作，所以透過 Google 找到了[這篇解法][5]

<pre><code class="language-bash">dscl . -create /Users/drone-scp
dscl . -create /Users/drone-scp UserShell /bin/bash
dscl . -create /Users/drone-scp RealName "Joe Admin" 
dscl . -create /Users/drone-scp UniqueID "510"
dscl . -create /Users/drone-scp PrimaryGroupID 20
dscl . -create /Users/drone-scp NFSHomeDirectory /Users/drone-scp
dscl . -passwd /Users/drone-scp password 
dscl . -append /Groups/admin GroupMembership drone-scp</code></pre>

上面指令完成後，請切到 Root 下重新開機的指令

<pre><code class="language-bash">$ reboot</code></pre>

這時候你會看到右上角多了一個帳號 `drone-scp`

[<img src="https://i2.wp.com/c2.staticflickr.com/6/5612/31937111666_fd0411ee7e_o.png?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][6]

最後登入 `drone-scp` 帳號來產生個人目錄底下的相關檔案，這樣用 Command 才可以切到該使用者家目錄 `/Users/drone-scp`

## 啟動帳戶 SSH 權限

Mac 預設是不讓外面透過 ssh 方式連線到使用者，所以必須透過管理者開通此權限，請到 System Preferences -> Shareing，將左邊 Sidebar 內的 Remote Login 打開，並且把 drone-scp 帳號放入白名單。

[<img src="https://i1.wp.com/live.staticflickr.com/602/31600688480_6dfebd5932_c.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][7]

## 測試 SSH

首先產生 SSH Key

<pre><code class="language-bash">$ ssh-keygen -f id_rsa -N '' -t rsa</code></pre>

複製 `id_rsa.pub` 到 drone-scp 家目錄

<pre><code class="language-bash">$ cp -r id_rsa.pub /Users/drone-scp/.ssh/authorized_keys</code></pre>

透過 ssh 指令測試看看是否可以登入，請注意 `id_rsa` 權限必須為 `400`

<pre><code class="language-bash">$ ssh -i id_rsa -l drone-scp localhost</code></pre>

有看到成功登入的畫面吧 ^\___^

## 後記

寫完這篇才想到，可以用 [Docker][8] 來快速架一個 SSH Server，這邊就不多介紹了，新建 Mac 帳號也是蠻快的。

 [1]: https://i1.wp.com/live.staticflickr.com/397/31822815762_fea6b2c9f4_c.jpg?ssl=1
 [2]: http://www.apple.com/tw/mac/
 [3]: https://golang.org/
 [4]: https://github.com/appleboy/drone-scp
 [5]: http://apple.stackexchange.com/questions/226073/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-11
 [6]: https://i2.wp.com/c2.staticflickr.com/6/5612/31937111666_fd0411ee7e_o.png?ssl=1
 [7]: https://i1.wp.com/live.staticflickr.com/602/31600688480_6dfebd5932_c.jpg?ssl=1
 [8]: https://www.docker.com/