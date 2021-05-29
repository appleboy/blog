---
title: Go 語言專案程式碼品質
author: appleboy
type: post
date: 2018-09-20T01:58:00+00:00
url: /2018/09/golang-project-quality/
dsq_thread_id:
  - 6921980610
categories:
  - Golang
tags:
  - golang

---
[<img src="https://i2.wp.com/farm1.staticflickr.com/805/39050902230_b1d91bc120_z.jpg?w=840&#038;ssl=1" alt="" data-recalc-dims="1" />][1]

本篇想介紹我在寫開源專案會用到的工具及服務，其實在編譯 [Go 語言][2]同時，就已經確保了一次程式碼品質，或者是在編譯之前會跑 `go fmt` 或 `go vet` 的驗證，網路上也蠻多工具可以提供更多驗證，像是：

  * errcheck (檢查是否略過錯誤驗證)
  * unused (檢查沒用到的 func, variable or const)
  * structcheck (檢查 struct 內沒有用到的 field)
  * varcheck (拿掉沒有用到的 const 變數)
  * deadcode (沒有用到的程式碼)

但是這麼多驗證工具，要一一導入專案，實在有點麻煩，我自己在公司內部只有驗證 `go fmt` 或 `go vet` 或 [misspell-check][3] (驗證英文單字是否錯誤) 及 [vendor-check][4] (驗證開發者是否有去修改過 vendor 而沒有恢復修正)。如果你有在玩開源專案，其實可以不用這麼麻煩，導入兩套工具就可以讓你安心驗證別人發的 PR。底下來介紹一套工具及另外一套雲端服務。

<!--more-->

## 影片介紹

我錄製了一段影片介紹這兩套工具及服務，不想看本文的可以直接看影片

* * *

此影片同步在 [Udemy 課程][5]內，如果有購買課程的朋友們，也可以在 Udemy 上面觀看，如果想學習更多 Go 語言教學，現在可以透過 **$1800** 價格購買。

## [golangci.com][6] 服務

先說好這[套服務][6]對於私有專案是需要付費的，如果是開源專案，請盡情使用，目前只有支援 GitHub 上面的專案為主，不支援像是 GitLab 或 Bitbucket。對於有在寫 Go 開源專案的開發者，務必啟用這服務，此服務幫忙驗證超多檢查，請看底下

[<img src="https://i0.wp.com/farm2.staticflickr.com/1862/44793421681_3904269fcb_z.jpg?w=840&#038;ssl=1" alt="Screen Shot 2018-09-20 at 9.36.50 AM" data-recalc-dims="1" />][7]

當然不只有幫忙整合 CI/CD 的功能，還會在每個 PR 只要遇到驗證錯誤，直接會有 Bot 留言

[<img src="https://i0.wp.com/farm2.staticflickr.com/1897/43883330085_69c9627d22_z.jpg?w=840&#038;ssl=1" alt="Check_if_token_expired_in_MiddlewareFunc_by_a180285_·_Pull_Request__169_·_appleboy_gin-jwt_🔊" data-recalc-dims="1" />][8]

非常的方便，假設您的團隊有在 GitHub 使用，強烈建議導入這套服務。另外也可以進入 Repo 列表內看到詳細的錯誤清單。

[<img src="https://i0.wp.com/farm2.staticflickr.com/1896/29857249697_2257aee20f_z.jpg?w=840&#038;ssl=1" alt="Report_for_Pull_Request_appleboy_gorush_undefined_🔊" data-recalc-dims="1" />][9]

## go-critic 工具

[go-critic][10] 也是一套檢查程式碼品質的工具，只提供 CLI 方式驗證，不提供雲端整合服務，如果要導入 CI/CD 流程，請自行取用，為什麼特別介紹這套，這套工具其實是在幫助您如何寫出 Best Practice 的 Go 語言程式碼，就算你不打算用這套工具，那推薦壹定要閱讀完[驗證清單][11]，這會讓專案的程式碼品質再提升。像是寫 Bool 函式，可能會這樣命名:

```go
func Enabled() bool
```

用了此工具，會建議寫成 (是不是更好閱讀了)

```go
func IsEnabled() bool
```

還有很多驗證請自行參考，不過此工具會根據專案的大小來決定執行時間，所以我個人不推薦導入 CI/CD 流程，而是久久可以在自己電腦跑一次，一次性修改全部，這樣才不會影響部署時間。

## 心得

上面提供的兩套工具及服務，大家如果有興趣，歡迎導入，第一套雲服務我個人都用在開源專案，第二套工具，會用在公司內部專案，但是不會導入在 CI/CD 流程內。

 [1]: https://i2.wp.com/farm1.staticflickr.com/805/39050902230_b1d91bc120_z.jpg?ssl=1
 [2]: https://golang.org
 [3]: github.com/client9/misspell
 [4]: https://github.com/kardianos/govendor
 [5]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-TOP
 [6]: https://golangci.com/
 [7]: https://www.flickr.com/photos/appleboy/44793421681/in/dateposted-public/ "Screen Shot 2018-09-20 at 9.36.50 AM"
 [8]: https://www.flickr.com/photos/appleboy/43883330085/in/dateposted-public/ "Check_if_token_expired_in_MiddlewareFunc_by_a180285_·_Pull_Request__169_·_appleboy_gin-jwt_🔊"
 [9]: https://www.flickr.com/photos/appleboy/29857249697/in/dateposted-public/ "Report_for_Pull_Request_appleboy_gorush_undefined_🔊"
 [10]: https://go-critic.github.io/
 [11]: https://go-critic.github.io/overview.html