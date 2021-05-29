---
title: 如何使用 Go 語言 Flag 套件 (影片教學)
author: appleboy
type: post
date: 2018-04-12T03:17:25+00:00
url: /2018/04/how-to-use-golang-flag-package/
dsq_thread_id:
  - 6608813820
categories:
  - Golang

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1622/24407557644_36087ca6de.jpg?w=840&#038;ssl=1" alt="Go-brown-side.sh" data-recalc-dims="1" />][1] 之前寫過一篇『[用 Golang 寫 Command line 工具][2]』教學，作者我錄了一個教學影片，教大家如何使用 [Go 語言][3]的 [Flag][4] 套件，套件用法很簡單，相信看了底下的影片教學馬上就會了，但是在這邊強調，用 flag 的時機會是在寫 command line tool 給同事或者是自己用，如果是寫大型 Web Application，不推薦使用 flag，原因是 flag 不支援讀取系統環境變數，如果是 web 服務，想要動態改變 port 或者是 DB 連線資訊，就變得比較複雜，也無法搭配 [Docker][5] 使用，更不用說想結合 [Kubernetes][6]。如果要寫大專案，請使用 [urfave/cli][7] 或 [spf13/cobra][8]。 <!--more-->

### 線上課程 有興趣的話，可以直接

[購買課程][9]，現在特價 $1600，未來會漲價，另外課程尚未錄製完成，會陸陸續續分享 Go 的開發技巧。

 [1]: https://www.flickr.com/photos/appleboy/24407557644/in/dateposted-public/ "Go-brown-side.sh"
 [2]: https://blog.wu-boy.com/2017/02/write-command-line-in-golang/
 [3]: https://golang.org
 [4]: https://golang.org/pkg/flag/
 [5]: https://www.docker.com/
 [6]: https://kubernetes.io/
 [7]: https://github.com/urfave/cli
 [8]: https://github.com/spf13/cobra
 [9]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-INTRO