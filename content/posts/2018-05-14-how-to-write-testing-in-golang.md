---
title: 如何在 Go 專案內寫測試
author: appleboy
type: post
date: 2018-05-14T03:19:28+00:00
url: /2018/05/how-to-write-testing-in-golang/
dsq_thread_id:
  - 6669588673
categories:
  - Golang
tags:
  - golang
  - Testing

---
[<img src="https://i1.wp.com/farm2.staticflickr.com/1622/24407557644_36087ca6de.jpg?w=840&#038;ssl=1" alt="Go-brown-side.sh" data-recalc-dims="1" />][1]

相信大家都知道專案內不導入測試，未來越來越多功能，技術債就會越來越多，接手的人罵聲連連，而寫測試的簡單與否決定專案初期是否要先導入。為什麼專案要導入測試，導入測試有什麼好處，對於團隊而言，導入測試好處實在太多了，底下列了幾點是我個人覺得非常重要的。

  1. 減少 Review 時間
  2. 降低修改程式碼產生的的錯誤
  3. 確保程式碼品質

第一點非常實用，尤其在專案很忙的時候，同事間只有少許的時間可以幫忙看程式碼或討論，如果大家都有寫測試，在時間的壓力下，只要稍微看一下，CI/CD 驗證過無誤，大致上就可以上線了。第二點在於，團隊其他成員需要修改一個不確定的地方，商業邏輯修正可能會造成很大的錯誤，而測試在這時候就發揮效果。最後一點就是程式碼品質，不管是新功能，或者是 Bug，任何時間點都需要補上測試，就算 code coverage 已經很高了，但是只要有任何 bug 就要補測試，測試寫的越多，專案的品質相對會提高。在 Go 語言專案內該如何寫測試了，為什麼專案要導入 Go 語言的原因之一就是『寫測試太簡單』了，底下來介紹如何寫基本的測試。

<!--more-->

## 內建 testing 套件

在 Go 語言內，不需要而外安裝任何第三方套件就可以開使寫測試，首先該將測試放在哪個目錄內呢？不需要建立特定目錄來存放測試程式碼，而是針對每個 Go 的原始檔案，建立一個全新測試檔案，並且檔名最後加上 `_test` 就可以了，假設程式碼為 `car.go` 那麼測試程式就是 `car_test.go`，底下舉個[範例][2]

```go
package car

import "errors"

// Car struct
type Car struct {
  Name  string
  Price float32
}

// SetName set car name
func (c *Car) SetName(name string) string {
  if name != "" {
    c.Name = name
  }

  return c.Name
}

// New Object
func New(name string, price float32) (*Car, error) {
  if name == "" {
    return nil, errors.New("missing name")
  }

  return &Car{
    Name:  name,
    Price: price,
  }, nil
}
```

驗證上面的程式碼可以建立 `car_test.go`，並且寫下[第一個測試程式][3]：

```go
// Simple testing what different between Fatal and Error
func TestNew(t *testing.T) {
  c, err := New("", 100)
  if err != nil {
    t.Fatal("got errors:", err)
  }

  if c == nil {
    t.Error("car should be nil")
  }
}
```

首先 func 名稱一定要以 `Test` 作為開頭，而 Go 內建 testing 套件，可以使用簡易的 t.Fatal 或 t.Error 來驗證錯誤，這兩個的差異在於 t.Fatal 會中斷測試，而 t.Error 不會，簡單來說，假設您需要整個完整測試後才顯示錯誤，那就需要用 t.Error，反之就使用 t.Fatal 來中斷測試。

## 使用 testify 套件

這邊只會介紹一個第三方套件那就是 [testify][4]，裡面內建很多好用的測試等大家發掘，底下用簡單的 assert 套件來修改上方的[測試程式][5]:

```go
func TestNewWithAssert(t *testing.T) {
  c, err := New("", 100)
  assert.NotNil(t, err)
  assert.Error(t, err)
  assert.Nil(t, c)

  c, err = New("foo", 100)
  assert.Nil(t, err)
  assert.NoError(t, err)
  assert.NotNil(t, c)
  assert.Equal(t, "foo", c.Name)
}
```

有沒有看起來比較簡潔。這邊測試用的 command，也可以針對單一函式做測試。

```bash
go test -v -run=TestNewWithAssert ./example18-write-testing-and-doc/...
```

可以看到 `-run` 讓開發者可以針對單一函式做測試，對於大型專案來說非常方便，假設修正完 bug，並且寫了測試，就可以針對單一函式做測試，這點 Go 做得相當棒。

## 平行測試

講平行測試之前，跟大家講個用 vscode 編輯器寫測試的一個小技巧，就是透過 vscode 可以幫忙產生測試程式碼，該如何使用呢？可以先將要測試的函式全選，然後按下 `command` + `shift` + `p`，就會出現底下命令列選擇。

