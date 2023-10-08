---
title: "快速設定 Git Commit Signature Verification"
date: 2023-10-08T09:25:11+08:00
author: appleboy
type: post
slug: git-commit-signature-verification
share_img: /images/2023-10-08/cover.png
categories:
- git
---

![git commit](/images/2023-10-08/cover.png)

大家可以看到上面這張圖的第一筆 commit 是有加上綠色框框的 Verified 標籤，這是因為我有設定 [Git Commit Signature Verification][1]，這樣的好處是可以確保每次的 commit 都是由我本人所做的，而不是其他人偽造的。這邊我們來看看如何設定 Git Commit Signature Verification。

[1]:https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification

<!--more-->

## 設定 SSH Key

有兩種方式可以支援 Git Commit Signature Verification，第一種是透過 SSH Key，第二種是透過 GPG Key。這邊我們先來看看如何設定 SSH Key。

### 產生 SSH Key

底下是產生 SSH Key 的指令，請注意 `email` 參數必須要跟你的 GitHub 帳號相同，否則會無法正常運作。

```bash
ssh-keygen -t rsa -C "appleboy.tw@gmail.com"
```

產生完成後，你會看到類似下面的訊息

```bash
Generating public/private rsa key pair.
Enter file in which to save the key (/xxx/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /xxx/.ssh/id_rsa.
Your public key has been saved in /xxx/.ssh/id_rsa.pub.
The key fingerprint is:
```

相信大家現在都知道如何產生 SSH Key 了，接下來我們要把 SSH Key 加入到 GitHub 帳號中。

### 加入 SSH Key 到 GitHub 帳號

底下是加入 SSH Key 到 GitHub 帳號的指令

```bash
pbcopy < ~/.ssh/id_rsa.pub
```

![add new ssh key](/images/2023-10-08/add-new-ssh-key.png)

## 設定 Git Commit Signature Verification

第一步先設定 Git Commit Signature Verification，底下是設定 Git Commit Signature Verification 的指令

```bash
git config --global commit.gpgsign true
```

第二步設定 Git Commit Signature Verification 的 SSH Key，底下是設定 SSH Key 的指令

```bash
git config --global gpg.format ssh
git config --global user.signingkey \
  /xxx/.ssh/id_rsa.pub
```

其中 `/Users/appleboy/.ssh/id_rsa.pub` 請換成你自己的 SSH Key 路徑。完成後之後所有的 Commit 都會自動加上簽章，你可以透過 `git commit -S` 來手動加上簽章。

這邊注意，由於 GitHub 的設定頁面，其中 Authentication Key 跟 Signing Key 是分開設定的，故需要做兩次設定，其中 Authentication Key 是用來驗證你的身份，Signing Key 是用來驗證你的 Commit 是否為你本人所做的。如果您是用 [Gitea][21] 的話，則只需要設定一次即可。

[21]:https://gitea.com/

## 參考資料

* [GitLab Sign commits with SSH keys][11]

[11]:https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html#sign-commits-with-your-ssh-key
