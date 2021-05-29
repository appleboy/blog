---
title: 用 Golang 寫 Command line 工具
author: appleboy
type: post
date: 2017-02-16T07:46:06+00:00
url: /2017/02/write-command-line-in-golang/
dsq_thread_id:
  - 5555980505
categories:
  - Docker
  - Golang
tags:
  - Docker
  - golang

---
[![][1]][1]

如果你要寫 Command line 工具，又想在各平台 (像是 MacOS, Windows 或 Linux) 上執行，這時候 [Golang][2] 就是您最好的選擇。在 [Reddit][3] 讀到一篇 [Command line 工具比較介紹][4]，這篇最主要講到兩個 CLI 工具，一個是 [urfave/cli][5]，另一個是 [spf13/cobra][6]，這兩個工具其實都非常好用，後者是[去年加入 Google Golang 團隊][7]的 [spf13][8] 所開發，該作者加入 Google 後呢，非常的忙，但是強者他同事有幫忙繼續維護 cobra 專案，兩個 CLI 工具各自都有有大型專案使用 urfave/cli 有 [docker/libcompose][9], [docker/machine][10], [Drone][11], [Gitea][12], [Gogs][13] 等，而後者 spf13/cobra 則有 [docker][14], [docker/distribution][15], [etcd][16] 等。本篇筆者會介紹 urfave/cli 該如何使用？

<!--more-->

## 用 Golang 內建 flag 套件

其實 Golang 本身就有支援 Command line 功能，只要 import `flag` 就可以直接使用了

```go
package main

import (
    "flag"
    "fmt"
    "os"
)

func main() {
    var showVersion bool

    flag.BoolVar(&showVersion, "version", false, "Print version information.")
    flag.BoolVar(&showVersion, "v", false, "Print version information.")
    flag.Parse()

    // Show version and exit
    if showVersion {
        fmt.Println("Version 1.0.0")
        os.Exit(0)
    }
}
```

存檔成 `main.go`，執行 `go build -o main` 就可以產生 main 執行檔，最後可以直接下 `./main -v` 畫面就會顯示 `Version 1.0.0`。但是如果 flag 非常多，寫起來就會相當長，也不支援讀取 Environment 環境變數，這時候我們可以透過 urfave/cli 來簡化此流程。上面的範例可以在底下連結找到

### [用 Golang flag 寫 Command Line][17]

## 使用 urfave/cli 套件

底下是一個簡單範例，可以從 command line 讀取使用者帳號密碼

```go
package main

import (
    "fmt"
    "os"

    "github.com/urfave/cli"
)

type (
    // Config information.
    Config struct {
        username string
        password string
    }
)

var config Config

func main() {
    app := cli.NewApp()
    app.Name = "Example"
    app.Usage = "Example"
    app.Action = run
    app.Flags = []cli.Flag{
        cli.StringFlag{
            Name:  "username,u",
            Usage: "user account",
        },
        cli.StringFlag{
            Name:  "password,p",
            Usage: "user password",
        },
    }

    app.Run(os.Args)
}

func run(c *cli.Context) error {
    config = Config{
        username: c.String("username"),
        password: c.String("password"),
    }

    return exec()
}

func exec() error {
    fmt.Println("username:", config.username)
    fmt.Println("password:", config.password)

    return nil
}
```

從上面例子可以發現從 `Name` 就可以定義 Flag 名稱，用逗號分格，在命令列就可以使用 `-u` 或 `--username`，也會自動幫忙產生完整的 help 畫面

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/appleboy/32888555176/in/dateposted-public/" title="Screen Shot 2017-02-16 at 2.27.11 PM"><img src="https://i0.wp.com/c1.staticflickr.com/3/2440/32888555176_31f1a78e40_z.jpg?resize=640%2C409&#038;ssl=1" alt="Screen Shot 2017-02-16 at 2.27.11 PM" data-recalc-dims="1" /></a>

## 支援環境變數

在 Golang 可以快速的將執行檔打包成 [Docker][18] Image

```bash
FROM centurylink/ca-certs

ADD main /

ENTRYPOINT ["/main"]
```

在 Dockerfile 內使用參數可以透過 `CMD` 會變成底下

```bash
FROM centurylink/ca-certs

ADD main /

ENTRYPOINT ["/main"]
CMD ["-u", "appleboy"]
```

這樣非常麻煩，這時候就要讓 CLI 也支援環境變數，將 `cli.StringFlag` 改成如下

```diff
    app.Flags = []cli.Flag{
        cli.StringFlag{
            Name:   "username,u",
            Usage:  "user account",
+           EnvVar: "DOCKER_USERNAME",
        },
        cli.StringFlag{
            Name:   "password,p",
            Usage:  "user password",
+           EnvVar: "DOCKER_PASSWORD",
        },
    }
```

直接在命令列執行 `DOCKER_USERNAME=appleboy ./main`，則就會抓到 `DOCKER_USERNAME` 環境變數，在 Docker 指令就可以補上 `-e` 參數來實現變數傳遞:

```bash
$ docker run -e DOCKER_USERNAME=appleboy appleboy/cli
```

## 結論

把 Golang 執行檔包進去 Docker Image，就可以再任意環境內執行，如果你不想使用 Docker Image 也沒關係，Golang 支援跨平台編譯，底下是支援 Windows, Linux, MacOS 編譯參數

```bash
    GOOS=linux   GOARCH=amd64 CGO_ENABLED=0 go build -o bin/main-linux
    GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o bin/main.exe
    GOOS=darwin  GOARCH=amd64 CGO_ENABLED=0 go build -o bin/main-darwin
```

自從學了 Golang，讓用 Windows 工作的同事，也可以享用 Golang 的好處。上述範例檔案可以參考底下連結

### [用 urfave/cli 寫 Command Line][19]

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org
 [3]: https://www.reddit.com
 [4]: https://www.reddit.com/r/golang/comments/5sdvoh/what_is_the_essential_difference_between/
 [5]: https://github.com/urfave/cli
 [6]: https://github.com/spf13/cobra
 [7]: http://spf13.com/post/joining-go-team-at-google/
 [8]: http://spf13.com/
 [9]: https://github.com/docker/libcompose
 [10]: https://github.com/docker/machine
 [11]: https://github.com/drone/drone
 [12]: https://gitea.io/
 [13]: https://gogs.io/
 [14]: https://docker.com
 [15]: https://github.com/docker/distribution
 [16]: https://github.com/coreos/etcd
 [17]: https://github.com/appleboy/golang-cli-example/tree/master/example01
 [18]: https://www.docker.com/
 [19]: https://github.com/appleboy/golang-cli-example/blob/master/example02