---
title: 在 appveyor 內指定 Go 語言編譯版本
author: appleboy
type: post
date: 2019-04-14T08:45:06+00:00
url: /2019/04/install-specific-go-version-in-appveyor/
dsq_thread_id:
  - 7356328059
categories:
  - Golang
tags:
  - appveyor
  - golang
  - windows

---
[![golang logo][1]][1]

相信比較少人知道 [appveyor][2] 這服務，我會接觸到此服務最大的原因是，要提供 [Windows][3] 的 Docker Image，並且上傳到 [DockrHub][4]，此服務提供了 Windows 環境，讓開發者可以透過此服務編譯 Windows 的 Binary 檔案，並且在 Windows 上執行測試，這對於我在寫 [Go 語言][5]開源專案非常有幫助，畢竟平常開發真的沒有 Windows 相關的環境可以使用。但是 appveyor 在更新[第三方套件][6]非常的慢，這時候我們想要用 GO 的 1.12 版本就需要自行來安裝，安裝方式其實也不難，請參考底下設定。

<!--more-->

[![appveyor windows][7]][7]

## 安裝指定 Go 語言版本

安裝特定版本的 Go 語言，只要自行下載 Windows msi 執行檔，接著安裝就可以了:

```yaml
environment:
  GOPATH: c:\gopath
  GO111MODULE: on
  GOVERSION: 1.12.4

install:
  # Install the specific Go version.
  - rmdir c:\go /s /q
  - appveyor DownloadFile https://storage.googleapis.com/golang/go%GOVERSION%.windows-amd64.msi
  - msiexec /i go%GOVERSION%.windows-amd64.msi /q
  - go version
  - go env
  - ps: |
      docker version
      go version
  - ps: |
      $env:Path = "c:\gopath\bin;$env:Path"
```

會碰到這個問題最主要是 Go module 在 [1.11.1 ~ 1.11.3 有個 bug][8] 就是，只要在 go.mod 內寫了 `go 1.12` 這樣此套件就會判斷目前的 Go 版本，如果小於 go1.12 就無法編譯套件，這問題在 go1.11.4 已經被解決，但是 appveyor 還停留在 go 1.11.2 版本，所以造成需要自行升級 Go 版本。有需要在 Windows 測試 GO 語言的，現在透過此方式可以編譯不同版本的環境。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://www.appveyor.com/
 [3]: https://www.microsoft.com
 [4]: https://hub.docker.com/
 [5]: https://golang.org
 [6]: https://www.appveyor.com/docs/windows-images-software/#golang
 [7]: https://lh3.googleusercontent.com/WD0ksQ8NTc1XUHsgCvpv_z6geFeeY7tPBMMuSO74igtSGRb5NpgyH6xX-d29QEdYTgcTOz94g64Dl_HBOgkfcTsZQ3Nz_4YH_2eMzKUJ1Whu2kBA6mxwpcs4R0AedOUTgT4LGbzvwBY=w1920-h1080 "appveyor windows"
 [8]: https://github.com/golang/go/issues/30446