[<img src="https://i1.wp.com/farm1.staticflickr.com/830/42094339161_964d38f4cf_z.jpg?w=840&#038;ssl=1" alt="Snip20180514_2" data-recalc-dims="1" />][6]

這邊為什麼要平行測試呢？原因是單一函式測試，假設一個情境需要執行時間為 0.5 秒，那麼假設寫了 10 種狀況，就需要 10 * 0.5 秒，這樣花費太久了。這時候就需要請 Go 幫忙做平行測試。先看看底下範例:

```go
func TestCar_SetName(t *testing.T) {
  type fields struct {
    Name  string
    Price float32
  }
  type args struct {
    name string
  }
  tests := []struct {
    name   string
    fields fields
    args   args
    want   string
  }{
    {
      name: "no input name",
      fields: fields{
        Name:  "foo",
        Price: 100,
      },
      args: args{
        name: "",
      },
      want: "foo",
    },
    {
      name: "input name",
      fields: fields{
        Name:  "foo",
        Price: 100,
      },
      args: args{
        name: "bar",
      },
      want: "bar",
    },
  }
  for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
      c := &Car{
        Name:  tt.fields.Name,
        Price: tt.fields.Price,
      }
      if got := c.SetName(tt.args.name); got != tt.want {
        t.Errorf("Car.SetName() = %v, want %v", got, tt.want)
      }
    })
  }
}
```

上面範例跑了兩個測試，一個是沒有 input value，一個則是有 input，根據 for 迴圈會依序執行測試，其中裡面的 `t.Run` 是指 sub test，如下圖

[<img src="https://i1.wp.com/farm1.staticflickr.com/962/41375173154_b9bb7bd422_z.jpg?w=840&#038;ssl=1" alt="Snip20180514_3" data-recalc-dims="1" />][7]

上述的程式碼都是 vscode 幫忙產生的，開發者只需要把測試資料補上就可以了。假設有 10 個情境需要測試，那該如何讓 Go 幫忙平行測試呢？請使用 `t.Parallel()`

```go
  for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
      t.Parallel()
      c := &Car{
        Name:  tt.fields.Name,
        Price: tt.fields.Price,
      }
      if got := c.SetName(tt.args.name); got != tt.want {
        t.Errorf("Car.SetName() = %v, want %v", got, tt.want)
      }
    })
  }
```

在 `t.Run` 的 callback 測試內補上 `t.Parallel()` 就可以了喔。寫到這邊，大家應該可以看出一個問題，就是平行測試的內容怎麼都會是測試同一個情境，也就是本來要測試 10 種情境，但是會發現 Go 把最後一個情境同時跑了 10 次？這邊的問題點出在哪邊，請大家注意 `tt` 變數，由於跑平行測試，那麼 for 迴圈最後一次就會蓋掉之前的所有 tt 變數，要修正此狀況也非常容易，在迴圈內重新宣告一次即可 `tt := tt`

```go
  for _, tt := range tests {
    tt := tt
    t.Run(tt.name, func(t *testing.T) {
      t.Parallel()
      c := &Car{
        Name:  tt.fields.Name,
        Price: tt.fields.Price,
      }
      if got := c.SetName(tt.args.name); got != tt.want {
        t.Errorf("Car.SetName() = %v, want %v", got, tt.want)
      }
    })
  }
```

## 感想

本篇尚未寫到『整合性測試』也就是該如何搭配 Database 進行資料庫測試，會在開新的一篇做介紹。本文內容也有錄製影片放在 Udemy 上面，如果覺得寫的不錯，也可以參考我的教學影片。

# [直接購買線上影片][8]

 [1]: https://www.flickr.com/photos/appleboy/24407557644/in/dateposted-public/ "Go-brown-side.sh"
 [2]: https://github.com/go-training/training/blob/79ae76dd120c39949d99b4fcb69d692880200ad4/example18-write-testing-and-doc/car.go#L1
 [3]: https://github.com/go-training/training/blob/79ae76dd120c39949d99b4fcb69d692880200ad4/example18-write-testing-and-doc/car_test.go#L9-L19
 [4]: https://github.com/stretchr/testify
 [5]: https://github.com/go-training/training/blob/26970ef05d9cb438b0522f961493863b3628d0c2/example18-write-testing-and-doc/car_test.go#L21-L33
 [6]: https://www.flickr.com/photos/appleboy/42094339161/in/dateposted-public/ "Snip20180514_2"
 [7]: https://www.flickr.com/photos/appleboy/41375173154/in/dateposted-public/ "Snip20180514_3"
 [8]: https://www.udemy.com/golang-fight/?couponCode=GOLANG-INTRO
