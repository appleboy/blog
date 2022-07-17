---
title: "在 Go 語言測試使用 Setup 及 Teardown"
date: 2022-07-17T07:44:49+08:00
type: post
slug: setup-and-teardown-with-unit-testing-in-golang
share_img: https://i.imgur.com/FD5go1t.png
categories:
  - Golang
tags:
  - golang
  - testing
---

![logo](https://i.imgur.com/FD5go1t.png)

相信大家在寫測試時，都會需要啟動而外服務，像是 [Redis](https://redis.io/) 或 [Postgres](https://www.postgresql.org/) 等，而開始測試前會需要初始化資料庫連線，或者是準備測試資料，測試結束後就關閉資料庫連線，並且移除不必要的測試資料或檔案。在 [Go 語言][1]內開發者不用去依賴第三方的套件，透過內建的 `TestMain` 就可以非常輕鬆完成此事情。底下看看如何操作及使用。

[1]:https://go.dev

<!--more-->

## 整合 TestMain

Go 語言在測試套件內直接提供了 [TestMain][11] 函式，功能就是讓開發者可以再開始測試前準備服務 (setup) 或是測試結束後移除環境 (teardown)。底下看看正常執行的狀況

```go
func TestMain(m *testing.M) {
  // call flag.Parse() here if TestMain uses flags
  os.Exit(m.Run())
}
```

接著可以新增 setup() 及 teardown() 函式

```go
func setup() {
  // Do something here.
  fmt.Printf("\033[1;33m%s\033[0m", "> Setup completed\n")
}

func teardown() {
  // Do something here.
  fmt.Printf("\033[1;33m%s\033[0m", "> Teardown completed")
  fmt.Printf("\n")
}

func TestMain(m *testing.M) {
  setup()
  code := m.Run()
  teardown()
  os.Exit(code)
}
```

接著執行 `go test -v .` 可以看到底下結果

```sh
> Setup completed
testing: warning: no tests to run
PASS
> Teardown completed
ok      test    0.299s
```

這是符合我們的需求，可以在測試前準備服務或資料，結束後可以與服務正常斷線及移除資料

```go
func setup() {
  // initial worker
  queue.New(cfg.Worker.NumProcs, cfg.Worker.MaxQueue).Run()
  fmt.Printf("\033[1;33m%s\033[0m", "> Setup completed\n")
}

func teardown() {
  // initial worker
  queue.Realse()
  fmt.Printf("\033[1;33m%s\033[0m", "> Teardown completed")
  fmt.Printf("\n")
}
```

[11]: https://pkg.go.dev/testing#hdr-Main

## 單獨測試使用 Setup 及 Teardown

除了在整個測試前及測試後需要使用外，開發者也可能有需求在測試子項目 (sub-testing) 上。直接看底下範例，測試使用者是否存在

```go
func TestIsUserExist(t *testing.T) {
  assert.NoError(t, PrepareTestDatabase())
  type args struct {
    uid   int64
    email string
  }
  tests := []struct {
    name    string
    args    args
    want    bool
    wantErr bool
  }{
    {
      name:    "test email exist without login",
      args:    args{0, "test01@gmail.com"},
      want:    true,
      wantErr: false,
    },
    {
      name:    "test email not exist without login",
      args:    args{0, "test123456@gmail.com"},
      want:    false,
      wantErr: false,
    },
    {
      name:    "test email exist with login",
      args:    args{1, "test02@gmail.com"},
      want:    true,
      wantErr: false,
    },
    {
      name:    "test email not exist with login",
      args:    args{1, "test123456@gmail.com"},
      want:    false,
      wantErr: false,
    },
  }
  for _, tt := range tests {
    tt := tt
    t.Run(tt.name, func(t *testing.T) {
      got, err := IsUserExist(tt.args.uid, tt.args.email)
      if (err != nil) != tt.wantErr {
        t.Errorf("isUserExist() error = %v, wantErr %v", err, tt.wantErr)
        return
      }
      if got != tt.want {
        t.Errorf("isUserExist() = %v, want %v", got, tt.want)
      }
    })
  }
}
```

接著新增 setupTest 函式

```go
func setupTest(tb testing.TB) func(tb testing.TB) {
  fmt.Printf("\033[1;33m%s\033[0m", "> Setup Test\n")

  return func(tb testing.TB) {
    fmt.Printf("\033[1;33m%s\033[0m", "> Teardown Test\n")
  }
}
```

最後修改 `t.Run` 內容

```go
t.Run(tt.name, func(t *testing.T) {
  teardownTest := setupTest(t)
  defer teardownTest(t)
  got, err := IsUserExist(tt.args.uid, tt.args.email)
  if (err != nil) != tt.wantErr {
    t.Errorf("isUserExist() error = %v, wantErr %v", err, tt.wantErr)
    return
  }
  if got != tt.want {
    t.Errorf("isUserExist() = %v, want %v", got, tt.want)
  }
})
```

## 整合 TestMain + Teardown

我們來將上述的案例整合一起使用，先寫一個簡單的 ToString 功能

```go
package foobar

import "fmt"

// ToString convert any type to string
func ToString(value interface{}) string {
  if v, ok := value.(*string); ok {
    return *v
  }
  return fmt.Sprintf("%v", value)
}
```

接著寫測試

```go
package foobar

import (
  "fmt"
  "os"
  "reflect"
  "testing"
)

func setup() {
  // Do something here.
  fmt.Printf("\033[1;33m%s\033[0m", "> Setup completed\n")
}

func teardown() {
  // Do something here.
  fmt.Printf("\033[1;33m%s\033[0m", "> Teardown completed")
  fmt.Printf("\n")
}

func TestMain(m *testing.M) {
  setup()
  code := m.Run()
  teardown()
  os.Exit(code)
}

func setupTest(tb testing.TB) func(tb testing.TB) {
  fmt.Printf("\033[1;34m%s\033[0m", ">> Setup Test\n")

  return func(tb testing.TB) {
    fmt.Printf("\033[1;34m%s\033[0m", ">> Teardown Test\n")
  }
}

func TestToString(t *testing.T) {
  type args struct {
    value interface{}
  }
  tests := []struct {
    name string
    args args
    want interface{}
  }{
    {
      name: "int",
      args: args{
        value: 101,
      },
      want: "101",
    },
    {
      name: "int64",
      args: args{
        value: int64(100),
      },
      want: "100",
    },
    {
      name: "boolean",
      args: args{
        value: true,
      },
      want: "true",
    },
    {
      name: "float32",
      args: args{
        value: float32(23.03),
      },
      want: "23.03",
    },
  }
  for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
      teardown := setupTest(t)
      defer teardown(t)
      if got := ToString(tt.args.value); !reflect.DeepEqual(got, tt.want) {
        t.Errorf("ToString() = %v, want %v", got, tt.want)
      }
    })
  }
}
```

最後結果如下

```sh
$ go test -v .
> Setup completed
=== RUN   TestToString
=== RUN   TestToString/int
>> Setup Test
>> Teardown Test
=== RUN   TestToString/int64
>> Setup Test
>> Teardown Test
=== RUN   TestToString/boolean
>> Setup Test
>> Teardown Test
=== RUN   TestToString/float32
>> Setup Test
>> Teardown Test
--- PASS: TestToString (0.00s)
    --- PASS: TestToString/int (0.00s)
    --- PASS: TestToString/int64 (0.00s)
    --- PASS: TestToString/boolean (0.00s)
    --- PASS: TestToString/float32 (0.00s)
PASS
> Teardown completed
ok      test    0.293s
```

![Testing](https://i.imgur.com/QtV6Z1Y.png)
