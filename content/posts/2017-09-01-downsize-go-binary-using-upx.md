---
title: 用 upx 壓縮 Go 語言執行擋
author: appleboy
type: post
date: 2017-09-01T01:37:27+00:00
url: /2017/09/downsize-go-binary-using-upx/
dsq_thread_id:
  - 6111142548
categories:
  - DevOps
  - Golang
tags:
  - Go
  - upx

---
[![][1]][1]

剛開始學 [Go][2] 語言的時候，跟學習其他語言一樣，寫了底下一個簡單的 Hello World 檔案

```go
package main

import (
    "fmt"
)

func main() {
    fmt.Println("Hello World!")
}
```

這是一個最簡單的程式碼，接著透過 `go build` 的方式編譯出執行檔，這時候我們看看檔案大小:

<!--more-->

```bash
$ du -sh hello*
1.8M    hello
4.0K    hello.go
```

一個 4K 大小的 Hello World，竟然要 1.8MB (使用 Go 1.9 版本)，雖然說現在硬碟很便宜，網路傳輸也很快，但是對於大量 Deploy 到多台機器時，還是需要考量檔案大小，當然是越小越好，這時候我們可以使用 Go 語言的 `shared` 方式編譯出共同的 .a 檔案，將此檔案丟到全部機器，這樣再去編譯主執行擋，可以發現 Size 變成很小，應該不會超過 20K 吧。但是此種方式比較少人使用，大部分還直接將主程式編譯出來，這時來介紹另外一個工具用來減少 Binary 大小，叫做 [UPX][3]

> UPX - the Ultimate Packer for eXecutables

當然 upx 不只是可以壓縮 Go 的編譯檔案，其他編譯檔案也可以壓縮喔，底下是透過 upx 使用兩種不同的編譯方式來減少執行檔大小

```bash
$ du -sh hello*
1.8M    hello
# upx -o hello_1 hello
636K    hello_1
# upx --brute -o hello_2 hello
492K    hello_2
4.0K    hello.go
```

用了兩種方式來壓縮大小，越小的檔案，處理的時間越久，壓縮比例至少超過 70%，效果相當不錯，用 Hello World 沒啥感覺，實際拿個 Produciton 的案子來試試看，就拿 [Gorush][4] 來壓縮看看

```bash
$ du -sh *
15M     gorush
# upx --brute -o gorush_1 gorush
3.4M    gorush_1
# upx -o gorush_2 gorush
4.7M    gorush_2
```

壓縮比例也差不多 70 %，但是使用 `--brute` 處理時間蠻久的，如果要加速部署，用一般模式即可。別因為些微差異，就花費多餘時間在壓縮上。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org
 [3]: https://github.com/upx/upx
 [4]: https://github.com/appleboy/gorush