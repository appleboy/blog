---
title: "Go 語言內 new 跟 make 使用時機"
date: 2021-06-08T08:51:18+08:00
author: appleboy
type: post
url: /2021/06/what-is-different-between-new-and-make-in-golang/
share_img: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
categories:
  - Golang
tags:
  - golang
---

![logo](https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080)

大家接觸 Go 語言肯定對 `new` 跟 `make` 不陌生，但是什麼時候要使用 `new` 什麼時候用 `make`，也許是很多剛入門的開發者比較不懂，本篇就簡單筆記 `new` 跟 `make` 的差異及使用時機。

<!--more-->

## 使用 new 關鍵字

Go 提供兩種方式來分配記憶體，一個是 `new` 另一個是 `make`，這兩個關鍵字做的事情不同，應用的類型也不同，可能會造成剛入門的朋友一些混淆，但是這兩個關鍵字使用的規則卻很簡單，先來看看如何使用 `new` 關鍵字。`new(T)` 宣告會直接拿到儲存位置，並且配置 Zero Value (初始化)，也就是數字型態為 `0`，字串型態就是 `""`。底下是[範例程式](https://play.golang.org/p/4e933UXThtK)

```go
package main

import "fmt"

func main() {
  foo := new(int)
  fmt.Println(foo)
  fmt.Println(*foo)
  fmt.Printf("%#v", foo)
}
```

執行後可以看到底下結果

```bash
$ go run main.go 
0xc00001a110
0
(*int)(0xc00001a110)
```

上面的做法比較少人用，比較多人用在 `struct` 上面，由於 `new` 的特性，直接可以用在 `struct` 做初始化，底下是[範例程式](https://play.golang.org/p/xM1k5zi6OJ1)

```go
package main

import (
  "bytes"
  "fmt"
  "sync"
)

type SyncedBuffer struct {
  lock   sync.Mutex
  buffer bytes.Buffer
  foo    int
  bar    string
}

func main() {
  p := new(SyncedBuffer)
  fmt.Println("foo:", p.foo)
  fmt.Println("bar:", p.bar)
  fmt.Printf("%#v\n", p)
}
```

上面可以看到透過 `new` 快速的達到初始化，但是有個不方便的地方就是，如果開發者要塞入特定的初始化值，透過 `new` 是沒辦法做到的，所以大多數的寫法會改成如下，[範例連結](https://play.golang.org/p/tLyY-TKsloc)

```go
package main

import (
  "bytes"
  "fmt"
  "sync"
)

type SyncedBuffer struct {
  lock   sync.Mutex
  buffer bytes.Buffer
  foo    int
  bar    string
}

func main() {
  p := &SyncedBuffer{
    foo: 100,
    bar: "foobar",
  }
  fmt.Println("foo:", p.foo)
  fmt.Println("bar:", p.bar)
  fmt.Printf("%#v\n", p)
}
```

或者是大部分會寫一個新的 Func 做初始化設定，[範例程式](https://play.golang.org/p/hgEWKNdiwqC)如下

```go
package main

import (
  "bytes"
  "fmt"
  "sync"
)

type SyncedBuffer struct {
  lock   sync.Mutex
  buffer bytes.Buffer
  foo    int
  bar    string
}

func NewSynced(foo int, bar string) *SyncedBuffer {
  return &SyncedBuffer{
    foo: foo,
    bar: bar,
  }
}

func main() {
  p := NewSynced(100, "foobar")
  fmt.Println("foo:", p.foo)
  fmt.Println("bar:", p.bar)
  fmt.Printf("%#v\n", p)
}
```

但是 `new` 如果使用在 `slice`, `map` 及 `channel` 身上的話，其初始的 Value 會是 `nil`，請看底下[範例](https://play.golang.org/p/EAEIPcKKWjJ)：

```go
package main

import (
  "fmt"
)

func main() {
  p := new(map[string]string)
  test := *p
  test["foo"] = "bar"
  fmt.Println(test)
}
```

底下結果看到 panic

```bash
$ go run main.go 
panic: assignment to entry in nil map

goroutine 1 [running]:
main.main()
        /app/main.go:10 +0x4f
exit status 2
```

初始化 `map` 拿到的會是 `nil`，故通常在宣告 `slice`, `map` 及 `channel` 則會使用 Go 提供的另一個宣告方式 `make`。

## 使用 make 關鍵字

`make` 與 `new` 不同的地方在於，new 回傳指標，而 `make` 不是，`make` 通常只用於在宣告三個地方，分別是 `slice`, `map` 及 `channel`，如果真的想要拿到指標，建議還是用 `new` 方式。底下拿 [map 當作範例](https://play.golang.org/p/_ITcvotyjn1)

```go
package main

import "fmt"

func main() {
  var p *map[string]string
  // new
  p = new(map[string]string)
  *p = map[string]string{
    "bar": "foo",
  }
  people := *p
  people["foo"] = "bar"

  fmt.Println(people)
  fmt.Println(p)

  // make
  foobar := make(map[string]string)
  foobar["foo"] = "bar"
  foobar["bar"] = "foo"
  fmt.Println(foobar)
}
```

上面例子可以看到 p 宣告為 map 指標，new 初始化 map 後則需要獨立寫成 `map[string]string{}`，才可以正常運作，如果是透過 `make` 方式就可以快速宣告完成。通常是這樣，我自己在開發，幾乎很少用到 `new`，反到是在宣告 `slice`, `map` 及 `channel` 時一定會使用到 `make`。記住，用 `make` 回傳的不會是指標，真的要拿到指標，請使用 `new` 的方式，但是程式碼就會變得比較複雜些。

## 心得

總結底下 `make` 跟 `new` 的區別

* `make` 能夠分配並且初始化所需要的記憶體空間跟結構，而 `new` 只能回傳指標位置
* `make` 只能用在三種類型 `slice`, `map` 及 `channel`
* `make` 可以初始化上述三種格式的長度跟容量以便提供效率跟減少開銷

## 參考文章

* [Allocation with new](https://golang.org/doc/effective_go#allocation_new)
* [Allocation with make](https://golang.org/doc/effective_go#allocation_make)
