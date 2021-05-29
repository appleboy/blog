---
title: 用 Go 語言讀取專案內 .env 環境變數
author: appleboy
type: post
date: 2019-04-11T08:38:57+00:00
url: /2019/04/how-to-load-env-file-in-go/
dsq_thread_id:
  - 7350181171
categories:
  - Golang
tags:
  - golang

---
[![golang logo][1]][1]

在現代開發專案時，一定會用到環境變數，像是讀取 AWS Secret Key 等等，在部署上面也會透過設定變數讓專案依據不同環境讀取不同環境變數，而 [Go 語言][2]內如何實現讀取環境變數，又可以讓開發者透過 .env 檔案動態改變環境變數，本影片用簡單的套件來實現。這個在其他語言的 Framework 都有實現，像是 [Laravel 的 .env 設定][3]。透過本篇例子也教大家如何 import Go 語言的 Package。

<!--more-->

## 教學影片

更多實戰影片可以參考我的 Udemy 教學系列

  * Go 語言實戰課程: <http://bit.ly/golang-2019>
  * Drone CI/CD 自動化課程: <http://bit.ly/drone-2019>

## import package

直接用 [Google 搜尋][4]，一定可以找到第一筆資料，透過『[joho/godotenv][5]』套件就可以快速完成此功能，底下來看看例子:

<pre><code class="language-go">package main

import (
    "fmt"
    "log"
    "os"

    "github.com/joho/godotenv"
)

func main() {
    err := godotenv.Load()
    if err != nil {
        log.Fatal("Error loading .env file")
    }

    s3Bucket := os.Getenv("S3_BUCKET")
    secretKey := os.Getenv("SECRET_KEY")

    fmt.Println(s3Bucket)
    fmt.Println(secretKey)
}
</code></pre>

從上面例子可以看到我們使用了『[joho/godotenv][5]』套件，並且在主程式開頭就判斷專案底下是否有 `.env` 檔案，如果沒有的話就直接抱錯『Error loading .env file』，這樣寫倒是沒有什麼問題，但是當工程師在 git clone 專案時預設沒有 `.env` 檔案，如果執行主程式，肯定就會出錯，這時候我們該如何修正略過此錯誤訊息呢？可以改成如下

<pre><code class="language-go">func main() {
    godotenv.Load()

    s3Bucket := os.Getenv("S3_BUCKET")
    secretKey := os.Getenv("SECRET_KEY")

    fmt.Println(s3Bucket)
    fmt.Println(secretKey)
}</code></pre>

改完後你會發現 `godotenv.Load()` 其實很惱人，不知道能不能直接省略，答案是可以的，這邊我們透過 `_` 來 import 第三方套件

<pre><code class="language-go">package main

import (
    "fmt"
    "os"

    _ "github.com/joho/godotenv/autoload"
)

func main() {
    s3Bucket := os.Getenv("S3_BUCKET")
    secretKey := os.Getenv("SECRET_KEY")

    fmt.Println(s3Bucket)
    fmt.Println(secretKey)
}</code></pre>

大家都知道，如果專案內 import 了，但是沒用到，Go 在編譯時就會報錯，這時候可以透過 `_` 方式來略過此錯誤訊息，但是這邊的 `_` 又有不同的含義，就是可以讀取該套件底下的 `func init()`，我們看一下這 autolod 裡面做了什麼事情？

<pre><code class="language-go">package autoload

/*
    You can just read the .env file on import just by doing
        import _ "github.com/joho/godotenv/autoload"
    And bob's your mother's brother
*/

import "github.com/joho/godotenv"

func init() {
    godotenv.Load()
}</code></pre>

裡面只有定義了 `func init`，而透過 `_` import 就能讀取到 init 函式，此 init 會再進入 main 主程式前直接先讀取了。所以專案根本就是 import 了一行代碼，就可以達到讀取環境變數的功能，接著在專案底下建立 `.env` 檔案

<pre><code class="language-yaml">S3_BUCKET=test
SECRET_KEY=1234</code></pre>

有了這功能就可以讓工程師自行調整環境變數，而不用再額外透過 command 方式設定，我覺得相當方便，有在寫 Go 的朋友們，務必 import 此[套件][5]。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://golang.org
 [3]: https://laravel.com/docs/5.8/configuration
 [4]: https://www.google.com/search?q=golnag+load+env&oq=golnag+load+env&aqs=chrome..69i57j0l4.3374j0j1&sourceid=chrome&ie=UTF-8
 [5]: https://github.com/joho/godotenv