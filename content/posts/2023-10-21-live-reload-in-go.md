---
title: "Go 語言專案開發 Hot Reload 工具 - air"
date: 2023-10-21T11:10:03+08:00
author: appleboy
type: post
slug: live-reload-in-go
share_img: /images/2023-10-21/go.png
categories:
- golang
---

![go](/images/2023-10-21/go.png)

大家都知道 [Go 語言][2]的開發環境是非常的快速，但是如果你想要在開發的時候，修改程式碼後，自動重新編譯並且執行，這時候就需要一個 Hot Reload 工具，這邊介紹一個 [air][1]，這個工具可以幫助你在開發的時候，自動重新編譯並且執行。安裝及設定方式非常簡單，不用 10 分鐘就可以打造自動編譯的開發環境。

[1]:https://github.com/cosmtrek/air/
[2]:https://go.dev/

<!--more-->

## 安裝 air 工具

由於每個人都有 Go 語言的開發環境，所以我們可以直接使用 `go install` 指令安裝 air 工具。請注意 Go 版本需要在 1.18 以上。

```bash
go install github.com/cosmtrek/air@latest
```

執行 `air -v` 指令，會看到以下的訊息。

```bash
  __    _   ___  
 / /\  | | | |_) 
/_/--\ |_| |_| \_ v1.48.0, built with Go go1.21.1
```

## 使用方式

大家在開發 Go 語言專案時候，想必大家喜歡用 go run 方式來進行開發，而我個人都是推薦編譯完後在執行。所以通常會在專案底下加入 Makefile 來進行編譯及執行。

```makefile
EXECUTABLE := ai-service
SOURCES ?= $(shell find . -name "*.go" -type f)
GO ?= go

build: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCES)
  $(GO) build -v -tags '$(TAGS)' -ldflags '$(EXTLDFLAGS)-s \
    -w $(LDFLAGS)' -o bin/$@ ./cmd/$(EXECUTABLE)
```

所以只要執行 `make build` 就可以看到在 `bin` 目錄下產生 ai-service 執行檔案。那怎麼整合 air 指令呢？只需要在 makefile 內增加底下的指令即可。

```makefile
# install air command
.PHONY: air
air:
  @hash air > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
    $(GO) install github.com/cosmtrek/air@latest; \
  fi

# run air
.PHONY: dev
dev: air
  air --build.cmd "make" --build.bin bin/ai-service
```

只要把 `--build.cmd` 跟 `--build.bin` 參數設定正確，就可以在開發時，自動編譯並且執行。

![air](/images/2023-10-21/air.png)

有更多設定可以使用 `air init` 初始化設定檔案，這邊就不多做介紹，有興趣的朋友可以參考 [air example][11] 官方文件。

[11]:https://github.com/cosmtrek/air/blob/master/air_example.toml

## 心得

air 工具非常的好用，可以幫助我們在開發時，自動編譯並且執行，不用每次都手動執行 `go run` 指令，這樣可以節省開發時間，也可以讓我們專注在開發上面，不用花太多時間在編譯上面。另外也有[繁體中文][21]的文件可以參考喔

[21]:https://github.com/cosmtrek/air/blob/master/README-zh_tw.md

![air](/images/2023-10-21/vscode.png)
