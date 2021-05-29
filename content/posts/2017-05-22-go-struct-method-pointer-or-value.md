---
title: Go 語言內 struct methods 該使用 pointer 或 value 傳值?
author: appleboy
type: post
date: 2017-05-22T02:39:06+00:00
url: /2017/05/go-struct-method-pointer-or-value/
dsq_thread_id:
  - 5838567234
categories:
  - Golang
tags:
  - golang

---
[![][1]][1]

上週末在台北講『[Go 語言基礎課程][2]』，其中一段介紹 Struct 的使用，發現有幾個學員對於在 Method 內要放 Pointer 或 Value 感到困惑，而我自己平時在寫 Go 語言也沒有注意到這點。好在強者學員 [Dboy Liao][3] 找到一篇說明:『[Don't Get Bitten by Pointer vs Non-Pointer Method Receivers in Golang][4]』，在 Go 語言如何區分 `func (s *MyStruct)` 及 `func (s MyStruct)`，底下我們先來看看簡單的 Struct 例子

```go
package main

import "fmt"

type Cart struct {
    Name  string
    Price int
}

func (c Cart) GetPrice() {
    fmt.Println(c.Price)
}

func main() {
    c := &Cart{"bage", 100}
    c.GetPrice()
}
```

<!--more-->

上面是個很簡單的 Go struct 例子，假設我們需要動態更新 Price 值，可以新增 `UpdatePrice` method。[線上執行範例][5]

```go
package main

import "fmt"

type Cart struct {
    Name  string
    Price int
}

func (c Cart) GetPrice() {
    fmt.Println("price:", c.Price)
}

func (c Cart) UpdatePrice(price int) {
    c.Price = price
}

func main() {
    c := &Cart{"bage", 100}
    c.GetPrice()
    c.UpdatePrice(200)
    c.GetPrice()
}
```

上面可以看到輸出的結果是 100，只用 value 傳值是無法改 Struce 內成員。我們可以用另外方式繞過。[線上執行範例][6]

```go
package main

import "fmt"

type Cart struct {
    Name  string
    Price int
}

func (c Cart) GetPrice() {
    fmt.Println("price:", c.Price)
}

func (c Cart) UpdatePrice(price int) *Cart {
    c.Price = price
    return &c
}

func main() {
    c := &Cart{"bage", 100}
    c.GetPrice()
    c = c.UpdatePrice(200)
    c.GetPrice()
}
```

從上面範例可以發現，將 struct 回傳，這樣就可以正確拿到修改的值。但是這解法不是我們想要的。來試試看用 Pointer 方式 [線上執行範例][7]

```go
package main

import "fmt"

type Cart struct {
    Name  string
    Price int
}

func (c Cart) GetPrice() {
    fmt.Println("price:", c.Price)
}

func (c Cart) UpdatePrice(price int) {
    fmt.Println("[value] Update Price to", price)
    c.Price = price
}

func (c *Cart) UpdatePricePointer(price int) {
    fmt.Println("[pointer] Update Price to", price)
    c.Price = price
}

func main() {
    c := &Cart{"bage", 100}
    c.GetPrice()
    c.UpdatePrice(200)
    fmt.Println(c)
    c.UpdatePricePointer(200)
    fmt.Println(c)
}
```

只要使用 pointer 方式傳值就可以正確將您需要改變的值寫入，所以這邊可以結論就是，如果只是要讀值，可以使用 Value 或 Pointer 方式，但是要寫入，則只能用 Pointer 方式。其實在 Go 語言官方有[整理 FAQ][8]，竟然之前都沒發現，參考底下官方給的建議。

### 寫入或讀取

如果您需要對 Struct 內的成員進行修改，那請務必使用 Pointer 傳值，相反的，Go 會使用 Copy struct 方式來傳入，但是用此方式你就拿不到修改後的資料。

### 效能

假設 Struct 內部成員非常的多，請務必使用 Pointer 方式傳入，這樣省下的系統資源肯定比 Copy Value 的方式還來的多。

### 一致性

在開發團隊內，如果有人使用 Pointer 有人使用 Value 方式，這樣寫法不統一，造成維護效率非常低，所以官方建議，全部使用 Pointer 方式是最好的寫法。

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: http://learning.ithome.com.tw/course/JjojzNh9P1N9H
 [3]: https://www.facebook.com/YinChenLiao?fref=nf
 [4]: https://nathanleclaire.com/blog/2014/08/09/dont-get-bitten-by-pointer-vs-non-pointer-method-receivers-in-golang/
 [5]: https://play.golang.org/p/MPU3W-qR26
 [6]: https://play.golang.org/p/sckO_D1ImM
 [7]: https://play.golang.org/p/euf_D2cE15
 [8]: https://golang.org/doc/faq#methods_on_values_or_pointers