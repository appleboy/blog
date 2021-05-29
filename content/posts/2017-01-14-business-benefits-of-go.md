---
title: 從商業利益看 Go 程式語言
author: appleboy
type: post
date: 2017-01-14T12:59:30+00:00
url: /2017/01/business-benefits-of-go/
dsq_thread_id:
  - 5461983882
categories:
  - Golang
tags:
  - golang

---
[![][1]][1]

從 2016 年開始寫 [Go][2] 程式語言，在這一年我向很多朋友介紹了 Go 語言，很多人就不經問到為什麼我這麼喜歡 Go 語言，在公司內同事或主管更會問，為什麼要從 Node.js 或其他語言轉換到 Go，Go 語言有什麼地方可以帶給公司更大的利益，否則為什麼要多花時間跟人力去嘗試 Go 語言。如果團隊要建置一個商業 Web 服務，那我覺得底下的優點，是讓您選擇 Go 語言的最主要原因。

<!--more-->

### Go 優勢

  * 快速又簡單部署
  * 支援跨平台編譯
  * 保護原始程式碼
  * 善用多核心處理

底下會針對上述提到的優點進行詳細說明。

## 1. 快速部署

### 傳統部署

大家都知道 Golang 可以將專案程式碼編譯成一個二進制檔案，直接部署此檔案會比上傳上百的或上千個檔案還要來得容易。傳統上傳多個檔案是非常慢的，這就是為什麼我們在部署之前會將所有檔案透過 zip 或 tar 的方式打包成一個檔案再部署到機器上，除此之外，上傳後，伺服器端要另外解壓縮或者做其他事情，想想看要寫多少 Shell Script 才能完成此事情，而這些事情都是要靠 [DevOps][3] 工程師去撰寫，以及花時間去調整 [CI][4] 伺服器 (像是 [Jenkins][5])。

### 伺服器設定

當然還沒完，檔案上傳完後，每一台伺服器都需要準備相關軟體及設定，這時候可以透過 [Docker][6] 及 [Puppet][7] 或 [Chef][8] 完成這些事情，這些都是要花很大量的時間去處理，另外還要處理相對應安全性問題，像是 [PHP][9] 或 [Python][10] 或 [Ruby][11] 甚至 [Node.js][12] 版本的升級，太多層面需要考量。

### 用 Go 語言

在 Go 語言，你只需要將程式碼編譯出二進制執行檔，就可以直接丟到多台伺服器，直接啟動，並不需要準備各種環境或軟體設定，省下來的時間就是大量的金錢。如果是用 Go 語言，我相信團隊內的 DevOps 工程師會很感謝你。假如團隊還沒將 DevOps 流程納入公司的商業考量，那您就落伍了。一位好的 DevOps 工程師可以幫團隊省下很多資金。

## 2. 不需要 Web 伺服器

這點其實就跟 Node.js 很像，你不需要 Apache 或 Tomcat 或 Nginx 等相關服務，Go 的執行檔就可以處理 Http 連線，這意味著不會有伺服器設定，也不需要維護成本，更不用考慮伺服器安全性問題。當然你執意要使用 load balance 像是 [Nginx][13] 或 [HAProxy][14] 這時候就會變得比較難除錯，也會多花不少時間再調整設定。

## 3. 保護程式碼

這點非常重要，如果你是賣軟體或者是雲端的公司，這時候客戶希望你將整套雲端放置在客戶公司內部，讓他們測試使用，這時候如果你是使用 Node.js, Ruby 或 PHP 的話，你只能乖乖的將整套原始碼放置在對方公司，並且心驚膽跳的怕對方有意去複製整套程式碼，這時候你敢跟老闆講說，我們需要將程式碼放到對方公司嗎？但是如果是在 Go，我們只需要給客戶一個檔案，請他們直接執行，就可以將服務跑起來，如果想要 decompile 此 binary，答案是 NO。

## 4. 多核心處理

Go 是個多核心處理的程式語言，這對於伺服器非常重要，許多 web 多語言都是跑 single thread，所以會閒置許多系統效能，現在的伺服器幾乎都是多核 CPU 了，像在 Node.js 你就必須在一台機器跑多個 Node 服務，才可以有效率地發揮效能。在 Go 1.5 版本後 (含 1.5) 已經將 `GOMAXPROCS` 預設值為系統可用的多核數，所以只要啟動一個執行檔，就可以將系統效能發揮到極限。

## 5. 跨平台編譯

Go 語言可以將程式碼編譯成 [Windows][15] 或 [MacOS][16] 或 [Linux][17] 的執行檔，方便攜帶或測試，想看看業務到外面跟客戶 Demo，還要連到 Internet 才可以 Demo 給客戶看，如果網路環境不好或者是沒網路該怎麼辦呢？這時候你只需要攜帶一個執行檔在身上就可以解決您的問題。在團隊內部，每次 QA 都要等工程師部署到內部機器才可以開始測試，這時只要給他們執行檔，就不需要等待工程師部署才可以測試，省下多少時間，這些寶貴的時間都是金錢啊。

## 結論

其實你會發現上面提到的所有優勢都是省下`時間`及`金錢`，時間在公司是非常重要及寶貴，大家可以想看看，省下的時間是不是可以讓團隊多做一些事情，讓公司更進步更有競爭力呢？

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org/
 [3]: https://zh.wikipedia.org/wiki/DevOps
 [4]: https://zh.wikipedia.org/wiki/%E6%8C%81%E7%BA%8C%E6%95%B4%E5%90%88
 [5]: https://jenkins.io/
 [6]: https://www.docker.com/
 [7]: https://puppet.com/
 [8]: https://www.chef.io/
 [9]: http://php.net/
 [10]: https://www.python.org/
 [11]: https://www.ruby-lang.org/
 [12]: https://nodejs.org/
 [13]: https://nginx.org/
 [14]: http://www.haproxy.org/
 [15]: https://www.microsoft.com/
 [16]: http://www.apple.com/
 [17]: https://zh.wikipedia.org/wiki/Linux