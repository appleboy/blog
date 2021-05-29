---
title: '[Go 語言教學影片] 在 struct 內的 pointers 跟 values 差異'
author: appleboy
type: post
date: 2019-05-06T07:29:36+00:00
url: /2019/05/what-is-different-between-pointer-and-value-in-golang/
dsq_thread_id:
  - 7401845305
categories:
  - Golang
tags:
  - golang

---
[![golang logo][1]][1]

[Struct Method][2] 在 [Go 語言][3]開發上是一個很重大的功能，而新手在接觸這塊時，通常會搞混為什麼會在 function 內的 struct name 前面多一個 `*` pointer 符號，而有時候又沒有看到呢？以及如何用 struct method 實現 Chain 的實作，本影片會實際用寄信當作範例講解什麼時候該用 `pointer` 什麼時候該用用 `Value`。也可以參考我之前的一篇文章『[Go 語言內 struct methods 該使用 pointer 或 value 傳值?][4]』

<!--more-->

## 教學影片

{{< youtube 36X8uf7AxOg >}}

## 範例

要區別 pointer 跟 value 可以透過下面的例子快速了解:

```go
package main

import "fmt"

type car struct {
    name  string
    color string
}

func (c *car) SetName01(s string) {
    fmt.Printf("SetName01: car address: %p\n", c)
    c.name = s
}

func (c car) SetName02(s string) {
    fmt.Printf("SetName02: car address: %p\n", &c)
    c.name = s
}

func main() {
    toyota := &car{
        name:  "toyota",
        color: "white",
    }

    fmt.Printf("car address: %p\n", toyota)

    fmt.Println(toyota.name)
    toyota.SetName01("foo")
    fmt.Println(toyota.name)
    toyota.SetName02("bar")
    fmt.Println(toyota.name)
    toyota.SetName02("test")
    fmt.Println(toyota.name)
}
```

上面範例可以看到如果是透過 `SetName02` 來設定最後是拿不到設定值，這就代表使用 `SetName02` 時候，是會將整個 struct 複製一份。假設 struct 內有很多成員，這樣付出的代價就相對提高。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080 "golang logo"
 [2]: https://gobyexample.com/methods
 [3]: https://golang.org
 [4]: https://blog.wu-boy.com/2017/05/go-struct-method-pointer-or-value/
