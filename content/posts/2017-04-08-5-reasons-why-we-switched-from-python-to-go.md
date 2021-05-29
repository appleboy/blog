---
title: 五大理由從 Python 轉到 Go 語言
author: appleboy
type: post
date: 2017-04-08T10:14:43+00:00
url: /2017/04/5-reasons-why-we-switched-from-python-to-go/
dsq_thread_id:
  - 5707064727
categories:
  - Golang
tags:
  - golang
  - Python

---
[![][1]][1]

在網路上看到這篇『[5 Reasons Why We switched from Python To Go][2]』，先發到自己 [Facebook 牆上][3]，引發討論，乾脆整理一篇 Blog 來寫自己的感想，底下五大理由讓該篇作者從 [Python][4] 轉到 [Go 語言][5]。我會針對前四點來寫心得

  1. 編譯二進制檔案 (加速部署及跨平台)
  2. 編譯自動檢查 Static 型態 (你不會把 string 欄位帶入 Integer)
  3. 效能 (Go 並發跟 Python thread 比起來節省許多資源)
  4. 不需要 web framework (Go 內建大多數 Library 像是 HTTP, JSON, HTML templating)
  5. 好用的 IDE (內文提到 Webstorm, PHPStorm) 我推薦用 [VSCode][6]

除了第五點外，其他四點個人覺得都是工程師的痛點。

<!--more-->

## 1. It Compiles Into Single Binary

由於現在 Web Application 技術越來越先進，所以造成 CI/CD 流程相對複雜，所以每次只要 commit code，部署 + 測試時間相當久，在 Go 語言可以把前端 Source Code 整個包進去 Go Binary，所以 Production 機器根本不需要安裝任何 Package 就可以進行部署，這省下的時間對於大團隊而言是很可觀的。在 Go 語言只需要一個指令，就可以直接 build 出 binary file (不管是 ARM, Linux, MacOS, Windows) 32 bit or 64 bit

<pre><code class="language-bash">$ GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o hello package
$ GOOS=linux GOARCH=arm CGO_ENABLED=0 go build -o hello package
$ GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o hello package
$ GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o hello.exe package</code></pre>

## 2. Static Type System

這點對團隊來說非常重要，每個人寫 Code 的品質真的差異極大，所以每次寫 Function Test 都要寫如果變數帶數字 1 或字串 1，都要寫測試，在函示內也要進行轉換，免的程式出錯，這點解決了大部份工程師會犯錯的問題，並不是每個工程師寫 Code 都會使用 `!==` 或 `===`

## 3. Performance!!

效能這點就無庸置疑，直接看這連結 [Go 1.10 vs Python 3.6.0][7]

## 4. You Don’t Need Web Framework For Go

可以先看去年這篇『[Why I Don’t Use Go Web Frameworks][8]』，如果想寫 web 服務，要最好的效能，就是不要引用複雜第三方套件，直接用 Go 內建的 Package 最快，當然如果是跟其他語言的 Framework 比起來(像是 [Django][9] 或 PHP 的 [Laravel][10])，開發速度不會比較快，但是得到的就是好的效能以及上述優勢。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://medium.com/@tigranbs/5-reasons-why-we-switched-from-python-to-go-4414d5f42690
 [3]: https://www.facebook.com/appleboy46/posts/10155217598399250
 [4]: https://www.python.org/
 [5]: https://golang.org
 [6]: https://code.visualstudio.com/
 [7]: https://benchmarksgame-team.pages.debian.net/benchmarksgame/faster/go-python3.html
 [8]: https://medium.com/code-zen/why-i-don-t-use-go-web-frameworks-1087e1facfa4
 [9]: https://www.djangoproject.com/
 [10]: https://laravel.com/