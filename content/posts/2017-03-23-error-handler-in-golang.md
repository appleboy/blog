---
title: Go 語言的錯誤訊息處理
author: appleboy
type: post
date: 2017-03-23T07:25:00+00:00
url: /2017/03/error-handler-in-golang/
dsq_thread_id:
  - 5657464176
categories:
  - Golang
tags:
  - Error
  - Go
  - golang

---
[![][1]][1]

每個語言對於錯誤訊息的處理方式都不同，在學習每個語言時，都要先學會如何在程式內處理錯誤訊息 (Error Handler)，而在 [Go 語言][2]的錯誤處理是非常簡單，本篇會用簡單的範例教大家 Go 如何處理錯誤訊息。

<!--more-->

## Go 輸出錯誤訊息

在 Go 語言內有兩種方式讓函示 (function) 可以回傳錯誤訊息，一種是透過 `errors` 套件或 `fmt` 套件，先看看 errors 套件使用方式:

```go
package main

import (
    "errors"
    "fmt"
)

func isEnable(enable bool) (bool, error) {
    if enable {
        return false, errors.New("You can't enable this setting")
    }

    return true, nil
}

func main() {
    if _, err := isEnable(true); err != nil {
        fmt.Println(err.Error())
    }
}
```

請先引入 errors 套件，接著透過 `errors.New("message here")`，就可以實現 error 錯誤訊息。接著我們打開 errors package 原始碼來看看

```go
package errors

// New returns an error that formats as the given text.
func New(text string) error {
    return &errorString{text}
}

// errorString is a trivial implementation of error.
type errorString struct {
    s string
}

func (e *errorString) Error() string {
    return e.s
}
```

可以發現 errors 套件內提供了 `New` 函示，讓開發者可以直接建立 error 物件，並且實現了 error interface。在 Go 語言有定義 error interface 為:

```go
type error interface {
    Error() string
}
```

只要任何 `stuct` 有實作 `Error()` 接口，就可以變成 error 物件。這在下面的自訂錯誤訊息會在提到。除了上面使用 errors 套件外，還可以使用 fmt 套件，將上述程式碼改成:

```go
func isEnable(enable bool) (bool, error) {
    if enable {
        return false, fmt.Errorf("You can't enable this setting")
    }

    return true, nil
}
```

這樣也可以成功輸出錯誤訊息，請深入看 `fmt.Errorf` 為

```go
// Errorf formats according to a format specifier and returns the string
// as a value that satisfies error.
func Errorf(format string, a ...interface{}) error {
    return errors.New(Sprintf(format, a...))
}
```

你可以發現在 fmt 套件內，引用了 errors 套件，所以基本上本質是一樣的。

## Go 錯誤訊息測試

在 Go 語言如何測試錯誤訊息，直接引用 `testing` 套件

```go
package error

import "testing"

func TestIsMyError(t *testing.T) {
    ok, err := isEnable(true)

    if ok {
        t.Fatal("should be false")
    }

    if err.Error() != "You can't enable this setting" {
        t.Fatal("message error")
    }
}
```

另外 Go 語言最常用的測試套件 [Testify][3]，可以改寫如下:

```go
package error

import (
    "testing"

    "github.com/stretchr/testify/assert"
)

func TestIsEnable(t *testing.T) {
    ok, err := isEnable(true)
    assert.False(t, ok)
    assert.NotNil(t, err)
    assert.Equal(t, "You can't enable this setting", err.Error())
}
```

## Go 自訂錯誤訊息

從上面的例子可以看到，錯誤訊息都是固定的，如果我們要動態改動錯誤訊息，就必須帶變數進去。底下我們來看看如何實現自訂錯誤訊息:

```go
package main

import (
    "fmt"
)

// MyError is an error implementation that includes a time and message.
type MyError struct {
    Title   string
    Message string
}

func (e MyError) Error() string {
    return fmt.Sprintf("%v: %v", e.Title, e.Message)
}

func main() {
    err := MyError{"Error Title 1", "Error Message 1"}
    fmt.Println(err)

    err = MyError{
        Title:   "Error Title 2",
        Message: "Error Message 2",
    }
    fmt.Println(err)
}
```

也可以把錯誤訊息包成 Package 方式

```go
package error

import (
    "fmt"
)

// MyError is an error implementation that includes a time and message.
type MyError struct {
    Title   string
    Message string
}

func (e MyError) Error() string {
    return fmt.Sprintf("%v: %v", e.Title, e.Message)
}
```

在 `main.go` 就可以直接引用 `error` 套件

```go
package main

import (
    "fmt"

    my "github.com/go-training/training/example04/error"
)

func main() {
    err := my.MyError{"Error Title 1", "Error Message 1"}
    fmt.Println(err)

    err = my.MyError{
        Title:   "Error Title 2",
        Message: "Error Message 2",
    }
    fmt.Println(err)
}
```

如何測試錯誤訊息是我們自己所定義的呢？請在 error 套件內加入底下測試函示

```go
func IsMyError(err error) bool {
    _, ok := err.(MyError)
    return ok
}
```

由於我們實作了 error 接口，只要是 Interface 就可以透過 [Type assertion][4] 來判斷此錯誤訊息是否為 `MyError`。

```go
package error

import "testing"

func TestIsMyError(t *testing.T) {
    err := MyError{"title", "message"}

    ok := IsMyError(err)

    if !ok {
        t.Fatal("error is not MyError")
    }

    if err.Error() != "title: message" {
        t.Fatal("message error")
    }
}
```

這樣在專案裡就可以實現多個錯誤訊息，寫測試時就可以直接判斷錯誤訊息為哪一種自訂格式。

## 結論

在 Go 裡面寫錯誤訊息真的很方便又很容易，動態訊息請自定，反之，固定訊息請直接宣告 const 就可以了。在寫套件給大家使用時，大部份都是使用固定訊息，如果是大型專案牽扯到資料庫時，通常會用動態自訂錯誤訊息比較多。

### 上述程式碼請參考[這裡][5]

 [1]: https://lh3.googleusercontent.com/jsocHCR9A9yEfDVUTrU0m42_aHhTEVDGW5p5PsQSx7GSlkt3gLjohfXH3S7P7p982332ruU_e-EtW0LwmiuZjvN65VIcyME-zE35C6EM0IV1nqY6KoNw3dwW2djjid3F-T5YgnJothA=w1920-h1080
 [2]: https://golang.org/
 [3]: https://github.com/stretchr/testify
 [4]: http://golang.org/doc/go_spec.html#Type_assertions
 [5]: https://github.com/go-training/training/tree/master/example04