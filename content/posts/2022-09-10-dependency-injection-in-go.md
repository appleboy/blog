---
title: "用 Google 團隊推出的 Wire 工具解決 Dependency Injection"
date: 2022-09-10T13:17:01+08:00
author: appleboy
type: post
slug: dependency-injection-in-go
share_img: https://i.imgur.com/j7KDYk4.png
categories:
  - Golang
tags:
  - golang
  - dependency injection
---

![proposal](https://i.imgur.com/DZOA6zy.png)

不知道大家在用 [Go 語言][11]寫服務的時候，會不會遇到 Components 會有相互依賴的關係，A 物件依賴 B 物件，B 物件又依賴 C 物件，所以在初始化 A 物件前，就必須先將 B 跟 C 初始化完成，這就是錯綜復雜的關係。也許大家會想到另一個做法，就是把每個物件都宣告成**全域變數**，我個人不推薦這個使用方式，雖然很方便，但是就會讓整體架構變得很複雜。而本篇要介紹一個救星工具，就是 Google 團隊開發的 [Wire][1] 工具，官方部落格也可以[參考看看][2]。此工具就是為了解決底下兩個問題 ([dependency injection][3])。

1. Components 互相依賴錯綜復雜的關係
2. 不要宣告全域變數

[1]:https://github.com/google/wire
[2]:https://blog.golang.org/wire
[3]:https://en.wikipedia.org/wiki/Dependency_injection
[11]:https://go.dev

<!--more-->

## 教學影片

{{< youtube iYOYOAEVsRw >}}

```sh
00:00 Dependency Injection 是什麼
00:23 模組相依性產生的問題
02:09 用程式碼講解問題出在哪邊
05:29 撰寫 wire.go 代碼，宣告 application struct
06:52 撰寫 inject_router.go
07:49 撰寫 inject_user.go
09:06 產生 wire_gen.go 代碼
10:36 安裝 wire 工具
11:17 wire_gen.go 內容是什麼
12:23 如何簡化 main.go 內容
14:04 如何再次修改 dependency
```

其他線上課程請參考如下

* [Docker 容器實戰](https://blog.wu-boy.com/docker-course/)
* [Go 語言課程](https://blog.wu-boy.com/golang-online-course/)

## 模組依賴問題

底下所有程式碼都可以在[這邊找到](https://github.com/go-training/training/tree/master/example49-dependency-injection)。

![proposal](https://i.imgur.com/j7KDYk4.png)

大家參考上面這張圖，開發者想要在 `main.go` 內宣告 User 的 struct，就會需要一層一層依賴，所以代碼會寫成如下

```go
cfg, err := config.Environ()
if err != nil {
 log.Fatal().
   Err(err).
   Msg("invalid configuration")
}

c, err := cache.New(cfg)
if err != nil {
 log.Fatal().
   Err(err).
   Msg("invalid configuration")
}

l, err := ldap.New(cfg, c)
if err != nil {
 log.Fatal().
   Err(err).
   Msg("invalid configuration")
}

cd, err := crowd.New(cfg, c)
if err != nil {
 log.Fatal().
   Err(err).
   Msg("invalid configuration")
}

u, err := user.New(l, cd, c)
if err != nil {
 log.Fatal().
   Err(err).
   Msg("invalid configuration")
}

if ok := u.Login("test", "test"); !ok {
  log.Fatal().
    Err(err).
    Msg("invalid configuration")
}

m := graceful.NewManager()
srv := &http.Server{
  Addr:              cfg.Server.Port,
  Handler:           router.New(cfg, u),
  ReadHeaderTimeout: 5 * time.Second,
  ReadTimeout:       5 * time.Minute,
  WriteTimeout:      5 * time.Minute,
  MaxHeaderBytes:    8 * 1024, // 8KiB
}
```

上述代碼大家可以想一下，如果是幾 10 個 Components 寫起來就會更加複雜。其實我們在主程式內只有用到 `user` 跟 `router` 而已，光是宣告其他 component 就寫了一堆代碼，我們是否可以將代碼優化成一個 struct

```go
type application struct {
  router http.Handler
  user   *user.Service
}

func newApplication(
  router http.Handler,
  user *user.Service,
) *application {
  return &application{
    router: router,
    user:   user,
  }
}
```

這樣只要宣告 application 中間的 dependency 都透過 wire 幫忙處理。

## 使用 Wire 工具

```go
func newApplication(
  router http.Handler,
  user *user.Service,
) *application {
  return &application{
    router: router,
    user:   user,
  }
}
```

要讓 wire 工具可以知道上面全部的依賴關係，先建立一個初始化函式，注意 `wireinject` 這個 build 標籤是不能拿掉的，這是給 wire CLI 工具辨認用的。

```go
//go:build wireinject
// +build wireinject

package main

import (
  "github.com/go-training/example49-dependency-injection/config"

  "github.com/google/wire"
)

func InitializeApplication(cfg config.Config) (*application, error) {
  wire.Build(
    routerSet,
    userSet,
    newApplication,
  )
  return &application{}, nil
}
```

大家可以看到我們需要告知 wire 工具，router, user 及 newApplication 的關係，所以在分別建立 `inject_router.go` 跟 `inject_user.go` 兩個檔案，先看看 router 部分

```go
var routerSet = wire.NewSet( //nolint:deadcode,unused,varcheck
  provideRouter,
)

func provideRouter(
  cfg config.Config,
  user *user.Service,
) http.Handler {
  return router.New(cfg, user)
}
```

這邊只有依賴 config 跟 user 兩物件並回傳 http.Handler，接下來 user 部分

```go
var userSet = wire.NewSet( //nolint:deadcode,unused,varcheck
  provideUser,
  provideLDAP,
  provideCROWD,
  provideCache,
)

func provideUser(
  l *ldap.Service,
  c *crowd.Service,
  cache *cache.Service,
) (*user.Service, error) {
  return user.New(l, c, cache)
}

func provideLDAP(
  cfg config.Config,
  cache *cache.Service,
) (*ldap.Service, error) {
  return ldap.New(cfg, cache)
}

func provideCROWD(
  cfg config.Config,
  cache *cache.Service,
) (*crowd.Service, error) {
  return crowd.New(cfg, cache)
}

func provideCache(
  cfg config.Config,
) (*cache.Service, error) {
  return cache.New(cfg)
}
```

user 依賴了 cache, ldap 跟 crowd 三個物件，完成後就可以透過 wire 指令產生 `wire_gen.go` 檔案

```sh
wire gen ./...
```

打開 `wire_gen.go`

```go
func InitializeApplication(cfg config.Config) (*application, error) {
  service, err := provideCache(cfg)
  if err != nil {
    return nil, err
  }
  ldapService, err := provideLDAP(cfg, service)
  if err != nil {
    return nil, err
  }
  crowdService, err := provideCROWD(cfg, service)
  if err != nil {
    return nil, err
  }
  userService, err := provideUser(ldapService, crowdService, service)
  if err != nil {
    return nil, err
  }
  handler := provideRouter(cfg, userService)
  mainApplication := newApplication(handler, userService)
  return mainApplication, nil
}
```

可以看到透過我們自己定義的 `provide` 前綴的函式，wire 工具自動幫我們把相依信都處理完畢，所以這工具讓你在主程式內把所以相依性都處理完畢，不要再使用**全域變數**了。

## 心得

除了使用在 main 函式，還可以用在測試上面，測試也是要把依賴性都處理完畢，這樣才方便測試。相信大家處理依賴性肯定會遇到這問題。好的做法就是不要在 package 內宣告其他 package 的設定，這樣會非常難維護，畢竟一開始把所有的物件都初始化完畢，除錯的時候會相對容易。程式碼可以[這邊觀看](https://github.com/go-training/training/tree/master/example49-dependency-injection)。
