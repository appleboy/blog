---
title: "加密檔案的好工具 - age"
date: 2023-09-30T09:51:04+08:00
author: appleboy
type: post
slug: secure-encryption-tool-age
share_img: /images/2023-09-30/flow.png
categories:
- age-encryption
- encryption
---

![cover](/images/2023-09-30/cover.png)

[Go 語言][2]內的 [age][1] 軟體是一種開源的密碼學工具，用於加密和解密檔案。它主要用於保護敏感檔案或資料的隱私。它使用先進的加密標準，如 XChaCha20 和 Poly1305，以及 Scrypt 來加密和解密檔案。它還支持多種加密標準，如 RSA 和 Ed25519，以及多種密碼學工具，它還支持多種平台，如 Linux、Windows 和 macOS。為什麼我需要選擇這套工具呢？可以先從底下的流程圖來了解。

[1]:https://github.com/FiloSottile/age
[2]:htts://go.dev

<!--more-->

![flow](/images/2023-09-30/flow.png)

## 專案需求

公司架構非常複雜，因為團隊多樣性的關係，部分資料是不能上傳到公開的雲端平台，因此會把這些開發流程建置在無網路環境上，但是這樣的開發流程會有一些問題，例如我們要把檔案傳送給其他人，但是又不想讓其他人知道檔案內容，必須把檔案加密，加密的檔案又不能讓其他人解密。所以我們需要一套工具來加密檔案，並且可以將加密的檔案傳送給其他人，讓其他人可以解密檔案。這套工具必須要有以下特性：

* 簡單容易操作
* 支援多種加密
* 支援多種平台

在上述流程圖中的步驟一，就是要使用 age 工具來加密檔案，由於需要全程自動化關係，故會在此步驟進行一次性的產生加密的 Public + Private Key，確保加密的檔案只有特定的人可以解密。

## 安裝 age 工具

age 工具支援多種平台，例如 Linux、Windows 和 macOS，可以參考[官方文件][3]。底下是安裝 age 工具的指令。這邊我們用 MacOS 來當作範例

[3]: https://github.com/FiloSottile/age#installation

```bash
brew install age
```

安裝完成後，你可以發現有兩個指令可以使用，分別是 `age-keygen` 及 `age`。`age-keygen` 用來產生 Public + Private Key，`age` 用來加密檔案。

## 產生 Public + Private Key

底下是快速產生 Public + Private Key 的指令

```bash
$ age-keygen -o key.txt
Public key: age1ceyq43kkwk3a3x6van6zf4anx2g7v5c9fk9zje5ux3pf6t5enyyqf50hjn
```

你可以打開 key.txt 檔案，會看到類似下面的內容

```bash
# created: 2023-09-30T16:02:55+08:00
# public key: age1ceyq43kkwk3a3x6van6zf4anx2g7v5c9fk9zje5ux3pf6t5enyyqf50hjn
AGE-SECRET-KEY-1A07QJAJXSRL7PMVH8F4Z77XHRKZKY62EM6XKRC35774CGCVXM49SS2FLH5
```

請好好保存這個檔案，因為這個檔案是你的 Private Key，如果你遺失了這個檔案，你就無法解密檔案了。

## 加密檔案

我們先產生一個檔案，並對其作加密檔案的指令

```bash
echo "Hello World" > secret.txt
age -r your_public_key_raw_content -o secret.txt.enc secret.txt
```

`-r` 參數是你的 Public Key 內容，`-o` 參數是輸出的檔案名稱，最後一個參數是要加密的檔案名稱。加密完成後，你會看到 `secret.txt.enc` 檔案，這個檔案就是加密後的檔案，你可以打開來看看，會發現檔案內容已經被加密了。

### 多個 Public Key 加密

如果你想要多個人可以解密檔案，你可以使用 `-r` 參數來加入多個 Public Key，底下是範例

```bash
age -r your_public_key_raw_content -r your_public_key_raw_content -o secret.txt.enc secret.txt
```

除了 `-r` 參數之外，你也可以將多個 public key 寫入到檔案中，例如 `public.txt`，底下是範例

```bash
$ cat public.txt
# Alice
age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
# Bob
age1lggyhqrw2nlhcxprm67z43rta597azn8gknawjehu9d9dl0jq3yqqvfafg

# execute command
age -R public.txt -o secret.txt.enc secret.txt
```

### 使用 SSH Keys 加密

如果你想要使用 SSH Keys 來加密檔案，你可以使用 `-R` 參數，底下是範例

```bash
age -R ~/.ssh/id_ed25519.pub secret.txt > secret.txt.age
```

SSH Key 也支援使用 `-R` 多個參數，底下是範例是透過 GitHub 的 SSH Keys 來加密檔案

```bash
curl https://github.com/appleboy.keys | age -R - secret.txt > secret.txt.age
```

## 解密檔案

底下是解密檔案的指令

```bash
age --decrypt -i key.txt secret.txt.age > secret.txt
```

## 心得感想

age 工具非常的簡單，而且支援多種加密方式，如果你想要使用 SSH Keys 來加密檔案，也非常的容易，只需要使用 `-R` 參數即可。如果你想要多個人可以解密檔案，也可以使用 `-r` 參數來加入多個 Public Key。總之如果你想要加密檔案，age 工具是一個不錯的選擇。
