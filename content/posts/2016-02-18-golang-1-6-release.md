---
title: Golang 發佈 1.6 正式 Release
author: appleboy
type: post
date: 2016-02-18T02:12:59+00:00
url: /2016/02/golang-1-6-release/
dsq_thread_id:
  - 4588997049
categories:
  - Golang
tags:
  - golang

---
[![][1]][1]

今天 [golang][2] 正式[發佈 1.6 版本][3]，趕快到[官方網站下載][4]使用，如果你是用 [gvm][5]，直接下 `gvm install go1.6` 即可。golang wiki 提供了很多 [Package Management Tools][6]，可以隨意選一套來使用。底下整理幾點 1.6 的改變：

## 重大改變

  * 正式支援 [HTTP/2][7] 協定，跑 https 會預設[啟動 HTTP/2][8]
  * Go 1.5 介紹了[實驗性質的 vendor][9]，在 1.6 還是會支援 `GO15VENDOREXPERIMENT` 變數，但是預設值為 1，在 1.7 會正式將此變數拿掉
  * 預設用 [cgo][10] 來編譯分享 golang 指標與 C 之間溝通
  * 支援 [Linux on 64-bit MIPS 和 Android on 32-bit x86][11] 架構
  * 在 [FreeBSD][12] 上面預設使用 [clang][13] 而不是 [gcc][14]

## 效能議題

官方說無從比較，有些程式碼可能在 1.6 比較快，也有可能在 1.5 會比較快，但是在 garbage collector 上面 1.6 會比 1.5 好，前提是程式使用了大量的記憶體，1.6 版本也針對蠻多 package 做了 Performance 改善，提升了至少 10 % 喔 [compress/bzip2][15], [compress/gzip][16], [crypto/aes][17], [crypto/elliptic][18], [crypto/ecdsa][19], 和 [sort][20] 套件。

更詳細的 1.6 釋出文件，可以直接參考[這邊][21]

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org
 [3]: http://blog.golang.org/go1.6
 [4]: https://golang.org/dl/
 [5]: https://github.com/moovweb/gvm
 [6]: https://github.com/golang/go/wiki/PackageManagementTools
 [7]: https://http2.github.io/
 [8]: https://golang.org/doc/go1.6#http2
 [9]: https://golang.org/s/go15vendor
 [10]: https://golang.org/doc/go1.6#cgo
 [11]: https://golang.org/doc/go1.6#ports
 [12]: https://www.freebsd.org/
 [13]: http://clang.llvm.org/
 [14]: https://gcc.gnu.org/
 [15]: https://golang.org/pkg/compress/bzip2/
 [16]: https://golang.org/pkg/compress/gzip/
 [17]: https://golang.org/pkg/crypto/aes/
 [18]: https://golang.org/pkg/crypto/elliptic/
 [19]: https://golang.org/pkg/crypto/ecdsa/
 [20]: https://golang.org/pkg/sort/
 [21]: https://golang.org/doc/go1.6