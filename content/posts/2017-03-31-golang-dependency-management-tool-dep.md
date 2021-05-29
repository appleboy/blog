---
title: Go 語言官方推出的 dep 使用心得
author: appleboy
type: post
date: 2017-03-31T01:58:01+00:00
url: /2017/03/golang-dependency-management-tool-dep/
dsq_thread_id:
  - 5682264779
categories:
  - Golang
tags:
  - golang

---
[![][1]][1]

[Go][2] 語言團隊在去年開始開發 Dependency Management Tool 稱作 [dep][3]，並且預計明年 2018 推出 1.10 Go 版本時內建，詳細可以參考官方的 [roadmap][4]，強者我朋友寫了一篇[使用教學][5]，有興趣的朋友可以參考看看，但是本篇會講幾點我目前不打算用 dep 的原因。

<!--more-->

## dep ensure 預設是抓 $GOPATH 的路徑

dep init 或 dep ensure 預設會先去掃 `$GOPATH` 底下是否存在您所需要的 Package 原始碼，如果有，預設就會去抓到 vendor 目錄，但是這點對開發者很困擾，在 $GOPATH 底下的專案都不是最新的，有時候自己還會去修改自己開發的 Package，這樣造成開發者還要下一次指令去更新 vendor 套件 (請加上 `-update` 參數)。

## 不支援抓 sub package.

其他 Dependency tool 幾乎都有支援抓 sub package，像是 [govendor][6] 或 [glide][7]

```bash
govendor fetch github.com/joho/godotenv/autoload
```

上面指令只會抓 [godotenv][8] 內的 [autoload package][9] 原始碼，跟 autoload 無關的一律不抓，但是在 dep 只能能抓 godotenv 全部資料，不支援底下寫法，會直接報錯

```bash
dep ensure github.com/joho/godotenv/autoload
```

## dep 預設抓不相關的檔案到 vendor

dep 預設會抓非 .go 或者是不相關的檔案到 vendor 目錄，像是 `.travis.yml` 另外也把 `_test.go` 也一起抓進來，造成整個 venodr 有點肥。相對像是 govendor 只會抓專案會用到的 `*.go` 或 `License` 檔案，所以在 vendor 目錄底下相對看起來蠻清楚的。

## 結論

綜合上面三點，我個人不推薦現在使用 dep，非常不穩定，未來官方還會修正 .json 或 .lock 檔案格式，現在要決定的話，我會等到年底或者是明年初再開始使用，大部份的 Open Source 專案還是都是使用 govendor 或 glide ...等相對穩定的工具。我個人推薦 govendor 啦。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org/
 [3]: https://github.com/golang/dep
 [4]: https://github.com/golang/dep/wiki/Roadmap
 [5]: https://github.com/kevingo/dep-example
 [6]: https://github.com/kardianos/govendor
 [7]: https://github.com/Masterminds/glide
 [8]: https://github.com/joho/godotenv
 [9]: https://github.com/joho/godotenv/tree/master/autoload